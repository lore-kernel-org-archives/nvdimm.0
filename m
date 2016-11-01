Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BECC881D15
 for <linux-nvdimm@lists.01.org>; Tue,  1 Nov 2016 14:22:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/11] ext4: DAX iomap write support
Date: Tue,  1 Nov 2016 22:06:16 +0100
Message-Id: <1478034381-19037-7-git-send-email-jack@suse.cz>
In-Reply-To: <1478034381-19037-1-git-send-email-jack@suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Implement DAX writes using the new iomap infrastructure instead of
overloading the direct IO path.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c  | 39 ++++++++++++++++++++++--
 fs/ext4/inode.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 125 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 28ebc2418dc2..d7ab0e90d1b8 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -172,6 +172,39 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
 }
 
 static ssize_t
+ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+	bool overwrite = false;
+
+	inode_lock(inode);
+	ret = ext4_write_checks(iocb, from);
+	if (ret <= 0)
+		goto out;
+	ret = file_remove_privs(iocb->ki_filp);
+	if (ret)
+		goto out;
+	ret = file_update_time(iocb->ki_filp);
+	if (ret)
+		goto out;
+
+	if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
+		overwrite = true;
+		downgrade_write(&inode->i_rwsem);
+	}
+	ret = dax_iomap_rw(iocb, from, &ext4_iomap_ops);
+out:
+	if (!overwrite)
+		inode_unlock(inode);
+	else
+		inode_unlock_shared(inode);
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	return ret;
+}
+
+static ssize_t
 ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -180,6 +213,9 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	int overwrite = 0;
 	ssize_t ret;
 
+	if (IS_DAX(inode))
+		return ext4_dax_write_iter(iocb, from);
+
 	inode_lock(inode);
 	ret = ext4_write_checks(iocb, from);
 	if (ret <= 0)
@@ -199,8 +235,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	iocb->private = &overwrite;
 	/* Check whether we do a DIO overwrite or not */
-	if (((o_direct && !unaligned_aio) || IS_DAX(inode)) &&
-	    ext4_should_dioread_nolock(inode) &&
+	if ((o_direct && !unaligned_aio) && ext4_should_dioread_nolock(inode) &&
 	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
 		overwrite = 1;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ac26a390f14c..d07d003ebce2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3316,18 +3316,62 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	struct ext4_map_blocks map;
 	int ret;
 
-	if (flags & IOMAP_WRITE)
-		return -EIO;
-
 	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
 		return -ERANGE;
 
 	map.m_lblk = first_block;
 	map.m_len = last_block - first_block + 1;
 
-	ret = ext4_map_blocks(NULL, inode, &map, 0);
-	if (ret < 0)
-		return ret;
+	if (!(flags & IOMAP_WRITE)) {
+		ret = ext4_map_blocks(NULL, inode, &map, 0);
+	} else {
+		int dio_credits;
+		handle_t *handle;
+		int retries = 0;
+
+		/* Trim mapping request to maximum we can map at once for DIO */
+		if (map.m_len > DIO_MAX_BLOCKS)
+			map.m_len = DIO_MAX_BLOCKS;
+		dio_credits = ext4_chunk_trans_blocks(inode, map.m_len);
+retry:
+		/*
+		 * Either we allocate blocks and then we don't get unwritten
+		 * extent so we have reserved enough credits, or the blocks
+		 * are already allocated and unwritten and in that case
+		 * extent conversion fits in the credits as well.
+		 */
+		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
+					    dio_credits);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		ret = ext4_map_blocks(handle, inode, &map,
+				      EXT4_GET_BLOCKS_PRE_IO |
+				      EXT4_GET_BLOCKS_CREATE_ZERO);
+		if (ret < 0) {
+			ext4_journal_stop(handle);
+			if (ret == -ENOSPC &&
+			    ext4_should_retry_alloc(inode->i_sb, &retries))
+				goto retry;
+			return ret;
+		}
+		/* For DAX writes we need to zero out unwritten extents */
+		if (map.m_flags & EXT4_MAP_UNWRITTEN) {
+			/*
+			 * We are protected by i_mmap_sem or i_rwsem so we know
+			 * block cannot go away from under us even though we
+			 * dropped i_data_sem. Convert extent to written and
+			 * write zeros there.
+			 */
+			ret = ext4_map_blocks(handle, inode, &map,
+					      EXT4_GET_BLOCKS_CONVERT |
+					      EXT4_GET_BLOCKS_CREATE_ZERO);
+			if (ret < 0) {
+				ext4_journal_stop(handle);
+				return ret;
+			}
+		}
+	}
 
 	iomap->flags = 0;
 	iomap->bdev = inode->i_sb->s_bdev;
@@ -3355,8 +3399,46 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
+			  ssize_t written, unsigned flags, struct iomap *iomap)
+{
+	if (flags & IOMAP_WRITE) {
+		handle_t *handle = ext4_journal_current_handle();
+		ext4_lblk_t written_blk, end_blk;
+		int blkbits = inode->i_blkbits;
+		bool truncate = false;
+
+		if (ext4_update_inode_size(inode, offset + written))
+			ext4_mark_inode_dirty(handle, inode);
+		written_blk = (offset + written) >> blkbits;
+		end_blk = (offset + length) >> blkbits;
+		/*
+		 * We may need to truncate allocated but not written blocks
+		 * beyond EOF.
+		 */
+		if (written_blk < end_blk && offset + length > inode->i_size &&
+		    ext4_can_truncate(inode)) {
+			ext4_orphan_add(handle, inode);
+			truncate = true;
+		}
+		ext4_journal_stop(handle);
+		if (truncate) {
+			ext4_truncate_failed_write(inode);
+			/*
+			 * If truncate failed early the inode might still be
+			 * on the orphan list; we need to make sure the inode
+			 * is removed from the orphan list in that case.
+			 */
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+		}
+	}
+	return 0;
+}
+
 struct iomap_ops ext4_iomap_ops = {
 	.iomap_begin		= ext4_iomap_begin,
+	.iomap_end		= ext4_iomap_end,
 };
 
 #else
-- 
2.6.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
