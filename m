Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E9D02194EB6D
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:14:55 -0700 (PDT)
Subject: [resend PATCH v2 04/33] dax: introduce dax_operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:09:11 -0700
Message-ID: <149245615151.10206.3993711890457746918.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Track a set of dax_operations per dax_device that can be set at
alloc_dax() time. These operations will be used to stop the abuse of
block_device_operations for communicating dax capabilities to
filesystems. It will also be used to replace the "pmem api" and move
pmem-specific cache maintenance, and other dax-driver-specific
filesystem-dax operations, to dax device methods. In particular this
allows us to stop abusing __copy_user_nocache(), via memcpy_to_pmem(),
with a driver specific replacement.

This is a standalone introduction of the operations. Follow on patches
convert each dax-driver and teach fs/dax.c to use ->direct_access() from
dax_operations instead of block_device_operations.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.h    |    4 +++-
 drivers/dax/device.c |    6 +++++-
 drivers/dax/super.c  |    6 +++++-
 include/linux/dax.h  |   10 ++++++++++
 4 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index 246a24d68d4c..617bbc24be2b 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,7 +13,9 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct dax_device;
-struct dax_device *alloc_dax(void *private, const char *host);
+struct dax_operations;
+struct dax_device *alloc_dax(void *private, const char *host,
+		const struct dax_operations *ops);
 void put_dax(struct dax_device *dax_dev);
 bool dax_alive(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index db68f4fa8ce0..a0db055054a4 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -645,7 +645,11 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		goto err_id;
 	}
 
-	dax_dev = alloc_dax(dev_dax, NULL);
+	/*
+	 * No 'host' or dax_operations since there is no access to this
+	 * device outside of mmap of the resulting character device.
+	 */
+	dax_dev = alloc_dax(dev_dax, NULL, NULL);
 	if (!dax_dev)
 		goto err_dax;
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index bb22956a106b..45ccfc043da8 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -17,6 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/hash.h>
 #include <linux/slab.h>
+#include <linux/dax.h>
 #include <linux/fs.h>
 
 static int nr_dax = CONFIG_NR_DEV_DAX;
@@ -61,6 +62,7 @@ struct dax_device {
 	const char *host;
 	void *private;
 	bool alive;
+	const struct dax_operations *ops;
 };
 
 bool dax_alive(struct dax_device *dax_dev)
@@ -204,7 +206,8 @@ static void dax_add_host(struct dax_device *dax_dev, const char *host)
 	spin_unlock(&dax_host_lock);
 }
 
-struct dax_device *alloc_dax(void *private, const char *__host)
+struct dax_device *alloc_dax(void *private, const char *__host,
+		const struct dax_operations *ops)
 {
 	struct dax_device *dax_dev;
 	const char *host;
@@ -225,6 +228,7 @@ struct dax_device *alloc_dax(void *private, const char *__host)
 		goto err_dev;
 
 	dax_add_host(dax_dev, host);
+	dax_dev->ops = ops;
 	dax_dev->private = private;
 	return dax_dev;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 9b2d5ba10d7d..74ebb92b625a 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -7,6 +7,16 @@
 #include <asm/pgtable.h>
 
 struct iomap_ops;
+struct dax_device;
+struct dax_operations {
+	/*
+	 * direct_access: translate a device-relative
+	 * logical-page-offset into an absolute physical pfn. Return the
+	 * number of pages available for DAX at that pfn.
+	 */
+	long (*direct_access)(struct dax_device *, pgoff_t, long,
+			void **, pfn_t *);
+};
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
