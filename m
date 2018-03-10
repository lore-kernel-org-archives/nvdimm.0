Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A68722603AEC
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:30 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g8so4832459pgv.7
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:49 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 27/83] Save the inode inuse list to pmem upon umount
Date: Sat, 10 Mar 2018 10:18:08 -0800
Message-Id: <1520705944-6723-28-git-send-email-jix024@eng.ucsd.edu>
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

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/bbuild.h |  1 +
 fs/nova/super.c  |  1 +
 3 files changed, 50 insertions(+)

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index 12a2f11..66053cb 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -116,6 +116,54 @@ static u64 nova_save_free_list_blocknodes(struct super_block *sb, int cpu,
 	return temp_tail;
 }
 
+void nova_save_inode_list_to_log(struct super_block *sb)
+{
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_INODELIST_INO);
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
+	sih.ino = NOVA_INODELIST_INO;
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
+	pi->log_head = new_block;
+	nova_update_tail(pi, temp_tail);
+	nova_flush_buffer(&pi->log_head, CACHELINE_SIZE, 0);
+
+	nova_dbg("%s: %lu inode nodes, pi head 0x%llx, tail 0x%llx\n",
+		__func__, num_nodes, pi->log_head, pi->log_tail);
+}
+
 void nova_save_blocknode_mappings_to_log(struct super_block *sb)
 {
 	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_BLOCKNODE_INO);
diff --git a/fs/nova/bbuild.h b/fs/nova/bbuild.h
index 59cc379..5d2b5f0 100644
--- a/fs/nova/bbuild.h
+++ b/fs/nova/bbuild.h
@@ -3,6 +3,7 @@
 
 void nova_init_header(struct super_block *sb,
 	struct nova_inode_info_header *sih, u16 i_mode);
+void nova_save_inode_list_to_log(struct super_block *sb);
 void nova_save_blocknode_mappings_to_log(struct super_block *sb);
 
 #endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 9b60873..69e4afc 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -734,6 +734,7 @@ static void nova_put_super(struct super_block *sb)
 	int i;
 
 	if (sbi->virt_addr) {
+		nova_save_inode_list_to_log(sb);
 		/* Save everything before blocknode mapping! */
 		nova_save_blocknode_mappings_to_log(sb);
 		sbi->virt_addr = NULL;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
