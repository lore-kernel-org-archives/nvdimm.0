Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38ED221A13492
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 08:31:08 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [RFC PATCH] dax: add badblocks check to Device DAX
Date: Wed,  3 May 2017 09:31:03 -0600
Message-Id: <20170503153103.30756-1-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is a RFC patch for seeking suggestions.  It adds support of
badblocks check in Device DAX by using region-level badblocks list.
This patch is only briefly tested.

device_dax is a well-isolated self-contained module as it calls
alloc_dax() with dev_dax, which is private to device_dax.  For
checking badblocks, it needs to call dax_pmem to check with
region-level badblocks.

This patch attempts to keep device_dax self-contained.  It adds
check_error() to dax_operations, and dax_check_error() as a stub
with *dev_dax and *dev pointers to convey it to dax_pmem.  I am
wondering if this is the right direction, or we should change the
modularity to let dax_pmem call alloc_dax() with its dax_pmem (or
I completely missed something).

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/device-dax.h |    4 +++-
 drivers/dax/device.c     |   22 ++++++++++++----------
 drivers/dax/pmem.c       |   28 +++++++++++++++++++++++++++-
 drivers/dax/super.c      |   19 +++++++++++++++++++
 include/linux/dax.h      |    7 +++++++
 5 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
index fdcd976..ae0277c 100644
--- a/drivers/dax/device-dax.h
+++ b/drivers/dax/device-dax.h
@@ -12,6 +12,7 @@
  */
 #ifndef __DEVICE_DAX_H__
 #define __DEVICE_DAX_H__
+#include <linux/dax.h>
 struct device;
 struct dev_dax;
 struct resource;
@@ -21,5 +22,6 @@ struct dax_region *alloc_dax_region(struct device *parent,
 		int region_id, struct resource *res, unsigned int align,
 		void *addr, unsigned long flags);
 struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
-		struct resource *res, int count);
+		struct resource *res, int count,
+		const struct dax_operations *ops);
 #endif /* __DEVICE_DAX_H__ */
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 1a3e08e..7eb1395 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -249,13 +249,14 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		pgoff -= PHYS_PFN(resource_size(res));
 	}
 
-	if (i < dev_dax->num_resources) {
-		res = &dev_dax->res[i];
-		if (phys + size - 1 <= res->end)
-			return phys;
-	}
+	if ((i >= dev_dax->num_resources) ||
+	    (phys + size - 1 > res->end))
+		return -1;
 
-	return -1;
+	if (dax_check_error(dev_dax->dax_dev, dev_dax->dev.parent, phys, size))
+		return -1;
+
+	return phys;
 }
 
 static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
@@ -340,7 +341,7 @@ static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
-		return VM_FAULT_SIGBUS;
+		return VM_FAULT_FALLBACK;
 	}
 
 	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
@@ -392,7 +393,7 @@ static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
-		return VM_FAULT_SIGBUS;
+		return VM_FAULT_FALLBACK;
 	}
 
 	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
@@ -574,7 +575,8 @@ static void unregister_dev_dax(void *dev)
 }
 
 struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
-		struct resource *res, int count)
+		struct resource *res, int count,
+		const struct dax_operations *ops)
 {
 	struct device *parent = dax_region->dev;
 	struct dax_device *dax_dev;
@@ -612,7 +614,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	 * No 'host' or dax_operations since there is no access to this
 	 * device outside of mmap of the resulting character device.
 	 */
-	dax_dev = alloc_dax(dev_dax, NULL, NULL);
+	dax_dev = alloc_dax(dev_dax, NULL, ops);
 	if (!dax_dev)
 		goto err_dax;
 
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index d4ca19b..c8db9bc 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -56,6 +56,32 @@ static void dax_pmem_percpu_kill(void *data)
 	wait_for_completion(&dax_pmem->cmp);
 }
 
+static int dax_pmem_check_error(struct device *dev, phys_addr_t phys,
+		unsigned long len)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	sector_t sector;
+
+	if (phys < nd_region->ndr_start) {
+		len = phys + len - nd_region->ndr_start;
+		phys = nd_region->ndr_start;
+	}
+
+	if (phys + len > nd_region->ndr_start + nd_region->ndr_size)
+		len = nd_region->ndr_start + nd_region->ndr_size - phys;
+
+	sector = (phys - nd_region->ndr_start) / 512;
+
+	if (unlikely(is_bad_pmem(&nd_region->bb, sector, len)))
+		return -EIO;
+
+	return 0;
+}
+
+static const struct dax_operations dax_pmem_ops = {
+	.check_error = dax_pmem_check_error,
+};
+
 static int dax_pmem_probe(struct device *dev)
 {
 	int rc;
@@ -130,7 +156,7 @@ static int dax_pmem_probe(struct device *dev)
 		return -ENOMEM;
 
 	/* TODO: support for subdividing a dax region... */
-	dev_dax = devm_create_dev_dax(dax_region, &res, 1);
+	dev_dax = devm_create_dev_dax(dax_region, &res, 1, &dax_pmem_ops);
 
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 465dcd7..6a83174 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -104,6 +104,25 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 }
 EXPORT_SYMBOL_GPL(dax_direct_access);
 
+/**
+ * dax_check_error() - check if a physical address range has any error
+ * @dax_dev: a dax_device instance representing the logical memory range
+ * @dev: a device instance representing the driver's device
+ * @phys: physical base address to check for error
+ * @len: length of physical address range to check for error
+ *
+ * Return: 0 if no error, negative errno if any error is found.
+ */
+int dax_check_error(struct dax_device *dax_dev, struct device *dev,
+		phys_addr_t phys, unsigned long len)
+{
+	if (!dax_dev->ops || !dax_dev->ops->check_error)
+		return 0;
+
+	return dax_dev->ops->check_error(dev, phys, len);
+}
+EXPORT_SYMBOL_GPL(dax_check_error);
+
 bool dax_alive(struct dax_device *dax_dev)
 {
 	lockdep_assert_held(&dax_srcu);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3158e7..7b575c4 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -16,6 +16,11 @@ struct dax_operations {
 	 */
 	long (*direct_access)(struct dax_device *, pgoff_t, long,
 			void **, pfn_t *);
+
+	/*
+	 * check_error: check if a physical address range has any error.
+	 */
+	int (*check_error)(struct device *, phys_addr_t, unsigned long);
 };
 
 int dax_read_lock(void);
@@ -29,6 +34,8 @@ void kill_dax(struct dax_device *dax_dev);
 void *dax_get_private(struct dax_device *dax_dev);
 long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		void **kaddr, pfn_t *pfn);
+int dax_check_error(struct dax_device *dax_dev, struct device *dev,
+		phys_addr_t phys, unsigned long len);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
