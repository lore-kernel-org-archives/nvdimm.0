Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2ADE8226462E7
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:15:10 -0800 (PST)
Received: by mail-pf0-x244.google.com with SMTP id a16so2614831pfn.9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:21:28 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 60/83] Add special inode operations.
Date: Sat, 10 Mar 2018 10:18:41 -0800
Message-Id: <1520705944-6723-61-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/inode.c | 2 ++
 fs/nova/namei.c | 5 +++++
 fs/nova/nova.h  | 1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/nova/inode.c b/fs/nova/inode.c
index 2092a55..0e9ab4b 100644
--- a/fs/nova/inode.c
+++ b/fs/nova/inode.c
@@ -239,6 +239,7 @@ static int nova_read_inode(struct super_block *sb, struct inode *inode,
 	case S_IFLNK:
 		break;
 	default:
+		inode->i_op = &nova_special_inode_operations;
 		init_special_inode(inode, inode->i_mode,
 				   le32_to_cpu(pi->dev.rdev));
 		break;
@@ -929,6 +930,7 @@ struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
 		break;
 	case TYPE_MKNOD:
 		init_special_inode(inode, mode, rdev);
+		inode->i_op = &nova_special_inode_operations;
 		break;
 	case TYPE_SYMLINK:
 		inode->i_mapping->a_ops = &nova_aops_dax;
diff --git a/fs/nova/namei.c b/fs/nova/namei.c
index 1966bff..7a81672 100644
--- a/fs/nova/namei.c
+++ b/fs/nova/namei.c
@@ -771,3 +771,8 @@ const struct inode_operations nova_dir_inode_operations = {
 	.setattr	= nova_notify_change,
 	.get_acl	= NULL,
 };
+
+const struct inode_operations nova_special_inode_operations = {
+	.setattr	= nova_notify_change,
+	.get_acl	= NULL,
+};
diff --git a/fs/nova/nova.h b/fs/nova/nova.h
index 03ea0bd..85292d3 100644
--- a/fs/nova/nova.h
+++ b/fs/nova/nova.h
@@ -486,6 +486,7 @@ int nova_remove_dentry(struct dentry *dentry, int dec_link,
 
 /* namei.c */
 extern const struct inode_operations nova_dir_inode_operations;
+extern const struct inode_operations nova_special_inode_operations;
 extern struct dentry *nova_get_parent(struct dentry *child);
 
 /* rebuild.c */
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
