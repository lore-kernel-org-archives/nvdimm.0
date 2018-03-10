Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F86E22646315
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:22 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id e9so4831319pgs.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:41 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 70/83] File operation: Inplace write.
Date: Sat, 10 Mar 2018 10:18:51 -0800
Message-Id: <1520705944-6723-71-git-send-email-jix024@eng.ucsd.edu>
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

If the user specifies inplace updates, or the file is mmaped,
NOVA performs inplace writes.

The trick is dax page fault can occur concurrently with inplace writes,
and allocate new blocks. Also, inplace write memcpy may trigger page fault (xfstests 248).
Since page fault may take the write lock to modify the tree, write routine
cannot take tree lock during the memcpy.
As a result we perform inplace write in the following way:

1. Take the tree read lock, check existing entries or holes.
2. Release the read lock. Allocate new data pages if needed;
   allocate and initialize file write item, add to the list and perform memcpy.
3. With the list of file write items, take the tree write lock and perform commit:
   Due to concurrent page fault, the hole returned in step 1 may be filled by
   page fault handlers. In this case, NOVA copies the data from the file write item
   to the pages allocated by page fault handler, and free the data blocks allocated
   in step 2. This guarantees application can see the write via mmaped region.

The step 3 actually formats a new list of write items, and reuse the CoW commit
routine to commit the items.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/dax.c  | 472 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/file.c |  10 +-
 fs/nova/nova.h |   4 +
 3 files changed, 484 insertions(+), 2 deletions(-)

diff --git a/fs/nova/dax.c b/fs/nova/dax.c
index 9561d8e..8624ce4 100644
--- a/fs/nova/dax.c
+++ b/fs/nova/dax.c
@@ -259,3 +259,475 @@ void nova_init_file_write_item(struct super_block *sb,
 
 	entry->size = file_size;
 }
+
+/*
+ * Check if there is an existing entry or hole for target page offset.
+ * Used for inplace write, DAX-mmap and fallocate.
+ */
+unsigned long nova_check_existing_entry(struct super_block *sb,
+	struct inode *inode, unsigned long num_blocks, unsigned long start_blk,
+	struct nova_file_write_entry **ret_entry,
+	int check_next, u64 epoch_id,
+	int *inplace)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_entry *entry;
+	unsigned long next_pgoff;
+	unsigned long ent_blks = 0;
+	timing_t check_time;
+
+	NOVA_START_TIMING(check_entry_t, check_time);
+
+	*ret_entry = NULL;
+	*inplace = 0;
+	entry = nova_get_write_entry(sb, sih, start_blk);
+
+	if (entry) {
+		*ret_entry = entry;
+
+		/* We can do inplace write. Find contiguous blocks */
+		if (entry->reassigned == 0)
+			ent_blks = entry->num_pages -
+					(start_blk - entry->pgoff);
+		else
+			ent_blks = 1;
+
+		if (ent_blks > num_blocks)
+			ent_blks = num_blocks;
+
+		if (entry->epoch_id == epoch_id)
+			*inplace = 1;
+
+	} else if (check_next) {
+		/* Possible Hole */
+		entry = nova_find_next_entry(sb, sih, start_blk);
+		if (entry) {
+			next_pgoff = entry->pgoff;
+			if (next_pgoff <= start_blk) {
+				nova_err(sb, "iblock %lu, entry pgoff %lu, num pages %lu\n",
+				       start_blk, next_pgoff, entry->num_pages);
+				nova_print_inode_log(sb, inode);
+				dump_stack();
+				ent_blks = num_blocks;
+				goto out;
+			}
+			ent_blks = next_pgoff - start_blk;
+			if (ent_blks > num_blocks)
+				ent_blks = num_blocks;
+		} else {
+			/* File grow */
+			ent_blks = num_blocks;
+		}
+	}
+
+	if (entry && ent_blks == 0) {
+		nova_dbg("%s: %d\n", __func__, check_next);
+		dump_stack();
+	}
+
+out:
+	NOVA_END_TIMING(check_entry_t, check_time);
+	return ent_blks;
+}
+
+/* Memcpy from newly allocated data blocks to existing data blocks */
+static int nova_inplace_memcpy(struct super_block *sb, struct inode *inode,
+	struct nova_file_write_entry *from, struct nova_file_write_entry *to,
+	unsigned long num_blocks, loff_t pos, size_t len)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_log_entry_info entry_info;
+	unsigned long pgoff;
+	unsigned long from_nvmm, to_nvmm;
+	void *from_addr, *to_addr = NULL;
+	loff_t base, start, end, offset;
+
+	pgoff = le64_to_cpu(from->pgoff);
+	base = start = pgoff << PAGE_SHIFT;
+	end = (pgoff + num_blocks) << PAGE_SHIFT;
+
+	if (start < pos)
+		start = pos;
+
+	if (end > pos + len)
+		end = pos + len;
+
+	len = end - start;
+	offset = start - base;
+
+	from_nvmm = get_nvmm(sb, sih, from, pgoff);
+	from_addr = nova_get_block(sb, (from_nvmm << PAGE_SHIFT));
+	to_nvmm = get_nvmm(sb, sih, to, pgoff);
+	to_addr = nova_get_block(sb, (to_nvmm << PAGE_SHIFT));
+
+	memcpy_to_pmem_nocache(to_addr + offset, from_addr + offset, len);
+
+	/* Update entry */
+	entry_info.type = FILE_WRITE;
+	entry_info.epoch_id = from->epoch_id;
+	entry_info.trans_id = from->trans_id;
+	entry_info.time = from->mtime;
+	entry_info.file_size = from->size;
+	entry_info.inplace = 1;
+
+	nova_inplace_update_write_entry(sb, inode, to, &entry_info);
+	return 0;
+}
+
+/*
+ * Due to concurrent DAX fault, we may have overlapped entries in the list.
+ * We copy the data to the existing data pages and update the entry.
+ * Must be called with sih write lock held.
+ */
+static int nova_commit_inplace_writes_to_log(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode,
+	struct list_head *head, unsigned long new_blocks,
+	loff_t pos, size_t len)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_file_write_item *entry_item, *temp;
+	struct nova_file_write_item *new_item;
+	struct nova_file_write_entry *curr, *entry;
+	struct list_head new_head;
+	unsigned long start_blk, ent_blks;
+	unsigned long num_blocks;
+	unsigned long blocknr;
+	u64 epoch_id;
+	int inplace;
+	int ret = 0;
+
+	if (list_empty(head))
+		return 0;
+
+	sih_lock(sih);
+	INIT_LIST_HEAD(&new_head);
+
+	list_for_each_entry_safe(entry_item, temp, head, list) {
+		list_del(&entry_item->list);
+		curr = &entry_item->entry;
+		epoch_id = le64_to_cpu(curr->epoch_id);
+again:
+		num_blocks = le32_to_cpu(curr->num_pages);
+		start_blk = le64_to_cpu(curr->pgoff);
+
+		ent_blks = nova_check_existing_entry(sb, inode, num_blocks,
+						start_blk, &entry,
+						1, epoch_id, &inplace);
+
+		if (!entry && ent_blks == num_blocks) {
+			/* Hole */
+			list_add_tail(&entry_item->list, &new_head);
+			continue;
+		}
+
+		blocknr = nova_get_blocknr(sb, curr->block,
+						sih->i_blk_type);
+		/* Overlap with head. Memcpy */
+		if (entry) {
+			new_blocks -= ent_blks;
+			nova_inplace_memcpy(sb, inode, curr, entry, ent_blks,
+						pos, len);
+			if (ent_blks == num_blocks) {
+				/* Full copy */
+				nova_free_data_blocks(sb, sih, blocknr,
+						ent_blks);
+				nova_free_file_write_item(entry_item);
+				continue;
+			} else {
+				/* Partial copy */
+				curr->num_pages -= ent_blks;
+				curr->pgoff += ent_blks;
+				curr->block += ent_blks << PAGE_SHIFT;
+				nova_free_data_blocks(sb, sih, blocknr,
+						ent_blks);
+				goto again;
+			}
+		}
+
+		/* Overlap with middle or tail. */
+		new_item = nova_alloc_file_write_item(sb);
+		if (!new_item) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		nova_init_file_write_item(sb, sih, new_item,
+				epoch_id, start_blk, ent_blks,
+				blocknr, entry->mtime, entry->size);
+
+		list_add_tail(&new_item->list, &new_head);
+
+		curr->num_pages -= ent_blks;
+		curr->pgoff += ent_blks;
+		curr->block += ent_blks << PAGE_SHIFT;
+		goto again;
+	}
+
+	ret = nova_commit_writes_to_log(sb, pi, inode,
+					&new_head, new_blocks, 1);
+	if (ret < 0) {
+		nova_err(sb, "commit to log failed\n");
+		goto out;
+	}
+
+out:
+	if (ret < 0)
+		nova_cleanup_incomplete_write(sb, sih, &new_head, 1);
+
+	sih_unlock(sih);
+	return ret;
+}
+
+/*
+ * Do an inplace write.  This function assumes that the lock on the inode is
+ * already held.
+ *
+ * We do this in three steps:
+ * 1. Check the tree, protected by sih read lock.
+ * 2. Allocate blocks for hole, copy from user buffer.
+ * 3. Take sih write lock and commit the writes.
+ *
+ * This is necessary because DAX fault can occur when we do the copy.
+ * We cannot hold sih lock when performing the data copy,
+ * and DAX fault may allocate data pages during step 2.
+ * In this case we overwrite with our data and free the data pages we allocated.
+ */
+ssize_t do_nova_inplace_file_write(struct file *filp,
+	const char __user *buf,	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode	*inode = mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi;
+	struct nova_file_write_entry *entry;
+	struct nova_file_write_item *entry_item;
+	struct list_head item_head;
+	struct nova_inode_update update;
+	ssize_t	    written = 0;
+	loff_t pos, original_pos;
+	size_t count, offset, copied;
+	unsigned long start_blk, num_blocks, ent_blks = 0;
+	unsigned long total_blocks;
+	unsigned long new_blocks = 0;
+	unsigned long blocknr = 0;
+	int allocated = 0;
+	int inplace = 0;
+	bool hole_fill = false;
+	void *kmem;
+	u64 blk_off;
+	size_t bytes;
+	long status = 0;
+	timing_t inplace_write_time, memcpy_time;
+	unsigned long step = 0;
+	u64 epoch_id;
+	u64 file_size;
+	u32 time;
+	ssize_t ret;
+
+	if (len == 0)
+		return 0;
+
+	NOVA_START_TIMING(inplace_write_t, inplace_write_time);
+	INIT_LIST_HEAD(&item_head);
+
+	if (!access_ok(VERIFY_READ, buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	pos = original_pos = *ppos;
+
+	if (filp->f_flags & O_APPEND)
+		pos = i_size_read(inode);
+
+	count = len;
+
+	pi = nova_get_block(sb, sih->pi_addr);
+
+	offset = pos & (sb->s_blocksize - 1);
+	num_blocks = ((count + offset - 1) >> sb->s_blocksize_bits) + 1;
+	total_blocks = num_blocks;
+
+	/* offset in the actual block size block */
+
+	ret = file_remove_privs(filp);
+	if (ret)
+		goto out;
+
+	inode->i_ctime = inode->i_mtime = current_time(inode);
+	time = current_time(inode).tv_sec;
+
+	epoch_id = nova_get_epoch_id(sb);
+
+	nova_dbgv("%s: epoch_id %llu, inode %lu, offset %lld, count %lu\n",
+			__func__, epoch_id, inode->i_ino, pos, count);
+	update.tail = sih->log_tail;
+	while (num_blocks > 0) {
+		hole_fill = false;
+		offset = pos & (nova_inode_blk_size(sih) - 1);
+		start_blk = pos >> sb->s_blocksize_bits;
+
+		sih_lock_shared(sih);
+		ent_blks = nova_check_existing_entry(sb, inode, num_blocks,
+						start_blk, &entry,
+						1, epoch_id, &inplace);
+		sih_unlock_shared(sih);
+
+		if (entry && inplace) {
+			/* We can do inplace write. Find contiguous blocks */
+			blocknr = get_nvmm(sb, sih, entry, start_blk);
+			blk_off = blocknr << PAGE_SHIFT;
+			allocated = ent_blks;
+		} else {
+			/* Allocate blocks to fill hole */
+			allocated = nova_new_data_blocks(sb, sih, &blocknr,
+					 start_blk, ent_blks, ALLOC_NO_INIT,
+					 ANY_CPU, ALLOC_FROM_HEAD);
+
+			nova_dbg_verbose("%s: alloc %d blocks @ %lu\n",
+						__func__, allocated, blocknr);
+
+			if (allocated <= 0) {
+				nova_dbg("%s alloc blocks failed!, %d\n",
+							__func__, allocated);
+				ret = allocated;
+				goto out;
+			}
+
+			hole_fill = true;
+			new_blocks += allocated;
+			blk_off = nova_get_block_off(sb, blocknr,
+							sih->i_blk_type);
+
+			invalidate_inode_pages2_range(inode->i_mapping,
+					start_blk, start_blk + allocated - 1);
+		}
+
+		step++;
+		bytes = sb->s_blocksize * allocated - offset;
+		if (bytes > count)
+			bytes = count;
+
+		kmem = nova_get_block(inode->i_sb, blk_off);
+
+		if (hole_fill &&
+		    (offset || ((offset + bytes) & (PAGE_SIZE - 1)) != 0)) {
+			ret =  nova_handle_head_tail_blocks(sb, inode,
+							    pos, bytes, kmem);
+			if (ret)
+				goto out;
+
+		}
+
+		/* Now copy from user buf */
+//		nova_dbg("Write: %p\n", kmem);
+		NOVA_START_TIMING(memcpy_w_nvmm_t, memcpy_time);
+		copied = bytes - memcpy_to_pmem_nocache(kmem + offset,
+						buf, bytes);
+		NOVA_END_TIMING(memcpy_w_nvmm_t, memcpy_time);
+
+		if (pos + copied > inode->i_size)
+			file_size = cpu_to_le64(pos + copied);
+		else
+			file_size = cpu_to_le64(inode->i_size);
+
+		/* Handle hole fill write */
+		if (hole_fill) {
+			entry_item = nova_alloc_file_write_item(sb);
+			if (!entry_item) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			nova_init_file_write_item(sb, sih, entry_item,
+						epoch_id, start_blk, allocated,
+						blocknr, time, file_size);
+
+			list_add_tail(&entry_item->list, &item_head);
+		} else {
+			/* Update existing entry */
+			struct nova_log_entry_info entry_info;
+
+			entry_info.type = FILE_WRITE;
+			entry_info.epoch_id = epoch_id;
+			entry_info.trans_id = sih->trans_id;
+			entry_info.time = time;
+			entry_info.file_size = file_size;
+			entry_info.inplace = 1;
+
+			nova_inplace_update_write_entry(sb, inode, entry,
+							&entry_info);
+		}
+
+		nova_dbgv("Write: %p, %lu\n", kmem, copied);
+		if (copied > 0) {
+			status = copied;
+			written += copied;
+			pos += copied;
+			buf += copied;
+			count -= copied;
+			num_blocks -= allocated;
+		}
+		if (unlikely(copied != bytes)) {
+			nova_dbg("%s ERROR!: %p, bytes %lu, copied %lu\n",
+				__func__, kmem, bytes, copied);
+			if (status >= 0)
+				status = -EFAULT;
+		}
+		if (status < 0)
+			break;
+	}
+
+	ret = nova_commit_inplace_writes_to_log(sb, pi, inode, &item_head,
+					new_blocks, original_pos, len);
+	if (ret < 0) {
+		nova_err(sb, "commit to log failed\n");
+		goto out;
+	}
+
+	ret = written;
+	NOVA_STATS_ADD(inplace_write_breaks, step);
+	nova_dbgv("blocks: %lu, %lu\n", inode->i_blocks, sih->i_blocks);
+
+	*ppos = pos;
+	if (pos > inode->i_size) {
+		i_size_write(inode, pos);
+		sih->i_size = pos;
+	}
+
+out:
+	if (ret < 0)
+		nova_cleanup_incomplete_write(sb, sih, &item_head, 1);
+
+	NOVA_END_TIMING(inplace_write_t, inplace_write_time);
+	NOVA_STATS_ADD(inplace_write_bytes, written);
+	return ret;
+}
+
+/*
+ * Acquire locks and perform an inplace update.
+ */
+ssize_t nova_inplace_file_write(struct file *filp,
+				const char __user *buf,	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	int ret;
+
+	if (len == 0)
+		return 0;
+
+	sb_start_write(inode->i_sb);
+	inode_lock(inode);
+
+	ret = do_nova_inplace_file_write(filp, buf, len, ppos);
+
+	inode_unlock(inode);
+	sb_end_write(inode->i_sb);
+
+	return ret;
+}
diff --git a/fs/nova/file.c b/fs/nova/file.c
index 26f15c7..b94a9a3 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -448,7 +448,10 @@ ssize_t nova_cow_file_write(struct file *filp,
 	sb_start_write(inode->i_sb);
 	inode_lock(inode);
 
-	ret = do_nova_cow_file_write(filp, buf, len, ppos);
+	if (mapping_mapped(mapping))
+		ret = do_nova_inplace_file_write(filp, buf, len, ppos);
+	else
+		ret = do_nova_cow_file_write(filp, buf, len, ppos);
 
 	inode_unlock(inode);
 	sb_end_write(inode->i_sb);
@@ -460,7 +463,10 @@ ssize_t nova_cow_file_write(struct file *filp,
 static ssize_t nova_dax_file_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *ppos)
 {
-	return nova_cow_file_write(filp, buf, len, ppos);
+	if (inplace_data_updates)
+		return nova_inplace_file_write(filp, buf, len, ppos);
+	else
+		return nova_cow_file_write(filp, buf, len, ppos);
 }
 
 
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 6c94a9b..40c70da 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -477,6 +477,10 @@ void nova_init_file_write_item(struct super_block *sb,
 	struct nova_inode_info_header *sih, struct nova_file_write_item *item,
 	u64 epoch_id, u64 pgoff, int num_pages, u64 blocknr, u32 time,
 	u64 file_size);
+ssize_t nova_inplace_file_write(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos);
+ssize_t do_nova_inplace_file_write(struct file *filp, const char __user *buf,
+	size_t len, loff_t *ppos);
 
 /* dir.c */
 extern const struct file_operations nova_dir_operations;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
