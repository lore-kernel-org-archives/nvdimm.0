Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 956378200D
 for <linux-nvdimm@lists.01.org>; Sat, 28 Jan 2017 00:40:37 -0800 (PST)
Subject: [RFC PATCH 05/17] pmem: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Jan 2017 00:36:31 -0800
Message-ID: <148559259117.11180.1457266167792742944.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Setup a dax_inode to have the same lifetime as the pmem block device and
add a ->direct_access() method that is equivalent to
pmem_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old pmem_direct_access() will be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.h               |    7 -----
 drivers/nvdimm/Kconfig          |    1 +
 drivers/nvdimm/pmem.c           |   55 +++++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.h           |    7 ++++-
 include/linux/dax.h             |    6 ++++
 tools/testing/nvdimm/pmem-dax.c |   12 ++++-----
 6 files changed, 61 insertions(+), 27 deletions(-)

diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index aeb1d49aafb8..b4c686d2d446 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,15 +13,8 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct dax_inode;
-struct dax_operations;
-struct dax_inode *alloc_dax_inode(void *private, const char *host,
-		const struct dax_operations *ops);
-void put_dax_inode(struct dax_inode *dax_inode);
-bool dax_inode_alive(struct dax_inode *dax_inode);
-void kill_dax_inode(struct dax_inode *dax_inode);
 struct dax_inode *inode_to_dax_inode(struct inode *inode);
 struct inode *dax_inode_to_inode(struct dax_inode *dax_inode);
-void *dax_inode_get_private(struct dax_inode *dax_inode);
 int dax_inode_register(struct dax_inode *dax_inode,
 		const struct file_operations *fops, struct module *owner,
 		struct kobject *parent);
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 59e750183b7f..5bdd499b5f4f 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -20,6 +20,7 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
+	select DAX
 	select ND_BTT if BTT
 	select ND_PFN if NVDIMM_PFN
 	help
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 5b536be5a12e..d3d7de645e20 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -28,6 +28,7 @@
 #include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
+#include <linux/dax.h>
 #include <linux/nd.h>
 #include "pmem.h"
 #include "pfn.h"
@@ -199,13 +200,12 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
-__weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void **kaddr, pfn_t *pfn, long size)
+__weak long __pmem_direct_access(struct pmem_device *pmem, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size)
 {
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	resource_size_t offset = dev_addr + pmem->data_offset;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+	if (unlikely(is_bad_pmem(&pmem->bb, dev_addr / 512, size)))
 		return -EIO;
 	*kaddr = pmem->virt_addr + offset;
 	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
@@ -219,22 +219,46 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	return pmem->size - pmem->pfn_pad - offset;
 }
 
+static long pmem_blk_direct_access(struct block_device *bdev, sector_t sector,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_queue->queuedata;
+
+	return __pmem_direct_access(pmem, sector * 512, kaddr, pfn, size);
+}
+
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_direct_access,
+	.direct_access =	pmem_blk_direct_access,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
+static long pmem_dax_direct_access(struct dax_inode *dax_inode,
+		phys_addr_t dev_addr, void **kaddr, pfn_t *pfn, long size)
+{
+	struct pmem_device *pmem = dax_inode_get_private(dax_inode);
+
+	return __pmem_direct_access(pmem, dev_addr, kaddr, pfn, size);
+}
+
+static const struct dax_operations pmem_dax_ops = {
+	.direct_access = pmem_dax_direct_access,
+};
+
 static void pmem_release_queue(void *q)
 {
 	blk_cleanup_queue(q);
 }
 
-static void pmem_release_disk(void *disk)
+static void pmem_release_disk(void *__pmem)
 {
-	del_gendisk(disk);
-	put_disk(disk);
+	struct pmem_device *pmem = __pmem;
+
+	kill_dax_inode(pmem->dax_inode);
+	put_dax_inode(pmem->dax_inode);
+	del_gendisk(pmem->disk);
+	put_disk(pmem->disk);
 }
 
 static int pmem_attach_disk(struct device *dev,
@@ -245,6 +269,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct vmem_altmap __altmap, *altmap = NULL;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
+	struct dax_inode *dax_inode;
 	int nid = dev_to_node(dev);
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
@@ -325,6 +350,7 @@ static int pmem_attach_disk(struct device *dev,
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
 		return -ENOMEM;
+	pmem->disk = disk;
 
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
@@ -336,9 +362,16 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, res);
 	disk->bb = &pmem->bb;
-	device_add_disk(dev, disk);
 
-	if (devm_add_action_or_reset(dev, pmem_release_disk, disk))
+	dax_inode = alloc_dax_inode(pmem, disk->disk_name, &pmem_dax_ops);
+	if (!dax_inode) {
+		put_disk(disk);
+		return -ENOMEM;
+	}
+	pmem->dax_inode = dax_inode;
+
+	device_add_disk(dev, disk);
+	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
 	revalidate_disk(disk);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index b4ee4f71b4a1..a26ade213eb5 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -5,8 +5,6 @@
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
 
-long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void **kaddr, pfn_t *pfn, long size);
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
 	/* One contiguous memory region per device */
@@ -20,5 +18,10 @@ struct pmem_device {
 	/* trim size when namespace capacity has been section aligned */
 	u32			pfn_pad;
 	struct badblocks	bb;
+	struct dax_inode	*dax_inode;
+	struct gendisk		*disk;
 };
+
+long __pmem_direct_access(struct pmem_device *pmem, phys_addr_t dev_addr,
+		void **kaddr, pfn_t *pfn, long size);
 #endif /* __NVDIMM_PMEM_H__ */
diff --git a/include/linux/dax.h b/include/linux/dax.h
index def9a9d118c9..5aa620e8e5a2 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -16,6 +16,12 @@ struct dax_operations {
 int dax_read_lock(void);
 void dax_read_unlock(int id);
 struct dax_inode *dax_get_by_host(const char *host);
+struct dax_inode *alloc_dax_inode(void *private, const char *host,
+		const struct dax_operations *ops);
+void *dax_inode_get_private(struct dax_inode *dax_inode);
+void put_dax_inode(struct dax_inode *dax_inode);
+bool dax_inode_alive(struct dax_inode *dax_inode);
+void kill_dax_inode(struct dax_inode *dax_inode);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index c9b8c48f85fc..2c93836c169e 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -15,13 +15,12 @@
 #include <pmem.h>
 #include <nd.h>
 
-long pmem_direct_access(struct block_device *bdev, sector_t sector,
+long __pmem_direct_access(struct pmem_device *pmem, phys_addr_t dev_addr,
 		void **kaddr, pfn_t *pfn, long size)
 {
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	resource_size_t offset = dev_addr + pmem->data_offset;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+	if (unlikely(is_bad_pmem(&pmem->bb, dev_addr / 512, size)))
 		return -EIO;
 
 	/*
@@ -34,9 +33,8 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		*kaddr = pmem->virt_addr + offset;
 		page = vmalloc_to_page(pmem->virt_addr + offset);
 		*pfn = page_to_pfn_t(page);
-		dev_dbg_ratelimited(disk_to_dev(bdev->bd_disk)->parent,
-				"%s: sector: %#llx pfn: %#lx\n", __func__,
-				(unsigned long long) sector, page_to_pfn(page));
+		pr_debug_ratelimited("%s: pmem: %p dev_addr: %pa pfn: %#lx\n",
+				__func__, pmem, &dev_addr, page_to_pfn(page));
 
 		return PAGE_SIZE;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
