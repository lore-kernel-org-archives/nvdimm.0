Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC6D42194EB7A
 for <linux-nvdimm@lists.01.org>; Tue, 16 Apr 2019 09:42:44 -0700 (PDT)
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 17/18] btrfs: Disable dax-based defrag and send
Date: Tue, 16 Apr 2019 11:41:53 -0500
Message-Id: <20190416164154.30390-18-rgoldwyn@suse.de>
In-Reply-To: <20190416164154.30390-1-rgoldwyn@suse.de>
References: <20190416164154.30390-1-rgoldwyn@suse.de>
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
To: linux-btrfs@vger.kernel.org
Cc: kilobyte@angband.pl, jack@suse.cz, darrick.wong@oracle.com, nborisov@suse.com, linux-nvdimm@lists.01.org, david@fromorbit.com, dsterba@suse.cz, willy@infradead.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This is temporary, and a TODO.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ioctl.c | 13 +++++++++++++
 fs/btrfs/send.c  |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cd590105bd78..8ac770fe00dc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2990,6 +2990,12 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 
+		if (IS_DAX(inode)) {
+			btrfs_warn(root->fs_info, "File defrag is not supported with DAX");
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
 		if (argp) {
 			if (copy_from_user(range, argp,
 					   sizeof(*range))) {
@@ -4653,6 +4659,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* send can be on a directory, so check super block instead */
+	if (btrfs_test_opt(fs_info, DAX))
+		return -EOPNOTSUPP;
+
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
@@ -5505,6 +5515,9 @@ static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
 	struct btrfs_ioctl_send_args *arg;
 	int ret;
 
+	if (IS_DAX(file_inode(file)))
+		return -EOPNOTSUPP;
+
 	if (compat) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 		struct btrfs_ioctl_send_args_32 args32;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7ea2d6b1f170..9679fd54db86 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6609,6 +6609,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	int sort_clone_roots = 0;
 	int index;
 
+	/* send can be on a directory, so check super block instead */
+	if (btrfs_test_opt(fs_info, DAX))
+		return -EOPNOTSUPP;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
