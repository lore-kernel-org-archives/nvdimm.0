Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 134F382029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:33:11 -0800 (PST)
Subject: [PATCH 7/8] dax: add / remove dax devices after provisioning
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:29:01 -0800
Message-ID: <148143774173.10950.7251573649546331606.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Create a new device-dax seed when incrementing the size of the existing
seed from zero.

Destroy a device-dax instance when its size changes from non-zero to
zero.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  195 +++++++++++++++++++++++++++++++++++------------------
 1 file changed, 128 insertions(+), 67 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 9b641c079e52..b130eff91b83 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/mount.h>
 #include <linux/pfn_t.h>
+#include <linux/async.h>
 #include <linux/hash.h>
 #include <linux/cdev.h>
 #include <linux/slab.h>
@@ -32,6 +33,7 @@ static struct vfsmount *dax_mnt;
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
+static ASYNC_DOMAIN_EXCLUSIVE(dax_dev_async);
 
 /**
  * struct dax_region - mapping infrastructure for dax devices
@@ -329,6 +331,7 @@ static void dax_region_free(struct kref *kref)
 			"%s: child count not zero\n",
 			dev_name(dax_region->dev));
 	kfree(dax_region);
+	module_put(THIS_MODULE);
 }
 
 void dax_region_put(struct dax_region *dax_region)
@@ -377,15 +380,22 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->base = addr;
-	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
-		kfree(dax_region);
-		return NULL;;
-	}
+	if (!try_module_get(THIS_MODULE))
+		goto err_module;
+
+	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups))
+		goto err_groups;
 
 	kref_get(&dax_region->kref);
 	if (devm_add_action_or_reset(parent, dax_region_unregister, dax_region))
 		return NULL;
 	return dax_region;
+
+err_groups:
+	module_put(THIS_MODULE);
+err_module:
+	kfree(dax_region);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
@@ -402,6 +412,9 @@ static unsigned long long dax_dev_size(struct dax_dev *dax_dev)
 
 	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
 
+	if (!dax_dev->alive)
+		return 0;
+
 	for (i = 0; i < dax_dev->num_resources; i++)
 		size += resource_size(dax_dev->res[i]);
 
@@ -415,6 +428,9 @@ static ssize_t size_show(struct device *dev,
 	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct dax_region *dax_region = dax_dev->region;
 
+	/* flush previous size operations */
+	async_synchronize_full_domain(&dax_dev_async);
+
 	mutex_lock(&dax_region->lock);
 	size = dax_dev_size(dax_dev);
 	mutex_unlock(&dax_region->lock);
@@ -494,6 +510,89 @@ static int dax_dev_adjust_resource(struct dax_dev *dax_dev,
 	return rc;
 }
 
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
+static void unregister_dax_dev(void *dev)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
+	struct cdev *cdev = &dax_dev->cdev;
+	int i;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	/*
+	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
+	 * ensuring that any fault handlers that might have seen
+	 * dax_dev->alive == true, have completed.  Any fault handlers
+	 * that start after synchronize_rcu() has started will abort
+	 * upon seeing dax_dev->alive == false.
+	 */
+	dax_dev->alive = false;
+	synchronize_rcu();
+	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
+
+	mutex_lock(&dax_region->lock);
+	clear_dax_dev_radix(dax_dev);
+	for (i = 0; i < dax_dev->num_resources; i++)
+		__release_region(&dax_region->res, dax_dev->res[i]->start,
+				resource_size(dax_dev->res[i]));
+	if (dax_region->seed == dev)
+		dax_region->seed = NULL;
+	mutex_unlock(&dax_region->lock);
+	atomic_dec(&dax_region->child_count);
+
+	cdev_del(cdev);
+	device_unregister(dev);
+}
+
+static void dax_dev_async_unregister(void *d, async_cookie_t cookie)
+{
+	struct device *dev = d;
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
+
+	/*
+	 * Check that we still have an enabled region, if not then this
+	 * device was unregistered when the region was disabled.
+	 */
+	device_lock(dax_region->dev);
+	if (dev_get_drvdata(dax_region->dev)) {
+		devm_remove_action(dax_region->dev, unregister_dax_dev, dev);
+		unregister_dax_dev(dev);
+	}
+	device_unlock(dax_region->dev);
+
+	put_device(dev);
+}
+
 static int dax_dev_shrink(struct dax_region *dax_region,
 		struct dax_dev *dax_dev, unsigned long long size)
 {
@@ -552,6 +651,14 @@ static int dax_dev_shrink(struct dax_region *dax_region,
 	 */
 	unmap_mapping_range(mapping, size, dev_size - size, 1);
 
+	if (size == 0 && &dax_dev->dev != dax_region->seed) {
+		get_device(&dax_dev->dev);
+		dax_dev->alive = false;
+		synchronize_rcu();
+		async_schedule_domain(dax_dev_async_unregister, &dax_dev->dev,
+				&dax_dev_async);
+	}
+
 	return rc;
 }
 
@@ -607,6 +714,9 @@ static ssize_t dax_dev_resize(struct dax_region *dax_region,
 	resource_size_t region_end;
 	int i, rc;
 
+	if (!dax_dev->alive)
+		return -ENXIO;
+
 	if (size == dev_size)
 		return 0;
 	if (size > dev_size && size - dev_size > avail)
@@ -686,6 +796,20 @@ static ssize_t dax_dev_resize(struct dax_region *dax_region,
 		}
 	}
 
+	device_lock(dax_region->dev);
+	if (dev_get_drvdata(dax_region->dev) && dev_size == 0
+			&& &dax_dev->dev == dax_region->seed) {
+		struct dax_dev *seed;
+
+		seed = devm_create_dax_dev(dax_region, NULL, 0);
+		if (IS_ERR(seed))
+			dev_warn(dax_region->dev,
+					"failed to create new region seed\n");
+		else
+			dax_region->seed = &seed->dev;
+	}
+	device_unlock(dax_region->dev);
+
 	return 0;
 }
 
@@ -1001,35 +1125,6 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_mmap,
 };
 
-static void clear_dax_dev_radix(struct dax_dev *dax_dev)
-{
-	struct address_space *mapping = dax_dev->inode->i_mapping;
-	struct radix_tree_iter iter;
-	void **slot;
-
-	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, 0) {
-		struct resource *res;
-		unsigned long pgoff;
-		unsigned order;
-
-		res = radix_tree_deref_slot(slot);
-		if (unlikely(!res))
-			continue;
-		if (radix_tree_deref_retry(res)) {
-			slot = radix_tree_iter_retry(&iter);
-			continue;
-		}
-
-		foreach_order_pgoff(res, order, pgoff)
-			radix_tree_delete(&mapping->page_tree,
-					to_dev_pgoff(res) + pgoff);
-	}
-	rcu_read_unlock();
-
-	synchronize_rcu();
-}
-
 static void dax_dev_release(struct device *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
@@ -1043,40 +1138,6 @@ static void dax_dev_release(struct device *dev)
 	kfree(dax_dev);
 }
 
-static void unregister_dax_dev(void *dev)
-{
-	struct dax_dev *dax_dev = to_dax_dev(dev);
-	struct dax_region *dax_region = dax_dev->region;
-	struct cdev *cdev = &dax_dev->cdev;
-	int i;
-
-	dev_dbg(dev, "%s\n", __func__);
-
-	/*
-	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
-	 * ensuring that any fault handlers that might have seen
-	 * dax_dev->alive == true, have completed.  Any fault handlers
-	 * that start after synchronize_rcu() has started will abort
-	 * upon seeing dax_dev->alive == false.
-	 */
-	dax_dev->alive = false;
-	synchronize_rcu();
-	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
-
-	mutex_lock(&dax_region->lock);
-	clear_dax_dev_radix(dax_dev);
-	for (i = 0; i < dax_dev->num_resources; i++)
-		__release_region(&dax_region->res, dax_dev->res[i]->start,
-				resource_size(dax_dev->res[i]));
-	if (dax_region->seed == dev)
-		dax_region->seed = NULL;
-	mutex_unlock(&dax_region->lock);
-	atomic_dec(&dax_region->child_count);
-
-	cdev_del(cdev);
-	device_unregister(dev);
-}
-
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		struct resource *res, int count)
 {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
