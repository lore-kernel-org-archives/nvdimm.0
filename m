Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x243.google.com (mail-pl0-x243.google.com
 [IPv6:2607:f8b0:400e:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F2882258AEFB
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:13 -0800 (PST)
Received: by mail-pl0-x243.google.com with SMTP id m22-v6so7032110pls.5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:31 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 13/83] Add remount_fs and show_options methods.
Date: Sat, 10 Mar 2018 10:17:54 -0800
Message-Id: <1520705944-6723-14-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/super.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/nova/super.c b/fs/nova/super.c
index 3efb560..f41cc04 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -617,6 +617,59 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	return retval;
 }
 
+static int nova_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct nova_sb_info *sbi = NOVA_SB(root->d_sb);
+
+	if (sbi->mode != (0777 | S_ISVTX))
+		seq_printf(seq, ",mode=%03o", sbi->mode);
+	if (uid_valid(sbi->uid))
+		seq_printf(seq, ",uid=%u", from_kuid(&init_user_ns, sbi->uid));
+	if (gid_valid(sbi->gid))
+		seq_printf(seq, ",gid=%u", from_kgid(&init_user_ns, sbi->gid));
+	if (test_opt(root->d_sb, ERRORS_RO))
+		seq_puts(seq, ",errors=remount-ro");
+	if (test_opt(root->d_sb, ERRORS_PANIC))
+		seq_puts(seq, ",errors=panic");
+	if (test_opt(root->d_sb, DAX))
+		seq_puts(seq, ",dax");
+
+	return 0;
+}
+
+static int nova_remount(struct super_block *sb, int *mntflags, char *data)
+{
+	unsigned long old_sb_flags;
+	unsigned long old_mount_opt;
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	int ret = -EINVAL;
+
+	/* Store the old options */
+	mutex_lock(&sbi->s_lock);
+	old_sb_flags = sb->s_flags;
+	old_mount_opt = sbi->s_mount_opt;
+
+	if (nova_parse_options(data, sbi, 1))
+		goto restore_opt;
+
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+		      ((sbi->s_mount_opt & NOVA_MOUNT_POSIX_ACL) ?
+		       MS_POSIXACL : 0);
+
+	if ((*mntflags & MS_RDONLY) != (sb->s_flags & MS_RDONLY))
+		nova_update_mount_time(sb);
+
+	mutex_unlock(&sbi->s_lock);
+	ret = 0;
+	return ret;
+
+restore_opt:
+	sb->s_flags = old_sb_flags;
+	sbi->s_mount_opt = old_mount_opt;
+	mutex_unlock(&sbi->s_lock);
+	return ret;
+}
+
 static void nova_put_super(struct super_block *sb)
 {
 	struct nova_sb_info *sbi = NOVA_SB(sb);
@@ -697,6 +750,8 @@ static struct super_operations nova_sops = {
 	.alloc_inode	= nova_alloc_inode,
 	.destroy_inode	= nova_destroy_inode,
 	.put_super	= nova_put_super,
+	.remount_fs	= nova_remount,
+	.show_options	= nova_show_options,
 };
 
 static struct dentry *nova_mount(struct file_system_type *fs_type,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
