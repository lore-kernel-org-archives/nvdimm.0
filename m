Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E39A226462E2
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:11 -0800 (PST)
Received: by mail-pf0-x243.google.com with SMTP id d26so2620394pfn.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:30 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 61/83] Super: Add nova_export_ops.
Date: Sat, 10 Mar 2018 10:18:42 -0800
Message-Id: <1520705944-6723-62-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/super.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/fs/nova/super.c b/fs/nova/super.c
index daf3270..0847e57 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -51,6 +51,7 @@ module_param(nova_dbgmask, int, 0444);
 MODULE_PARM_DESC(nova_dbgmask, "Control debugging output");
 
 static struct super_operations nova_sops;
+static const struct export_operations nova_export_ops;
 
 static struct kmem_cache *nova_inode_cachep;
 static struct kmem_cache *nova_range_node_cachep;
@@ -631,6 +632,7 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &nova_sops;
 	sb->s_maxbytes = nova_max_size(sb->s_blocksize_bits);
 	sb->s_time_gran = 1000000000; // 1 second.
+	sb->s_export_op = &nova_export_ops;
 	sb->s_xattr = NULL;
 	sb->s_flags |= MS_NOSEC;
 
@@ -904,6 +906,52 @@ static struct file_system_type nova_fs_type = {
 	.kill_sb	= kill_block_super,
 };
 
+static struct inode *nova_nfs_get_inode(struct super_block *sb,
+					 u64 ino, u32 generation)
+{
+	struct inode *inode;
+
+	if (ino < NOVA_ROOT_INO)
+		return ERR_PTR(-ESTALE);
+
+	if (ino > LONG_MAX)
+		return ERR_PTR(-ESTALE);
+
+	inode = nova_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	if (generation && inode->i_generation != generation) {
+		/* we didn't find the right inode.. */
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return inode;
+}
+
+static struct dentry *nova_fh_to_dentry(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    nova_nfs_get_inode);
+}
+
+static struct dentry *nova_fh_to_parent(struct super_block *sb,
+					 struct fid *fid, int fh_len,
+					 int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    nova_nfs_get_inode);
+}
+
+static const struct export_operations nova_export_ops = {
+	.fh_to_dentry	= nova_fh_to_dentry,
+	.fh_to_parent	= nova_fh_to_parent,
+	.get_parent	= nova_get_parent,
+};
+
 static int __init init_nova_fs(void)
 {
 	int rc = 0;
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
