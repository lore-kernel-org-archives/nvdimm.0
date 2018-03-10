Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 721D922603AEC
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:29 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id u13-v6so7031461plq.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:48 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 26/83] Add inode_map to track inuse inodes.
Date: Sat, 10 Mar 2018 10:18:07 -0800
Message-Id: <1520705944-6723-27-git-send-email-jix024@eng.ucsd.edu>
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

NOVA uses per-CPU inode map to track inuse inodes.
It works in the same way as the allocator, the only difference is that inode map
tracks in-use inodes, while free list contains free ranges. NOVA always try
to allocate the first available inode number.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 190 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/inode.h |   3 +
 fs/nova/nova.h  |  10 +++
 fs/nova/super.c |  44 +++++++++++++
 fs/nova/super.h |   9 +++
 5 files changed, 256 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 4e2842d..7c10d0e 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -29,6 +29,43 @@
 unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX] = {12, 21, 30};
 uint32_t blk_type_to_size[NOVA_BLOCK_TYPE_MAX] = {0x1000, 0x200000, 0x40000000};
 
+int nova_init_inode_inuse_list(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_range_node *range_node;
+	struct inode_map *inode_map;
+	unsigned long range_high;
+	int i;
+	int ret;
+
+	sbi->s_inodes_used_count = NOVA_NORMAL_INODE_START;
+
+	range_high = NOVA_NORMAL_INODE_START / sbi->cpus;
+	if (NOVA_NORMAL_INODE_START % sbi->cpus)
+		range_high++;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		range_node = nova_alloc_inode_node(sb);
+		if (range_node == NULL)
+			/* FIXME: free allocated memories */
+			return -ENOMEM;
+
+		range_node->range_low = 0;
+		range_node->range_high = range_high;
+		ret = nova_insert_inodetree(sbi, range_node, i);
+		if (ret) {
+			nova_err(sb, "%s failed\n", __func__);
+			nova_free_inode_node(sb, range_node);
+			return ret;
+		}
+		inode_map->num_range_node_inode = 1;
+		inode_map->first_inode_range = range_node;
+	}
+
+	return 0;
+}
+
 static int nova_alloc_inode_table(struct super_block *sb,
 	struct nova_inode_info_header *sih)
 {
@@ -298,3 +335,156 @@ struct inode *nova_iget(struct super_block *sb, unsigned long ino)
 	return ERR_PTR(err);
 }
 
+inline int nova_insert_inodetree(struct nova_sb_info *sbi,
+	struct nova_range_node *new_node, int cpu)
+{
+	struct rb_root *tree;
+	int ret;
+
+	tree = &sbi->inode_maps[cpu].inode_inuse_tree;
+	ret = nova_insert_range_node(tree, new_node);
+	if (ret)
+		nova_dbg("ERROR: %s failed %d\n", __func__, ret);
+
+	return ret;
+}
+
+static inline int nova_search_inodetree(struct nova_sb_info *sbi,
+	unsigned long ino, struct nova_range_node **ret_node)
+{
+	struct rb_root *tree;
+	unsigned long internal_ino;
+	int cpu;
+
+	cpu = ino % sbi->cpus;
+	tree = &sbi->inode_maps[cpu].inode_inuse_tree;
+	internal_ino = ino / sbi->cpus;
+	return nova_find_range_node(sbi, tree, internal_ino, ret_node);
+}
+
+int nova_alloc_unused_inode(struct super_block *sb, int cpuid,
+	unsigned long *ino)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	struct nova_range_node *i, *next_i;
+	struct rb_node *temp, *next;
+	unsigned long next_range_low;
+	unsigned long new_ino;
+	unsigned long MAX_INODE = 1UL << 31;
+
+	inode_map = &sbi->inode_maps[cpuid];
+	i = inode_map->first_inode_range;
+	NOVA_ASSERT(i);
+
+	temp = &i->node;
+	next = rb_next(temp);
+
+	if (!next) {
+		next_i = NULL;
+		next_range_low = MAX_INODE;
+	} else {
+		next_i = container_of(next, struct nova_range_node, node);
+		next_range_low = next_i->range_low;
+	}
+
+	new_ino = i->range_high + 1;
+
+	if (next_i && new_ino == (next_range_low - 1)) {
+		/* Fill the gap completely */
+		i->range_high = next_i->range_high;
+		rb_erase(&next_i->node, &inode_map->inode_inuse_tree);
+		nova_free_inode_node(sb, next_i);
+		inode_map->num_range_node_inode--;
+	} else if (new_ino < (next_range_low - 1)) {
+		/* Aligns to left */
+		i->range_high = new_ino;
+	} else {
+		nova_dbg("%s: ERROR: new ino %lu, next low %lu\n", __func__,
+			new_ino, next_range_low);
+		return -ENOSPC;
+	}
+
+	*ino = new_ino * sbi->cpus + cpuid;
+	sbi->s_inodes_used_count++;
+	inode_map->allocated++;
+
+	nova_dbg_verbose("Alloc ino %lu\n", *ino);
+	return 0;
+}
+
+int nova_free_inuse_inode(struct super_block *sb, unsigned long ino)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	struct nova_range_node *i = NULL;
+	struct nova_range_node *curr_node;
+	int found = 0;
+	int cpuid = ino % sbi->cpus;
+	unsigned long internal_ino = ino / sbi->cpus;
+	int ret = 0;
+
+	nova_dbg_verbose("Free inuse ino: %lu\n", ino);
+	inode_map = &sbi->inode_maps[cpuid];
+
+	mutex_lock(&inode_map->inode_table_mutex);
+	found = nova_search_inodetree(sbi, ino, &i);
+	if (!found) {
+		nova_dbg("%s ERROR: ino %lu not found\n", __func__, ino);
+		mutex_unlock(&inode_map->inode_table_mutex);
+		return -EINVAL;
+	}
+
+	if ((internal_ino == i->range_low) && (internal_ino == i->range_high)) {
+		/* fits entire node */
+		rb_erase(&i->node, &inode_map->inode_inuse_tree);
+		nova_free_inode_node(sb, i);
+		inode_map->num_range_node_inode--;
+		goto block_found;
+	}
+	if ((internal_ino == i->range_low) && (internal_ino < i->range_high)) {
+		/* Aligns left */
+		i->range_low = internal_ino + 1;
+		goto block_found;
+	}
+	if ((internal_ino > i->range_low) && (internal_ino == i->range_high)) {
+		/* Aligns right */
+		i->range_high = internal_ino - 1;
+		goto block_found;
+	}
+	if ((internal_ino > i->range_low) && (internal_ino < i->range_high)) {
+		/* Aligns somewhere in the middle */
+		curr_node = nova_alloc_inode_node(sb);
+		NOVA_ASSERT(curr_node);
+		if (curr_node == NULL) {
+			/* returning without freeing the block */
+			goto block_found;
+		}
+		curr_node->range_low = internal_ino + 1;
+		curr_node->range_high = i->range_high;
+
+		i->range_high = internal_ino - 1;
+
+		ret = nova_insert_inodetree(sbi, curr_node, cpuid);
+		if (ret) {
+			nova_free_inode_node(sb, curr_node);
+			goto err;
+		}
+		inode_map->num_range_node_inode++;
+		goto block_found;
+	}
+
+err:
+	nova_error_mng(sb, "Unable to free inode %lu\n", ino);
+	nova_error_mng(sb, "Found inuse block %lu - %lu\n",
+				 i->range_low, i->range_high);
+	mutex_unlock(&inode_map->inode_table_mutex);
+	return ret;
+
+block_found:
+	sbi->s_inodes_used_count--;
+	inode_map->freed++;
+	mutex_unlock(&inode_map->inode_table_mutex);
+	return ret;
+}
+
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index a88f0a2..497343d 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -221,9 +221,12 @@ static inline int nova_persist_inode(struct nova_inode *pi)
 }
 
 
+int nova_init_inode_inuse_list(struct super_block *sb);
 int nova_init_inode_table(struct super_block *sb);
 int nova_get_inode_address(struct super_block *sb, u64 ino,
 	u64 *pi_addr, int extendable);
 struct inode *nova_iget(struct super_block *sb, unsigned long ino);
+inline int nova_insert_inodetree(struct nova_sb_info *sbi,
+	struct nova_range_node *new_node, int cpu);
 
 #endif
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index aa88d9f..bf4b6ac 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -318,6 +318,16 @@ struct nova_range_node {
 };
 
 #include "bbuild.h"
+
+struct inode_map {
+	struct mutex		inode_table_mutex;
+	struct rb_root		inode_inuse_tree;
+	unsigned long		num_range_node_inode;
+	struct nova_range_node *first_inode_range;
+	int			allocated;
+	int			freed;
+};
+
 #include "balloc.h"
 
 static inline unsigned long
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 32fe29b..9b60873 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -378,6 +378,9 @@ static struct nova_inode *nova_init(struct super_block *sb,
 
 	nova_init_blockmap(sb, 0);
 
+	if (nova_init_inode_inuse_list(sb) < 0)
+		return ERR_PTR(-EINVAL);
+
 	if (nova_init_inode_table(sb) < 0)
 		return ERR_PTR(-EINVAL);
 
@@ -420,6 +423,7 @@ static inline void set_default_opts(struct nova_sb_info *sbi)
 	sbi->head_reserved_blocks = HEAD_RESERVED_BLOCKS;
 	sbi->tail_reserved_blocks = TAIL_RESERVED_BLOCKS;
 	sbi->cpus = num_online_cpus();
+	sbi->map_id = 0;
 }
 
 static void nova_root_check(struct super_block *sb, struct nova_inode *root_pi)
@@ -481,9 +485,11 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	struct nova_sb_info *sbi = NULL;
 	struct nova_inode *root_pi;
 	struct inode *root_i = NULL;
+	struct inode_map *inode_map;
 	unsigned long blocksize;
 	u32 random = 0;
 	int retval = -EINVAL;
+	int i;
 	timing_t mount_time;
 
 	NOVA_START_TIMING(mount_t, mount_time);
@@ -533,6 +539,21 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->gid = current_fsgid();
 	set_opt(sbi->s_mount_opt, HUGEIOREMAP);
 
+	sbi->inode_maps = kcalloc(sbi->cpus, sizeof(struct inode_map),
+					GFP_KERNEL);
+	if (!sbi->inode_maps) {
+		retval = -ENOMEM;
+		nova_dbg("%s: Allocating inode maps failed.",
+			 __func__);
+		goto out;
+	}
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		mutex_init(&inode_map->inode_table_mutex);
+		inode_map->inode_inuse_tree = RB_ROOT;
+	}
+
 	mutex_init(&sbi->s_lock);
 
 	sbi->zeroed_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -625,6 +646,9 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 
 	nova_delete_free_lists(sb);
 
+	kfree(sbi->inode_maps);
+	sbi->inode_maps = NULL;
+
 	kfree(sbi->nova_sb);
 	kfree(sbi);
 	nova_dbg("%s failed: return %d\n", __func__, retval);
@@ -706,6 +730,8 @@ static int nova_remount(struct super_block *sb, int *mntflags, char *data)
 static void nova_put_super(struct super_block *sb)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_map *inode_map;
+	int i;
 
 	if (sbi->virt_addr) {
 		/* Save everything before blocknode mapping! */
@@ -718,6 +744,13 @@ static void nova_put_super(struct super_block *sb)
 	kfree(sbi->zeroed_page);
 	nova_dbgmask = 0;
 
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_map = &sbi->inode_maps[i];
+		nova_dbgv("CPU %d: inode allocated %d, freed %d\n",
+			i, inode_map->allocated, inode_map->freed);
+	}
+
+	kfree(sbi->inode_maps);
 	kfree(sbi->nova_sb);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
@@ -728,6 +761,12 @@ inline void nova_free_range_node(struct nova_range_node *node)
 	kmem_cache_free(nova_range_node_cachep, node);
 }
 
+inline void nova_free_inode_node(struct super_block *sb,
+	struct nova_range_node *node)
+{
+	nova_free_range_node(node);
+}
+
 inline struct nova_range_node *nova_alloc_range_node(struct super_block *sb)
 {
 	struct nova_range_node *p;
@@ -737,6 +776,11 @@ inline struct nova_range_node *nova_alloc_range_node(struct super_block *sb)
 	return p;
 }
 
+inline struct nova_range_node *nova_alloc_inode_node(struct super_block *sb)
+{
+	return nova_alloc_range_node(sb);
+}
+
 static struct inode *nova_alloc_inode(struct super_block *sb)
 {
 	struct nova_inode_info *vi;
diff --git a/fs/nova/super.h b/fs/nova/super.h
index dcafbd8..9772d2f 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -119,6 +119,12 @@ struct nova_sb_info {
 	/* ZEROED page for cache page initialized */
 	void *zeroed_page;
 
+	/* Per-CPU inode map */
+	struct inode_map	*inode_maps;
+
+	/* Decide new inode map id */
+	unsigned long map_id;
+
 	/* Per-CPU free block list */
 	struct free_list *free_lists;
 	unsigned long per_list_blocks;
@@ -150,6 +156,9 @@ static inline struct nova_super_block *nova_get_super(struct super_block *sb)
 
 extern void nova_error_mng(struct super_block *sb, const char *fmt, ...);
 extern struct nova_range_node *nova_alloc_range_node(struct super_block *sb);
+extern inline struct nova_range_node *nova_alloc_inode_node(struct super_block *sb);
 extern void nova_free_range_node(struct nova_range_node *node);
+extern inline void nova_free_inode_node(struct super_block *sb,
+	struct nova_range_node *node);
 
 #endif
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
