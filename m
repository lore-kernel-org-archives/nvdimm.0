Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13CC5210DC1C3
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 23:59:54 -0700 (PDT)
Subject: [PATCH 10/13] filesystem-dax: Make mount time pfn validation a
 debug check
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Jul 2018 23:49:56 -0700
Message-ID: <153077339595.40830.16578300356324475234.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153077334130.40830.2714147692560185329.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Do not ask for dax_direct_access() to retrieve a pfn in the
DAX_DRIVER_DEBUG=n case. This avoids an early call to memmap_sync() in
the driver.

Now that QUEUE_FLAG_DAX usage has been fixed the validation of the pfn
is only useful for dax driver developers. It is safe to assume that
pmem, dcssblk, and device-mapper-dax are correct with respect to dax
operation, so only retrieve the pfn for debug builds when qualifying a
new dax driver, if one ever arrives.

The moves the first consumption of a pfn from ->direct_access() to the
first dax mapping fault, rather than initial filesystem mount. I.e. more
time for memmap init to run in the background.

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |   10 ++++++++
 drivers/dax/super.c |   64 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index e0700bf4893a..b32f8827b983 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -9,6 +9,16 @@ menuconfig DAX
 
 if DAX
 
+config DAX_DRIVER_DEBUG
+	bool "DAX: driver debug"
+	help
+	  Enable validation of the page frame objects returned from a
+	  driver's 'direct_access' operation. This validation is
+	  performed relative to the requirements of the FS_DAX and
+	  FS_DAX_LIMITED configuration options. If you are validating
+	  the implementation of a dax device driver say Y otherwise
+	  say N.
+
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 903d9c473749..87b1c55b7c7a 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -72,6 +72,41 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
 EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 #endif
 
+static bool validate_dax_pfn(pfn_t *pfn)
+{
+	bool dax_enabled = false;
+
+	/*
+	 * Unless debugging a new dax driver, or new dax architecture
+	 * support there is no need to check the pfn. Delay the kernel's
+	 * first need for a dax pfn until first userspace dax fault.
+	 */
+	if (!pfn)
+		return true;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(*pfn)) {
+		/*
+		 * An arch that has enabled the pmem api should also
+		 * have its drivers support pfn_t_devmap()
+		 *
+		 * This is a developer warning and should not trigger in
+		 * production. dax_flush() will crash since it depends
+		 * on being able to do (page_address(pfn_to_page())).
+		 */
+		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
+		dax_enabled = true;
+	} else if (pfn_t_devmap(*pfn)) {
+		struct dev_pagemap *pgmap;
+
+		pgmap = get_dev_pagemap(pfn_t_to_pfn(*pfn), NULL);
+		if (pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX)
+			dax_enabled = true;
+		put_dev_pagemap(pgmap);
+	}
+
+	return dax_enabled;
+}
+
 /**
  * __bdev_dax_supported() - Check if the device supports dax for filesystem
  * @bdev: block device to check
@@ -85,11 +120,10 @@ EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
 bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 {
 	struct dax_device *dax_dev;
-	bool dax_enabled = false;
+	pfn_t _pfn, *pfn;
 	pgoff_t pgoff;
 	int err, id;
 	void *kaddr;
-	pfn_t pfn;
 	long len;
 	char buf[BDEVNAME_SIZE];
 
@@ -113,8 +147,10 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
+	pfn = IS_ENABLED(DAX_DRIVER_DEBUG) ? &_pfn : NULL;
+
 	id = dax_read_lock();
-	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
+	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, pfn);
 	dax_read_unlock(id);
 
 	put_dax(dax_dev);
@@ -125,27 +161,7 @@ bool __bdev_dax_supported(struct block_device *bdev, int blocksize)
 		return false;
 	}
 
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
-		/*
-		 * An arch that has enabled the pmem api should also
-		 * have its drivers support pfn_t_devmap()
-		 *
-		 * This is a developer warning and should not trigger in
-		 * production. dax_flush() will crash since it depends
-		 * on being able to do (page_address(pfn_to_page())).
-		 */
-		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
-		dax_enabled = true;
-	} else if (pfn_t_devmap(pfn)) {
-		struct dev_pagemap *pgmap;
-
-		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
-		if (pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX)
-			dax_enabled = true;
-		put_dev_pagemap(pgmap);
-	}
-
-	if (!dax_enabled) {
+	if (!validate_dax_pfn(pfn)) {
 		pr_debug("%s: error: dax support not enabled\n",
 				bdevname(bdev, buf));
 		return false;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
