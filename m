Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38DE82264D228
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:32 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id 68so2620266pfx.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:51 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 78/83] GC: Thorough garbage collection.
Date: Sat, 10 Mar 2018 10:18:59 -0800
Message-Id: <1520705944-6723-79-git-send-email-jix024@eng.ucsd.edu>
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

After fast gc, if the valid log entries still account for less
than the half of the log size, NOVA starts thorough garbage collection,
allocates a new log, copies the live log entries to it, and switches
to the new log atomically. The radix tree needs to be updated to point
to the new log.

Example:
I = Invalid, V = Valid

VIIV -> IIII -> VVII

     ||
     ||  fast gc
     \/

VIIV -> VVII

     ||
     ||  thorough gc
     \/

    VVVV

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/gc.c | 273 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 273 insertions(+)

diff --git a/fs/nova/gc.c b/fs/nova/gc.c
index 1634c04..d74286e 100644
--- a/fs/nova/gc.c
+++ b/fs/nova/gc.c
@@ -18,6 +18,62 @@
 #include "nova.h"
 #include "inode.h"
 
+static bool curr_log_entry_invalid(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 curr_p, size_t *length)
+{
+	struct nova_file_write_entry *entry;
+	struct nova_dentry *dentry;
+	struct nova_setattr_logentry *setattr_entry;
+	struct nova_link_change_entry *linkc_entry;
+	void *entryc;
+	u8 type;
+	bool ret = true;
+
+	entryc = (void *)nova_get_block(sb, curr_p);
+	type = nova_get_entry_type(entryc);
+
+	switch (type) {
+	case SET_ATTR:
+		setattr_entry = (struct nova_setattr_logentry *) entryc;
+		if (setattr_entry->invalid == 0)
+			ret = false;
+		*length = sizeof(struct nova_setattr_logentry);
+		break;
+	case LINK_CHANGE:
+		linkc_entry = (struct nova_link_change_entry *) entryc;
+		if (linkc_entry->invalid == 0)
+			ret = false;
+		*length = sizeof(struct nova_link_change_entry);
+		break;
+	case FILE_WRITE:
+		entry = (struct nova_file_write_entry *) entryc;
+		if (entry->num_pages != entry->invalid_pages)
+			ret = false;
+		*length = sizeof(struct nova_file_write_entry);
+		break;
+	case DIR_LOG:
+		dentry = (struct nova_dentry *) entryc;
+		if (dentry->invalid == 0)
+			ret = false;
+		if (sih->last_dentry == curr_p)
+			ret = false;
+		*length = le16_to_cpu(dentry->de_len);
+		break;
+	case NEXT_PAGE:
+		/* No more entries in this page */
+		*length = PAGE_SIZE - ENTRY_LOC(curr_p);
+		break;
+	default:
+		nova_dbg("%s: unknown type %d, 0x%llx\n",
+					__func__, type, curr_p);
+		NOVA_ASSERT(0);
+		*length = PAGE_SIZE - ENTRY_LOC(curr_p);
+		break;
+	}
+
+	return ret;
+}
 
 static bool curr_page_invalid(struct super_block *sb,
 	struct nova_inode *pi, struct nova_inode_info_header *sih,
@@ -68,6 +124,210 @@ static void free_curr_page(struct super_block *sb,
 			nova_get_blocknr(sb, curr_head, btype), 1);
 }
 
+static int nova_gc_assign_file_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_file_write_entry *old_entry,
+	struct nova_file_write_entry *new_entry)
+{
+	struct nova_file_write_entry *temp;
+	void **pentry;
+	unsigned long start_pgoff = old_entry->pgoff;
+	unsigned int num = old_entry->num_pages;
+	unsigned long curr_pgoff;
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < num; i++) {
+		curr_pgoff = start_pgoff + i;
+
+		pentry = radix_tree_lookup_slot(&sih->tree, curr_pgoff);
+		if (pentry) {
+			temp = radix_tree_deref_slot(pentry);
+			if (temp == old_entry)
+				radix_tree_replace_slot(&sih->tree, pentry,
+							new_entry);
+		}
+	}
+
+	return ret;
+}
+
+static int nova_gc_assign_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_dentry *old_dentry,
+	struct nova_dentry *new_dentry)
+{
+	struct nova_dentry *temp;
+	void **pentry;
+	unsigned long hash;
+	int ret = 0;
+
+	hash = BKDRHash(old_dentry->name, old_dentry->name_len);
+	nova_dbgv("%s: assign %s hash %lu\n", __func__,
+			old_dentry->name, hash);
+
+	/* FIXME: hash collision ignored here */
+	pentry = radix_tree_lookup_slot(&sih->tree, hash);
+	if (pentry) {
+		temp = radix_tree_deref_slot(pentry);
+		if (temp == old_dentry)
+			radix_tree_replace_slot(&sih->tree, pentry, new_dentry);
+	}
+
+	return ret;
+}
+
+static int nova_gc_assign_new_entry(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	u64 curr_p, u64 new_curr)
+{
+	struct nova_file_write_entry *old_entry, *new_entry;
+	struct nova_dentry *old_dentry, *new_dentry;
+	void *addr, *new_addr;
+	u8 type;
+	int ret = 0;
+
+	addr = (void *)nova_get_block(sb, curr_p);
+	type = nova_get_entry_type(addr);
+	switch (type) {
+	case SET_ATTR:
+		sih->last_setattr = new_curr;
+		break;
+	case LINK_CHANGE:
+		sih->last_link_change = new_curr;
+		break;
+	case FILE_WRITE:
+		new_addr = (void *)nova_get_block(sb, new_curr);
+		old_entry = (struct nova_file_write_entry *)addr;
+		new_entry = (struct nova_file_write_entry *)new_addr;
+		ret = nova_gc_assign_file_entry(sb, sih, old_entry, new_entry);
+		break;
+	case DIR_LOG:
+		new_addr = (void *)nova_get_block(sb, new_curr);
+		old_dentry = (struct nova_dentry *)addr;
+		new_dentry = (struct nova_dentry *)new_addr;
+		if (sih->last_dentry == curr_p)
+			sih->last_dentry = new_curr;
+		ret = nova_gc_assign_dentry(sb, sih, old_dentry, new_dentry);
+		break;
+	default:
+		nova_dbg("%s: unknown type %d, 0x%llx\n",
+					__func__, type, curr_p);
+		NOVA_ASSERT(0);
+		break;
+	}
+
+	return ret;
+}
+
+/* Copy live log entries to the new log and atomically replace the old log */
+static unsigned long nova_inode_log_thorough_gc(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	unsigned long blocks, unsigned long checked_pages)
+{
+	struct nova_inode_log_page *curr_page = NULL;
+	size_t length;
+	u64 curr_p, new_curr;
+	u64 old_curr_p;
+	u64 tail_block;
+	u64 old_head;
+	u64 new_head = 0;
+	u64 next;
+	int allocated;
+	int extended = 0;
+	int ret;
+	timing_t gc_time;
+
+	NOVA_START_TIMING(thorough_gc_t, gc_time);
+
+	curr_p = sih->log_head;
+	old_curr_p = curr_p;
+	old_head = sih->log_head;
+	nova_dbg_verbose("Log head 0x%llx, tail 0x%llx\n",
+				curr_p, sih->log_tail);
+	if (curr_p == 0 && sih->log_tail == 0)
+		goto out;
+
+	if (curr_p >> PAGE_SHIFT == sih->log_tail >> PAGE_SHIFT)
+		goto out;
+
+	allocated = nova_allocate_inode_log_pages(sb, sih, blocks,
+					&new_head, ANY_CPU, 0);
+	if (allocated != blocks) {
+		nova_err(sb, "%s: ERROR: no inode log page available\n",
+					__func__);
+		goto out;
+	}
+
+	new_curr = new_head;
+	while (curr_p != sih->log_tail) {
+		old_curr_p = curr_p;
+		if (goto_next_page(sb, curr_p))
+			curr_p = next_log_page(sb, curr_p);
+
+		if (curr_p >> PAGE_SHIFT == sih->log_tail >> PAGE_SHIFT) {
+			/* Don't recycle tail page */
+			break;
+		}
+
+		length = 0;
+		ret = curr_log_entry_invalid(sb, pi, sih, curr_p, &length);
+		if (!ret) {
+			extended = 0;
+			new_curr = nova_get_append_head(sb, pi, sih,
+						new_curr, length, MAIN_LOG,
+						1, &extended);
+			if (extended)
+				blocks++;
+			/* Copy entry to the new log */
+			memcpy_to_pmem_nocache(nova_get_block(sb, new_curr),
+				nova_get_block(sb, curr_p), length);
+			nova_inc_page_num_entries(sb, new_curr);
+			nova_gc_assign_new_entry(sb, pi, sih, curr_p, new_curr);
+			new_curr += length;
+		}
+
+		curr_p += length;
+	}
+
+	/* Step 1: Link new log to the tail block */
+	tail_block = BLOCK_OFF(sih->log_tail);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb,
+							BLOCK_OFF(new_curr));
+	next = next_log_page(sb, new_curr);
+	if (next > 0)
+		nova_free_contiguous_log_blocks(sb, sih, next);
+
+	nova_set_next_page_flag(sb, new_curr);
+	nova_set_next_page_address(sb, curr_page, tail_block, 0);
+
+	/* Step 2: Atomically switch to the new log */
+	pi->log_head = new_head;
+	nova_persist_inode(pi);
+	nova_flush_buffer(pi, sizeof(struct nova_inode), 1);
+	sih->log_head = new_head;
+
+	/* Step 3: Unlink the old log */
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb,
+							BLOCK_OFF(old_curr_p));
+	next = next_log_page(sb, old_curr_p);
+	if (next != tail_block)
+		nova_err(sb, "Old log error: old curr_p 0x%lx, next 0x%lx ",
+			"curr_p 0x%lx, tail block 0x%lx\n", old_curr_p,
+			next, curr_p, tail_block);
+
+	nova_set_next_page_address(sb, curr_page, 0, 1);
+
+	/* Step 4: Free the old log */
+	nova_free_contiguous_log_blocks(sb, sih, old_head);
+
+	sih->log_pages = sih->log_pages + blocks - checked_pages;
+	NOVA_STATS_ADD(thorough_gc_pages, checked_pages - blocks);
+	NOVA_STATS_ADD(thorough_checked_pages, checked_pages);
+out:
+	NOVA_END_TIMING(thorough_gc_t, gc_time);
+	return blocks;
+}
+
 
 /*
  * Scan pages in the log and remove those with no valid log entries.
@@ -178,9 +438,22 @@ int nova_inode_log_fast_gc(struct super_block *sb,
 	if (sih->num_entries == 0)
 		return 0;
 
+	/* Estimate how many pages worth of valid entries the log contains.
+	 *
+	 * If it is less than half the number pages that remain in the log,
+	 * compress them with thorough gc.
+	 */
 	blocks = (sih->valid_entries * checked_pages) / sih->num_entries;
 	if ((sih->valid_entries * checked_pages) % sih->num_entries)
 		blocks++;
 
+	if (force_thorough || (blocks && blocks * 2 < checked_pages)) {
+		nova_dbgv("Thorough GC for inode %lu: checked pages %lu, valid pages %lu\n",
+				sih->ino,
+				checked_pages, blocks);
+		blocks = nova_inode_log_thorough_gc(sb, pi, sih,
+							blocks, checked_pages);
+	}
+
 	return 0;
 }
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
