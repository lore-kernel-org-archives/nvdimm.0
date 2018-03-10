Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x241.google.com (mail-pf0-x241.google.com
 [IPv6:2607:f8b0:400e:c00::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E0DFF22603B11
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:37 -0800 (PST)
Received: by mail-pf0-x241.google.com with SMTP id z10so2607547pfh.13
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:56 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 33/83] Inode log and entry printing for debug purpose.
Date: Sat, 10 Mar 2018 10:18:14 -0800
Message-Id: <1520705944-6723-34-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/nova.h  |   3 +
 fs/nova/stats.c | 234 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 237 insertions(+)

diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index bf4b6ac..03c4991 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -367,6 +367,9 @@ void nova_get_IO_stats(void);
 void nova_print_timing_stats(struct super_block *sb);
 void nova_clear_stats(struct super_block *sb);
 void nova_print_inode(struct nova_inode *pi);
+void nova_print_inode_log(struct super_block *sb, struct inode *inode);
+void nova_print_inode_log_pages(struct super_block *sb, struct inode *inode);
+int nova_check_inode_logs(struct super_block *sb, struct nova_inode *pi);
 void nova_print_free_lists(struct super_block *sb);
 
 #endif /* __NOVA_H */
diff --git a/fs/nova/stats.c b/fs/nova/stats.c
index 9ddd267..990e964 100644
--- a/fs/nova/stats.c
+++ b/fs/nova/stats.c
@@ -333,6 +333,240 @@ void nova_print_inode(struct nova_inode *pi)
 		pi->create_epoch_id, pi->delete_epoch_id);
 }
 
+static inline void nova_print_file_write_entry(struct super_block *sb,
+	u64 curr, struct nova_file_write_entry *entry)
+{
+	nova_dbg("file write entry @ 0x%llx: epoch %llu, trans %llu, "
+			"pgoff %llu, pages %u, blocknr %llu, reassigned %u, "
+			"invalid count %u, size %llu, mtime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->pgoff, entry->num_pages,
+			entry->block >> PAGE_SHIFT,
+			entry->reassigned,
+			entry->invalid_pages, entry->size, entry->mtime);
+}
+
+static inline void nova_print_set_attr_entry(struct super_block *sb,
+	u64 curr, struct nova_setattr_logentry *entry)
+{
+	nova_dbg("set attr entry @ 0x%llx: epoch %llu, trans %llu, invalid %u, "
+			"mode %u, size %llu, atime %u, mtime %u, ctime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->invalid, entry->mode,
+			entry->size, entry->atime, entry->mtime, entry->ctime);
+}
+
+static inline void nova_print_link_change_entry(struct super_block *sb,
+	u64 curr, struct nova_link_change_entry *entry)
+{
+	nova_dbg("link change entry @ 0x%llx: epoch %llu, trans %llu, "
+			"invalid %u, links %u, flags %u, ctime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->invalid, entry->links,
+			entry->flags, entry->ctime);
+}
+
+static inline size_t nova_print_dentry(struct super_block *sb,
+	u64 curr, struct nova_dentry *entry)
+{
+	nova_dbg("dir logentry @ 0x%llx: epoch %llu, trans %llu, "
+			"reassigned %u, invalid %u, inode %llu, links %u, "
+			"namelen %u, rec len %u, name %s, mtime %u\n",
+			curr, entry->epoch_id, entry->trans_id,
+			entry->reassigned, entry->invalid,
+			le64_to_cpu(entry->ino),
+			entry->links_count, entry->name_len,
+			le16_to_cpu(entry->de_len), entry->name,
+			entry->mtime);
+
+	return le16_to_cpu(entry->de_len);
+}
+
+u64 nova_print_log_entry(struct super_block *sb, u64 curr)
+{
+	void *addr;
+	size_t size;
+	u8 type;
+
+	addr = (void *)nova_get_block(sb, curr);
+	type = nova_get_entry_type(addr);
+	switch (type) {
+	case SET_ATTR:
+		nova_print_set_attr_entry(sb, curr, addr);
+		curr += sizeof(struct nova_setattr_logentry);
+		break;
+	case LINK_CHANGE:
+		nova_print_link_change_entry(sb, curr, addr);
+		curr += sizeof(struct nova_link_change_entry);
+		break;
+	case FILE_WRITE:
+		nova_print_file_write_entry(sb, curr, addr);
+		curr += sizeof(struct nova_file_write_entry);
+		break;
+	case DIR_LOG:
+		size = nova_print_dentry(sb, curr, addr);
+		curr += size;
+		if (size == 0) {
+			nova_dbg("%s: dentry with size 0 @ 0x%llx\n",
+					__func__, curr);
+			curr += sizeof(struct nova_file_write_entry);
+			NOVA_ASSERT(0);
+		}
+		break;
+	case NEXT_PAGE:
+		nova_dbg("%s: next page sign @ 0x%llx\n", __func__, curr);
+		curr = PAGE_TAIL(curr);
+		break;
+	default:
+		nova_dbg("%s: unknown type %d, 0x%llx\n", __func__, type, curr);
+		curr += sizeof(struct nova_file_write_entry);
+		NOVA_ASSERT(0);
+		break;
+	}
+
+	return curr;
+}
+
+void nova_print_curr_log_page(struct super_block *sb, u64 curr)
+{
+	struct nova_inode_page_tail *tail;
+	u64 start, end;
+
+	start = BLOCK_OFF(curr);
+	end = PAGE_TAIL(curr);
+
+	while (start < end)
+		start = nova_print_log_entry(sb, start);
+
+	tail = nova_get_block(sb, end);
+	nova_dbg("Page tail. curr 0x%llx, next page 0x%llx, %u entries, %u invalid\n",
+			start, tail->next_page,
+			tail->num_entries, tail->invalid_entries);
+}
+
+void nova_print_nova_log(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	u64 curr;
+
+	if (sih->log_tail == 0 || sih->log_head == 0)
+		return;
+
+	curr = sih->log_head;
+	nova_dbg("Pi %lu: log head 0x%llx, tail 0x%llx\n",
+			sih->ino, curr, sih->log_tail);
+	while (curr != sih->log_tail) {
+		if ((curr & (PAGE_SIZE - 1)) == LOG_BLOCK_TAIL) {
+			struct nova_inode_page_tail *tail =
+					nova_get_block(sb, curr);
+			nova_dbg("Log tail, curr 0x%llx, next page 0x%llx, "
+					"%u entries, %u invalid\n",
+					curr, tail->next_page,
+					tail->num_entries,
+					tail->invalid_entries);
+			curr = tail->next_page;
+		} else {
+			curr = nova_print_log_entry(sb, curr);
+		}
+	}
+}
+
+void nova_print_inode_log(struct super_block *sb, struct inode *inode)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	nova_print_nova_log(sb, sih);
+}
+
+int nova_get_nova_log_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode *pi)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 curr, next;
+	int count = 1;
+
+	if (pi->log_head == 0 || pi->log_tail == 0) {
+		nova_dbg("Pi %lu has no log\n", sih->ino);
+		return 0;
+	}
+
+	curr = pi->log_head;
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	while ((next = curr_page->page_tail.next_page) != 0) {
+		curr = next;
+		curr_page = (struct nova_inode_log_page *)
+			nova_get_block(sb, curr);
+		count++;
+	}
+
+	return count;
+}
+
+void nova_print_nova_log_pages(struct super_block *sb,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_inode_log_page *curr_page;
+	u64 curr, next;
+	int count = 1;
+	int used = count;
+
+	if (sih->log_head == 0 || sih->log_tail == 0) {
+		nova_dbg("Pi %lu has no log\n", sih->ino);
+		return;
+	}
+
+	curr = sih->log_head;
+	nova_dbg("Pi %lu: log head @ 0x%llx, tail @ 0x%llx\n",
+			sih->ino, curr, sih->log_tail);
+	curr_page = (struct nova_inode_log_page *)nova_get_block(sb, curr);
+	while ((next = curr_page->page_tail.next_page) != 0) {
+		nova_dbg("Current page 0x%llx, next page 0x%llx, %u entries, %u invalid\n",
+			curr >> PAGE_SHIFT, next >> PAGE_SHIFT,
+			curr_page->page_tail.num_entries,
+			curr_page->page_tail.invalid_entries);
+		if (sih->log_tail >> PAGE_SHIFT == curr >> PAGE_SHIFT)
+			used = count;
+		curr = next;
+		curr_page = (struct nova_inode_log_page *)
+			nova_get_block(sb, curr);
+		count++;
+	}
+	if (sih->log_tail >> PAGE_SHIFT == curr >> PAGE_SHIFT)
+		used = count;
+	nova_dbg("Pi %lu: log used %d pages, has %d pages, si reports %lu pages\n",
+		sih->ino, used, count,
+		sih->log_pages);
+}
+
+void nova_print_inode_log_pages(struct super_block *sb, struct inode *inode)
+{
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+
+	nova_print_nova_log_pages(sb, sih);
+}
+
+int nova_check_inode_logs(struct super_block *sb, struct nova_inode *pi)
+{
+	int count = 0;
+	int tail_at = 0;
+	u64 curr;
+
+	curr = pi->log_head;
+
+	while (curr) {
+		count++;
+		if ((curr >> PAGE_SHIFT) == (pi->log_tail >> PAGE_SHIFT))
+			tail_at = count;
+		curr = next_log_page(sb, curr);
+	}
+
+	nova_dbg("Log %d pages, tail @ page %d\n", count, tail_at);
+
+	return 0;
+}
+
 void nova_print_free_lists(struct super_block *sb)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
