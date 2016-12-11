Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32C2E82029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:32:55 -0800 (PST)
Subject: [PATCH 4/8] dax: use multi-order radix for resource lookup
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:28:46 -0800
Message-ID: <148143772606.10950.7648706422287905979.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Before we add support for multiple discontiguous extents in a device-dax
region, convert the file-offset to physical-address lookup to use the
multi-order radix tree.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    1 
 drivers/dax/dax.c   |  120 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 104 insertions(+), 17 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 3e2ab3b14eea..f01d1b353b8e 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -2,6 +2,7 @@ menuconfig DEV_DAX
 	tristate "DAX: direct access to differentiated memory"
 	default m if NVDIMM_DAX
 	depends on TRANSPARENT_HUGEPAGE
+	select RADIX_TREE_MULTIORDER
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index c9ba011e333b..d878a56cf3e3 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -458,28 +458,34 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	return 0;
 }
 
+/*
+ * Reuse the unused ->desc attribute of a dax_dev resource to store the
+ * relative pgoff of the resource within the device.
+ */
+static unsigned long to_dev_pgoff(struct resource *res)
+{
+	return res->desc;
+}
+
+static void set_dev_pgoff(struct resource *res, unsigned long dev_pgoff)
+{
+	res->desc = dev_pgoff;
+}
+
 static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 		unsigned long size)
 {
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	phys_addr_t res_offset;
 	struct resource *res;
-	phys_addr_t phys;
-	int i;
-
-	for (i = 0; i < dax_dev->num_resources; i++) {
-		res = dax_dev->res[i];
-		phys = pgoff * PAGE_SIZE + res->start;
-		if (phys >= res->start && phys <= res->end)
-			break;
-		pgoff -= PHYS_PFN(resource_size(res));
-	}
-
-	if (i < dax_dev->num_resources) {
-		res = dax_dev->res[i];
-		if (phys + size - 1 <= res->end)
-			return phys;
-	}
 
-	return -1;
+	res = radix_tree_lookup(&mapping->page_tree, pgoff);
+	if (!res)
+		return -1;
+	res_offset = PFN_PHYS(pgoff - to_dev_pgoff(res));
+	if (res_offset + size >= resource_size(res))
+		return -1;
+	return res->start + res_offset;
 }
 
 static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
@@ -682,6 +688,58 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_mmap,
 };
 
+static unsigned order_at(struct resource *res, unsigned long pgoff)
+{
+	unsigned long dev_pgoff = to_dev_pgoff(res) + pgoff;
+	unsigned long nr_pages = PHYS_PFN(resource_size(res));
+	unsigned order_max, order_pgoff;
+
+	if (nr_pages == pgoff)
+		return UINT_MAX;
+
+	/*
+	 * What is the largest power-of-2 range available from this
+	 * resource pgoff to the end of the resource range, considering
+	 * the alignment of the current dev_pgoff?
+	 */
+	order_pgoff = ilog2(nr_pages | dev_pgoff);
+	order_max = ilog2(nr_pages - pgoff);
+	return min(order_max, order_pgoff);
+}
+
+#define foreach_order_pgoff(res, order, pgoff) \
+	for (pgoff = 0, order = order_at((res), pgoff); order < UINT_MAX; \
+		pgoff += 1UL << order, order = order_at(res, pgoff))
+
+static void clear_dax_dev_radix(struct dax_dev *dax_dev)
+{
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	rcu_read_lock();
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, 0) {
+		struct resource *res;
+		unsigned long pgoff;
+		unsigned order;
+
+		res = radix_tree_deref_slot(slot);
+		if (unlikely(!res))
+			continue;
+		if (radix_tree_deref_retry(res)) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
+
+		foreach_order_pgoff(res, order, pgoff)
+			radix_tree_delete(&mapping->page_tree,
+					to_dev_pgoff(res) + pgoff);
+	}
+	rcu_read_unlock();
+
+	synchronize_rcu();
+}
+
 static void dax_dev_release(struct device *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
@@ -716,6 +774,7 @@ static void unregister_dax_dev(void *dev)
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
 
 	mutex_lock(&dax_region->lock);
+	clear_dax_dev_radix(dax_dev);
 	for (i = 0; i < dax_dev->num_resources; i++)
 		__release_region(&dax_region->res, dax_dev->res[i]->start,
 				resource_size(dax_dev->res[i]));
@@ -734,6 +793,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
 	int rc = 0, minor, i;
+	unsigned long pgoff;
 	struct device *dev;
 	struct cdev *cdev;
 	dev_t dev_t;
@@ -790,6 +850,28 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		goto err_inode;
 	}
 
+	for (i = 0, pgoff = 0; i < count; i++) {
+		struct address_space *mapping = dax_dev->inode->i_mapping;
+		struct resource *dax_res;
+		int order;
+
+		dax_res = dax_dev->res[i];
+		set_dev_pgoff(dax_res, pgoff);
+		mutex_lock(&dax_region->lock);
+		foreach_order_pgoff(dax_res, order, pgoff) {
+			rc = __radix_tree_insert(&mapping->page_tree,
+					to_dev_pgoff(dax_res) + pgoff, order,
+					dax_res);
+			if (rc)
+				break;
+		}
+		mutex_unlock(&dax_region->lock);
+		pgoff = to_dev_pgoff(dax_res) + PHYS_PFN(resource_size(dax_res));
+
+		if (rc)
+			goto err_radix_insert;
+	}
+
 	/* device_initialize() so cdev can reference kobj parent */
 	device_initialize(dev);
 
@@ -840,6 +922,10 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	return dax_dev;
 
  err_cdev:
+	mutex_lock(&dax_region->lock);
+	clear_dax_dev_radix(dax_dev);
+	mutex_unlock(&dax_region->lock);
+ err_radix_insert:
 	iput(dax_dev->inode);
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
