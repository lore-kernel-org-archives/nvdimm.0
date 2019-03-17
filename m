Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B86E211D6163
 for <linux-nvdimm@lists.01.org>; Sun, 17 Mar 2019 11:02:14 -0700 (PDT)
Subject: [PATCH] device-dax: Drop register_filesystem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Mar 2019 10:49:34 -0700
Message-ID: <155284497431.996981.8629530520988419809.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The device-dax fs is only there to allocate a common inode for each
device-node that refers to the same device by major:minor. It is
otherwise not user mountable and need not be displayed in
/proc/filesystems.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index ccb22d8db3a2..3d6a9e61e358 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -615,10 +615,6 @@ static int dax_fs_init(void)
 	if (!dax_cache)
 		return -ENOMEM;
 
-	rc = register_filesystem(&dax_fs_type);
-	if (rc)
-		goto err_register_fs;
-
 	dax_mnt = kern_mount(&dax_fs_type);
 	if (IS_ERR(dax_mnt)) {
 		rc = PTR_ERR(dax_mnt);
@@ -629,8 +625,6 @@ static int dax_fs_init(void)
 	return 0;
 
  err_mount:
-	unregister_filesystem(&dax_fs_type);
- err_register_fs:
 	kmem_cache_destroy(dax_cache);
 
 	return rc;
@@ -639,7 +633,6 @@ static int dax_fs_init(void)
 static void dax_fs_exit(void)
 {
 	kern_unmount(dax_mnt);
-	unregister_filesystem(&dax_fs_type);
 	kmem_cache_destroy(dax_cache);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
