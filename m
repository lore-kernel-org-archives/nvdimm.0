Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5A3021F0DB38
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 21:12:32 -0700 (PDT)
Subject: [PATCH v8 05/18] ext4, dax: introduce ext4_dax_aops
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:02:36 -0700
Message-ID: <152246895649.36038.5391043415273091960.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: jack@suse.cz, snitzer@redhat.com, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/inode.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c94780075b04..249a97b19181 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2725,12 +2725,6 @@ static int ext4_writepages(struct address_space *mapping,
 	percpu_down_read(&sbi->s_journal_flag_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
-	if (dax_mapping(mapping)) {
-		ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev,
-						  wbc);
-		goto out_writepages;
-	}
-
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
 	 * a transaction for special inodes like journal inode on last iput()
@@ -2955,6 +2949,27 @@ static int ext4_writepages(struct address_space *mapping,
 	return ret;
 }
 
+static int ext4_dax_writepages(struct address_space *mapping,
+			       struct writeback_control *wbc)
+{
+	int ret;
+	long nr_to_write = wbc->nr_to_write;
+	struct inode *inode = mapping->host;
+	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
+
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
+		return -EIO;
+
+	percpu_down_read(&sbi->s_journal_flag_rwsem);
+	trace_ext4_writepages(inode, wbc);
+
+	ret = dax_writeback_mapping_range(mapping, inode->i_sb->s_bdev, wbc);
+	trace_ext4_writepages_result(inode, wbc, ret,
+				     nr_to_write - wbc->nr_to_write);
+	percpu_up_read(&sbi->s_journal_flag_rwsem);
+	return ret;
+}
+
 static int ext4_nonda_switch(struct super_block *sb)
 {
 	s64 free_clusters, dirty_clusters;
@@ -3857,10 +3872,6 @@ static ssize_t ext4_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (ext4_has_inline_data(inode))
 		return 0;
 
-	/* DAX uses iomap path now */
-	if (WARN_ON_ONCE(IS_DAX(inode)))
-		return 0;
-
 	trace_ext4_direct_IO_enter(inode, offset, count, iov_iter_rw(iter));
 	if (iov_iter_rw(iter) == READ)
 		ret = ext4_direct_IO_read(iocb, iter);
@@ -3946,6 +3957,13 @@ static const struct address_space_operations ext4_da_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
+static const struct address_space_operations ext4_dax_aops = {
+	.writepages		= ext4_dax_writepages,
+	.direct_IO		= noop_direct_IO,
+	.set_page_dirty		= noop_set_page_dirty,
+	.invalidatepage		= noop_invalidatepage,
+};
+
 void ext4_set_aops(struct inode *inode)
 {
 	switch (ext4_inode_journal_mode(inode)) {
@@ -3958,7 +3976,9 @@ void ext4_set_aops(struct inode *inode)
 	default:
 		BUG();
 	}
-	if (test_opt(inode->i_sb, DELALLOC))
+	if (IS_DAX(inode))
+		inode->i_mapping->a_ops = &ext4_dax_aops;
+	else if (test_opt(inode->i_sb, DELALLOC))
 		inode->i_mapping->a_ops = &ext4_da_aops;
 	else
 		inode->i_mapping->a_ops = &ext4_aops;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
