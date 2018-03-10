Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B2292264D233
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:37 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id h11so2618067pfn.4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:56 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 82/83] Failure recovery: Per-CPU recovery.
Date: Sat, 10 Mar 2018 10:19:03 -0800
Message-Id: <1520705944-6723-83-git-send-email-jix024@eng.ucsd.edu>
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

NOVA starts a recovery thread on each CPU, and scans all the inodes
in a parallel way. It recovers the inode inuse list during the
scan as well.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c | 396 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 396 insertions(+)

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index 75dfcba..3271166 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -677,6 +677,11 @@ struct task_ring {
 	u64 *nvmm_array;
 };
 
+static struct task_ring *task_rings;
+static struct task_struct **threads;
+wait_queue_head_t finish_wq;
+int *finished;
+
 static int nova_traverse_inode_log(struct super_block *sb,
 	struct nova_inode *pi, struct scan_bitmap *bm, u64 head)
 {
@@ -973,6 +978,378 @@ static int nova_recover_inode_pages(struct super_block *sb,
 }
 
 
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
+		return -EINVAL;
+	}
+
+	cpu = ino_low % sbi->cpus;
+	if (ino_high % sbi->cpus != cpu) {
+		nova_err(sb, "%s: ino low %lu, ino high %lu\n",
+				__func__, ino_low, ino_high);
+		return -EINVAL;
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
+		nova_free_inode_node(sb, next);
+		goto finish;
+	}
+	if (prev && (internal_low == prev->range_high + 1)) {
+		/* Aligns left */
+		prev->range_high += internal_high - internal_low + 1;
+		goto finish;
+	}
+	if (next && (internal_high + 1 == next->range_low)) {
+		/* Aligns right */
+		next->range_low -= internal_high - internal_low + 1;
+		goto finish;
+	}
+
+	/* Aligns somewhere in the middle */
+	new_node = nova_alloc_inode_node(sb);
+	NOVA_ASSERT(new_node);
+	new_node->range_low = internal_low;
+	new_node->range_high = internal_high;
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
+	u64 curr;
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
+					/* Deleteable */
+					pi->deleted = 1;
+					fake_pi.deleted = 1;
+					continue;
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
+	int ret = 0;
+	int count;
+	int cpuid;
+
+	root_addr = nova_get_reserved_inode_addr(sb, NOVA_ROOT_INO);
+
+	for (cpuid = 0; cpuid < sbi->cpus; cpuid++) {
+		ring = &task_rings[cpuid];
+		inode_table = nova_get_inode_table(sb, cpuid);
+		if (!inode_table)
+			return -EINVAL;
+
+		count = 0;
+		curr = inode_table->log_head;
+		while (curr) {
+			if (ring->num >= 512) {
+				nova_err(sb, "%s: ring size too small\n",
+					 __func__);
+				return -EINVAL;
+			}
+
+			ring->addr0[count] = curr;
+
+			count++;
+
+			curr_addr = (unsigned long)nova_get_block(sb,
+							curr);
+			/* Next page resides at the last 8 bytes */
+			curr_addr += 2097152 - 8;
+			curr = *(u64 *)(curr_addr);
+		}
+
+		if (count > ring->num)
+			ring->num = count;
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
+			sbi->s_inodes_used_count - NOVA_NORMAL_INODE_START);
+	return ret;
+}
+
 /*********************** Recovery entrance *************************/
 
 /* Return TRUE if we can do a normal unmount recovery */
@@ -1027,7 +1404,23 @@ int nova_recovery(struct super_block *sb)
 	nova_init_blockmap(sb, 1);
 
 	value = nova_try_normal_recovery(sb);
+	if (value) {
+		nova_dbg("NOVA: Normal shutdown\n");
+	} else {
+		nova_dbg("NOVA: Failure recovery\n");
+		ret = alloc_bm(sb, initsize);
+		if (ret)
+			goto out;
+
+		sbi->s_inodes_used_count = 0;
+		ret = nova_failure_recovery(sb);
+		if (ret)
+			goto out;
 
+		ret = nova_build_blocknode_map(sb, initsize);
+	}
+
+out:
 	NOVA_END_TIMING(recovery_t, start);
 	if (measure_timing == 0) {
 		getrawmonotonic(&end);
@@ -1036,6 +1429,9 @@ int nova_recovery(struct super_block *sb)
 			(end.tv_nsec - start.tv_nsec);
 	}
 
+	if (!value)
+		free_bm(sb);
+
 	sbi->s_epoch_id = le64_to_cpu(super->s_epoch_id);
 	return ret;
 }
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
