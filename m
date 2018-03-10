Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B500E22646318
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:23 -0800 (PST)
Received: by mail-pf0-x243.google.com with SMTP id q13so2624449pff.0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:42 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 71/83] Symlink support.
Date: Sat, 10 Mar 2018 10:18:52 -0800
Message-Id: <1520705944-6723-72-git-send-email-jix024@eng.ucsd.edu>
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

NOVA alloates two blocks for symlink inode: One for inode log,
and the other one is a data block, storing symname.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile  |   2 +-
 fs/nova/inode.c   |   2 +
 fs/nova/namei.c   |  70 ++++++++++++++++++++++++++++
 fs/nova/nova.h    |   5 ++
 fs/nova/symlink.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 211 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/symlink.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 7f851f2..7bf6403 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_NOVA_FS) += nova.o
 
 nova-y := balloc.o bbuild.o dax.o dir.o file.o inode.o journal.o log.o namei.o\
-	  rebuild.o stats.o super.o
+	  rebuild.o stats.o super.o symlink.o
diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index a6d74cb..21be31a 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -285,6 +285,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 		inode->i_fop = &nova_dir_operations;
 		break;
 	case S_IFLNK:
+		inode->i_op = &nova_symlink_inode_operations;
 		break;
 	default:
 		inode->i_op = &nova_special_inode_operations;
@@ -983,6 +984,7 @@ struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 		inode->i_op = &nova_special_inode_operations;
 		break;
 	case TYPE_SYMLINK:
+		inode->i_op = &nova_symlink_inode_operations;
 		inode->i_mapping->a_ops = &nova_aops_dax;
 		break;
 	case TYPE_MKDIR:
diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index 7a81672..58f6a72 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -207,6 +207,75 @@ static int nova_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
+static int nova_symlink(struct inode *dir, struct dentry *dentry,
+	const char *symname)
+{
+	struct super_block *sb = dir->i_sb;
+	int err = -ENAMETOOLONG;
+	unsigned int len = strlen(symname);
+	struct inode *inode;
+	struct nova_inode_info *si;
+	struct nova_inode_info_header *sih;
+	u64 pi_addr = 0;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 ino;
+	u64 epoch_id;
+	timing_t symlink_time;
+
+	NOVA_START_TIMING(symlink_t, symlink_time);
+	if (len + 1 > sb->s_blocksize)
+		goto out;
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_fail;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_fail;
+
+	nova_dbgv("%s: name %s, symname %s\n", __func__,
+				dentry->d_name.name, symname);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+
+	update.tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_fail;
+
+	inode = nova_new_vfs_inode(TYPE_SYMLINK, dir, pi_addr, ino,
+					S_IFLNK|0777, len, 0,
+					&dentry->d_name, epoch_id);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_fail;
+	}
+
+	pi = nova_get_inode(sb, inode);
+
+	si = NOVA_I(inode);
+	sih = &si->header;
+
+	err = nova_block_symlink(sb, pi, inode, symname, len, epoch_id);
+	if (err)
+		goto out_fail;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+					&update);
+out:
+	NOVA_END_TIMING(symlink_t, symlink_time);
+	return err;
+
+out_fail:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	goto out;
+}
+
 static void nova_lite_transaction_for_time_and_link(struct super_block *sb,
 	struct nova_inode *pi, struct nova_inode *pidir, struct inode *inode,
 	struct inode *dir, struct nova_inode_update *update,
@@ -764,6 +833,7 @@ const struct inode_operations nova_dir_inode_operations = {
 	.lookup		= nova_lookup,
 	.link		= nova_link,
 	.unlink		= nova_unlink,
+	.symlink	= nova_symlink,
 	.mkdir		= nova_mkdir,
 	.rmdir		= nova_rmdir,
 	.mknod		= nova_mknod,
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 40c70da..6392bb3 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -518,6 +518,11 @@ int nova_rebuild_dir_inode_tree(struct super_block *sb,
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 	u64 ino, u64 pi_addr, int rebuild_dir);
 
+/* symlink.c */
+int nova_block_symlink(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, const char *symname, int len, u64 epoch_id);
+extern const struct inode_operations nova_symlink_inode_operations;
+
 /* stats.c */
 void nova_get_timing_stats(void);
 void nova_get_IO_stats(void);
diff --git a/fs/nova/symlink.c b/fs/nova/symlink.c
new file mode 100644
index 0000000..dbd57c5
--- /dev/null
+++ b/fs/nova/symlink.c
@@ -0,0 +1,133 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Symlink operations
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/version.h>
+#include "nova.h"
+#include "inode.h"
+
+int nova_block_symlink(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, const char *symname, int len, u64 epoch_id)
+{
+	struct nova_file_write_item entry_item;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode_update update;
+	unsigned long name_blocknr = 0;
+	int allocated;
+	u64 block;
+	char *blockp;
+	u32 time;
+	int ret;
+
+	update.tail = sih->log_tail;
+
+	allocated = nova_new_data_blocks(sb, sih, &name_blocknr, 0, 1,
+				 ALLOC_INIT_ZERO, ANY_CPU, ALLOC_FROM_TAIL);
+	if (allocated != 1 || name_blocknr == 0) {
+		ret = allocated;
+		return ret;
+	}
+
+	/* First copy name to name block */
+	block = nova_get_block_off(sb, name_blocknr, NOVA_BLOCK_TYPE_4K);
+	blockp = (char *)nova_get_block(sb, block);
+
+	memcpy_to_pmem_nocache(blockp, symname, len);
+	blockp[len] = '\0';
+
+	/* Apply a write entry to the log page */
+	time = current_time(inode).tv_sec;
+	nova_init_file_write_item(sb, sih, &entry_item, epoch_id, 0, 1,
+					name_blocknr, time, len + 1);
+
+	sih_lock(sih);
+	ret = nova_append_file_write_entry(sb, pi, inode, &entry_item, &update);
+	if (ret) {
+		nova_dbg("%s: append file write entry failed %d\n",
+					__func__, ret);
+		nova_free_data_blocks(sb, sih, name_blocknr, 1);
+		return ret;
+	}
+
+	nova_update_inode(sb, inode, pi, &update);
+	sih->trans_id++;
+	sih_unlock(sih);
+
+	return 0;
+}
+
+/* FIXME: Temporary workaround */
+static int nova_readlink_copy(char __user *buffer, int buflen, const char *link)
+{
+	int len = PTR_ERR(link);
+
+	if (IS_ERR(link))
+		goto out;
+
+	len = strlen(link);
+	if (len > (unsigned int) buflen)
+		len = buflen;
+	if (copy_to_user(buffer, link, len))
+		len = -EFAULT;
+out:
+	return len;
+}
+
+static int nova_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+{
+	struct nova_file_write_entry *entry;
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	char *blockp;
+
+	entry = (struct nova_file_write_entry *)nova_get_block(sb,
+							sih->log_head);
+
+	blockp = (char *)nova_get_block(sb, BLOCK_OFF(entry->block));
+
+	return nova_readlink_copy(buffer, buflen, blockp);
+}
+
+static const char *nova_get_link(struct dentry *dentry, struct inode *inode,
+	struct delayed_call *done)
+{
+	struct nova_file_write_entry *entry;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	char *blockp;
+
+	entry = (struct nova_file_write_entry *)nova_get_block(sb,
+							sih->log_head);
+
+	blockp = (char *)nova_get_block(sb, BLOCK_OFF(entry->block));
+
+	return blockp;
+}
+
+const struct inode_operations nova_symlink_inode_operations = {
+	.readlink	= nova_readlink,
+	.get_link	= nova_get_link,
+	.setattr	= nova_notify_change,
+};
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
