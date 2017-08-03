Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2E8F209589F6
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:17 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id y129so793862pgy.3
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:49:29 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 11/16] NOVA: Snapshot support
Date: Thu, 03 Aug 2017 00:49:26 -0700
Message-ID: <150174656631.104003.11773390528493052782.stgit@hn>
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

Nova supports snapshots to facilitate backups.

Taking a snapshot
-----------------

Each Nova file systems has a current epoch_id in the super block and each log
entry has the epoch_id attached to it at creation.  When the user creates a
snaphot, Nova increments the epoch_id for the file system and the old epoch_id
identifies the moment the snapshot was taken.

Nova records the epoch_id and a timestamp in a new log entry (struct
snapshot_info_log_entry) and appends it to the log of the reserved snapshot
inode (NOVA_SNAPSHOT_INODE) in the superblock.

Nova also maintains a radix tree (nova_sb_info.snapshot_info_tree) of struct
snapshot_info in DRAM indexed by epoch_id.

Nova also marks all mmap'd pages as read-only and uses COW to preserve file
contents after the snapshot.

Tracking Live Data
------------------

Supporting snapshots requires Nova to preserve file contents from previous
snapshots while also being able to recover the space a snapshot occupied after
its deletion.

Preserving file contents requires a small change to how Nova implements write
operations.  To perform a write, Nova appends a write log entry to the file's
log.  The log entry includes pointers to newly-allocated and populated NVMM
pages that hold the written data.  If the write overwrites existing data, Nova
locates the previous write log entry for that portion of the file, and performs
an "epoch check" that compares the old log entry's epoch_id to the file
system's current epoch_id.  If the comparison matches, the old write log entry
and the file data blocks it points to no longer belong to any snapshot, and
Nova reclaims the data blocks.

If the epoch_id's do not match, then the data in the old log entry belongs to
an earlier snapshot and Nova leaves the log entry in place.

Determining when to reclaim data belonging to deleted snapshots requires
additional bookkeeping.  For each snapshot, Nova maintains a "snapshot log"
that records the inodes and blocks that belong to that snapshot, but are not
part of the current file system image.

Nova populates the snapshot log during the epoch check: If the epoch_ids for
the new and old log entries do not match, it appends a log entry (either struct
snapshot_inode_entry or struct snapshot_file_write_entry) to the snapshot log
that the old log entry belongs to.  The log entry contains a pointer to the old
log entry, and the filesystem's current epoch_id as the delete_epoch_id.

To delete a snapshot, Nova removes the snapshot from the list of live snapshots
and appends its log to the following snapshot's log.  Then, a background thread
traverses the combined log and reclaims dead inode/data based on the delete
epoch_id: If the delete epoch_id for an entry in the log is less than or equal
to the snapshot's epoch_id, it means the log entry and/or the associated data
blocks are now dead.



Snapshots and DAX
-----------------

Taking consistent snapshots while applications are modifying files using
DAX-style mmap requires NOVA to reckon with the order in which stores to NVMM
become persistent (i.e., reach physical NVMM so they will survive a system
failure).  These applications rely on the processor's memory persistence
model'' [http://dl.acm.org/citation.cfm?id=2665671.2665712] to make guarantees
about when and in what order stores become persistent.  These guarantees allow
the application to restore their data to a consistent state during recovery
from a system failure.

>>From the application's perspective, reading a snapshot is equivalent to
recovering from a system failure.  In both cases, the contents of the
memory-mapped file reflect its state at a moment when application operations
might be in-flight and when the application had no chance to shut down cleanly.

A naive approach to checkpointing mmap()'d files in NOVA would simply mark each
of the read/write mapped pages as read-only and then do copy-on-write when a
store occurs to preserve the old pages as part of the snapshot.

However, this approach can leave the snapshot in an inconsistent state:
Setting the page to read-only captures its contents for the
snapshot, and the kernel requires NOVA to set the pages as read-only
one at a time.  So, if the order in which NOVA marks pages as read-only
is incompatible with ordering that the application requires, the snapshot will
contain an inconsistent version of the file.

To resolve this problem, when NOVA starts marking pages as read-only, it blocks
page faults to the read-only mmap()'d pages until it has marked all the pages
read-only and finished taking the snapshot.

More detail is available in the technical report referenced at the top of this
document.

We have implemented this functionality in NOVA by adding the 'original_write'
flag to struct vm_area_struct that tracks whether the vm_area_struct is created
with write permission, but has been marked read-only in the course of taking a
snapshot.  We have also added a 'dax_cow' operation to struct
vm_operations_struct that the page fault handler runs when applications write
to a page with original_write = 1.  NOVA's dax_cow operation
(nova_restore_page_write()) performs the COW, maps the page to a new physical
page and allows writing.


Saving Snapshot State
---------------------

During a clean shutdown, Nova stores the snapshot information to PMEM.

Nova reserves an inode for storing snapshot information.  The log for the inode
contains an entry for each snapshot (struct snapshot_info_log_entry).  On
shutdown, Nova allocates one page (struct snapshot_nvmm_page) to store an array
of struct snapshot_nvmm_list.

Each of these lists (one per CPU) contains head and tail pointers to a linked
list of blocks (just like an inode log).  The lists contain a struct
snapshot_file_write_entry or struct snapshot_inode_entry for each operation
that modified file data or an inode.

Superblock
+--------------------+
|   ...              |
+--------------------+
| Reserved Inodes    |
+---+----------------+
|   |     ..         |
+---+----------------+
| 7 | Snapshot Inode |
|   | head           |
+---+----------------+
        /
       /
      /
+---------+---------+---------+
|  Snap   |  Snap   |  Snap   |
| epoch=1 | epoch=4 | epoch=11|
|         |         |         |
|nvmm_page|nvmm_page|nvmm_page|
+---------+---------+---------+
     |
     |
+----------+   +--------+--------+
|  cpu 0   |   | snap 	| snap   |
|   head   |-->| inode	| write	 |
|          |   | entry  | entry  |
|          |   +--------+--------+
+----------+   +--------+--------+
|  cpu 1   |   | snap 	| snap   |
|   head   |-->| write	| write	 |
|          |   | entry  | entry  |
|          |   +--------+--------+
+----------+
|    ...   |
+----------+   +--------+
|  cpu 128 |   | snap 	|
|   head   |-->| inode	|
|          |   | entry  |
|          |   +--------+
+----------+

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 arch/x86/mm/fault.c      |   11 
 fs/nova/snapshot.c       | 1407 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/snapshot.h       |   98 +++
 include/linux/mm.h       |    2 
 include/linux/mm_types.h |    3 
 mm/mprotect.c            |   13 
 6 files changed, 1533 insertions(+), 1 deletion(-)
 create mode 100644 fs/nova/snapshot.c
 create mode 100644 fs/nova/snapshot.h

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8ad91a01cbc8..34430601c7c0 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1431,6 +1431,17 @@ __do_page_fault(struct pt_regs *regs, unsigned long error_code,
 	 * we can handle it..
 	 */
 good_area:
+
+	if (error_code & PF_WRITE) {
+		/* write, present and write, not present: */
+		if (vma->original_write && vma->vm_ops &&
+					vma->vm_ops->dax_cow) {
+			up_read(&mm->mmap_sem);
+			vma->vm_ops->dax_cow(vma, address);
+			down_read(&mm->mmap_sem);
+		}
+	}
+
 	if (unlikely(access_error(error_code, vma))) {
 		bad_area_access_error(regs, error_code, address, vma);
 		return;
diff --git a/fs/nova/snapshot.c b/fs/nova/snapshot.c
new file mode 100644
index 000000000000..088b56c0d38c
--- /dev/null
+++ b/fs/nova/snapshot.c
@@ -0,0 +1,1407 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Snapshot support
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
+#include "super.h"
+
+static inline u64 next_list_page(u64 curr_p)
+{
+	void *curr_addr = (void *)curr_p;
+	unsigned long page_tail = ((unsigned long)curr_addr & ~PAGE_OFFSET_MASK)
+					+ LOG_BLOCK_TAIL;
+	return ((struct nova_inode_page_tail *)page_tail)->next_page;
+}
+
+static inline bool goto_next_list_page(struct super_block *sb, u64 curr_p)
+{
+	void *addr;
+	u8 type;
+
+	/* Each kind of entry takes at least 32 bytes */
+	if (ENTRY_LOC(curr_p) + 32 > LOG_BLOCK_TAIL)
+		return true;
+
+	addr = (void *)curr_p;
+	type = nova_get_entry_type(addr);
+	if (type == NEXT_PAGE)
+		return true;
+
+	return false;
+}
+
+static int nova_find_target_snapshot_info(struct super_block *sb,
+	u64 epoch_id, struct snapshot_info **ret_info)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *infos[1];
+	int nr_infos;
+	int ret = 0;
+
+	nr_infos = radix_tree_gang_lookup(&sbi->snapshot_info_tree,
+					(void **)infos, epoch_id, 1);
+	if (nr_infos == 1) {
+		*ret_info = infos[0];
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static struct snapshot_info *
+nova_find_next_snapshot_info(struct super_block *sb, struct snapshot_info *info)
+{
+	struct snapshot_info *ret_info = NULL;
+	int ret;
+
+	ret = nova_find_target_snapshot_info(sb, info->epoch_id + 1, &ret_info);
+
+	if (ret == 1 && ret_info->epoch_id <= info->epoch_id) {
+		nova_err(sb, "info epoch id %llu, next epoch id %llu\n",
+				info->epoch_id, ret_info->epoch_id);
+		ret_info = NULL;
+	}
+
+	return ret_info;
+}
+
+static int nova_insert_snapshot_info(struct super_block *sb,
+	struct snapshot_info *info)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int ret;
+
+	ret = radix_tree_insert(&sbi->snapshot_info_tree, info->epoch_id, info);
+	if (ret)
+		nova_dbg("%s ERROR %d\n", __func__, ret);
+
+	return ret;
+}
+
+/* Reuse the inode log page structure */
+static inline void nova_set_link_page_epoch_id(struct super_block *sb,
+	struct nova_inode_log_page *curr_page, u64 epoch_id)
+{
+	curr_page->page_tail.epoch_id = epoch_id;
+}
+
+/* Reuse the inode log page structure */
+static inline void nova_set_next_link_page_address(struct super_block *sb,
+	struct nova_inode_log_page *curr_page, u64 next_page)
+{
+	curr_page->page_tail.next_page = next_page;
+}
+
+static int nova_delete_snapshot_list_entries(struct super_block *sb,
+	struct snapshot_list *list)
+{
+	struct snapshot_file_write_entry *w_entry = NULL;
+	struct snapshot_inode_entry *i_entry = NULL;
+	struct nova_inode_info_header sih;
+	void *addr;
+	u64 curr_p;
+	u8 type;
+
+	sih.ino = NOVA_SNAPSHOT_INO;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+	sih.log_head = sih.log_tail = 0;
+
+	curr_p = list->head;
+	nova_dbg_verbose("Snapshot list head 0x%llx, tail 0x%lx\n",
+				curr_p, list->tail);
+	if (curr_p == 0 && list->tail == 0)
+		return 0;
+
+	while (curr_p != list->tail) {
+		if (goto_next_list_page(sb, curr_p)) {
+			curr_p = next_list_page(curr_p);
+			if (curr_p == list->tail)
+				break;
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "Snapshot list is NULL!\n");
+			BUG();
+		}
+
+		addr = (void *)curr_p;
+		type = nova_get_entry_type(addr);
+
+		switch (type) {
+		case SS_INODE:
+			i_entry = (struct snapshot_inode_entry *)addr;
+			if (i_entry->deleted == 0)
+				nova_delete_dead_inode(sb, i_entry->nova_ino);
+			curr_p += sizeof(struct snapshot_inode_entry);
+			continue;
+		case SS_FILE_WRITE:
+			w_entry = (struct snapshot_file_write_entry *)addr;
+			if (w_entry->deleted == 0)
+				nova_free_data_blocks(sb, &sih, w_entry->nvmm,
+							w_entry->num_pages);
+			curr_p += sizeof(struct snapshot_file_write_entry);
+			continue;
+		default:
+			nova_err(sb, "unknown type %d, 0x%llx, tail 0x%llx\n",
+					type, curr_p, list->tail);
+			NOVA_ASSERT(0);
+			curr_p += sizeof(struct snapshot_file_write_entry);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+static inline int nova_background_clean_inode_entry(struct super_block *sb,
+	struct snapshot_inode_entry *i_entry, u64 epoch_id)
+{
+	if (i_entry->deleted == 0 && i_entry->delete_epoch_id <= epoch_id) {
+		nova_delete_dead_inode(sb, i_entry->nova_ino);
+		i_entry->deleted = 1;
+	}
+
+	return 0;
+}
+
+static inline int nova_background_clean_write_entry(struct super_block *sb,
+	struct snapshot_file_write_entry *w_entry,
+	struct nova_inode_info_header *sih, u64 epoch_id)
+{
+	if (w_entry->deleted == 0 && w_entry->delete_epoch_id <= epoch_id) {
+		nova_free_data_blocks(sb, sih, w_entry->nvmm,
+					w_entry->num_pages);
+		w_entry->deleted = 1;
+	}
+
+	return 0;
+}
+
+static int nova_background_clean_snapshot_list(struct super_block *sb,
+	struct snapshot_list *list, u64 epoch_id)
+{
+	struct nova_inode_log_page *curr_page;
+	struct nova_inode_info_header sih;
+	void *addr;
+	u64 curr_p;
+	u8 type;
+
+	sih.ino = NOVA_SNAPSHOT_INO;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+	sih.log_head = sih.log_tail = 0;
+
+	curr_p = list->head;
+	nova_dbg_verbose("Snapshot list head 0x%llx, tail 0x%lx\n",
+				curr_p, list->tail);
+	if (curr_p == 0 && list->tail == 0)
+		return 0;
+
+	curr_page = (struct nova_inode_log_page *)curr_p;
+	while (curr_page->page_tail.epoch_id < epoch_id &&
+					curr_p != list->tail) {
+		if (goto_next_list_page(sb, curr_p)) {
+			curr_p = next_list_page(curr_p);
+			if (curr_p == list->tail)
+				break;
+			curr_page = (struct nova_inode_log_page *)curr_p;
+			if (curr_page->page_tail.epoch_id == epoch_id)
+				break;
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "Snapshot list is NULL!\n");
+			BUG();
+		}
+
+		addr = (void *)curr_p;
+		type = nova_get_entry_type(addr);
+
+		switch (type) {
+		case SS_INODE:
+			nova_background_clean_inode_entry(sb, addr, epoch_id);
+			curr_p += sizeof(struct snapshot_inode_entry);
+			continue;
+		case SS_FILE_WRITE:
+			nova_background_clean_write_entry(sb, addr, &sih,
+								epoch_id);
+			curr_p += sizeof(struct snapshot_file_write_entry);
+			continue;
+		default:
+			nova_err(sb, "unknown type %d, 0x%llx, tail 0x%llx\n",
+					type, curr_p, list->tail);
+			NOVA_ASSERT(0);
+			curr_p += sizeof(struct snapshot_file_write_entry);
+			continue;
+		}
+	}
+
+	return 0;
+}
+
+static int nova_delete_snapshot_list_pages(struct super_block *sb,
+	struct snapshot_list *list)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 curr_block = list->head;
+	int freed = 0;
+
+	while (curr_block) {
+		if (ENTRY_LOC(curr_block)) {
+			nova_dbg("%s: ERROR: invalid block %llu\n",
+					__func__, curr_block);
+			break;
+		}
+		curr_page = (struct nova_inode_log_page *)curr_block;
+		curr_block = curr_page->page_tail.next_page;
+		kfree(curr_page);
+		freed++;
+	}
+
+	return freed;
+}
+
+static int nova_delete_snapshot_list(struct super_block *sb,
+	struct snapshot_list *list, int delete_entries)
+{
+	if (delete_entries)
+		nova_delete_snapshot_list_entries(sb, list);
+	nova_delete_snapshot_list_pages(sb, list);
+	return 0;
+}
+
+static int nova_delete_snapshot_info(struct super_block *sb,
+	struct snapshot_info *info, int delete_entries)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_list *list;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		mutex_lock(&list->list_mutex);
+		nova_delete_snapshot_list(sb, list, delete_entries);
+		mutex_unlock(&list->list_mutex);
+	}
+
+	kfree(info->lists);
+	return 0;
+}
+
+static int nova_initialize_snapshot_info_pages(struct super_block *sb,
+	struct snapshot_info *info, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_list *list;
+	unsigned long new_page = 0;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		new_page = (unsigned long)kmalloc(PAGE_SIZE,
+							GFP_KERNEL);
+		/* Aligned to PAGE_SIZE */
+		if (!new_page || ENTRY_LOC(new_page)) {
+			nova_dbg("%s: failed\n", __func__);
+			kfree((void *)new_page);
+			return -ENOMEM;
+		}
+
+		nova_set_link_page_epoch_id(sb, (void *)new_page, epoch_id);
+		nova_set_next_link_page_address(sb, (void *)new_page, 0);
+		list->tail = list->head = new_page;
+		list->num_pages = 1;
+	}
+
+	return 0;
+}
+
+static int nova_initialize_snapshot_info(struct super_block *sb,
+	struct snapshot_info **ret_info, int init_pages, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info;
+	struct snapshot_list *list;
+	int i;
+	int ret;
+	timing_t init_snapshot_time;
+
+	NOVA_START_TIMING(init_snapshot_info_t, init_snapshot_time);
+
+	info = nova_alloc_snapshot_info(sb);
+	if (!info) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	info->lists = kzalloc(sbi->cpus * sizeof(struct snapshot_list),
+							GFP_KERNEL);
+
+	if (!info->lists) {
+		nova_free_snapshot_info(info);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		mutex_init(&list->list_mutex);
+	}
+
+	if (init_pages) {
+		ret = nova_initialize_snapshot_info_pages(sb, info, epoch_id);
+		if (ret)
+			goto fail;
+	}
+
+	*ret_info = info;
+out:
+	NOVA_END_TIMING(init_snapshot_info_t, init_snapshot_time);
+	return ret;
+
+fail:
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		if (list->head)
+			kfree((void *)list->head);
+	}
+
+	kfree(info->lists);
+	nova_free_snapshot_info(info);
+
+	*ret_info = NULL;
+	goto out;
+}
+
+static void nova_write_snapshot_list_entry(struct super_block *sb,
+	struct snapshot_list *list, u64 curr_p, void *entry, size_t size)
+{
+	if (is_last_entry(curr_p, size)) {
+		nova_err(sb, "%s: write to page end? curr 0x%llx, size %lu\n",
+				__func__, curr_p, size);
+		return;
+	}
+
+	memcpy((void *)curr_p, entry, size);
+	list->tail = curr_p + size;
+}
+
+static int nova_append_snapshot_list_entry(struct super_block *sb,
+	struct snapshot_info *info, void *entry, size_t size)
+{
+	struct snapshot_list *list;
+	struct nova_inode_log_page *curr_page;
+	u64 curr_block;
+	int cpuid;
+	u64 curr_p;
+	u64 new_page = 0;
+
+	cpuid = smp_processor_id();
+	list = &info->lists[cpuid];
+
+retry:
+	mutex_lock(&list->list_mutex);
+	curr_p = list->tail;
+
+	if (new_page) {
+		/* Link prev block and newly allocated page */
+		curr_block = BLOCK_OFF(curr_p);
+		curr_page = (struct nova_inode_log_page *)curr_block;
+		nova_set_next_link_page_address(sb, curr_page, new_page);
+		list->num_pages++;
+	}
+
+	if ((is_last_entry(curr_p, size) && next_list_page(curr_p) == 0)) {
+		nova_set_entry_type((void *)curr_p, NEXT_PAGE);
+		if (new_page == 0) {
+			mutex_unlock(&list->list_mutex);
+			new_page = (unsigned long)kmalloc(PAGE_SIZE,
+						GFP_KERNEL);
+			if (!new_page || ENTRY_LOC(new_page)) {
+				kfree((void *)new_page);
+				nova_err(sb, "%s: allocation failed\n",
+						__func__);
+				return -ENOMEM;
+			}
+			nova_set_link_page_epoch_id(sb, (void *)new_page,
+						info->epoch_id);
+			nova_set_next_link_page_address(sb,
+						(void *)new_page, 0);
+			goto retry;
+		}
+	}
+
+	if (is_last_entry(curr_p, size)) {
+		nova_set_entry_type((void *)curr_p, NEXT_PAGE);
+		curr_p = next_list_page(curr_p);
+	}
+
+	nova_write_snapshot_list_entry(sb, list, curr_p, entry, size);
+	mutex_unlock(&list->list_mutex);
+
+	return 0;
+}
+
+/*
+ * An entry is deleteable if
+ * 1) It is created after the last snapshot, or
+ * 2) It is created and deleted during the same snapshot period.
+ */
+static int nova_old_entry_deleteable(struct super_block *sb,
+	u64 create_epoch_id, u64 delete_epoch_id,
+	struct snapshot_info **ret_info)
+{
+	struct snapshot_info *info = NULL;
+	int ret;
+
+	if (create_epoch_id == delete_epoch_id) {
+		/* Create and delete in the same epoch */
+		return 1;
+	}
+
+	ret = nova_find_target_snapshot_info(sb, create_epoch_id, &info);
+	if (ret == 0) {
+		/* Old entry does not belong to any snapshot */
+		return 1;
+	}
+
+	if (info->epoch_id >= delete_epoch_id) {
+		/* Create and delete in different epoch but same snapshot */
+		return 1;
+	}
+
+	*ret_info = info;
+	return 0;
+}
+
+static int nova_append_snapshot_file_write_entry(struct super_block *sb,
+	struct snapshot_info *info, u64 nvmm, u64 num_pages,
+	u64 delete_epoch_id)
+{
+	struct snapshot_file_write_entry entry;
+	int ret;
+	timing_t append_time;
+
+	if (!info) {
+		nova_dbg("%s: Snapshot info not found\n", __func__);
+		return -EINVAL;
+	}
+
+	NOVA_START_TIMING(append_snapshot_file_t, append_time);
+	nova_dbgv("Append file write entry: block %llu, %llu pages, delete epoch ID %llu to Snapshot epoch ID %llu\n",
+			nvmm, num_pages, delete_epoch_id,
+			info->epoch_id);
+
+	memset(&entry, 0, sizeof(struct snapshot_file_write_entry));
+	entry.type = SS_FILE_WRITE;
+	entry.deleted = 0;
+	entry.nvmm = nvmm;
+	entry.num_pages = num_pages;
+	entry.delete_epoch_id = delete_epoch_id;
+
+	ret = nova_append_snapshot_list_entry(sb, info, &entry,
+			sizeof(struct snapshot_file_write_entry));
+
+	NOVA_END_TIMING(append_snapshot_file_t, append_time);
+	return ret;
+}
+
+/* entry given to this function is a copy in dram */
+int nova_append_data_to_snapshot(struct super_block *sb,
+	struct nova_file_write_entry *entry, u64 nvmm, u64 num_pages,
+	u64 delete_epoch_id)
+{
+	struct snapshot_info *info = NULL;
+	int ret;
+
+	ret = nova_old_entry_deleteable(sb, entry->epoch_id,
+					delete_epoch_id, &info);
+	if (ret == 0)
+		nova_append_snapshot_file_write_entry(sb, info, nvmm,
+					num_pages, delete_epoch_id);
+
+	return ret;
+}
+
+static int nova_append_snapshot_inode_entry(struct super_block *sb,
+	struct nova_inode *pi, struct snapshot_info *info)
+{
+	struct snapshot_inode_entry entry;
+	int ret;
+	timing_t append_time;
+
+	if (!info) {
+		nova_dbg("%s: Snapshot info not found\n", __func__);
+		return -EINVAL;
+	}
+
+	NOVA_START_TIMING(append_snapshot_inode_t, append_time);
+	nova_dbgv("Append inode entry: inode %llu, delete epoch ID %llu to Snapshot epoch ID %llu\n",
+			pi->nova_ino, pi->delete_epoch_id,
+			info->epoch_id);
+
+	memset(&entry, 0, sizeof(struct snapshot_inode_entry));
+	entry.type = SS_INODE;
+	entry.deleted = 0;
+	entry.nova_ino = pi->nova_ino;
+	entry.delete_epoch_id = pi->delete_epoch_id;
+
+	ret = nova_append_snapshot_list_entry(sb, info, &entry,
+			sizeof(struct snapshot_inode_entry));
+
+	NOVA_END_TIMING(append_snapshot_inode_t, append_time);
+	return ret;
+}
+
+int nova_append_inode_to_snapshot(struct super_block *sb,
+	struct nova_inode *pi)
+{
+	struct snapshot_info *info = NULL;
+	int ret;
+
+	ret = nova_old_entry_deleteable(sb, pi->create_epoch_id,
+					pi->delete_epoch_id, &info);
+	if (ret == 0)
+		nova_append_snapshot_inode_entry(sb, pi, info);
+
+	return ret;
+}
+
+int nova_encounter_mount_snapshot(struct super_block *sb, void *addr,
+	u8 type)
+{
+	struct nova_dentry *dentry;
+	struct nova_setattr_logentry *attr_entry;
+	struct nova_link_change_entry *linkc_entry;
+	struct nova_file_write_entry *fw_entry;
+	struct nova_mmap_entry *mmap_entry;
+	int ret = 0;
+
+	switch (type) {
+	case SET_ATTR:
+		attr_entry = (struct nova_setattr_logentry *)addr;
+		if (pass_mount_snapshot(sb, attr_entry->epoch_id))
+			ret = 1;
+		break;
+	case LINK_CHANGE:
+		linkc_entry = (struct nova_link_change_entry *)addr;
+		if (pass_mount_snapshot(sb, linkc_entry->epoch_id))
+			ret = 1;
+		break;
+	case DIR_LOG:
+		dentry = (struct nova_dentry *)addr;
+		if (pass_mount_snapshot(sb, dentry->epoch_id))
+			ret = 1;
+		break;
+	case FILE_WRITE:
+		fw_entry = (struct nova_file_write_entry *)addr;
+		if (pass_mount_snapshot(sb, fw_entry->epoch_id))
+			ret = 1;
+		break;
+	case MMAP_WRITE:
+		mmap_entry = (struct nova_mmap_entry *)addr;
+		if (pass_mount_snapshot(sb, mmap_entry->epoch_id))
+			ret = 1;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int nova_copy_snapshot_list_to_dram(struct super_block *sb,
+	struct snapshot_list *list, struct snapshot_nvmm_list *nvmm_list)
+{
+	struct nova_inode_log_page *dram_page;
+	void *curr_nvmm_addr;
+	u64 curr_nvmm_block;
+	u64 prev_dram_addr;
+	u64 curr_dram_addr;
+	unsigned long i;
+	int ret;
+
+	curr_dram_addr = list->head;
+	prev_dram_addr = list->head;
+	curr_nvmm_block = nvmm_list->head;
+	curr_nvmm_addr = nova_get_block(sb, curr_nvmm_block);
+
+	for (i = 0; i < nvmm_list->num_pages; i++) {
+		/* Leave next_page field alone */
+		ret = memcpy_mcsafe((void *)curr_dram_addr, curr_nvmm_addr,
+						LOG_BLOCK_TAIL);
+
+		if (ret < 0) {
+			nova_dbg("%s: Copy nvmm page %lu failed\n",
+					__func__, i);
+			continue;
+		}
+
+		dram_page = (struct nova_inode_log_page *)curr_dram_addr;
+		prev_dram_addr = curr_dram_addr;
+		curr_nvmm_block = next_log_page(sb, curr_nvmm_block);
+		if (curr_nvmm_block < 0)
+			break;
+		curr_nvmm_addr = nova_get_block(sb, curr_nvmm_block);
+		curr_dram_addr = dram_page->page_tail.next_page;
+	}
+
+	list->num_pages = nvmm_list->num_pages;
+	list->tail = prev_dram_addr + ENTRY_LOC(nvmm_list->tail);
+
+	return 0;
+}
+
+static int nova_allocate_snapshot_list_pages(struct super_block *sb,
+	struct snapshot_list *list, struct snapshot_nvmm_list *nvmm_list,
+	u64 epoch_id)
+{
+	unsigned long prev_page = 0;
+	unsigned long new_page = 0;
+	unsigned long i;
+
+	for (i = 0; i < nvmm_list->num_pages; i++) {
+		new_page = (unsigned long)kmalloc(PAGE_SIZE,
+							GFP_KERNEL);
+
+		if (!new_page) {
+			nova_dbg("%s ERROR: fail to allocate list pages\n",
+					__func__);
+			goto fail;
+		}
+
+		nova_set_link_page_epoch_id(sb, (void *)new_page, epoch_id);
+		nova_set_next_link_page_address(sb, (void *)new_page, 0);
+
+		if (i == 0)
+			list->head = new_page;
+
+		if (prev_page)
+			nova_set_next_link_page_address(sb, (void *)prev_page,
+							new_page);
+		prev_page = new_page;
+	}
+
+	return 0;
+
+fail:
+	nova_delete_snapshot_list_pages(sb, list);
+	return -ENOMEM;
+}
+
+static int nova_restore_snapshot_info_lists(struct super_block *sb,
+	struct snapshot_info *info, struct nova_snapshot_info_entry *entry,
+	u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_nvmm_page *nvmm_page;
+	struct snapshot_list *list;
+	struct snapshot_nvmm_list *nvmm_list;
+	int i;
+	int ret;
+
+	nvmm_page = (struct snapshot_nvmm_page *)nova_get_block(sb,
+						entry->nvmm_page_addr);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		nvmm_list = &nvmm_page->lists[i];
+		if (!list || !nvmm_list) {
+			nova_dbg("%s: list NULL? list %p, nvmm list %p\n",
+					__func__, list, nvmm_list);
+			continue;
+		}
+
+		ret = nova_allocate_snapshot_list_pages(sb, list,
+						nvmm_list, info->epoch_id);
+		if (ret) {
+			nova_dbg("%s failure\n", __func__);
+			return ret;
+		}
+		nova_copy_snapshot_list_to_dram(sb, list, nvmm_list);
+	}
+
+	return 0;
+}
+
+static int nova_restore_snapshot_info(struct super_block *sb,
+	struct nova_snapshot_info_entry *entry, u64 epoch_id,
+	u64 timestamp, u64 curr_p, int just_init)
+{
+	struct snapshot_info *info = NULL;
+	int ret = 0;
+
+	nova_dbg("Restore snapshot epoch ID %llu\n", epoch_id);
+
+	/* Allocate list pages on demand later */
+	ret = nova_initialize_snapshot_info(sb, &info, just_init, epoch_id);
+	if (ret) {
+		nova_dbg("%s: initialize snapshot info failed %d\n",
+				__func__, ret);
+		goto fail;
+	}
+
+	info->epoch_id = epoch_id;
+	info->timestamp = timestamp;
+	info->snapshot_entry = curr_p;
+
+	if (just_init == 0) {
+		ret = nova_restore_snapshot_info_lists(sb, info,
+							entry, epoch_id);
+		if (ret)
+			goto fail;
+	}
+
+	ret = nova_insert_snapshot_info(sb, info);
+	return ret;
+
+fail:
+	nova_delete_snapshot_info(sb, info, 0);
+	return ret;
+}
+
+int nova_mount_snapshot(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 epoch_id;
+
+	epoch_id = sbi->mount_snapshot_epoch_id;
+	nova_dbg("Mount snapshot %llu\n", epoch_id);
+	return 0;
+}
+
+static int nova_free_nvmm_page(struct super_block *sb,
+	u64 nvmm_page_addr)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_nvmm_page *nvmm_page;
+	struct snapshot_nvmm_list *nvmm_list;
+	struct nova_inode_info_header sih;
+	unsigned long nvmm_blocknr;
+	int i;
+
+	if (nvmm_page_addr == 0)
+		return 0;
+
+	sih.ino = NOVA_SNAPSHOT_INO;
+	sih.i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+
+	nvmm_page = (struct snapshot_nvmm_page *)nova_get_block(sb,
+						nvmm_page_addr);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		nvmm_list = &nvmm_page->lists[i];
+		sih.log_head = nvmm_list->head;
+		sih.log_tail = nvmm_list->tail;
+		sih.alter_log_head = sih.alter_log_tail = 0;
+		nova_free_inode_log(sb, NULL, &sih);
+	}
+
+	nvmm_blocknr = nova_get_blocknr(sb, nvmm_page_addr, 0);
+	nova_free_log_blocks(sb, &sih, nvmm_blocknr, 1);
+	return 0;
+}
+
+static int nova_set_nvmm_page_addr(struct super_block *sb,
+	struct nova_snapshot_info_entry *entry, u64 nvmm_page_addr)
+{
+	nova_memunlock_range(sb, entry, CACHELINE_SIZE);
+	entry->nvmm_page_addr = nvmm_page_addr;
+	nova_update_entry_csum(entry);
+	nova_update_alter_entry(sb, entry);
+	nova_memlock_range(sb, entry, CACHELINE_SIZE);
+
+	return 0;
+}
+
+static int nova_clear_nvmm_page(struct super_block *sb,
+	struct nova_snapshot_info_entry *entry, int just_init)
+{
+	if (just_init)
+		/* No need to free because we do not set the bitmap. */
+		goto out;
+
+	nova_free_nvmm_page(sb, entry->nvmm_page_addr);
+
+out:
+	nova_set_nvmm_page_addr(sb, entry, 0);
+	return 0;
+}
+
+int nova_restore_snapshot_entry(struct super_block *sb,
+	struct nova_snapshot_info_entry *entry, u64 curr_p, int just_init)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 epoch_id, timestamp;
+	int ret = 0;
+
+	if (entry->deleted == 1)
+		goto out;
+
+	epoch_id = entry->epoch_id;
+	timestamp = entry->timestamp;
+
+	ret = nova_restore_snapshot_info(sb, entry, epoch_id,
+					timestamp, curr_p, just_init);
+	if (ret) {
+		nova_dbg("%s: Restore snapshot epoch ID %llu failed\n",
+				__func__, epoch_id);
+		goto out;
+	}
+
+	if (epoch_id > sbi->s_epoch_id)
+		sbi->s_epoch_id = epoch_id;
+
+out:
+	nova_clear_nvmm_page(sb, entry, just_init);
+
+	return ret;
+}
+
+static int nova_append_snapshot_info_log(struct super_block *sb,
+	struct snapshot_info *info, u64 epoch_id, u64 timestamp)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info *si = sbi->snapshot_si;
+	struct nova_inode *pi = nova_get_reserved_inode(sb, NOVA_SNAPSHOT_INO);
+	struct nova_inode_update update;
+	struct nova_snapshot_info_entry entry_info;
+	int ret;
+
+	entry_info.type = SNAPSHOT_INFO;
+	entry_info.deleted = 0;
+	entry_info.nvmm_page_addr = 0;
+	entry_info.epoch_id = epoch_id;
+	entry_info.timestamp = timestamp;
+
+	update.tail = update.alter_tail = 0;
+	ret = nova_append_snapshot_info_entry(sb, pi, si, info,
+					&entry_info, &update);
+	if (ret) {
+		nova_dbg("%s: append snapshot info entry failure\n", __func__);
+		return ret;
+	}
+
+	nova_memunlock_inode(sb, pi);
+	nova_update_inode(sb, &si->vfs_inode, pi, &update, 1);
+	nova_memlock_inode(sb, pi);
+
+	return 0;
+}
+
+int nova_create_snapshot(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info = NULL;
+	u64 timestamp = 0;
+	u64 epoch_id;
+	int ret;
+	timing_t create_snapshot_time;
+
+	NOVA_START_TIMING(create_snapshot_t, create_snapshot_time);
+
+	mutex_lock(&sbi->s_lock);
+	sbi->snapshot_taking = 1;
+
+	/* Increase the epoch id, but use the old value as snapshot id */
+	epoch_id = sbi->s_epoch_id++;
+
+	/*
+	 * Mark the create_snapshot_epoch_id before starting the snapshot
+	 * creation. We will check this during in-place updates for metadata
+	 * and data, to prevent overwriting logs that might belong to a
+	 * snapshot that is being created.
+	 */
+	nova_info("%s: epoch id %llu\n", __func__, epoch_id);
+
+
+	timestamp = timespec_trunc(current_kernel_time(),
+				   sb->s_time_gran).tv_sec;
+
+	ret = nova_initialize_snapshot_info(sb, &info, 1, epoch_id);
+	if (ret) {
+		nova_dbg("%s: initialize snapshot info failed %d\n",
+				__func__, ret);
+		NOVA_END_TIMING(create_snapshot_t, create_snapshot_time);
+		goto out;
+	}
+
+	info->epoch_id = epoch_id;
+	info->timestamp = timestamp;
+
+	ret = nova_append_snapshot_info_log(sb, info, epoch_id, timestamp);
+	if (ret) {
+		nova_free_snapshot_info(info);
+		NOVA_END_TIMING(create_snapshot_t, create_snapshot_time);
+		goto out;
+	}
+
+	sbi->num_snapshots++;
+
+	ret = nova_insert_snapshot_info(sb, info);
+
+	nova_set_vmas_readonly(sb);
+
+	sbi->nova_sb->s_wtime = cpu_to_le32(get_seconds());
+	sbi->nova_sb->s_epoch_id = cpu_to_le64(epoch_id);
+	nova_update_super_crc(sb);
+
+	nova_sync_super(sb);
+
+out:
+	sbi->snapshot_taking = 0;
+	mutex_unlock(&sbi->s_lock);
+	wake_up_interruptible(&sbi->snapshot_mmap_wait);
+
+	NOVA_END_TIMING(create_snapshot_t, create_snapshot_time);
+	return ret;
+}
+
+static void wakeup_snapshot_cleaner(struct nova_sb_info *sbi)
+{
+	if (!waitqueue_active(&sbi->snapshot_cleaner_wait))
+		return;
+
+	nova_dbg("Wakeup snapshot cleaner thread\n");
+	wake_up_interruptible(&sbi->snapshot_cleaner_wait);
+}
+
+static int nova_link_to_next_snapshot(struct super_block *sb,
+	struct snapshot_info *prev_info, struct snapshot_info *next_info)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_list *prev_list, *next_list;
+	struct nova_inode_log_page *curr_page;
+	u64 curr_block, curr_p;
+	int i;
+
+	nova_dbg("Link deleted snapshot %llu to next snapshot %llu\n",
+			prev_info->epoch_id, next_info->epoch_id);
+
+	if (prev_info->epoch_id >= next_info->epoch_id)
+		nova_dbg("Error: prev epoch ID %llu higher than next epoch ID %llu\n",
+			prev_info->epoch_id, next_info->epoch_id);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		prev_list = &prev_info->lists[i];
+		next_list = &next_info->lists[i];
+
+		mutex_lock(&prev_list->list_mutex);
+		mutex_lock(&next_list->list_mutex);
+
+		/* Set NEXT_PAGE flag for prev lists */
+		curr_p = prev_list->tail;
+		if (!goto_next_list_page(sb, curr_p))
+			nova_set_entry_type((void *)curr_p, NEXT_PAGE);
+
+		/* Link the prev lists to the head of next lists */
+		curr_block = BLOCK_OFF(prev_list->tail);
+		curr_page = (struct nova_inode_log_page *)curr_block;
+		nova_set_next_link_page_address(sb, curr_page, next_list->head);
+
+		next_list->head = prev_list->head;
+		next_list->num_pages += prev_list->num_pages;
+
+		mutex_unlock(&next_list->list_mutex);
+		mutex_unlock(&prev_list->list_mutex);
+	}
+
+	sbi->curr_clean_snapshot_info = next_info;
+	wakeup_snapshot_cleaner(sbi);
+
+	return 0;
+}
+
+static int nova_invalidate_snapshot_entry(struct super_block *sb,
+	struct snapshot_info *info)
+{
+	struct nova_snapshot_info_entry *entry;
+	int ret;
+
+	entry = nova_get_block(sb, info->snapshot_entry);
+	ret = nova_invalidate_logentry(sb, entry, SNAPSHOT_INFO, 0);
+	return ret;
+}
+
+int nova_delete_snapshot(struct super_block *sb, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info = NULL;
+	struct snapshot_info *next = NULL;
+	int delete = 0;
+	int ret;
+	timing_t delete_snapshot_time;
+
+	NOVA_START_TIMING(delete_snapshot_t, delete_snapshot_time);
+	mutex_lock(&sbi->s_lock);
+	nova_info("Delete snapshot epoch ID %llu\n", epoch_id);
+
+	ret = nova_find_target_snapshot_info(sb, epoch_id, &info);
+	if (ret != 1 || info->epoch_id != epoch_id) {
+		nova_dbg("%s: Snapshot info not found\n", __func__);
+		goto out;
+	}
+
+	next = nova_find_next_snapshot_info(sb, info);
+
+	if (next) {
+		nova_link_to_next_snapshot(sb, info, next);
+	} else {
+		/* Delete the last snapshot. Find the previous one. */
+		delete = 1;
+	}
+
+	radix_tree_delete(&sbi->snapshot_info_tree, epoch_id);
+
+	nova_invalidate_snapshot_entry(sb, info);
+
+out:
+	sbi->num_snapshots--;
+	mutex_unlock(&sbi->s_lock);
+
+	if (delete)
+		nova_delete_snapshot_info(sb, info, 1);
+
+	nova_free_snapshot_info(info);
+
+	NOVA_END_TIMING(delete_snapshot_t, delete_snapshot_time);
+	return 0;
+}
+
+static int nova_copy_snapshot_list_to_nvmm(struct super_block *sb,
+	struct snapshot_list *list, struct snapshot_nvmm_list *nvmm_list,
+	u64 new_block)
+{
+	struct nova_inode_log_page *dram_page;
+	void *curr_nvmm_addr;
+	u64 curr_nvmm_block;
+	u64 prev_nvmm_block;
+	u64 curr_dram_addr;
+	unsigned long i;
+	size_t size = sizeof(struct snapshot_nvmm_list);
+
+	curr_dram_addr = list->head;
+	prev_nvmm_block = new_block;
+	curr_nvmm_block = new_block;
+	curr_nvmm_addr = nova_get_block(sb, curr_nvmm_block);
+
+	for (i = 0; i < list->num_pages; i++) {
+		/* Leave next_page field alone */
+		nova_memunlock_block(sb, curr_nvmm_addr);
+		memcpy_to_pmem_nocache(curr_nvmm_addr, (void *)curr_dram_addr,
+						LOG_BLOCK_TAIL);
+		nova_memlock_block(sb, curr_nvmm_addr);
+
+		dram_page = (struct nova_inode_log_page *)curr_dram_addr;
+		prev_nvmm_block = curr_nvmm_block;
+		curr_nvmm_block = next_log_page(sb, curr_nvmm_block);
+		if (curr_nvmm_block < 0)
+			break;
+		curr_nvmm_addr = nova_get_block(sb, curr_nvmm_block);
+		curr_dram_addr = dram_page->page_tail.next_page;
+	}
+
+	nova_memunlock_range(sb, nvmm_list, size);
+	nvmm_list->num_pages = list->num_pages;
+	nvmm_list->tail = prev_nvmm_block + ENTRY_LOC(list->tail);
+	nvmm_list->head = new_block;
+	nova_memlock_range(sb, nvmm_list, size);
+
+	nova_flush_buffer(nvmm_list, sizeof(struct snapshot_nvmm_list), 1);
+
+	return 0;
+}
+
+static int nova_save_snapshot_info(struct super_block *sb,
+	struct snapshot_info *info)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_snapshot_info_entry *entry;
+	struct nova_inode_info_header sih;
+	struct snapshot_list *list;
+	struct snapshot_nvmm_page *nvmm_page;
+	struct snapshot_nvmm_list *nvmm_list;
+	unsigned long num_pages;
+	int i;
+	u64 nvmm_page_addr;
+	u64 new_block;
+	int allocated;
+
+	sih.ino = NOVA_SNAPSHOT_INO;
+	sih.i_blk_type = 0;
+
+	/* Support up to 128 CPUs */
+	allocated = nova_allocate_inode_log_pages(sb, &sih, 1,
+						&nvmm_page_addr, ANY_CPU, 0);
+	if (allocated != 1) {
+		nova_dbg("Error allocating NVMM info page\n");
+		return -ENOSPC;
+	}
+
+	nvmm_page = (struct snapshot_nvmm_page *)nova_get_block(sb,
+							nvmm_page_addr);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+		num_pages = list->num_pages;
+		allocated = nova_allocate_inode_log_pages(sb, &sih,
+					num_pages, &new_block, i, 0);
+		if (allocated != num_pages) {
+			nova_dbg("Error saving snapshot list: %d\n", allocated);
+			return -ENOSPC;
+		}
+		nvmm_list = &nvmm_page->lists[i];
+		nova_copy_snapshot_list_to_nvmm(sb, list, nvmm_list, new_block);
+	}
+
+	entry = nova_get_block(sb, info->snapshot_entry);
+	nova_set_nvmm_page_addr(sb, entry, nvmm_page_addr);
+
+	return 0;
+}
+
+static int nova_print_snapshot_info(struct snapshot_info *info,
+	struct seq_file *seq)
+{
+	struct tm tm;
+	u64 epoch_id;
+	u64 timestamp;
+	unsigned long local_time;
+
+	epoch_id = info->epoch_id;
+	timestamp = info->timestamp;
+
+	local_time = timestamp - sys_tz.tz_minuteswest * 60;
+	time_to_tm(local_time, 0, &tm);
+	seq_printf(seq, "%8llu\t%4lu-%02d-%02d\t%02d:%02d:%02d\n",
+					info->epoch_id,
+					tm.tm_year + 1900, tm.tm_mon + 1,
+					tm.tm_mday,
+					tm.tm_hour, tm.tm_min, tm.tm_sec);
+	return 0;
+}
+
+int nova_print_snapshots(struct super_block *sb, struct seq_file *seq)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info;
+	struct snapshot_info *infos[FREE_BATCH];
+	int nr_infos;
+	u64 epoch_id = 0;
+	int count = 0;
+	int i;
+
+	seq_puts(seq, "========== NOVA snapshot table ==========\n");
+	seq_puts(seq, "Epoch ID\t      Date\t    Time\n");
+
+	/* Print in epoch ID increasing order */
+	do {
+		nr_infos = radix_tree_gang_lookup(&sbi->snapshot_info_tree,
+					(void **)infos, epoch_id, FREE_BATCH);
+		for (i = 0; i < nr_infos; i++) {
+			info = infos[i];
+			BUG_ON(!info);
+			epoch_id = info->epoch_id;
+			nova_print_snapshot_info(info, seq);
+			count++;
+		}
+		epoch_id++;
+	} while (nr_infos == FREE_BATCH);
+
+	seq_printf(seq, "=========== Total %d snapshots ===========\n", count);
+	return 0;
+}
+
+int nova_print_snapshot_lists(struct super_block *sb, struct seq_file *seq)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info;
+	struct snapshot_list *list;
+	struct snapshot_info *infos[FREE_BATCH];
+	int nr_infos;
+	u64 epoch_id = 0;
+	int count = 0;
+	int sum;
+	int i, j;
+
+	seq_puts(seq, "========== NOVA snapshot statistics ==========\n");
+
+	/* Print in epoch ID increasing order */
+	do {
+		nr_infos = radix_tree_gang_lookup(&sbi->snapshot_info_tree,
+					(void **)infos, epoch_id, FREE_BATCH);
+		for (i = 0; i < nr_infos; i++) {
+			info = infos[i];
+			BUG_ON(!info);
+			epoch_id = info->epoch_id;
+			sum = 0;
+			for (j = 0; j < sbi->cpus; j++) {
+				list = &info->lists[j];
+				sum += list->num_pages;
+			}
+			seq_printf(seq, "Snapshot epoch ID %llu, %d list pages\n",
+					epoch_id, sum);
+			count++;
+		}
+		epoch_id++;
+	} while (nr_infos == FREE_BATCH);
+
+	seq_printf(seq, "============= Total %d snapshots =============\n",
+			count);
+	return 0;
+}
+
+static int nova_traverse_and_delete_snapshot_infos(struct super_block *sb,
+	int save)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct snapshot_info *info;
+	struct snapshot_info *infos[FREE_BATCH];
+	int nr_infos;
+	u64 epoch_id = 0;
+	int i;
+
+	do {
+		nr_infos = radix_tree_gang_lookup(&sbi->snapshot_info_tree,
+					(void **)infos, epoch_id, FREE_BATCH);
+		for (i = 0; i < nr_infos; i++) {
+			info = infos[i];
+			BUG_ON(!info);
+			epoch_id = info->epoch_id;
+			if (save)
+				nova_save_snapshot_info(sb, info);
+			nova_delete_snapshot_info(sb, info, 0);
+			radix_tree_delete(&sbi->snapshot_info_tree, epoch_id);
+			nova_free_snapshot_info(info);
+		}
+		epoch_id++;
+	} while (nr_infos == FREE_BATCH);
+
+	return 0;
+}
+
+int nova_save_snapshots(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (sbi->snapshot_cleaner_thread)
+		kthread_stop(sbi->snapshot_cleaner_thread);
+
+	if (sbi->mount_snapshot)
+		return 0;
+
+	return nova_traverse_and_delete_snapshot_infos(sb, 1);
+}
+
+int nova_destroy_snapshot_infos(struct super_block *sb)
+{
+	return nova_traverse_and_delete_snapshot_infos(sb, 0);
+}
+
+static void snapshot_cleaner_try_sleeping(struct nova_sb_info *sbi)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&sbi->snapshot_cleaner_wait, &wait, TASK_INTERRUPTIBLE);
+	schedule();
+	finish_wait(&sbi->snapshot_cleaner_wait, &wait);
+}
+
+static int nova_clean_snapshot(struct nova_sb_info *sbi)
+{
+	struct super_block *sb = sbi->sb;
+	struct snapshot_info *info;
+	struct snapshot_list *list;
+	int i;
+
+	if (!sbi->curr_clean_snapshot_info)
+		return 0;
+
+	info = sbi->curr_clean_snapshot_info;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		list = &info->lists[i];
+
+		mutex_lock(&list->list_mutex);
+		nova_background_clean_snapshot_list(sb, list,
+							info->epoch_id);
+		mutex_unlock(&list->list_mutex);
+	}
+
+	sbi->curr_clean_snapshot_info = NULL;
+	return 0;
+}
+
+static int nova_snapshot_cleaner(void *arg)
+{
+	struct nova_sb_info *sbi = arg;
+
+	nova_dbg("Running snapshot cleaner thread\n");
+	for (;;) {
+		snapshot_cleaner_try_sleeping(sbi);
+
+		if (kthread_should_stop())
+			break;
+
+		nova_clean_snapshot(sbi);
+	}
+
+	if (sbi->curr_clean_snapshot_info)
+		nova_clean_snapshot(sbi);
+
+	return 0;
+}
+
+static int nova_snapshot_cleaner_init(struct nova_sb_info *sbi)
+{
+	int ret = 0;
+
+	init_waitqueue_head(&sbi->snapshot_cleaner_wait);
+
+	sbi->snapshot_cleaner_thread = kthread_run(nova_snapshot_cleaner,
+		sbi, "nova_snapshot_cleaner");
+	if (IS_ERR(sbi->snapshot_cleaner_thread)) {
+		nova_info("Failed to start NOVA snapshot cleaner thread\n");
+		ret = -1;
+	}
+	nova_info("Start NOVA snapshot cleaner thread.\n");
+	return ret;
+}
+
+int nova_snapshot_init(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info_header *sih;
+	u64 ino = NOVA_SNAPSHOT_INO;
+	int ret;
+
+	sih = &sbi->snapshot_si->header;
+	nova_init_header(sb, sih, 0);
+	sih->pi_addr = nova_get_reserved_inode_addr(sb, ino);
+	sih->alter_pi_addr = nova_get_alter_reserved_inode_addr(sb, ino);
+	sih->ino = ino;
+	sih->i_blk_type = NOVA_DEFAULT_BLOCK_TYPE;
+
+	INIT_RADIX_TREE(&sbi->snapshot_info_tree, GFP_ATOMIC);
+	init_waitqueue_head(&sbi->snapshot_mmap_wait);
+	ret = nova_snapshot_cleaner_init(sbi);
+
+	return ret;
+}
+
diff --git a/fs/nova/snapshot.h b/fs/nova/snapshot.h
new file mode 100644
index 000000000000..948dfd557de4
--- /dev/null
+++ b/fs/nova/snapshot.h
@@ -0,0 +1,98 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Snapshot header
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
+
+/*
+ * DRAM log of updates to a snapshot.
+ */
+struct snapshot_list {
+	struct mutex list_mutex;
+	unsigned long num_pages;
+	unsigned long head;
+	unsigned long tail;
+};
+
+
+/*
+ * DRAM info about a snapshop.
+ */
+struct snapshot_info {
+	u64	epoch_id;
+	u64	timestamp;
+	unsigned long snapshot_entry; /* PMEM pointer to the struct
+				       * snapshot_info_entry for this
+				       * snapshot
+				       */
+
+	struct snapshot_list *lists;	/* Per-CPU snapshot list */
+};
+
+
+enum nova_snapshot_entry_type {
+	SS_INODE = 1,
+	SS_FILE_WRITE,
+};
+
+/*
+ * Snapshot log entry for recording an inode operation in a snapshot log.
+ *
+ * Todo: add checksum
+ */
+struct snapshot_inode_entry {
+	u8	type;
+	u8	deleted;
+	u8	padding[6];
+	u64	padding64;
+	u64	nova_ino;          // inode number that was deleted.
+	u64	delete_epoch_id;   // Deleted when?
+} __attribute((__packed__));
+
+/*
+ * Snapshot log entry for recording a write operation in a snapshot log
+ *
+ * Todo: add checksum.
+ */
+struct snapshot_file_write_entry {
+	u8	type;
+	u8	deleted;
+	u8	padding[6];
+	u64	nvmm;
+	u64	num_pages;
+	u64	delete_epoch_id;
+} __attribute((__packed__));
+
+/*
+ * PMEM structure pointing to a log comprised of snapshot_inode_entry and
+ * snapshot_file_write_entry objects.
+ *
+ * TODO: add checksum
+ */
+struct snapshot_nvmm_list {
+	__le64 padding;
+	__le64 num_pages;
+	__le64 head;
+	__le64 tail;
+} __attribute((__packed__));
+
+/* Support up to 128 CPUs */
+struct snapshot_nvmm_page {
+	struct snapshot_nvmm_list lists[128];
+};
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f543a47fc92..349e319b10f6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -415,6 +415,8 @@ struct vm_operations_struct {
 	 */
 	struct page *(*find_special_page)(struct vm_area_struct *vma,
 					  unsigned long addr);
+	/* For NOVA DAX-mmap protection */
+	int (*dax_cow)(struct vm_area_struct * area, unsigned long address);
 };
 
 struct mmu_gather;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 45cdb27791a3..0b7667fe3dfb 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -342,6 +342,9 @@ struct vm_area_struct {
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
 	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
+
+	/* Flag for NOVA DAX cow */
+	int original_write;
 };
 
 struct core_thread {
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 8edd0d576254..aa27a5517a75 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -275,6 +275,7 @@ unsigned long change_protection(struct vm_area_struct *vma, unsigned long start,
 
 	return pages;
 }
+EXPORT_SYMBOL(change_protection);
 
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
@@ -288,7 +289,7 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	int error;
 	int dirty_accountable = 0;
 
-	if (newflags == oldflags) {
+	if (newflags == oldflags && vma->original_write == 0) {
 		*pprev = vma;
 		return 0;
 	}
@@ -352,6 +353,16 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	change_protection(vma, start, end, vma->vm_page_prot,
 			  dirty_accountable, 0);
 
+	/* Update NOVA vma list */
+	if (vma->vm_ops && vma->vm_ops->dax_cow) {
+		if (!(oldflags & VM_WRITE) && (newflags & VM_WRITE)) {
+			vma->vm_ops->open(vma);
+		} else if (!(newflags & VM_WRITE)) {
+			if (vma->original_write || (oldflags & VM_WRITE))
+				vma->vm_ops->close(vma);
+		}
+	}
+
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
 	 * fault on access.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
