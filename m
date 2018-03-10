Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 047112264D238
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:34 -0800 (PST)
Received: by mail-pf0-x243.google.com with SMTP id x1so2618050pfh.7
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:52 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 79/83] Normal recovery.
Date: Sat, 10 Mar 2018 10:19:00 -0800
Message-Id: <1520705944-6723-80-git-send-email-jix024@eng.ucsd.edu>
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

Upon umount, NOVA stores the allocator information and the inuse
inode list in reserved inodes. During remount, NOVA reads these
information and rebuild the allocator and inuse inode list DRAM
data structures.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c | 266 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/bbuild.h |   1 +
 fs/nova/super.c  |   3 +
 3 files changed, 270 insertions(+)

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index af1b352..ca51dca 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -52,6 +52,206 @@ void nova_init_header(struct super_block *sb,
 	init_rwsem(&sih->i_sem);
 }
 
+static inline int get_cpuid(struct nova_sb_info *sbi, unsigned long blocknr)
+{
+	return blocknr / sbi->per_list_blocks;
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
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_INODELIST_INO);
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
 static u64 nova_append_range_node_entry(struct super_block *sb,
 	struct nova_range_node *curr, u64 tail, unsigned long cpuid)
 {
@@ -214,3 +414,69 @@ void nova_save_blocknode_mappings_to_log(struct super_block *sb)
 		  pi->log_head, pi->log_tail);
 }
 
+/*********************** Recovery entrance *************************/
+
+/* Return TRUE if we can do a normal unmount recovery */
+static bool nova_try_normal_recovery(struct super_block *sb)
+{
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
+	return true;
+}
+
+/*
+ * Recovery routine has two tasks:
+ * 1. Restore inuse inode list;
+ * 2. Restore the NVMM allocator.
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
+
+	NOVA_END_TIMING(recovery_t, start);
+	if (measure_timing == 0) {
+		getrawmonotonic(&end);
+		Timingstats[recovery_t] +=
+			(end.tv_sec - start.tv_sec) * 1000000000 +
+			(end.tv_nsec - start.tv_nsec);
+	}
+
+	sbi->s_epoch_id = le64_to_cpu(super->s_epoch_id);
+	return ret;
+}
diff --git a/fs/nova/bbuild.h b/fs/nova/bbuild.h
index 5d2b5f0..2c3deb0 100644
--- a/fs/nova/bbuild.h
+++ b/fs/nova/bbuild.h
@@ -5,5 +5,6 @@ void nova_init_header(struct super_block *sb,
 	struct nova_inode_info_header *sih, u16 i_mode);
 void nova_save_inode_list_to_log(struct super_block *sb);
 void nova_save_blocknode_mappings_to_log(struct super_block *sb);
+int nova_recovery(struct super_block *sb);
 
 #endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 980b1d7..14b4af6 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -642,6 +642,9 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_xattr = NULL;
 	sb->s_flags |= MS_NOSEC;
 
+	if ((sbi->s_mount_opt & NOVA_MOUNT_FORMAT) == 0)
+		nova_recovery(sb);
+
 	root_i = nova_iget(sb, NOVA_ROOT_INO);
 	if (IS_ERR(root_i)) {
 		retval = PTR_ERR(root_i);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
