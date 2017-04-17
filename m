Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09C7421939239
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:14:45 -0700 (PDT)
Subject: [resend PATCH v2 02/33] dax: refactor dax-fs into a generic
 provider of 'struct dax_device' instances
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:09:00 -0700
Message-ID: <149245614087.10206.6255573945930660609.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

We want dax capable drivers to be able to publish a set of dax
operations [1]. However, we do not want to further abuse block_devices
to advertise these operations. Instead we will attach these operations
to a dax device and add a lookup mechanism to go from block device path
to a dax device. A dax capable driver like pmem or brd is responsible
for registering a dax device, alongside a block device, and then a dax
capable filesystem is responsible for retrieving the dax device by path
name if it wants to call dax_operations.

For now, we refactor the dax pseudo-fs to be a generic facility, rather
than an implementation detail, of the device-dax use case. Where a "dax
device" is just an inode + dax infrastructure, and "Device DAX" is a
mapping service layered on top of that base 'struct dax_device'.
"Filesystem DAX" is then a mapping service that layers a filesystem on
top of that same base device. Filesystem DAX is associated with a
block_device for now, but perhaps directly to a dax device in the
future, or for new pmem-only filesystems.

[1]: https://lkml.org/lkml/2017/1/19/880

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/Makefile            |    2 
 drivers/dax/Kconfig         |   10 +
 drivers/dax/Makefile        |    5 +
 drivers/dax/dax.h           |   20 +--
 drivers/dax/device-dax.h    |   25 ++++
 drivers/dax/device.c        |  241 ++++++----------------------------
 drivers/dax/pmem.c          |    2 
 drivers/dax/super.c         |  303 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dax.h         |    3 
 tools/testing/nvdimm/Kbuild |   10 +
 10 files changed, 404 insertions(+), 217 deletions(-)
 create mode 100644 drivers/dax/device-dax.h
 rename drivers/dax/{dax.c => device.c} (77%)
 create mode 100644 drivers/dax/super.c

diff --git a/drivers/Makefile b/drivers/Makefile
index 2eced9afba53..0442e982cf35 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -71,7 +71,7 @@ obj-$(CONFIG_PARPORT)		+= parport/
 obj-$(CONFIG_NVM)		+= lightnvm/
 obj-y				+= base/ block/ misc/ mfd/ nfc/
 obj-$(CONFIG_LIBNVDIMM)		+= nvdimm/
-obj-$(CONFIG_DEV_DAX)		+= dax/
+obj-$(CONFIG_DAX)		+= dax/
 obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf/
 obj-$(CONFIG_NUBUS)		+= nubus/
 obj-y				+= macintosh/
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 9e95bf94eb13..b7053eafd88e 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -1,8 +1,13 @@
-menuconfig DEV_DAX
+menuconfig DAX
 	tristate "DAX: direct access to differentiated memory"
+	select SRCU
 	default m if NVDIMM_DAX
+
+if DAX
+
+config DEV_DAX
+	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
-	select SRCU
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
@@ -11,7 +16,6 @@ menuconfig DEV_DAX
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
index ea176d875d60..2472d9da96db 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -12,14 +12,12 @@
  */
 #ifndef __DAX_H__
 #define __DAX_H__
-struct device;
-struct dev_dax;
-struct resource;
-struct dax_region;
-void dax_region_put(struct dax_region *dax_region);
-struct dax_region *alloc_dax_region(struct device *parent,
-		int region_id, struct resource *res, unsigned int align,
-		void *addr, unsigned long flags);
-struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
-		struct resource *res, int count);
+struct dax_device;
+struct dax_device *alloc_dax(void *private);
+void put_dax(struct dax_device *dax_dev);
+bool dax_alive(struct dax_device *dax_dev);
+void kill_dax(struct dax_device *dax_dev);
+struct dax_device *inode_dax(struct inode *inode);
+struct inode *dax_inode(struct dax_device *dax_dev);
+void *dax_get_private(struct dax_device *dax_dev);
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
new file mode 100644
index 000000000000..fdcd9769ffde
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
+struct dev_dax;
+struct resource;
+struct dax_region;
+void dax_region_put(struct dax_region *dax_region);
+struct dax_region *alloc_dax_region(struct device *parent,
+		int region_id, struct resource *res, unsigned int align,
+		void *addr, unsigned long flags);
+struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
+		struct resource *res, int count);
+#endif /* __DEVICE_DAX_H__ */
diff --git a/drivers/dax/dax.c b/drivers/dax/device.c
similarity index 77%
rename from drivers/dax/dax.c
rename to drivers/dax/device.c
index 376fdd353aea..19a42edbfa03 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/device.c
@@ -1,5 +1,5 @@
 /*
- * Copyright(c) 2016 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 - 2017 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -13,10 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/magic.h>
-#include <linux/mount.h>
 #include <linux/pfn_t.h>
-#include <linux/hash.h>
 #include <linux/cdev.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
@@ -24,16 +21,7 @@
 #include <linux/mm.h>
 #include "dax.h"
 
-static dev_t dax_devt;
-DEFINE_STATIC_SRCU(dax_srcu);
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
@@ -59,19 +47,16 @@ struct dax_region {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region
  * @region - parent region
- * @dev - device backing the character device
- * @cdev - core chardev data
- * @alive - !alive + srcu grace period == no new mappings can be established
+ * @dax_dev - core dax functionality
+ * @dev - device core
  * @id - child id in the region
  * @num_resources - number of physical address extents in this device
  * @res - array of physical address ranges
  */
 struct dev_dax {
 	struct dax_region *region;
-	struct inode *inode;
+	struct dax_device *dax_dev;
 	struct device dev;
-	struct cdev cdev;
-	bool alive;
 	int id;
 	int num_resources;
 	struct resource res[0];
@@ -144,117 +129,6 @@ static const struct attribute_group *dax_region_attribute_groups[] = {
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
@@ -363,7 +237,7 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 	struct device *dev = &dev_dax->dev;
 	unsigned long mask;
 
-	if (!dev_dax->alive)
+	if (!dax_alive(dev_dax->dax_dev))
 		return -ENXIO;
 
 	/* prevent private mappings from being established */
@@ -582,7 +456,7 @@ static int dev_dax_huge_fault(struct vm_fault *vmf,
 			? "write" : "read",
 			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
 
-	id = srcu_read_lock(&dax_srcu);
+	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
 		rc = __dev_dax_pte_fault(dev_dax, vmf);
@@ -596,7 +470,7 @@ static int dev_dax_huge_fault(struct vm_fault *vmf,
 	default:
 		rc = VM_FAULT_SIGBUS;
 	}
-	srcu_read_unlock(&dax_srcu, id);
+	dax_read_unlock(id);
 
 	return rc;
 }
@@ -614,11 +488,17 @@ static const struct vm_operations_struct dax_vm_ops = {
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct dev_dax *dev_dax = filp->private_data;
-	int rc;
+	int rc, id;
 
 	dev_dbg(&dev_dax->dev, "%s\n", __func__);
 
+	/*
+	 * We lock to check dax_dev liveness and will re-check at
+	 * fault time.
+	 */
+	id = dax_read_lock();
 	rc = check_vma(dev_dax, vma, __func__);
+	dax_read_unlock(id);
 	if (rc)
 		return rc;
 
@@ -664,12 +544,13 @@ static unsigned long dax_get_unmapped_area(struct file *filp,
 
 static int dax_open(struct inode *inode, struct file *filp)
 {
-	struct dev_dax *dev_dax;
+	struct dax_device *dax_dev = inode_dax(inode);
+	struct inode *__dax_inode = dax_inode(dax_dev);
+	struct dev_dax *dev_dax = dax_get_private(dax_dev);
 
-	dev_dax = container_of(inode->i_cdev, struct dev_dax, cdev);
 	dev_dbg(&dev_dax->dev, "%s\n", __func__);
-	inode->i_mapping = dev_dax->inode->i_mapping;
-	inode->i_mapping->host = dev_dax->inode;
+	inode->i_mapping = __dax_inode->i_mapping;
+	inode->i_mapping->host = __dax_inode;
 	filp->f_mapping = inode->i_mapping;
 	filp->private_data = dev_dax;
 	inode->i_flags = S_DAX;
@@ -698,36 +579,34 @@ static void dev_dax_release(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct dax_region *dax_region = dev_dax->region;
+	struct dax_device *dax_dev = dev_dax->dax_dev;
 
 	ida_simple_remove(&dax_region->ida, dev_dax->id);
-	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
-	iput(dev_dax->inode);
+	put_dax(dax_dev);
 	kfree(dev_dax);
 }
 
 static void kill_dev_dax(struct dev_dax *dev_dax)
 {
-	/*
-	 * Note, rcu is not protecting the liveness of dev_dax, rcu is
-	 * ensuring that any fault handlers that might have seen
-	 * dev_dax->alive == true, have completed.  Any fault handlers
-	 * that start after synchronize_srcu() has started will abort
-	 * upon seeing dev_dax->alive == false.
-	 */
-	dev_dax->alive = false;
-	synchronize_srcu(&dax_srcu);
-	unmap_mapping_range(dev_dax->inode->i_mapping, 0, 0, 1);
+	struct dax_device *dax_dev = dev_dax->dax_dev;
+	struct inode *inode = dax_inode(dax_dev);
+
+	kill_dax(dax_dev);
+	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
 }
 
 static void unregister_dev_dax(void *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_device *dax_dev = dev_dax->dax_dev;
+	struct inode *inode = dax_inode(dax_dev);
+	struct cdev *cdev = inode->i_cdev;
 
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
-	cdev_device_del(&dev_dax->cdev, dev);
+	cdev_device_del(cdev, dev);
 	put_device(dev);
 }
 
@@ -735,11 +614,12 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
+	struct dax_device *dax_dev;
 	struct dev_dax *dev_dax;
-	int rc = 0, minor, i;
+	struct inode *inode;
 	struct device *dev;
 	struct cdev *cdev;
-	dev_t dev_t;
+	int rc = 0, i;
 
 	dev_dax = kzalloc(sizeof(*dev_dax) + sizeof(*res) * count, GFP_KERNEL);
 	if (!dev_dax)
@@ -765,33 +645,25 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		goto err_id;
 	}
 
-	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
-	if (minor < 0) {
-		rc = minor;
-		goto err_minor;
-	}
+	dax_dev = alloc_dax(dev_dax);
+	if (!dax_dev)
+		goto err_dax;
 
-	dev_t = MKDEV(MAJOR(dax_devt), minor);
+	/* from here on we're committed to teardown via dax_dev_release() */
 	dev = &dev_dax->dev;
-	dev_dax->inode = dax_inode_get(&dev_dax->cdev, dev_t);
-	if (!dev_dax->inode) {
-		rc = -ENOMEM;
-		goto err_inode;
-	}
-
-	/* from here on we're committed to teardown via dev_dax_release() */
 	device_initialize(dev);
 
-	cdev = &dev_dax->cdev;
+	inode = dax_inode(dax_dev);
+	cdev = inode->i_cdev;
 	cdev_init(cdev, &dax_fops);
 	cdev->owner = parent->driver->owner;
 
 	dev_dax->num_resources = count;
-	dev_dax->alive = true;
+	dev_dax->dax_dev = dax_dev;
 	dev_dax->region = dax_region;
 	kref_get(&dax_region->kref);
 
-	dev->devt = dev_t;
+	dev->devt = inode->i_rdev;
 	dev->class = dax_class;
 	dev->parent = parent;
 	dev->groups = dax_attribute_groups;
@@ -811,9 +683,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 
 	return dev_dax;
 
- err_inode:
-	ida_simple_remove(&dax_minor_ida, minor);
- err_minor:
+ err_dax:
 	ida_simple_remove(&dax_region->ida, dev_dax->id);
  err_id:
 	kfree(dev_dax);
@@ -824,38 +694,13 @@ EXPORT_SYMBOL_GPL(devm_create_dev_dax);
 
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
index 2c736fc4508b..d4ca19bd74eb 100644
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
index 000000000000..c9f85f1c086e
--- /dev/null
+++ b/drivers/dax/super.c
@@ -0,0 +1,303 @@
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
+DEFINE_STATIC_SRCU(dax_srcu);
+static struct vfsmount *dax_mnt;
+static DEFINE_IDA(dax_minor_ida);
+static struct kmem_cache *dax_cache __read_mostly;
+static struct super_block *dax_superblock __read_mostly;
+
+int dax_read_lock(void)
+{
+	return srcu_read_lock(&dax_srcu);
+}
+EXPORT_SYMBOL_GPL(dax_read_lock);
+
+void dax_read_unlock(int id)
+{
+	srcu_read_unlock(&dax_srcu, id);
+}
+EXPORT_SYMBOL_GPL(dax_read_unlock);
+
+/**
+ * struct dax_device - anchor object for dax services
+ * @inode: core vfs
+ * @cdev: optional character interface for "device dax"
+ * @private: dax driver private data
+ * @alive: !alive + rcu grace period == no new operations / mappings
+ */
+struct dax_device {
+	struct inode inode;
+	struct cdev cdev;
+	void *private;
+	bool alive;
+};
+
+bool dax_alive(struct dax_device *dax_dev)
+{
+	lockdep_assert_held(&dax_srcu);
+	return dax_dev->alive;
+}
+EXPORT_SYMBOL_GPL(dax_alive);
+
+/*
+ * Note, rcu is not protecting the liveness of dax_dev, rcu is ensuring
+ * that any fault handlers or operations that might have seen
+ * dax_alive(), have completed.  Any operations that start after
+ * synchronize_srcu() has run will abort upon seeing !dax_alive().
+ */
+void kill_dax(struct dax_device *dax_dev)
+{
+	if (!dax_dev)
+		return;
+
+	dax_dev->alive = false;
+	synchronize_srcu(&dax_srcu);
+	dax_dev->private = NULL;
+}
+EXPORT_SYMBOL_GPL(kill_dax);
+
+static struct inode *dax_alloc_inode(struct super_block *sb)
+{
+	struct dax_device *dax_dev;
+
+	dax_dev = kmem_cache_alloc(dax_cache, GFP_KERNEL);
+	return &dax_dev->inode;
+}
+
+static struct dax_device *to_dax_dev(struct inode *inode)
+{
+	return container_of(inode, struct dax_device, inode);
+}
+
+static void dax_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+	struct dax_device *dax_dev = to_dax_dev(inode);
+
+	ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
+	kmem_cache_free(dax_cache, dax_dev);
+}
+
+static void dax_destroy_inode(struct inode *inode)
+{
+	struct dax_device *dax_dev = to_dax_dev(inode);
+
+	WARN_ONCE(dax_dev->alive,
+			"kill_dax() must be called before final iput()\n");
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
+static struct file_system_type dax_fs_type = {
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
+static struct dax_device *dax_dev_get(dev_t devt)
+{
+	struct dax_device *dax_dev;
+	struct inode *inode;
+
+	inode = iget5_locked(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
+			dax_test, dax_set, &devt);
+
+	if (!inode)
+		return NULL;
+
+	dax_dev = to_dax_dev(inode);
+	if (inode->i_state & I_NEW) {
+		dax_dev->alive = true;
+		inode->i_cdev = &dax_dev->cdev;
+		inode->i_mode = S_IFCHR;
+		inode->i_flags = S_DAX;
+		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		unlock_new_inode(inode);
+	}
+
+	return dax_dev;
+}
+
+struct dax_device *alloc_dax(void *private)
+{
+	struct dax_device *dax_dev;
+	dev_t devt;
+	int minor;
+
+	minor = ida_simple_get(&dax_minor_ida, 0, nr_dax, GFP_KERNEL);
+	if (minor < 0)
+		return NULL;
+
+	devt = MKDEV(MAJOR(dax_devt), minor);
+	dax_dev = dax_dev_get(devt);
+	if (!dax_dev)
+		goto err_inode;
+
+	dax_dev->private = private;
+	return dax_dev;
+
+ err_inode:
+	ida_simple_remove(&dax_minor_ida, minor);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(alloc_dax);
+
+void put_dax(struct dax_device *dax_dev)
+{
+	if (!dax_dev)
+		return;
+	iput(&dax_dev->inode);
+}
+EXPORT_SYMBOL_GPL(put_dax);
+
+/**
+ * inode_dax: convert a public inode into its dax_dev
+ * @inode: An inode with i_cdev pointing to a dax_dev
+ *
+ * Note this is not equivalent to to_dax_dev() which is for private
+ * internal use where we know the inode filesystem type == dax_fs_type.
+ */
+struct dax_device *inode_dax(struct inode *inode)
+{
+	struct cdev *cdev = inode->i_cdev;
+
+	return container_of(cdev, struct dax_device, cdev);
+}
+EXPORT_SYMBOL_GPL(inode_dax);
+
+struct inode *dax_inode(struct dax_device *dax_dev)
+{
+	return &dax_dev->inode;
+}
+EXPORT_SYMBOL_GPL(dax_inode);
+
+void *dax_get_private(struct dax_device *dax_dev)
+{
+	return dax_dev->private;
+}
+EXPORT_SYMBOL_GPL(dax_get_private);
+
+static void init_once(void *_dax_dev)
+{
+	struct dax_device *dax_dev = _dax_dev;
+	struct inode *inode = &dax_dev->inode;
+
+	inode_init_once(inode);
+}
+
+static int __dax_fs_init(void)
+{
+	int rc;
+
+	dax_cache = kmem_cache_create("dax_cache", sizeof(struct dax_device), 0,
+			(SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
+			 SLAB_MEM_SPREAD|SLAB_ACCOUNT),
+			init_once);
+	if (!dax_cache)
+		return -ENOMEM;
+
+	rc = register_filesystem(&dax_fs_type);
+	if (rc)
+		goto err_register_fs;
+
+	dax_mnt = kern_mount(&dax_fs_type);
+	if (IS_ERR(dax_mnt)) {
+		rc = PTR_ERR(dax_mnt);
+		goto err_mount;
+	}
+	dax_superblock = dax_mnt->mnt_sb;
+
+	return 0;
+
+ err_mount:
+	unregister_filesystem(&dax_fs_type);
+ err_register_fs:
+	kmem_cache_destroy(dax_cache);
+
+	return rc;
+}
+
+static void __dax_fs_exit(void)
+{
+	kern_unmount(dax_mnt);
+	unregister_filesystem(&dax_fs_type);
+	kmem_cache_destroy(dax_cache);
+}
+
+static int __init dax_fs_init(void)
+{
+	int rc;
+
+	rc = __dax_fs_init();
+	if (rc)
+		return rc;
+
+	nr_dax = max(nr_dax, 256);
+	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
+	if (rc)
+		__dax_fs_exit();
+	return rc;
+}
+
+static void __exit dax_fs_exit(void)
+{
+	unregister_chrdev_region(dax_devt, nr_dax);
+	ida_destroy(&dax_minor_ida);
+	__dax_fs_exit();
+}
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
+subsys_initcall(dax_fs_init);
+module_exit(dax_fs_exit);
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d8a3dc042e1c..5b62f5d19aea 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -8,6 +8,9 @@
 
 struct iomap_ops;
 
+int dax_read_lock(void);
+void dax_read_unlock(int id);
+
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
  * the entry size (PMD) and two more to tell us if the entry is a huge zero
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 405212be044a..2033ad03b8cd 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -28,7 +28,10 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
 obj-$(CONFIG_ND_BLK) += nd_blk.o
 obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
 obj-$(CONFIG_ACPI_NFIT) += nfit.o
-obj-$(CONFIG_DEV_DAX) += dax.o
+ifeq ($(CONFIG_DAX),m)
+obj-$(CONFIG_DAX) += dax.o
+endif
+obj-$(CONFIG_DEV_DAX) += device_dax.o
 obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
@@ -48,9 +51,12 @@ nd_blk-y += config_check.o
 nd_e820-y := $(NVDIMM_SRC)/e820.o
 nd_e820-y += config_check.o
 
-dax-y := $(DAX_SRC)/dax.o
+dax-y := $(DAX_SRC)/super.o
 dax-y += config_check.o
 
+device_dax-y := $(DAX_SRC)/device.o
+device_dax-y += config_check.o
+
 dax_pmem-y := $(DAX_SRC)/pmem.o
 dax_pmem-y += config_check.o
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
