Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C863E22631484
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:56 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id a15so484614pgn.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:15 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 49/83] Dir: Append create/remove dentry.
Date: Sat, 10 Mar 2018 10:18:30 -0800
Message-Id: <1520705944-6723-50-git-send-email-jix024@eng.ucsd.edu>
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

NOVA adds or removes a directory/file by appending a dentry
to the parent directory's log. Dentry contains filename and inode number.
A positive inode number indicates a create(valid) dentry, and
a dentry with inode number zero is a remove dentry.
NOVA can also inplace update a create dentry to invalidate it.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/dir.c  | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nova/nova.h |   4 ++
 2 files changed, 144 insertions(+)

diff --git a/fs/nova/dir.c b/fs/nova/dir.c
index 35a66f9..47ee9ad 100644
--- a/fs/nova/dir.c
+++ b/fs/nova/dir.c
@@ -222,6 +222,146 @@ int nova_append_dir_init_entries(struct super_block *sb,
 	return 0;
 }
 
+/* adds a directory entry pointing to the inode. assumes the inode has
+ * already been logged for consistency
+ */
+int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
+	struct nova_inode_update *update, u64 epoch_id)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = dir->i_sb;
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pidir;
+	const char *name = dentry->d_name.name;
+	int namelen = dentry->d_name.len;
+	struct nova_dentry *direntry;
+	unsigned short loglen;
+	int ret;
+	u64 curr_entry;
+	timing_t add_dentry_time;
+
+	nova_dbg_verbose("%s: dir %lu new inode %llu\n",
+				__func__, dir->i_ino, ino);
+	nova_dbg_verbose("%s: %s %d\n", __func__, name, namelen);
+	NOVA_START_TIMING(add_dentry_t, add_dentry_time);
+	if (namelen == 0)
+		return -EINVAL;
+
+	pidir = nova_get_inode(sb, dir);
+
+	/*
+	 * XXX shouldn't update any times until successful
+	 * completion of syscall, but too many callers depend
+	 * on this.
+	 */
+	dir->i_mtime = dir->i_ctime = current_time(dir);
+
+	loglen = NOVA_DIR_LOG_REC_LEN(namelen);
+	ret = nova_append_dentry(sb, pidir, dir, dentry,
+				ino, loglen, update,
+				inc_link, epoch_id);
+
+	if (ret) {
+		nova_dbg("%s: append dir entry failure\n", __func__);
+		return ret;
+	}
+
+	curr_entry = update->curr_entry;
+	direntry = (struct nova_dentry *)nova_get_block(sb, curr_entry);
+	sih->last_dentry = curr_entry;
+	ret = nova_insert_dir_radix_tree(sb, sih, name, namelen, direntry);
+
+	sih->trans_id++;
+	NOVA_END_TIMING(add_dentry_t, add_dentry_time);
+	return ret;
+}
+
+static int nova_can_inplace_update_dentry(struct super_block *sb,
+	struct nova_dentry *dentry, u64 epoch_id)
+{
+	if (dentry && dentry->epoch_id == epoch_id)
+		return 1;
+
+	return 0;
+}
+
+/* removes a directory entry pointing to the inode. assumes the inode has
+ * already been logged for consistency
+ */
+int nova_remove_dentry(struct dentry *dentry, int dec_link,
+	struct nova_inode_update *update, u64 epoch_id)
+{
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = dir->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode_info *si = NOVA_I(dir);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_inode *pidir;
+	struct qstr *entry = &dentry->d_name;
+	struct nova_dentry *old_dentry = NULL;
+	unsigned short loglen;
+	int ret;
+	u64 curr_entry;
+	timing_t remove_dentry_time;
+
+	NOVA_START_TIMING(remove_dentry_t, remove_dentry_time);
+
+	update->create_dentry = NULL;
+	update->delete_dentry = NULL;
+
+	if (!dentry->d_name.len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = nova_remove_dir_radix_tree(sb, sih, entry->name, entry->len, 0,
+					&old_dentry);
+
+	if (ret)
+		goto out;
+
+	pidir = nova_get_inode(sb, dir);
+
+	dir->i_mtime = dir->i_ctime = current_time(dir);
+
+	if (nova_can_inplace_update_dentry(sb, old_dentry, epoch_id)) {
+		nova_inplace_update_dentry(sb, dir, old_dentry,
+						dec_link, epoch_id);
+		curr_entry = nova_get_addr_off(sbi, old_dentry);
+
+		sih->last_dentry = curr_entry;
+		/* Leave create/delete_dentry to NULL
+		 * Do not change tail if used as input
+		 */
+		if (update->tail == 0) {
+			update->tail = sih->log_tail;
+		}
+		sih->trans_id++;
+		goto out;
+	}
+
+	loglen = NOVA_DIR_LOG_REC_LEN(entry->len);
+	ret = nova_append_dentry(sb, pidir, dir, dentry,
+				0, loglen, update,
+				dec_link, epoch_id);
+
+	if (ret) {
+		nova_dbg("%s: append dir entry failure\n", __func__);
+		goto out;
+	}
+
+	update->create_dentry = old_dentry;
+	curr_entry = update->curr_entry;
+	update->delete_dentry = (struct nova_dentry *)nova_get_block(sb,
+						curr_entry);
+	sih->last_dentry = curr_entry;
+	sih->trans_id++;
+out:
+	NOVA_END_TIMING(remove_dentry_t, remove_dentry_time);
+	return ret;
+}
+
 static u64 nova_find_next_dentry_addr(struct super_block *sb,
 	struct nova_inode_info_header *sih, u64 pos)
 {
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index ed269fe..3a51dae 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -461,6 +461,10 @@ struct nova_dentry *nova_find_dentry(struct super_block *sb,
 	unsigned long name_len);
 int nova_append_dir_init_entries(struct super_block *sb,
 	struct nova_inode *pi, u64 self_ino, u64 parent_ino, u64 epoch_id);
+int nova_add_dentry(struct dentry *dentry, u64 ino, int inc_link,
+	struct nova_inode_update *update, u64 epoch_id);
+int nova_remove_dentry(struct dentry *dentry, int dec_link,
+	struct nova_inode_update *update, u64 epoch_id);
 
 /* rebuild.c */
 int nova_rebuild_inode(struct super_block *sb, struct nova_inode_info *si,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
