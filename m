Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE59822603B1D
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:43 -0800 (PST)
Received: by mail-pf0-x242.google.com with SMTP id j20so2625215pfi.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:02 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 38/83] Journal: NOVA lite journal initialization.
Date: Sat, 10 Mar 2018 10:18:19 -0800
Message-Id: <1520705944-6723-39-git-send-email-jix024@eng.ucsd.edu>
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

NOVA uses per-CPU spinlock to protect the journals.
Lite journal initialization consists of two parts:
for a new NOVA instance, hard_init allocates the journal pages.
soft_init initializes the locks and performs journal recovery.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/journal.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/journal.h |  2 ++
 fs/nova/super.c   | 15 ++++++++++++
 fs/nova/super.h   |  3 +++
 4 files changed, 90 insertions(+)

diff --git a/fs/nova/journal.c b/fs/nova/journal.c
index 0e203fa..d2578e2 100644
--- a/fs/nova/journal.c
+++ b/fs/nova/journal.c
@@ -340,3 +340,73 @@ void nova_commit_lite_transaction(struct super_block *sb, u64 tail, int cpu)
 	pair->journal_head = tail;
 	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
 }
+
+/**************************** Initialization ******************************/
+
+// Initialized DRAM journal state, validate, and recover
+int nova_lite_journal_soft_init(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct journal_ptr_pair *pair;
+	int i;
+	int ret = 0;
+
+	sbi->journal_locks = kcalloc(sbi->cpus, sizeof(spinlock_t),
+				     GFP_KERNEL);
+	if (!sbi->journal_locks)
+		return -ENOMEM;
+
+	for (i = 0; i < sbi->cpus; i++)
+		spin_lock_init(&sbi->journal_locks[i]);
+
+	for (i = 0; i < sbi->cpus; i++) {
+		pair = nova_get_journal_pointers(sb, i);
+		if (pair->journal_head == pair->journal_tail)
+			continue;
+
+		/* Ensure all entries are genuine */
+		ret = nova_check_journal_entries(sb, pair);
+		if (ret) {
+			nova_err(sb, "Journal %d checksum failure\n", i);
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = nova_recover_lite_journal(sb, pair);
+	}
+
+	return ret;
+}
+
+/* Initialized persistent journal state */
+int nova_lite_journal_hard_init(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info_header sih;
+	struct journal_ptr_pair *pair;
+	unsigned long blocknr = 0;
+	int allocated;
+	int i;
+	u64 block;
+
+	sih.ino = NOVA_LITEJOURNAL_INO;
+	sih.i_blk_type = NOVA_BLOCK_TYPE_4K;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		pair = nova_get_journal_pointers(sb, i);
+
+		allocated = nova_new_log_blocks(sb, &sih, &blocknr, 1,
+			ALLOC_INIT_ZERO, ANY_CPU, ALLOC_FROM_HEAD);
+		nova_dbg_verbose("%s: allocate log @ 0x%lx\n", __func__,
+							blocknr);
+		if (allocated != 1 || blocknr == 0)
+			return -ENOSPC;
+
+		block = nova_get_block_off(sb, blocknr, NOVA_BLOCK_TYPE_4K);
+		pair->journal_head = pair->journal_tail = block;
+		nova_flush_buffer(pair, CACHELINE_SIZE, 0);
+	}
+
+	PERSISTENT_BARRIER();
+	return nova_lite_journal_soft_init(sb);
+}
diff --git a/fs/nova/journal.h b/fs/nova/journal.h
index 2259880..6e3a528 100644
--- a/fs/nova/journal.h
+++ b/fs/nova/journal.h
@@ -50,5 +50,7 @@ u64 nova_create_rename_transaction(struct super_block *sb,
 u64 nova_create_logentry_transaction(struct super_block *sb,
 	void *entry, enum nova_entry_type type, int cpu);
 void nova_commit_lite_transaction(struct super_block *sb, u64 tail, int cpu);
+int nova_lite_journal_soft_init(struct super_block *sb);
+int nova_lite_journal_hard_init(struct super_block *sb);
 
 #endif
diff --git a/fs/nova/super.c b/fs/nova/super.c
index d73c202..216d396 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -379,6 +379,11 @@ static struct nova_inode *nova_init(struct super_block *sb,
 
 	nova_init_blockmap(sb, 0);
 
+	if (nova_lite_journal_hard_init(sb) < 0) {
+		nova_err(sb, "Lite journal hard initialization failed\n");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (nova_init_inode_inuse_list(sb) < 0)
 		return ERR_PTR(-EINVAL);
 
@@ -598,6 +603,12 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 	}
 
+	if (nova_lite_journal_soft_init(sb)) {
+		retval = -EINVAL;
+		nova_err(sb, "Lite journal initialization failed\n");
+		goto out;
+	}
+
 	blocksize = le32_to_cpu(sbi->nova_sb->s_blocksize);
 	nova_set_blocksize(sb, blocksize);
 
@@ -647,6 +658,9 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 
 	nova_delete_free_lists(sb);
 
+	kfree(sbi->journal_locks);
+	sbi->journal_locks = NULL;
+
 	kfree(sbi->inode_maps);
 	sbi->inode_maps = NULL;
 
@@ -745,6 +759,7 @@ static void nova_put_super(struct super_block *sb)
 
 	kfree(sbi->zeroed_page);
 	nova_dbgmask = 0;
+	kfree(sbi->journal_locks);
 
 	for (i = 0; i < sbi->cpus; i++) {
 		inode_map = &sbi->inode_maps[i];
diff --git a/fs/nova/super.h b/fs/nova/super.h
index 9772d2f..56a840e 100644
--- a/fs/nova/super.h
+++ b/fs/nova/super.h
@@ -119,6 +119,9 @@ struct nova_sb_info {
 	/* ZEROED page for cache page initialized */
 	void *zeroed_page;
 
+	/* Per-CPU journal lock */
+	spinlock_t *journal_locks;
+
 	/* Per-CPU inode map */
 	struct inode_map	*inode_maps;
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
