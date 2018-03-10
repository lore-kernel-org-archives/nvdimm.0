Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 107D22264D228
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:31 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id m19so4838076pgn.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:49 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 77/83] GC: Fast garbage collection.
Date: Sat, 10 Mar 2018 10:18:58 -0800
Message-Id: <1520705944-6723-78-git-send-email-jix024@eng.ucsd.edu>
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

NOVA cleans and compacts the log when the log is full.
The log is a linked list of 4KB pmem pages, and NOVA performs
fast garbage collection by deleting dead log pages (all the entries are invalid)
from the linked list.

Example:
I = Invalid, V = Valid

VIIV -> IIII -> VVII

	||
	||  fast gc
	\/

VIIV -> VVII

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |   2 +-
 fs/nova/gc.c     | 186 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.c    |   3 +
 fs/nova/nova.h   |   7 +++
 4 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/gc.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 87e56c6..7a5fb6d 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := balloc.o bbuild.o dax.o dir.o file.o inode.o ioctl.o journal.o\
+nova-y := balloc.o bbuild.o dax.o dir.o file.o gc.o inode.o ioctl.o journal.o\
 	  log.o namei.o rebuild.o stats.o super.o symlink.o
diff --git a/fs/nova/gc.c b/fs/nova/gc.c
new file mode 100644
index 0000000..1634c04
--- /dev/null
+++ b/fs/nova/gc.c
@@ -0,0 +1,186 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Garbage collection methods
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
+#include "nova.h"
+#include "inode.h"
+
+
+static bool curr_page_invalid(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 page_head)
+{
+	struct nova_inode_log_page *curr_page;
+	struct nova_inode_page_tail page_tail;
+	unsigned int num_entries;
+	unsigned int invalid_entries;
+	bool ret;
+	timing_t check_time;
+	int rc;
+
+	NOVA_START_TIMING(check_invalid_t, check_time);
+
+	curr_page = (struct nova_inode_log_page *)
+					nova_get_block(sb, page_head);
+	rc = memcpy_mcsafe(&page_tail, &curr_page->page_tail,
+					sizeof(struct nova_inode_page_tail));
+	if (rc) {
+		nova_err(sb, "check page failed\n");
+		return false;
+	}
+
+	num_entries = le32_to_cpu(page_tail.num_entries);
+	invalid_entries = le32_to_cpu(page_tail.invalid_entries);
+
+	ret = (invalid_entries == num_entries);
+	if (!ret) {
+		sih->num_entries += num_entries;
+		sih->valid_entries += num_entries - invalid_entries;
+	}
+
+	NOVA_END_TIMING(check_invalid_t, check_time);
+	return ret;
+}
+
+static void free_curr_page(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_inode_log_page *curr_page,
+	struct nova_inode_log_page *last_page, u64 curr_head)
+{
+	u8 btype = sih->i_blk_type;
+
+	nova_set_next_page_address(sb, last_page,
+			curr_page->page_tail.next_page, 1);
+	nova_free_log_blocks(sb, sih,
+			nova_get_blocknr(sb, curr_head, btype), 1);
+}
+
+
+/*
+ * Scan pages in the log and remove those with no valid log entries.
+ */
+int nova_inode_log_fast_gc(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 curr_tail, u64 new_block,
+	int num_pages, int force_thorough)
+{
+	u64 curr, next, possible_head = 0;
+	int found_head = 0;
+	struct nova_inode_log_page *last_page = NULL;
+	struct nova_inode_log_page *curr_page = NULL;
+	int first_need_free = 0;
+	int num_logs;
+	u8 btype = sih->i_blk_type;
+	unsigned long blocks;
+	unsigned long checked_pages = 0;
+	int freed_pages = 0;
+	timing_t gc_time;
+
+	NOVA_START_TIMING(fast_gc_t, gc_time);
+	curr = sih->log_head;
+	sih->valid_entries = 0;
+	sih->num_entries = 0;
+
+	num_logs = 1;
+
+	nova_dbgv("%s: log head 0x%llx, tail 0x%llx\n",
+				__func__, curr, curr_tail);
+	while (1) {
+		if (curr >> PAGE_SHIFT == sih->log_tail >> PAGE_SHIFT) {
+			/* Don't recycle tail page */
+			if (found_head == 0) {
+				possible_head = cpu_to_le64(curr);
+			}
+			break;
+		}
+
+		curr_page = (struct nova_inode_log_page *)
+					nova_get_block(sb, curr);
+		next = next_log_page(sb, curr);
+		if (next < 0)
+			break;
+
+		nova_dbg_verbose("curr 0x%llx, next 0x%llx\n", curr, next);
+		if (curr_page_invalid(sb, pi, sih, curr)) {
+			nova_dbg_verbose("curr page %p invalid\n", curr_page);
+			if (curr == sih->log_head) {
+				/* Free first page later */
+				first_need_free = 1;
+				last_page = curr_page;
+			} else {
+				nova_dbg_verbose("Free log block 0x%llx\n",
+						curr >> PAGE_SHIFT);
+				free_curr_page(sb, sih, curr_page, last_page,
+						curr);
+			}
+			NOVA_STATS_ADD(fast_gc_pages, 1);
+			freed_pages++;
+		} else {
+			if (found_head == 0) {
+				possible_head = cpu_to_le64(curr);
+				found_head = 1;
+			}
+			last_page = curr_page;
+		}
+
+		curr = next;
+		checked_pages++;
+		if (curr == 0)
+			break;
+	}
+
+	NOVA_STATS_ADD(fast_checked_pages, checked_pages);
+	nova_dbgv("checked pages %lu, freed %d\n", checked_pages, freed_pages);
+	checked_pages -= freed_pages;
+
+	// TODO:  I think this belongs in nova_extend_inode_log.
+	if (num_pages > 0) {
+		curr = BLOCK_OFF(curr_tail);
+		curr_page = (struct nova_inode_log_page *)
+						  nova_get_block(sb, curr);
+
+		nova_set_next_page_address(sb, curr_page, new_block, 1);
+	}
+
+	curr = sih->log_head;
+
+	pi->log_head = possible_head;
+	nova_persist_inode(pi);
+	sih->log_head = possible_head;
+	nova_dbgv("%s: %d new head 0x%llx\n", __func__,
+					found_head, possible_head);
+	sih->log_pages += (num_pages - freed_pages) * num_logs;
+	/* Don't update log tail pointer here */
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 1);
+
+	if (first_need_free) {
+		nova_dbg_verbose("Free log head block 0x%llx\n",
+					curr >> PAGE_SHIFT);
+		nova_free_log_blocks(sb, sih,
+				nova_get_blocknr(sb, curr, btype), 1);
+	}
+
+	NOVA_END_TIMING(fast_gc_t, gc_time);
+
+	if (sih->num_entries == 0)
+		return 0;
+
+	blocks = (sih->valid_entries * checked_pages) / sih->num_entries;
+	if ((sih->valid_entries * checked_pages) % sih->num_entries)
+		blocks++;
+
+	return 0;
+}
diff --git a/fs/nova/log.c b/fs/nova/log.c
index 451be27..66bf98e 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -964,6 +964,9 @@ static u64 nova_extend_inode_log(struct super_block *sb, struct nova_inode *pi,
 	}
 
 	/* Perform GC */
+	nova_inode_log_fast_gc(sb, pi, sih, curr_p,
+			       new_block, allocated, 0);
+
 	return new_block;
 }
 
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index ab9153e..32b7b2f 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -515,6 +515,13 @@ int nova_remove_dentry(struct dentry *dentry, int dec_link,
 extern const struct file_operations nova_dax_file_operations;
 extern const struct inode_operations nova_file_inode_operations;
 
+
+/* gc.c */
+int nova_inode_log_fast_gc(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 curr_tail, u64 new_block, int num_pages,
+	int force_thorough);
+
 /* ioctl.c */
 extern long nova_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 #ifdef CONFIG_COMPAT
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
