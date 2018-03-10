Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x244.google.com (mail-pg0-x244.google.com
 [IPv6:2607:f8b0:400e:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D362D2264D22A
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:35 -0800 (PST)
Received: by mail-pg0-x244.google.com with SMTP id w17so768541pgq.8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:54 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 81/83] Failure recovery: Inode pages recovery routines.
Date: Sat, 10 Mar 2018 10:19:02 -0800
Message-Id: <1520705944-6723-82-git-send-email-jix024@eng.ucsd.edu>
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

For each inode, NOVA traverses the inode log and records the pages
allocated in the bitmap. For directory inode, NOVA only set the log pages.
For file and symlink inodes, NOVA needs to set the data pages.
NOVA divides the file into 1GB zones, and records the pages fall into
the current zone, until all the pages have been recorded.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/bbuild.c | 307 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 307 insertions(+)

diff --git a/fs/nova/bbuild.c b/fs/nova/bbuild.c
index 35c661a..75dfcba 100644
--- a/fs/nova/bbuild.c
+++ b/fs/nova/bbuild.c
@@ -665,6 +665,313 @@ static int alloc_bm(struct super_block *sb, unsigned long initsize)
 	return 0;
 }
 
+/************************** NOVA recovery ****************************/
+
+#define MAX_PGOFF	262144
+
+struct task_ring {
+	u64 addr0[512];
+	int num;
+	int inodes_used_count;
+	u64 *entry_array;
+	u64 *nvmm_array;
+};
+
+static int nova_traverse_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct scan_bitmap *bm, u64 head)
+{
+	u64 curr_p;
+	u64 next;
+
+	curr_p = head;
+
+	if (curr_p == 0)
+		return 0;
+
+	WARN_ON(curr_p & (PAGE_SIZE - 1));
+	set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+
+	next = next_log_page(sb, curr_p);
+	while (next > 0) {
+		curr_p = next;
+		WARN_ON(curr_p & (PAGE_SIZE - 1));
+		set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+		next = next_log_page(sb, curr_p);
+	}
+
+	return 0;
+}
+
+static void nova_traverse_dir_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct scan_bitmap *bm)
+{
+	nova_traverse_inode_log(sb, pi, bm, pi->log_head);
+}
+
+static int nova_set_ring_array(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	struct task_ring *ring,
+	unsigned long base, struct scan_bitmap *bm)
+{
+	unsigned long start, end;
+	unsigned long pgoff, old_pgoff = 0;
+	unsigned long index;
+	unsigned int num_free = 0;
+	u64 old_entry = 0;
+
+	start = entry->pgoff;
+	if (start < base)
+		start = base;
+
+	end = entry->pgoff + entry->num_pages;
+	if (end > base + MAX_PGOFF)
+		end = base + MAX_PGOFF;
+
+	for (pgoff = start; pgoff < end; pgoff++) {
+		index = pgoff - base;
+		if (ring->nvmm_array[index]) {
+			if (ring->entry_array[index] != old_entry) {
+				old_entry = ring->entry_array[index];
+				old_pgoff = pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+		}
+	}
+
+	for (pgoff = start; pgoff < end; pgoff++) {
+		index = pgoff - base;
+		ring->entry_array[index] = (u64)entry;
+		ring->nvmm_array[index] = (u64)(entry->block >> PAGE_SHIFT)
+						+ pgoff - entry->pgoff;
+	}
+
+	return 0;
+}
+
+static int nova_set_file_bm(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct task_ring *ring,
+	struct scan_bitmap *bm, unsigned long base, unsigned long last_blocknr)
+{
+	unsigned long nvmm, pgoff;
+
+	if (last_blocknr >= base + MAX_PGOFF)
+		last_blocknr = MAX_PGOFF - 1;
+	else
+		last_blocknr -= base;
+
+	for (pgoff = 0; pgoff <= last_blocknr; pgoff++) {
+		nvmm = ring->nvmm_array[pgoff];
+		if (nvmm) {
+			set_bm(nvmm, bm, BM_4K);
+			ring->nvmm_array[pgoff] = 0;
+			ring->entry_array[pgoff] = 0;
+		}
+	}
+
+	return 0;
+}
+
+/* entry given to this function is a copy in dram */
+static void nova_ring_setattr_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih,
+	struct nova_setattr_logentry *entry, struct task_ring *ring,
+	unsigned long base, unsigned int data_bits, struct scan_bitmap *bm)
+{
+	unsigned long first_blocknr, last_blocknr;
+	unsigned long pgoff, old_pgoff = 0;
+	unsigned long index;
+	unsigned int num_free = 0;
+	u64 old_entry = 0;
+	loff_t start, end;
+
+	if (sih->i_size <= entry->size)
+		goto out;
+
+	start = entry->size;
+	end = sih->i_size;
+
+	first_blocknr = (start + (1UL << data_bits) - 1) >> data_bits;
+
+	if (end > 0)
+		last_blocknr = (end - 1) >> data_bits;
+	else
+		last_blocknr = 0;
+
+	if (first_blocknr > last_blocknr)
+		goto out;
+
+	if (first_blocknr < base)
+		first_blocknr = base;
+
+	if (last_blocknr > base + MAX_PGOFF - 1)
+		last_blocknr = base + MAX_PGOFF - 1;
+
+	for (pgoff = first_blocknr; pgoff <= last_blocknr; pgoff++) {
+		index = pgoff - base;
+		if (ring->nvmm_array[index]) {
+			if (ring->entry_array[index] != old_entry) {
+				old_entry = ring->entry_array[index];
+				old_pgoff = pgoff;
+				num_free = 1;
+			} else {
+				num_free++;
+			}
+		}
+	}
+
+	for (pgoff = first_blocknr; pgoff <= last_blocknr; pgoff++) {
+		index = pgoff - base;
+		ring->nvmm_array[index] = 0;
+		ring->entry_array[index] = 0;
+	}
+
+out:
+	sih->i_size = entry->size;
+}
+
+static unsigned long nova_traverse_file_write_entry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_file_write_entry *entry,
+	struct task_ring *ring,
+	unsigned long base, struct scan_bitmap *bm)
+{
+	unsigned long max_blocknr = 0;
+	sih->i_size = entry->size;
+
+	if (entry->num_pages != entry->invalid_pages) {
+		max_blocknr = entry->pgoff + entry->num_pages - 1;
+		if (entry->pgoff < base + MAX_PGOFF &&
+				entry->pgoff + entry->num_pages > base)
+			nova_set_ring_array(sb, sih, entry,
+						ring, base, bm);
+	}
+
+	return max_blocknr;
+}
+
+static int nova_traverse_file_inode_log(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct task_ring *ring, struct scan_bitmap *bm)
+{
+	unsigned long base = 0;
+	unsigned long last_blocknr = 0, curr_last;
+	void *entry;
+	unsigned int btype;
+	unsigned int data_bits;
+	u64 curr_p;
+	u64 next;
+	u8 type;
+
+	btype = pi->i_blk_type;
+	data_bits = blk_type_to_shift[btype];
+
+again:
+	curr_p = pi->log_head;
+	nova_dbg_verbose("Log head 0x%llx, tail 0x%llx\n",
+				curr_p, pi->log_tail);
+	if (curr_p == 0 && pi->log_tail == 0)
+		return 0;
+
+	if (base == 0) {
+		WARN_ON(curr_p & (PAGE_SIZE - 1));
+		set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+	}
+
+	while (curr_p != pi->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			curr_p = next_log_page(sb, curr_p);
+			if (base == 0) {
+				WARN_ON(curr_p & (PAGE_SIZE - 1));
+				set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+			}
+		}
+
+		entry = (void *)nova_get_block(sb, curr_p);
+
+		type = nova_get_entry_type(entry);
+		switch (type) {
+		case SET_ATTR:
+			nova_ring_setattr_entry(sb, sih, SENTRY(entry),
+						ring, base, data_bits,
+						bm);
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case FILE_WRITE:
+			curr_last = nova_traverse_file_write_entry(sb, sih,
+						WENTRY(entry), ring, base, bm);
+			curr_p += sizeof(struct nova_file_write_entry);
+			if (last_blocknr < curr_last)
+				last_blocknr = curr_last;
+			break;
+		default:
+			nova_dbg("%s: unknown type %d, 0x%llx\n",
+						__func__, type, curr_p);
+			NOVA_ASSERT(0);
+		}
+
+	}
+
+	if (base == 0) {
+		/* Keep traversing until log ends */
+		curr_p &= PAGE_MASK;
+		next = next_log_page(sb, curr_p);
+		while (next > 0) {
+			curr_p = next;
+			WARN_ON(curr_p & (PAGE_SIZE - 1));
+			set_bm(curr_p >> PAGE_SHIFT, bm, BM_4K);
+			next = next_log_page(sb, curr_p);
+		}
+	}
+
+	nova_set_file_bm(sb, sih, ring, bm, base, last_blocknr);
+	if (last_blocknr >= base + MAX_PGOFF) {
+		base += MAX_PGOFF;
+		goto again;
+	}
+
+	return 0;
+}
+
+static int nova_recover_inode_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct task_ring *ring,
+	struct nova_inode *pi, struct scan_bitmap *bm)
+{
+	unsigned long nova_ino;
+
+	if (pi->deleted == 1)
+		return 0;
+
+	nova_ino = pi->nova_ino;
+	ring->inodes_used_count++;
+
+	sih->i_mode = __le16_to_cpu(pi->i_mode);
+	sih->ino = nova_ino;
+
+	nova_dbgv("%s: inode %lu, head 0x%llx, tail 0x%llx\n",
+			__func__, nova_ino, pi->log_head, pi->log_tail);
+
+	switch (__le16_to_cpu(pi->i_mode) & S_IFMT) {
+	case S_IFDIR:
+		nova_traverse_dir_inode_log(sb, pi, bm);
+		break;
+	case S_IFLNK:
+		/* Treat symlink files as normal files */
+		/* Fall through */
+	case S_IFREG:
+		/* Fall through */
+	default:
+		/* In case of special inode, walk the log */
+		nova_traverse_file_inode_log(sb, pi, sih, ring, bm);
+		break;
+	}
+
+	return 0;
+}
+
 
 /*********************** Recovery entrance *************************/
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
