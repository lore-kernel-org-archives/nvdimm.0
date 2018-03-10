Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACC722263149B
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:01 -0800 (PST)
Received: by mail-pl0-x244.google.com with SMTP id 9-v6so7020007ple.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:20 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 53/83] Namei: lookup.
Date: Sat, 10 Mar 2018 10:18:34 -0800
Message-Id: <1520705944-6723-54-git-send-email-jix024@eng.ucsd.edu>
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

NOVA lookup the inode number by searching the radix tree with
the filename hash value and locating the corresponding dentry on the log.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |  3 +-
 fs/nova/inode.c  |  2 ++
 fs/nova/namei.c  | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h   |  4 +++
 4 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/namei.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 3a3243c..eb97e46 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o dir.o inode.o journal.o log.o rebuild.o stats.o super.o
+nova-y := balloc.o bbuild.o dir.o inode.o journal.o log.o namei.o\
+	  rebuild.o stats.o super.o
diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 17addd3..2d3f7a3 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -181,6 +181,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	case S_IFREG:
 		break;
 	case S_IFDIR:
+		inode->i_op = &nova_dir_inode_operations;
 		inode->i_fop = &nova_dir_operations;
 		break;
 	case S_IFLNK:
@@ -881,6 +882,7 @@ struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 		inode->i_mapping->a_ops = &nova_aops_dax;
 		break;
 	case TYPE_MKDIR:
+		inode->i_op = &nova_dir_inode_operations;
 		inode->i_fop = &nova_dir_operations;
 		inode->i_mapping->a_ops = &nova_aops_dax;
 		set_nlink(inode, 2);
diff --git a/fs/nova/namei.c b/fs/nova/namei.c
new file mode 100644
index 0000000..8076f5b
--- /dev/null
+++ b/fs/nova/namei.c
@@ -0,0 +1,97 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Inode operations for directories.
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
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "nova.h"
+#include "journal.h"
+#include "inode.h"
+
+static ino_t nova_inode_by_name(struct inode *dir, struct qstr *entry,
+				 struct nova_dentry **res_entry)
+{
+	struct super_block *sb = dir->i_sb;
+	struct nova_dentry *direntry;
+
+	direntry = nova_find_dentry(sb, NULL, dir,
+					entry->name, entry->len);
+	if (direntry == NULL)
+		return 0;
+
+	*res_entry = direntry;
+	return direntry->ino;
+}
+
+static struct dentry *nova_lookup(struct inode *dir, struct dentry *dentry,
+				   unsigned int flags)
+{
+	struct inode *inode = NULL;
+	struct nova_dentry *de;
+	ino_t ino;
+	timing_t lookup_time;
+
+	NOVA_START_TIMING(lookup_t, lookup_time);
+	if (dentry->d_name.len > NOVA_NAME_LEN) {
+		nova_dbg("%s: namelen %u exceeds limit\n",
+			__func__, dentry->d_name.len);
+		return ERR_PTR(-ENAMETOOLONG);
+	}
+
+	nova_dbg_verbose("%s: %s\n", __func__, dentry->d_name.name);
+	ino = nova_inode_by_name(dir, &dentry->d_name, &de);
+	nova_dbg_verbose("%s: ino %lu\n", __func__, ino);
+	if (ino) {
+		inode = nova_iget(dir->i_sb, ino);
+		if (inode == ERR_PTR(-ESTALE) || inode == ERR_PTR(-ENOMEM)
+				|| inode == ERR_PTR(-EACCES)) {
+			nova_err(dir->i_sb,
+				  "%s: get inode failed: %lu\n",
+				  __func__, (unsigned long)ino);
+			return ERR_PTR(-EIO);
+		}
+	}
+
+	NOVA_END_TIMING(lookup_t, lookup_time);
+	return d_splice_alias(inode, dentry);
+}
+
+struct dentry *nova_get_parent(struct dentry *child)
+{
+	struct inode *inode;
+	struct qstr dotdot = QSTR_INIT("..", 2);
+	struct nova_dentry *de = NULL;
+	ino_t ino;
+
+	nova_inode_by_name(child->d_inode, &dotdot, &de);
+	if (!de)
+		return ERR_PTR(-ENOENT);
+
+	/* FIXME: can de->ino be avoided by using the return value of
+	 * nova_inode_by_name()?
+	 */
+	ino = le64_to_cpu(de->ino);
+
+	if (ino)
+		inode = nova_iget(child->d_inode->i_sb, ino);
+	else
+		return ERR_PTR(-ENOENT);
+
+	return d_obtain_alias(inode);
+}
+
+const struct inode_operations nova_dir_inode_operations = {
+	.lookup		= nova_lookup,
+};
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 983c6b2..03ea0bd 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -484,6 +484,10 @@ int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
 int nova_remove_dentry(struct dentry *dentry, int dec_link,
 	struct nova_inode_update *update, u64 epoch_id);
 
+/* namei.c */
+extern const struct inode_operations nova_dir_inode_operations;
+extern struct dentry *nova_get_parent(struct dentry *child);
+
 /* rebuild.c */
 int nova_rebuild_dir_inode_tree(struct super_block *sb,
 	struct nova_inode *pi, u64 pi_addr,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
