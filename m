Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x243.google.com (mail-pl0-x243.google.com
 [IPv6:2607:f8b0:400e:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C80262258AF01
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:10 -0800 (PST)
Received: by mail-pl0-x243.google.com with SMTP id 61-v6so7023341plf.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:29 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 11/83] Add timing and I/O statistics for performance analysis
 and profiling.
Date: Sat, 10 Mar 2018 10:17:52 -0800
Message-Id: <1520705944-6723-12-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/Makefile |   2 +-
 fs/nova/nova.h   |  12 +++
 fs/nova/stats.c  | 263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/stats.h  | 178 +++++++++++++++++++++++++++++++++++++
 fs/nova/super.c  |   6 ++
 5 files changed, 460 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/stats.c
 create mode 100644 fs/nova/stats.h

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index eb19646..886356a 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_NOVA_FS) += nova.o
 
-nova-y := bbuild.o inode.o rebuild.o super.o
+nova-y := bbuild.o inode.o rebuild.o stats.o super.o
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index ded9fe8..ba7ffca 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -48,6 +48,7 @@
 #include <linux/pagevec.h>
 
 #include "nova_def.h"
+#include "stats.h"
 
 #define PAGE_SHIFT_2M 21
 #define PAGE_SHIFT_1G 30
@@ -135,6 +136,10 @@ extern unsigned int nova_dbgmask;
 #define	ANY_CPU				(65536)
 #define	FREE_BATCH			(16)
 
+
+extern int measure_timing;
+
+
 extern unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX];
 extern unsigned int blk_type_to_size[NOVA_BLOCK_TYPE_MAX];
 
@@ -306,4 +311,11 @@ static inline u64 nova_get_epoch_id(struct super_block *sb)
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 	u64 ino, u64 pi_addr, int rebuild_dir);
 
+/* stats.c */
+void nova_get_timing_stats(void);
+void nova_get_IO_stats(void);
+void nova_print_timing_stats(struct super_block *sb);
+void nova_clear_stats(struct super_block *sb);
+void nova_print_inode(struct nova_inode *pi);
+
 #endif /* __NOVA_H */
diff --git a/fs/nova/stats.c b/fs/nova/stats.c
new file mode 100644
index 0000000..4b7c317
--- /dev/null
+++ b/fs/nova/stats.c
@@ -0,0 +1,263 @@
+/*
+ * NOVA File System statistics
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
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
+#include "nova.h"
+
+const char *Timingstring[TIMING_NUM] = {
+	/* Init */
+	"================ Initialization ================",
+	"init",
+	"mount",
+	"ioremap",
+	"new_init",
+	"recovery",
+
+	/* Namei operations */
+	"============= Directory operations =============",
+	"create",
+	"lookup",
+	"link",
+	"unlink",
+	"symlink",
+	"mkdir",
+	"rmdir",
+	"mknod",
+	"rename",
+	"readdir",
+	"add_dentry",
+	"remove_dentry",
+	"setattr",
+	"setsize",
+
+	/* I/O operations */
+	"================ I/O operations ================",
+	"dax_read",
+	"cow_write",
+	"inplace_write",
+	"copy_to_nvmm",
+	"dax_get_block",
+	"read_iter",
+	"write_iter",
+
+	/* Memory operations */
+	"============== Memory operations ===============",
+	"memcpy_read_nvmm",
+	"memcpy_write_nvmm",
+	"memcpy_write_back_to_nvmm",
+	"handle_partial_block",
+
+	/* Memory management */
+	"============== Memory management ===============",
+	"alloc_blocks",
+	"new_data_blocks",
+	"new_log_blocks",
+	"free_blocks",
+	"free_data_blocks",
+	"free_log_blocks",
+
+	/* Transaction */
+	"================= Transaction ==================",
+	"transaction_new_inode",
+	"transaction_link_change",
+	"update_tail",
+
+	/* Logging */
+	"============= Logging operations ===============",
+	"append_dir_entry",
+	"append_file_entry",
+	"append_link_change",
+	"append_setattr",
+	"inplace_update_entry",
+
+	/* Tree */
+	"=============== Tree operations ================",
+	"checking_entry",
+	"assign_blocks",
+
+	/* GC */
+	"============= Garbage collection ===============",
+	"log_fast_gc",
+	"log_thorough_gc",
+	"check_invalid_log",
+
+	/* Others */
+	"================ Miscellaneous =================",
+	"find_cache_page",
+	"fsync",
+	"write_pages",
+	"fallocate",
+	"direct_IO",
+	"free_old_entry",
+	"delete_file_tree",
+	"delete_dir_tree",
+	"new_vfs_inode",
+	"new_nova_inode",
+	"free_inode",
+	"free_inode_log",
+	"evict_inode",
+
+	/* Mmap */
+	"=============== MMap operations ================",
+	"mmap_page_fault",
+	"mmap_pmd_fault",
+	"mmap_pfn_mkwrite",
+
+	/* Rebuild */
+	"=================== Rebuild ====================",
+	"rebuild_dir",
+	"rebuild_file",
+};
+
+u64 Timingstats[TIMING_NUM];
+DEFINE_PER_CPU(u64[TIMING_NUM], Timingstats_percpu);
+u64 Countstats[TIMING_NUM];
+DEFINE_PER_CPU(u64[TIMING_NUM], Countstats_percpu);
+u64 IOstats[STATS_NUM];
+DEFINE_PER_CPU(u64[STATS_NUM], IOstats_percpu);
+
+static void nova_print_IO_stats(struct super_block *sb)
+{
+	nova_info("=========== NOVA I/O stats ===========\n");
+	nova_info("Read %llu, bytes %llu, average %llu\n",
+		Countstats[dax_read_t], IOstats[read_bytes],
+		Countstats[dax_read_t] ?
+			IOstats[read_bytes] / Countstats[dax_read_t] : 0);
+	nova_info("COW write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[cow_write_t], IOstats[cow_write_bytes],
+		Countstats[cow_write_t] ?
+			IOstats[cow_write_bytes] / Countstats[cow_write_t] : 0,
+		IOstats[cow_write_breaks], Countstats[cow_write_t] ?
+			IOstats[cow_write_breaks] / Countstats[cow_write_t]
+			: 0);
+	nova_info("Inplace write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[inplace_write_t], IOstats[inplace_write_bytes],
+		Countstats[inplace_write_t] ?
+			IOstats[inplace_write_bytes] /
+			Countstats[inplace_write_t] : 0,
+		IOstats[inplace_write_breaks], Countstats[inplace_write_t] ?
+			IOstats[inplace_write_breaks] /
+			Countstats[inplace_write_t] : 0);
+}
+
+void nova_get_timing_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < TIMING_NUM; i++) {
+		Timingstats[i] = 0;
+		Countstats[i] = 0;
+		for_each_possible_cpu(cpu) {
+			Timingstats[i] += per_cpu(Timingstats_percpu[i], cpu);
+			Countstats[i] += per_cpu(Countstats_percpu[i], cpu);
+		}
+	}
+}
+
+void nova_get_IO_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < STATS_NUM; i++) {
+		IOstats[i] = 0;
+		for_each_possible_cpu(cpu)
+			IOstats[i] += per_cpu(IOstats_percpu[i], cpu);
+	}
+}
+
+void nova_print_timing_stats(struct super_block *sb)
+{
+	int i;
+
+	nova_get_timing_stats();
+	nova_get_IO_stats();
+
+	nova_info("=========== NOVA kernel timing stats ============\n");
+	for (i = 0; i < TIMING_NUM; i++) {
+		/* Title */
+		if (Timingstring[i][0] == '=') {
+			nova_info("\n%s\n\n", Timingstring[i]);
+			continue;
+		}
+
+		if (measure_timing || Timingstats[i]) {
+			nova_info("%s: count %llu, timing %llu, average %llu\n",
+				Timingstring[i],
+				Countstats[i],
+				Timingstats[i],
+				Countstats[i] ?
+				Timingstats[i] / Countstats[i] : 0);
+		} else {
+			nova_info("%s: count %llu\n",
+				Timingstring[i],
+				Countstats[i]);
+		}
+	}
+
+	nova_info("\n");
+	nova_print_IO_stats(sb);
+}
+
+static void nova_clear_timing_stats(void)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < TIMING_NUM; i++) {
+		Countstats[i] = 0;
+		Timingstats[i] = 0;
+		for_each_possible_cpu(cpu) {
+			per_cpu(Timingstats_percpu[i], cpu) = 0;
+			per_cpu(Countstats_percpu[i], cpu) = 0;
+		}
+	}
+}
+
+static void nova_clear_IO_stats(struct super_block *sb)
+{
+	int i;
+	int cpu;
+
+	for (i = 0; i < STATS_NUM; i++) {
+		IOstats[i] = 0;
+		for_each_possible_cpu(cpu)
+			per_cpu(IOstats_percpu[i], cpu) = 0;
+	}
+}
+
+void nova_clear_stats(struct super_block *sb)
+{
+	nova_clear_timing_stats();
+	nova_clear_IO_stats(sb);
+}
+
+void nova_print_inode(struct nova_inode *pi)
+{
+	nova_dbg("%s: NOVA inode %llu\n", __func__, pi->nova_ino);
+	nova_dbg("valid %u, deleted %u, blk type %u, flags %u\n",
+		pi->valid, pi->deleted, pi->i_blk_type, pi->i_flags);
+	nova_dbg("size %llu, ctime %u, mtime %u, atime %u\n",
+		pi->i_size, pi->i_ctime, pi->i_mtime, pi->i_atime);
+	nova_dbg("mode %u, links %u, xattr 0x%llx\n",
+		pi->i_mode, pi->i_links_count, pi->i_xattr);
+	nova_dbg("uid %u, gid %u, gen %u, create time %u\n",
+		pi->i_uid, pi->i_gid, pi->i_generation, pi->i_create_time);
+	nova_dbg("head 0x%llx, tail 0x%llx\n",
+		pi->log_head, pi->log_tail);
+	nova_dbg("create epoch id %llu, delete epoch id %llu\n",
+		pi->create_epoch_id, pi->delete_epoch_id);
+}
diff --git a/fs/nova/stats.h b/fs/nova/stats.h
new file mode 100644
index 0000000..8dbd02d
--- /dev/null
+++ b/fs/nova/stats.h
@@ -0,0 +1,178 @@
+/*
+ * NOVA File System statistics
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
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
+#ifndef __STATS_H
+#define __STATS_H
+
+
+/* ======================= Timing ========================= */
+enum timing_category {
+	/* Init */
+	init_title_t,
+	init_t,
+	mount_t,
+	ioremap_t,
+	new_init_t,
+	recovery_t,
+
+	/* Namei operations */
+	namei_title_t,
+	create_t,
+	lookup_t,
+	link_t,
+	unlink_t,
+	symlink_t,
+	mkdir_t,
+	rmdir_t,
+	mknod_t,
+	rename_t,
+	readdir_t,
+	add_dentry_t,
+	remove_dentry_t,
+	setattr_t,
+	setsize_t,
+
+	/* I/O operations */
+	io_title_t,
+	dax_read_t,
+	cow_write_t,
+	inplace_write_t,
+	copy_to_nvmm_t,
+	dax_get_block_t,
+	read_iter_t,
+	write_iter_t,
+
+	/* Memory operations */
+	memory_title_t,
+	memcpy_r_nvmm_t,
+	memcpy_w_nvmm_t,
+	memcpy_w_wb_t,
+	partial_block_t,
+
+	/* Memory management */
+	mm_title_t,
+	new_blocks_t,
+	new_data_blocks_t,
+	new_log_blocks_t,
+	free_blocks_t,
+	free_data_t,
+	free_log_t,
+
+	/* Transaction */
+	trans_title_t,
+	create_trans_t,
+	link_trans_t,
+	update_tail_t,
+
+	/* Logging */
+	logging_title_t,
+	append_dir_entry_t,
+	append_file_entry_t,
+	append_link_change_t,
+	append_setattr_t,
+	update_entry_t,
+
+	/* Tree */
+	tree_title_t,
+	check_entry_t,
+	assign_t,
+
+	/* GC */
+	gc_title_t,
+	fast_gc_t,
+	thorough_gc_t,
+	check_invalid_t,
+
+	/* Others */
+	others_title_t,
+	find_cache_t,
+	fsync_t,
+	write_pages_t,
+	fallocate_t,
+	direct_IO_t,
+	free_old_t,
+	delete_file_tree_t,
+	delete_dir_tree_t,
+	new_vfs_inode_t,
+	new_nova_inode_t,
+	free_inode_t,
+	free_inode_log_t,
+	evict_inode_t,
+
+	/* Mmap */
+	mmap_title_t,
+	mmap_fault_t,
+	pmd_fault_t,
+	pfn_mkwrite_t,
+
+	/* Rebuild */
+	rebuild_title_t,
+	rebuild_dir_t,
+	rebuild_file_t,
+
+	/* Sentinel */
+	TIMING_NUM,
+};
+
+enum stats_category {
+	alloc_steps,
+	cow_write_breaks,
+	inplace_write_breaks,
+	read_bytes,
+	cow_write_bytes,
+	inplace_write_bytes,
+	fast_checked_pages,
+	thorough_checked_pages,
+	fast_gc_pages,
+	thorough_gc_pages,
+	dax_new_blocks,
+	inplace_new_blocks,
+	fdatasync,
+
+	/* Sentinel */
+	STATS_NUM,
+};
+
+extern const char *Timingstring[TIMING_NUM];
+extern u64 Timingstats[TIMING_NUM];
+DECLARE_PER_CPU(u64[TIMING_NUM], Timingstats_percpu);
+extern u64 Countstats[TIMING_NUM];
+DECLARE_PER_CPU(u64[TIMING_NUM], Countstats_percpu);
+extern u64 IOstats[STATS_NUM];
+DECLARE_PER_CPU(u64[STATS_NUM], IOstats_percpu);
+
+typedef struct timespec timing_t;
+
+#define NOVA_START_TIMING(name, start) \
+	{if (measure_timing) getrawmonotonic(&start); }
+
+#define NOVA_END_TIMING(name, start) \
+	{if (measure_timing) { \
+		timing_t end; \
+		getrawmonotonic(&end); \
+		__this_cpu_add(Timingstats_percpu[name], \
+			(end.tv_sec - start.tv_sec) * 1000000000 + \
+			(end.tv_nsec - start.tv_nsec)); \
+	} \
+	__this_cpu_add(Countstats_percpu[name], 1); \
+	}
+
+#define NOVA_STATS_ADD(name, value) \
+	{__this_cpu_add(IOstats_percpu[name], value); }
+
+
+
+#endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index e0e38ab..9295d23 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -40,8 +40,12 @@
 #include "nova.h"
 #include "super.h"
 
+int measure_timing;
 int support_clwb;
 
+module_param(measure_timing, int, 0444);
+MODULE_PARM_DESC(measure_timing, "Timing measurement");
+
 module_param(nova_dbgmask, int, 0444);
 MODULE_PARM_DESC(nova_dbgmask, "Control debugging output");
 
@@ -500,6 +504,8 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	nova_dbg("measure timing %d\n", measure_timing);
+
 	get_random_bytes(&random, sizeof(u32));
 	atomic_set(&sbi->next_generation, random);
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
