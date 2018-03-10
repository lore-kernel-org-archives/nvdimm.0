Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2E0D2258AF1B
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:20 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id m19so4837331pgn.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:39 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 19/83] Add pmem block free routines.
Date: Sat, 10 Mar 2018 10:18:00 -0800
Message-Id: <1520705944-6723-20-git-send-email-jix024@eng.ucsd.edu>
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

NOVA allocates/frees log pages and data pages in the same way.
For block free, NOVA first gets the corresponding free list by
checking the block number, and then inserts the freed range in
the red-black tree. NOVA always merge adjacent free ranges if possible.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/balloc.c | 223 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/balloc.h |   8 ++
 fs/nova/nova.h   |  23 ++++++
 3 files changed, 254 insertions(+)

diff --git a/fs/nova/balloc.c b/fs/nova/balloc.c
index 0742fe0..9108721 100644
--- a/fs/nova/balloc.c
+++ b/fs/nova/balloc.c
@@ -218,6 +218,229 @@ inline int nova_insert_blocktree(struct nova_sb_info *sbi,
 	return ret;
 }
 
+/* Used for both block free tree and inode inuse tree */
+int nova_find_free_slot(struct nova_sb_info *sbi,
+	struct rb_root *tree, unsigned long range_low,
+	unsigned long range_high, struct nova_range_node **prev,
+	struct nova_range_node **next)
+{
+	struct nova_range_node *ret_node = NULL;
+	struct rb_node *tmp;
+	int check_prev = 0, check_next = 0;
+	int ret;
+
+	ret = nova_find_range_node(sbi, tree, range_low, &ret_node);
+	if (ret) {
+		nova_dbg("%s ERROR: %lu - %lu already in free list\n",
+			__func__, range_low, range_high);
+		return -EINVAL;
+	}
+
+	if (!ret_node) {
+		*prev = *next = NULL;
+	} else if (ret_node->range_high < range_low) {
+		*prev = ret_node;
+		tmp = rb_next(&ret_node->node);
+		if (tmp) {
+			*next = container_of(tmp, struct nova_range_node, node);
+			check_next = 1;
+		} else {
+			*next = NULL;
+		}
+	} else if (ret_node->range_low > range_high) {
+		*next = ret_node;
+		tmp = rb_prev(&ret_node->node);
+		if (tmp) {
+			*prev = container_of(tmp, struct nova_range_node, node);
+			check_prev = 1;
+		} else {
+			*prev = NULL;
+		}
+	} else {
+		nova_dbg("%s ERROR: %lu - %lu overlaps with existing node %lu - %lu\n",
+			 __func__, range_low, range_high, ret_node->range_low,
+			ret_node->range_high);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * blocknr: start block number
+ * num: number of freed pages
+ * btype: is large page?
+ * log_page: is log page?
+ */
+static int nova_free_blocks(struct super_block *sb, unsigned long blocknr,
+	int num, unsigned short btype, int log_page)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct rb_root *tree;
+	unsigned long block_low;
+	unsigned long block_high;
+	unsigned long num_blocks = 0;
+	struct nova_range_node *prev = NULL;
+	struct nova_range_node *next = NULL;
+	struct nova_range_node *curr_node;
+	struct free_list *free_list;
+	int cpuid;
+	int new_node_used = 0;
+	int ret;
+	timing_t free_time;
+
+	if (num <= 0) {
+		nova_dbg("%s ERROR: free %d\n", __func__, num);
+		return -EINVAL;
+	}
+
+	NOVA_START_TIMING(free_blocks_t, free_time);
+	cpuid = blocknr / sbi->per_list_blocks;
+
+	/* Pre-allocate blocknode */
+	curr_node = nova_alloc_blocknode(sb);
+	if (curr_node == NULL) {
+		/* returning without freeing the block*/
+		NOVA_END_TIMING(free_blocks_t, free_time);
+		return -ENOMEM;
+	}
+
+	free_list = nova_get_free_list(sb, cpuid);
+	spin_lock(&free_list->s_lock);
+
+	tree = &(free_list->block_free_tree);
+
+	num_blocks = nova_get_numblocks(btype) * num;
+	block_low = blocknr;
+	block_high = blocknr + num_blocks - 1;
+
+	nova_dbgv("Free: %lu - %lu\n", block_low, block_high);
+
+	if (blocknr < free_list->block_start ||
+			blocknr + num > free_list->block_end + 1) {
+		nova_err(sb, "free blocks %lu to %lu, free list %d, start %lu, end %lu\n",
+				blocknr, blocknr + num - 1,
+				free_list->index,
+				free_list->block_start,
+				free_list->block_end);
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = nova_find_free_slot(sbi, tree, block_low,
+					block_high, &prev, &next);
+
+	if (ret) {
+		nova_dbg("%s: find free slot fail: %d\n", __func__, ret);
+		goto out;
+	}
+
+	if (prev && next && (block_low == prev->range_high + 1) &&
+			(block_high + 1 == next->range_low)) {
+		/* fits the hole */
+		rb_erase(&next->node, tree);
+		free_list->num_blocknode--;
+		prev->range_high = next->range_high;
+		if (free_list->last_node == next)
+			free_list->last_node = prev;
+		nova_free_blocknode(sb, next);
+		goto block_found;
+	}
+	if (prev && (block_low == prev->range_high + 1)) {
+		/* Aligns left */
+		prev->range_high += num_blocks;
+		goto block_found;
+	}
+	if (next && (block_high + 1 == next->range_low)) {
+		/* Aligns right */
+		next->range_low -= num_blocks;
+		goto block_found;
+	}
+
+	/* Aligns somewhere in the middle */
+	curr_node->range_low = block_low;
+	curr_node->range_high = block_high;
+	new_node_used = 1;
+	ret = nova_insert_blocktree(sbi, tree, curr_node);
+	if (ret) {
+		new_node_used = 0;
+		goto out;
+	}
+	if (!prev)
+		free_list->first_node = curr_node;
+	if (!next)
+		free_list->last_node = curr_node;
+
+	free_list->num_blocknode++;
+
+block_found:
+	free_list->num_free_blocks += num_blocks;
+
+	if (log_page) {
+		free_list->free_log_count++;
+		free_list->freed_log_pages += num_blocks;
+	} else {
+		free_list->free_data_count++;
+		free_list->freed_data_pages += num_blocks;
+	}
+
+out:
+	spin_unlock(&free_list->s_lock);
+	if (new_node_used == 0)
+		nova_free_blocknode(sb, curr_node);
+
+	NOVA_END_TIMING(free_blocks_t, free_time);
+	return ret;
+}
+
+int nova_free_data_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr, int num)
+{
+	int ret;
+	timing_t free_time;
+
+	nova_dbgv("Inode %lu: free %d data block from %lu to %lu\n",
+			sih->ino, num, blocknr, blocknr + num - 1);
+	if (blocknr == 0) {
+		nova_dbg("%s: ERROR: %lu, %d\n", __func__, blocknr, num);
+		return -EINVAL;
+	}
+	NOVA_START_TIMING(free_data_t, free_time);
+	ret = nova_free_blocks(sb, blocknr, num, sih->i_blk_type, 0);
+	if (ret) {
+		nova_err(sb, "Inode %lu: free %d data block from %lu to %lu failed!\n",
+			 sih->ino, num, blocknr, blocknr + num - 1);
+		dump_stack();
+	}
+	NOVA_END_TIMING(free_data_t, free_time);
+
+	return ret;
+}
+
+int nova_free_log_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr, int num)
+{
+	int ret;
+	timing_t free_time;
+
+	nova_dbgv("Inode %lu: free %d log block from %lu to %lu\n",
+			sih->ino, num, blocknr, blocknr + num - 1);
+	if (blocknr == 0) {
+		nova_dbg("%s: ERROR: %lu, %d\n", __func__, blocknr, num);
+		return -EINVAL;
+	}
+	NOVA_START_TIMING(free_log_t, free_time);
+	ret = nova_free_blocks(sb, blocknr, num, sih->i_blk_type, 1);
+	if (ret) {
+		nova_err(sb, "Inode %lu: free %d log block from %lu to %lu failed!\n",
+			 sih->ino, num, blocknr, blocknr + num - 1);
+		dump_stack();
+	}
+	NOVA_END_TIMING(free_log_t, free_time);
+
+	return ret;
+}
+
 /* We do not take locks so it's inaccurate */
 unsigned long nova_count_free_blocks(struct super_block *sb)
 {
diff --git a/fs/nova/balloc.h b/fs/nova/balloc.h
index 537532e..249eb72 100644
--- a/fs/nova/balloc.h
+++ b/fs/nova/balloc.h
@@ -69,6 +69,14 @@ extern void nova_init_blockmap(struct super_block *sb, int recovery);
 extern unsigned long nova_count_free_blocks(struct super_block *sb);
 inline int nova_insert_blocktree(struct nova_sb_info *sbi,
 	struct rb_root *tree, struct nova_range_node *new_node);
+extern int nova_free_data_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr, int num);
+extern int nova_free_log_blocks(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr, int num);
+int nova_find_free_slot(struct nova_sb_info *sbi,
+	struct rb_root *tree, unsigned long range_low,
+	unsigned long range_high, struct nova_range_node **prev,
+	struct nova_range_node **next);
 
 extern int nova_insert_range_node(struct rb_root *tree,
 				  struct nova_range_node *new_node);
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 404e133..0992f50 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -312,6 +312,29 @@ struct nova_range_node {
 #include "bbuild.h"
 #include "balloc.h"
 
+static inline unsigned long
+nova_get_numblocks(unsigned short btype)
+{
+	unsigned long num_blocks;
+
+	if (btype == NOVA_BLOCK_TYPE_4K) {
+		num_blocks = 1;
+	} else if (btype == NOVA_BLOCK_TYPE_2M) {
+		num_blocks = 512;
+	} else {
+		//btype == NOVA_BLOCK_TYPE_1G
+		num_blocks = 0x40000;
+	}
+	return num_blocks;
+}
+
+static inline unsigned long
+nova_get_blocknr(struct super_block *sb, u64 block, unsigned short btype)
+{
+	return block >> PAGE_SHIFT;
+}
+
+
 /* ====================================================== */
 /* ==============  Function prototypes  ================= */
 /* ====================================================== */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
