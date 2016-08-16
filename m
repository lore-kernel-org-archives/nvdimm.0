Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 666491A1E2A
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:43 -0700 (PDT)
Subject: [PATCH 4/7] dax: embed a struct device in dax_dev
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:19 -0700
Message-ID: <147131791986.13727.3628540285165752573.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147131789847.13727.7932192631919982514.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

The kref in dax_dev can be made redundant if the final put_device() on
the device associated with the dax_dev frees the dax_dev.  This can be
accomplished by embedding a struct device in struct dax_dev, open coding
device_create() and specifying a custom release method.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  130 ++++++++++++++++++-----------------------------------
 1 file changed, 45 insertions(+), 85 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 994dfa507dfb..181d2a5a21e4 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -49,7 +49,6 @@ struct dax_region {
  * struct dax_dev - subdivision of a dax region
  * @region - parent region
  * @dev - device backing the character device
- * @kref - enable this data to be tracked in filp->private_data
  * @alive - !alive + rcu grace period == no new mappings can be established
  * @id - child id in the region
  * @num_resources - number of physical address extents in this device
@@ -57,8 +56,7 @@ struct dax_region {
  */
 struct dax_dev {
 	struct dax_region *region;
-	struct device *dev;
-	struct kref kref;
+	struct device dev;
 	bool alive;
 	int id;
 	int num_resources;
@@ -79,20 +77,6 @@ void dax_region_put(struct dax_region *dax_region)
 }
 EXPORT_SYMBOL_GPL(dax_region_put);
 
-static void dax_dev_free(struct kref *kref)
-{
-	struct dax_dev *dax_dev;
-
-	dax_dev = container_of(kref, struct dax_dev, kref);
-	dax_region_put(dax_dev->region);
-	kfree(dax_dev);
-}
-
-static void dax_dev_put(struct dax_dev *dax_dev)
-{
-	kref_put(&dax_dev->kref, dax_dev_free);
-}
-
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct resource *res, unsigned int align, void *addr,
 		unsigned long pfn_flags)
@@ -117,10 +101,15 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
+static struct dax_dev *to_dax_dev(struct device *dev)
+{
+	return container_of(dev, struct dax_dev, dev);
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dax_dev *dax_dev = dev_get_drvdata(dev);
+	struct dax_dev *dax_dev = to_dax_dev(dev);
 	unsigned long long size = 0;
 	int i;
 
@@ -149,7 +138,7 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		const char *func)
 {
 	struct dax_region *dax_region = dax_dev->region;
-	struct device *dev = dax_dev->dev;
+	struct device *dev = &dax_dev->dev;
 	unsigned long mask;
 
 	if (!dax_dev->alive)
@@ -214,7 +203,7 @@ static int __dax_dev_fault(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
 	unsigned long vaddr = (unsigned long) vmf->virtual_address;
-	struct device *dev = dax_dev->dev;
+	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
 	int rc = VM_FAULT_SIGBUS;
 	phys_addr_t phys;
@@ -254,7 +243,7 @@ static int dax_dev_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
-	dev_dbg(dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
+	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
 			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 	rcu_read_lock();
@@ -269,7 +258,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
 		unsigned int flags)
 {
 	unsigned long pmd_addr = addr & PMD_MASK;
-	struct device *dev = dax_dev->dev;
+	struct device *dev = &dax_dev->dev;
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
@@ -311,7 +300,7 @@ static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	struct file *filp = vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
-	dev_dbg(dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
+	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
 			current->comm, (flags & FAULT_FLAG_WRITE)
 			? "write" : "read", vma->vm_start, vma->vm_end);
 
@@ -322,29 +311,9 @@ static int dax_dev_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	return rc;
 }
 
-static void dax_dev_vm_open(struct vm_area_struct *vma)
-{
-	struct file *filp = vma->vm_file;
-	struct dax_dev *dax_dev = filp->private_data;
-
-	dev_dbg(dax_dev->dev, "%s\n", __func__);
-	kref_get(&dax_dev->kref);
-}
-
-static void dax_dev_vm_close(struct vm_area_struct *vma)
-{
-	struct file *filp = vma->vm_file;
-	struct dax_dev *dax_dev = filp->private_data;
-
-	dev_dbg(dax_dev->dev, "%s\n", __func__);
-	dax_dev_put(dax_dev);
-}
-
 static const struct vm_operations_struct dax_dev_vm_ops = {
 	.fault = dax_dev_fault,
 	.pmd_fault = dax_dev_pmd_fault,
-	.open = dax_dev_vm_open,
-	.close = dax_dev_vm_close,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
@@ -352,13 +321,12 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct dax_dev *dax_dev = filp->private_data;
 	int rc;
 
-	dev_dbg(dax_dev->dev, "%s\n", __func__);
+	dev_dbg(&dax_dev->dev, "%s\n", __func__);
 
 	rc = check_vma(dax_dev, vma, __func__);
 	if (rc)
 		return rc;
 
-	kref_get(&dax_dev->kref);
 	vma->vm_ops = &dax_dev_vm_ops;
 	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	return 0;
@@ -420,30 +388,20 @@ static int dax_open(struct inode *inode, struct file *filp)
 	if (!dev)
 		return -ENXIO;
 
-	device_lock(dev);
-	dax_dev = dev_get_drvdata(dev);
-	if (dax_dev) {
-		dev_dbg(dev, "%s\n", __func__);
-		filp->private_data = dax_dev;
-		kref_get(&dax_dev->kref);
-		inode->i_flags = S_DAX;
-	}
-	device_unlock(dev);
+	dax_dev = to_dax_dev(dev);
+	dev_dbg(dev, "%s\n", __func__);
+	filp->private_data = dax_dev;
+	inode->i_flags = S_DAX;
 
-	if (!dax_dev) {
-		put_device(dev);
-		return -ENXIO;
-	}
 	return 0;
 }
 
 static int dax_release(struct inode *inode, struct file *filp)
 {
 	struct dax_dev *dax_dev = filp->private_data;
-	struct device *dev = dax_dev->dev;
+	struct device *dev = &dax_dev->dev;
 
-	dev_dbg(dax_dev->dev, "%s\n", __func__);
-	dax_dev_put(dax_dev);
+	dev_dbg(dev, "%s\n", __func__);
 	put_device(dev);
 
 	return 0;
@@ -458,12 +416,21 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_mmap,
 };
 
-static void unregister_dax_dev(void *_dev)
+static void dax_dev_release(struct device *dev)
 {
-	struct device *dev = _dev;
-	struct dax_dev *dax_dev = dev_get_drvdata(dev);
+	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct dax_region *dax_region = dax_dev->region;
 
+	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
+	dax_region_put(dax_region);
+	kfree(dax_dev);
+}
+
+static void unregister_dax_dev(void *dev)
+{
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+
 	dev_dbg(dev, "%s\n", __func__);
 
 	/*
@@ -475,13 +442,7 @@ static void unregister_dax_dev(void *_dev)
 	 */
 	dax_dev->alive = false;
 	synchronize_rcu();
-
-	get_device(dev);
 	device_unregister(dev);
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
-	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
-	put_device(dev);
-	dax_dev_put(dax_dev);
 }
 
 int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
@@ -498,7 +459,6 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 		return -ENOMEM;
 	memcpy(dax_dev->res, res, sizeof(*res) * count);
 	dax_dev->num_resources = count;
-	kref_init(&dax_dev->kref);
 	dax_dev->alive = true;
 	dax_dev->region = dax_region;
 	kref_get(&dax_region->kref);
@@ -516,27 +476,27 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	}
 
 	dev_t = MKDEV(dax_major, minor);
-	dev = device_create_with_groups(dax_class, parent, dev_t, dax_dev,
-			dax_attribute_groups, "dax%d.%d", dax_region->id,
-			dax_dev->id);
-	if (IS_ERR(dev)) {
-		rc = PTR_ERR(dev);
-		goto err_create;
-	}
-	dax_dev->dev = dev;
 
-	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
-	if (rc)
+	dev = &dax_dev->dev;
+	device_initialize(dev);
+	dev->devt = dev_t;
+	dev->class = dax_class;
+	dev->parent = parent;
+	dev->groups = dax_attribute_groups;
+	dev->release = dax_dev_release;
+	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
+	rc = device_add(dev);
+	if (rc) {
+		put_device(dev);
 		return rc;
+	}
 
-	return 0;
+	return devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
 
- err_create:
-	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
  err_id:
-	dax_dev_put(dax_dev);
+	kfree(dax_dev);
 
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
