Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id E91591A1E20
 for <linux-nvdimm@lists.01.org>; Mon, 15 Aug 2016 20:27:53 -0700 (PDT)
Subject: [PATCH 6/7] dax: define a unified inode/address_space for
 device-dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Aug 2016 20:25:30 -0700
Message-ID: <147131793017.13727.7562195683997858588.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In support of enabling resize / truncate of device-dax instances, define
a pseudo-fs to provide a unified inode/address space for vm operations.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c          |  150 +++++++++++++++++++++++++++++++++++++++++++-
 fs/char_dev.c              |    1 
 include/uapi/linux/magic.h |    1 
 3 files changed, 148 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 17715773c097..e8b9319aeadb 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -13,7 +13,9 @@
 #include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/mount.h>
 #include <linux/pfn_t.h>
+#include <linux/hash.h>
 #include <linux/cdev.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
@@ -26,6 +28,9 @@ static struct class *dax_class;
 static DEFINE_IDA(dax_minor_ida);
 static int nr_dax = CONFIG_NR_DEV_DAX;
 module_param(nr_dax, int, S_IRUGO);
+static struct vfsmount *dax_mnt;
+static struct kmem_cache *dax_cache __read_mostly;
+static struct super_block *dax_superblock __read_mostly;
 MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
 
 /**
@@ -61,6 +66,7 @@ struct dax_region {
  */
 struct dax_dev {
 	struct dax_region *region;
+	struct inode *inode;
 	struct device dev;
 	struct cdev cdev;
 	bool alive;
@@ -69,6 +75,117 @@ struct dax_dev {
 	struct resource res[0];
 };
 
+static struct inode *dax_alloc_inode(struct super_block *sb)
+{
+	return kmem_cache_alloc(dax_cache, GFP_KERNEL);
+}
+
+static void dax_i_callback(struct rcu_head *head)
+{
+	struct inode *inode = container_of(head, struct inode, i_rcu);
+
+	kmem_cache_free(dax_cache, inode);
+}
+
+static void dax_destroy_inode(struct inode *inode)
+{
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
+	return inode->i_cdev == data;
+}
+
+static int dax_set(struct inode *inode, void *data)
+{
+	inode->i_cdev = data;
+	return 0;
+}
+
+static struct inode *dax_inode_get(struct cdev *cdev, dev_t devt)
+{
+	struct inode *inode;
+
+	inode = iget5_locked(dax_superblock, hash_32(devt + DAXFS_MAGIC, 31),
+			dax_test, dax_set, cdev);
+
+	if (!inode)
+		return NULL;
+
+	if (inode->i_state & I_NEW) {
+		inode->i_mode = S_IFCHR;
+		inode->i_flags = S_DAX;
+		inode->i_rdev = devt;
+		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
+static void init_once(void *inode)
+{
+	inode_init_once(inode);
+}
+
+static int dax_inode_init(void)
+{
+	int rc;
+
+	dax_cache = kmem_cache_create("dax_cache", sizeof(struct inode), 0,
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
 static void dax_region_free(struct kref *kref)
 {
 	struct dax_region *dax_region;
@@ -379,6 +496,9 @@ static int dax_open(struct inode *inode, struct file *filp)
 
 	dax_dev = container_of(inode->i_cdev, struct dax_dev, cdev);
 	dev_dbg(&dax_dev->dev, "%s\n", __func__);
+	inode->i_mapping = dax_dev->inode->i_mapping;
+	inode->i_mapping->host = dax_dev->inode;
+	filp->f_mapping = inode->i_mapping;
 	filp->private_data = dax_dev;
 	inode->i_flags = S_DAX;
 
@@ -410,6 +530,7 @@ static void dax_dev_release(struct device *dev)
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
 	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
+	iput(dax_dev->inode);
 	kfree(dax_dev);
 }
 
@@ -459,6 +580,12 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 		goto err_minor;
 	}
 
+	dax_dev->inode = dax_inode_get(&dax_dev->cdev, dev_t);
+	if (!dax_dev->inode) {
+		rc = -ENOMEM;
+		goto err_inode;
+	}
+
 	/* device_initialize() so cdev can reference kobj parent */
 	dev_t = MKDEV(MAJOR(dax_devt), minor);
 	dev = &dax_dev->dev;
@@ -494,6 +621,8 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	return devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
 
  err_cdev:
+	iput(dax_dev->inode);
+ err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
 	ida_simple_remove(&dax_region->ida, dax_dev->id);
@@ -508,16 +637,28 @@ static int __init dax_init(void)
 {
 	int rc;
 
+	rc = dax_inode_init();
+	if (rc)
+		return rc;
+
 	nr_dax = max(nr_dax, 256);
 	rc = alloc_chrdev_region(&dax_devt, 0, nr_dax, "dax");
 	if (rc)
-		return rc;
+		goto err_chrdev;
 
 	dax_class = class_create(THIS_MODULE, "dax");
-	if (IS_ERR(dax_class))
-		unregister_chrdev_region(dax_devt, nr_dax);
+	if (IS_ERR(dax_class)) {
+		rc = PTR_ERR(dax_class);
+		goto err_class;
+	}
 
-	return PTR_ERR_OR_ZERO(dax_class);
+	return 0;
+
+ err_class:
+	unregister_chrdev_region(dax_devt, nr_dax);
+ err_chrdev:
+	dax_inode_exit();
+	return rc;
 }
 
 static void __exit dax_exit(void)
@@ -525,6 +666,7 @@ static void __exit dax_exit(void)
 	class_destroy(dax_class);
 	unregister_chrdev_region(dax_devt, nr_dax);
 	ida_destroy(&dax_minor_ida);
+	dax_inode_exit();
 }
 
 MODULE_AUTHOR("Intel Corporation");
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 6edd825231c5..44a240c4bb65 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -406,6 +406,7 @@ void cd_forget(struct inode *inode)
 	spin_lock(&cdev_lock);
 	list_del_init(&inode->i_devices);
 	inode->i_cdev = NULL;
+	inode->i_mapping = &inode->i_data;
 	spin_unlock(&cdev_lock);
 }
 
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index e398beac67b8..9bd559472c92 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -65,6 +65,7 @@
 #define V9FS_MAGIC		0x01021997
 
 #define BDEVFS_MAGIC            0x62646576
+#define DAXFS_MAGIC             0x64646178
 #define BINFMTFS_MAGIC          0x42494e4d
 #define DEVPTS_SUPER_MAGIC	0x1cd1
 #define FUTEXFS_SUPER_MAGIC	0xBAD1DEA

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
