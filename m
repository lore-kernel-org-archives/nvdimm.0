Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FDF5225892DA
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:45 -0800 (PST)
Received: by mail-pf0-x244.google.com with SMTP id h19so2612562pfd.12
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:03 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 39/83] Log operation: dentry append.
Date: Sat, 10 Mar 2018 10:18:20 -0800
Message-Id: <1520705944-6723-40-git-send-email-jix024@eng.ucsd.edu>
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

NOVA performs atomic log appending by first appending the entry
to the tail of the log, and then atomically update the log tail pointer.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/log.c | 162 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/log.h |   4 ++
 2 files changed, 166 insertions(+)

diff --git a/fs/nova/log.c b/fs/nova/log.c
index f01b7c8..13f9597 100644
--- a/fs/nova/log.c
+++ b/fs/nova/log.c
@@ -20,6 +20,168 @@
 #include "inode.h"
 #include "log.h"
 
+static int nova_update_old_dentry(struct super_block *sb,
+	struct inode *dir, struct nova_dentry *dentry,
+	struct nova_log_entry_info *entry_info)
+{
+	unsigned short links_count;
+	int link_change = entry_info->link_change;
+	u64 addr;
+
+	dentry->epoch_id = entry_info->epoch_id;
+	dentry->trans_id = entry_info->trans_id;
+	/* Remove_dentry */
+	dentry->ino = cpu_to_le64(0);
+	dentry->invalid = 1;
+	dentry->mtime = cpu_to_le32(dir->i_mtime.tv_sec);
+
+	links_count = cpu_to_le16(dir->i_nlink);
+	if (links_count == 0 && link_change == -1)
+		links_count = 0;
+	else
+		links_count += link_change;
+	dentry->links_count = cpu_to_le16(links_count);
+
+	addr = nova_get_addr_off(NOVA_SB(sb), dentry);
+	nova_inc_page_invalid_entries(sb, addr);
+
+	nova_persist_entry(dentry);
+
+	return 0;
+}
+
+static int nova_update_new_dentry(struct super_block *sb,
+	struct inode *dir, struct nova_dentry *entry,
+	struct nova_log_entry_info *entry_info)
+{
+	struct dentry *dentry = entry_info->data;
+	unsigned short links_count;
+	int link_change = entry_info->link_change;
+
+	entry->entry_type = DIR_LOG;
+	entry->epoch_id = entry_info->epoch_id;
+	entry->trans_id = entry_info->trans_id;
+	entry->ino = entry_info->ino;
+	entry->name_len = dentry->d_name.len;
+	memcpy_to_pmem_nocache(entry->name, dentry->d_name.name,
+				dentry->d_name.len);
+	entry->name[dentry->d_name.len] = '\0';
+	entry->mtime = cpu_to_le32(dir->i_mtime.tv_sec);
+	//entry->size = cpu_to_le64(dir->i_size);
+
+	links_count = cpu_to_le16(dir->i_nlink);
+	if (links_count == 0 && link_change == -1)
+		links_count = 0;
+	else
+		links_count += link_change;
+	entry->links_count = cpu_to_le16(links_count);
+
+	/* Update actual de_len */
+	entry->de_len = cpu_to_le16(entry_info->file_size);
+
+	nova_persist_entry(entry);
+
+	return 0;
+}
+
+static int nova_update_log_entry(struct super_block *sb, struct inode *inode,
+	void *entry, struct nova_log_entry_info *entry_info)
+{
+	enum nova_entry_type type = entry_info->type;
+
+	switch (type) {
+	case FILE_WRITE:
+		break;
+	case DIR_LOG:
+		if (entry_info->inplace)
+			nova_update_old_dentry(sb, inode, entry, entry_info);
+		else
+			nova_update_new_dentry(sb, inode, entry, entry_info);
+		break;
+	case SET_ATTR:
+		break;
+	case LINK_CHANGE:
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int nova_append_log_entry(struct super_block *sb,
+	struct nova_inode *pi, struct inode *inode,
+	struct nova_inode_info_header *sih,
+	struct nova_log_entry_info *entry_info)
+{
+	void *entry;
+	enum nova_entry_type type = entry_info->type;
+	struct nova_inode_update *update = entry_info->update;
+	u64 tail;
+	u64 curr_p;
+	size_t size;
+	int extended = 0;
+
+	if (type == DIR_LOG)
+		size = entry_info->file_size;
+	else
+		size = nova_get_log_entry_size(sb, type);
+
+	tail = update->tail;
+
+	curr_p = nova_get_append_head(sb, pi, sih, tail, size,
+						MAIN_LOG, 0, &extended);
+	if (curr_p == 0)
+		return -ENOSPC;
+
+	nova_dbg_verbose("%s: inode %lu attr change entry @ 0x%llx\n",
+				__func__, sih->ino, curr_p);
+
+	entry = nova_get_block(sb, curr_p);
+	/* inode is already updated with attr */
+	memset(entry, 0, size);
+	nova_update_log_entry(sb, inode, entry, entry_info);
+	nova_inc_page_num_entries(sb, curr_p);
+	update->curr_entry = curr_p;
+	update->tail = curr_p + size;
+
+	entry_info->curr_p = curr_p;
+	return 0;
+}
+
+int nova_append_dentry(struct super_block *sb, struct nova_inode *pi,
+	struct inode *dir, struct dentry *dentry, u64 ino,
+	unsigned short de_len, struct nova_inode_update *update,
+	int link_change, u64 epoch_id)
+{
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_log_entry_info entry_info;
+	timing_t append_time;
+	int ret;
+
+	NOVA_START_TIMING(append_dir_entry_t, append_time);
+
+	entry_info.type = DIR_LOG;
+	entry_info.update = update;
+	entry_info.data = dentry;
+	entry_info.ino = ino;
+	entry_info.link_change = link_change;
+	entry_info.file_size = de_len;
+	entry_info.epoch_id = epoch_id;
+	entry_info.trans_id = sih->trans_id;
+	entry_info.inplace = 0;
+
+	ret = nova_append_log_entry(sb, pi, dir, sih, &entry_info);
+	if (ret)
+		nova_err(sb, "%s failed\n", __func__);
+
+	dir->i_blocks = sih->i_blocks;
+
+	NOVA_END_TIMING(append_dir_entry_t, append_time);
+	return ret;
+}
+
 /* Coalesce log pages to a singly linked list */
 static int nova_coalesce_log_pages(struct super_block *sb,
 	unsigned long prev_blocknr, unsigned long first_blocknr,
diff --git a/fs/nova/log.h b/fs/nova/log.h
index 6b4a085..305e69b 100644
--- a/fs/nova/log.h
+++ b/fs/nova/log.h
@@ -364,6 +364,10 @@ static inline int is_dir_init_entry(struct super_block *sb,
 }
 
 
+int nova_append_dentry(struct super_block *sb, struct nova_inode *pi,
+	struct inode *dir, struct dentry *dentry, u64 ino,
+	unsigned short de_len, struct nova_inode_update *update,
+	int link_change, u64 epoch_id);
 int nova_allocate_inode_log_pages(struct super_block *sb,
 	struct nova_inode_info_header *sih, unsigned long num_pages,
 	u64 *new_block, int cpuid, enum nova_alloc_direction from_tail);
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
