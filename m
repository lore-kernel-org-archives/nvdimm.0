Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E51582002
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:26 -0800 (PST)
Subject: [RFC PATCH 03/17] dax: add a facility to lookup a dax inode by
 'host' device name
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:20 -0800
Message-ID: <148559258055.11180.1317052601044081558.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For the current block_device based filesystem-dax path, we need a way
for it to lookup the dax_inode associated with a block_device. Add a
'host' property of a dax_inode that can be used for this purpose. It is
a free form string, but for a dax_inode associated with a block device
it is the bdev name.

This is a band-aid until filesystems are able to mount on a dax-inode
directly.

We use a hash list since blkdev_writepages() will need to use this
interface to issue dax_writeback_mapping_range().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.h    |    2 +
 drivers/dax/device.c |    2 +
 drivers/dax/super.c  |   79 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dax.h  |    1 +
 4 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index def061aa75f4..f33c16ed2ec6 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,7 +13,7 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct dax_inode;
-struct dax_inode *alloc_dax_inode(void *private);
+struct dax_inode *alloc_dax_inode(void *private, const char *host);
 void put_dax_inode(struct dax_inode *dax_inode);
 bool dax_inode_alive(struct dax_inode *dax_inode);
 void kill_dax_inode(struct dax_inode *dax_inode);
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index af06d0bfd6ea..6d0a3241a608 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -560,7 +560,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 		goto err_id;
 	}
 
-	dax_inode = alloc_dax_inode(dax_dev);
+	dax_inode = alloc_dax_inode(dax_dev, NULL);
 	if (!dax_inode)
 		goto err_inode;
 
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 7c4dc97d53a8..7ac048f94b2b 100644
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
  * struct dax_inode - anchor object for dax services
  * @inode: core vfs
  * @cdev: optional character interface for "device dax"
+ * @host: optional name for lookups where the device path is not available
  * @private: dax driver private data
  * @alive: !alive + rcu grace period == no new operations / mappings
  */
 struct dax_inode {
+	struct hlist_node list;
 	struct inode inode;
 	struct cdev cdev;
+	const char *host;
 	void *private;
 	bool alive;
 };
@@ -63,6 +70,11 @@ bool dax_inode_alive(struct dax_inode *dax_inode)
 }
 EXPORT_SYMBOL_GPL(dax_inode_alive);
 
+static int dax_host_hash(const char *host)
+{
+	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
+}
+
 /*
  * Note, rcu is not protecting the liveness of dax_inode, rcu is
  * ensuring that any fault handlers or operations that might have seen
@@ -75,6 +87,12 @@ void kill_dax_inode(struct dax_inode *dax_inode)
 		return;
 
 	dax_inode->alive = false;
+
+	spin_lock(&dax_host_lock);
+	if (!hlist_unhashed(&dax_inode->list))
+		hlist_del_init(&dax_inode->list);
+	spin_unlock(&dax_host_lock);
+
 	synchronize_srcu(&dax_srcu);
 	dax_inode->private = NULL;
 }
@@ -98,6 +116,8 @@ static void dax_i_callback(struct rcu_head *head)
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct dax_inode *dax_inode = to_dax_inode(inode);
 
+	kfree(dax_inode->host);
+	dax_inode->host = NULL;
 	ida_simple_remove(&dax_minor_ida, MINOR(inode->i_rdev));
 	kmem_cache_free(dax_cache, dax_inode);
 }
@@ -169,26 +189,49 @@ static struct dax_inode *dax_inode_get(dev_t devt)
 	return dax_inode;
 }
 
-struct dax_inode *alloc_dax_inode(void *private)
+static void dax_add_host(struct dax_inode *dax_inode, const char *host)
+{
+	int hash;
+
+	INIT_HLIST_NODE(&dax_inode->list);
+	if (!host)
+		return;
+
+	dax_inode->host = host;
+	hash = dax_host_hash(host);
+	spin_lock(&dax_host_lock);
+	hlist_add_head(&dax_inode->list, &dax_host_list[hash]);
+	spin_unlock(&dax_host_lock);
+}
+
+struct dax_inode *alloc_dax_inode(void *private, const char *__host)
 {
 	struct dax_inode *dax_inode;
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
 	dax_inode = dax_inode_get(devt);
 	if (!dax_inode)
 		goto err_inode;
 
+	dax_add_host(dax_inode, host);
 	dax_inode->private = private;
 	return dax_inode;
 
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
+ err_minor:
+	kfree(host);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(alloc_dax_inode);
@@ -202,6 +245,38 @@ void put_dax_inode(struct dax_inode *dax_inode)
 EXPORT_SYMBOL_GPL(put_dax_inode);
 
 /**
+ * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
+ * @host: alternate name for the inode registered by a dax driver
+ */
+struct dax_inode *dax_get_by_host(const char *host)
+{
+	struct dax_inode *dax_inode, *found = NULL;
+	int hash, id;
+
+	if (!host)
+		return NULL;
+
+	hash = dax_host_hash(host);
+
+	id = dax_read_lock();
+	spin_lock(&dax_host_lock);
+	hlist_for_each_entry(dax_inode, &dax_host_list[hash], list) {
+		if (!dax_inode_alive(dax_inode)
+				|| strcmp(host, dax_inode->host) != 0)
+			continue;
+
+		if (igrab(&dax_inode->inode))
+			found = dax_inode;
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
  * inode_to_dax_inode: convert a public inode into its dax_inode
  * @inode: An inode with i_cdev pointing to a dax_inode
  */
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 67002898d130..8fe19230e118 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -10,6 +10,7 @@ struct iomap_ops;
 
 int dax_read_lock(void);
 void dax_read_unlock(int id);
+struct dax_inode *dax_get_by_host(const char *host);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
