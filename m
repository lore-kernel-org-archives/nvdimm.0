Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22BC922631491
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:04 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id w22-v6so7026134pll.2
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:22 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 55/83] Namei: mkdir
Date: Sat, 10 Mar 2018 10:18:36 -0800
Message-Id: <1520705944-6723-56-git-send-email-jix024@eng.ucsd.edu>
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

NOVA mkdir is similar to create. The difference is NOVA will
allocate log page for the newly created directory, and append
init dentries.

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/nova/namei.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index a07cc4f..a95b2fe 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -207,6 +207,79 @@ static int nova_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return err;
 }
 
+static int nova_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
+{
+	struct super_block *sb = dir->i_sb;
+	struct inode *inode;
+	struct nova_inode *pidir, *pi;
+	struct nova_inode_info *si, *sidir;
+	struct nova_inode_info_header *sih = NULL;
+	struct nova_inode_update update;
+	u64 pi_addr = 0;
+	u64 ino;
+	u64 epoch_id;
+	int err = -EMLINK;
+	timing_t mkdir_time;
+
+	NOVA_START_TIMING(mkdir_t, mkdir_time);
+	if (dir->i_nlink >= NOVA_LINK_MAX)
+		goto out;
+
+	ino = nova_new_nova_inode(sb, &pi_addr);
+	if (ino == 0)
+		goto out_err;
+
+	epoch_id = nova_get_epoch_id(sb);
+	nova_dbgv("%s: name %s\n", __func__, dentry->d_name.name);
+	nova_dbgv("%s: inode %llu, dir %lu, link %d\n", __func__,
+				ino, dir->i_ino, dir->i_nlink);
+
+	update.tail = 0;
+	err = nova_add_dentry(dentry, ino, 1, &update, epoch_id);
+	if (err) {
+		nova_dbg("failed to add dir entry\n");
+		goto out_err;
+	}
+
+	inode = nova_new_vfs_inode(TYPE_MKDIR, dir, pi_addr, ino,
+					S_IFDIR | mode, sb->s_blocksize,
+					0, &dentry->d_name, epoch_id);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto out_err;
+	}
+
+	pi = nova_get_inode(sb, inode);
+	err = nova_append_dir_init_entries(sb, pi, inode->i_ino, dir->i_ino,
+					epoch_id);
+	if (err < 0)
+		goto out_err;
+
+	/* Build the dir tree */
+	si = NOVA_I(inode);
+	sih = &si->header;
+	nova_rebuild_dir_inode_tree(sb, pi, pi_addr, sih);
+
+	pidir = nova_get_inode(sb, dir);
+	sidir = NOVA_I(dir);
+	sih = &si->header;
+	dir->i_blocks = sih->i_blocks;
+	inc_nlink(dir);
+	d_instantiate(dentry, inode);
+	unlock_new_inode(inode);
+
+	nova_lite_transaction_for_new_inode(sb, pi, pidir, inode, dir,
+					&update);
+out:
+	NOVA_END_TIMING(mkdir_t, mkdir_time);
+	return err;
+
+out_err:
+//	clear_nlink(inode);
+	nova_err(sb, "%s return %d\n", __func__, err);
+	goto out;
+}
+
 struct dentry *nova_get_parent(struct dentry *child)
 {
 	struct inode *inode;
@@ -234,5 +307,6 @@ struct dentry *nova_get_parent(struct dentry *child)
 const struct inode_operations nova_dir_inode_operations = {
 	.create		= nova_create,
 	.lookup		= nova_lookup,
+	.mkdir		= nova_mkdir,
 	.mknod		= nova_mknod,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
