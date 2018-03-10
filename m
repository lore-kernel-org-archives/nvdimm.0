Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 719512263149D
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:06 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id w12-v6so7031041plp.4
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:25 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 57/83] Namei: rmdir
Date: Sat, 10 Mar 2018 10:18:38 -0800
Message-Id: <1520705944-6723-58-git-send-email-jix024@eng.ucsd.edu>
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

Similar to unlink.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/namei.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index 360d716..4bf6396 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -437,6 +437,110 @@ static int nova_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	goto out;
 }
 
+/*
+ * routine to check that the specified directory is empty (for rmdir)
+ */
+static int nova_empty_dir(struct inode *inode)
+{
+	struct super_block *sb;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	struct nova_dentry *entry;
+	unsigned long pos = 0;
+	struct nova_dentry *entries[4];
+	int nr_entries;
+	int i;
+
+	sb = inode->i_sb;
+	nr_entries = radix_tree_gang_lookup(&sih->tree,
+					(void **)entries, pos, 4);
+	if (nr_entries > 2)
+		return 0;
+
+	for (i = 0; i < nr_entries; i++) {
+		entry = entries[i];
+
+		if (!is_dir_init_entry(sb, entry))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int nova_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct nova_dentry *de;
+	struct super_block *sb = inode->i_sb;
+	struct nova_inode *pi = nova_get_inode(sb, inode), *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	struct nova_inode_info *si = NOVA_I(inode);
+	struct nova_inode_info_header *sih = &si->header;
+	int err = -ENOTEMPTY;
+	u64 epoch_id;
+	timing_t rmdir_time;
+
+	NOVA_START_TIMING(rmdir_t, rmdir_time);
+	if (!inode)
+		return -ENOENT;
+
+	nova_dbgv("%s: name %s\n", __func__, dentry->d_name.name);
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		return -EINVAL;
+
+	if (nova_inode_by_name(dir, &dentry->d_name, &de) == 0)
+		return -ENOENT;
+
+	if (!nova_empty_dir(inode))
+		return err;
+
+	nova_dbgv("%s: inode %lu, dir %lu, link %d\n", __func__,
+				inode->i_ino, dir->i_ino, dir->i_nlink);
+
+	if (inode->i_nlink != 2)
+		nova_dbg("empty directory %lu has nlink!=2 (%d), dir %lu",
+				inode->i_ino, inode->i_nlink, dir->i_ino);
+
+	epoch_id = nova_get_epoch_id(sb);
+
+	update_dir.tail = 0;
+	err = nova_remove_dentry(dentry, -1, &update_dir, epoch_id);
+	if (err)
+		goto end_rmdir;
+
+	/*inode->i_version++; */
+	clear_nlink(inode);
+	inode->i_ctime = dir->i_ctime;
+
+	if (dir->i_nlink)
+		drop_nlink(dir);
+
+	nova_delete_dir_tree(sb, sih);
+
+	update.tail = 0;
+	err = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (err)
+		goto end_rmdir;
+
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+					&update, &update_dir, 1, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+	nova_invalidate_dentries(sb, &update_dir);
+
+	NOVA_END_TIMING(rmdir_t, rmdir_time);
+	return err;
+
+end_rmdir:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(rmdir_t, rmdir_time);
+	return err;
+}
+
 struct dentry *nova_get_parent(struct dentry *child)
 {
 	struct inode *inode;
@@ -467,5 +571,6 @@ const struct inode_operations nova_dir_inode_operations = {
 	.link		= nova_link,
 	.unlink		= nova_unlink,
 	.mkdir		= nova_mkdir,
+	.rmdir		= nova_rmdir,
 	.mknod		= nova_mknod,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
