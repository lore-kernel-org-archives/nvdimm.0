Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A43D322603B10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:07 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id m22-v6so7032836pls.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:26 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 58/83] Namei: rename
Date: Sat, 10 Mar 2018 10:18:39 -0800
Message-Id: <1520705944-6723-59-git-send-email-jix024@eng.ucsd.edu>
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

Rename is the most cpmplex namei operation. The target dir may be
different from the source dir, and the target inode may exist.
Rename involves up to four inodes, and NOVA uses rename transation
to atomically update all the affected inodes.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/namei.c | 195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 195 insertions(+)

diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index 4bf6396..bb50c0a 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -541,6 +541,200 @@ static int nova_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
+static int nova_rename(struct inode *old_dir,
+			struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry,
+			unsigned int flags)
+{
+	struct inode *old_inode = old_dentry->d_inode;
+	struct inode *new_inode = new_dentry->d_inode;
+	struct super_block *sb = old_inode->i_sb;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct nova_inode *old_pi = NULL, *new_pi = NULL;
+	struct nova_inode *new_pidir = NULL, *old_pidir = NULL;
+	struct nova_dentry *father_entry = NULL;
+	char *head_addr = NULL;
+	int invalidate_new_inode = 0;
+	struct nova_inode_update update_dir_new;
+	struct nova_inode_update update_dir_old;
+	struct nova_inode_update update_new;
+	struct nova_inode_update update_old;
+	u64 old_linkc1 = 0, old_linkc2 = 0;
+	int err = -ENOENT;
+	int inc_link = 0, dec_link = 0;
+	int cpu;
+	int change_parent = 0;
+	u64 journal_tail;
+	u64 epoch_id;
+	timing_t rename_time;
+
+	nova_dbgv("%s: rename %s to %s,\n", __func__,
+			old_dentry->d_name.name, new_dentry->d_name.name);
+	nova_dbgv("%s: %s inode %lu, old dir %lu, new dir %lu, new inode %lu\n",
+			__func__, S_ISDIR(old_inode->i_mode) ? "dir" : "normal",
+			old_inode->i_ino, old_dir->i_ino, new_dir->i_ino,
+			new_inode ? new_inode->i_ino : 0);
+
+	if (flags & ~RENAME_NOREPLACE)
+		return -EINVAL;
+
+	NOVA_START_TIMING(rename_t, rename_time);
+
+	if (new_inode) {
+		err = -ENOTEMPTY;
+		if (S_ISDIR(old_inode->i_mode) && !nova_empty_dir(new_inode))
+			goto out;
+	} else {
+		if (S_ISDIR(old_inode->i_mode)) {
+			err = -EMLINK;
+			if (new_dir->i_nlink >= NOVA_LINK_MAX)
+				goto out;
+		}
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
+		dec_link = -1;
+		if (!new_inode)
+			inc_link = 1;
+		/*
+		 * Tricky for in-place update:
+		 * New dentry is always after renamed dentry, so we have to
+		 * make sure new dentry has the correct links count
+		 * to workaround the rebuild nlink issue.
+		 */
+		if (old_dir == new_dir) {
+			inc_link--;
+			if (inc_link == 0)
+				dec_link = 0;
+		}
+	}
+
+	epoch_id = nova_get_epoch_id(sb);
+	new_pidir = nova_get_inode(sb, new_dir);
+	old_pidir = nova_get_inode(sb, old_dir);
+
+	old_pi = nova_get_inode(sb, old_inode);
+	old_inode->i_ctime = current_time(old_inode);
+	update_old.tail = 0;
+	err = nova_append_link_change_entry(sb, old_pi, old_inode,
+					&update_old, &old_linkc1, epoch_id);
+	if (err)
+		goto out;
+
+	if (S_ISDIR(old_inode->i_mode) && old_dir != new_dir) {
+		/* My father is changed. Update .. entry */
+		/* For simplicity, we use in-place update and journal it */
+		change_parent = 1;
+		head_addr = (char *)nova_get_block(sb, old_pi->log_head);
+		father_entry = (struct nova_dentry *)(head_addr +
+					NOVA_DIR_LOG_REC_LEN(1));
+
+		if (le64_to_cpu(father_entry->ino) != old_dir->i_ino)
+			nova_err(sb, "%s: dir %lu parent should be %lu, but actually %lu\n",
+				__func__,
+				old_inode->i_ino, old_dir->i_ino,
+				le64_to_cpu(father_entry->ino));
+	}
+
+	update_dir_new.tail = 0;
+	if (new_inode) {
+		/* First remove the old entry in the new directory */
+		err = nova_remove_dentry(new_dentry, 0, &update_dir_new,
+					epoch_id);
+		if (err)
+			goto out;
+	}
+
+	/* link into the new directory. */
+	err = nova_add_dentry(new_dentry, old_inode->i_ino,
+				inc_link, &update_dir_new, epoch_id);
+	if (err)
+		goto out;
+
+	if (inc_link > 0)
+		inc_nlink(new_dir);
+
+	update_dir_old.tail = 0;
+	if (old_dir == new_dir) {
+		update_dir_old.tail = update_dir_new.tail;
+	}
+
+	err = nova_remove_dentry(old_dentry, dec_link, &update_dir_old,
+					epoch_id);
+	if (err)
+		goto out;
+
+	if (dec_link < 0)
+		drop_nlink(old_dir);
+
+	if (new_inode) {
+		new_pi = nova_get_inode(sb, new_inode);
+		new_inode->i_ctime = current_time(new_inode);
+
+		if (S_ISDIR(old_inode->i_mode)) {
+			if (new_inode->i_nlink)
+				drop_nlink(new_inode);
+		}
+		if (new_inode->i_nlink)
+			drop_nlink(new_inode);
+
+		update_new.tail = 0;
+		err = nova_append_link_change_entry(sb, new_pi, new_inode,
+						&update_new, &old_linkc2,
+						epoch_id);
+		if (err)
+			goto out;
+	}
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+	if (new_inode && new_inode->i_nlink == 0)
+		invalidate_new_inode = 1;
+	journal_tail = nova_create_rename_transaction(sb, old_inode, old_dir,
+				new_inode,
+				old_dir != new_dir ? new_dir : NULL,
+				father_entry,
+				invalidate_new_inode,
+				cpu);
+
+	nova_update_inode(sb, old_inode, old_pi, &update_old);
+	nova_update_inode(sb, old_dir, old_pidir, &update_dir_old);
+
+	if (old_pidir != new_pidir)
+		nova_update_inode(sb, new_dir, new_pidir, &update_dir_new);
+
+	if (change_parent && father_entry) {
+		father_entry->ino = cpu_to_le64(new_dir->i_ino);
+		nova_persist_entry(father_entry);
+	}
+
+	if (new_inode) {
+		if (invalidate_new_inode) {
+			new_pi->valid = 0;
+			new_pi->delete_epoch_id = epoch_id;
+		}
+		nova_update_inode(sb, new_inode, new_pi, &update_new);
+	}
+
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	nova_invalidate_link_change_entry(sb, old_linkc1);
+	nova_invalidate_link_change_entry(sb, old_linkc2);
+	if (new_inode)
+		nova_invalidate_dentries(sb, &update_dir_new);
+	nova_invalidate_dentries(sb, &update_dir_old);
+
+	NOVA_END_TIMING(rename_t, rename_time);
+	return 0;
+out:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(rename_t, rename_time);
+	return err;
+}
+
 struct dentry *nova_get_parent(struct dentry *child)
 {
 	struct inode *inode;
@@ -573,4 +767,5 @@ const struct inode_operations nova_dir_inode_operations = {
 	.mkdir		= nova_mkdir,
 	.rmdir		= nova_rmdir,
 	.mknod		= nova_mknod,
+	.rename		= nova_rename,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
