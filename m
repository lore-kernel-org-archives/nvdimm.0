Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C09422603B1C
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:42 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id j2so2613993pff.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:01 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 37/83] Journal: Lite journal create and commit.
Date: Sat, 10 Mar 2018 10:18:18 -0800
Message-Id: <1520705944-6723-38-git-send-email-jix024@eng.ucsd.edu>
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

NOVA uses lite journal to perform light weight transaction.
Instead of journaling metadata/data changes directly,
NOVA first append updates to each inode's log, and then
journal the log tail pointers to make sure all the logs
are updated atomically. For inode creation and deletion,
NOVA journals the inode's valid field.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/journal.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/journal.h |  11 ++++
 2 files changed, 190 insertions(+)

diff --git a/fs/nova/journal.c b/fs/nova/journal.c
index f31de97..0e203fa 100644
--- a/fs/nova/journal.c
+++ b/fs/nova/journal.c
@@ -161,3 +161,182 @@ static int nova_recover_lite_journal(struct super_block *sb,
 
 	return 0;
 }
+
+/**************************** Create/commit ******************************/
+
+/* Create and append an undo entry for a small update to PMEM. */
+static u64 nova_append_entry_journal(struct super_block *sb,
+	u64 curr_p, void *field)
+{
+	struct nova_lite_journal_entry *entry;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 *aligned_field;
+	u64 addr;
+
+	entry = (struct nova_lite_journal_entry *)nova_get_block(sb,
+							curr_p);
+	entry->type = cpu_to_le64(JOURNAL_ENTRY);
+	entry->padding = 0;
+	/* Align to 8 bytes */
+	aligned_field = (u64 *)((unsigned long)field & ~7UL);
+	/* Store the offset from the start of Nova instead of the pointer */
+	addr = (u64)nova_get_addr_off(sbi, aligned_field);
+	entry->data1 = cpu_to_le64(addr);
+	entry->data2 = cpu_to_le64(*aligned_field);
+	nova_update_journal_entry_csum(sb, entry);
+
+	curr_p = next_lite_journal(curr_p);
+	return curr_p;
+}
+
+static u64 nova_journal_inode_tail(struct super_block *sb,
+	u64 curr_p, struct nova_inode *pi)
+{
+	curr_p = nova_append_entry_journal(sb, curr_p, &pi->log_tail);
+
+	return curr_p;
+}
+
+/* Create and append undo log entries for creating a new file or directory. */
+static u64 nova_append_inode_journal(struct super_block *sb,
+	u64 curr_p, struct inode *inode, int new_inode,
+	int invalidate, int is_dir)
+{
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+
+	if (!pi) {
+		nova_err(sb, "%s: get inode failed\n", __func__);
+		return curr_p;
+	}
+
+	if (is_dir)
+		return nova_journal_inode_tail(sb, curr_p, pi);
+
+	if (new_inode) {
+		curr_p = nova_append_entry_journal(sb, curr_p,
+						&pi->valid);
+	} else {
+		curr_p = nova_journal_inode_tail(sb, curr_p, pi);
+		if (invalidate) {
+			curr_p = nova_append_entry_journal(sb, curr_p,
+						&pi->valid);
+			curr_p = nova_append_entry_journal(sb, curr_p,
+						&pi->delete_epoch_id);
+		}
+	}
+
+	return curr_p;
+}
+
+static u64 nova_append_dentry_journal(struct super_block *sb,
+	u64 curr_p, struct nova_dentry *dentry)
+{
+	curr_p = nova_append_entry_journal(sb, curr_p, &dentry->ino);
+	curr_p = nova_append_entry_journal(sb, curr_p, &dentry->csum);
+	return curr_p;
+}
+
+/* Journaled transactions for inode creation */
+u64 nova_create_inode_transaction(struct super_block *sb,
+	struct inode *inode, struct inode *dir, int cpu,
+	int new_inode, int invalidate)
+{
+	struct journal_ptr_pair *pair;
+	u64 temp;
+
+	pair = nova_get_journal_pointers(sb, cpu);
+
+	temp = pair->journal_head;
+
+	temp = nova_append_inode_journal(sb, temp, inode,
+					new_inode, invalidate, 0);
+
+	temp = nova_append_inode_journal(sb, temp, dir,
+					new_inode, invalidate, 1);
+
+	pair->journal_tail = temp;
+	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
+
+	nova_dbgv("%s: head 0x%llx, tail 0x%llx\n",
+			__func__, pair->journal_head, pair->journal_tail);
+	return temp;
+}
+
+/* Journaled transactions for rename operations */
+u64 nova_create_rename_transaction(struct super_block *sb,
+	struct inode *old_inode, struct inode *old_dir, struct inode *new_inode,
+	struct inode *new_dir, struct nova_dentry *father_entry,
+	int invalidate_new_inode, int cpu)
+{
+	struct journal_ptr_pair *pair;
+	u64 temp;
+
+	pair = nova_get_journal_pointers(sb, cpu);
+
+	temp = pair->journal_head;
+
+	/* Journal tails for old inode */
+	temp = nova_append_inode_journal(sb, temp, old_inode, 0, 0, 0);
+
+	/* Journal tails for old dir */
+	temp = nova_append_inode_journal(sb, temp, old_dir, 0, 0, 1);
+
+	if (new_inode) {
+		/* New inode may be unlinked */
+		temp = nova_append_inode_journal(sb, temp, new_inode, 0,
+					invalidate_new_inode, 0);
+	}
+
+	if (new_dir)
+		temp = nova_append_inode_journal(sb, temp, new_dir, 0, 0, 1);
+
+	if (father_entry)
+		temp = nova_append_dentry_journal(sb, temp, father_entry);
+
+	pair->journal_tail = temp;
+	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
+
+	nova_dbgv("%s: head 0x%llx, tail 0x%llx\n",
+			__func__, pair->journal_head, pair->journal_tail);
+	return temp;
+}
+
+/* For log entry inplace update */
+u64 nova_create_logentry_transaction(struct super_block *sb,
+	void *entry, enum nova_entry_type type, int cpu)
+{
+	struct journal_ptr_pair *pair;
+	size_t size = 0;
+	int i, count;
+	u64 temp;
+
+	pair = nova_get_journal_pointers(sb, cpu);
+
+	size = nova_get_log_entry_size(sb, type);
+
+	temp = pair->journal_head;
+
+	count = size / 8;
+	for (i = 0; i < count; i++) {
+		temp = nova_append_entry_journal(sb, temp,
+						(char *)entry + i * 8);
+	}
+
+	pair->journal_tail = temp;
+	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
+
+	nova_dbgv("%s: head 0x%llx, tail 0x%llx\n",
+			__func__, pair->journal_head, pair->journal_tail);
+	return temp;
+}
+
+/* Commit the transactions by dropping the journal entries */
+void nova_commit_lite_transaction(struct super_block *sb, u64 tail, int cpu)
+{
+	struct journal_ptr_pair *pair;
+
+	pair = nova_get_journal_pointers(sb, cpu);
+
+	pair->journal_head = tail;
+	nova_flush_buffer(&pair->journal_head, CACHELINE_SIZE, 1);
+}
diff --git a/fs/nova/journal.h b/fs/nova/journal.h
index d1d0ffb..2259880 100644
--- a/fs/nova/journal.h
+++ b/fs/nova/journal.h
@@ -40,4 +40,15 @@ struct journal_ptr_pair *nova_get_journal_pointers(struct super_block *sb,
 }
 
 
+u64 nova_create_inode_transaction(struct super_block *sb,
+	struct inode *inode, struct inode *dir, int cpu,
+	int new_inode, int invalidate);
+u64 nova_create_rename_transaction(struct super_block *sb,
+	struct inode *old_inode, struct inode *old_dir, struct inode *new_inode,
+	struct inode *new_dir, struct nova_dentry *father_entry,
+	int invalidate_new_inode, int cpu);
+u64 nova_create_logentry_transaction(struct super_block *sb,
+	void *entry, enum nova_entry_type type, int cpu);
+void nova_commit_lite_transaction(struct super_block *sb, u64 tail, int cpu);
+
 #endif
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
