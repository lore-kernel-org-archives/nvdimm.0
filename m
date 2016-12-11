Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD2E482029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:33:05 -0800 (PST)
Subject: [PATCH 6/8] dax: sub-division support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:28:56 -0800
Message-ID: <148143773633.10950.11187126583319503457.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Device-DAX is a mechanism to establish mappings of performance / feature
differentiated memory with strict fault behavior guarantees. With
sub-division support a platform owner can provision sub-allocations of a
dax-region into separate devices. The provisioning mechanism follows the
same scheme as the libnvdimm sub-system in that a 'seed' device is
created at initialization time that can be resized from zero to become
enabled. Note that a later patch handles creating a new seed when the
current one is "planted" (enabled).

Unlike the nvdimm sub-system there is no on media labelling scheme
associated with this partitioning. Provisioning decisions are ephemeral
/ not automatically restored after reboot. While the initial use case of
device-dax is persistent memory other uses case may be volatile, so the
device-dax core is unable to assume the underlying memory is pmem.  The
task of recalling a partitioning scheme or permissions on the device(s)
is left to userspace.

For persistent allocations, naming, and permissions automatically
recalled by the kernel, use filesystem-DAX. For a userspace helper
library and utility for manipulating device-dax instances see libdaxctl
and the daxctl utility here: https://github.com/pmem/ndctl

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  351 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 312 insertions(+), 39 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 5b65eaff6ace..9b641c079e52 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -63,6 +63,7 @@ struct dax_region {
 /**
  * struct dax_dev - subdivision of a dax region
  * @region - parent region
+ * @resize_lock - for resource size reductions
  * @dev - device backing the character device
  * @cdev - core chardev data
  * @alive - !alive + rcu grace period == no new mappings can be established
@@ -72,6 +73,7 @@ struct dax_region {
  */
 struct dax_dev {
 	struct dax_region *region;
+	rwlock_t resize_lock;
 	struct inode *inode;
 	struct device dev;
 	struct cdev cdev;
@@ -419,7 +421,302 @@ static ssize_t size_show(struct device *dev,
 
 	return sprintf(buf, "%llu\n", size);
 }
-static DEVICE_ATTR_RO(size);
+
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
+static int dax_dev_adjust_resource(struct dax_dev *dax_dev,
+		struct resource *res, resource_size_t size)
+{
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	unsigned long pgoff;
+	int rc = 0, order;
+
+	/*
+	 * Take the lock to prevent false negative lookups while we
+	 * adjust both the resource and radix entries. Note that the
+	 * false *positive* lookups that are allowed by not locking when
+	 * deleting full resources are permissible because we will end
+	 * up invalidating those mappings before completing the resize.
+	 */
+	write_lock(&dax_dev->resize_lock);
+	foreach_order_pgoff(res, order, pgoff)
+		radix_tree_delete(&mapping->page_tree,
+				to_dev_pgoff(res) + pgoff);
+
+	adjust_resource(res, res->start, size);
+
+	foreach_order_pgoff(res, order, pgoff) {
+		rc = __radix_tree_insert(&mapping->page_tree,
+				to_dev_pgoff(res) + pgoff, order, res);
+		if (rc) {
+			dev_WARN(&dax_dev->dev,
+					"error: %d adjusting size\n", rc);
+			break;
+		}
+	}
+	write_unlock(&dax_dev->resize_lock);
+
+	return rc;
+}
+
+static int dax_dev_shrink(struct dax_region *dax_region,
+		struct dax_dev *dax_dev, unsigned long long size)
+{
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	resource_size_t dev_size = dax_dev_size(dax_dev);
+	resource_size_t res_size, to_free;
+	struct resource *max_res, *res;
+	unsigned long pgoff;
+	int i, order, rc = 0;
+
+	to_free = dev_size - size;
+
+retry:
+	max_res = NULL;
+	/* delete from the highest pgoff resource */
+	for (i = 0; i < dax_dev->num_resources; i++) {
+		res = dax_dev->res[i];
+		if (!max_res || to_dev_pgoff(res) > to_dev_pgoff(max_res))
+			max_res = res;
+	}
+
+	res = max_res;
+	if (!res)
+		return -ENXIO;
+	res_size = resource_size(res);
+
+	if (to_free >= res_size) {
+		foreach_order_pgoff(res, order, pgoff)
+			radix_tree_delete(&mapping->page_tree,
+					to_dev_pgoff(res) + pgoff);
+		synchronize_rcu();
+		__release_region(&dax_region->res, res->start, res_size);
+		for (i = 0; i < dax_dev->num_resources; i++)
+			if (res == dax_dev->res[i])
+				break;
+		for (i = i + 1; i < dax_dev->num_resources; i++)
+			dax_dev->res[i - 1] = dax_dev->res[i];
+		dax_dev->num_resources--;
+		to_free -= res_size;
+
+		/*
+		 * Once we've deleted a resource we need to search the
+		 * next resource at the highest remaining dev_pgoff.
+		 */
+		if (to_free)
+			goto retry;
+	} else {
+		rc = dax_dev_adjust_resource(dax_dev, res, res_size - to_free);
+		synchronize_rcu();
+	}
+
+	/*
+	 * Now that the lookup radix and resource tree has been cleaned
+	 * up we can invalidate any remaining mappings in the deleted
+	 * range.
+	 */
+	unmap_mapping_range(mapping, size, dev_size - size, 1);
+
+	return rc;
+}
+
+static int dax_dev_add_resource(struct dax_region *dax_region,
+		struct dax_dev *dax_dev, resource_size_t start,
+		resource_size_t size, unsigned long dev_pgoff)
+{
+	struct address_space *mapping = dax_dev->inode->i_mapping;
+	struct resource *res, **resources;
+	int order, rc = -ENOMEM;
+	unsigned long pgoff;
+
+	res = __request_region(&dax_region->res, start, size,
+			dev_name(&dax_dev->dev), 0);
+	if (!res)
+		return -EBUSY;
+	set_dev_pgoff(res, dev_pgoff);
+	resources = krealloc(dax_dev->res, sizeof(struct resource *)
+			* (dax_dev->num_resources + 1), GFP_KERNEL);
+	if (!resources)
+		goto err_resources;
+	dax_dev->res = resources;
+	dax_dev->res[dax_dev->num_resources++] = res;
+
+	foreach_order_pgoff(res, order, pgoff) {
+		rc = __radix_tree_insert(&mapping->page_tree,
+				to_dev_pgoff(res) + pgoff, order, res);
+		if (rc)
+			goto err_radix;
+	}
+
+	return 0;
+
+err_radix:
+	foreach_order_pgoff(res, order, pgoff)
+		radix_tree_delete(&mapping->page_tree,
+				to_dev_pgoff(res) + pgoff);
+	dax_dev->res[--dax_dev->num_resources] = NULL;
+err_resources:
+	__release_region(&dax_region->res, start, size);
+	return -ENOMEM;
+
+}
+
+static ssize_t dax_dev_resize(struct dax_region *dax_region,
+		struct dax_dev *dax_dev, resource_size_t size)
+{
+	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
+	resource_size_t dev_size = dax_dev_size(dax_dev);
+	struct resource *max_res = NULL, *res, *first;
+	unsigned long dev_pgoff = PHYS_PFN(dev_size);
+	const char *name = dev_name(&dax_dev->dev);
+	resource_size_t region_end;
+	int i, rc;
+
+	if (size == dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+
+	if (size < dev_size)
+		return dax_dev_shrink(dax_region, dax_dev, size);
+
+	to_alloc = size - dev_size;
+	if (!IS_ALIGNED(to_alloc, dax_region->align)) {
+		WARN_ON(1);
+		return -ENXIO;
+	}
+
+	for (i = 0; i < dax_dev->num_resources; i++) {
+		res = dax_dev->res[i];
+		if (!max_res || to_dev_pgoff(res) > to_dev_pgoff(max_res))
+			max_res = res;
+	}
+
+	/*
+	 * Expand the device into the unused portion of the region. This
+	 * may involve adjusting the end of an existing resource, or
+	 * allocating a new disjoint resource.
+	 */
+	region_end = dax_region->res.start + resource_size(&dax_region->res);
+	first = dax_region->res.child;
+	for (res = first; to_alloc && res; res = res->sibling) {
+		struct resource *next = res->sibling;
+		resource_size_t alloc, res_end;
+
+		res_end = res->start + resource_size(res);
+
+		/* space at the beginning of the region */
+		if (res == first && res->start > dax_region->res.start) {
+			alloc = res->start - dax_region->res.start;
+			alloc = min(alloc, to_alloc);
+			rc = dax_dev_add_resource(dax_region, dax_dev,
+					dax_region->res.start, alloc,
+					dev_pgoff);
+			if (rc)
+				return rc;
+			to_alloc -= alloc;
+			dev_pgoff += PHYS_PFN(alloc);
+		}
+
+		/* space between allocations */
+		if (to_alloc && next && next->start > res_end) {
+			alloc = next->start - res_end;
+			alloc = min(alloc, to_alloc);
+			if (res == max_res && strcmp(name, res->name) == 0)
+				rc = dax_dev_adjust_resource(dax_dev, res,
+						resource_size(res) + alloc);
+			else
+				rc = dax_dev_add_resource(dax_region, dax_dev,
+						res_end, alloc, dev_pgoff);
+			if (rc)
+				return rc;
+			to_alloc -= alloc;
+			dev_pgoff += PHYS_PFN(alloc);
+		}
+
+		/* space at the end of the region */
+		if (to_alloc && !next && res_end < region_end) {
+			alloc = region_end - res_end;
+			alloc = min(alloc, to_alloc);
+			if (res == max_res && strcmp(name, res->name) == 0)
+				rc = dax_dev_adjust_resource(dax_dev, res,
+						resource_size(res) + alloc);
+			else
+				rc = dax_dev_add_resource(dax_region, dax_dev,
+						res_end, alloc, dev_pgoff);
+			if (rc)
+				return rc;
+			to_alloc -= alloc;
+			dev_pgoff += PHYS_PFN(alloc);
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t size_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	ssize_t rc;
+	unsigned long long val;
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
+
+	rc = kstrtoull(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (!IS_ALIGNED(val, dax_region->align)) {
+		dev_dbg(&dax_dev->dev, "%s: size: %lld misaligned\n",
+				__func__, val);
+		return -EINVAL;
+	}
+
+	mutex_lock(&dax_region->lock);
+	rc = dax_dev_resize(dax_region, dax_dev, val);
+	mutex_unlock(&dax_region->lock);
+
+	if (rc == 0)
+		return len;
+
+	return rc;
+}
+static DEVICE_ATTR_RW(size);
 
 static struct attribute *dax_device_attributes[] = {
 	&dev_attr_size.attr,
@@ -476,21 +773,7 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	return 0;
 }
 
-/*
- * Reuse the unused ->desc attribute of a dax_dev resource to store the
- * relative pgoff of the resource within the device.
- */
-static unsigned long to_dev_pgoff(struct resource *res)
-{
-	return res->desc;
-}
-
-static void set_dev_pgoff(struct resource *res, unsigned long dev_pgoff)
-{
-	res->desc = dev_pgoff;
-}
-
-static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+static phys_addr_t __pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct address_space *mapping = dax_dev->inode->i_mapping;
@@ -506,6 +789,18 @@ static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 	return res->start + res_offset;
 }
 
+static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+                unsigned long size)
+{
+	phys_addr_t phys;
+
+	read_lock(&dax_dev->resize_lock);
+	phys = __pgoff_to_phys(dax_dev, pgoff, size);
+	read_unlock(&dax_dev->resize_lock);
+
+	return phys;
+}
+
 static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
@@ -706,29 +1001,6 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_mmap,
 };
 
-static unsigned order_at(struct resource *res, unsigned long pgoff)
-{
-	unsigned long dev_pgoff = to_dev_pgoff(res) + pgoff;
-	unsigned long nr_pages = PHYS_PFN(resource_size(res));
-	unsigned order_max, order_pgoff;
-
-	if (nr_pages == pgoff)
-		return UINT_MAX;
-
-	/*
-	 * What is the largest power-of-2 range available from this
-	 * resource pgoff to the end of the resource range, considering
-	 * the alignment of the current dev_pgoff?
-	 */
-	order_pgoff = ilog2(nr_pages | dev_pgoff);
-	order_max = ilog2(nr_pages - pgoff);
-	return min(order_max, order_pgoff);
-}
-
-#define foreach_order_pgoff(res, order, pgoff) \
-	for (pgoff = 0, order = order_at((res), pgoff); order < UINT_MAX; \
-		pgoff += 1UL << order, order = order_at(res, pgoff))
-
 static void clear_dax_dev_radix(struct dax_dev *dax_dev)
 {
 	struct address_space *mapping = dax_dev->inode->i_mapping;
@@ -905,6 +1177,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dax_dev->num_resources = count;
 	dax_dev->alive = true;
 	dax_dev->region = dax_region;
+	rwlock_init(&dax_dev->resize_lock);
 	kref_get(&dax_region->kref);
 
 	dev->devt = dev_t;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
