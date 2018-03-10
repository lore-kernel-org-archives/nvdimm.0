Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD78A22646306
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:13 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id m19so4837896pgn.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:32 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 63/83] File operation: llseek.
Date: Sat, 10 Mar 2018 10:18:44 -0800
Message-Id: <1520705944-6723-64-git-send-email-jix024@eng.ucsd.edu>
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

Search the file radix tree to find hold or data.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/file.c  |  47 +++++++++++++++++++++++
 fs/nova/inode.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/inode.h |   1 +
 fs/nova/nova.h  |   1 +
 4 files changed, 162 insertions(+)

diff --git a/fs/nova/file.c b/fs/nova/file.c
index b46d4bd..ecaf20a 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -23,6 +23,53 @@
 #include "nova.h"
 #include "inode.h"
 
+static loff_t nova_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	int retval;
+
+	if (origin != SEEK_DATA && origin != SEEK_HOLE)
+		return generic_file_llseek(file, offset, origin);
+
+	sih_lock_shared(sih);
+	switch (origin) {
+	case SEEK_DATA:
+		retval = nova_find_region(inode, &offset, 0);
+		if (retval) {
+			sih_unlock_shared(sih);
+			return retval;
+		}
+		break;
+	case SEEK_HOLE:
+		retval = nova_find_region(inode, &offset, 1);
+		if (retval) {
+			sih_unlock_shared(sih);
+			return retval;
+		}
+		break;
+	}
+
+	if ((offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) ||
+	    offset > inode->i_sb->s_maxbytes) {
+		sih_unlock_shared(sih);
+		return -ENXIO;
+	}
+
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+
+	sih_unlock_shared(sih);
+	return offset;
+}
+
+
+const struct file_operations nova_dax_file_operations = {
+	.llseek		= nova_llseek,
+};
 
 const struct inode_operations nova_file_inode_operations = {
 	.setattr	= nova_notify_change,
diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 6fcc5e7..a6d74cb 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -193,6 +193,52 @@ static void nova_truncate_file_blocks(struct inode *inode, loff_t start,
 
 }
 
+/* search the radix tree to find hole or data
+ * in the specified range
+ * Input:
+ * first_blocknr: first block in the specified range
+ * last_blocknr: last_blocknr in the specified range
+ * @data_found: indicates whether data blocks were found
+ * @hole_found: indicates whether a hole was found
+ * hole: whether we are looking for a hole or data
+ */
+static int nova_lookup_hole_in_range(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	unsigned long first_blocknr, unsigned long last_blocknr,
+	int *data_found, int *hole_found, int hole)
+{
+	struct nova_file_write_entry *entry;
+	unsigned long blocks = 0;
+	unsigned long pgoff, old_pgoff;
+
+	pgoff = first_blocknr;
+	while (pgoff <= last_blocknr) {
+		old_pgoff = pgoff;
+		entry = radix_tree_lookup(&sih->tree, pgoff);
+		if (entry) {
+			*data_found = 1;
+			if (!hole)
+				goto done;
+			pgoff++;
+		} else {
+			*hole_found = 1;
+			entry = nova_find_next_entry(sb, sih, pgoff);
+			pgoff++;
+			if (entry) {
+				pgoff = pgoff > entry->pgoff ?
+					pgoff : entry->pgoff;
+				if (pgoff > last_blocknr)
+					pgoff = last_blocknr + 1;
+			}
+		}
+
+		if (!*hole_found || !hole)
+			blocks += pgoff - old_pgoff;
+	}
+done:
+	return blocks;
+}
+
 /* copy persistent state to struct inode */
 static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	u64 pi_addr)
@@ -232,6 +278,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &nova_file_inode_operations;
+		inode->i_fop = &nova_dax_file_operations;
 		break;
 	case S_IFDIR:
 		inode->i_op = &nova_dir_inode_operations;
@@ -929,6 +976,7 @@ struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 	case TYPE_CREATE:
 		inode->i_op = &nova_file_inode_operations;
 		inode->i_mapping->a_ops = &nova_aops_dax;
+		inode->i_fop = &nova_dax_file_operations;
 		break;
 	case TYPE_MKNOD:
 		init_special_inode(inode, mode, rdev);
@@ -1170,6 +1218,71 @@ int nova_notify_change(struct dentry *dentry, struct iattr *attr)
 	return ret;
 }
 
+/*
+ * find the file offset for SEEK_DATA/SEEK_HOLE
+ */
+unsigned long nova_find_region(struct inode *inode, loff_t *offset, int hole)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	unsigned long first_blocknr, last_blocknr;
+	unsigned long blocks = 0, offset_in_block;
+	int data_found = 0, hole_found = 0;
+
+	if (*offset >= inode->i_size)
+		return -ENXIO;
+
+	if (!inode->i_blocks || !sih->i_size) {
+		if (hole)
+			return inode->i_size;
+		else
+			return -ENXIO;
+	}
+
+	offset_in_block = *offset & ((1UL << data_bits) - 1);
+
+	first_blocknr = *offset >> data_bits;
+	last_blocknr = inode->i_size >> data_bits;
+
+	nova_dbgv("find_region offset %llx, first_blocknr %lx, last_blocknr %lx hole %d\n",
+		  *offset, first_blocknr, last_blocknr, hole);
+
+	blocks = nova_lookup_hole_in_range(inode->i_sb, sih,
+		first_blocknr, last_blocknr, &data_found, &hole_found, hole);
+
+	/* Searching data but only hole found till the end */
+	if (!hole && !data_found && hole_found)
+		return -ENXIO;
+
+	if (data_found && !hole_found) {
+		/* Searching data but we are already into them */
+		if (hole)
+			/* Searching hole but only data found, go to the end */
+			*offset = inode->i_size;
+		return 0;
+	}
+
+	/* Searching for hole, hole found and starting inside an hole */
+	if (hole && hole_found && !blocks) {
+		/* we found data after it */
+		if (!data_found)
+			/* last hole */
+			*offset = inode->i_size;
+		return 0;
+	}
+
+	if (offset_in_block) {
+		blocks--;
+		*offset += (blocks << data_bits) +
+			   ((1 << data_bits) - offset_in_block);
+	} else {
+		*offset += blocks << data_bits;
+	}
+
+	return 0;
+}
+
 static ssize_t nova_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	/* DAX does not support direct IO */
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 48403cf..693aa90 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -264,6 +264,7 @@ int nova_delete_file_tree(struct super_block *sb,
 	struct nova_inode_info_header *sih, unsigned long start_blocknr,
 	unsigned long last_blocknr, bool delete_nvmm, bool delete_dead,
 	u64 epoch_id);
+unsigned long nova_find_region(struct inode *inode, loff_t *offset, int hole);
 extern void nova_evict_inode(struct inode *inode);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 601e082..b2831f6 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -485,6 +485,7 @@ int nova_remove_dentry(struct dentry *dentry, int dec_link,
 	struct nova_inode_update *update, u64 epoch_id);
 
 /* file.c */
+extern const struct file_operations nova_dax_file_operations;
 extern const struct inode_operations nova_file_inode_operations;
 
 /* namei.c */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
