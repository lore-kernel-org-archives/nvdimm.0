Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B32F32264D233
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:38 -0800 (PST)
Received: by mail-pf0-x244.google.com with SMTP id j2so2614492pff.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:57 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 83/83] Sysfs support.
Date: Sat, 10 Mar 2018 10:19:04 -0800
Message-Id: <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
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

Sysfs support allows user to get/post information of running NOVA instance.
After mount, NOVA creates four entries under proc directory
/proc/fs/nova/pmem#/:

timing_stats	IO_stats	allocator	gc

Show NOVA file operation timing statistics:
cat /proc/fs/NOVA/pmem#/timing_stats

Clear timing statistics:
echo 1 > /proc/fs/NOVA/pmem#/timing_stats

Show NOVA I/O statistics:
cat /proc/fs/NOVA/pmem#/IO_stats

Clear I/O statistics:
echo 1 > /proc/fs/NOVA/pmem#/IO_stats

Show NOVA allocator information:
cat /proc/fs/NOVA/pmem#/allocator

Manual garbage collection:
echo #inode_number > /proc/fs/NOVA/pmem#/gc

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/Makefile |   2 +-
 fs/nova/nova.h   |   6 +
 fs/nova/super.c  |   9 ++
 fs/nova/super.h  |   1 +
 fs/nova/sysfs.c  | 379 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 396 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/sysfs.c

diff --git a/fs/nova/Makefile b/fs/nova/Makefile
index 7a5fb6d..6e1c29d 100644
--- a/fs/nova/Makefile
+++ b/fs/nova/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_NOVA_FS) += nova.o
 
 nova-y := balloc.o bbuild.o dax.o dir.o file.o gc.o inode.o ioctl.o journal.o\
-	  log.o namei.o rebuild.o stats.o super.o symlink.o
+	  log.o namei.o rebuild.o stats.o super.o symlink.o sysfs.o
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 32b7b2f..0814676 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -546,6 +546,12 @@ int nova_block_symlink(struct super_block *sb, struct nova_inode *pi,
 	struct inode *inode, const char *symname, int len, u64 epoch_id);
 extern const struct inode_operations nova_symlink_inode_operations;
 
+/* sysfs.c */
+extern const char *proc_dirname;
+extern struct proc_dir_entry *nova_proc_root;
+void nova_sysfs_init(struct super_block *sb);
+void nova_sysfs_exit(struct super_block *sb);
+
 /* stats.c */
 void nova_get_timing_stats(void);
 void nova_get_IO_stats(void);
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 14b4af6..039c003 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -596,6 +596,8 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	nova_sysfs_init(sb);
+
 	/* Init a new nova instance */
 	if (sbi->s_mount_opt & NOVA_MOUNT_FORMAT) {
 		root_pi = nova_init(sb, sbi->initsize);
@@ -680,6 +682,8 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(sbi->inode_maps);
 	sbi->inode_maps = NULL;
 
+	nova_sysfs_exit(sb);
+
 	kfree(sbi->nova_sb);
 	kfree(sbi);
 	nova_dbg("%s failed: return %d\n", __func__, retval);
@@ -783,6 +787,8 @@ static void nova_put_super(struct super_block *sb)
 			i, inode_map->allocated, inode_map->freed);
 	}
 
+	nova_sysfs_exit(sb);
+
 	kfree(sbi->inode_maps);
 	kfree(sbi->nova_sb);
 	kfree(sbi);
@@ -1007,6 +1013,8 @@ static int __init init_nova_fs(void)
 	nova_info("Arch new instructions support: CLWB %s\n",
 			support_clwb ? "YES" : "NO");
 
+	nova_proc_root = proc_mkdir(proc_dirname, NULL);
+
 	rc = init_rangenode_cache();
 	if (rc)
 		goto out;
@@ -1041,6 +1049,7 @@ static int __init init_nova_fs(void)
 static void __exit exit_nova_fs(void)
 {
 	unregister_filesystem(&nova_fs_type);
+	remove_proc_entry(proc_dirname, NULL);
 	destroy_file_write_item_cache();
 	destroy_inodecache();
 	destroy_rangenode_cache();
diff --git a/fs/nova/super.h b/fs/nova/super.h
index bcf9548..bcbe862 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -112,6 +112,7 @@ struct nova_sb_info {
 	struct mutex	s_lock;	/* protects the SB's buffer-head */
 
 	int cpus;
+	struct proc_dir_entry *s_proc;
 
 	/* Current epoch. volatile guarantees visibility */
 	volatile u64 s_epoch_id;
diff --git a/fs/nova/sysfs.c b/fs/nova/sysfs.c
new file mode 100644
index 0000000..0a73ef4
--- /dev/null
+++ b/fs/nova/sysfs.c
@@ -0,0 +1,379 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Proc fs operations
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
+#include "nova.h"
+#include "inode.h"
+
+const char *proc_dirname = "fs/NOVA";
+struct proc_dir_entry *nova_proc_root;
+
+/* ====================== Statistics ======================== */
+static int nova_seq_timing_show(struct seq_file *seq, void *v)
+{
+	int i;
+
+	nova_get_timing_stats();
+
+	seq_puts(seq, "=========== NOVA kernel timing stats ===========\n");
+	for (i = 0; i < TIMING_NUM; i++) {
+		/* Title */
+		if (Timingstring[i][0] == '=') {
+			seq_printf(seq, "\n%s\n\n", Timingstring[i]);
+			continue;
+		}
+
+		if (measure_timing || Timingstats[i]) {
+			seq_printf(seq, "%s: count %llu, timing %llu, average %llu\n",
+				Timingstring[i],
+				Countstats[i],
+				Timingstats[i],
+				Countstats[i] ?
+				Timingstats[i] / Countstats[i] : 0);
+		} else {
+			seq_printf(seq, "%s: count %llu\n",
+				Timingstring[i],
+				Countstats[i]);
+		}
+	}
+
+	seq_puts(seq, "\n");
+	return 0;
+}
+
+static int nova_seq_timing_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_timing_show, PDE_DATA(inode));
+}
+
+ssize_t nova_seq_clear_stats(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = PDE_DATA(inode);
+
+	nova_clear_stats(sb);
+	return len;
+}
+
+static const struct file_operations nova_seq_timing_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_timing_open,
+	.read		= seq_read,
+	.write		= nova_seq_clear_stats,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nova_seq_IO_show(struct seq_file *seq, void *v)
+{
+	struct super_block *sb = seq->private;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long alloc_log_count = 0;
+	unsigned long alloc_log_pages = 0;
+	unsigned long alloc_data_count = 0;
+	unsigned long alloc_data_pages = 0;
+	unsigned long free_log_count = 0;
+	unsigned long freed_log_pages = 0;
+	unsigned long free_data_count = 0;
+	unsigned long freed_data_pages = 0;
+	int i;
+
+	nova_get_timing_stats();
+	nova_get_IO_stats();
+
+	seq_puts(seq, "============ NOVA allocation stats ============\n\n");
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+
+		alloc_log_count += free_list->alloc_log_count;
+		alloc_log_pages += free_list->alloc_log_pages;
+		alloc_data_count += free_list->alloc_data_count;
+		alloc_data_pages += free_list->alloc_data_pages;
+		free_log_count += free_list->free_log_count;
+		freed_log_pages += free_list->freed_log_pages;
+		free_data_count += free_list->free_data_count;
+		freed_data_pages += free_list->freed_data_pages;
+	}
+
+	seq_printf(seq, "alloc log count %lu, allocated log pages %lu\n"
+		"alloc data count %lu, allocated data pages %lu\n"
+		"free log count %lu, freed log pages %lu\n"
+		"free data count %lu, freed data pages %lu\n",
+		alloc_log_count, alloc_log_pages,
+		alloc_data_count, alloc_data_pages,
+		free_log_count, freed_log_pages,
+		free_data_count, freed_data_pages);
+
+	seq_printf(seq, "Fast GC %llu, check pages %llu, free pages %llu, average %llu\n",
+		Countstats[fast_gc_t], IOstats[fast_checked_pages],
+		IOstats[fast_gc_pages], Countstats[fast_gc_t] ?
+			IOstats[fast_gc_pages] / Countstats[fast_gc_t] : 0);
+	seq_printf(seq, "Thorough GC %llu, checked pages %llu, free pages %llu, average %llu\n",
+		Countstats[thorough_gc_t],
+		IOstats[thorough_checked_pages], IOstats[thorough_gc_pages],
+		Countstats[thorough_gc_t] ?
+			IOstats[thorough_gc_pages] / Countstats[thorough_gc_t]
+			: 0);
+
+	seq_puts(seq, "\n");
+
+	seq_puts(seq, "================ NOVA I/O stats ================\n\n");
+	seq_printf(seq, "Read %llu, bytes %llu, average %llu\n",
+		Countstats[dax_read_t], IOstats[read_bytes],
+		Countstats[dax_read_t] ?
+			IOstats[read_bytes] / Countstats[dax_read_t] : 0);
+	seq_printf(seq, "COW write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[cow_write_t], IOstats[cow_write_bytes],
+		Countstats[cow_write_t] ?
+			IOstats[cow_write_bytes] / Countstats[cow_write_t] : 0,
+		IOstats[cow_write_breaks], Countstats[cow_write_t] ?
+			IOstats[cow_write_breaks] / Countstats[cow_write_t]
+			: 0);
+	seq_printf(seq, "Inplace write %llu, bytes %llu, average %llu, write breaks %llu, average %llu\n",
+		Countstats[inplace_write_t], IOstats[inplace_write_bytes],
+		Countstats[inplace_write_t] ?
+			IOstats[inplace_write_bytes] /
+			Countstats[inplace_write_t] : 0,
+		IOstats[inplace_write_breaks], Countstats[inplace_write_t] ?
+			IOstats[inplace_write_breaks] /
+			Countstats[inplace_write_t] : 0);
+	seq_printf(seq, "Inplace write %llu, allocate new blocks %llu\n",
+			Countstats[inplace_write_t],
+			IOstats[inplace_new_blocks]);
+	seq_printf(seq, "DAX get blocks %llu, allocate new blocks %llu\n",
+			Countstats[dax_get_block_t], IOstats[dax_new_blocks]);
+	seq_printf(seq, "Page fault %llu\n", Countstats[mmap_fault_t]);
+	seq_printf(seq, "fsync %llu, fdatasync %llu\n",
+			Countstats[fsync_t], IOstats[fdatasync]);
+
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+
+static int nova_seq_IO_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_IO_show, PDE_DATA(inode));
+}
+
+static const struct file_operations nova_seq_IO_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_IO_open,
+	.read		= seq_read,
+	.write		= nova_seq_clear_stats,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nova_seq_show_allocator(struct seq_file *seq, void *v)
+{
+	struct super_block *sb = seq->private;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int i;
+	unsigned long log_pages = 0;
+	unsigned long data_pages = 0;
+
+	seq_puts(seq, "======== NOVA per-CPU allocator stats ========\n");
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		seq_printf(seq, "Free list %d: block start %lu, block end %lu, num_blocks %lu, num_free_blocks %lu, blocknode %lu\n",
+			i, free_list->block_start, free_list->block_end,
+			free_list->block_end - free_list->block_start + 1,
+			free_list->num_free_blocks, free_list->num_blocknode);
+
+		if (free_list->first_node) {
+			seq_printf(seq, "First node %lu - %lu\n",
+					free_list->first_node->range_low,
+					free_list->first_node->range_high);
+		}
+
+		if (free_list->last_node) {
+			seq_printf(seq, "Last node %lu - %lu\n",
+					free_list->last_node->range_low,
+					free_list->last_node->range_high);
+		}
+
+		seq_printf(seq, "Free list %d: alloc log count %lu, allocated log pages %lu, alloc data count %lu, allocated data pages %lu, free log count %lu, freed log pages %lu, free data count %lu, freed data pages %lu\n",
+			   i,
+			   free_list->alloc_log_count,
+			   free_list->alloc_log_pages,
+			   free_list->alloc_data_count,
+			   free_list->alloc_data_pages,
+			   free_list->free_log_count,
+			   free_list->freed_log_pages,
+			   free_list->free_data_count,
+			   free_list->freed_data_pages);
+
+		log_pages += free_list->alloc_log_pages;
+		log_pages -= free_list->freed_log_pages;
+
+		data_pages += free_list->alloc_data_pages;
+		data_pages -= free_list->freed_data_pages;
+	}
+
+	seq_printf(seq, "\nCurrently used pmem pages: log %lu, data %lu\n",
+			log_pages, data_pages);
+
+	return 0;
+}
+
+static int nova_seq_allocator_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_show_allocator,
+				PDE_DATA(inode));
+}
+
+static const struct file_operations nova_seq_allocator_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_allocator_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+
+/* ====================== GC ======================== */
+
+
+static int nova_seq_gc_show(struct seq_file *seq, void *v)
+{
+	seq_printf(seq, "Echo inode number to trigger garbage collection\n"
+		   "    example: echo 34 > /proc/fs/NOVA/pmem0/gc\n");
+	return 0;
+}
+
+static int nova_seq_gc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_gc_show, PDE_DATA(inode));
+}
+
+ssize_t nova_seq_gc(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	u64 target_inode_number;
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = PDE_DATA(inode);
+	struct inode *target_inode;
+	struct nova_inode *target_pi;
+	struct nova_inode_info *target_sih;
+
+	int ret;
+	char *_buf;
+	int retval = len;
+
+	_buf = kmalloc(len, GFP_KERNEL);
+	if (_buf == NULL)  {
+		retval = -ENOMEM;
+		nova_dbg("%s: kmalloc failed\n", __func__);
+		goto out;
+	}
+
+	if (copy_from_user(_buf, buf, len)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	_buf[len] = 0;
+	ret = kstrtoull(_buf, 0, &target_inode_number);
+	if (ret) {
+		nova_info("%s: Could not parse ino '%s'\n", __func__, _buf);
+		return ret;
+	}
+	nova_info("%s: target_inode_number=%llu.", __func__,
+		  target_inode_number);
+
+	target_inode = nova_iget(sb, target_inode_number);
+	if (target_inode == NULL) {
+		nova_info("%s: inode %llu does not exist.", __func__,
+			  target_inode_number);
+		retval = -ENOENT;
+		goto out;
+	}
+
+	target_pi = nova_get_inode(sb, target_inode);
+	if (target_pi == NULL) {
+		nova_info("%s: couldn't get nova inode %llu.", __func__,
+			  target_inode_number);
+		retval = -ENOENT;
+		goto out;
+	}
+
+	target_sih = NOVA_I(target_inode);
+
+	nova_info("%s: got inode %llu @ 0x%p; pi=0x%p\n", __func__,
+		  target_inode_number, target_inode, target_pi);
+
+	nova_inode_log_fast_gc(sb, target_pi, &target_sih->header,
+			       0, 0, 0, 1);
+	iput(target_inode);
+
+out:
+	kfree(_buf);
+	return retval;
+}
+
+static const struct file_operations nova_seq_gc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_gc_open,
+	.read		= seq_read,
+	.write		= nova_seq_gc,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/* ====================== Setup/teardown======================== */
+void nova_sysfs_init(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (nova_proc_root)
+		sbi->s_proc = proc_mkdir(sbi->s_bdev->bd_disk->disk_name,
+					 nova_proc_root);
+
+	if (sbi->s_proc) {
+		proc_create_data("timing_stats", 0444, sbi->s_proc,
+				 &nova_seq_timing_fops, sb);
+		proc_create_data("IO_stats", 0444, sbi->s_proc,
+				 &nova_seq_IO_fops, sb);
+		proc_create_data("allocator", 0444, sbi->s_proc,
+				 &nova_seq_allocator_fops, sb);
+		proc_create_data("gc", 0444, sbi->s_proc,
+				 &nova_seq_gc_fops, sb);
+	}
+}
+
+void nova_sysfs_exit(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (sbi->s_proc) {
+		remove_proc_entry("timing_stats", sbi->s_proc);
+		remove_proc_entry("IO_stats", sbi->s_proc);
+		remove_proc_entry("allocator", sbi->s_proc);
+		remove_proc_entry("gc", sbi->s_proc);
+		remove_proc_entry(sbi->s_bdev->bd_disk->disk_name,
+					nova_proc_root);
+	}
+}
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
