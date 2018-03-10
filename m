Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6FE522646310
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:18 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id j20so2625553pfi.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:37 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 67/83] Dax: commit list of file write items to log.
Date: Sat, 10 Mar 2018 10:18:48 -0800
Message-Id: <1520705944-6723-68-git-send-email-jix024@eng.ucsd.edu>
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

Given a list of file write items, NOVA commits them by appending
each file write entry to the log, and then updates the radix tree
to point to these new entries, and updates log tail pointer to
commit all the writes atomically.
If the items are allocated on heap, free them on success.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |   2 +-
 fs/nova/dax.c    | 112 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h   |   5 +++
 3 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/dax.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 468ed6f..7f851f2 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o dir.o file.o inode.o journal.o log.o namei.o\
+nova-y := balloc.o bbuild.o dax.o dir.o file.o inode.o journal.o log.o namei.o\
 	  rebuild.o stats.o super.o
diff --git a/fs/nova/dax.c b/fs/nova/dax.c
new file mode 100644
index 0000000..1669dc0
--- /dev/null
+++ b/fs/nova/dax.c
@@ -0,0 +1,112 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * DAX file operations.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2009-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/buffer_head.h>
+#include <linux/cpufeature.h>
+#include <asm/pgtable.h>
+#include <linux/version.h>
+#include "nova.h"
+#include "inode.h"
+
+
+static int nova_reassign_file_tree(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 begin_tail, u64 end_tail)
+{
+	void *addr;
+	struct nova_file_write_entry *entry;
+	u64 curr_p = begin_tail;
+	size_t entry_size = sizeof(struct nova_file_write_entry);
+
+	while (curr_p && curr_p != end_tail) {
+		if (is_last_entry(curr_p, entry_size))
+			curr_p = next_log_page(sb, curr_p);
+
+		if (curr_p == 0) {
+			nova_err(sb, "%s: File inode %lu log is NULL!\n",
+				__func__, sih->ino);
+			return -EINVAL;
+		}
+
+		addr = (void *) nova_get_block(sb, curr_p);
+		entry = (struct nova_file_write_entry *) addr;
+
+		if (nova_get_entry_type(entry) != FILE_WRITE) {
+			nova_dbg("%s: entry type is not write? %d\n",
+				__func__, nova_get_entry_type(entry));
+			curr_p += entry_size;
+			continue;
+		}
+
+		nova_assign_write_entry(sb, sih, entry, true);
+		curr_p += entry_size;
+	}
+
+	return 0;
+}
+
+int nova_commit_writes_to_log(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, struct list_head *head, unsigned long new_blocks,
+	int free)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_item *entry_item, *temp;
+	struct nova_inode_update update;
+	unsigned int data_bits;
+	u64 begin_tail = 0;
+	int ret = 0;
+
+	if (list_empty(head))
+		return 0;
+
+	update.tail = 0;
+
+	list_for_each_entry(entry_item, head, list) {
+		ret = nova_append_file_write_entry(sb, pi, inode,
+					entry_item, &update);
+		if (ret) {
+			nova_dbg("%s: append inode entry failed\n", __func__);
+			return -ENOSPC;
+		}
+
+		if (begin_tail == 0)
+			begin_tail = update.curr_entry;
+	}
+
+	/* Update file tree */
+	ret = nova_reassign_file_tree(sb, sih, begin_tail, update.tail);
+	if (ret < 0) {
+		/* FIXME: Need to rebuild the tree */
+		return ret;
+	}
+
+	data_bits = blk_type_to_shift[sih->i_blk_type];
+	sih->i_blocks += (new_blocks << (data_bits - sb->s_blocksize_bits));
+
+	inode->i_blocks = sih->i_blocks;
+
+	nova_update_inode(sb, inode, pi, &update);
+	NOVA_STATS_ADD(inplace_new_blocks, 1);
+
+	sih->trans_id++;
+
+	if (free) {
+		list_for_each_entry_safe(entry_item, temp, head, list)
+			nova_free_file_write_item(entry_item);
+	}
+
+	return ret;
+}
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index b2831f6..dcda02a 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -464,6 +464,11 @@ nova_get_blocknr(struct super_block *sb, u64 block, unsigned short btype)
 /* ==============  Function prototypes  ================= */
 /* ====================================================== */
 
+/* dax.c */
+int nova_commit_writes_to_log(struct super_block *sb, struct nova_inode *pi,
+	struct inode *inode, struct list_head *head, unsigned long new_blocks,
+	int free);
+
 /* dir.c */
 extern const struct file_operations nova_dir_operations;
 int nova_insert_dir_radix_tree(struct super_block *sb,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
