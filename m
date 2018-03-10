Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5E342263149B
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:02 -0800 (PST)
Received: by mail-pl0-x242.google.com with SMTP id 61-v6so7023997plf.3
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:21 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 54/83] Namei: create and mknod.
Date: Sat, 10 Mar 2018 10:18:35 -0800
Message-Id: <1520705944-6723-55-git-send-email-jix024@eng.ucsd.edu>
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

NOVA allocates and initializes a new inode, and appends a dentry
to the directory's log. Then NOVA creates a transaction to
commit both changes atomically: update the directory log tail
pointer and validate the new inode.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/namei.c | 141 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index 8076f5b..a07cc4f 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -68,6 +68,145 @@ static struct dentry *nova_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 }
 
+static void nova_lite_transaction_for_new_inode(struct super_block *sb,
+	struct nova_inode *pi, struct nova_inode *pidir, struct inode *inode,
+	struct inode *dir, struct nova_inode_update *update)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int cpu;
+	u64 journal_tail;
+	timing_t trans_time;
+
+	NOVA_START_TIMING(create_trans_t, trans_time);
+
+	cpu = smp_processor_id();
+	spin_lock(&sbi->journal_locks[cpu]);
+
+	// If you change what's required to create a new inode, you need to
+	// update this functions so the changes will be roll back on failure.
+	journal_tail = nova_create_inode_transaction(sb, inode, dir, cpu, 1, 0);
+
+	nova_update_inode(sb, dir, pidir, update);
+
+	pi->valid = 1;
+	nova_persist_inode(pi);
+	PERSISTENT_BARRIER();
+
+	nova_commit_lite_transaction(sb, journal_tail, cpu);
+	spin_unlock(&sbi->journal_locks[cpu]);
+
+	NOVA_END_TIMING(create_trans_t, trans_time);
+}
+
+/* Returns new tail after append */
+/*
+ * By the time this is called, we already have created
+ * the directory cache entry for the new file, but it
+ * is so far negative - it has no inode.
+ *
+ * If the create succeeds, we fill in the inode information
+ * with d_instantiate().
+ */
+static int nova_create(struct inode *dir, struct dentry *dentry, umode_t mode,
+			bool excl)
+{
+	struct inode *inode = NULL;
+	int err = PTR_ERR(inode);
+	struct super_block *sb = dir->i_sb;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 pi_addr = 0;
+	u64 ino, epoch_id;
+	timing_t create_time;
+
+	NOVA_START_TIMING(create_t, create_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	update.tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_err;
+
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+	inode = nova_new_vfs_inode(TYPE_CREATE, dir, pi_addr, ino, mode,
+					0, 0, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode))
+		goto out_err;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	pi = nova_get_block(sb, pi_addr);
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+						&update);
+	NOVA_END_TIMING(create_t, create_time);
+	return err;
+out_err:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(create_t, create_time);
+	return err;
+}
+
+static int nova_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
+		       dev_t rdev)
+{
+	struct inode *inode = NULL;
+	int err = PTR_ERR(inode);
+	struct super_block *sb = dir->i_sb;
+	u64 pi_addr = 0;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_update update;
+	u64 ino;
+	u64 epoch_id;
+	timing_t mknod_time;
+
+	NOVA_START_TIMING(mknod_t, mknod_time);
+
+	pidir = nova_get_inode(sb, dir);
+	if (!pidir)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	nova_dbgv("%s: %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu\n", __func__, ino, dir->i_ino);
+
+	update.tail = 0;
+	err = nova_add_dentry(dentry, ino, 0, &update, epoch_id);
+	if (err)
+		goto out_err;
+
+	inode = nova_new_vfs_inode(TYPE_MKNOD, dir, pi_addr, ino, mode,
+					0, rdev, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode))
+		goto out_err;
+
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	pi = nova_get_block(sb, pi_addr);
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+						&update);
+	NOVA_END_TIMING(mknod_t, mknod_time);
+	return err;
+out_err:
+	nova_err(sb, "%s return %d\n", __func__, err);
+	NOVA_END_TIMING(mknod_t, mknod_time);
+	return err;
+}
+
 struct dentry *nova_get_parent(struct dentry *child)
 {
 	struct inode *inode;
@@ -93,5 +232,7 @@ struct dentry *nova_get_parent(struct dentry *child)
 }
 
 const struct inode_operations nova_dir_inode_operations = {
+	.create		= nova_create,
 	.lookup		= nova_lookup,
+	.mknod		= nova_mknod,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
