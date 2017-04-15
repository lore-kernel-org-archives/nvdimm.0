Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7EA332194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:38:58 -0700 (PDT)
Subject: [PATCH v2 01/33] device-dax: rename 'dax_dev' to 'dev_dax'
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:33:14 -0700
Message-ID: <149222359411.32363.1086472729408337671.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for introducing a struct dax_device type to the kernel
global type namespace, rename dax_dev to dev_dax. A 'dax_device'
instance will be a generic device-driver object for any provider of dax
functionality. A 'dev_dax' object is a device-dax-driver local /
internal instance.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |  206 ++++++++++++++++++++++++++--------------------------
 drivers/dax/dax.h  |    4 +
 drivers/dax/pmem.c |    8 +-
 3 files changed, 109 insertions(+), 109 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 352cc54056ce..376fdd353aea 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -57,7 +57,7 @@ struct dax_region {
 };
 
 /**
- * struct dax_dev - subdivision of a dax region
+ * struct dev_dax - instance data for a subdivision of a dax region
  * @region - parent region
  * @dev - device backing the character device
  * @cdev - core chardev data
@@ -66,7 +66,7 @@ struct dax_region {
  * @num_resources - number of physical address extents in this device
  * @res - array of physical address ranges
  */
-struct dax_dev {
+struct dev_dax {
 	struct dax_region *region;
 	struct inode *inode;
 	struct device dev;
@@ -323,47 +323,47 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
-static struct dax_dev *to_dax_dev(struct device *dev)
+static struct dev_dax *to_dev_dax(struct device *dev)
 {
-	return container_of(dev, struct dax_dev, dev);
+	return container_of(dev, struct dev_dax, dev);
 }
 
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dev_dax *dev_dax = to_dev_dax(dev);
 	unsigned long long size = 0;
 	int i;
 
-	for (i = 0; i < dax_dev->num_resources; i++)
-		size += resource_size(&dax_dev->res[i]);
+	for (i = 0; i < dev_dax->num_resources; i++)
+		size += resource_size(&dev_dax->res[i]);
 
 	return sprintf(buf, "%llu\n", size);
 }
 static DEVICE_ATTR_RO(size);
 
-static struct attribute *dax_device_attributes[] = {
+static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_size.attr,
 	NULL,
 };
 
-static const struct attribute_group dax_device_attribute_group = {
-	.attrs = dax_device_attributes,
+static const struct attribute_group dev_dax_attribute_group = {
+	.attrs = dev_dax_attributes,
 };
 
 static const struct attribute_group *dax_attribute_groups[] = {
-	&dax_device_attribute_group,
+	&dev_dax_attribute_group,
 	NULL,
 };
 
-static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
+static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 		const char *func)
 {
-	struct dax_region *dax_region = dax_dev->region;
-	struct device *dev = &dax_dev->dev;
+	struct dax_region *dax_region = dev_dax->region;
+	struct device *dev = &dev_dax->dev;
 	unsigned long mask;
 
-	if (!dax_dev->alive)
+	if (!dev_dax->alive)
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
@@ -397,23 +397,23 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	return 0;
 }
 
-static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
+static phys_addr_t pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		unsigned long size)
 {
 	struct resource *res;
 	phys_addr_t phys;
 	int i;
 
-	for (i = 0; i < dax_dev->num_resources; i++) {
-		res = &dax_dev->res[i];
+	for (i = 0; i < dev_dax->num_resources; i++) {
+		res = &dev_dax->res[i];
 		phys = pgoff * PAGE_SIZE + res->start;
 		if (phys >= res->start && phys <= res->end)
 			break;
 		pgoff -= PHYS_PFN(resource_size(res));
 	}
 
-	if (i < dax_dev->num_resources) {
-		res = &dax_dev->res[i];
+	if (i < dev_dax->num_resources) {
+		res = &dev_dax->res[i];
 		if (phys + size - 1 <= res->end)
 			return phys;
 	}
@@ -421,19 +421,19 @@ static phys_addr_t pgoff_to_phys(struct dax_dev *dax_dev, pgoff_t pgoff,
 	return -1;
 }
 
-static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 {
-	struct device *dev = &dax_dev->dev;
+	struct device *dev = &dev_dax->dev;
 	struct dax_region *dax_region;
 	int rc = VM_FAULT_SIGBUS;
 	phys_addr_t phys;
 	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
-	if (check_vma(dax_dev, vmf->vma, __func__))
+	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dax_dev->region;
+	dax_region = dev_dax->region;
 	if (dax_region->align > PAGE_SIZE) {
 		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
 			__func__, dax_region->align, fault_size);
@@ -443,7 +443,7 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	if (fault_size != dax_region->align)
 		return VM_FAULT_SIGBUS;
 
-	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
+	phys = pgoff_to_phys(dev_dax, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				vmf->pgoff);
@@ -462,20 +462,20 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	return VM_FAULT_NOPAGE;
 }
 
-static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
-	struct device *dev = &dax_dev->dev;
+	struct device *dev = &dev_dax->dev;
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
 	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
-	if (check_vma(dax_dev, vmf->vma, __func__))
+	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dax_dev->region;
+	dax_region = dev_dax->region;
 	if (dax_region->align > PMD_SIZE) {
 		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
 			__func__, dax_region->align, fault_size);
@@ -499,7 +499,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	pgoff = linear_page_index(vmf->vma, pmd_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
+	phys = pgoff_to_phys(dev_dax, pgoff, PMD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
@@ -513,10 +513,10 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 {
 	unsigned long pud_addr = vmf->address & PUD_MASK;
-	struct device *dev = &dax_dev->dev;
+	struct device *dev = &dev_dax->dev;
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
@@ -524,10 +524,10 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	unsigned int fault_size = PUD_SIZE;
 
 
-	if (check_vma(dax_dev, vmf->vma, __func__))
+	if (check_vma(dev_dax, vmf->vma, __func__))
 		return VM_FAULT_SIGBUS;
 
-	dax_region = dax_dev->region;
+	dax_region = dev_dax->region;
 	if (dax_region->align > PUD_SIZE) {
 		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
 			__func__, dax_region->align, fault_size);
@@ -551,7 +551,7 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 		return VM_FAULT_SIGBUS;
 
 	pgoff = linear_page_index(vmf->vma, pud_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
+	phys = pgoff_to_phys(dev_dax, pgoff, PUD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
@@ -564,20 +564,20 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 			vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
-static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
+static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 {
 	return VM_FAULT_FALLBACK;
 }
 #endif /* !CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
-static int dax_dev_huge_fault(struct vm_fault *vmf,
+static int dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
 	int rc, id;
 	struct file *filp = vmf->vma->vm_file;
-	struct dax_dev *dax_dev = filp->private_data;
+	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx) size = %d\n", __func__,
+	dev_dbg(&dev_dax->dev, "%s: %s: %s (%#lx - %#lx) size = %d\n", __func__,
 			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read",
 			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
@@ -585,13 +585,13 @@ static int dax_dev_huge_fault(struct vm_fault *vmf,
 	id = srcu_read_lock(&dax_srcu);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		rc = __dax_dev_pte_fault(dax_dev, vmf);
+		rc = __dev_dax_pte_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PMD:
-		rc = __dax_dev_pmd_fault(dax_dev, vmf);
+		rc = __dev_dax_pmd_fault(dev_dax, vmf);
 		break;
 	case PE_SIZE_PUD:
-		rc = __dax_dev_pud_fault(dax_dev, vmf);
+		rc = __dev_dax_pud_fault(dev_dax, vmf);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
@@ -601,28 +601,28 @@ static int dax_dev_huge_fault(struct vm_fault *vmf,
 	return rc;
 }
 
-static int dax_dev_fault(struct vm_fault *vmf)
+static int dev_dax_fault(struct vm_fault *vmf)
 {
-	return dax_dev_huge_fault(vmf, PE_SIZE_PTE);
+	return dev_dax_huge_fault(vmf, PE_SIZE_PTE);
 }
 
-static const struct vm_operations_struct dax_dev_vm_ops = {
-	.fault = dax_dev_fault,
-	.huge_fault = dax_dev_huge_fault,
+static const struct vm_operations_struct dax_vm_ops = {
+	.fault = dev_dax_fault,
+	.huge_fault = dev_dax_huge_fault,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 {
-	struct dax_dev *dax_dev = filp->private_data;
+	struct dev_dax *dev_dax = filp->private_data;
 	int rc;
 
-	dev_dbg(&dax_dev->dev, "%s\n", __func__);
+	dev_dbg(&dev_dax->dev, "%s\n", __func__);
 
-	rc = check_vma(dax_dev, vma, __func__);
+	rc = check_vma(dev_dax, vma, __func__);
 	if (rc)
 		return rc;
 
-	vma->vm_ops = &dax_dev_vm_ops;
+	vma->vm_ops = &dax_vm_ops;
 	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	return 0;
 }
@@ -633,13 +633,13 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 		unsigned long flags)
 {
 	unsigned long off, off_end, off_align, len_align, addr_align, align;
-	struct dax_dev *dax_dev = filp ? filp->private_data : NULL;
+	struct dev_dax *dev_dax = filp ? filp->private_data : NULL;
 	struct dax_region *dax_region;
 
-	if (!dax_dev || addr)
+	if (!dev_dax || addr)
 		goto out;
 
-	dax_region = dax_dev->region;
+	dax_region = dev_dax->region;
 	align = dax_region->align;
 	off = pgoff << PAGE_SHIFT;
 	off_end = off + len;
@@ -664,14 +664,14 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 
 static int dax_open(struct inode *inode, struct file *filp)
 {
-	struct dax_dev *dax_dev;
+	struct dev_dax *dev_dax;
 
-	dax_dev = container_of(inode->i_cdev, struct dax_dev, cdev);
-	dev_dbg(&dax_dev->dev, "%s\n", __func__);
-	inode->i_mapping = dax_dev->inode->i_mapping;
-	inode->i_mapping->host = dax_dev->inode;
+	dev_dax = container_of(inode->i_cdev, struct dev_dax, cdev);
+	dev_dbg(&dev_dax->dev, "%s\n", __func__);
+	inode->i_mapping = dev_dax->inode->i_mapping;
+	inode->i_mapping->host = dev_dax->inode;
 	filp->f_mapping = inode->i_mapping;
-	filp->private_data = dax_dev;
+	filp->private_data = dev_dax;
 	inode->i_flags = S_DAX;
 
 	return 0;
@@ -679,9 +679,9 @@ static int dax_open(struct inode *inode, struct file *filp)
 
 static int dax_release(struct inode *inode, struct file *filp)
 {
-	struct dax_dev *dax_dev = filp->private_data;
+	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dax_dev->dev, "%s\n", __func__);
+	dev_dbg(&dev_dax->dev, "%s\n", __func__);
 	return 0;
 }
 
@@ -694,55 +694,55 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_mmap,
 };
 
-static void dax_dev_release(struct device *dev)
+static void dev_dax_release(struct device *dev)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
-	struct dax_region *dax_region = dax_dev->region;
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
 
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	ida_simple_remove(&dax_region->ida, dev_dax->id);
 	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
-	iput(dax_dev->inode);
-	kfree(dax_dev);
+	iput(dev_dax->inode);
+	kfree(dev_dax);
 }
 
-static void kill_dax_dev(struct dax_dev *dax_dev)
+static void kill_dev_dax(struct dev_dax *dev_dax)
 {
 	/*
-	 * Note, rcu is not protecting the liveness of dax_dev, rcu is
+	 * Note, rcu is not protecting the liveness of dev_dax, rcu is
 	 * ensuring that any fault handlers that might have seen
-	 * dax_dev->alive == true, have completed.  Any fault handlers
+	 * dev_dax->alive == true, have completed.  Any fault handlers
 	 * that start after synchronize_srcu() has started will abort
-	 * upon seeing dax_dev->alive == false.
+	 * upon seeing dev_dax->alive == false.
 	 */
-	dax_dev->alive = false;
+	dev_dax->alive = false;
 	synchronize_srcu(&dax_srcu);
-	unmap_mapping_range(dax_dev->inode->i_mapping, 0, 0, 1);
+	unmap_mapping_range(dev_dax->inode->i_mapping, 0, 0, 1);
 }
 
-static void unregister_dax_dev(void *dev)
+static void unregister_dev_dax(void *dev)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dev_dax *dev_dax = to_dev_dax(dev);
 
 	dev_dbg(dev, "%s\n", __func__);
 
-	kill_dax_dev(dax_dev);
-	cdev_device_del(&dax_dev->cdev, dev);
+	kill_dev_dax(dev_dax);
+	cdev_device_del(&dev_dax->cdev, dev);
 	put_device(dev);
 }
 
-struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
+struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
-	struct dax_dev *dax_dev;
+	struct dev_dax *dev_dax;
 	int rc = 0, minor, i;
 	struct device *dev;
 	struct cdev *cdev;
 	dev_t dev_t;
 
-	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
-	if (!dax_dev)
+	dev_dax = kzalloc(sizeof(*dev_dax) + sizeof(*res) * count, GFP_KERNEL);
+	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
 
 	for (i = 0; i < count; i++) {
@@ -752,16 +752,16 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 			rc = -EINVAL;
 			break;
 		}
-		dax_dev->res[i].start = res[i].start;
-		dax_dev->res[i].end = res[i].end;
+		dev_dax->res[i].start = res[i].start;
+		dev_dax->res[i].end = res[i].end;
 	}
 
 	if (i < count)
 		goto err_id;
 
-	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
-	if (dax_dev->id < 0) {
-		rc = dax_dev->id;
+	dev_dax->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
+	if (dev_dax->id < 0) {
+		rc = dev_dax->id;
 		goto err_id;
 	}
 
@@ -772,55 +772,55 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	}
 
 	dev_t = MKDEV(MAJOR(dax_devt), minor);
-	dev = &dax_dev->dev;
-	dax_dev->inode = dax_inode_get(&dax_dev->cdev, dev_t);
-	if (!dax_dev->inode) {
+	dev = &dev_dax->dev;
+	dev_dax->inode = dax_inode_get(&dev_dax->cdev, dev_t);
+	if (!dev_dax->inode) {
 		rc = -ENOMEM;
 		goto err_inode;
 	}
 
-	/* from here on we're committed to teardown via dax_dev_release() */
+	/* from here on we're committed to teardown via dev_dax_release() */
 	device_initialize(dev);
 
-	cdev = &dax_dev->cdev;
+	cdev = &dev_dax->cdev;
 	cdev_init(cdev, &dax_fops);
 	cdev->owner = parent->driver->owner;
 
-	dax_dev->num_resources = count;
-	dax_dev->alive = true;
-	dax_dev->region = dax_region;
+	dev_dax->num_resources = count;
+	dev_dax->alive = true;
+	dev_dax->region = dax_region;
 	kref_get(&dax_region->kref);
 
 	dev->devt = dev_t;
 	dev->class = dax_class;
 	dev->parent = parent;
 	dev->groups = dax_attribute_groups;
-	dev->release = dax_dev_release;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
+	dev->release = dev_dax_release;
+	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
 	rc = cdev_device_add(cdev, dev);
 	if (rc) {
-		kill_dax_dev(dax_dev);
+		kill_dev_dax(dev_dax);
 		put_device(dev);
 		return ERR_PTR(rc);
 	}
 
-	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dev_dax, dev);
 	if (rc)
 		return ERR_PTR(rc);
 
-	return dax_dev;
+	return dev_dax;
 
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	ida_simple_remove(&dax_region->ida, dev_dax->id);
  err_id:
-	kfree(dax_dev);
+	kfree(dev_dax);
 
 	return ERR_PTR(rc);
 }
-EXPORT_SYMBOL_GPL(devm_create_dax_dev);
+EXPORT_SYMBOL_GPL(devm_create_dev_dax);
 
 static int __init dax_init(void)
 {
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index ddd829ab58c0..ea176d875d60 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,13 +13,13 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct device;
-struct dax_dev;
+struct dev_dax;
 struct resource;
 struct dax_region;
 void dax_region_put(struct dax_region *dax_region);
 struct dax_region *alloc_dax_region(struct device *parent,
 		int region_id, struct resource *res, unsigned int align,
 		void *addr, unsigned long flags);
-struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
+struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		struct resource *res, int count);
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 033f49b31fdc..2c736fc4508b 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -61,8 +61,8 @@ static int dax_pmem_probe(struct device *dev)
 	int rc;
 	void *addr;
 	struct resource res;
-	struct dax_dev *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
+	struct dev_dax *dev_dax;
 	struct dax_pmem *dax_pmem;
 	struct nd_region *nd_region;
 	struct nd_namespace_io *nsio;
@@ -130,12 +130,12 @@ static int dax_pmem_probe(struct device *dev)
 		return -ENOMEM;
 
 	/* TODO: support for subdividing a dax region... */
-	dax_dev = devm_create_dax_dev(dax_region, &res, 1);
+	dev_dax = devm_create_dev_dax(dax_region, &res, 1);
 
-	/* child dax_dev instances now own the lifetime of the dax_region */
+	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
 
-	return PTR_ERR_OR_ZERO(dax_dev);
+	return PTR_ERR_OR_ZERO(dev_dax);
 }
 
 static struct nd_device_driver dax_pmem_driver = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
