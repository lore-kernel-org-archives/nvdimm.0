Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD7B922603AE2
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:25 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id 93-v6so7012349plc.9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:44 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 23/83] Save allocator to pmem in put_super.
Date: Sat, 10 Mar 2018 10:18:04 -0800
Message-Id: <1520705944-6723-24-git-send-email-jix024@eng.ucsd.edu>
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

We allocate log pages and append free range node to the log of the reserved blocknode inode.
We can recover the allocator status by reading the log upon normal recovery.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/bbuild.h |   1 +
 fs/nova/inode.h  |  13 +++++++
 fs/nova/nova.h   |   7 ++++
 fs/nova/super.c  |   2 +
 5 files changed, 137 insertions(+)

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index 8bc0545..12a2f11 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -51,3 +51,117 @@ void nova_init_header(struct super_block *sb,
 	init_rwsem(&sih->i_sem);
 }
 
+static u64 nova_append_range_node_entry(struct super_block *sb,
+	struct nova_range_node *curr, u64 tail, unsigned long cpuid)
+{
+	u64 curr_p;
+	size_t size = sizeof(struct nova_range_node_lowhigh);
+	struct nova_range_node_lowhigh *entry;
+
+	curr_p = tail;
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
+	entry->range_low = cpu_to_le64(curr->range_low);
+	if (cpuid)
+		entry->range_low |= cpu_to_le64(cpuid << 56);
+	entry->range_high = cpu_to_le64(curr->range_high);
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
+	pi->log_head = new_block;
+	nova_update_tail(pi, temp_tail);
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 0);
+
+	nova_dbg("%s: %lu blocknodes, %lu log pages, pi head 0x%llx, tail 0x%llx\n",
+		  __func__, num_blocknode, num_pages,
+		  pi->log_head, pi->log_tail);
+}
+
diff --git a/fs/nova/bbuild.h b/fs/nova/bbuild.h
index 162a832..59cc379 100644
--- a/fs/nova/bbuild.h
+++ b/fs/nova/bbuild.h
@@ -3,5 +3,6 @@
 
 void nova_init_header(struct super_block *sb,
 	struct nova_inode_info_header *sih, u16 i_mode);
+void nova_save_blocknode_mappings_to_log(struct super_block *sb);
 
 #endif
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index dbd5256..0594ef3 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -123,6 +123,19 @@ static inline void sih_unlock_shared(struct nova_inode_info_header *header)
 	up_read(&header->i_sem);
 }
 
+static inline void nova_update_tail(struct nova_inode *pi, u64 new_tail)
+{
+	timing_t update_time;
+
+	NOVA_START_TIMING(update_tail_t, update_time);
+
+	PERSISTENT_BARRIER();
+	pi->log_tail = new_tail;
+	nova_flush_buffer(&pi->log_tail, CACHELINE_SIZE, 1);
+
+	NOVA_END_TIMING(update_tail_t, update_time);
+}
+
 static inline unsigned int
 nova_inode_blk_shift(struct nova_inode_info_header *sih)
 {
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index f5b4ec8..aa88d9f 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -303,6 +303,13 @@ static inline u64 nova_get_epoch_id(struct super_block *sb)
 #include "inode.h"
 #include "log.h"
 
+struct nova_range_node_lowhigh {
+	__le64 range_low;
+	__le64 range_high;
+};
+
+#define	RANGENODE_PER_PAGE	254
+
 /* A node in the RB tree representing a range of pages */
 struct nova_range_node {
 	struct rb_node node;
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 3500d19..7ee3f66 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -705,6 +705,8 @@ static void nova_put_super(struct super_block *sb)
 	struct nova_sb_info *sbi = NOVA_SB(sb);
 
 	if (sbi->virt_addr) {
+		/* Save everything before blocknode mapping! */
+		nova_save_blocknode_mappings_to_log(sb);
 		sbi->virt_addr = NULL;
 	}
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
