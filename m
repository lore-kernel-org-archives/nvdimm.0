Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DABC0225264A3
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 15:01:35 -0700 (PDT)
Subject: [PATCH] dax: adding fsync/msync support for device DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 04 Apr 2018 15:01:34 -0700
Message-ID: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When msync() is called on a device dax region, eventually ops->fsync() is
called. By providing fsync in the device dax file operations, we can provide
support for both. nvdimm_flush() for the nd_region is called when msync/fsync
is called in order to provide deep flush to the user app through standard POSIX
calls.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/device-dax.h  |    2 ++
 drivers/dax/device.c      |   19 +++++++++++++++++++
 drivers/dax/pmem.c        |   10 ++++++++++
 4 files changed, 32 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index b6fc4f04636d..5fc20191c89e 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -35,6 +35,7 @@ struct dax_region {
 	unsigned int align;
 	struct resource res;
 	unsigned long pfn_flags;
+	void (*sync)(struct device *);
 };
 
 /**
diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
index 688b051750bd..651f2e763058 100644
--- a/drivers/dax/device-dax.h
+++ b/drivers/dax/device-dax.h
@@ -22,4 +22,6 @@ struct dax_region *alloc_dax_region(struct device *parent,
 		void *addr, unsigned long flags);
 struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 		int id, struct resource *res, int count);
+void dax_set_sync(struct dax_region *dax_region, void (*sync)(struct device *dev));
+
 #endif /* __DEVICE_DAX_H__ */
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 37be5a306c8f..5341760cc987 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -523,6 +523,24 @@ static int dax_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+void dax_set_sync(struct dax_region *dax_region, void (*sync)(struct device *))
+{
+	dax_region->sync = sync;
+}
+EXPORT_SYMBOL_GPL(dax_set_sync);
+
+static int dax_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
+{
+	struct dev_dax *dev_dax = filp->private_data;
+	struct dax_region *dax_region = dev_dax->region;
+
+	if (!dax_region->sync)
+		return -EOPNOTSUPP;
+
+	dax_region->sync(dax_region->dev);
+	return 0;
+}
+
 static const struct file_operations dax_fops = {
 	.llseek = noop_llseek,
 	.owner = THIS_MODULE,
@@ -530,6 +548,7 @@ static const struct file_operations dax_fops = {
 	.release = dax_release,
 	.get_unmapped_area = dax_get_unmapped_area,
 	.mmap = dax_mmap,
+	.fsync = dax_fsync,
 };
 
 static void dev_dax_release(struct device *dev)
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index fd49b24fd6af..2b47b4dd2671 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -57,6 +57,14 @@ static void dax_pmem_percpu_kill(void *data)
 	percpu_ref_kill(ref);
 }
 
+static void dax_pmem_sync(struct device *dev)
+{
+	struct nd_namespace_common *ndns;
+
+	ndns = to_ndns(dev);
+	nvdimm_flush(to_nd_region(ndns->dev.parent));
+}
+
 static int dax_pmem_probe(struct device *dev)
 {
 	void *addr;
@@ -133,6 +141,8 @@ static int dax_pmem_probe(struct device *dev)
 	if (!dax_region)
 		return -ENOMEM;
 
+	dax_set_sync(dax_region, dax_pmem_sync);
+
 	/* TODO: support for subdividing a dax region... */
 	dev_dax = devm_create_dev_dax(dax_region, id, &res, 1);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
