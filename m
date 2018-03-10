Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43B3822631464
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:53 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id g12so4844474pgs.0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:12 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 46/83] Dir: Add Directory radix tree insert/remove methods.
Date: Sat, 10 Mar 2018 10:18:27 -0800
Message-Id: <1520705944-6723-47-git-send-email-jix024@eng.ucsd.edu>
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

NOVA uses Hash to quickly locate dentry in the directory inode log.
The key is the hash of the filename, the value is the dentry.

Currently hash collision is ignored, and the radix tree may occupy
large memory space with huge directories. Considering replacing
it in the future.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |   2 +-
 fs/nova/dir.c    | 141 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h   |  26 ++++++++++
 3 files changed, 168 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/dir.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 4aeadea..3a3243c 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o inode.o journal.o log.o rebuild.o stats.o super.o
+nova-y := balloc.o bbuild.o dir.o inode.o journal.o log.o rebuild.o stats.o super.o
diff --git a/fs/nova/dir.c b/fs/nova/dir.c
new file mode 100644
index 0000000..5bea57a
--- /dev/null
+++ b/fs/nova/dir.c
@@ -0,0 +1,141 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * File operations for directories.
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
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include "nova.h"
+#include "inode.h"
+
+#define DT2IF(dt) (((dt) << 12) & S_IFMT)
+#define IF2DT(sif) (((sif) & S_IFMT) >> 12)
+
+struct nova_dentry *nova_find_dentry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode, const char *name,
+	unsigned long name_len)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_dentry *direntry;
+	unsigned long hash;
+
+	hash = BKDRHash(name, name_len);
+	direntry = radix_tree_lookup(&sih->tree, hash);
+
+	return direntry;
+}
+
+int nova_insert_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name,
+	int namelen, struct nova_dentry *direntry)
+{
+	unsigned long hash;
+	int ret;
+
+	hash = BKDRHash(name, namelen);
+	nova_dbgv("%s: insert %s hash %lu\n", __func__, name, hash);
+
+	/* FIXME: hash collision ignored here */
+	ret = radix_tree_insert(&sih->tree, hash, direntry);
+	if (ret)
+		nova_dbg("%s ERROR %d: %s\n", __func__, ret, name);
+
+	return ret;
+}
+
+static int nova_check_dentry_match(struct super_block *sb,
+	struct nova_dentry *dentry, const char *name, int namelen)
+{
+	if (dentry->name_len != namelen)
+		return -EINVAL;
+
+	return strncmp(dentry->name, name, namelen);
+}
+
+int nova_remove_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name, int namelen,
+	int replay, struct nova_dentry **create_dentry)
+{
+	struct nova_dentry *entry;
+	unsigned long hash;
+
+	hash = BKDRHash(name, namelen);
+	entry = radix_tree_delete(&sih->tree, hash);
+
+	if (replay == 0) {
+		if (!entry) {
+			nova_dbg("%s ERROR: %s, length %d, hash %lu\n",
+					__func__, name, namelen, hash);
+			return -EINVAL;
+		}
+
+		if (entry->ino == 0 || entry->invalid ||
+		    nova_check_dentry_match(sb, entry, name, namelen)) {
+			nova_dbg("%s dentry not match: %s, length %d, hash %lu\n",
+				 __func__, name, namelen, hash);
+			/* for debug information, still allow access to nvmm */
+			nova_dbg("dentry: type %d, inode %llu, name %s, namelen %u, rec len %u\n",
+				 entry->entry_type, le64_to_cpu(entry->ino),
+				 entry->name, entry->name_len,
+				 le16_to_cpu(entry->de_len));
+			return -EINVAL;
+		}
+
+		if (create_dentry)
+			*create_dentry = entry;
+	}
+
+	return 0;
+}
+
+void nova_delete_dir_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_dentry *direntry;
+	unsigned long pos = 0;
+	struct nova_dentry *entries[FREE_BATCH];
+	timing_t delete_time;
+	int nr_entries;
+	int i;
+	void *ret;
+
+	NOVA_START_TIMING(delete_dir_tree_t, delete_time);
+
+	nova_dbgv("%s: delete dir %lu\n", __func__, sih->ino);
+	do {
+		nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, FREE_BATCH);
+		for (i = 0; i < nr_entries; i++) {
+			direntry = entries[i];
+
+			pos = BKDRHash(direntry->name, direntry->name_len);
+			ret = radix_tree_delete(&sih->tree, pos);
+			if (!ret || ret != direntry) {
+				nova_err(sb, "dentry: type %d, inode %llu, "
+					"name %s, namelen %u, rec len %u\n",
+					direntry->entry_type,
+					le64_to_cpu(direntry->ino),
+					direntry->name, direntry->name_len,
+					le16_to_cpu(direntry->de_len));
+				if (!ret)
+					nova_dbg("ret is NULL\n");
+			}
+		}
+		pos++;
+	} while (nr_entries == FREE_BATCH);
+
+	NOVA_END_TIMING(delete_dir_tree_t, delete_time);
+}
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 8f085cf..3890479 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -340,6 +340,19 @@ static inline int old_entry_freeable(struct super_block *sb, u64 epoch_id)
 	return 0;
 }
 
+// BKDR String Hash Function
+static inline unsigned long BKDRHash(const char *str, int length)
+{
+	unsigned int seed = 131; // 31 131 1313 13131 131313 etc..
+	unsigned long hash = 0;
+	int i;
+
+	for (i = 0; i < length; i++)
+		hash = hash * seed + (*str++);
+
+	return hash;
+}
+
 #include "balloc.h"
 
 static inline struct nova_file_write_entry *
@@ -433,6 +446,19 @@ nova_get_blocknr(struct super_block *sb, u64 block, unsigned short btype)
 /* ==============  Function prototypes  ================= */
 /* ====================================================== */
 
+/* dir.c */
+int nova_insert_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name,
+	int namelen, struct nova_dentry *direntry);
+int nova_remove_dir_radix_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, const char *name, int namelen,
+	int replay, struct nova_dentry **create_dentry);
+void nova_delete_dir_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih);
+struct nova_dentry *nova_find_dentry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode, const char *name,
+	unsigned long name_len);
+
 /* rebuild.c */
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 	u64 ino, u64 pi_addr, int rebuild_dir);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
