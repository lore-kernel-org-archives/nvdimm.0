Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E46DD226462E5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:08 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id f23-v6so7024355plr.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:27 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 59/83] Namei: setattr
Date: Sat, 10 Mar 2018 10:18:40 -0800
Message-Id: <1520705944-6723-60-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

Add notify_change for setattr operations. Truncate the file blocks
if the file is shrunk.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 180 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/inode.h |   1 +
 fs/nova/namei.c |   2 +
 3 files changed, 183 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 2d3f7a3..2092a55 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -141,6 +141,58 @@ void nova_set_inode_flags(struct inode *inode, struct nova_inode *pi,
 	inode->i_flags |= S_DAX;
 }
 
+static inline void check_eof_blocks(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode,
+	struct nova_inode_info_header *sih)
+{
+	if ((pi->i_flags & cpu_to_le32(NOVA_EOFBLOCKS_FL)) &&
+		(inode->i_size + sb->s_blocksize) > (sih->i_blocks
+			<< sb->s_blocksize_bits)) {
+		pi->i_flags &= cpu_to_le32(~NOVA_EOFBLOCKS_FL);
+		nova_persist_inode(pi);
+	}
+}
+
+/*
+ * Free data blocks from inode in the range start <=> end
+ */
+static void nova_truncate_file_blocks(struct inode *inode, loff_t start,
+				    loff_t end, u64 epoch_id)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	unsigned long first_blocknr, last_blocknr;
+	int freed = 0;
+
+	inode->i_mtime = inode->i_ctime = current_time(inode);
+
+	nova_dbg_verbose("truncate: pi %p iblocks %lx %llx %llx %llx\n", pi,
+			 sih->i_blocks, start, end, pi->i_size);
+
+	first_blocknr = (start + (1UL << data_bits) - 1) >> data_bits;
+
+	if (end == 0)
+		return;
+	last_blocknr = (end - 1) >> data_bits;
+
+	if (first_blocknr > last_blocknr)
+		return;
+
+	freed = nova_delete_file_tree(sb, sih, first_blocknr,
+				last_blocknr, true, false, epoch_id);
+
+	inode->i_blocks -= (freed * (1 << (data_bits -
+				sb->s_blocksize_bits)));
+
+	sih->i_blocks = inode->i_blocks;
+	/* Check for the flag EOFBLOCKS is still valid after the set size */
+	check_eof_blocks(sb, pi, inode, sih);
+
+}
+
 /* copy persistent state to struct inode */
 static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	u64 pi_addr)
@@ -963,6 +1015,134 @@ void nova_dirty_inode(struct inode *inode, int flags)
 	nova_flush_buffer(&pi->i_atime, sizeof(pi->i_atime), 0);
 }
 
+/*
+ * Zero the tail page. Used in resize request
+ * to avoid to keep data in case the file grows again.
+ */
+static void nova_clear_last_page_tail(struct super_block *sb,
+	struct inode *inode, loff_t newsize)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned long offset = newsize & (sb->s_blocksize - 1);
+	unsigned long pgoff, length;
+	u64 nvmm;
+	char *nvmm_addr;
+
+	if (offset == 0 || newsize > inode->i_size)
+		return;
+
+	length = sb->s_blocksize - offset;
+	pgoff = newsize >> sb->s_blocksize_bits;
+
+	nvmm = nova_find_nvmm_block(sb, sih, NULL, pgoff);
+	if (nvmm == 0)
+		return;
+
+	nvmm_addr = (char *)nova_get_block(sb, nvmm);
+	memcpy_to_pmem_nocache(nvmm_addr + offset, sbi->zeroed_page, length);
+}
+
+static void nova_setsize(struct inode *inode, loff_t oldsize, loff_t newsize,
+	u64 epoch_id)
+{
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	timing_t setsize_time;
+
+	/* We only support truncate regular file */
+	if (!(S_ISREG(inode->i_mode))) {
+		nova_err(inode->i_sb, "%s:wrong file mode %x\n", inode->i_mode);
+		return;
+	}
+
+	NOVA_START_TIMING(setsize_t, setsize_time);
+
+	inode_dio_wait(inode);
+
+	nova_dbgv("%s: inode %lu, old size %llu, new size %llu\n",
+		__func__, inode->i_ino, oldsize, newsize);
+
+	sih_lock(sih);
+	if (newsize != oldsize) {
+		nova_clear_last_page_tail(sb, inode, newsize);
+		i_size_write(inode, newsize);
+		sih->i_size = newsize;
+	}
+
+	/* FIXME: we should make sure that there is nobody reading the inode
+	 * before truncating it. Also we need to munmap the truncated range
+	 * from application address space, if mmapped.
+	 */
+	/* synchronize_rcu(); */
+
+	/* FIXME: Do we need to clear truncated DAX pages? */
+//	dax_truncate_page(inode, newsize, nova_dax_get_block);
+
+	truncate_pagecache(inode, newsize);
+	nova_truncate_file_blocks(inode, newsize, oldsize, epoch_id);
+	sih_unlock(sih);
+	NOVA_END_TIMING(setsize_t, setsize_time);
+}
+
+int nova_notify_change(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	int ret;
+	unsigned int ia_valid = attr->ia_valid, attr_mask;
+	loff_t oldsize = inode->i_size;
+	u64 epoch_id;
+	timing_t setattr_time;
+
+	NOVA_START_TIMING(setattr_t, setattr_time);
+	if (!pi) {
+		ret = -EACCES;
+		goto out;
+	}
+
+	ret = setattr_prepare(dentry, attr);
+	if (ret)
+		goto out;
+
+	/* Update inode with attr except for size */
+	setattr_copy(inode, attr);
+
+	epoch_id = nova_get_epoch_id(sb);
+
+	attr_mask = ATTR_MODE | ATTR_UID | ATTR_GID | ATTR_SIZE | ATTR_ATIME
+			| ATTR_MTIME | ATTR_CTIME;
+
+	ia_valid = ia_valid & attr_mask;
+
+	if (ia_valid == 0)
+		goto out;
+
+	ret = nova_handle_setattr_operation(sb, inode, pi, ia_valid,
+					attr, epoch_id);
+	if (ret)
+		goto out;
+
+	/* Only after log entry is committed, we can truncate size */
+	if ((ia_valid & ATTR_SIZE) && (attr->ia_size != oldsize ||
+			pi->i_flags & cpu_to_le32(NOVA_EOFBLOCKS_FL))) {
+//		nova_set_blocksize_hint(sb, inode, pi, attr->ia_size);
+
+		/* now we can freely truncate the inode */
+		nova_setsize(inode, oldsize, attr->ia_size, epoch_id);
+	}
+
+	sih->trans_id++;
+out:
+	NOVA_END_TIMING(setattr_t, setattr_time);
+	return ret;
+}
+
 static ssize_t nova_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	/* DAX does not support direct IO */
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 42690e6..4ddf8c2 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -267,5 +267,6 @@ int nova_delete_file_tree(struct super_block *sb,
 extern void nova_evict_inode(struct inode *inode);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
+extern int nova_notify_change(struct dentry *dentry, struct iattr *attr);
 
 #endif
diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index bb50c0a..1966bff 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -768,4 +768,6 @@ const struct inode_operations nova_dir_inode_operations = {
 	.rmdir		= nova_rmdir,
 	.mknod		= nova_mknod,
 	.rename		= nova_rename,
+	.setattr	= nova_notify_change,
+	.get_acl	= NULL,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
