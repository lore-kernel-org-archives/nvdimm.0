Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B453226462E9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:12 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id l4so4832135pgp.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:31 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 62/83] File: getattr and file inode operations
Date: Sat, 10 Mar 2018 10:18:43 -0800
Message-Id: <1520705944-6723-63-git-send-email-jix024@eng.ucsd.edu>
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

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |  2 +-
 fs/nova/file.c   | 31 +++++++++++++++++++++++++++++++
 fs/nova/inode.c  | 25 +++++++++++++++++++++++++
 fs/nova/inode.h  |  2 ++
 fs/nova/nova.h   |  3 +++
 5 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/file.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index eb97e46..468ed6f 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o dir.o inode.o journal.o log.o namei.o\
+nova-y := balloc.o bbuild.o dir.o file.o inode.o journal.o log.o namei.o\
 	  rebuild.o stats.o super.o
diff --git a/fs/nova/file.c b/fs/nova/file.c
new file mode 100644
index 0000000..b46d4bd
--- /dev/null
+++ b/fs/nova/file.c
@@ -0,0 +1,31 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * File operations for files.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ * Copyright 2003 Sony Corporation
+ * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
+ * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/slab.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/falloc.h>
+#include <asm/mman.h>
+#include "nova.h"
+#include "inode.h"
+
+
+const struct inode_operations nova_file_inode_operations = {
+	.setattr	= nova_notify_change,
+	.getattr	= nova_getattr,
+	.get_acl	= NULL,
+};
diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 0e9ab4b..6fcc5e7 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -231,6 +231,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
+		inode->i_op = &nova_file_inode_operations;
 		break;
 	case S_IFDIR:
 		inode->i_op = &nova_dir_inode_operations;
@@ -926,6 +927,7 @@ struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 
 	switch (type) {
 	case TYPE_CREATE:
+		inode->i_op = &nova_file_inode_operations;
 		inode->i_mapping->a_ops = &nova_aops_dax;
 		break;
 	case TYPE_MKNOD:
@@ -1089,6 +1091,29 @@ static void nova_setsize(struct inode *inode, loff_t oldsize, loff_t newsize,
 	NOVA_END_TIMING(setsize_t, setsize_time);
 }
 
+int nova_getattr(const struct path *path, struct kstat *stat,
+		 u32 request_mask, unsigned int query_flags)
+{
+	struct inode *inode = d_inode(path->dentry);
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	unsigned int flags = sih->i_flags;
+
+	if (flags & FS_APPEND_FL)
+		stat->attributes |= STATX_ATTR_APPEND;
+	if (flags & FS_COMPR_FL)
+		stat->attributes |= STATX_ATTR_COMPRESSED;
+	if (flags & FS_IMMUTABLE_FL)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (flags & FS_NODUMP_FL)
+		stat->attributes |= STATX_ATTR_NODUMP;
+
+	generic_fillattr(inode, stat);
+	/* stat->blocks should be the number of 512B blocks */
+	stat->blocks = (inode->i_blocks << inode->i_sb->s_blocksize_bits) >> 9;
+	return 0;
+}
+
 int nova_notify_change(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 4ddf8c2..48403cf 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -267,6 +267,8 @@ int nova_delete_file_tree(struct super_block *sb,
 extern void nova_evict_inode(struct inode *inode);
 extern int nova_write_inode(struct inode *inode, struct writeback_control *wbc);
 extern void nova_dirty_inode(struct inode *inode, int flags);
+extern int nova_getattr(const struct path *path, struct kstat *stat,
+		 u32 request_mask, unsigned int query_flags);
 extern int nova_notify_change(struct dentry *dentry, struct iattr *attr);
 
 #endif
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 85292d3..601e082 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -484,6 +484,9 @@ int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
 int nova_remove_dentry(struct dentry *dentry, int dec_link,
 	struct nova_inode_update *update, u64 epoch_id);
 
+/* file.c */
+extern const struct inode_operations nova_file_inode_operations;
+
 /* namei.c */
 extern const struct inode_operations nova_dir_inode_operations;
 extern const struct inode_operations nova_special_inode_operations;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
