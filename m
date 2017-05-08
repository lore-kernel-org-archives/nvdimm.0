Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27D7021A0BA8E
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 14:09:43 -0700 (PDT)
Subject: [PATCH 2/2] device-dax: kill NR_DEV_DAX
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 08 May 2017 14:03:50 -0700
Message-ID: <149427743028.38205.11259335580114937340.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149427742346.38205.12361226658239922137.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149427742346.38205.12361226658239922137.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-block@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

There is no point to ask how many device-dax instances the kernel should
support. Since we are already using a dynamic major number, just allow
the max number of minors by default and be done. This also fixes the
fact that the proposed max for the NR_DEV_DAX range was larger than what
could be supported by alloc_chrdev_region().

Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    5 -----
 drivers/dax/super.c |   11 +++--------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 6b7e20eae16c..b79aa8f7a497 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -28,9 +28,4 @@ config DEV_DAX_PMEM
 
 	  Say Y if unsure
 
-config NR_DEV_DAX
-	int "Maximum number of Device-DAX instances"
-	default 32768
-	range 256 2147483647
-
 endif
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 465dcd7317d5..f2d4f20eb2b8 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -20,10 +20,6 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 
-static int nr_dax = CONFIG_NR_DEV_DAX;
-module_param(nr_dax, int, S_IRUGO);
-MODULE_PARM_DESC(nr_dax, "max number of dax device instances");
-
 static dev_t dax_devt;
 DEFINE_STATIC_SRCU(dax_srcu);
 static struct vfsmount *dax_mnt;
@@ -261,7 +257,7 @@ struct dax_device *alloc_dax(void *private, const char *__host,
 	if (__host && !host)
 		return NULL;
 
-	minor = ida_simple_get(&dax_minor_ida, 0, nr_dax, GFP_KERNEL);
+	minor = ida_simple_get(&dax_minor_ida, 0, MINORMASK+1, GFP_KERNEL);
 	if (minor < 0)
 		goto err_minor;
 
@@ -405,8 +401,7 @@ static int __init dax_fs_init(void)
 	if (rc)
 		return rc;
 
-	nr_dax = max(nr_dax, 256);
-	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
+	rc = alloc_chrdev_region(&dax_devt, 0, MINORMASK+1, "dax");
 	if (rc)
 		__dax_fs_exit();
 	return rc;
@@ -414,7 +409,7 @@ static int __init dax_fs_init(void)
 
 static void __exit dax_fs_exit(void)
 {
-	unregister_chrdev_region(dax_devt, nr_dax);
+	unregister_chrdev_region(dax_devt, MINORMASK+1);
 	ida_destroy(&dax_minor_ida);
 	__dax_fs_exit();
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
