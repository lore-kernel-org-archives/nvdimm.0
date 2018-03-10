Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B93C22258AEFB
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:15 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id l4so4831581pgp.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:34 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 15/83] Add free list data structure.
Date: Sat, 10 Mar 2018 10:17:56 -0800
Message-Id: <1520705944-6723-16-git-send-email-jix024@eng.ucsd.edu>
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

Free list is the data structure that NOVA uses to manage free pmem blocks.
Each CPU has its own free list to avoid contention.
Free list manages free pmem blocks (represented in range node) with red-black tree.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |  2 +-
 fs/nova/balloc.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/balloc.h | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h   |  1 +
 fs/nova/super.c  | 11 ++++++++++
 fs/nova/super.h  |  4 ++++
 6 files changed, 141 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/balloc.c
 create mode 100644 fs/nova/balloc.h

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 886356a..e2f7b07 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := bbuild.o inode.o rebuild.o stats.o super.o
+nova-y := balloc.o bbuild.o inode.o rebuild.o stats.o super.o
diff --git a/fs/nova/balloc.c b/fs/nova/balloc.c
new file mode 100644
index 0000000..450c942
--- /dev/null
+++ b/fs/nova/balloc.c
@@ -0,0 +1,58 @@
+/*
+ * NOVA persistent memory management
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
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include "nova.h"
+#include "inode.h"
+
+int nova_alloc_block_free_lists(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int i;
+
+	sbi->free_lists = kcalloc(sbi->cpus, sizeof(struct free_list),
+				  GFP_KERNEL);
+
+	if (!sbi->free_lists)
+		return -ENOMEM;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		free_list->block_free_tree = RB_ROOT;
+		spin_lock_init(&free_list->s_lock);
+		free_list->index = i;
+	}
+
+	return 0;
+}
+
+void nova_delete_free_lists(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	/* Each tree is freed in save_blocknode_mappings */
+	kfree(sbi->free_lists);
+	sbi->free_lists = NULL;
+}
+
+
diff --git a/fs/nova/balloc.h b/fs/nova/balloc.h
new file mode 100644
index 0000000..e7c7a1d
--- /dev/null
+++ b/fs/nova/balloc.h
@@ -0,0 +1,66 @@
+#ifndef __BALLOC_H
+#define __BALLOC_H
+
+#include "inode.h"
+
+/* DRAM structure to hold a list of free PMEM blocks */
+struct free_list {
+	spinlock_t s_lock;
+	struct rb_root	block_free_tree;
+	struct nova_range_node *first_node; // lowest address free range
+	struct nova_range_node *last_node; // highest address free range
+
+	int		index; // Which CPU do I belong to?
+
+	/*
+	 * Start and end of allocatable range, inclusive.
+	 */
+	unsigned long	block_start;
+	unsigned long	block_end;
+
+	unsigned long	num_free_blocks;
+
+	/* How many nodes in the rb tree? */
+	unsigned long	num_blocknode;
+
+	u32		csum;		/* Protect integrity */
+
+	/* Statistics */
+	unsigned long	alloc_log_count;
+	unsigned long	alloc_data_count;
+	unsigned long	free_log_count;
+	unsigned long	free_data_count;
+	unsigned long	alloc_log_pages;
+	unsigned long	alloc_data_pages;
+	unsigned long	freed_log_pages;
+	unsigned long	freed_data_pages;
+
+	u64		padding[8];	/* Cache line break */
+};
+
+static inline
+struct free_list *nova_get_free_list(struct super_block *sb, int cpu)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	return &sbi->free_lists[cpu];
+}
+
+enum nova_alloc_direction {ALLOC_FROM_HEAD = 0,
+			   ALLOC_FROM_TAIL = 1};
+
+enum nova_alloc_init {ALLOC_NO_INIT = 0,
+		      ALLOC_INIT_ZERO = 1};
+
+enum alloc_type {
+	LOG = 1,
+	DATA,
+};
+
+
+
+
+int nova_alloc_block_free_lists(struct super_block *sb);
+void nova_delete_free_lists(struct super_block *sb);
+
+#endif
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index e0e85fb..c4abdd8 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -310,6 +310,7 @@ struct nova_range_node {
 };
 
 #include "bbuild.h"
+#include "balloc.h"
 
 /* ====================================================== */
 /* ==============  Function prototypes  ================= */
diff --git a/fs/nova/super.c b/fs/nova/super.c
index aec1cd3..43b24a7 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -545,6 +545,13 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	if (nova_alloc_block_free_lists(sb)) {
+		retval = -ENOMEM;
+		nova_err(sb, "%s: Failed to allocate block free lists.",
+			 __func__);
+		goto out;
+	}
+
 	/* Init a new nova instance */
 	if (sbi->s_mount_opt & NOVA_MOUNT_FORMAT) {
 		root_pi = nova_init(sb, sbi->initsize);
@@ -611,6 +618,8 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(sbi->zeroed_page);
 	sbi->zeroed_page = NULL;
 
+	nova_delete_free_lists(sb);
+
 	kfree(sbi->nova_sb);
 	kfree(sbi);
 	nova_dbg("%s failed: return %d\n", __func__, retval);
@@ -679,6 +688,8 @@ static void nova_put_super(struct super_block *sb)
 		sbi->virt_addr = NULL;
 	}
 
+	nova_delete_free_lists(sb);
+
 	kfree(sbi->zeroed_page);
 	nova_dbgmask = 0;
 
diff --git a/fs/nova/super.h b/fs/nova/super.h
index b478080..dcafbd8 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -118,6 +118,10 @@ struct nova_sb_info {
 
 	/* ZEROED page for cache page initialized */
 	void *zeroed_page;
+
+	/* Per-CPU free block list */
+	struct free_list *free_lists;
+	unsigned long per_list_blocks;
 };
 
 static inline struct nova_sb_info *NOVA_SB(struct super_block *sb)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
