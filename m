Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4180211DBE73
 for <linux-nvdimm@lists.01.org>; Thu, 14 Mar 2019 09:10:19 -0700 (PDT)
Subject: [PATCH 10/38] vfs: Convert dax to fs_context
From: David Howells <dhowells@redhat.com>
Date: Thu, 14 Mar 2019 16:10:16 +0000
Message-ID: <155257981689.13720.12884353658173264997.stgit@warthog.procyon.org.uk>
In-Reply-To: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
References: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Dan Williams <dan.j.williams@intel.com>
cc: Vishal Verma <vishal.l.verma@intel.com>
cc: Keith Busch <keith.busch@intel.com>
cc: Dave Jiang <dave.jiang@intel.com>
cc: linux-nvdimm@lists.01.org
---

 drivers/dax/super.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 0cb8c30ea278..40a9e665be32 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/fs_context.h>
 #include <linux/magic.h>
 #include <linux/genhd.h>
 #include <linux/pfn_t.h>
@@ -435,16 +436,16 @@ static const struct super_operations dax_sops = {
 	.drop_inode = generic_delete_inode,
 };
 
-static struct dentry *dax_mount(struct file_system_type *fs_type,
-		int flags, const char *dev_name, void *data)
+static int dax_init_fs_context(struct fs_context *fc)
 {
-	return mount_pseudo(fs_type, "dax:", &dax_sops, NULL, DAXFS_MAGIC);
+	return vfs_init_pseudo_fs_context(fc, "dax:",
+					  &dax_sops, NULL, NULL, DAXFS_MAGIC);
 }
 
 static struct file_system_type dax_fs_type = {
-	.name = "dax",
-	.mount = dax_mount,
-	.kill_sb = kill_anon_super,
+	.name		= "dax",
+	.init_fs_context = dax_init_fs_context,
+	.kill_sb	= kill_anon_super,
 };
 
 static int dax_test(struct inode *inode, void *data)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
