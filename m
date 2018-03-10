Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F164F2258AEF8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:21 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id i14so4841504pgv.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:40 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 20/83] Pmem block allocation routines.
Date: Sat, 10 Mar 2018 10:18:01 -0800
Message-Id: <1520705944-6723-21-git-send-email-jix024@eng.ucsd.edu>
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

Upon a allocation request, NOVA first try the free list on current CPU.
If there are not enough blocks to allocate, NOVA will go to the
free list with the most free blocks.
Caller can specify allocation direction: from low address or from
high address.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/balloc.c | 270 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/balloc.h |  10 +++
 2 files changed, 280 insertions(+)

diff --git a/fs/nova/balloc.c b/fs/nova/balloc.c
index 9108721..8e99215 100644
--- a/fs/nova/balloc.c
+++ b/fs/nova/balloc.c
@@ -441,6 +441,276 @@ int nova_free_log_blocks(struct super_block *sb,
 	return ret;
 }
 
+static int not_enough_blocks(struct free_list *free_list,
+	unsigned long num_blocks, enum alloc_type atype)
+{
+	struct nova_range_node *first = free_list->first_node;
+	struct nova_range_node *last = free_list->last_node;
+
+	if (free_list->num_free_blocks < num_blocks || !first || !last) {
+		nova_dbgv("%s: num_free_blocks=%ld; num_blocks=%ld; first=0x%p; last=0x%p",
+			  __func__, free_list->num_free_blocks, num_blocks,
+			  first, last);
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Return how many blocks allocated */
+static long nova_alloc_blocks_in_free_list(struct super_block *sb,
+	struct free_list *free_list, unsigned short btype,
+	enum alloc_type atype, unsigned long num_blocks,
+	unsigned long *new_blocknr, enum nova_alloc_direction from_tail)
+{
+	struct rb_root *tree;
+	struct nova_range_node *curr, *next = NULL, *prev = NULL;
+	struct rb_node *temp, *next_node, *prev_node;
+	unsigned long curr_blocks;
+	bool found = 0;
+	unsigned long step = 0;
+
+	if (!free_list->first_node || free_list->num_free_blocks == 0) {
+		nova_dbgv("%s: Can't alloc. free_list->first_node=0x%p free_list->num_free_blocks = %lu",
+			  __func__, free_list->first_node,
+			  free_list->num_free_blocks);
+		return -ENOSPC;
+	}
+
+	if (atype == LOG && not_enough_blocks(free_list, num_blocks, atype)) {
+		nova_dbgv("%s: Can't alloc.  not_enough_blocks() == true",
+			  __func__);
+		return -ENOSPC;
+	}
+
+	tree = &(free_list->block_free_tree);
+	if (from_tail == ALLOC_FROM_HEAD)
+		temp = &(free_list->first_node->node);
+	else
+		temp = &(free_list->last_node->node);
+
+	while (temp) {
+		step++;
+		curr = container_of(temp, struct nova_range_node, node);
+
+		curr_blocks = curr->range_high - curr->range_low + 1;
+
+		if (num_blocks >= curr_blocks) {
+			/* Superpage allocation must succeed */
+			if (btype > 0 && num_blocks > curr_blocks)
+				goto next;
+
+			/* Otherwise, allocate the whole blocknode */
+			if (curr == free_list->first_node) {
+				next_node = rb_next(temp);
+				if (next_node)
+					next = container_of(next_node,
+						struct nova_range_node, node);
+				free_list->first_node = next;
+			}
+
+			if (curr == free_list->last_node) {
+				prev_node = rb_prev(temp);
+				if (prev_node)
+					prev = container_of(prev_node,
+						struct nova_range_node, node);
+				free_list->last_node = prev;
+			}
+
+			rb_erase(&curr->node, tree);
+			free_list->num_blocknode--;
+			num_blocks = curr_blocks;
+			*new_blocknr = curr->range_low;
+			nova_free_blocknode(sb, curr);
+			found = 1;
+			break;
+		}
+
+		/* Allocate partial blocknode */
+		if (from_tail == ALLOC_FROM_HEAD) {
+			*new_blocknr = curr->range_low;
+			curr->range_low += num_blocks;
+		} else {
+			*new_blocknr = curr->range_high + 1 - num_blocks;
+			curr->range_high -= num_blocks;
+		}
+
+		found = 1;
+		break;
+next:
+		if (from_tail == ALLOC_FROM_HEAD)
+			temp = rb_next(temp);
+		else
+			temp = rb_prev(temp);
+	}
+
+	if (free_list->num_free_blocks < num_blocks) {
+		nova_dbg("%s: free list %d has %lu free blocks, but allocated %lu blocks?\n",
+				__func__, free_list->index,
+				free_list->num_free_blocks, num_blocks);
+		return -ENOSPC;
+	}
+
+	if (found == 1)
+		free_list->num_free_blocks -= num_blocks;
+	else {
+		nova_dbgv("%s: Can't alloc.  found = %d", __func__, found);
+		return -ENOSPC;
+	}
+
+	NOVA_STATS_ADD(alloc_steps, step);
+
+	return num_blocks;
+}
+
+/* Find out the free list with most free blocks */
+static int nova_get_candidate_free_list(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	int cpuid = 0;
+	int num_free_blocks = 0;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		if (free_list->num_free_blocks > num_free_blocks) {
+			cpuid = i;
+			num_free_blocks = free_list->num_free_blocks;
+		}
+	}
+
+	return cpuid;
+}
+
+static int nova_new_blocks(struct super_block *sb, unsigned long *blocknr,
+	unsigned int num, unsigned short btype, int zero,
+	enum alloc_type atype, int cpuid, enum nova_alloc_direction from_tail)
+{
+	struct free_list *free_list;
+	void *bp;
+	unsigned long num_blocks = 0;
+	unsigned long new_blocknr = 0;
+	long ret_blocks = 0;
+	int retried = 0;
+	timing_t alloc_time;
+
+	num_blocks = num * nova_get_numblocks(btype);
+	if (num_blocks == 0) {
+		nova_dbg_verbose("%s: num_blocks == 0", __func__);
+		return -EINVAL;
+	}
+
+	NOVA_START_TIMING(new_blocks_t, alloc_time);
+	if (cpuid == ANY_CPU)
+		cpuid = smp_processor_id();
+
+retry:
+	free_list = nova_get_free_list(sb, cpuid);
+	spin_lock(&free_list->s_lock);
+
+	if (not_enough_blocks(free_list, num_blocks, atype)) {
+		nova_dbgv("%s: cpu %d, free_blocks %lu, required %lu, blocknode %lu\n",
+			  __func__, cpuid, free_list->num_free_blocks,
+			  num_blocks, free_list->num_blocknode);
+
+		if (retried >= 2)
+			/* Allocate anyway */
+			goto alloc;
+
+		spin_unlock(&free_list->s_lock);
+		cpuid = nova_get_candidate_free_list(sb);
+		retried++;
+		goto retry;
+	}
+alloc:
+	ret_blocks = nova_alloc_blocks_in_free_list(sb, free_list, btype, atype,
+					num_blocks, &new_blocknr, from_tail);
+
+	if (ret_blocks > 0) {
+		if (atype == LOG) {
+			free_list->alloc_log_count++;
+			free_list->alloc_log_pages += ret_blocks;
+		} else if (atype == DATA) {
+			free_list->alloc_data_count++;
+			free_list->alloc_data_pages += ret_blocks;
+		}
+	}
+
+	spin_unlock(&free_list->s_lock);
+	NOVA_END_TIMING(new_blocks_t, alloc_time);
+
+	if (ret_blocks <= 0 || new_blocknr == 0) {
+		nova_dbg_verbose("%s: not able to allocate %d blocks.  ret_blocks=%ld; new_blocknr=%lu",
+				 __func__, num, ret_blocks, new_blocknr);
+		return -ENOSPC;
+	}
+
+	if (zero) {
+		bp = nova_get_block(sb, nova_get_block_off(sb,
+						new_blocknr, btype));
+		memset_nt(bp, 0, PAGE_SIZE * ret_blocks);
+	}
+	*blocknr = new_blocknr;
+
+	nova_dbg_verbose("Alloc %lu NVMM blocks 0x%lx\n", ret_blocks, *blocknr);
+	return ret_blocks / nova_get_numblocks(btype);
+}
+
+// Allocate data blocks.  The offset for the allocated block comes back in
+// blocknr.  Return the number of blocks allocated.
+inline int nova_new_data_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long *blocknr,
+	unsigned long start_blk, unsigned int num,
+	enum nova_alloc_init zero, int cpu,
+	enum nova_alloc_direction from_tail)
+{
+	int allocated;
+	timing_t alloc_time;
+
+	NOVA_START_TIMING(new_data_blocks_t, alloc_time);
+	allocated = nova_new_blocks(sb, blocknr, num,
+			    sih->i_blk_type, zero, DATA, cpu, from_tail);
+	NOVA_END_TIMING(new_data_blocks_t, alloc_time);
+	if (allocated < 0) {
+		nova_dbgv("FAILED: Inode %lu, start blk %lu, alloc %d data blocks from %lu to %lu\n",
+			  sih->ino, start_blk, allocated, *blocknr,
+			  *blocknr + allocated - 1);
+	} else {
+		nova_dbgv("Inode %lu, start blk %lu, alloc %d data blocks from %lu to %lu\n",
+			  sih->ino, start_blk, allocated, *blocknr,
+			  *blocknr + allocated - 1);
+	}
+	return allocated;
+}
+
+
+// Allocate log blocks. The offset for the allocated block comes back in
+// blocknr.  Return the number of blocks allocated.
+inline int nova_new_log_blocks(struct super_block *sb,
+			struct nova_inode_info_header *sih,
+			unsigned long *blocknr, unsigned int num,
+			enum nova_alloc_init zero, int cpu,
+			enum nova_alloc_direction from_tail)
+{
+	int allocated;
+	timing_t alloc_time;
+
+	NOVA_START_TIMING(new_log_blocks_t, alloc_time);
+	allocated = nova_new_blocks(sb, blocknr, num,
+			    sih->i_blk_type, zero, LOG, cpu, from_tail);
+	NOVA_END_TIMING(new_log_blocks_t, alloc_time);
+	if (allocated < 0) {
+		nova_dbgv("%s: ino %lu, failed to alloc %d log blocks",
+			  __func__, sih->ino, num);
+	} else {
+		nova_dbgv("%s: ino %lu, alloc %d of %d log blocks %lu to %lu\n",
+			  __func__, sih->ino, allocated, num, *blocknr,
+			  *blocknr + allocated - 1);
+	}
+	return allocated;
+}
+
 /* We do not take locks so it's inaccurate */
 unsigned long nova_count_free_blocks(struct super_block *sb)
 {
diff --git a/fs/nova/balloc.h b/fs/nova/balloc.h
index 249eb72..463fbac 100644
--- a/fs/nova/balloc.h
+++ b/fs/nova/balloc.h
@@ -73,6 +73,16 @@ extern int nova_free_data_blocks(struct super_block *sb,
 	struct nova_inode_info_header *sih, unsigned long blocknr, int num);
 extern int nova_free_log_blocks(struct super_block *sb,
 	struct nova_inode_info_header *sih, unsigned long blocknr, int num);
+extern inline int nova_new_data_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long *blocknr,
+	unsigned long start_blk, unsigned int num,
+	enum nova_alloc_init zero, int cpu,
+	enum nova_alloc_direction from_tail);
+extern int nova_new_log_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	unsigned long *blocknr, unsigned int num,
+	enum nova_alloc_init zero, int cpu,
+	enum nova_alloc_direction from_tail);
 int nova_find_free_slot(struct nova_sb_info *sbi,
 	struct rb_root *tree, unsigned long range_low,
 	unsigned long range_high, struct nova_range_node **prev,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
