Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCB912258AEFB
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:11 -0800 (PST)
Received: by mail-pl0-x244.google.com with SMTP id u13-v6so7031217plq.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:30 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 12/83] Add timing for mount and init.
Date: Sat, 10 Mar 2018 10:17:53 -0800
Message-Id: <1520705944-6723-13-git-send-email-jix024@eng.ucsd.edu>
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
 fs/nova/super.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/nova/super.c b/fs/nova/super.c
index 9295d23..3efb560 100644
--- a/fs/nova/super.c
+++ b/fs/nova/super.c
@@ -347,6 +347,9 @@ static struct nova_inode *nova_init(struct super_block *sb,
 	struct nova_inode *root_i, *pi;
 	struct nova_super_block *super;
 	struct nova_sb_info *sbi = NOVA_SB(sb);
+	timing_t init_time;
+
+	NOVA_START_TIMING(new_init_t, init_time);
 
 	nova_info("creating an empty nova of size %lu\n", size);
 	sbi->num_blocks = ((unsigned long)(size) >> PAGE_SHIFT);
@@ -357,6 +360,7 @@ static struct nova_inode *nova_init(struct super_block *sb,
 
 	if (!nova_check_size(sb, size)) {
 		nova_warn("Specified NOVA size too small 0x%lx.\n", size);
+		NOVA_END_TIMING(new_init_t, init_time);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -399,6 +403,7 @@ static struct nova_inode *nova_init(struct super_block *sb,
 	PERSISTENT_MARK();
 	PERSISTENT_BARRIER();
 	nova_info("NOVA initialization finish\n");
+	NOVA_END_TIMING(new_init_t, init_time);
 	return root_i;
 }
 
@@ -473,15 +478,22 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned long blocksize;
 	u32 random = 0;
 	int retval = -EINVAL;
+	timing_t mount_time;
+
+	NOVA_START_TIMING(mount_t, mount_time);
 
 	BUILD_BUG_ON(sizeof(struct nova_super_block) > NOVA_SB_SIZE);
 
 	sbi = kzalloc(sizeof(struct nova_sb_info), GFP_KERNEL);
-	if (!sbi)
+	if (!sbi) {
+		NOVA_END_TIMING(mount_t, mount_time);
 		return -ENOMEM;
+	}
+
 	sbi->nova_sb = kzalloc(sizeof(struct nova_super_block), GFP_KERNEL);
 	if (!sbi->nova_sb) {
 		kfree(sbi);
+		NOVA_END_TIMING(mount_t, mount_time);
 		return -ENOMEM;
 	}
 
@@ -591,6 +603,7 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 		nova_update_mount_time(sb);
 
 	retval = 0;
+	NOVA_END_TIMING(mount_t, mount_time);
 	return retval;
 
 out:
@@ -600,6 +613,7 @@ static int nova_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(sbi->nova_sb);
 	kfree(sbi);
 	nova_dbg("%s failed: return %d\n", __func__, retval);
+	NOVA_END_TIMING(mount_t, mount_time);
 	return retval;
 }
 
@@ -701,6 +715,9 @@ static struct file_system_type nova_fs_type = {
 static int __init init_nova_fs(void)
 {
 	int rc = 0;
+	timing_t init_time;
+
+	NOVA_START_TIMING(init_t, init_time);
 
 	nova_dbg("%s: %d cpus online\n", __func__, num_online_cpus());
 	if (arch_has_clwb())
@@ -711,17 +728,19 @@ static int __init init_nova_fs(void)
 
 	rc = init_inodecache();
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = register_filesystem(&nova_fs_type);
 	if (rc)
 		goto out1;
 
+out:
+	NOVA_END_TIMING(init_t, init_time);
 	return rc;
 
 out1:
 	destroy_inodecache();
-	return rc;
+	goto out;
 }
 
 static void __exit exit_nova_fs(void)
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
