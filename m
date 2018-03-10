Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5535022631491
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:59 -0800 (PST)
Received: by mail-pf0-x244.google.com with SMTP id f80so2617780pfa.8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:18 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 51/83] Rebuild: directory inode.
Date: Sat, 10 Mar 2018 10:18:32 -0800
Message-Id: <1520705944-6723-52-git-send-email-jix024@eng.ucsd.edu>
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

When vfs issues a read inode command, or when the inode is newly allocated,
walk through the inode log to rebuild inode information and the radix tree.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/inode.h   |  15 +++
 fs/nova/nova.h    |  21 ++++
 fs/nova/rebuild.c | 329 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 364 insertions(+), 1 deletion(-)

diff --git a/fs/nova/inode.h b/fs/nova/inode.h
index 62c8bdc..42690e6 100644
--- a/fs/nova/inode.h
+++ b/fs/nova/inode.h
@@ -97,6 +97,21 @@ struct nova_inode_info_header {
 	u8  i_blk_type;
 };
 
+/* For rebuild purpose, temporarily store pi infomation */
+struct nova_inode_rebuild {
+	u64	i_size;
+	u32	i_flags;	/* Inode flags */
+	u32	i_ctime;	/* Inode modification time */
+	u32	i_mtime;	/* Inode b-tree Modification time */
+	u32	i_atime;	/* Access time */
+	u32	i_uid;		/* Owner Uid */
+	u32	i_gid;		/* Group Id */
+	u32	i_generation;	/* File version (for NFS) */
+	u16	i_links_count;	/* Links count */
+	u16	i_mode;		/* File mode */
+	u64	trans_id;
+};
+
 /*
  * DRAM state for inodes
  */
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 3a51dae..983c6b2 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -301,6 +301,24 @@ static inline u64 nova_get_epoch_id(struct super_block *sb)
 }
 
 #include "inode.h"
+
+static inline int nova_get_head_tail(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih)
+{
+	struct nova_inode fake_pi;
+	int rc;
+
+	rc = memcpy_mcsafe(&fake_pi, pi, sizeof(struct nova_inode));
+	if (rc)
+		return rc;
+
+	sih->i_blk_type = fake_pi.i_blk_type;
+	sih->log_head = fake_pi.log_head;
+	sih->log_tail = fake_pi.log_tail;
+
+	return rc;
+}
+
 #include "log.h"
 
 struct nova_range_node_lowhigh {
@@ -467,6 +485,9 @@ int nova_remove_dentry(struct dentry *dentry, int dec_link,
 	struct nova_inode_update *update, u64 epoch_id);
 
 /* rebuild.c */
+int nova_rebuild_dir_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih);
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 	u64 ino, u64 pi_addr, int rebuild_dir);
 
diff --git a/fs/nova/rebuild.c b/fs/nova/rebuild.c
index 0595851..9a1327d 100644
--- a/fs/nova/rebuild.c
+++ b/fs/nova/rebuild.c
@@ -18,6 +18,319 @@
 #include "nova.h"
 #include "inode.h"
 
+/* entry given to this function is a copy in dram */
+static void nova_apply_setattr_entry(struct super_block *sb,
+	struct nova_inode_rebuild *reb,	struct nova_inode_info_header *sih,
+	struct nova_setattr_logentry *entry)
+{
+	unsigned int data_bits = blk_type_to_shift[sih->i_blk_type];
+	unsigned long first_blocknr, last_blocknr;
+	loff_t start, end;
+	int freed = 0;
+
+	reb->i_mode	= entry->mode;
+	reb->i_uid	= entry->uid;
+	reb->i_gid	= entry->gid;
+	reb->i_atime	= entry->atime;
+
+	if (S_ISREG(reb->i_mode)) {
+		start = entry->size;
+		end = reb->i_size;
+
+		first_blocknr = (start + (1UL << data_bits) - 1) >> data_bits;
+
+		if (end > 0)
+			last_blocknr = (end - 1) >> data_bits;
+		else
+			last_blocknr = 0;
+
+		freed = nova_delete_file_tree(sb, sih, first_blocknr,
+					last_blocknr, false, false, 0);
+	}
+}
+
+/* entry given to this function is a copy in dram */
+static void nova_apply_link_change_entry(struct super_block *sb,
+	struct nova_inode_rebuild *reb,	struct nova_link_change_entry *entry)
+{
+	reb->i_links_count	= entry->links;
+	reb->i_ctime		= entry->ctime;
+	reb->i_flags		= entry->flags;
+	reb->i_generation	= entry->generation;
+
+	/* Do not flush now */
+}
+
+static void nova_update_inode_with_rebuild(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_inode *pi)
+{
+	pi->i_size = cpu_to_le64(reb->i_size);
+	pi->i_flags = cpu_to_le32(reb->i_flags);
+	pi->i_uid = cpu_to_le32(reb->i_uid);
+	pi->i_gid = cpu_to_le32(reb->i_gid);
+	pi->i_atime = cpu_to_le32(reb->i_atime);
+	pi->i_ctime = cpu_to_le32(reb->i_ctime);
+	pi->i_mtime = cpu_to_le32(reb->i_mtime);
+	pi->i_generation = cpu_to_le32(reb->i_generation);
+	pi->i_links_count = cpu_to_le16(reb->i_links_count);
+	pi->i_mode = cpu_to_le16(reb->i_mode);
+}
+
+static int nova_init_inode_rebuild(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_inode *pi)
+{
+	struct nova_inode fake_pi;
+	int rc;
+
+	rc = memcpy_mcsafe(&fake_pi, pi, sizeof(struct nova_inode));
+	if (rc)
+		return rc;
+
+	reb->i_size = le64_to_cpu(fake_pi.i_size);
+	reb->i_flags = le32_to_cpu(fake_pi.i_flags);
+	reb->i_uid = le32_to_cpu(fake_pi.i_uid);
+	reb->i_gid = le32_to_cpu(fake_pi.i_gid);
+	reb->i_atime = le32_to_cpu(fake_pi.i_atime);
+	reb->i_ctime = le32_to_cpu(fake_pi.i_ctime);
+	reb->i_mtime = le32_to_cpu(fake_pi.i_mtime);
+	reb->i_generation = le32_to_cpu(fake_pi.i_generation);
+	reb->i_links_count = le16_to_cpu(fake_pi.i_links_count);
+	reb->i_mode = le16_to_cpu(fake_pi.i_mode);
+	reb->trans_id = 0;
+
+	return rc;
+}
+
+static inline void nova_rebuild_file_time_and_size(struct super_block *sb,
+	struct nova_inode_rebuild *reb, u32 mtime, u32 ctime, u64 size)
+{
+	reb->i_mtime = cpu_to_le32(mtime);
+	reb->i_ctime = cpu_to_le32(ctime);
+	reb->i_size = cpu_to_le64(size);
+}
+
+static int nova_rebuild_inode_start(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct nova_inode_rebuild *reb, u64 pi_addr)
+{
+	int ret;
+
+	ret = nova_get_head_tail(sb, pi, sih);
+	if (ret)
+		return ret;
+
+	ret = nova_init_inode_rebuild(sb, reb, pi);
+	if (ret)
+		return ret;
+
+	sih->pi_addr = pi_addr;
+
+	nova_dbg_verbose("Log head 0x%llx, tail 0x%llx\n",
+				sih->log_head, sih->log_tail);
+	sih->log_pages = 1;
+
+	return ret;
+}
+
+static int nova_rebuild_inode_finish(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode_info_header *sih,
+	struct nova_inode_rebuild *reb, u64 curr_p)
+{
+	u64 next;
+
+	sih->i_size = le64_to_cpu(reb->i_size);
+	sih->i_mode = le64_to_cpu(reb->i_mode);
+	sih->i_flags = le32_to_cpu(reb->i_flags);
+	sih->trans_id = reb->trans_id + 1;
+
+	nova_update_inode_with_rebuild(sb, reb, pi);
+	nova_persist_inode(pi);
+
+	/* Keep traversing until log ends */
+	curr_p &= PAGE_MASK;
+	while ((next = next_log_page(sb, curr_p)) > 0) {
+		sih->log_pages++;
+		curr_p = next;
+	}
+
+	return 0;
+}
+
+/******************* Directory rebuild *********************/
+
+static inline void nova_rebuild_dir_time_and_size(struct super_block *sb,
+	struct nova_inode_rebuild *reb, struct nova_dentry *entry)
+{
+	if (!entry || !reb)
+		return;
+
+	reb->i_ctime = entry->mtime;
+	reb->i_mtime = entry->mtime;
+	reb->i_links_count = entry->links_count;
+	//reb->i_size = entry->size;
+}
+
+static void nova_reassign_last_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, u64 curr_p)
+{
+	struct nova_dentry *dentry, *old_dentry;
+
+	if (sih->last_dentry == 0) {
+		sih->last_dentry = curr_p;
+	} else {
+		old_dentry = (struct nova_dentry *)nova_get_block(sb,
+							sih->last_dentry);
+		dentry = (struct nova_dentry *)nova_get_block(sb, curr_p);
+		if (dentry->trans_id >= old_dentry->trans_id)
+			sih->last_dentry = curr_p;
+	}
+}
+
+static inline int nova_replay_add_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_dentry *entry)
+{
+	if (!entry->name_len)
+		return -EINVAL;
+
+	nova_dbg_verbose("%s: add %s\n", __func__, entry->name);
+	return nova_insert_dir_radix_tree(sb, sih,
+			entry->name, entry->name_len, entry);
+}
+
+/* entry given to this function is a copy in dram */
+static inline int nova_replay_remove_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_dentry *entry)
+{
+	nova_dbg_verbose("%s: remove %s\n", __func__, entry->name);
+	nova_remove_dir_radix_tree(sb, sih, entry->name,
+					entry->name_len, 1, NULL);
+	return 0;
+}
+
+static int nova_rebuild_handle_dentry(struct super_block *sb,
+	struct nova_inode_info_header *sih, struct nova_inode_rebuild *reb,
+	struct nova_dentry *entry, u64 curr_p)
+{
+	int ret = 0;
+
+	nova_dbgv("curr_p: 0x%llx, type %d, ino %llu, name %s, namelen %u, rec len %u\n",
+			curr_p,
+			entry->entry_type, le64_to_cpu(entry->ino),
+			entry->name, entry->name_len,
+			le16_to_cpu(entry->de_len));
+
+	nova_reassign_last_dentry(sb, sih, curr_p);
+
+	if (entry->invalid == 0) {
+		if (entry->ino > 0)
+			ret = nova_replay_add_dentry(sb, sih, entry);
+		else
+			ret = nova_replay_remove_dentry(sb, sih, entry);
+	}
+
+	if (ret) {
+		nova_err(sb, "%s ERROR %d\n", __func__, ret);
+		return ret;
+	}
+
+	if (entry->trans_id >= reb->trans_id) {
+		nova_rebuild_dir_time_and_size(sb, reb, entry);
+		reb->trans_id = entry->trans_id;
+	}
+
+	return ret;
+}
+
+int nova_rebuild_dir_inode_tree(struct super_block *sb,
+	struct nova_inode *pi, u64 pi_addr,
+	struct nova_inode_info_header *sih)
+{
+	struct nova_dentry *entry = NULL;
+	struct nova_setattr_logentry *attr_entry = NULL;
+	struct nova_link_change_entry *lc_entry = NULL;
+	struct nova_inode_rebuild rebuild, *reb;
+	u64 ino = pi->nova_ino;
+	unsigned short de_len;
+	timing_t rebuild_time;
+	void *addr, *entryc = NULL;
+	u64 curr_p;
+	u8 type;
+	int ret;
+
+	NOVA_START_TIMING(rebuild_dir_t, rebuild_time);
+	nova_dbgv("Rebuild dir %llu tree\n", ino);
+
+	reb = &rebuild;
+	ret = nova_rebuild_inode_start(sb, pi, sih, reb, pi_addr);
+	if (ret)
+		goto out;
+
+	curr_p = sih->log_head;
+	if (curr_p == 0) {
+		nova_err(sb, "Dir %llu log is NULL!\n", ino);
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	while (curr_p != sih->log_tail) {
+		if (goto_next_page(sb, curr_p)) {
+			sih->log_pages++;
+			curr_p = next_log_page(sb, curr_p);
+		}
+
+		if (curr_p == 0) {
+			nova_err(sb, "Dir %llu log is NULL!\n", ino);
+			ret = -EIO;
+			goto out;
+		}
+
+		addr = (void *)nova_get_block(sb, curr_p);
+
+		entryc = addr;
+
+		type = nova_get_entry_type(entryc);
+
+		switch (type) {
+		case SET_ATTR:
+			attr_entry = (struct nova_setattr_logentry *)entryc;
+			nova_apply_setattr_entry(sb, reb, sih, attr_entry);
+			sih->last_setattr = curr_p;
+			curr_p += sizeof(struct nova_setattr_logentry);
+			break;
+		case LINK_CHANGE:
+			lc_entry = (struct nova_link_change_entry *)entryc;
+			if (lc_entry->trans_id >= reb->trans_id) {
+				nova_apply_link_change_entry(sb, reb, lc_entry);
+				reb->trans_id = lc_entry->trans_id;
+			}
+			sih->last_link_change = curr_p;
+			curr_p += sizeof(struct nova_link_change_entry);
+			break;
+		case DIR_LOG:
+			entry = (struct nova_dentry *)addr;
+			ret = nova_rebuild_handle_dentry(sb, sih, reb,
+					entry, curr_p);
+			if (ret)
+				goto out;
+			de_len = le16_to_cpu(DENTRY(entryc)->de_len);
+			curr_p += de_len;
+			break;
+		default:
+			nova_dbg("%s: unknown type %d, 0x%llx\n",
+					__func__, type, curr_p);
+			NOVA_ASSERT(0);
+			break;
+		}
+	}
+
+	ret = nova_rebuild_inode_finish(sb, pi, sih, reb, curr_p);
+	sih->i_blocks = sih->log_pages;
+
+out:
+	NOVA_END_TIMING(rebuild_dir_t, rebuild_time);
+	return ret;
+}
+
 /* initialize nova inode header and other DRAM data structures */
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 	u64 ino, u64 pi_addr, int rebuild_dir)
@@ -42,7 +355,21 @@ int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
 
 	sih->ino = ino;
 
-	/* Traverse the log */
+	switch (__le16_to_cpu(pi->i_mode) & S_IFMT) {
+	case S_IFLNK:
+		/* Treat symlink files as normal files */
+		/* Fall through */
+	case S_IFREG:
+		break;
+	case S_IFDIR:
+		if (rebuild_dir)
+			nova_rebuild_dir_inode_tree(sb, pi, pi_addr, sih);
+		break;
+	default:
+		sih->pi_addr = pi_addr;
+		break;
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
