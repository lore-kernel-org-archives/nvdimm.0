Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DEC42194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:39:08 -0700 (PDT)
Subject: [PATCH v2 03/33] dax: add a facility to lookup a dax device by
 'host' device name
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:33:24 -0700
Message-ID: <149222360442.32363.18293902621484457086.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For the current block_device based filesystem-dax path, we need a way
for it to lookup the dax_device associated with a block_device. Add a
'host' property of a dax_device that can be used for this purpose. It is
a free form string, but for a dax_device associated with a block device
it is the bdev name.

This is a stop-gap until filesystems are able to mount on a dax-inode
directly.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.h    |    2 +
 drivers/dax/device.c |    2 +
 drivers/dax/super.c  |   83 ++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/dax.h  |    1 +
 4 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index 2472d9da96db..246a24d68d4c 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,7 +13,7 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct dax_device;
-struct dax_device *alloc_dax(void *private);
+struct dax_device *alloc_dax(void *private, const char *host);
 void put_dax(struct dax_device *dax_dev);
 bool dax_alive(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 19a42edbfa03..db68f4fa8ce0 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -645,7 +645,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		goto err_id;
 	}
 
-	dax_dev = alloc_dax(dev_dax);
+	dax_dev = alloc_dax(dev_dax, NULL);
 	if (!dax_dev)
 		goto err_dax;
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index c9f85f1c086e..bb22956a106b 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -30,6 +30,10 @@ static DEFINE_IDA(dax_minor_ida);
 static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 
+#define DAX_HASH_SIZE (PAGE_SIZE / sizeof(struct hlist_head))
+static struct hlist_head dax_host_list[DAX_HASH_SIZE];
+static DEFINE_SPINLOCK(dax_host_lock);
+
 int dax_read_lock(void)
 {
 	return srcu_read_lock(&dax_srcu);
@@ -46,12 +50,15 @@ EXPORT_SYMBOL_GPL(dax_read_unlock);
  * struct dax_device - anchor object for dax services
  * @inode: core vfs
  * @cdev: optional character interface for "device dax"
+ * @host: optional name for lookups where the device path is not available
  * @private: dax driver private data
  * @alive: !alive + rcu grace period == no new operations / mappings
  */
 struct dax_device {
+	struct hlist_node list;
 	struct inode inode;
 	struct cdev cdev;
+	const char *host;
 	void *private;
 	bool alive;
 };
@@ -63,6 +70,11 @@ bool dax_alive(struct dax_device *dax_dev)
 }
 EXPORT_SYMBOL_GPL(dax_alive);
 
+static int dax_host_hash(const char *host)
+{
+	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
+}
+
 /*
  * Note, rcu is not protecting the liveness of dax_dev, rcu is ensuring
  * that any fault handlers or operations that might have seen
@@ -75,6 +87,12 @@ void kill_dax(struct dax_device *dax_dev)
 		return;
 
 	dax_dev->alive = false;
+
+	spin_lock(&dax_host_lock);
+	if (!hlist_unhashed(&dax_dev->list))
+		hlist_del_init(&dax_dev->list);
+	spin_unlock(&dax_host_lock);
+
 	synchronize_srcu(&dax_srcu);
 	dax_dev->private = NULL;
 }
@@ -98,6 +116,8 @@ static void dax_i_callback(struct rcu_head *head)
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct dax_device *dax_dev = to_dax_dev(inode);
 
+	kfree(dax_dev->host);
+	dax_dev->host = NULL;
 	ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
 	kmem_cache_free(dax_cache, dax_dev);
 }
@@ -169,26 +189,49 @@ static struct dax_device *dax_dev_get(dev_t devt)
 	return dax_dev;
 }
 
-struct dax_device *alloc_dax(void *private)
+static void dax_add_host(struct dax_device *dax_dev, const char *host)
+{
+	int hash;
+
+	INIT_HLIST_NODE(&dax_dev->list);
+	if (!host)
+		return;
+
+	dax_dev->host = host;
+	hash = dax_host_hash(host);
+	spin_lock(&dax_host_lock);
+	hlist_add_head(&dax_dev->list, &dax_host_list[hash]);
+	spin_unlock(&dax_host_lock);
+}
+
+struct dax_device *alloc_dax(void *private, const char *__host)
 {
 	struct dax_device *dax_dev;
+	const char *host;
 	dev_t devt;
 	int minor;
 
+	host = kstrdup(__host, GFP_KERNEL);
+	if (__host && !host)
+		return NULL;
+
 	minor = ida_simple_get(&dax_minor_ida, 0, nr_dax, GFP_KERNEL);
 	if (minor < 0)
-		return NULL;
+		goto err_minor;
 
 	devt = MKDEV(MAJOR(dax_devt), minor);
 	dax_dev = dax_dev_get(devt);
 	if (!dax_dev)
-		goto err_inode;
+		goto err_dev;
 
+	dax_add_host(dax_dev, host);
 	dax_dev->private = private;
 	return dax_dev;
 
- err_inode:
+ err_dev:
 	ida_simple_remove(&dax_minor_ida, minor);
+ err_minor:
+	kfree(host);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(alloc_dax);
@@ -202,6 +245,38 @@ void put_dax(struct dax_device *dax_dev)
 EXPORT_SYMBOL_GPL(put_dax);
 
 /**
+ * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
+ * @host: alternate name for the device registered by a dax driver
+ */
+struct dax_device *dax_get_by_host(const char *host)
+{
+	struct dax_device *dax_dev, *found = NULL;
+	int hash, id;
+
+	if (!host)
+		return NULL;
+
+	hash = dax_host_hash(host);
+
+	id = dax_read_lock();
+	spin_lock(&dax_host_lock);
+	hlist_for_each_entry(dax_dev, &dax_host_list[hash], list) {
+		if (!dax_alive(dax_dev)
+				|| strcmp(host, dax_dev->host) != 0)
+			continue;
+
+		if (igrab(&dax_dev->inode))
+			found = dax_dev;
+		break;
+	}
+	spin_unlock(&dax_host_lock);
+	dax_read_unlock(id);
+
+	return found;
+}
+EXPORT_SYMBOL_GPL(dax_get_by_host);
+
+/**
  * inode_dax: convert a public inode into its dax_dev
  * @inode: An inode with i_cdev pointing to a dax_dev
  *
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 5b62f5d19aea..9b2d5ba10d7d 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -10,6 +10,7 @@ struct iomap_ops;
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);
+struct dax_device *dax_get_by_host(const char *host);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
