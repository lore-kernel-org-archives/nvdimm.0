Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BEEF881FF4
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:15 -0800 (PST)
Subject: [RFC PATCH 01/17] dax: refactor dax-fs into a generic provider of
 dax inodes
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:09 -0800
Message-ID: <148559256970.11180.2541041546993320141.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

We want dax capable drivers to be able to publish a set of dax
operations [1]. However, we do not want to further abuse block_devices
to advertise these operations. Instead we will attach these operations
to a dax inode and add a lookup mechanism to go from block device path
to a dax inode. A dax capable driver like pmem or brd is responsible for
registering a dax inode, alongside a block device, and then a dax
capable filesystem is responsible for retrieving the dax inode by path
name if it wants to call dax_operations.

For now, we refactor the dax pseudo-fs to be a generic facility, rather
than an implementation detail, of the device-dax use case. Where a "dax
inode" is just an inode + dax infrastructure, and "Device DAX" is a
mapping service layered on top of that base inode. "Filesystem DAX" is
then a mapping service that layers a filesystem on top of the base dax
inode. Filesystem DAX goes through a block_device for now, but perhaps
directly to a dax inode in the future, or for new pmem-only filesystems.

[1]: https://lkml.org/lkml/2017/1/19/880

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/Makefile            |    2 
 drivers/dax/Kconfig         |    8 +
 drivers/dax/Makefile        |    5 +
 drivers/dax/dax.h           |   24 ++-
 drivers/dax/device-dax.h    |   25 +++
 drivers/dax/device.c        |  241 +++++----------------------------
 drivers/dax/pmem.c          |    2 
 drivers/dax/super.c         |  310 +++++++++++++++++++++++++++++++++++++++++++
 tools/testing/nvdimm/Kbuild |    6 -
 9 files changed, 402 insertions(+), 221 deletions(-)
 create mode 100644 drivers/dax/device-dax.h
 rename drivers/dax/{dax.c => device.c} (75%)
 create mode 100644 drivers/dax/super.c

diff --git a/drivers/Makefile b/drivers/Makefile
index 060026a02f59..17f42e4a6717 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -68,7 +68,7 @@ obj-$(CONFIG_PARPORT)		+= parport/
 obj-$(CONFIG_NVM)		+= lightnvm/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
 obj-$(CONFIG_LIBNVDIMM)		+= nvdimm/
-obj-$(CONFIG_DEV_DAX)		+= dax/
+obj-$(CONFIG_DAX)		+= dax/
 obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 3e2ab3b14eea..39bcbf4c5e40 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,6 +1,11 @@
-menuconfig DEV_DAX
+menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
 	default m if NVDIMM_DAX
+
+if DAX
+
+config DEV_DAX
+	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
@@ -10,7 +15,6 @@ menuconfig DEV_DAX
 	  baseline memory pool.  Mappings of a /dev/daxX.Y device impose
 	  restrictions that make the mapping behavior deterministic.
 
-if DEV_DAX
 
 config DEV_DAX_PMEM
 	tristate "PMEM DAX: direct access to persistent memory"
diff --git a/drivers/dax/Makefile b/drivers/dax/Makefile
index 27c54e38478a..dc7422530462 100644
--- a/drivers/dax/Makefile
+++ b/drivers/dax/Makefile
@@ -1,4 +1,7 @@
-obj-$(CONFIG_DEV_DAX) += dax.o
+obj-$(CONFIG_DAX) += dax.o
+obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
+dax-y := super.o
 dax_pmem-y := pmem.o
+device_dax-y := device.o
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index ddd829ab58c0..def061aa75f4 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -12,14 +12,16 @@
  */
 #ifndef __DAX_H__
 #define __DAX_H__
-struct device;
-struct dax_dev;
-struct resource;
-struct dax_region;
-void dax_region_put(struct dax_region *dax_region);
-struct dax_region *alloc_dax_region(struct device *parent,
-		int region_id, struct resource *res, unsigned int align,
-		void *addr, unsigned long flags);
-struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
-		struct resource *res, int count);
+struct dax_inode;
+struct dax_inode *alloc_dax_inode(void *private);
+void put_dax_inode(struct dax_inode *dax_inode);
+bool dax_inode_alive(struct dax_inode *dax_inode);
+void kill_dax_inode(struct dax_inode *dax_inode);
+struct dax_inode *inode_to_dax_inode(struct inode *inode);
+struct inode *dax_inode_to_inode(struct dax_inode *dax_inode);
+void *dax_inode_get_private(struct dax_inode *dax_inode);
+int dax_inode_register(struct dax_inode *dax_inode,
+		const struct file_operations *fops, struct module *owner,
+		struct kobject *parent);
+void dax_inode_unregister(struct dax_inode *dax_inode);
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
new file mode 100644
index 000000000000..c9b7e9cc227e
--- /dev/null
+++ b/drivers/dax/device-dax.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __DEVICE_DAX_H__
+#define __DEVICE_DAX_H__
+struct device;
+struct dax_dev;
+struct resource;
+struct dax_region;
+void dax_region_put(struct dax_region *dax_region);
+struct dax_region *alloc_dax_region(struct device *parent,
+		int region_id, struct resource *res, unsigned int align,
+		void *addr, unsigned long flags);
+struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
+		struct resource *res, int count);
+#endif /* __DEVICE_DAX_H__ */
diff --git a/drivers/dax/dax.c b/drivers/dax/device.c
similarity index 75%
rename from drivers/dax/dax.c
rename to drivers/dax/device.c
index ed758b74ddf0..5b5572314929 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/device.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -13,25 +13,14 @@
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/mount.h>
 #include <linux/pfn_t.h>
-#include <linux/hash.h>
-#include <linux/cdev.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "dax.h"
 
-static dev_t dax_devt;
 static struct class *dax_class;
-static DEFINE_IDA(dax_minor_ida);
-static int nr_dax = CONFIG_NR_DEV_DAX;
-module_param(nr_dax, int, S_IRUGO);
-static struct vfsmount *dax_mnt;
-static struct kmem_cache *dax_cache __read_mostly;
-static struct super_block *dax_superblock __read_mostly;
-MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
 
 /**
  * struct dax_region - mapping infrastructure for dax devices
@@ -57,19 +46,16 @@ struct dax_region {
 /**
  * struct dax_dev - subdivision of a dax region
  * @region - parent region
- * @dev - device backing the character device
- * @cdev - core chardev data
- * @alive - !alive + rcu grace period == no new mappings can be established
+ * @dax_inode - core dax functionality
+ * @dev - device core
  * @id - child id in the region
  * @num_resources - number of physical address extents in this device
  * @res - array of physical address ranges
  */
 struct dax_dev {
 	struct dax_region *region;
-	struct inode *inode;
+	struct dax_inode *dax_inode;
 	struct device dev;
-	struct cdev cdev;
-	bool alive;
 	int id;
 	int num_resources;
 	struct resource res[0];
@@ -142,117 +128,6 @@ static const struct attribute_group *dax_region_attribute_groups[] = {
 	NULL,
 };
 
-static struct inode *dax_alloc_inode(struct super_block *sb)
-{
-	return kmem_cache_alloc(dax_cache, GFP_KERNEL);
-}
-
-static void dax_i_callback(struct rcu_head *head)
-{
-	struct inode *inode = container_of(head, struct inode, i_rcu);
-
-	kmem_cache_free(dax_cache, inode);
-}
-
-static void dax_destroy_inode(struct inode *inode)
-{
-	call_rcu(&inode->i_rcu, dax_i_callback);
-}
-
-static const struct super_operations dax_sops = {
-	.statfs = simple_statfs,
-	.alloc_inode = dax_alloc_inode,
-	.destroy_inode = dax_destroy_inode,
-	.drop_inode = generic_delete_inode,
-};
-
-static struct dentry *dax_mount(struct file_system_type *fs_type,
-		int flags, const char *dev_name, void *data)
-{
-	return mount_pseudo(fs_type, "dax:", &dax_sops, NULL, DAXFS_MAGIC);
-}
-
-static struct file_system_type dax_type = {
-	.name = "dax",
-	.mount = dax_mount,
-	.kill_sb = kill_anon_super,
-};
-
-static int dax_test(struct inode *inode, void *data)
-{
-	return inode->i_cdev == data;
-}
-
-static int dax_set(struct inode *inode, void *data)
-{
-	inode->i_cdev = data;
-	return 0;
-}
-
-static struct inode *dax_inode_get(struct cdev *cdev, dev_t devt)
-{
-	struct inode *inode;
-
-	inode = iget5_locked(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
-			dax_test, dax_set, cdev);
-
-	if (!inode)
-		return NULL;
-
-	if (inode->i_state & I_NEW) {
-		inode->i_mode = S_IFCHR;
-		inode->i_flags = S_DAX;
-		inode->i_rdev = devt;
-		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
-		unlock_new_inode(inode);
-	}
-	return inode;
-}
-
-static void init_once(void *inode)
-{
-	inode_init_once(inode);
-}
-
-static int dax_inode_init(void)
-{
-	int rc;
-
-	dax_cache = kmem_cache_create("dax_cache", sizeof(struct inode), 0,
-			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
-			 SLAB_MEM_SPREAD|SLAB_ACCOUNT),
-			init_once);
-	if (!dax_cache)
-		return -ENOMEM;
-
-	rc = register_filesystem(&dax_type);
-	if (rc)
-		goto err_register_fs;
-
-	dax_mnt = kern_mount(&dax_type);
-	if (IS_ERR(dax_mnt)) {
-		rc = PTR_ERR(dax_mnt);
-		goto err_mount;
-	}
-	dax_superblock = dax_mnt->mnt_sb;
-
-	return 0;
-
- err_mount:
-	unregister_filesystem(&dax_type);
- err_register_fs:
-	kmem_cache_destroy(dax_cache);
-
-	return rc;
-}
-
-static void dax_inode_exit(void)
-{
-	kern_unmount(dax_mnt);
-	unregister_filesystem(&dax_type);
-	kmem_cache_destroy(dax_cache);
-}
-
 static void dax_region_free(struct kref *kref)
 {
 	struct dax_region *dax_region;
@@ -361,7 +236,7 @@ static int check_vma(struct dax_dev *dax_dev, struct vm_area_struct *vma,
 	struct device *dev = &dax_dev->dev;
 	unsigned long mask;
 
-	if (!dax_dev->alive)
+	if (!dax_inode_alive(dax_dev->dax_inode))
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
@@ -542,7 +417,13 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 
 	dev_dbg(&dax_dev->dev, "%s\n", __func__);
 
+	/*
+	 * We lock to check dax_inode liveness and will re-check at
+	 * fault time.
+	 */
+	rcu_read_lock();
 	rc = check_vma(dax_dev, vma, __func__);
+	rcu_read_unlock();
 	if (rc)
 		return rc;
 
@@ -588,12 +469,13 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 
 static int dax_open(struct inode *inode, struct file *filp)
 {
-	struct dax_dev *dax_dev;
+	struct dax_inode *dax_inode = inode_to_dax_inode(inode);
+	struct inode *__dax_inode = dax_inode_to_inode(dax_inode);
+	struct dax_dev *dax_dev = dax_inode_get_private(dax_inode);
 
-	dax_dev = container_of(inode->i_cdev, struct dax_dev, cdev);
 	dev_dbg(&dax_dev->dev, "%s\n", __func__);
-	inode->i_mapping = dax_dev->inode->i_mapping;
-	inode->i_mapping->host = dax_dev->inode;
+	inode->i_mapping = __dax_inode->i_mapping;
+	inode->i_mapping->host = __dax_inode;
 	filp->f_mapping = inode->i_mapping;
 	filp->private_data = dax_dev;
 	inode->i_flags = S_DAX;
@@ -622,32 +504,25 @@ static void dax_dev_release(struct device *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct dax_region *dax_region = dax_dev->region;
+	struct dax_inode *dax_inode = dax_dev->dax_inode;
 
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
-	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
-	iput(dax_dev->inode);
+	put_dax_inode(dax_inode);
 	kfree(dax_dev);
 }
 
 static void unregister_dax_dev(void *dev)
 {
 	struct dax_dev *dax_dev = to_dax_dev(dev);
-	struct cdev *cdev = &dax_dev->cdev;
+	struct dax_inode *dax_inode = dax_dev->dax_inode;
+	struct inode *inode = dax_inode_to_inode(dax_inode);
 
 	dev_dbg(dev, "%s\n", __func__);
 
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
-	cdev_del(cdev);
+	kill_dax_inode(dax_inode);
+	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+	dax_inode_unregister(dax_inode);
 	device_unregister(dev);
 }
 
@@ -655,11 +530,11 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
+	struct dax_inode *dax_inode;
 	struct dax_dev *dax_dev;
-	int rc = 0, minor, i;
+	struct inode *inode;
 	struct device *dev;
-	struct cdev *cdev;
-	dev_t dev_t;
+	int rc = 0, i;
 
 	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
 	if (!dax_dev)
@@ -685,38 +560,27 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		goto err_id;
 	}
 
-	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
-	if (minor < 0) {
-		rc = minor;
-		goto err_minor;
-	}
-
-	dev_t = MKDEV(MAJOR(dax_devt), minor);
-	dev = &dax_dev->dev;
-	dax_dev->inode = dax_inode_get(&dax_dev->cdev, dev_t);
-	if (!dax_dev->inode) {
-		rc = -ENOMEM;
+	dax_inode = alloc_dax_inode(dax_dev);
+	if (!dax_inode)
 		goto err_inode;
-	}
 
-	/* device_initialize() so cdev can reference kobj parent */
+	/* initialize now so dax_inode_register() can reference dev->kobj */
+	dax_dev->dax_inode = dax_inode;
+	dev = &dax_dev->dev;
 	device_initialize(dev);
 
-	cdev = &dax_dev->cdev;
-	cdev_init(cdev, &dax_fops);
-	cdev->owner = parent->driver->owner;
-	cdev->kobj.parent = &dev->kobj;
-	rc = cdev_add(&dax_dev->cdev, dev_t, 1);
+	rc = dax_inode_register(dax_inode, &dax_fops,
+			parent->driver->owner, &dev->kobj);
 	if (rc)
-		goto err_cdev;
+		goto err_register;
 
 	/* from here on we're committed to teardown via dax_dev_release() */
 	dax_dev->num_resources = count;
-	dax_dev->alive = true;
 	dax_dev->region = dax_region;
 	kref_get(&dax_region->kref);
 
-	dev->devt = dev_t;
+	inode = dax_inode_to_inode(dax_inode);
+	dev->devt = inode->i_rdev;
 	dev->class = dax_class;
 	dev->parent = parent;
 	dev->groups = dax_attribute_groups;
@@ -734,11 +598,9 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 
 	return dax_dev;
 
- err_cdev:
-	iput(dax_dev->inode);
+ err_register:
+	put_dax_inode(dax_inode);
  err_inode:
-	ida_simple_remove(&dax_minor_ida, minor);
- err_minor:
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
  err_id:
 	kfree(dax_dev);
@@ -749,38 +611,13 @@ EXPORT_SYMBOL_GPL(devm_create_dax_dev);
 
 static int __init dax_init(void)
 {
-	int rc;
-
-	rc = dax_inode_init();
-	if (rc)
-		return rc;
-
-	nr_dax = max(nr_dax, 256);
-	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
-	if (rc)
-		goto err_chrdev;
-
 	dax_class = class_create(THIS_MODULE, "dax");
-	if (IS_ERR(dax_class)) {
-		rc = PTR_ERR(dax_class);
-		goto err_class;
-	}
-
-	return 0;
-
- err_class:
-	unregister_chrdev_region(dax_devt, nr_dax);
- err_chrdev:
-	dax_inode_exit();
-	return rc;
+	return PTR_ERR_OR_ZERO(dax_class);
 }
 
 static void __exit dax_exit(void)
 {
 	class_destroy(dax_class);
-	unregister_chrdev_region(dax_devt, nr_dax);
-	ida_destroy(&dax_minor_ida);
-	dax_inode_exit();
 }
 
 MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 033f49b31fdc..9c98b1dd24c1 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -16,7 +16,7 @@
 #include <linux/pfn_t.h>
 #include "../nvdimm/pfn.h"
 #include "../nvdimm/nd.h"
-#include "dax.h"
+#include "device-dax.h"
 
 struct dax_pmem {
 	struct device *dev;
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
new file mode 100644
index 000000000000..e6369b851619
--- /dev/null
+++ b/drivers/dax/super.c
@@ -0,0 +1,310 @@
+/*
+ * Copyright(c) 2017 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/mount.h>
+#include <linux/magic.h>
+#include <linux/cdev.h>
+#include <linux/hash.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+
+static int nr_dax = CONFIG_NR_DEV_DAX;
+module_param(nr_dax, int, S_IRUGO);
+MODULE_PARM_DESC(nr_dax, "max number of dax device instances");
+
+static dev_t dax_devt;
+static struct vfsmount *dax_mnt;
+static DEFINE_IDA(dax_minor_ida);
+static struct kmem_cache *dax_cache __read_mostly;
+static struct super_block *dax_superblock __read_mostly;
+
+/**
+ * struct dax_inode - anchor object for dax services
+ * @inode: core vfs
+ * @cdev: optional character interface for "device dax"
+ * @private: dax driver private data
+ * @alive: !alive + rcu grace period == no new operations / mappings
+ */
+struct dax_inode {
+	struct inode inode;
+	struct cdev cdev;
+	void *private;
+	bool alive;
+};
+
+bool dax_inode_alive(struct dax_inode *dax_inode)
+{
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			"dax operations require rcu_read_lock()\n");
+	return dax_inode->alive;
+}
+EXPORT_SYMBOL_GPL(dax_inode_alive);
+
+/*
+ * Note, rcu is not protecting the liveness of dax_inode, rcu is
+ * ensuring that any fault handlers or operations that might have seen
+ * dax_inode_alive(), have completed.  Any operations that start after
+ * synchronize_rcu() has run will abort upon seeing !dax_inode_alive().
+ */
+void kill_dax_inode(struct dax_inode *dax_inode)
+{
+	if (!dax_inode)
+		return;
+
+	dax_inode->alive = false;
+	synchronize_rcu();
+	dax_inode->private = NULL;
+}
+EXPORT_SYMBOL_GPL(kill_dax_inode);
+
+static struct inode *dax_alloc_inode(struct super_block *sb)
+{
+	struct dax_inode *dax_inode;
+
+	dax_inode = kmem_cache_alloc(dax_cache, GFP_KERNEL);
+	return &dax_inode->inode;
+}
+
+static struct dax_inode *to_dax_inode(struct inode *inode)
+{
+	return container_of(inode, struct dax_inode, inode);
+}
+
+static void dax_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct dax_inode *dax_inode = to_dax_inode(inode);
+
+	ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
+	kmem_cache_free(dax_cache, dax_inode);
+}
+
+static void dax_destroy_inode(struct inode *inode)
+{
+	struct dax_inode *dax_inode = to_dax_inode(inode);
+
+	WARN_ONCE(dax_inode->alive,
+			"kill_dax_inode() must be called before final iput()\n");
+	call_rcu(&inode->i_rcu, dax_i_callback);
+}
+
+static const struct super_operations dax_sops = {
+	.statfs = simple_statfs,
+	.alloc_inode = dax_alloc_inode,
+	.destroy_inode = dax_destroy_inode,
+	.drop_inode = generic_delete_inode,
+};
+
+static struct dentry *dax_mount(struct file_system_type *fs_type,
+		int flags, const char *dev_name, void *data)
+{
+	return mount_pseudo(fs_type, "dax:", &dax_sops, NULL, DAXFS_MAGIC);
+}
+
+static struct file_system_type dax_type = {
+	.name = "dax",
+	.mount = dax_mount,
+	.kill_sb = kill_anon_super,
+};
+
+static int dax_test(struct inode *inode, void *data)
+{
+	dev_t devt = *(dev_t *) data;
+
+	return inode->i_rdev == devt;
+}
+
+static int dax_set(struct inode *inode, void *data)
+{
+	dev_t devt = *(dev_t *) data;
+
+	inode->i_rdev = devt;
+	return 0;
+}
+
+static struct dax_inode *dax_inode_get(dev_t devt)
+{
+	struct dax_inode *dax_inode;
+	struct inode *inode;
+
+	inode = iget5_locked(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
+			dax_test, dax_set, &devt);
+
+	if (!inode)
+		return NULL;
+
+	dax_inode = to_dax_inode(inode);
+	if (inode->i_state & I_NEW) {
+		dax_inode->alive = true;
+		inode->i_cdev = &dax_inode->cdev;
+		inode->i_mode = S_IFCHR;
+		inode->i_flags = S_DAX;
+		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		unlock_new_inode(inode);
+	}
+
+	return dax_inode;
+}
+
+struct dax_inode *alloc_dax_inode(void *private)
+{
+	struct dax_inode *dax_inode;
+	dev_t devt;
+	int minor;
+
+	minor = ida_simple_get(&dax_minor_ida, 0, nr_dax, GFP_KERNEL);
+	if (minor < 0)
+		return NULL;
+
+	devt = MKDEV(MAJOR(dax_devt), minor);
+	dax_inode = dax_inode_get(devt);
+	if (!dax_inode)
+		goto err_inode;
+
+	dax_inode->private = private;
+	return dax_inode;
+
+ err_inode:
+	ida_simple_remove(&dax_minor_ida, minor);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(alloc_dax_inode);
+
+void put_dax_inode(struct dax_inode *dax_inode)
+{
+	if (!dax_inode)
+		return;
+	iput(&dax_inode->inode);
+}
+EXPORT_SYMBOL_GPL(put_dax_inode);
+
+/**
+ * inode_to_dax_inode: convert a public inode into its dax_inode
+ * @inode: An inode with i_cdev pointing to a dax_inode
+ */
+struct dax_inode *inode_to_dax_inode(struct inode *inode)
+{
+	struct cdev *cdev = inode->i_cdev;
+
+	return container_of(cdev, struct dax_inode, cdev);
+}
+EXPORT_SYMBOL_GPL(inode_to_dax_inode);
+
+struct inode *dax_inode_to_inode(struct dax_inode *dax_inode)
+{
+	return &dax_inode->inode;
+}
+EXPORT_SYMBOL_GPL(dax_inode_to_inode);
+
+void *dax_inode_get_private(struct dax_inode *dax_inode)
+{
+	return dax_inode->private;
+}
+EXPORT_SYMBOL_GPL(dax_inode_get_private);
+
+int dax_inode_register(struct dax_inode *dax_inode,
+		const struct file_operations *fops, struct module *owner,
+		struct kobject *parent)
+{
+	struct cdev *cdev = &dax_inode->cdev;
+	struct inode *inode = &dax_inode->inode;
+
+	cdev_init(cdev, fops);
+	cdev->owner = owner;
+	cdev->kobj.parent = parent;
+	return cdev_add(cdev, inode->i_rdev, 1);
+}
+EXPORT_SYMBOL_GPL(dax_inode_register);
+
+void dax_inode_unregister(struct dax_inode *dax_inode)
+{
+	struct cdev *cdev = &dax_inode->cdev;
+
+	cdev_del(cdev);
+}
+EXPORT_SYMBOL_GPL(dax_inode_unregister);
+
+static void init_once(void *_dax_inode)
+{
+	struct dax_inode *dax_inode = _dax_inode;
+	struct inode *inode = &dax_inode->inode;
+
+	inode_init_once(inode);
+}
+
+static int dax_inode_init(void)
+{
+	int rc;
+
+	dax_cache = kmem_cache_create("dax_cache", sizeof(struct dax_inode), 0,
+			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
+			 SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+			init_once);
+	if (!dax_cache)
+		return -ENOMEM;
+
+	rc = register_filesystem(&dax_type);
+	if (rc)
+		goto err_register_fs;
+
+	dax_mnt = kern_mount(&dax_type);
+	if (IS_ERR(dax_mnt)) {
+		rc = PTR_ERR(dax_mnt);
+		goto err_mount;
+	}
+	dax_superblock = dax_mnt->mnt_sb;
+
+	return 0;
+
+ err_mount:
+	unregister_filesystem(&dax_type);
+ err_register_fs:
+	kmem_cache_destroy(dax_cache);
+
+	return rc;
+}
+
+static void dax_inode_exit(void)
+{
+	kern_unmount(dax_mnt);
+	unregister_filesystem(&dax_type);
+	kmem_cache_destroy(dax_cache);
+}
+
+static int __init dax_fs_init(void)
+{
+	int rc;
+
+	rc = dax_inode_init();
+	if (rc)
+		return rc;
+
+	nr_dax = max(nr_dax, 256);
+	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
+	if (rc)
+		dax_inode_exit();
+	return rc;
+}
+
+static void __exit dax_fs_exit(void)
+{
+	unregister_chrdev_region(dax_devt, nr_dax);
+	ida_destroy(&dax_minor_ida);
+	dax_inode_exit();
+}
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+subsys_initcall(dax_fs_init);
+module_exit(dax_fs_exit);
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 405212be044a..a1ed891d239a 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -28,7 +28,7 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
 obj-$(CONFIG_ACPI_NFIT) += nfit.o
-obj-$(CONFIG_DEV_DAX) += dax.o
+obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
@@ -48,8 +48,8 @@ nd_blk-y += config_check.o
 nd_e820-y := $(NVDIMM_SRC)/e820.o
 nd_e820-y += config_check.o
 
-dax-y := $(DAX_SRC)/dax.o
-dax-y += config_check.o
+device_dax-y := $(DAX_SRC)/device.o
+device_dax-y += config_check.o
 
 dax_pmem-y := $(DAX_SRC)/pmem.o
 dax_pmem-y += config_check.o

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
