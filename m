Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F333C22603AE2
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:26 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id f23-v6so7023831plr.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:45 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 24/83] Initialize and allocate inode table.
Date: Sat, 10 Mar 2018 10:18:05 -0800
Message-Id: <1520705944-6723-25-git-send-email-jix024@eng.ucsd.edu>
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

Inode table is a singly linked list of 2MB pages.
Each CPU has one inode table with initial size 2MB.
The inode table addresses are stored in the
INODE_TABLE_START of the pmem range.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/inode.h | 26 ++++++++++++++++++++++++++
 fs/nova/super.c |  3 +++
 3 files changed, 84 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index f7d6410..42816ff 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -29,6 +29,61 @@
 unsigned int blk_type_to_shift[NOVA_BLOCK_TYPE_MAX] = {12, 21, 30};
 uint32_t blk_type_to_size[NOVA_BLOCK_TYPE_MAX] = {0x1000, 0x200000, 0x40000000};
 
+static int nova_alloc_inode_table(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct inode_table *inode_table;
+	unsigned long blocknr;
+	u64 block;
+	int allocated;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		inode_table = nova_get_inode_table(sb, i);
+		if (!inode_table)
+			return -EINVAL;
+
+		allocated = nova_new_log_blocks(sb, sih, &blocknr, 1,
+				ALLOC_INIT_ZERO, i, ALLOC_FROM_HEAD);
+
+		nova_dbgv("%s: allocate log @ 0x%lx\n", __func__,
+							blocknr);
+		if (allocated != 1 || blocknr == 0)
+			return -ENOSPC;
+
+		block = nova_get_block_off(sb, blocknr, NOVA_BLOCK_TYPE_2M);
+		inode_table->log_head = block;
+		nova_flush_buffer(inode_table, CACHELINE_SIZE, 0);
+	}
+
+	return 0;
+}
+
+int nova_init_inode_table(struct super_block *sb)
+{
+	struct nova_inode *pi = nova_get_inode_by_ino(sb, NOVA_INODETABLE_INO);
+	struct nova_inode_info_header sih;
+	int ret = 0;
+
+	pi->i_mode = 0;
+	pi->i_uid = 0;
+	pi->i_gid = 0;
+	pi->i_links_count = cpu_to_le16(1);
+	pi->i_flags = 0;
+	pi->nova_ino = NOVA_INODETABLE_INO;
+
+	pi->i_blk_type = NOVA_BLOCK_TYPE_2M;
+
+	sih.ino = NOVA_INODETABLE_INO;
+	sih.i_blk_type = NOVA_BLOCK_TYPE_2M;
+
+	ret = nova_alloc_inode_table(sb, &sih);
+
+	PERSISTENT_BARRIER();
+	return ret;
+}
+
 void nova_set_inode_flags(struct inode *inode, struct nova_inode *pi,
 	unsigned int flags)
 {
diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 0594ef3..a88f0a2 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -60,6 +60,13 @@ struct nova_inode {
 } __attribute((__packed__));
 
 /*
+ * Inode table.  It's a linked list of pages.
+ */
+struct inode_table {
+	__le64 log_head;
+};
+
+/*
  * NOVA-specific inode state kept in DRAM
  */
 struct nova_inode_info_header {
@@ -136,6 +143,22 @@ static inline void nova_update_tail(struct nova_inode *pi, u64 new_tail)
 	NOVA_END_TIMING(update_tail_t, update_time);
 }
 
+static inline
+struct inode_table *nova_get_inode_table(struct super_block *sb, int cpu)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int table_start;
+
+	if (cpu >= sbi->cpus)
+		return NULL;
+
+	table_start = INODE_TABLE_START;
+
+	return (struct inode_table *)((char *)nova_get_block(sb,
+		NOVA_DEF_BLOCK_SIZE_4K * table_start) +
+		cpu * CACHELINE_SIZE);
+}
+
 static inline unsigned int
 nova_inode_blk_shift(struct nova_inode_info_header *sih)
 {
@@ -197,7 +220,10 @@ static inline int nova_persist_inode(struct nova_inode *pi)
 	return 0;
 }
 
+
+int nova_init_inode_table(struct super_block *sb);
 int nova_get_inode_address(struct super_block *sb, u64 ino,
 	u64 *pi_addr, int extendable);
 struct inode *nova_iget(struct super_block *sb, unsigned long ino);
+
 #endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 7ee3f66..32fe29b 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -378,6 +378,9 @@ static struct nova_inode *nova_init(struct super_block *sb,
 
 	nova_init_blockmap(sb, 0);
 
+	if (nova_init_inode_table(sb) < 0)
+		return ERR_PTR(-EINVAL);
+
 	sbi->nova_sb->s_size = cpu_to_le64(size);
 	sbi->nova_sb->s_blocksize = cpu_to_le32(blocksize);
 	sbi->nova_sb->s_magic = cpu_to_le32(NOVA_SUPER_MAGIC);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
