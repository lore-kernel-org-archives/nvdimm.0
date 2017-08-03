Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F05DB21E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:30 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id t83so789865pfj.3
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:42 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 13/16] NOVA: Sysfs and ioctl
Date: Thu, 03 Aug 2017 00:49:40 -0700
Message-ID: <150174658015.104003.8893996228849161193.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Nova provides the normal ioctls for setting file attributes and provides a /proc-based interface for taking snapshots.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/ioctl.c |  185 +++++++++++++++++++
 fs/nova/sysfs.c |  543 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 728 insertions(+)
 create mode 100644 fs/nova/ioctl.c
 create mode 100644 fs/nova/sysfs.c

diff --git a/fs/nova/ioctl.c b/fs/nova/ioctl.c
new file mode 100644
index 000000000000..163e24ccd2ca
--- /dev/null
+++ b/fs/nova/ioctl.c
@@ -0,0 +1,185 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Ioctl operations.
+ *
+ * Copyright 2015-2016 Regents of the University of California,
+ * UCSD Non-Volatile Systems Lab, Andiry Xu <jix024@cs.ucsd.edu>
+ * Copyright 2012-2013 Intel Corporation
+ * Copyright 2010-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/capability.h>
+#include <linux/time.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/mount.h>
+#include "nova.h"
+#include "inode.h"
+
+long nova_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode    *inode = mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pi;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode_update update;
+	unsigned int flags;
+	int ret;
+
+	pi = nova_get_inode(sb, inode);
+	if (!pi)
+		return -EACCES;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		flags = le32_to_cpu(pi->i_flags) & NOVA_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *)arg);
+	case FS_IOC_SETFLAGS: {
+		unsigned int oldflags;
+		u64 old_linkc = 0;
+		u64 epoch_id;
+
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+
+		if (!inode_owner_or_capable(inode)) {
+			ret = -EPERM;
+			goto flags_out;
+		}
+
+		if (get_user(flags, (int __user *)arg)) {
+			ret = -EFAULT;
+			goto flags_out;
+		}
+
+		inode_lock(inode);
+		oldflags = le32_to_cpu(pi->i_flags);
+
+		if ((flags ^ oldflags) &
+		    (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				inode_unlock(inode);
+				ret = -EPERM;
+				goto flags_out_unlock;
+			}
+		}
+
+		if (!S_ISDIR(inode->i_mode))
+			flags &= ~FS_DIRSYNC_FL;
+
+		epoch_id = nova_get_epoch_id(sb);
+		flags = flags & FS_FL_USER_MODIFIABLE;
+		flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
+		inode->i_ctime = current_time(inode);
+		nova_set_inode_flags(inode, pi, flags);
+
+		update.tail = 0;
+		update.alter_tail = 0;
+		ret = nova_append_link_change_entry(sb, pi, inode,
+					&update, &old_linkc, epoch_id);
+		if (!ret) {
+			nova_memunlock_inode(sb, pi);
+			nova_update_inode(sb, inode, pi, &update, 1);
+			nova_memlock_inode(sb, pi);
+			nova_invalidate_link_change_entry(sb, old_linkc);
+		}
+		sih->trans_id++;
+flags_out_unlock:
+		inode_unlock(inode);
+flags_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	case FS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *)arg);
+	case FS_IOC_SETVERSION: {
+		u64 old_linkc = 0;
+		u64 epoch_id;
+		__u32 generation;
+
+		if (!inode_owner_or_capable(inode))
+			return -EPERM;
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+		if (get_user(generation, (int __user *)arg)) {
+			ret = -EFAULT;
+			goto setversion_out;
+		}
+
+		epoch_id = nova_get_epoch_id(sb);
+		inode_lock(inode);
+		inode->i_ctime = current_time(inode);
+		inode->i_generation = generation;
+
+		update.tail = 0;
+		update.alter_tail = 0;
+		ret = nova_append_link_change_entry(sb, pi, inode,
+					&update, &old_linkc, epoch_id);
+		if (!ret) {
+			nova_memunlock_inode(sb, pi);
+			nova_update_inode(sb, inode, pi, &update, 1);
+			nova_memlock_inode(sb, pi);
+			nova_invalidate_link_change_entry(sb, old_linkc);
+		}
+		sih->trans_id++;
+		inode_unlock(inode);
+setversion_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	case NOVA_PRINT_TIMING: {
+		nova_print_timing_stats(sb);
+		return 0;
+	}
+	case NOVA_CLEAR_STATS: {
+		nova_clear_stats(sb);
+		return 0;
+	}
+	case NOVA_PRINT_LOG: {
+		nova_print_inode_log(sb, inode);
+		return 0;
+	}
+	case NOVA_PRINT_LOG_PAGES: {
+		nova_print_inode_log_pages(sb, inode);
+		return 0;
+	}
+	case NOVA_PRINT_FREE_LISTS: {
+		nova_print_free_lists(sb);
+		return 0;
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+long nova_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
+	case FS_IOC32_SETVERSION:
+		cmd = FS_IOC_SETVERSION;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return nova_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
diff --git a/fs/nova/sysfs.c b/fs/nova/sysfs.c
new file mode 100644
index 000000000000..38749bb8b14b
--- /dev/null
+++ b/fs/nova/sysfs.c
@@ -0,0 +1,543 @@
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
+	seq_printf(seq, "Dirty pages %llu\n", IOstats[dirty_pages]);
+	seq_printf(seq, "Protect head %llu, tail %llu\n",
+			IOstats[protect_head], IOstats[protect_tail]);
+	seq_printf(seq, "Block csum parity %llu\n", IOstats[block_csum_parity]);
+	seq_printf(seq, "Page fault %llu, dax cow fault %llu, dax cow fault during snapshot creation %llu\n"
+			"CoW write overlap mmap range %llu, mapping/pfn updated pages %llu\n",
+			Countstats[mmap_fault_t], Countstats[mmap_cow_t],
+			IOstats[dax_cow_during_snapshot],
+			IOstats[cow_overlap_mmap],
+			IOstats[mapping_updated_pages]);
+	seq_printf(seq, "fsync %llu, fdatasync %llu\n",
+			Countstats[fsync_t], IOstats[fdatasync]);
+
+	seq_puts(seq, "\n");
+
+	nova_print_snapshot_lists(sb, seq);
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
+		seq_printf(seq, "Free list %d: csum start %lu, replica csum start %lu, csum blocks %lu, parity start %lu, parity blocks %lu\n",
+			i, free_list->csum_start, free_list->replica_csum_start,
+			free_list->num_csum_blocks,
+			free_list->parity_start, free_list->num_parity_blocks);
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
+/* ====================== Snapshot ======================== */
+static int nova_seq_create_snapshot_show(struct seq_file *seq, void *v)
+{
+	seq_puts(seq, "Write to create a snapshot\n");
+	return 0;
+}
+
+static int nova_seq_create_snapshot_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_create_snapshot_show,
+				PDE_DATA(inode));
+}
+
+ssize_t nova_seq_create_snapshot(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = PDE_DATA(inode);
+
+	nova_create_snapshot(sb);
+	return len;
+}
+
+static const struct file_operations nova_seq_create_snapshot_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_create_snapshot_open,
+	.read		= seq_read,
+	.write		= nova_seq_create_snapshot,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nova_seq_delete_snapshot_show(struct seq_file *seq, void *v)
+{
+	seq_puts(seq, "Echo index to delete a snapshot\n");
+	return 0;
+}
+
+static int nova_seq_delete_snapshot_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_delete_snapshot_show,
+				PDE_DATA(inode));
+}
+
+ssize_t nova_seq_delete_snapshot(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = PDE_DATA(inode);
+	u64 epoch_id;
+	int ret;
+
+	ret = kstrtoull(buf, 10, &epoch_id);
+	if (ret < 0)
+		nova_warn("Couldn't parse snapshot id %s", buf);
+	else
+		nova_delete_snapshot(sb, epoch_id);
+
+	return len;
+}
+
+static const struct file_operations nova_seq_delete_snapshot_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_delete_snapshot_open,
+	.read		= seq_read,
+	.write		= nova_seq_delete_snapshot,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int nova_seq_show_snapshots(struct seq_file *seq, void *v)
+{
+	struct super_block *sb = seq->private;
+
+	nova_print_snapshots(sb, seq);
+	return 0;
+}
+
+static int nova_seq_show_snapshots_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_show_snapshots,
+				PDE_DATA(inode));
+}
+
+static const struct file_operations nova_seq_show_snapshots_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_show_snapshots_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/* ====================== Performance ======================== */
+static int nova_seq_test_perf_show(struct seq_file *seq, void *v)
+{
+	seq_printf(seq, "Echo function:poolmb:size:disks to test function performance working on size of data.\n"
+			"    example: echo 1:128:4096:8 > /proc/fs/NOVA/pmem0/test_perf\n"
+			"The disks value only matters for raid functions.\n"
+			"Set function to 0 to test all functions.\n");
+	return 0;
+}
+
+static int nova_seq_test_perf_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nova_seq_test_perf_show, PDE_DATA(inode));
+}
+
+ssize_t nova_seq_test_perf(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	struct super_block *sb = PDE_DATA(inode);
+	size_t size;
+	unsigned int func_id, poolmb, disks;
+
+	if (sscanf(buf, "%u:%u:%zu:%u", &func_id, &poolmb, &size, &disks) == 4)
+		nova_test_perf(sb, func_id, poolmb, size, disks);
+	else
+		nova_warn("Couldn't parse test_perf request: %s", buf);
+
+	return len;
+}
+
+static const struct file_operations nova_seq_test_perf_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nova_seq_test_perf_open,
+	.read		= seq_read,
+	.write		= nova_seq_test_perf,
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
+			       0, 0, 0, 0, 1);
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
+		proc_create_data("create_snapshot", 0444, sbi->s_proc,
+				 &nova_seq_create_snapshot_fops, sb);
+		proc_create_data("delete_snapshot", 0444, sbi->s_proc,
+				 &nova_seq_delete_snapshot_fops, sb);
+		proc_create_data("snapshots", 0444, sbi->s_proc,
+				 &nova_seq_show_snapshots_fops, sb);
+		proc_create_data("test_perf", 0444, sbi->s_proc,
+				 &nova_seq_test_perf_fops, sb);
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
+		remove_proc_entry("create_snapshot", sbi->s_proc);
+		remove_proc_entry("delete_snapshot", sbi->s_proc);
+		remove_proc_entry("snapshots", sbi->s_proc);
+		remove_proc_entry("test_perf", sbi->s_proc);
+		remove_proc_entry("gc", sbi->s_proc);
+		remove_proc_entry(sbi->s_bdev->bd_disk->disk_name,
+					nova_proc_root);
+	}
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
