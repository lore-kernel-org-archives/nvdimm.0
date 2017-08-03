Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C34D22095DB81
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:24 -0700 (PDT)
Received: by mail-pg0-x242.google.com with SMTP id 123so787609pga.5
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:36 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 12/16] NOVA: Recovery code
Date: Thu, 03 Aug 2017 00:49:33 -0700
Message-ID: <150174657320.104003.4984055527127345869.stgit@hn>
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

Clean umount/mount
------------------

On a clean unmount, Nova saves the contents of many of its DRAM data structures
to PMEM to accelerate the next mount:

1. Nova stores the allocator state for each of the per-cpu allocators to the
   log of a reserved inode (NOVA_BLOCK_NODE_INO).

2. Nova stores the per-CPU lists of available inodes (the inuse_list) to the
   NOVA_BLOCK_INODELIST1_INO reserved inode.

3. Nova stores the snapshot state to PMEM as described above.

After a clean unmount, the following mount restores these data and then
invalidates them.

Recovery after failures
------------------------

In case of a unclean dismount (e.g., system crash), Nova must rebuild these
DRAM structures by scanning the inode logs.  Nova log scanning is fast because
per-CPU inode tables and per-inode logs allow for parallel recovery.

The number of live log entries in an inode log is roughly the number of extents
in the file.  As a result, Nova only needs to scan a small fraction of the NVMM
during recovery.

The Nova failure recovery consists of two steps:

First, Nova checks its lite weight journals and rolls back any uncommitted
transactions to restore the file system to a consistent state.

Second, Nova starts a recovery thread on each CPU and scans the inode tables in
parallel, performing log scanning for every valid inode in the inode table.
Nova use different recovery mechanisms for directory inodes and file inodes:
For a directory inode, Nova scans the log's linked list to enumerate the pages
it occupies, but it does not inspect the log's contents.  For a file inode,
Nova reads the write entries in the log to enumerate the data pages.

During the recovery scan Nova builds a bitmap of occupied pages, and rebuilds
the allocator based on the result. After this process completes, the file
system is ready to accept new requests.

During the same scan, it rebuilds the snapshot information and the list
available inodes.

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/nova/bbuild.c  | 1602 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/rebuild.c |  847 ++++++++++++++++++++++++++++
 2 files changed, 2449 insertions(+)
 create mode 100644 fs/nova/bbuild.c
 create mode 100644 fs/nova/rebuild.c

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
new file mode 100644
index 000000000000..bdfcc3e3d70f
--- /dev/null
+++ b/fs/nova/bbuild.c
@@ -0,0 +1,1602 @@
+/*
+ * NOVA Recovery routines.
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
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/delay.h>
+#include "nova.h"
+#include "journal.h"
+#include "super.h"
+#include "inode.h"
+#include "log.h"
+
+void nova_init_header(struct super_block *sb,
+	struct nova_inode_info_header *sih, u16 i_mode)
+{
+	sih->log_pages = 0;
+	sih->i_size = 0;
+	sih->i_blocks = 0;
+	sih->pi_addr = 0;
+	sih->alter_pi_addr = 0;
+	INIT_RADIX_TREE(&sih->tree, GFP_ATOMIC);
+	sih->vma_tree = RB_ROOT;
+	sih->num_vmas = 0;
+	INIT_LIST_HEAD(&sih->list);
+	sih->i_mode = i_mode;
+	sih->valid_entries = 0;
+	sih->num_entries = 0;
+	sih->last_setattr = 0;
+	sih->last_link_change = 0;
+	sih->last_dentry = 0;
+	sih->trans_id = 0;
+	sih->log_head = 0;
+	sih->log_tail = 0;
+	sih->alter_log_head = 0;
+	sih->alter_log_tail = 0;
+	sih->i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+}
+
+static inline void set_scan_bm(unsigned long bit,
+	struct single_scan_bm *scan_bm)
+{
+	set_bit(bit, scan_bm->bitmap);
+}
+
+inline void set_bm(unsigned long bit, struct scan_bitmap *bm,
+	enum bm_type type)
+{
+	switch (type) {
+	case BM_4K:
+		set_scan_bm(bit, &bm->scan_bm_4K);
+		break;
+	case BM_2M:
+		set_scan_bm(bit, &bm->scan_bm_2M);
+		break;
+	case BM_1G:
+		set_scan_bm(bit, &bm->scan_bm_1G);
+		break;
+	default:
+		break;
+	}
+}
+
+static inline int get_cpuid(struct nova_sb_info *sbi, unsigned long blocknr)
+{
+	return blocknr / sbi->per_list_blocks;
+}
+
+static int nova_failure_insert_inodetree(struct super_block *sb,
+	unsigned long ino_low, unsigned long ino_high)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	struct nova_range_node *prev = NULL, *next = NULL;
+	struct nova_range_node *new_node;
+	unsigned long internal_low, internal_high;
+	int cpu;
+	struct rb_root *tree;
+	int ret;
+
+	if (ino_low > ino_high) {
+		nova_err(sb, "%s: ino low %lu, ino high %lu\n",
+				__func__, ino_low, ino_high);
+		BUG();
+	}
+
+	cpu = ino_low % sbi->cpus;
+	if (ino_high % sbi->cpus != cpu) {
+		nova_err(sb, "%s: ino low %lu, ino high %lu\n",
+				__func__, ino_low, ino_high);
+		BUG();
+	}
+
+	internal_low = ino_low / sbi->cpus;
+	internal_high = ino_high / sbi->cpus;
+	inode_map = &sbi->inode_maps[cpu];
+	tree = &inode_map->inode_inuse_tree;
+	mutex_lock(&inode_map->inode_table_mutex);
+
+	ret = nova_find_free_slot(sbi, tree, internal_low, internal_high,
+					&prev, &next);
+	if (ret) {
+		nova_dbg("%s: ino %lu - %lu already exists!: %d\n",
+					__func__, ino_low, ino_high, ret);
+		mutex_unlock(&inode_map->inode_table_mutex);
+		return ret;
+	}
+
+	if (prev && next && (internal_low == prev->range_high + 1) &&
+			(internal_high + 1 == next->range_low)) {
+		/* fits the hole */
+		rb_erase(&next->node, tree);
+		inode_map->num_range_node_inode--;
+		prev->range_high = next->range_high;
+		nova_update_range_node_checksum(prev);
+		nova_free_inode_node(sb, next);
+		goto finish;
+	}
+	if (prev && (internal_low == prev->range_high + 1)) {
+		/* Aligns left */
+		prev->range_high += internal_high - internal_low + 1;
+		nova_update_range_node_checksum(prev);
+		goto finish;
+	}
+	if (next && (internal_high + 1 == next->range_low)) {
+		/* Aligns right */
+		next->range_low -= internal_high - internal_low + 1;
+		nova_update_range_node_checksum(next);
+		goto finish;
+	}
+
+	/* Aligns somewhere in the middle */
+	new_node = nova_alloc_inode_node(sb);
+	NOVA_ASSERT(new_node);
+	new_node->range_low = internal_low;
+	new_node->range_high = internal_high;
+	nova_update_range_node_checksum(new_node);
+	ret = nova_insert_inodetree(sbi, new_node, cpu);
+	if (ret) {
+		nova_err(sb, "%s failed\n", __func__);
+		nova_free_inode_node(sb, new_node);
+		goto finish;
+	}
+	inode_map->num_range_node_inode++;
+
+finish:
+	mutex_unlock(&inode_map->inode_table_mutex);
+	return ret;
+}
+
+static void nova_destroy_range_node_tree(struct super_block *sb,
+	struct rb_root *tree)
+{
+	struct nova_range_node *curr;
+	struct rb_node *temp;
+
+	temp = rb_first(tree);
+	while (temp) {
+		curr = container_of(temp, struct nova_range_node, node);
+		temp = rb_next(temp);
+		rb_erase(&curr->node, tree);
+		nova_free_range_node(curr);
+	}
+}
+
+static void nova_destroy_blocknode_tree(struct super_block *sb, int cpu)
+{
+	struct free_list *free_list;
+
+	free_list = nova_get_free_list(sb, cpu);
+	nova_destroy_range_node_tree(sb, &free_list->block_free_tree);
+}
+
+static void nova_destroy_blocknode_trees(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++)
+		nova_destroy_blocknode_tree(sb, i);
+
+}
+
+static int nova_init_blockmap_from_inode(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
+	struct nova_inode_info_header sih;
+	struct free_list *free_list;
+	struct nova_range_node_lowhigh *entry;
+	struct nova_range_node *blknode;
+	size_t size = sizeof(struct nova_range_node_lowhigh);
+	u64 curr_p;
+	u64 cpuid;
+	int ret = 0;
+
+	/* FIXME: Backup inode for BLOCKNODE */
+	ret = nova_get_head_tail(sb, pi, &sih);
+	if (ret)
+		goto out;
+
+	curr_p = sih.log_head;
+	if (curr_p == 0) {
+		nova_dbg("%s: pi head is 0!\n", __func__);
+		return -EINVAL;
+	}
+
+	while (curr_p != sih.log_tail) {
+		if (is_last_entry(curr_p, size))
+			curr_p = next_log_page(sb, curr_p);
+
+		if (curr_p == 0) {
+			nova_dbg("%s: curr_p is NULL!\n", __func__);
+			NOVA_ASSERT(0);
+			ret = -EINVAL;
+			break;
+		}
+
+		entry = (struct nova_range_node_lowhigh *)nova_get_block(sb,
+							curr_p);
+		blknode = nova_alloc_blocknode(sb);
+		if (blknode == NULL)
+			NOVA_ASSERT(0);
+		blknode->range_low = le64_to_cpu(entry->range_low);
+		blknode->range_high = le64_to_cpu(entry->range_high);
+		nova_update_range_node_checksum(blknode);
+		cpuid = get_cpuid(sbi, blknode->range_low);
+
+		/* FIXME: Assume NR_CPUS not change */
+		free_list = nova_get_free_list(sb, cpuid);
+		ret = nova_insert_blocktree(sbi,
+				&free_list->block_free_tree, blknode);
+		if (ret) {
+			nova_err(sb, "%s failed\n", __func__);
+			nova_free_blocknode(sb, blknode);
+			NOVA_ASSERT(0);
+			nova_destroy_blocknode_trees(sb);
+			goto out;
+		}
+		free_list->num_blocknode++;
+		if (free_list->num_blocknode == 1)
+			free_list->first_node = blknode;
+		free_list->last_node = blknode;
+		free_list->num_free_blocks +=
+			blknode->range_high - blknode->range_low + 1;
+		curr_p += sizeof(struct nova_range_node_lowhigh);
+	}
+out:
+	nova_free_inode_log(sb, pi, &sih);
+	return ret;
+}
+
+static void nova_destroy_inode_trees(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		nova_destroy_range_node_tree(sb,
+					&inode_map->inode_inuse_tree);
+	}
+}
+
+#define CPUID_MASK 0xff00000000000000
+
+static int nova_init_inode_list_from_inode(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_INODELIST1_INO);
+	struct nova_inode_info_header sih;
+	struct nova_range_node_lowhigh *entry;
+	struct nova_range_node *range_node;
+	struct inode_map *inode_map;
+	size_t size = sizeof(struct nova_range_node_lowhigh);
+	unsigned long num_inode_node = 0;
+	u64 curr_p;
+	unsigned long cpuid;
+	int ret;
+
+	/* FIXME: Backup inode for INODELIST */
+	ret = nova_get_head_tail(sb, pi, &sih);
+	if (ret)
+		goto out;
+
+	sbi->s_inodes_used_count = 0;
+	curr_p = sih.log_head;
+	if (curr_p == 0) {
+		nova_dbg("%s: pi head is 0!\n", __func__);
+		return -EINVAL;
+	}
+
+	while (curr_p != sih.log_tail) {
+		if (is_last_entry(curr_p, size))
+			curr_p = next_log_page(sb, curr_p);
+
+		if (curr_p == 0) {
+			nova_dbg("%s: curr_p is NULL!\n", __func__);
+			NOVA_ASSERT(0);
+		}
+
+		entry = (struct nova_range_node_lowhigh *)nova_get_block(sb,
+							curr_p);
+		range_node = nova_alloc_inode_node(sb);
+		if (range_node == NULL)
+			NOVA_ASSERT(0);
+
+		cpuid = (entry->range_low & CPUID_MASK) >> 56;
+		if (cpuid >= sbi->cpus) {
+			nova_err(sb, "Invalid cpuid %lu\n", cpuid);
+			nova_free_inode_node(sb, range_node);
+			NOVA_ASSERT(0);
+			nova_destroy_inode_trees(sb);
+			goto out;
+		}
+
+		range_node->range_low = entry->range_low & ~CPUID_MASK;
+		range_node->range_high = entry->range_high;
+		nova_update_range_node_checksum(range_node);
+		ret = nova_insert_inodetree(sbi, range_node, cpuid);
+		if (ret) {
+			nova_err(sb, "%s failed, %d\n", __func__, cpuid);
+			nova_free_inode_node(sb, range_node);
+			NOVA_ASSERT(0);
+			nova_destroy_inode_trees(sb);
+			goto out;
+		}
+
+		sbi->s_inodes_used_count +=
+			range_node->range_high - range_node->range_low + 1;
+		num_inode_node++;
+
+		inode_map = &sbi->inode_maps[cpuid];
+		inode_map->num_range_node_inode++;
+		if (!inode_map->first_inode_range)
+			inode_map->first_inode_range = range_node;
+
+		curr_p += sizeof(struct nova_range_node_lowhigh);
+	}
+
+	nova_dbg("%s: %lu inode nodes\n", __func__, num_inode_node);
+out:
+	nova_free_inode_log(sb, pi, &sih);
+	return ret;
+}
+
+static u64 nova_append_range_node_entry(struct super_block *sb,
+	struct nova_range_node *curr, u64 tail, unsigned long cpuid)
+{
+	u64 curr_p;
+	size_t size = sizeof(struct nova_range_node_lowhigh);
+	struct nova_range_node_lowhigh *entry;
+
+	curr_p = tail;
+
+	if (!nova_range_node_checksum_ok(curr)) {
+		nova_dbg("%s: range node checksum failure\n", __func__);
+		goto out;
+	}
+
+	if (curr_p == 0 || (is_last_entry(curr_p, size) &&
+				next_log_page(sb, curr_p) == 0)) {
+		nova_dbg("%s: inode log reaches end?\n", __func__);
+		goto out;
+	}
+
+	if (is_last_entry(curr_p, size))
+		curr_p = next_log_page(sb, curr_p);
+
+	entry = (struct nova_range_node_lowhigh *)nova_get_block(sb, curr_p);
+	nova_memunlock_range(sb, entry, size);
+	entry->range_low = cpu_to_le64(curr->range_low);
+	if (cpuid)
+		entry->range_low |= cpu_to_le64(cpuid << 56);
+	entry->range_high = cpu_to_le64(curr->range_high);
+	nova_memlock_range(sb, entry, size);
+	nova_dbgv("append entry block low 0x%lx, high 0x%lx\n",
+			curr->range_low, curr->range_high);
+
+	nova_flush_buffer(entry, sizeof(struct nova_range_node_lowhigh), 0);
+out:
+	return curr_p;
+}
+
+static u64 nova_save_range_nodes_to_log(struct super_block *sb,
+	struct rb_root *tree, u64 temp_tail, unsigned long cpuid)
+{
+	struct nova_range_node *curr;
+	struct rb_node *temp;
+	size_t size = sizeof(struct nova_range_node_lowhigh);
+	u64 curr_entry = 0;
+
+	/* Save in increasing order */
+	temp = rb_first(tree);
+	while (temp) {
+		curr = container_of(temp, struct nova_range_node, node);
+		curr_entry = nova_append_range_node_entry(sb, curr,
+						temp_tail, cpuid);
+		temp_tail = curr_entry + size;
+		temp = rb_next(temp);
+		rb_erase(&curr->node, tree);
+		nova_free_range_node(curr);
+	}
+
+	return temp_tail;
+}
+
+static u64 nova_save_free_list_blocknodes(struct super_block *sb, int cpu,
+	u64 temp_tail)
+{
+	struct free_list *free_list;
+
+	free_list = nova_get_free_list(sb, cpu);
+	temp_tail = nova_save_range_nodes_to_log(sb,
+				&free_list->block_free_tree, temp_tail, 0);
+	return temp_tail;
+}
+
+void nova_save_inode_list_to_log(struct super_block *sb)
+{
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_INODELIST1_INO);
+	struct nova_inode_info_header sih;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	unsigned long num_blocks;
+	unsigned long num_nodes = 0;
+	struct inode_map *inode_map;
+	unsigned long i;
+	u64 temp_tail;
+	u64 new_block;
+	int allocated;
+
+	sih.ino = NOVA_INODELIST1_INO;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+	sih.i_blocks = 0;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		num_nodes += inode_map->num_range_node_inode;
+	}
+
+	num_blocks = num_nodes / RANGENODE_PER_PAGE;
+	if (num_nodes % RANGENODE_PER_PAGE)
+		num_blocks++;
+
+	allocated = nova_allocate_inode_log_pages(sb, &sih, num_blocks,
+						&new_block, ANY_CPU, 0);
+	if (allocated != num_blocks) {
+		nova_dbg("Error saving inode list: %d\n", allocated);
+		return;
+	}
+
+	temp_tail = new_block;
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		temp_tail = nova_save_range_nodes_to_log(sb,
+				&inode_map->inode_inuse_tree, temp_tail, i);
+	}
+
+	nova_memunlock_inode(sb, pi);
+	pi->alter_log_head = pi->alter_log_tail = 0;
+	pi->log_head = new_block;
+	nova_update_tail(pi, temp_tail);
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 0);
+	nova_memlock_inode(sb, pi);
+
+	nova_dbg("%s: %lu inode nodes, pi head 0x%llx, tail 0x%llx\n",
+		__func__, num_nodes, pi->log_head, pi->log_tail);
+}
+
+void nova_save_blocknode_mappings_to_log(struct super_block *sb)
+{
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
+	struct nova_inode_info_header sih;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long num_blocknode = 0;
+	unsigned long num_pages;
+	int allocated;
+	u64 new_block = 0;
+	u64 temp_tail;
+	int i;
+
+	sih.ino = NOVA_BLOCKNODE_INO;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+
+	/* Allocate log pages before save blocknode mappings */
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		num_blocknode += free_list->num_blocknode;
+		nova_dbgv("%s: free list %d: %lu nodes\n", __func__,
+				i, free_list->num_blocknode);
+	}
+
+	num_pages = num_blocknode / RANGENODE_PER_PAGE;
+	if (num_blocknode % RANGENODE_PER_PAGE)
+		num_pages++;
+
+	allocated = nova_allocate_inode_log_pages(sb, &sih, num_pages,
+						&new_block, ANY_CPU, 0);
+	if (allocated != num_pages) {
+		nova_dbg("Error saving blocknode mappings: %d\n", allocated);
+		return;
+	}
+
+	temp_tail = new_block;
+	for (i = 0; i < sbi->cpus; i++)
+		temp_tail = nova_save_free_list_blocknodes(sb, i, temp_tail);
+
+	/* Finally update log head and tail */
+	nova_memunlock_inode(sb, pi);
+	pi->alter_log_head = pi->alter_log_tail = 0;
+	pi->log_head = new_block;
+	nova_update_tail(pi, temp_tail);
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 0);
+	nova_memlock_inode(sb, pi);
+
+	nova_dbg("%s: %lu blocknodes, %lu log pages, pi head 0x%llx, tail 0x%llx\n",
+		  __func__, num_blocknode, num_pages,
+		  pi->log_head, pi->log_tail);
+}
+
+static int nova_insert_blocknode_map(struct super_block *sb,
+	int cpuid, unsigned long low, unsigned long high)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	struct rb_root *tree;
+	struct nova_range_node *blknode = NULL;
+	unsigned long num_blocks = 0;
+	int ret;
+
+	num_blocks = high - low + 1;
+	nova_dbgv("%s: cpu %d, low %lu, high %lu, num %lu\n",
+		__func__, cpuid, low, high, num_blocks);
+	free_list = nova_get_free_list(sb, cpuid);
+	tree = &(free_list->block_free_tree);
+
+	blknode = nova_alloc_blocknode(sb);
+	if (blknode == NULL)
+		return -ENOMEM;
+	blknode->range_low = low;
+	blknode->range_high = high;
+	nova_update_range_node_checksum(blknode);
+	ret = nova_insert_blocktree(sbi, tree, blknode);
+	if (ret) {
+		nova_err(sb, "%s failed\n", __func__);
+		nova_free_blocknode(sb, blknode);
+		goto out;
+	}
+	if (!free_list->first_node)
+		free_list->first_node = blknode;
+	free_list->last_node = blknode;
+	free_list->num_blocknode++;
+	free_list->num_free_blocks += num_blocks;
+out:
+	return ret;
+}
+
+static int __nova_build_blocknode_map(struct super_block *sb,
+	unsigned long *bitmap, unsigned long bsize, unsigned long scale)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long next = 0;
+	unsigned long low = 0;
+	unsigned long start, end;
+	int cpuid = 0;
+
+	free_list = nova_get_free_list(sb, cpuid);
+	start = free_list->block_start;
+	end = free_list->block_end + 1;
+	while (1) {
+		next = find_next_zero_bit(bitmap, end, start);
+		if (next == bsize)
+			break;
+		if (next == end) {
+			if (cpuid == sbi->cpus - 1)
+				break;
+
+			cpuid++;
+			free_list = nova_get_free_list(sb, cpuid);
+			start = free_list->block_start;
+			end = free_list->block_end + 1;
+			continue;
+		}
+
+		low = next;
+		next = find_next_bit(bitmap, end, next);
+		if (nova_insert_blocknode_map(sb, cpuid,
+				low << scale, (next << scale) - 1)) {
+			nova_dbg("Error: could not insert %lu - %lu\n",
+				low << scale, ((next << scale) - 1));
+		}
+		start = next;
+		if (next == bsize)
+			break;
+		if (next == end) {
+			if (cpuid == sbi->cpus - 1)
+				break;
+
+			cpuid++;
+			free_list = nova_get_free_list(sb, cpuid);
+			start = free_list->block_start;
+			end = free_list->block_end + 1;
+		}
+	}
+	return 0;
+}
+
+static void nova_update_4K_map(struct super_block *sb,
+	struct scan_bitmap *bm,	unsigned long *bitmap,
+	unsigned long bsize, unsigned long scale)
+{
+	unsigned long next = 0;
+	unsigned long low = 0;
+	int i;
+
+	while (1) {
+		next = find_next_bit(bitmap, bsize, next);
+		if (next == bsize)
+			break;
+		low = next;
+		next = find_next_zero_bit(bitmap, bsize, next);
+		for (i = (low << scale); i < (next << scale); i++)
+			set_bm(i, bm, BM_4K);
+		if (next == bsize)
+			break;
+	}
+}
+
+struct scan_bitmap *global_bm[64];
+
+static int nova_build_blocknode_map(struct super_block *sb,
+	unsigned long initsize)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct scan_bitmap *bm;
+	struct scan_bitmap *final_bm;
+	unsigned long *src, *dst;
+	int i, j;
+	int num;
+	int ret;
+
+	final_bm = kzalloc(sizeof(struct scan_bitmap), GFP_KERNEL);
+	if (!final_bm)
+		return -ENOMEM;
+
+	final_bm->scan_bm_4K.bitmap_size =
+				(initsize >> (PAGE_SHIFT + 0x3));
+
+	/* Alloc memory to hold the block alloc bitmap */
+	final_bm->scan_bm_4K.bitmap = kzalloc(final_bm->scan_bm_4K.bitmap_size,
+							GFP_KERNEL);
+
+	if (!final_bm->scan_bm_4K.bitmap) {
+		kfree(final_bm);
+		return -ENOMEM;
+	}
+
+	/*
+	 * We are using free lists. Set 2M and 1G blocks in 4K map,
+	 * and use 4K map to rebuild block map.
+	 */
+	for (i = 0; i < sbi->cpus; i++) {
+		bm = global_bm[i];
+		nova_update_4K_map(sb, bm, bm->scan_bm_2M.bitmap,
+			bm->scan_bm_2M.bitmap_size * 8, PAGE_SHIFT_2M - 12);
+		nova_update_4K_map(sb, bm, bm->scan_bm_1G.bitmap,
+			bm->scan_bm_1G.bitmap_size * 8, PAGE_SHIFT_1G - 12);
+	}
+
+	/* Merge per-CPU bms to the final single bm */
+	num = final_bm->scan_bm_4K.bitmap_size / sizeof(unsigned long);
+	if (final_bm->scan_bm_4K.bitmap_size % sizeof(unsigned long))
+		num++;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		bm = global_bm[i];
+		src = (unsigned long *)bm->scan_bm_4K.bitmap;
+		dst = (unsigned long *)final_bm->scan_bm_4K.bitmap;
+
+		for (j = 0; j < num; j++)
+			dst[j] |= src[j];
+	}
+
+	ret = __nova_build_blocknode_map(sb, final_bm->scan_bm_4K.bitmap,
+			final_bm->scan_bm_4K.bitmap_size * 8, PAGE_SHIFT - 12);
+
+	kfree(final_bm->scan_bm_4K.bitmap);
+	kfree(final_bm);
+
+	return ret;
+}
+
+static void free_bm(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct scan_bitmap *bm;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		bm = global_bm[i];
+		if (bm) {
+			kfree(bm->scan_bm_4K.bitmap);
+			kfree(bm->scan_bm_2M.bitmap);
+			kfree(bm->scan_bm_1G.bitmap);
+			kfree(bm);
+		}
+	}
+}
+
+static int alloc_bm(struct super_block *sb, unsigned long initsize)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct scan_bitmap *bm;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		bm = kzalloc(sizeof(struct scan_bitmap), GFP_KERNEL);
+		if (!bm)
+			return -ENOMEM;
+
+		global_bm[i] = bm;
+
+		bm->scan_bm_4K.bitmap_size =
+				(initsize >> (PAGE_SHIFT + 0x3));
+		bm->scan_bm_2M.bitmap_size =
+				(initsize >> (PAGE_SHIFT_2M + 0x3));
+		bm->scan_bm_1G.bitmap_size =
+				(initsize >> (PAGE_SHIFT_1G + 0x3));
+
+		/* Alloc memory to hold the block alloc bitmap */
+		bm->scan_bm_4K.bitmap = kzalloc(bm->scan_bm_4K.bitmap_size,
+							GFP_KERNEL);
+		bm->scan_bm_2M.bitmap = kzalloc(bm->scan_bm_2M.bitmap_size,
+							GFP_KERNEL);
+		bm->scan_bm_1G.bitmap = kzalloc(bm->scan_bm_1G.bitmap_size,
+							GFP_KERNEL);
+
+		if (!bm->scan_bm_4K.bitmap || !bm->scan_bm_2M.bitmap ||
+				!bm->scan_bm_1G.bitmap)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/************************** NOVA recovery ****************************/
+
+#define MAX_PGOFF	262144
+
+struct task_ring {
+	u64 addr0[512];
+	u64 addr1[512];		/* Second inode address */
+	int num;
+	int inodes_used_count;
+	u64 *entry_array;
+	u64 *nvmm_array;
+};
+
+static struct task_ring *task_rings;
+static struct task_struct **threads;
+wait_queue_head_t finish_wq;
+int *finished;
+
+static int nova_traverse_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct scan_bitmap *bm, u64 head)
+{
+	u64 curr_p;
+	u64 next;
+
+	curr_p = head;
+
+	if (curr_p == 0)
+		return 0;
+
+	BUG_ON(curr_p & (PAGE_SIZE - 1));
+	set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+
+	next = next_log_page(sb, curr_p);
+	while (next > 0) {
+		curr_p = next;
+		BUG_ON(curr_p & (PAGE_SIZE - 1));
+		set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+		next = next_log_page(sb, curr_p);
+	}
+
+	return 0;
+}
+
+static void nova_traverse_dir_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct scan_bitmap *bm)
+{
+	nova_traverse_inode_log(sb, pi, bm, pi->log_head);
+	if (metadata_csum)
+		nova_traverse_inode_log(sb, pi, bm, pi->alter_log_head);
+}
+
+static unsigned int nova_check_old_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 entry_addr,
+	unsigned long pgoff, unsigned int num_free,
+	u64 epoch_id, struct task_ring *ring, unsigned long base,
+	struct scan_bitmap *bm)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_entry *entryc, entry_copy;
+	unsigned long old_nvmm, nvmm;
+	unsigned long index;
+	int i;
+	int ret;
+
+	entry = (struct nova_file_write_entry *)entry_addr;
+
+	if (!entry)
+		return 0;
+
+	if (metadata_csum == 0)
+		entryc = entry;
+	else {
+		entryc = &entry_copy;
+		if (!nova_verify_entry_csum(sb, entry, entryc))
+			return 0;
+	}
+
+	old_nvmm = get_nvmm(sb, sih, entryc, pgoff);
+
+	ret = nova_append_data_to_snapshot(sb, entryc, old_nvmm,
+				num_free, epoch_id);
+
+	if (ret != 0)
+		return ret;
+
+	index = pgoff - base;
+	for (i = 0; i < num_free; i++) {
+		nvmm = ring->nvmm_array[index];
+		if (nvmm)
+			set_bm(nvmm, bm, BM_4K);
+		index++;
+	}
+
+	return ret;
+}
+
+static int nova_set_ring_array(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	struct nova_file_write_entry *entryc, struct task_ring *ring,
+	unsigned long base, struct scan_bitmap *bm)
+{
+	unsigned long start, end;
+	unsigned long pgoff, old_pgoff = 0;
+	unsigned long index;
+	unsigned int num_free = 0;
+	u64 old_entry = 0;
+	u64 epoch_id = entryc->epoch_id;
+
+	start = entryc->pgoff;
+	if (start < base)
+		start = base;
+
+	end = entryc->pgoff + entryc->num_pages;
+	if (end > base + MAX_PGOFF)
+		end = base + MAX_PGOFF;
+
+	for (pgoff = start; pgoff < end; pgoff++) {
+		index = pgoff - base;
+		if (ring->nvmm_array[index]) {
+			if (ring->entry_array[index] != old_entry) {
+				if (old_entry)
+					nova_check_old_entry(sb, sih, old_entry,
+							old_pgoff, num_free,
+							epoch_id, ring, base,
+							bm);
+
+				old_entry = ring->entry_array[index];
+				old_pgoff = pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+		}
+	}
+
+	if (old_entry)
+		nova_check_old_entry(sb, sih, old_entry, old_pgoff,
+					num_free, epoch_id, ring, base, bm);
+
+	for (pgoff = start; pgoff < end; pgoff++) {
+		index = pgoff - base;
+		ring->entry_array[index] = (u64)entry;
+		ring->nvmm_array[index] = (u64)(entryc->block >> PAGE_SHIFT)
+						+ pgoff - entryc->pgoff;
+	}
+
+	return 0;
+}
+
+static int nova_set_file_bm(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct task_ring *ring,
+	struct scan_bitmap *bm, unsigned long base, unsigned long last_blocknr)
+{
+	unsigned long nvmm, pgoff;
+
+	if (last_blocknr >= base + MAX_PGOFF)
+		last_blocknr = MAX_PGOFF - 1;
+	else
+		last_blocknr -= base;
+
+	for (pgoff = 0; pgoff <= last_blocknr; pgoff++) {
+		nvmm = ring->nvmm_array[pgoff];
+		if (nvmm) {
+			set_bm(nvmm, bm, BM_4K);
+			ring->nvmm_array[pgoff] = 0;
+			ring->entry_array[pgoff] = 0;
+		}
+	}
+
+	return 0;
+}
+
+/* entry given to this function is a copy in dram */
+static void nova_ring_setattr_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_setattr_logentry *entry, struct task_ring *ring,
+	unsigned long base, unsigned int data_bits, struct scan_bitmap *bm)
+{
+	unsigned long first_blocknr, last_blocknr;
+	unsigned long pgoff, old_pgoff = 0;
+	unsigned long index;
+	unsigned int num_free = 0;
+	u64 old_entry = 0;
+	loff_t start, end;
+	u64 epoch_id = entry->epoch_id;
+
+	if (sih->i_size <= entry->size)
+		goto out;
+
+	start = entry->size;
+	end = sih->i_size;
+
+	first_blocknr = (start + (1UL << data_bits) - 1) >> data_bits;
+
+	if (end > 0)
+		last_blocknr = (end - 1) >> data_bits;
+	else
+		last_blocknr = 0;
+
+	if (first_blocknr > last_blocknr)
+		goto out;
+
+	if (first_blocknr < base)
+		first_blocknr = base;
+
+	if (last_blocknr > base + MAX_PGOFF - 1)
+		last_blocknr = base + MAX_PGOFF - 1;
+
+	for (pgoff = first_blocknr; pgoff <= last_blocknr; pgoff++) {
+		index = pgoff - base;
+		if (ring->nvmm_array[index]) {
+			if (ring->entry_array[index] != old_entry) {
+				if (old_entry)
+					nova_check_old_entry(sb, sih, old_entry,
+							old_pgoff, num_free,
+							epoch_id, ring, base,
+							bm);
+
+				old_entry = ring->entry_array[index];
+				old_pgoff = pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+		}
+	}
+
+	if (old_entry)
+		nova_check_old_entry(sb, sih, old_entry, old_pgoff,
+					num_free, epoch_id, ring, base, bm);
+
+	for (pgoff = first_blocknr; pgoff <= last_blocknr; pgoff++) {
+		index = pgoff - base;
+		ring->nvmm_array[index] = 0;
+		ring->entry_array[index] = 0;
+	}
+
+out:
+	sih->i_size = entry->size;
+}
+
+static void nova_traverse_file_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	struct nova_file_write_entry *entryc, struct task_ring *ring,
+	unsigned long base, struct scan_bitmap *bm)
+{
+	sih->i_size = entryc->size;
+
+	if (entryc->num_pages != entryc->invalid_pages) {
+		if (entryc->pgoff < base + MAX_PGOFF &&
+				entryc->pgoff + entryc->num_pages > base)
+			nova_set_ring_array(sb, sih, entry, entryc,
+						ring, base, bm);
+	}
+}
+
+static int nova_traverse_file_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct task_ring *ring, struct scan_bitmap *bm)
+{
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	unsigned long base = 0;
+	unsigned long last_blocknr;
+	u64 ino = pi->nova_ino;
+	void *entry, *entryc;
+	unsigned int btype;
+	unsigned int data_bits;
+	u64 curr_p;
+	u64 next;
+	u8 type;
+
+	btype = pi->i_blk_type;
+	data_bits = blk_type_to_shift[btype];
+
+	if (metadata_csum)
+		nova_traverse_inode_log(sb, pi, bm, pi->alter_log_head);
+
+	entryc = (metadata_csum == 0) ? NULL : entry_copy;
+
+again:
+	sih->i_size = 0;
+	curr_p = pi->log_head;
+	nova_dbg_verbose("Log head 0x%llx, tail 0x%llx\n",
+				curr_p, pi->log_tail);
+	if (curr_p == 0 && pi->log_tail == 0)
+		return 0;
+
+	if (base == 0) {
+		BUG_ON(curr_p & (PAGE_SIZE - 1));
+		set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+	}
+
+	while (curr_p != pi->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			curr_p = next_log_page(sb, curr_p);
+			if (base == 0) {
+				BUG_ON(curr_p & (PAGE_SIZE - 1));
+				set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+			}
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "File inode %llu log is NULL!\n", ino);
+			BUG();
+		}
+
+		entry = (void *)nova_get_block(sb, curr_p);
+
+		if (metadata_csum == 0)
+			entryc = entry;
+		else if (!nova_verify_entry_csum(sb, entry, entryc))
+			return 0;
+
+		type = nova_get_entry_type(entryc);
+		switch (type) {
+		case SET_ATTR:
+			nova_ring_setattr_entry(sb, sih, SENTRY(entryc),
+						ring, base, data_bits,
+						bm);
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case FILE_WRITE:
+			nova_traverse_file_write_entry(sb, sih, WENTRY(entry),
+						WENTRY(entryc), ring, base, bm);
+			curr_p += sizeof(struct nova_file_write_entry);
+			break;
+		case MMAP_WRITE:
+			curr_p += sizeof(struct nova_mmap_entry);
+			break;
+		default:
+			nova_dbg("%s: unknown type %d, 0x%llx\n",
+						__func__, type, curr_p);
+			NOVA_ASSERT(0);
+			BUG();
+		}
+
+	}
+
+	if (base == 0) {
+		/* Keep traversing until log ends */
+		curr_p &= PAGE_MASK;
+		next = next_log_page(sb, curr_p);
+		while (next > 0) {
+			curr_p = next;
+			BUG_ON(curr_p & (PAGE_SIZE - 1));
+			set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+			next = next_log_page(sb, curr_p);
+		}
+	}
+
+	if (sih->i_size == 0)
+		return 0;
+
+	last_blocknr = (sih->i_size - 1) >> data_bits;
+	nova_set_file_bm(sb, sih, ring, bm, base, last_blocknr);
+	if (last_blocknr >= base + MAX_PGOFF) {
+		base += MAX_PGOFF;
+		goto again;
+	}
+
+	return 0;
+}
+
+/* Pi is DRAM fake version */
+static int nova_recover_inode_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct task_ring *ring,
+	struct nova_inode *pi, struct scan_bitmap *bm)
+{
+	unsigned long nova_ino;
+
+	if (pi->deleted == 1)
+		return 0;
+
+	nova_ino = pi->nova_ino;
+	ring->inodes_used_count++;
+
+	sih->i_mode = __le16_to_cpu(pi->i_mode);
+	sih->ino = nova_ino;
+
+	nova_dbgv("%s: inode %lu, head 0x%llx, tail 0x%llx\n",
+			__func__, nova_ino, pi->log_head, pi->log_tail);
+
+	switch (__le16_to_cpu(pi->i_mode) & S_IFMT) {
+	case S_IFDIR:
+		nova_traverse_dir_inode_log(sb, pi, bm);
+		break;
+	case S_IFLNK:
+		/* Treat symlink files as normal files */
+		/* Fall through */
+	case S_IFREG:
+		/* Fall through */
+	default:
+		/* In case of special inode, walk the log */
+		nova_traverse_file_inode_log(sb, pi, sih, ring, bm);
+		break;
+	}
+
+	return 0;
+}
+
+static void free_resources(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct task_ring *ring;
+	int i;
+
+	if (task_rings) {
+		for (i = 0; i < sbi->cpus; i++) {
+			ring = &task_rings[i];
+			vfree(ring->entry_array);
+			vfree(ring->nvmm_array);
+			ring->entry_array = NULL;
+			ring->nvmm_array = NULL;
+		}
+	}
+
+	kfree(task_rings);
+	kfree(threads);
+	kfree(finished);
+}
+
+static int failure_thread_func(void *data);
+
+static int allocate_resources(struct super_block *sb, int cpus)
+{
+	struct task_ring *ring;
+	int i;
+
+	task_rings = kcalloc(cpus, sizeof(struct task_ring), GFP_KERNEL);
+	if (!task_rings)
+		goto fail;
+
+	for (i = 0; i < cpus; i++) {
+		ring = &task_rings[i];
+
+		ring->nvmm_array = vzalloc(sizeof(u64) * MAX_PGOFF);
+		if (!ring->nvmm_array)
+			goto fail;
+
+		ring->entry_array = vmalloc(sizeof(u64) * MAX_PGOFF);
+		if (!ring->entry_array)
+			goto fail;
+	}
+
+	threads = kcalloc(cpus, sizeof(struct task_struct *), GFP_KERNEL);
+	if (!threads)
+		goto fail;
+
+	finished = kcalloc(cpus, sizeof(int), GFP_KERNEL);
+	if (!finished)
+		goto fail;
+
+	init_waitqueue_head(&finish_wq);
+
+	for (i = 0; i < cpus; i++) {
+		threads[i] = kthread_create(failure_thread_func,
+						sb, "recovery thread");
+		kthread_bind(threads[i], i);
+	}
+
+	return 0;
+
+fail:
+	free_resources(sb);
+	return -ENOMEM;
+}
+
+static void wait_to_finish(int cpus)
+{
+	int i;
+
+	for (i = 0; i < cpus; i++) {
+		while (finished[i] == 0) {
+			wait_event_interruptible_timeout(finish_wq, false,
+							msecs_to_jiffies(1));
+		}
+	}
+}
+
+/*********************** Failure recovery *************************/
+
+static inline int nova_failure_update_inodetree(struct super_block *sb,
+	struct nova_inode *pi, unsigned long *ino_low, unsigned long *ino_high)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (*ino_low == 0) {
+		*ino_low = *ino_high = pi->nova_ino;
+	} else {
+		if (pi->nova_ino == *ino_high + sbi->cpus) {
+			*ino_high = pi->nova_ino;
+		} else {
+			/* A new start */
+			nova_failure_insert_inodetree(sb, *ino_low, *ino_high);
+			*ino_low = *ino_high = pi->nova_ino;
+		}
+	}
+
+	return 0;
+}
+
+static int failure_thread_func(void *data)
+{
+	struct super_block *sb = data;
+	struct nova_inode_info_header sih;
+	struct task_ring *ring;
+	struct nova_inode *pi, fake_pi;
+	unsigned long num_inodes_per_page;
+	unsigned long ino_low, ino_high;
+	unsigned long last_blocknr;
+	unsigned int data_bits;
+	u64 curr, curr1;
+	int cpuid = smp_processor_id();
+	unsigned long i;
+	unsigned long max_size = 0;
+	u64 pi_addr = 0;
+	int ret = 0;
+	int count;
+
+	pi = nova_get_inode_by_ino(sb, NOVA_INODETABLE_INO);
+	data_bits = blk_type_to_shift[pi->i_blk_type];
+	num_inodes_per_page = 1 << (data_bits - NOVA_INODE_BITS);
+
+	ring = &task_rings[cpuid];
+	nova_init_header(sb, &sih, 0);
+
+	for (count = 0; count < ring->num; count++) {
+		curr = ring->addr0[count];
+		curr1 = ring->addr1[count];
+		ino_low = ino_high = 0;
+
+		/*
+		 * Note: The inode log page is allocated in 2MB
+		 * granularity, but not aligned on 2MB boundary.
+		 */
+		for (i = 0; i < 512; i++)
+			set_bm((curr >> PAGE_SHIFT) + i,
+					global_bm[cpuid], BM_4K);
+
+		if (metadata_csum) {
+			for (i = 0; i < 512; i++)
+				set_bm((curr1 >> PAGE_SHIFT) + i,
+					global_bm[cpuid], BM_4K);
+		}
+
+		for (i = 0; i < num_inodes_per_page; i++) {
+			pi_addr = curr + i * NOVA_INODE_SIZE;
+			ret = nova_get_reference(sb, pi_addr, &fake_pi,
+				(void **)&pi, sizeof(struct nova_inode));
+			if (ret) {
+				nova_dbg("Recover pi @ 0x%llx failed\n",
+						pi_addr);
+				continue;
+			}
+			/* FIXME: Check inode checksum */
+			if (fake_pi.i_mode && fake_pi.deleted == 0) {
+				if (fake_pi.valid == 0) {
+					ret = nova_append_inode_to_snapshot(sb,
+									pi);
+					if (ret != 0) {
+						/* Deleteable */
+						pi->deleted = 1;
+						fake_pi.deleted = 1;
+						continue;
+					}
+				}
+
+				nova_recover_inode_pages(sb, &sih, ring,
+						&fake_pi, global_bm[cpuid]);
+				nova_failure_update_inodetree(sb, pi,
+						&ino_low, &ino_high);
+				if (sih.i_size > max_size)
+					max_size = sih.i_size;
+			}
+		}
+
+		if (ino_low && ino_high)
+			nova_failure_insert_inodetree(sb, ino_low, ino_high);
+	}
+
+	/* Free radix tree */
+	if (max_size) {
+		last_blocknr = (max_size - 1) >> PAGE_SHIFT;
+		nova_delete_file_tree(sb, &sih, 0, last_blocknr,
+						false, false, 0);
+	}
+
+	finished[cpuid] = 1;
+	wake_up_interruptible(&finish_wq);
+	do_exit(ret);
+	return ret;
+}
+
+static int nova_failure_recovery_crawl(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info_header sih;
+	struct inode_table *inode_table;
+	struct task_ring *ring;
+	struct nova_inode *pi, fake_pi;
+	unsigned long curr_addr;
+	u64 root_addr;
+	u64 curr;
+	int num_tables;
+	int version;
+	int ret = 0;
+	int count;
+	int cpuid;
+
+	root_addr = nova_get_reserved_inode_addr(sb, NOVA_ROOT_INO);
+
+	num_tables = 1;
+	if (metadata_csum)
+		num_tables = 2;
+
+	for (cpuid = 0; cpuid < sbi->cpus; cpuid++) {
+		ring = &task_rings[cpuid];
+		for (version = 0; version < num_tables; version++) {
+			inode_table = nova_get_inode_table(sb, version,
+								cpuid);
+			if (!inode_table)
+				return -EINVAL;
+
+			count = 0;
+			curr = inode_table->log_head;
+			while (curr) {
+				if (ring->num >= 512) {
+					nova_err(sb, "%s: ring size too small\n",
+						 __func__);
+					return -EINVAL;
+				}
+
+				if (version == 0)
+					ring->addr0[count] = curr;
+				else
+					ring->addr1[count] = curr;
+
+				count++;
+
+				curr_addr = (unsigned long)nova_get_block(sb,
+								curr);
+				/* Next page resides at the last 8 bytes */
+				curr_addr += 2097152 - 8;
+				curr = *(u64 *)(curr_addr);
+			}
+
+			if (count > ring->num)
+				ring->num = count;
+		}
+	}
+
+	for (cpuid = 0; cpuid < sbi->cpus; cpuid++)
+		wake_up_process(threads[cpuid]);
+
+	nova_init_header(sb, &sih, 0);
+	/* Recover the root iode */
+	ret = nova_get_reference(sb, root_addr, &fake_pi,
+			(void **)&pi, sizeof(struct nova_inode));
+	if (ret) {
+		nova_dbg("Recover root pi failed\n");
+		return ret;
+	}
+
+	nova_recover_inode_pages(sb, &sih, &task_rings[0],
+					&fake_pi, global_bm[1]);
+
+	return ret;
+}
+
+int nova_failure_recovery(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct task_ring *ring;
+	struct nova_inode *pi;
+	struct journal_ptr_pair *pair;
+	int ret;
+	int i;
+
+	sbi->s_inodes_used_count = 0;
+
+	/* Initialize inuse inode list */
+	if (nova_init_inode_inuse_list(sb) < 0)
+		return -EINVAL;
+
+	/* Handle special inodes */
+	pi = nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
+	pi->log_head = pi->log_tail = 0;
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 0);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		pair = nova_get_journal_pointers(sb, i);
+
+		set_bm(pair->journal_head >> PAGE_SHIFT, global_bm[i], BM_4K);
+	}
+
+	i = NOVA_SNAPSHOT_INO % sbi->cpus;
+	pi = nova_get_inode_by_ino(sb, NOVA_SNAPSHOT_INO);
+	/* Set snapshot info log pages */
+	nova_traverse_dir_inode_log(sb, pi, global_bm[i]);
+
+	PERSISTENT_BARRIER();
+
+	ret = allocate_resources(sb, sbi->cpus);
+	if (ret)
+		return ret;
+
+	ret = nova_failure_recovery_crawl(sb);
+
+	wait_to_finish(sbi->cpus);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		ring = &task_rings[i];
+		sbi->s_inodes_used_count += ring->inodes_used_count;
+	}
+
+	free_resources(sb);
+
+	nova_dbg("Failure recovery total recovered %lu\n",
+				sbi->s_inodes_used_count);
+	return ret;
+}
+
+/*********************** Recovery entrance *************************/
+
+/* Return TRUE if we can do a normal unmount recovery */
+static bool nova_try_normal_recovery(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *pi =  nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
+	int ret;
+
+	if (pi->log_head == 0 || pi->log_tail == 0)
+		return false;
+
+	ret = nova_init_blockmap_from_inode(sb);
+	if (ret) {
+		nova_err(sb, "init blockmap failed, fall back to failure recovery\n");
+		return false;
+	}
+
+	ret = nova_init_inode_list_from_inode(sb);
+	if (ret) {
+		nova_err(sb, "init inode list failed, fall back to failure recovery\n");
+		nova_destroy_blocknode_trees(sb);
+		return false;
+	}
+
+	if (sbi->mount_snapshot == 0) {
+		ret = nova_restore_snapshot_table(sb, 0);
+		if (ret) {
+			nova_err(sb, "Restore snapshot table failed, fall back to failure recovery\n");
+			nova_destroy_snapshot_infos(sb);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+/*
+ * Recovery routine has three tasks:
+ * 1. Restore snapshot table;
+ * 2. Restore inuse inode list;
+ * 3. Restore the NVMM allocator.
+ */
+int nova_recovery(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_super_block *super = sbi->nova_sb;
+	unsigned long initsize = le64_to_cpu(super->s_size);
+	bool value = false;
+	int ret = 0;
+	timing_t start, end;
+
+	nova_dbgv("%s\n", __func__);
+
+	/* Always check recovery time */
+	if (measure_timing == 0)
+		getrawmonotonic(&start);
+
+	NOVA_START_TIMING(recovery_t, start);
+	sbi->num_blocks = ((unsigned long)(initsize) >> PAGE_SHIFT);
+
+	/* initialize free list info */
+	nova_init_blockmap(sb, 1);
+
+	value = nova_try_normal_recovery(sb);
+	if (value) {
+		nova_dbg("NOVA: Normal shutdown\n");
+	} else {
+		nova_dbg("NOVA: Failure recovery\n");
+		ret = alloc_bm(sb, initsize);
+		if (ret)
+			goto out;
+
+		if (sbi->mount_snapshot == 0) {
+			/* Initialize the snapshot infos */
+			ret = nova_restore_snapshot_table(sb, 1);
+			if (ret) {
+				nova_dbg("Initialize snapshot infos failed\n");
+				nova_destroy_snapshot_infos(sb);
+				goto out;
+			}
+		}
+
+		sbi->s_inodes_used_count = 0;
+		ret = nova_failure_recovery(sb);
+		if (ret)
+			goto out;
+
+		ret = nova_build_blocknode_map(sb, initsize);
+	}
+
+out:
+	NOVA_END_TIMING(recovery_t, start);
+	if (measure_timing == 0) {
+		getrawmonotonic(&end);
+		Timingstats[recovery_t] +=
+			(end.tv_sec - start.tv_sec) * 1000000000 +
+			(end.tv_nsec - start.tv_nsec);
+	}
+
+	if (!value)
+		free_bm(sb);
+
+	sbi->s_epoch_id = le64_to_cpu(super->s_epoch_id);
+	return ret;
+}
diff --git a/fs/nova/rebuild.c b/fs/nova/rebuild.c
new file mode 100644
index 000000000000..893f180d507e
--- /dev/null
+++ b/fs/nova/rebuild.c
@@ -0,0 +1,847 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Inode rebuild methods.
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
+/* entry given to this function is a copy in dram */
+static void nova_apply_setattr_entry(struct super_block *sb,
+	struct nova_inode_rebuild *reb,	struct nova_inode_info_header *sih,
+	struct nova_setattr_logentry *entry)
+{
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	unsigned long first_blocknr, last_blocknr;
+	loff_t start, end;
+	int freed = 0;
+
+	if (entry->entry_type != SET_ATTR)
+		BUG();
+
+	reb->i_mode	= entry->mode;
+	reb->i_uid	= entry->uid;
+	reb->i_gid	= entry->gid;
+	reb->i_atime	= entry->atime;
+
+	if (S_ISREG(reb->i_mode)) {
+		start = entry->size;
+		end = reb->i_size;
+
+		first_blocknr = (start + (1UL << data_bits) - 1) >> data_bits;
+
+		if (end > 0)
+			last_blocknr = (end - 1) >> data_bits;
+		else
+			last_blocknr = 0;
+
+		freed = nova_delete_file_tree(sb, sih, first_blocknr,
+					last_blocknr, false, false, 0);
+	}
+}
+
+/* entry given to this function is a copy in dram */
+static void nova_apply_link_change_entry(struct super_block *sb,
+	struct nova_inode_rebuild *reb,	struct nova_link_change_entry *entry)
+{
+	if (entry->entry_type != LINK_CHANGE)
+		BUG();
+
+	reb->i_links_count	= entry->links;
+	reb->i_ctime		= entry->ctime;
+	reb->i_flags		= entry->flags;
+	reb->i_generation	= entry->generation;
+
+	/* Do not flush now */
+}
+
+static void nova_update_inode_with_rebuild(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_inode *pi)
+{
+	pi->i_size = cpu_to_le64(reb->i_size);
+	pi->i_flags = cpu_to_le32(reb->i_flags);
+	pi->i_uid = cpu_to_le32(reb->i_uid);
+	pi->i_gid = cpu_to_le32(reb->i_gid);
+	pi->i_atime = cpu_to_le32(reb->i_atime);
+	pi->i_ctime = cpu_to_le32(reb->i_ctime);
+	pi->i_mtime = cpu_to_le32(reb->i_mtime);
+	pi->i_generation = cpu_to_le32(reb->i_generation);
+	pi->i_links_count = cpu_to_le16(reb->i_links_count);
+	pi->i_mode = cpu_to_le16(reb->i_mode);
+}
+
+static int nova_init_inode_rebuild(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_inode *pi)
+{
+	struct nova_inode fake_pi;
+	int rc;
+
+	rc = memcpy_mcsafe(&fake_pi, pi, sizeof(struct nova_inode));
+	if (rc)
+		return rc;
+
+	reb->i_size = le64_to_cpu(fake_pi.i_size);
+	reb->i_flags = le32_to_cpu(fake_pi.i_flags);
+	reb->i_uid = le32_to_cpu(fake_pi.i_uid);
+	reb->i_gid = le32_to_cpu(fake_pi.i_gid);
+	reb->i_atime = le32_to_cpu(fake_pi.i_atime);
+	reb->i_ctime = le32_to_cpu(fake_pi.i_ctime);
+	reb->i_mtime = le32_to_cpu(fake_pi.i_mtime);
+	reb->i_generation = le32_to_cpu(fake_pi.i_generation);
+	reb->i_links_count = le16_to_cpu(fake_pi.i_links_count);
+	reb->i_mode = le16_to_cpu(fake_pi.i_mode);
+	reb->trans_id = 0;
+
+	return rc;
+}
+
+static inline void nova_rebuild_file_time_and_size(struct super_block *sb,
+	struct nova_inode_rebuild *reb, u32 mtime, u32 ctime, u64 size)
+{
+	reb->i_mtime = cpu_to_le32(mtime);
+	reb->i_ctime = cpu_to_le32(ctime);
+	reb->i_size = cpu_to_le64(size);
+}
+
+static int nova_rebuild_inode_start(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct nova_inode_rebuild *reb, u64 pi_addr)
+{
+	int ret;
+
+	ret = nova_get_head_tail(sb, pi, sih);
+	if (ret)
+		return ret;
+
+	ret = nova_init_inode_rebuild(sb, reb, pi);
+	if (ret)
+		return ret;
+
+	sih->pi_addr = pi_addr;
+
+	nova_dbg_verbose("Log head 0x%llx, tail 0x%llx\n",
+				sih->log_head, sih->log_tail);
+	sih->log_pages = 1;
+
+	return ret;
+}
+
+static int nova_rebuild_inode_finish(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct nova_inode_rebuild *reb, u64 curr_p)
+{
+	struct nova_inode *alter_pi;
+	u64 next;
+
+	sih->i_size = le64_to_cpu(reb->i_size);
+	sih->i_mode = le64_to_cpu(reb->i_mode);
+	sih->trans_id = reb->trans_id + 1;
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode_with_rebuild(sb, reb, pi);
+	nova_update_inode_checksum(pi);
+	if (metadata_csum) {
+		alter_pi = (struct nova_inode *)nova_get_block(sb,
+							sih->alter_pi_addr);
+		memcpy_to_pmem_nocache(alter_pi, pi, sizeof(struct nova_inode));
+	}
+	nova_memlock_inode(sb, pi);
+
+	/* Keep traversing until log ends */
+	curr_p &= PAGE_MASK;
+	while ((next = next_log_page(sb, curr_p)) > 0) {
+		sih->log_pages++;
+		curr_p = next;
+	}
+
+	if (metadata_csum)
+		sih->log_pages *= 2;
+
+	return 0;
+}
+
+static int nova_reset_csum_parity_page(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long pgoff, int zero)
+{
+	nova_dbgv("%s: update page off %lu\n", __func__, pgoff);
+
+	if (data_csum)
+		nova_update_pgoff_csum(sb, sih, entry, pgoff, zero);
+
+	if (data_parity)
+		nova_update_pgoff_parity(sb, sih, entry, pgoff, zero);
+
+	return 0;
+}
+
+int nova_reset_csum_parity_range(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long start_pgoff, unsigned long end_pgoff, int zero,
+	int check_entry)
+{
+	struct nova_file_write_entry *curr;
+	unsigned long pgoff;
+
+	if (data_csum == 0 && data_parity == 0)
+		return 0;
+
+	for (pgoff = start_pgoff; pgoff < end_pgoff; pgoff++) {
+		if (entry && check_entry && zero == 0) {
+			curr = nova_get_write_entry(sb, sih, pgoff);
+			if (curr != entry)
+				continue;
+		}
+
+		/* FIXME: For mmap, check dirty? */
+		nova_reset_csum_parity_page(sb, sih, entry, pgoff, zero);
+	}
+
+	return 0;
+}
+
+/* Reset data csum for updating entries */
+static int nova_reset_data_csum_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	struct nova_file_write_entry *entryc)
+{
+	unsigned long end_pgoff;
+
+	if (data_csum == 0 && data_parity == 0)
+		goto out;
+
+	if (entryc->invalid_pages == entryc->num_pages)
+		/* Dead entry */
+		goto out;
+
+	end_pgoff = entryc->pgoff + entryc->num_pages;
+	nova_reset_csum_parity_range(sb, sih, entry, entryc->pgoff,
+			end_pgoff, 0, 1);
+
+out:
+	nova_set_write_entry_updating(sb, entry, 0);
+
+	return 0;
+}
+
+/* Reset data csum for mmap entries */
+static int nova_reset_mmap_csum_parity(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_mmap_entry *entry,
+	struct nova_mmap_entry *entryc)
+{
+	unsigned long end_pgoff;
+	int ret = 0;
+
+	if (data_csum == 0 && data_parity == 0)
+		return 0;
+
+	if (entryc->invalid == 1)
+		/* Dead entry */
+		return 0;
+
+	end_pgoff = entryc->pgoff + entryc->num_pages;
+	nova_reset_csum_parity_range(sb, sih, NULL, entryc->pgoff,
+			end_pgoff, 0, 0);
+
+	ret = nova_invalidate_logentry(sb, entry, MMAP_WRITE, 0);
+
+	return ret;
+}
+
+int nova_reset_mapping_csum_parity(struct super_block *sb,
+	struct inode *inode, struct address_space *mapping,
+	unsigned long start_pgoff, unsigned long end_pgoff)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	pgoff_t indices[PAGEVEC_SIZE];
+	struct pagevec pvec;
+	bool done = false;
+	int count = 0;
+	unsigned long start = 0;
+	timing_t reset_time;
+	int i;
+
+	if (data_csum == 0 && data_parity == 0)
+		return 0;
+
+	NOVA_START_TIMING(reset_mapping_t, reset_time);
+	nova_dbgv("%s: pgoff %lu to %lu\n",
+			__func__, start_pgoff, end_pgoff);
+
+	while (!done) {
+		pvec.nr = find_get_entries_tag(mapping, start_pgoff,
+				PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE,
+				pvec.pages, indices);
+
+		if (pvec.nr == 0)
+			break;
+
+		if (count == 0)
+			start = indices[0];
+
+		for (i = 0; i < pvec.nr; i++) {
+			if (indices[i] >= end_pgoff) {
+				done = true;
+				break;
+			}
+
+			NOVA_STATS_ADD(dirty_pages, 1);
+			nova_reset_csum_parity_page(sb, sih, NULL,
+						indices[i], 0);
+		}
+
+		count += pvec.nr;
+		if (pvec.nr < PAGEVEC_SIZE)
+			break;
+
+		start_pgoff = indices[pvec.nr - 1] + 1;
+	}
+
+	if (count)
+		nova_dbgv("%s: inode %lu, reset %d pages, start pgoff %lu\n",
+				__func__, sih->ino, count, start);
+
+	NOVA_END_TIMING(reset_mapping_t, reset_time);
+	return 0;
+}
+
+int nova_reset_vma_csum_parity(struct super_block *sb,
+	struct vma_item *item)
+{
+	struct vm_area_struct *vma = item->vma;
+	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct inode *inode = mapping->host;
+	struct nova_mmap_entry *entry;
+	unsigned long num_pages;
+	unsigned long start_index, end_index;
+	timing_t reset_time;
+	int ret = 0;
+
+	if (data_csum == 0 && data_parity == 0)
+		return 0;
+
+	NOVA_START_TIMING(reset_vma_t, reset_time);
+	num_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	start_index = vma->vm_pgoff;
+	end_index = vma->vm_pgoff + num_pages;
+
+	nova_dbgv("%s: inode %lu, pgoff %lu - %lu\n",
+			__func__, inode->i_ino, start_index, end_index);
+
+	ret = nova_reset_mapping_csum_parity(sb, inode, mapping,
+					start_index, end_index);
+
+	if (item->mmap_entry) {
+		entry = nova_get_block(sb, item->mmap_entry);
+		ret = nova_invalidate_logentry(sb, entry, MMAP_WRITE, 0);
+	}
+
+	NOVA_END_TIMING(reset_vma_t, reset_time);
+	return ret;
+}
+
+static void nova_rebuild_handle_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode_rebuild *reb,
+	struct nova_file_write_entry *entry,
+	struct nova_file_write_entry *entryc)
+{
+	if (entryc->num_pages != entryc->invalid_pages) {
+		/*
+		 * The overlaped blocks are already freed.
+		 * Don't double free them, just re-assign the pointers.
+		 */
+		nova_assign_write_entry(sb, sih, entry, entryc, false);
+	}
+
+	if (entryc->trans_id >= sih->trans_id) {
+		nova_rebuild_file_time_and_size(sb, reb,
+					entryc->mtime, entryc->mtime,
+					entryc->size);
+		reb->trans_id = entryc->trans_id;
+	}
+
+	if (entryc->updating)
+		nova_reset_data_csum_parity(sb, sih, entry, entryc);
+
+	/* Update sih->i_size for setattr apply operations */
+	sih->i_size = le64_to_cpu(reb->i_size);
+}
+
+static int nova_rebuild_file_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_file_write_entry *entry = NULL;
+	struct nova_setattr_logentry *attr_entry = NULL;
+	struct nova_link_change_entry *link_change_entry = NULL;
+	struct nova_mmap_entry *mmap_entry = NULL;
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	struct nova_inode_rebuild rebuild, *reb;
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	u64 ino = pi->nova_ino;
+	timing_t rebuild_time;
+	void *addr, *entryc;
+	u64 curr_p;
+	u8 type;
+	int ret;
+
+	NOVA_START_TIMING(rebuild_file_t, rebuild_time);
+	nova_dbg_verbose("Rebuild file inode %llu tree\n", ino);
+
+	reb = &rebuild;
+	ret = nova_rebuild_inode_start(sb, pi, sih, reb, pi_addr);
+	if (ret)
+		goto out;
+
+	curr_p = sih->log_head;
+	if (curr_p == 0 && sih->log_tail == 0)
+		goto out;
+
+	entryc = (metadata_csum == 0) ? NULL : entry_copy;
+
+//	nova_print_nova_log(sb, sih);
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			sih->log_pages++;
+			curr_p = next_log_page(sb, curr_p);
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "File inode %llu log is NULL!\n", ino);
+			BUG();
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+
+		if (metadata_csum == 0)
+			entryc = addr;
+		else if (!nova_verify_entry_csum(sb, addr, entryc))
+			return 0;
+
+		type = nova_get_entry_type(entryc);
+
+		if (sbi->mount_snapshot) {
+			if (nova_encounter_mount_snapshot(sb, addr, type))
+				break;
+		}
+
+		switch (type) {
+		case SET_ATTR:
+			attr_entry = (struct nova_setattr_logentry *)entryc;
+			nova_apply_setattr_entry(sb, reb, sih, attr_entry);
+			sih->last_setattr = curr_p;
+			if (attr_entry->trans_id >= reb->trans_id) {
+				nova_rebuild_file_time_and_size(sb, reb,
+							attr_entry->mtime,
+							attr_entry->ctime,
+							attr_entry->size);
+				reb->trans_id = attr_entry->trans_id;
+			}
+
+			/* Update sih->i_size for setattr operation */
+			sih->i_size = le64_to_cpu(reb->i_size);
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			link_change_entry =
+				(struct nova_link_change_entry *)entryc;
+			nova_apply_link_change_entry(sb, reb,
+						link_change_entry);
+			sih->last_link_change = curr_p;
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case FILE_WRITE:
+			entry = (struct nova_file_write_entry *)addr;
+			nova_rebuild_handle_write_entry(sb, sih, reb,
+					entry, WENTRY(entryc));
+			curr_p += sizeof(struct nova_file_write_entry);
+			break;
+		case MMAP_WRITE:
+			mmap_entry = (struct nova_mmap_entry *)addr;
+			nova_reset_mmap_csum_parity(sb, sih,
+					mmap_entry, MMENTRY(entryc));
+			curr_p += sizeof(struct nova_mmap_entry);
+			break;
+		default:
+			nova_err(sb, "unknown type %d, 0x%llx\n", type, curr_p);
+			NOVA_ASSERT(0);
+			curr_p += sizeof(struct nova_file_write_entry);
+			break;
+		}
+
+	}
+
+	ret = nova_rebuild_inode_finish(sb, pi, sih, reb, curr_p);
+	sih->i_blocks = sih->log_pages + (sih->i_size >> data_bits);
+
+out:
+//	nova_print_inode_log_page(sb, inode);
+	NOVA_END_TIMING(rebuild_file_t, rebuild_time);
+	return ret;
+}
+
+/******************* Directory rebuild *********************/
+
+static inline void nova_rebuild_dir_time_and_size(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_dentry *entry,
+	struct nova_dentry *entryc)
+{
+	if (!entry || !reb)
+		return;
+
+	reb->i_ctime = entryc->mtime;
+	reb->i_mtime = entryc->mtime;
+	reb->i_links_count = entryc->links_count;
+	//reb->i_size = entryc->size;
+}
+
+static void nova_reassign_last_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 curr_p)
+{
+	struct nova_dentry *dentry, *old_dentry;
+
+	if (sih->last_dentry == 0) {
+		sih->last_dentry = curr_p;
+	} else {
+		old_dentry = (struct nova_dentry *)nova_get_block(sb,
+							sih->last_dentry);
+		dentry = (struct nova_dentry *)nova_get_block(sb, curr_p);
+		if (dentry->trans_id >= old_dentry->trans_id)
+			sih->last_dentry = curr_p;
+	}
+}
+
+static inline int nova_replay_add_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_dentry *entry,
+	struct nova_dentry *entryc)
+{
+	if (!entryc->name_len)
+		return -EINVAL;
+
+	nova_dbg_verbose("%s: add %s\n", __func__, entry->name);
+	return nova_insert_dir_radix_tree(sb, sih,
+			entryc->name, entryc->name_len, entry);
+}
+
+/* entry given to this function is a copy in dram */
+static inline int nova_replay_remove_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_dentry *entry)
+{
+	nova_dbg_verbose("%s: remove %s\n", __func__, entry->name);
+	nova_remove_dir_radix_tree(sb, sih, entry->name,
+					entry->name_len, 1, NULL);
+	return 0;
+}
+
+static int nova_rebuild_handle_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode_rebuild *reb,
+	struct nova_dentry *entry, struct nova_dentry *entryc, u64 curr_p)
+{
+	int ret = 0;
+
+	nova_dbgv("curr_p: 0x%llx, type %d, ino %llu, name %s, namelen %u, csum 0x%x, rec len %u\n",
+			curr_p,
+			entry->entry_type, le64_to_cpu(entry->ino),
+			entry->name, entry->name_len, entry->csum,
+			le16_to_cpu(entry->de_len));
+
+	nova_reassign_last_dentry(sb, sih, curr_p);
+
+	if (entryc->invalid == 0) {
+		if (entryc->ino > 0)
+			ret = nova_replay_add_dentry(sb, sih, entry, entryc);
+		else
+			ret = nova_replay_remove_dentry(sb, sih, entryc);
+	}
+
+	if (ret) {
+		nova_err(sb, "%s ERROR %d\n", __func__, ret);
+		return ret;
+	}
+
+	if (entryc->trans_id >= reb->trans_id) {
+		nova_rebuild_dir_time_and_size(sb, reb, entry, entryc);
+		reb->trans_id = entryc->trans_id;
+	}
+
+	return ret;
+}
+
+int nova_rebuild_dir_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_dentry *entry = NULL;
+	struct nova_setattr_logentry *attr_entry = NULL;
+	struct nova_link_change_entry *lc_entry = NULL;
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	struct nova_inode_rebuild rebuild, *reb;
+	u64 ino = pi->nova_ino;
+	unsigned short de_len;
+	timing_t rebuild_time;
+	void *addr, *entryc;
+	u64 curr_p;
+	u8 type;
+	int ret;
+
+	NOVA_START_TIMING(rebuild_dir_t, rebuild_time);
+	nova_dbgv("Rebuild dir %llu tree\n", ino);
+
+	reb = &rebuild;
+	ret = nova_rebuild_inode_start(sb, pi, sih, reb, pi_addr);
+	if (ret)
+		goto out;
+
+	curr_p = sih->log_head;
+	if (curr_p == 0) {
+		nova_err(sb, "Dir %llu log is NULL!\n", ino);
+		BUG();
+		goto out;
+	}
+
+	entryc = (metadata_csum == 0) ? NULL : entry_copy;
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			sih->log_pages++;
+			curr_p = next_log_page(sb, curr_p);
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "Dir %llu log is NULL!\n", ino);
+			BUG();
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+
+		if (metadata_csum == 0)
+			entryc = addr;
+		else if (!nova_verify_entry_csum(sb, addr, entryc))
+			return 0;
+
+		type = nova_get_entry_type(entryc);
+
+		if (sbi->mount_snapshot) {
+			if (nova_encounter_mount_snapshot(sb, addr, type))
+				break;
+		}
+
+		switch (type) {
+		case SET_ATTR:
+			attr_entry = (struct nova_setattr_logentry *)entryc;
+			nova_apply_setattr_entry(sb, reb, sih, attr_entry);
+			sih->last_setattr = curr_p;
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			lc_entry = (struct nova_link_change_entry *)entryc;
+			if (lc_entry->trans_id >= reb->trans_id) {
+				nova_apply_link_change_entry(sb, reb, lc_entry);
+				reb->trans_id = lc_entry->trans_id;
+			}
+			sih->last_link_change = curr_p;
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case DIR_LOG:
+			entry = (struct nova_dentry *)addr;
+			ret = nova_rebuild_handle_dentry(sb, sih, reb,
+					entry, DENTRY(entryc), curr_p);
+			if (ret)
+				goto out;
+			de_len = le16_to_cpu(DENTRY(entryc)->de_len);
+			curr_p += de_len;
+			break;
+		default:
+			nova_dbg("%s: unknown type %d, 0x%llx\n",
+					__func__, type, curr_p);
+			NOVA_ASSERT(0);
+			break;
+		}
+	}
+
+	ret = nova_rebuild_inode_finish(sb, pi, sih, reb, curr_p);
+	sih->i_blocks = sih->log_pages;
+
+out:
+//	nova_print_dir_tree(sb, sih, ino);
+	NOVA_END_TIMING(rebuild_dir_t, rebuild_time);
+	return ret;
+}
+
+/* initialize nova inode header and other DRAM data structures */
+int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
+	u64 ino, u64 pi_addr, int rebuild_dir)
+{
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pi;
+	struct nova_inode inode_copy;
+	u64 alter_pi_addr = 0;
+	int ret;
+
+	if (metadata_csum) {
+		/* Get alternate inode address */
+		ret = nova_get_alter_inode_address(sb, ino, &alter_pi_addr);
+		if (ret)  {
+			nova_dbg("%s: failed alt ino addr for inode %llu\n",
+				 __func__, ino);
+			return ret;
+		}
+	}
+
+	ret = nova_check_inode_integrity(sb, ino, pi_addr, alter_pi_addr,
+					 &inode_copy, 1);
+
+	if (ret)
+		return ret;
+
+	pi = (struct nova_inode *)nova_get_block(sb, pi_addr);
+	// We need this te valid in case we need to evect the inode.
+	sih->pi_addr = pi_addr;
+
+	if (pi->deleted == 1) {
+		nova_dbg("%s: inode %llu has been deleted.\n", __func__, ino);
+		return -EINVAL;
+	}
+
+	nova_dbgv("%s: inode %llu, addr 0x%llx, valid %d, head 0x%llx, tail 0x%llx\n",
+			__func__, ino, pi_addr, pi->valid,
+			pi->log_head, pi->log_tail);
+
+	nova_init_header(sb, sih, __le16_to_cpu(pi->i_mode));
+	sih->ino = ino;
+	sih->alter_pi_addr = alter_pi_addr;
+
+	switch (__le16_to_cpu(pi->i_mode) & S_IFMT) {
+	case S_IFLNK:
+		/* Treat symlink files as normal files */
+		/* Fall through */
+	case S_IFREG:
+		nova_rebuild_file_inode_tree(sb, pi, pi_addr, sih);
+		break;
+	case S_IFDIR:
+		if (rebuild_dir)
+			nova_rebuild_dir_inode_tree(sb, pi, pi_addr, sih);
+		break;
+	default:
+		/* In case of special inode, walk the log */
+		if (pi->log_head)
+			nova_rebuild_file_inode_tree(sb, pi, pi_addr, sih);
+		sih->pi_addr = pi_addr;
+		break;
+	}
+
+	return 0;
+}
+
+
+/******************* Snapshot log rebuild *********************/
+
+/* For power failure recovery, just initialize the infos */
+int nova_restore_snapshot_table(struct super_block *sb, int just_init)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_snapshot_info_entry *entry = NULL;
+	struct nova_inode *pi;
+	struct nova_inode_info_header *sih;
+	struct nova_inode_rebuild rebuild, *reb;
+	unsigned int data_bits;
+	char entry_copy[NOVA_MAX_ENTRY_LEN];
+	size_t size = sizeof(struct nova_snapshot_info_entry);
+	u64 ino = NOVA_SNAPSHOT_INO;
+	timing_t rebuild_time;
+	int count = 0;
+	void *addr, *entryc;
+	u64 curr_p;
+	u8 type;
+	int ret;
+
+	NOVA_START_TIMING(rebuild_snapshot_t, rebuild_time);
+	nova_dbg_verbose("Rebuild snapshot table\n");
+
+	entryc = (metadata_csum == 0) ? NULL : entry_copy;
+
+	pi = nova_get_reserved_inode(sb, ino);
+	sih = &sbi->snapshot_si->header;
+	data_bits = blk_type_to_shift[sih->i_blk_type];
+	reb = &rebuild;
+	ret = nova_rebuild_inode_start(sb, pi, sih, reb, sih->pi_addr);
+	if (ret)
+		goto out;
+
+	curr_p = sih->log_head;
+	if (curr_p == 0 && sih->log_tail == 0)
+		goto out;
+
+//	nova_print_nova_log(sb, sih);
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			sih->log_pages++;
+			curr_p = next_log_page(sb, curr_p);
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "File inode %llu log is NULL!\n", ino);
+			BUG();
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+
+		if (metadata_csum == 0)
+			entryc = addr;
+		else if (!nova_verify_entry_csum(sb, addr, entryc))
+			return 0;
+
+		type = nova_get_entry_type(entryc);
+
+		switch (type) {
+		case SNAPSHOT_INFO:
+			entry = (struct nova_snapshot_info_entry *)addr;
+			ret = nova_restore_snapshot_entry(sb, entry,
+						curr_p, just_init);
+			if (ret) {
+				nova_err(sb, "Restore entry %llu failed\n",
+					entry->epoch_id);
+				goto out;
+			}
+			if (SNENTRY(entryc)->deleted == 0)
+				count++;
+			curr_p += size;
+			break;
+		default:
+			nova_err(sb, "unknown type %d, 0x%llx\n", type, curr_p);
+			NOVA_ASSERT(0);
+			curr_p += size;
+			break;
+		}
+
+	}
+
+	ret = nova_rebuild_inode_finish(sb, pi, sih, reb, curr_p);
+	sih->i_blocks = sih->log_pages + (sih->i_size >> data_bits);
+
+out:
+//	nova_print_inode_log_page(sb, inode);
+	NOVA_END_TIMING(rebuild_snapshot_t, rebuild_time);
+
+	nova_dbg("Recovered %d snapshots, latest epoch ID %llu\n",
+			count, sbi->s_epoch_id);
+
+	return ret;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
