Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0405922631475
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:51 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id g8so4832712pgv.7
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:10 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 45/83] Log operation: file inode log lookup and assign
Date: Sat, 10 Mar 2018 10:18:26 -0800
Message-Id: <1520705944-6723-46-git-send-email-jix024@eng.ucsd.edu>
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

After NOVA appends file write entry to commit new writes,
it updates the file offset radix tree, finds the old entries (if overwrite)
and reclaims the stale data blocks.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c  | 108 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.h  |   5 +++
 fs/nova/nova.h |  64 ++++++++++++++++++++++++++++++++++
 3 files changed, 177 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index d150f2e..451be27 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -102,6 +102,50 @@ static inline int nova_invalidate_write_entry(struct super_block *sb,
 							reassign, num_free);
 }
 
+unsigned int nova_free_old_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry,
+	unsigned long pgoff, unsigned int num_free,
+	bool delete_dead, u64 epoch_id)
+{
+	unsigned long old_nvmm;
+	timing_t free_time;
+
+	if (!entry)
+		return 0;
+
+	NOVA_START_TIMING(free_old_t, free_time);
+
+	old_nvmm = get_nvmm(sb, sih, entry, pgoff);
+
+	if (!delete_dead)
+		nova_invalidate_write_entry(sb, entry, 1, num_free);
+
+	nova_dbgv("%s: pgoff %lu, free %u blocks\n",
+				__func__, pgoff, num_free);
+	nova_free_data_blocks(sb, sih, old_nvmm, num_free);
+
+	sih->i_blocks -= num_free;
+
+	NOVA_END_TIMING(free_old_t, free_time);
+	return num_free;
+}
+
+struct nova_file_write_entry *nova_find_next_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, pgoff_t pgoff)
+{
+	struct nova_file_write_entry *entry = NULL;
+	struct nova_file_write_entry *entries[1];
+	int nr_entries;
+
+	nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pgoff, 1);
+	if (nr_entries == 1)
+		entry = entries[0];
+
+	return entry;
+}
+
 static void nova_update_setattr_entry(struct inode *inode,
 	struct nova_setattr_logentry *entry,
 	struct nova_log_entry_info *entry_info)
@@ -568,6 +612,70 @@ int nova_append_link_change_entry(struct super_block *sb,
 	return ret;
 }
 
+int nova_assign_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry,
+	bool free)
+{
+	struct nova_file_write_entry *old_entry;
+	struct nova_file_write_entry *start_old_entry = NULL;
+	void **pentry;
+	unsigned long start_pgoff = entry->pgoff;
+	unsigned long start_old_pgoff = 0;
+	unsigned int num = entry->num_pages;
+	unsigned int num_free = 0;
+	unsigned long curr_pgoff;
+	int i;
+	int ret = 0;
+	timing_t assign_time;
+
+	NOVA_START_TIMING(assign_t, assign_time);
+	for (i = 0; i < num; i++) {
+		curr_pgoff = start_pgoff + i;
+
+		pentry = radix_tree_lookup_slot(&sih->tree, curr_pgoff);
+		if (pentry) {
+			old_entry = radix_tree_deref_slot(pentry);
+			if (old_entry != start_old_entry) {
+				if (start_old_entry && free)
+					nova_free_old_entry(sb, sih,
+							start_old_entry,
+							start_old_pgoff,
+							num_free, false,
+							entry->epoch_id);
+				nova_invalidate_write_entry(sb,
+						start_old_entry, 1, 0);
+
+				start_old_entry = old_entry;
+				start_old_pgoff = curr_pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+
+			radix_tree_replace_slot(&sih->tree, pentry, entry);
+		} else {
+			ret = radix_tree_insert(&sih->tree, curr_pgoff, entry);
+			if (ret) {
+				nova_dbg("%s: ERROR %d\n", __func__, ret);
+				goto out;
+			}
+		}
+	}
+
+	if (start_old_entry && free)
+		nova_free_old_entry(sb, sih, start_old_entry,
+					start_old_pgoff, num_free, false,
+					entry->epoch_id);
+
+	nova_invalidate_write_entry(sb, start_old_entry, 1, 0);
+
+out:
+	NOVA_END_TIMING(assign_t, assign_time);
+
+	return ret;
+}
+
 int nova_inplace_update_write_entry(struct super_block *sb,
 	struct inode *inode, struct nova_file_write_entry *entry,
 	struct nova_log_entry_info *entry_info)
diff --git a/fs/nova/log.h b/fs/nova/log.h
index 2548083..f5149f7 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -398,4 +398,9 @@ int nova_free_contiguous_log_blocks(struct super_block *sb,
 int nova_free_inode_log(struct super_block *sb, struct nova_inode *pi,
 	struct nova_inode_info_header *sih);
 
+void nova_print_nova_log(struct super_block *sb,
+	struct nova_inode_info_header *sih);
+void nova_print_nova_log_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih);
+
 #endif
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 6cf3c33..8f085cf 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -342,6 +342,70 @@ static inline int old_entry_freeable(struct super_block *sb, u64 epoch_id)
 
 #include "balloc.h"
 
+static inline struct nova_file_write_entry *
+nova_get_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, unsigned long blocknr)
+{
+	struct nova_file_write_entry *entry;
+
+	entry = radix_tree_lookup(&sih->tree, blocknr);
+
+	return entry;
+}
+
+
+/*
+ * Find data at a file offset (pgoff) in the data pointed to by a write log
+ * entry.
+ */
+static inline unsigned long get_nvmm(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *entry, unsigned long pgoff)
+{
+	/* entry is already verified before this call and resides in dram
+	 * or we can do memcpy_mcsafe here but have to avoid double copy and
+	 * verification of the entry.
+	 */
+	if (entry->pgoff > pgoff || (unsigned long) entry->pgoff +
+			(unsigned long) entry->num_pages <= pgoff) {
+		struct nova_sb_info *sbi = NOVA_SB(sb);
+		u64 curr;
+
+		curr = nova_get_addr_off(sbi, entry);
+		nova_dbg("Entry ERROR: inode %lu, curr 0x%llx, pgoff %lu, entry pgoff %llu, num %u\n",
+			sih->ino,
+			curr, pgoff, entry->pgoff, entry->num_pages);
+		nova_print_nova_log_pages(sb, sih);
+		nova_print_nova_log(sb, sih);
+		NOVA_ASSERT(0);
+	}
+
+	return (unsigned long) (entry->block >> PAGE_SHIFT) + pgoff
+		- entry->pgoff;
+}
+
+static inline u64 nova_find_nvmm_block(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	unsigned long blocknr)
+{
+	unsigned long nvmm;
+	struct nova_file_write_entry *entryc, entry_copy;
+
+	if (!entry) {
+		entry = nova_get_write_entry(sb, sih, blocknr);
+		if (!entry)
+			return 0;
+	}
+
+	entryc = &entry_copy;
+	if (memcpy_mcsafe(entryc, entry,
+			sizeof(struct nova_file_write_entry)) < 0)
+		return 0;
+
+	nvmm = get_nvmm(sb, sih, entryc, blocknr);
+	return nvmm << PAGE_SHIFT;
+}
+
 static inline unsigned long
 nova_get_numblocks(unsigned short btype)
 {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
