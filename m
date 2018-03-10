Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1359822646314
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:20 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id l4so4832218pgp.11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:38 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 68/83] File operation: copy-on-write write.
Date: Sat, 10 Mar 2018 10:18:49 -0800
Message-Id: <1520705944-6723-69-git-send-email-jix024@eng.ucsd.edu>
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

If the file is not mmaped, NOVA performs copy-on-write.
The CoW is composed of parts:

1. Allocate contiguous data pages.
2. Copy data from user buffer to the data pages.
   If the write is not aligned to page size, also copy data from existing
   pmem pages.
3. Allocate and initialize a file write item, add it to a linked list.
4. Repeat 1 - 3 until the whole user data is copied to pmem pages.
5. Commit the list of file write items to the log and update the radix tree.
6. Update log tail pointer once all the items are committed.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/dax.c  | 149 +++++++++++++++++++++++++++++++++++++++++
 fs/nova/file.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h |   8 +++
 3 files changed, 365 insertions(+)

diff --git a/fs/nova/dax.c b/fs/nova/dax.c
index 1669dc0..9561d8e 100644
--- a/fs/nova/dax.c
+++ b/fs/nova/dax.c
@@ -22,6 +22,113 @@
 #include "inode.h"
 
 
+static inline int nova_copy_partial_block(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry, unsigned long index,
+	size_t offset, size_t length, void *kmem)
+{
+	void *ptr;
+	int rc = 0;
+	unsigned long nvmm;
+
+	nvmm = get_nvmm(sb, sih, entry, index);
+	ptr = nova_get_block(sb, (nvmm << PAGE_SHIFT));
+
+	if (ptr != NULL) {
+		if (support_clwb)
+			rc = memcpy_mcsafe(kmem + offset, ptr + offset,
+						length);
+		else
+			memcpy_to_pmem_nocache(kmem + offset, ptr + offset,
+						length);
+	}
+
+	/* TODO: If rc < 0, go to MCE data recovery. */
+	return rc;
+}
+
+static inline int nova_handle_partial_block(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry, unsigned long index,
+	size_t offset, size_t length, void *kmem)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+
+	if (entry == NULL) {
+		/* Fill zero */
+		if (support_clwb)
+			memset(kmem + offset, 0, length);
+		else
+			memcpy_to_pmem_nocache(kmem + offset,
+					sbi->zeroed_page, length);
+	} else {
+		nova_copy_partial_block(sb, sih, entry, index,
+					offset, length, kmem);
+
+	}
+	if (support_clwb)
+		nova_flush_buffer(kmem + offset, length, 0);
+	return 0;
+}
+
+/*
+ * Fill the new start/end block from original blocks.
+ * Do nothing if fully covered; copy if original blocks present;
+ * Fill zero otherwise.
+ */
+int nova_handle_head_tail_blocks(struct super_block *sb,
+	struct inode *inode, loff_t pos, size_t count, void *kmem)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	size_t offset, eblk_offset;
+	unsigned long start_blk, end_blk, num_blocks;
+	struct nova_file_write_entry *entry;
+	timing_t partial_time;
+	int ret = 0;
+
+	NOVA_START_TIMING(partial_block_t, partial_time);
+	offset = pos & (sb->s_blocksize - 1);
+	num_blocks = ((count + offset - 1) >> sb->s_blocksize_bits) + 1;
+	/* offset in the actual block size block */
+	offset = pos & (nova_inode_blk_size(sih) - 1);
+	start_blk = pos >> sb->s_blocksize_bits;
+	end_blk = start_blk + num_blocks - 1;
+
+	nova_dbg_verbose("%s: %lu blocks\n", __func__, num_blocks);
+	/* We avoid zeroing the alloc'd range, which is going to be overwritten
+	 * by this system call anyway
+	 */
+	nova_dbg_verbose("%s: start offset %lu start blk %lu %p\n", __func__,
+				offset, start_blk, kmem);
+	if (offset != 0) {
+		entry = nova_get_write_entry(sb, sih, start_blk);
+		ret = nova_handle_partial_block(sb, sih, entry,
+						start_blk, 0, offset, kmem);
+		if (ret < 0)
+			return ret;
+	}
+
+	kmem = (void *)((char *)kmem +
+			((num_blocks - 1) << sb->s_blocksize_bits));
+	eblk_offset = (pos + count) & (nova_inode_blk_size(sih) - 1);
+	nova_dbg_verbose("%s: end offset %lu, end blk %lu %p\n", __func__,
+				eblk_offset, end_blk, kmem);
+	if (eblk_offset != 0) {
+		entry = nova_get_write_entry(sb, sih, end_blk);
+
+		ret = nova_handle_partial_block(sb, sih, entry, end_blk,
+						eblk_offset,
+						sb->s_blocksize - eblk_offset,
+						kmem);
+		if (ret < 0)
+			return ret;
+	}
+	NOVA_END_TIMING(partial_block_t, partial_time);
+
+	return ret;
+}
+
 static int nova_reassign_file_tree(struct super_block *sb,
 	struct nova_inode_info_header *sih, u64 begin_tail, u64 end_tail)
 {
@@ -110,3 +217,45 @@ int nova_commit_writes_to_log(struct super_block *sb, struct nova_inode *pi,
 
 	return ret;
 }
+
+int nova_cleanup_incomplete_write(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct list_head *head, int free)
+{
+	struct nova_file_write_item *entry_item, *temp;
+	struct nova_file_write_entry *entry;
+	unsigned long blocknr;
+
+	list_for_each_entry_safe(entry_item, temp, head, list) {
+		entry = &entry_item->entry;
+		blocknr = nova_get_blocknr(sb, entry->block, sih->i_blk_type);
+		nova_free_data_blocks(sb, sih, blocknr, entry->num_pages);
+
+		if (free)
+			nova_free_file_write_item(entry_item);
+	}
+
+	return 0;
+}
+
+void nova_init_file_write_item(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_item *item,
+	u64 epoch_id, u64 pgoff, int num_pages, u64 blocknr, u32 time,
+	u64 file_size)
+{
+	struct nova_file_write_entry *entry = &item->entry;
+
+	INIT_LIST_HEAD(&item->list);
+	memset(entry, 0, sizeof(struct nova_file_write_entry));
+	entry->entry_type = FILE_WRITE;
+	entry->reassigned = 0;
+	entry->epoch_id = epoch_id;
+	entry->trans_id = sih->trans_id;
+	entry->pgoff = cpu_to_le64(pgoff);
+	entry->num_pages = cpu_to_le32(num_pages);
+	entry->invalid_pages = 0;
+	entry->block = cpu_to_le64(nova_get_block_off(sb, blocknr,
+							sih->i_blk_type));
+	entry->mtime = cpu_to_le32(time);
+
+	entry->size = file_size;
+}
diff --git a/fs/nova/file.c b/fs/nova/file.c
index 842da45..26f15c7 100644
--- a/fs/nova/file.c
+++ b/fs/nova/file.c
@@ -256,10 +256,218 @@ static ssize_t nova_dax_file_read(struct file *filp, char __user *buf,
 	return res;
 }
 
+/*
+ * Perform a COW write.   Must hold the inode lock before calling.
+ */
+static ssize_t do_nova_cow_file_write(struct file *filp,
+	const char __user *buf,	size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode	*inode = mapping->host;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi;
+	struct nova_file_write_item *entry_item;
+	struct list_head item_head;
+	struct nova_inode_update update;
+	ssize_t	    written = 0;
+	loff_t pos;
+	size_t count, offset, copied;
+	unsigned long start_blk, num_blocks;
+	unsigned long total_blocks;
+	unsigned long blocknr = 0;
+	int allocated = 0;
+	void *kmem;
+	u64 file_size;
+	size_t bytes;
+	long status = 0;
+	timing_t cow_write_time, memcpy_time;
+	unsigned long step = 0;
+	ssize_t ret;
+	u64 epoch_id;
+	u32 time;
+
+
+	if (len == 0)
+		return 0;
+
+	sih_lock(sih);
+	NOVA_START_TIMING(cow_write_t, cow_write_time);
+	INIT_LIST_HEAD(&item_head);
+
+	if (!access_ok(VERIFY_READ, buf, len)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	pos = *ppos;
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
+	start_blk = pos >> sb->s_blocksize_bits;
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
+	nova_dbgv("%s: inode %lu, offset %lld, count %lu\n",
+			__func__, inode->i_ino,	pos, count);
+
+	epoch_id = nova_get_epoch_id(sb);
+	update.tail = sih->log_tail;
+	while (num_blocks > 0) {
+		offset = pos & (nova_inode_blk_size(sih) - 1);
+		start_blk = pos >> sb->s_blocksize_bits;
+
+		/* don't zero-out the allocated blocks */
+		allocated = nova_new_data_blocks(sb, sih, &blocknr, start_blk,
+				 num_blocks, ALLOC_NO_INIT, ANY_CPU,
+				 ALLOC_FROM_HEAD);
+
+		nova_dbg_verbose("%s: alloc %d blocks @ %lu\n", __func__,
+						allocated, blocknr);
+
+		if (allocated <= 0) {
+			nova_dbg("%s alloc blocks failed %d\n", __func__,
+								allocated);
+			ret = allocated;
+			goto out;
+		}
+
+		step++;
+		bytes = sb->s_blocksize * allocated - offset;
+		if (bytes > count)
+			bytes = count;
+
+		kmem = nova_get_block(inode->i_sb,
+			     nova_get_block_off(sb, blocknr, sih->i_blk_type));
+
+		if (offset || ((offset + bytes) & (PAGE_SIZE - 1)) != 0)  {
+			ret = nova_handle_head_tail_blocks(sb, inode, pos,
+							   bytes, kmem);
+			if (ret)
+				goto out;
+		}
+		/* Now copy from user buf */
+		//		nova_dbg("Write: %p\n", kmem);
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
+		entry_item = nova_alloc_file_write_item(sb);
+		if (!entry_item) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		nova_init_file_write_item(sb, sih, entry_item, epoch_id,
+					start_blk, allocated, blocknr, time,
+					file_size);
+
+		list_add_tail(&entry_item->list, &item_head);
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
+	ret = nova_commit_writes_to_log(sb, pi, inode,
+					&item_head, total_blocks, 1);
+	if (ret < 0) {
+		nova_err(sb, "commit to log failed\n");
+		goto out;
+	}
+
+	ret = written;
+	NOVA_STATS_ADD(cow_write_breaks, step);
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
+	NOVA_END_TIMING(cow_write_t, cow_write_time);
+	NOVA_STATS_ADD(cow_write_bytes, written);
+	sih_unlock(sih);
+
+	return ret;
+}
+
+/*
+ * Acquire locks and perform COW write.
+ */
+ssize_t nova_cow_file_write(struct file *filp,
+	const char __user *buf,	size_t len, loff_t *ppos)
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
+	ret = do_nova_cow_file_write(filp, buf, len, ppos);
+
+	inode_unlock(inode);
+	sb_end_write(inode->i_sb);
+
+	return ret;
+}
+
+
+static ssize_t nova_dax_file_write(struct file *filp, const char __user *buf,
+				   size_t len, loff_t *ppos)
+{
+	return nova_cow_file_write(filp, buf, len, ppos);
+}
+
 
 const struct file_operations nova_dax_file_operations = {
 	.llseek		= nova_llseek,
 	.read		= nova_dax_file_read,
+	.write		= nova_dax_file_write,
 	.open		= nova_open,
 	.fsync		= nova_fsync,
 	.flush		= nova_flush,
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index dcda02a..1c2205e 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -465,9 +465,17 @@ nova_get_blocknr(struct super_block *sb, u64 block, unsigned short btype)
 /* ====================================================== */
 
 /* dax.c */
+int nova_handle_head_tail_blocks(struct super_block *sb,
+	struct inode *inode, loff_t pos, size_t count, void *kmem);
 int nova_commit_writes_to_log(struct super_block *sb, struct nova_inode *pi,
 	struct inode *inode, struct list_head *head, unsigned long new_blocks,
 	int free);
+int nova_cleanup_incomplete_write(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct list_head *head, int free);
+void nova_init_file_write_item(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_item *item,
+	u64 epoch_id, u64 pgoff, int num_pages, u64 blocknr, u32 time,
+	u64 file_size);
 
 /* dir.c */
 extern const struct file_operations nova_dir_operations;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
