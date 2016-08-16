Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id A2F671A1E1B
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:48 -0700 (PDT)
Subject: [PATCH 5/7] dax: convert to the cdev api
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:25 -0700
Message-ID: <147131792501.13727.618914864100576994.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

A goal of the device-DAX interface is to be able to support many
exclusive allocations (partitions) of performance / feature
differentiated memory.  This count may exceed the default minors limit
of 256.

As a result of switching to an embedded cdev the inode-to-dax_dev
conversion is simplified, as well as reference counting which can switch
to the cdev kobject lifetime.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/Kconfig |    5 +++
 drivers/dax/dax.c   |   82 ++++++++++++++++++++++++++-------------------------
 2 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index cedab7572de3..daadd20aa936 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -23,4 +23,9 @@ config DEV_DAX_PMEM
 
 	  Say Y if unsure
 
+config NR_DEV_DAX
+	int "Maximum number of Device-DAX instances"
+	default 32768
+	range 256 2147483647
+
 endif
diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 181d2a5a21e4..17715773c097 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -14,15 +14,19 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/pfn_t.h>
+#include <linux/cdev.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "dax.h"
 
-static int dax_major;
+static dev_t dax_devt;
 static struct class *dax_class;
 static DEFINE_IDA(dax_minor_ida);
+static int nr_dax = CONFIG_NR_DEV_DAX;
+module_param(nr_dax, int, S_IRUGO);
+MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
 
 /**
  * struct dax_region - mapping infrastructure for dax devices
@@ -49,6 +53,7 @@ struct dax_region {
  * struct dax_dev - subdivision of a dax region
  * @region - parent region
  * @dev - device backing the character device
+ * @cdev - core chardev data
  * @alive - !alive + rcu grace period == no new mappings can be established
  * @id - child id in the region
  * @num_resources - number of physical address extents in this device
@@ -57,6 +62,7 @@ struct dax_region {
 struct dax_dev {
 	struct dax_region *region;
 	struct device dev;
+	struct cdev cdev;
 	bool alive;
 	int id;
 	int num_resources;
@@ -367,29 +373,12 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
 
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
 static int dax_open(struct inode *inode, struct file *filp)
 {
-	struct dax_dev *dax_dev = NULL;
-	struct device *dev;
-
-	dev = dax_dev_find(inode->i_rdev);
-	if (!dev)
-		return -ENXIO;
+	struct dax_dev *dax_dev;
 
-	dax_dev = to_dax_dev(dev);
-	dev_dbg(dev, "%s\n", __func__);
+	dax_dev = container_of(inode->i_cdev, struct dax_dev, cdev);
+	dev_dbg(&dax_dev->dev, "%s\n", __func__);
 	filp->private_data = dax_dev;
 	inode->i_flags = S_DAX;
 
@@ -399,11 +388,8 @@ static int dax_open(struct inode *inode, struct file *filp)
 static int dax_release(struct inode *inode, struct file *filp)
 {
 	struct dax_dev *dax_dev = filp->private_data;
-	struct device *dev = &dax_dev->dev;
-
-	dev_dbg(dev, "%s\n", __func__);
-	put_device(dev);
 
+	dev_dbg(&dax_dev->dev, "%s\n", __func__);
 	return 0;
 }
 
@@ -430,6 +416,7 @@ static void dax_dev_release(struct device *dev)
 static void unregister_dax_dev(void *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct cdev *cdev = &dax_dev->cdev;
 
 	dev_dbg(dev, "%s\n", __func__);
 
@@ -442,6 +429,7 @@ static void unregister_dax_dev(void *dev)
 	 */
 	dax_dev->alive = false;
 	synchronize_rcu();
+	cdev_del(cdev);
 	device_unregister(dev);
 }
 
@@ -451,17 +439,13 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
 	struct device *dev;
+	struct cdev *cdev;
 	int rc, minor;
 	dev_t dev_t;
 
 	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
 	if (!dax_dev)
 		return -ENOMEM;
-	memcpy(dax_dev->res, res, sizeof(*res) * count);
-	dax_dev->num_resources = count;
-	dax_dev->alive = true;
-	dax_dev->region = dax_region;
-	kref_get(&dax_region->kref);
 
 	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
 	if (dax_dev->id < 0) {
@@ -475,10 +459,26 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 		goto err_minor;
 	}
 
-	dev_t = MKDEV(dax_major, minor);
-
+	/* device_initialize() so cdev can reference kobj parent */
+	dev_t = MKDEV(MAJOR(dax_devt), minor);
 	dev = &dax_dev->dev;
 	device_initialize(dev);
+
+	cdev = &dax_dev->cdev;
+	cdev_init(cdev, &dax_fops);
+	cdev->owner = parent->driver->owner;
+	cdev->kobj.parent = &dev->kobj;
+	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
+	if (rc)
+		goto err_cdev;
+
+	/* from here on we're committed to teardown via dax_dev_release() */
+	memcpy(dax_dev->res, res, sizeof(*res) * count);
+	dax_dev->num_resources = count;
+	dax_dev->alive = true;
+	dax_dev->region = dax_region;
+	kref_get(&dax_region->kref);
+
 	dev->devt = dev_t;
 	dev->class = dax_class;
 	dev->parent = parent;
@@ -493,6 +493,8 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 
 	return devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
 
+ err_cdev:
+	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
  err_id:
@@ -506,24 +508,22 @@ static int __init dax_init(void)
 {
 	int rc;
 
-	rc = register_chrdev(0, "dax", &dax_fops);
-	if (rc < 0)
+	nr_dax = max(nr_dax, 256);
+	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
+	if (rc)
 		return rc;
-	dax_major = rc;
 
 	dax_class = class_create(THIS_MODULE, "dax");
-	if (IS_ERR(dax_class)) {
-		unregister_chrdev(dax_major, "dax");
-		return PTR_ERR(dax_class);
-	}
+	if (IS_ERR(dax_class))
+		unregister_chrdev_region(dax_devt, nr_dax);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(dax_class);
 }
 
 static void __exit dax_exit(void)
 {
 	class_destroy(dax_class);
-	unregister_chrdev(dax_major, "dax");
+	unregister_chrdev_region(dax_devt, nr_dax);
 	ida_destroy(&dax_minor_ida);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
