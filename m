Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id D50191A1E1B
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:12:43 -0700 (PDT)
Subject: [PATCH 2/4] dax: add region-available-size attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:09:38 -0700
Message-ID: <147136737849.26813.13273014239442957870.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for a facility that enables dax regions to be
sub-divided, introduce a 'dax/available_size' attribute.  This attribute
appears under the parent device that registered the device-dax region,
and it assumes that the device-dax-core owns the driver-data for that
device.

'dax/available_size' adjusts dynamically as dax-device instances are
registered and unregistered.

As a side effect of using __request_region() to reserve capacity from
the dax_region we now track pointers to those returned resources rather
than duplicating the passed in resource array.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  135 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 123 insertions(+), 12 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 03bb54f7f58f..257cad62bd1d 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -38,6 +38,7 @@ MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
  * @id: kernel-wide unique region for a memory range
  * @base: linear address corresponding to @res
  * @kref: to pin while other agents have a need to do lookups
+ * @lock: synchronize changes / consistent-access to the resource tree (@res)
  * @dev: parent device backing this region
  * @align: allocation and mapping alignment for child dax devices
  * @res: physical address range of the region
@@ -48,6 +49,7 @@ struct dax_region {
 	struct ida ida;
 	void *base;
 	struct kref kref;
+	struct mutex lock;
 	struct device *dev;
 	unsigned int align;
 	struct resource res;
@@ -72,7 +74,56 @@ struct dax_dev {
 	bool alive;
 	int id;
 	int num_resources;
-	struct resource res[0];
+	struct resource **res;
+};
+
+#define for_each_dax_region_resource(dax_region, res) \
+	for (res = (dax_region)->res.child; res; res = res->sibling)
+
+static unsigned long long dax_region_avail_size(
+		struct dax_region *dax_region)
+{
+	unsigned long long size;
+	struct resource *res;
+
+	mutex_lock(&dax_region->lock);
+	size = resource_size(&dax_region->res);
+	for_each_dax_region_resource(dax_region, res)
+		size -= resource_size(res);
+	mutex_unlock(&dax_region->lock);
+
+	return size;
+}
+
+static ssize_t available_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	dax_region = dev_get_drvdata(dev);
+	if (dax_region)
+		rc = sprintf(buf, "%llu\n", dax_region_avail_size(dax_region));
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(available_size);
+
+static struct attribute *dax_region_attributes[] = {
+	&dev_attr_available_size.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_region_attribute_group = {
+	.name = "dax_region",
+	.attrs = dax_region_attributes,
+};
+
+static const struct attribute_group *dax_region_attribute_groups[] = {
+	&dax_region_attribute_group,
+	NULL,
 };
 
 static struct inode *dax_alloc_inode(struct super_block *sb)
@@ -200,12 +251,27 @@ void dax_region_put(struct dax_region *dax_region)
 }
 EXPORT_SYMBOL_GPL(dax_region_put);
 
+
+static void dax_region_unregister(void *region)
+{
+	struct dax_region *dax_region = region;
+
+	sysfs_remove_groups(&dax_region->dev->kobj,
+			dax_region_attribute_groups);
+	dax_region_put(dax_region);
+}
+
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct resource *res, unsigned int align, void *addr,
 		unsigned long pfn_flags)
 {
 	struct dax_region *dax_region;
 
+	if (dev_get_drvdata(parent)) {
+		dev_WARN(parent, "dax core found drvdata already in use\n");
+		return NULL;
+	}
+
 	if (!IS_ALIGNED(res->start, align)
 			|| !IS_ALIGNED(resource_size(res), align))
 		return NULL;
@@ -213,16 +279,26 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
 	if (!dax_region)
 		return NULL;
-
-	memcpy(&dax_region->res, res, sizeof(*res));
+	dev_set_drvdata(parent, dax_region);
+	dax_region->res.name = dev_name(parent);
+	dax_region->res.start = res->start;
+	dax_region->res.end = res->end;
 	dax_region->pfn_flags = pfn_flags;
+	mutex_init(&dax_region->lock);
 	kref_init(&dax_region->kref);
 	dax_region->id = region_id;
 	ida_init(&dax_region->ida);
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->base = addr;
+	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
+		kfree(dax_region);
+		return NULL;;
+	}
 
+	kref_get(&dax_region->kref);
+	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
+		return NULL;
 	return dax_region;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
@@ -240,7 +316,7 @@ static ssize_t size_show(struct device *dev,
 	int i;
 
 	for (i = 0; i < dax_dev->num_resources; i++)
-		size += resource_size(&dax_dev->res[i]);
+		size += resource_size(dax_dev->res[i]);
 
 	return sprintf(buf, "%llu\n", size);
 }
@@ -309,7 +385,7 @@ static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 	int i;
 
 	for (i = 0; i < dax_dev->num_resources; i++) {
-		res = &dax_dev->res[i];
+		res = dax_dev->res[i];
 		phys = pgoff * PAGE_SIZE + res->start;
 		if (phys >= res->start && phys <= res->end)
 			break;
@@ -317,7 +393,7 @@ static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 	}
 
 	if (i < dax_dev->num_resources) {
-		res = &dax_dev->res[i];
+		res = dax_dev->res[i];
 		if (phys + size - 1 <= res->end)
 			return phys;
 	}
@@ -534,13 +610,16 @@ static void dax_dev_release(struct device *dev)
 	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
 	iput(dax_dev->inode);
+	kfree(dax_dev->res);
 	kfree(dax_dev);
 }
 
 static void unregister_dax_dev(void *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
 	struct cdev *cdev = &dax_dev->cdev;
+	int i;
 
 	dev_dbg(dev, "%s\n", __func__);
 
@@ -554,6 +633,13 @@ static void unregister_dax_dev(void *dev)
 	dax_dev->alive = false;
 	synchronize_rcu();
 	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
+
+	mutex_lock(&dax_region->lock);
+	for (i = 0; i < dax_dev->num_resources; i++)
+		__release_region(&dax_region->res, dax_dev->res[i]->start,
+				resource_size(dax_dev->res[i]));
+	mutex_unlock(&dax_region->lock);
+
 	cdev_del(cdev);
 	device_unregister(dev);
 }
@@ -568,28 +654,42 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	struct cdev *cdev;
 	dev_t dev_t;
 
-	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
+	dax_dev = kzalloc(sizeof(*dax_dev), GFP_KERNEL);
 	if (!dax_dev)
 		return -ENOMEM;
 
+	dax_dev->res = kzalloc(sizeof(res) * count, GFP_KERNEL);
+	if (!dax_dev->res)
+		goto err_res;
+
 	for (i = 0; i < count; i++) {
+		struct resource *dax_res;
+
 		if (!IS_ALIGNED(res[i].start, dax_region->align)
 				|| !IS_ALIGNED(resource_size(&res[i]),
 					dax_region->align)) {
 			rc = -EINVAL;
 			break;
 		}
-		dax_dev->res[i].start = res[i].start;
-		dax_dev->res[i].end = res[i].end;
+
+		mutex_lock(&dax_region->lock);
+		dax_res = __request_region(&dax_region->res, res[i].start,
+				resource_size(&res[i]), NULL, 0);
+		mutex_unlock(&dax_region->lock);
+		if (!dax_res) {
+			rc = -EBUSY;
+			break;
+		}
+		dax_dev->res[i] = dax_res;
 	}
 
 	if (i < count)
-		goto err_id;
+		goto err_request_region;
 
 	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
 	if (dax_dev->id < 0) {
 		rc = dax_dev->id;
-		goto err_id;
+		goto err_request_region;
 	}
 
 	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
@@ -629,6 +729,10 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	dev->groups = dax_attribute_groups;
 	dev->release = dax_dev_release;
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
+	/* update resource names now that the owner device is named */
+	for (i = 0; i < dax_dev->num_resources; i++)
+		dax_dev->res[i]->name = dev_name(dev);
+
 	rc = device_add(dev);
 	if (rc) {
 		put_device(dev);
@@ -643,7 +747,14 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
- err_id:
+ err_request_region:
+	mutex_lock(&dax_region->lock);
+	for (i--; i >= 0; i--)
+		__release_region(&dax_region->res, dax_dev->res[i]->start,
+				resource_size(dax_dev->res[i]));
+	mutex_unlock(&dax_region->lock);
+	kfree(dax_dev->res);
+ err_res:
 	kfree(dax_dev);
 
 	return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
