Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B3FE2258AEF8
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:18 -0800 (PST)
Received: by mail-pg0-x243.google.com with SMTP id x2so695637pgo.9
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:37 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 17/83] Add statfs support.
Date: Sat, 10 Mar 2018 10:17:58 -0800
Message-Id: <1520705944-6723-18-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/balloc.c | 18 ++++++++++++++++++
 fs/nova/balloc.h |  1 +
 fs/nova/super.c  | 19 +++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/fs/nova/balloc.c b/fs/nova/balloc.c
index cb627db..0742fe0 100644
--- a/fs/nova/balloc.c
+++ b/fs/nova/balloc.c
@@ -217,3 +217,21 @@ inline int nova_insert_blocktree(struct nova_sb_info *sbi,
 
 	return ret;
 }
+
+/* We do not take locks so it's inaccurate */
+unsigned long nova_count_free_blocks(struct super_block *sb)
+{
+	struct nova_sb_info *sbi = NOVA_SB(sb);
+	struct free_list *free_list;
+	unsigned long num_free_blocks = 0;
+	int i;
+
+	for (i = 0; i < sbi->cpus; i++) {
+		free_list = nova_get_free_list(sb, i);
+		num_free_blocks += free_list->num_free_blocks;
+	}
+
+	return num_free_blocks;
+}
+
+
diff --git a/fs/nova/balloc.h b/fs/nova/balloc.h
index 57a93e4..537532e 100644
--- a/fs/nova/balloc.h
+++ b/fs/nova/balloc.h
@@ -66,6 +66,7 @@ inline struct nova_range_node *nova_alloc_blocknode(struct super_block *sb);
 inline void nova_free_blocknode(struct super_block *sb,
 	struct nova_range_node *bnode);
 extern void nova_init_blockmap(struct super_block *sb, int recovery);
+extern unsigned long nova_count_free_blocks(struct super_block *sb);
 inline int nova_insert_blocktree(struct nova_sb_info *sbi,
 	struct rb_root *tree, struct nova_range_node *new_node);
 
diff --git a/fs/nova/super.c b/fs/nova/super.c
index 9762f26..3500d19 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -629,6 +629,24 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	return retval;
 }
 
+static int nova_statfs(struct dentry *d, struct kstatfs *buf)
+{
+	struct super_block *sb = d->d_sb;
+	struct nova_sb_info *sbi = (struct nova_sb_info *)sb->s_fs_info;
+
+	buf->f_type = NOVA_SUPER_MAGIC;
+	buf->f_bsize = sb->s_blocksize;
+
+	buf->f_blocks = sbi->num_blocks;
+	buf->f_bfree = buf->f_bavail = nova_count_free_blocks(sb);
+	buf->f_files = LONG_MAX;
+	buf->f_ffree = LONG_MAX - sbi->s_inodes_used_count;
+	buf->f_namelen = NOVA_NAME_LEN;
+	nova_dbg_verbose("nova_stats: total 4k free blocks 0x%llx\n",
+		buf->f_bfree);
+	return 0;
+}
+
 static int nova_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct nova_sb_info *sbi = NOVA_SB(root->d_sb);
@@ -794,6 +812,7 @@ static struct super_operations nova_sops = {
 	.alloc_inode	= nova_alloc_inode,
 	.destroy_inode	= nova_destroy_inode,
 	.put_super	= nova_put_super,
+	.statfs		= nova_statfs,
 	.remount_fs	= nova_remount,
 	.show_options	= nova_show_options,
 };
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
