Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 1083C1A1E1D
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:33 -0700 (PDT)
Subject: [PATCH 2/7] dax: reorder dax_fops function definitions
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:09 -0700
Message-ID: <147131790935.13727.18064908681969396327.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In order to convert devm_create_dax_dev() to use cdev, it will need
access to dax_fops. Move dax_fops and related function definitions
before devm_create_dax_dev().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |  337 ++++++++++++++++++++++++++---------------------------
 1 file changed, 168 insertions(+), 169 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 736c03830fd0..3774fc9709bb 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -145,175 +145,6 @@ static const struct attribute_group *dax_attribute_groups[] = {
 	NULL,
 };
 
-static void unregister_dax_dev(void *_dev)
-{
-	struct device *dev = _dev;
-	struct dax_dev *dax_dev = dev_get_drvdata(dev);
-	struct dax_region *dax_region = dax_dev->region;
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
-
-	get_device(dev);
-	device_unregister(dev);
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
-	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
-	put_device(dev);
-	dax_dev_put(dax_dev);
-}
-
-int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
-		int count)
-{
-	struct device *parent = dax_region->dev;
-	struct dax_dev *dax_dev;
-	struct device *dev;
-	int rc, minor;
-	dev_t dev_t;
-
-	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
-	if (!dax_dev)
-		return -ENOMEM;
-	memcpy(dax_dev->res, res, sizeof(*res) * count);
-	dax_dev->num_resources = count;
-	kref_init(&dax_dev->kref);
-	dax_dev->alive = true;
-	dax_dev->region = dax_region;
-	kref_get(&dax_region->kref);
-
-	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
-	if (dax_dev->id < 0) {
-		rc = dax_dev->id;
-		goto err_id;
-	}
-
-	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
-	if (minor < 0) {
-		rc = minor;
-		goto err_minor;
-	}
-
-	dev_t = MKDEV(dax_major, minor);
-	dev = device_create_with_groups(dax_class, parent, dev_t, dax_dev,
-			dax_attribute_groups, "dax%d.%d", dax_region->id,
-			dax_dev->id);
-	if (IS_ERR(dev)) {
-		rc = PTR_ERR(dev);
-		goto err_create;
-	}
-	dax_dev->dev = dev;
-
-	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
-	if (rc)
-		return rc;
-
-	return 0;
-
- err_create:
-	ida_simple_remove(&dax_minor_ida, minor);
- err_minor:
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
- err_id:
-	dax_dev_put(dax_dev);
-
-	return rc;
-}
-EXPORT_SYMBOL_GPL(devm_create_dax_dev);
-
-/* return an unmapped area aligned to the dax region specified alignment */
-static unsigned long dax_dev_get_unmapped_area(struct file *filp,
-		unsigned long addr, unsigned long len, unsigned long pgoff,
-		unsigned long flags)
-{
-	unsigned long off, off_end, off_align, len_align, addr_align, align;
-	struct dax_dev *dax_dev = filp ? filp->private_data : NULL;
-	struct dax_region *dax_region;
-
-	if (!dax_dev || addr)
-		goto out;
-
-	dax_region = dax_dev->region;
-	align = dax_region->align;
-	off = pgoff << PAGE_SHIFT;
-	off_end = off + len;
-	off_align = round_up(off, align);
-
-	if ((off_end <= off_align) || ((off_end - off_align) < align))
-		goto out;
-
-	len_align = len + align;
-	if ((off + len_align) < off)
-		goto out;
-
-	addr_align = current->mm->get_unmapped_area(filp, addr, len_align,
-			pgoff, flags);
-	if (!IS_ERR_VALUE(addr_align)) {
-		addr_align += (off - addr_align) & (align - 1);
-		return addr_align;
-	}
- out:
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
-}
-
-static int __match_devt(struct device *dev, const void *data)
-{
-	const dev_t *devt = data;
-
-	return dev->devt == *devt;
-}
-
-static struct device *dax_dev_find(dev_t dev_t)
-{
-	return class_find_device(dax_class, NULL, &dev_t, __match_devt);
-}
-
-static int dax_dev_open(struct inode *inode, struct file *filp)
-{
-	struct dax_dev *dax_dev = NULL;
-	struct device *dev;
-
-	dev = dax_dev_find(inode->i_rdev);
-	if (!dev)
-		return -ENXIO;
-
-	device_lock(dev);
-	dax_dev = dev_get_drvdata(dev);
-	if (dax_dev) {
-		dev_dbg(dev, "%s\n", __func__);
-		filp->private_data = dax_dev;
-		kref_get(&dax_dev->kref);
-		inode->i_flags = S_DAX;
-	}
-	device_unlock(dev);
-
-	if (!dax_dev) {
-		put_device(dev);
-		return -ENXIO;
-	}
-	return 0;
-}
-
-static int dax_dev_release(struct inode *inode, struct file *filp)
-{
-	struct dax_dev *dax_dev = filp->private_data;
-	struct device *dev = dax_dev->dev;
-
-	dev_dbg(dax_dev->dev, "%s\n", __func__);
-	dax_dev_put(dax_dev);
-	put_device(dev);
-
-	return 0;
-}
-
 static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 		const char *func)
 {
@@ -531,7 +362,91 @@ static int dax_dev_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = &dax_dev_vm_ops;
 	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	return 0;
+}
+
+/* return an unmapped area aligned to the dax region specified alignment */
+static unsigned long dax_dev_get_unmapped_area(struct file *filp,
+		unsigned long addr, unsigned long len, unsigned long pgoff,
+		unsigned long flags)
+{
+	unsigned long off, off_end, off_align, len_align, addr_align, align;
+	struct dax_dev *dax_dev = filp ? filp->private_data : NULL;
+	struct dax_region *dax_region;
+
+	if (!dax_dev || addr)
+		goto out;
+
+	dax_region = dax_dev->region;
+	align = dax_region->align;
+	off = pgoff << PAGE_SHIFT;
+	off_end = off + len;
+	off_align = round_up(off, align);
+
+	if ((off_end <= off_align) || ((off_end - off_align) < align))
+		goto out;
+
+	len_align = len + align;
+	if ((off + len_align) < off)
+		goto out;
+
+	addr_align = current->mm->get_unmapped_area(filp, addr, len_align,
+			pgoff, flags);
+	if (!IS_ERR_VALUE(addr_align)) {
+		addr_align += (off - addr_align) & (align - 1);
+		return addr_align;
+	}
+ out:
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+
+static int __match_devt(struct device *dev, const void *data)
+{
+	const dev_t *devt = data;
+
+	return dev->devt == *devt;
+}
+
+static struct device *dax_dev_find(dev_t dev_t)
+{
+	return class_find_device(dax_class, NULL, &dev_t, __match_devt);
+}
+
+static int dax_dev_open(struct inode *inode, struct file *filp)
+{
+	struct dax_dev *dax_dev = NULL;
+	struct device *dev;
+
+	dev = dax_dev_find(inode->i_rdev);
+	if (!dev)
+		return -ENXIO;
+
+	device_lock(dev);
+	dax_dev = dev_get_drvdata(dev);
+	if (dax_dev) {
+		dev_dbg(dev, "%s\n", __func__);
+		filp->private_data = dax_dev;
+		kref_get(&dax_dev->kref);
+		inode->i_flags = S_DAX;
+	}
+	device_unlock(dev);
+
+	if (!dax_dev) {
+		put_device(dev);
+		return -ENXIO;
+	}
+	return 0;
+}
 
+static int dax_dev_release(struct inode *inode, struct file *filp)
+{
+	struct dax_dev *dax_dev = filp->private_data;
+	struct device *dev = dax_dev->dev;
+
+	dev_dbg(dax_dev->dev, "%s\n", __func__);
+	dax_dev_put(dax_dev);
+	put_device(dev);
+
+	return 0;
 }
 
 static const struct file_operations dax_fops = {
@@ -543,6 +458,90 @@ static const struct file_operations dax_fops = {
 	.mmap = dax_dev_mmap,
 };
 
+static void unregister_dax_dev(void *_dev)
+{
+	struct device *dev = _dev;
+	struct dax_dev *dax_dev = dev_get_drvdata(dev);
+	struct dax_region *dax_region = dax_dev->region;
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
+
+	get_device(dev);
+	device_unregister(dev);
+	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
+	put_device(dev);
+	dax_dev_put(dax_dev);
+}
+
+int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
+		int count)
+{
+	struct device *parent = dax_region->dev;
+	struct dax_dev *dax_dev;
+	struct device *dev;
+	int rc, minor;
+	dev_t dev_t;
+
+	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
+	if (!dax_dev)
+		return -ENOMEM;
+	memcpy(dax_dev->res, res, sizeof(*res) * count);
+	dax_dev->num_resources = count;
+	kref_init(&dax_dev->kref);
+	dax_dev->alive = true;
+	dax_dev->region = dax_region;
+	kref_get(&dax_region->kref);
+
+	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
+	if (dax_dev->id < 0) {
+		rc = dax_dev->id;
+		goto err_id;
+	}
+
+	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
+	if (minor < 0) {
+		rc = minor;
+		goto err_minor;
+	}
+
+	dev_t = MKDEV(dax_major, minor);
+	dev = device_create_with_groups(dax_class, parent, dev_t, dax_dev,
+			dax_attribute_groups, "dax%d.%d", dax_region->id,
+			dax_dev->id);
+	if (IS_ERR(dev)) {
+		rc = PTR_ERR(dev);
+		goto err_create;
+	}
+	dax_dev->dev = dev;
+
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
+	if (rc)
+		return rc;
+
+	return 0;
+
+ err_create:
+	ida_simple_remove(&dax_minor_ida, minor);
+ err_minor:
+	ida_simple_remove(&dax_region->ida, dax_dev->id);
+ err_id:
+	dax_dev_put(dax_dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_create_dax_dev);
+
 static int __init dax_init(void)
 {
 	int rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
