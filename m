Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x243.google.com (mail-pl0-x243.google.com
 [IPv6:2607:f8b0:400e:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 463BC2253FB61
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:05 -0800 (PST)
Received: by mail-pl0-x243.google.com with SMTP id f23-v6so7024300plr.10
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:24 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 56/83] Namei: link and unlink.
Date: Sat, 10 Mar 2018 10:18:37 -0800
Message-Id: <1520705944-6723-57-git-send-email-jix024@eng.ucsd.edu>
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

For link change operations, NOVA appends a link change entry
to the affected inode's log, and uses lite transaction to
atomically commit changes to multiple logs.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/namei.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 159 insertions(+)

diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index a95b2fe..360d716 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -207,6 +207,163 @@ static int nova_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
+static void nova_lite_transaction_for_time_and_link(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode *pidir, struct inode *inode,
+	struct inode *dir, struct nova_inode_update *update,
+	struct nova_inode_update *update_dir, int invalidate, u64 epoch_id)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	u64 journal_tail;
+	int cpu;
+	timing_t trans_time;
+
+	NOVA_START_TIMING(link_trans_t, trans_time);
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+
+	// If you change what's required to create a new inode, you need to
+	// update this functions so the changes will be roll back on failure.
+	journal_tail = nova_create_inode_transaction(sb, inode, dir, cpu,
+						0, invalidate);
+
+	if (invalidate) {
+		pi->valid = 0;
+		pi->delete_epoch_id = epoch_id;
+	}
+	nova_update_inode(sb, inode, pi, update);
+
+	nova_update_inode(sb, dir, pidir, update_dir);
+
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	NOVA_END_TIMING(link_trans_t, trans_time);
+}
+
+static int nova_link(struct dentry *dest_dentry, struct inode *dir,
+		      struct dentry *dentry)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode = dest_dentry->d_inode;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	u64 epoch_id;
+	int err = -ENOMEM;
+	timing_t link_time;
+
+	NOVA_START_TIMING(link_t, link_time);
+	if (inode->i_nlink >= NOVA_LINK_MAX) {
+		err = -EMLINK;
+		goto out;
+	}
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ihold(inode);
+	epoch_id = nova_get_epoch_id(sb);
+
+	nova_dbgv("%s: name %s, dest %s\n", __func__,
+			dentry->d_name.name, dest_dentry->d_name.name);
+	nova_dbgv("%s: inode %lu, dir %lu\n", __func__,
+			inode->i_ino, dir->i_ino);
+
+	update_dir.tail = 0;
+	err = nova_add_dentry(dentry, inode->i_ino, 0, &update_dir, epoch_id);
+	if (err) {
+		iput(inode);
+		goto out;
+	}
+
+	inode->i_ctime = current_time(inode);
+	inc_nlink(inode);
+
+	update.tail = 0;
+	err = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (err) {
+		iput(inode);
+		goto out;
+	}
+
+	d_instantiate(dentry, inode);
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+					&update, &update_dir, 0, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+
+out:
+	NOVA_END_TIMING(link_t, link_time);
+	return err;
+}
+
+static int nova_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct super_block *sb = dir->i_sb;
+	int retval = -ENOMEM;
+	struct nova_inode *pi = nova_get_inode(sb, inode);
+	struct nova_inode *pidir;
+	struct nova_inode_update update_dir;
+	struct nova_inode_update update;
+	u64 old_linkc = 0;
+	u64 epoch_id;
+	int invalidate = 0;
+	timing_t unlink_time;
+
+	NOVA_START_TIMING(unlink_t, unlink_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out;
+
+	epoch_id = nova_get_epoch_id(sb);
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %lu, dir %lu\n", __func__,
+				inode->i_ino, dir->i_ino);
+
+	update_dir.tail = 0;
+	retval = nova_remove_dentry(dentry, 0, &update_dir, epoch_id);
+	if (retval)
+		goto out;
+
+	inode->i_ctime = dir->i_ctime;
+
+	if (inode->i_nlink == 1)
+		invalidate = 1;
+
+	if (inode->i_nlink)
+		drop_nlink(inode);
+
+	update.tail = 0;
+	retval = nova_append_link_change_entry(sb, pi, inode, &update,
+						&old_linkc, epoch_id);
+	if (retval)
+		goto out;
+
+	nova_lite_transaction_for_time_and_link(sb, pi, pidir, inode, dir,
+				&update, &update_dir, invalidate, epoch_id);
+
+	nova_invalidate_link_change_entry(sb, old_linkc);
+	nova_invalidate_dentries(sb, &update_dir);
+
+	NOVA_END_TIMING(unlink_t, unlink_time);
+	return 0;
+out:
+	nova_err(sb, "%s return %d\n", __func__, retval);
+	NOVA_END_TIMING(unlink_t, unlink_time);
+	return retval;
+}
+
 static int nova_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
@@ -307,6 +464,8 @@ struct dentry *nova_get_parent(struct dentry *child)
 const struct inode_operations nova_dir_inode_operations = {
 	.create		= nova_create,
 	.lookup		= nova_lookup,
+	.link		= nova_link,
+	.unlink		= nova_unlink,
 	.mkdir		= nova_mkdir,
 	.mknod		= nova_mknod,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
