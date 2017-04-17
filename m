Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E61DF21939239
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:15:00 -0700 (PDT)
Subject: [resend PATCH v2 05/33] pmem: add dax_operations support
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:09:16 -0700
Message-ID: <149245615669.10206.5525594166204113189.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Setup a dax_device to have the same lifetime as the pmem block device
and add a ->direct_access() method that is equivalent to
pmem_direct_access(). Once fs/dax.c has been converted to use
dax_operations the old pmem_direct_access() will be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.h               |    7 ----
 drivers/nvdimm/Kconfig          |    1 +
 drivers/nvdimm/pmem.c           |   61 +++++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.h           |    7 +++-
 include/linux/dax.h             |    6 ++++
 tools/testing/nvdimm/pmem-dax.c |   21 ++++++-------
 6 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index 617bbc24be2b..f9e5feea742c 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,13 +13,6 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct dax_device;
-struct dax_operations;
-struct dax_device *alloc_dax(void *private, const char *host,
-		const struct dax_operations *ops);
-void put_dax(struct dax_device *dax_dev);
-bool dax_alive(struct dax_device *dax_dev);
-void kill_dax(struct dax_device *dax_dev);
 struct dax_device *inode_dax(struct inode *inode);
 struct inode *dax_inode(struct dax_device *dax_dev);
-void *dax_get_private(struct dax_device *dax_dev);
 #endif /* __DAX_H__ */
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
index 5b536be5a12e..fbbcf8154eec 100644
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
@@ -199,13 +200,13 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 }
 
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
-__weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void **kaddr, pfn_t *pfn, long size)
+__weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
+					PFN_PHYS(nr_pages))))
 		return -EIO;
 	*kaddr = pmem->virt_addr + offset;
 	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
@@ -215,26 +216,51 @@ __weak long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	 * requested range.
 	 */
 	if (unlikely(pmem->bb.count))
-		return size;
-	return pmem->size - pmem->pfn_pad - offset;
+		return nr_pages;
+	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
+}
+
+static long pmem_blk_direct_access(struct block_device *bdev, sector_t sector,
+		void **kaddr, pfn_t *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_queue->queuedata;
+
+	return __pmem_direct_access(pmem, PHYS_PFN(sector * 512),
+			PHYS_PFN(size), kaddr, pfn);
 }
 
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_direct_access,
+	.direct_access =	pmem_blk_direct_access,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
+static long pmem_dax_direct_access(struct dax_device *dax_dev,
+		pgoff_t pgoff, long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	struct pmem_device *pmem = dax_get_private(dax_dev);
+
+	return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
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
+	kill_dax(pmem->dax_dev);
+	put_dax(pmem->dax_dev);
+	del_gendisk(pmem->disk);
+	put_disk(pmem->disk);
 }
 
 static int pmem_attach_disk(struct device *dev,
@@ -245,6 +271,7 @@ static int pmem_attach_disk(struct device *dev,
 	struct vmem_altmap __altmap, *altmap = NULL;
 	struct resource *res = &nsio->res;
 	struct nd_pfn *nd_pfn = NULL;
+	struct dax_device *dax_dev;
 	int nid = dev_to_node(dev);
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
@@ -325,6 +352,7 @@ static int pmem_attach_disk(struct device *dev,
 	disk = alloc_disk_node(0, nid);
 	if (!disk)
 		return -ENOMEM;
+	pmem->disk = disk;
 
 	disk->fops		= &pmem_fops;
 	disk->queue		= q;
@@ -336,9 +364,16 @@ static int pmem_attach_disk(struct device *dev,
 		return -ENOMEM;
 	nvdimm_badblocks_populate(nd_region, &pmem->bb, res);
 	disk->bb = &pmem->bb;
-	device_add_disk(dev, disk);
 
-	if (devm_add_action_or_reset(dev, pmem_release_disk, disk))
+	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops);
+	if (!dax_dev) {
+		put_disk(disk);
+		return -ENOMEM;
+	}
+	pmem->dax_dev = dax_dev;
+
+	device_add_disk(dev, disk);
+	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
 	revalidate_disk(disk);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index b4ee4f71b4a1..7f4dbd72a90a 100644
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
+	struct dax_device	*dax_dev;
+	struct gendisk		*disk;
 };
+
+long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn);
 #endif /* __NVDIMM_PMEM_H__ */
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 74ebb92b625a..39a0312c45c3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -21,6 +21,12 @@ struct dax_operations {
 int dax_read_lock(void);
 void dax_read_unlock(int id);
 struct dax_device *dax_get_by_host(const char *host);
+struct dax_device *alloc_dax(void *private, const char *host,
+		const struct dax_operations *ops);
+void put_dax(struct dax_device *dax_dev);
+bool dax_alive(struct dax_device *dax_dev);
+void kill_dax(struct dax_device *dax_dev);
+void *dax_get_private(struct dax_device *dax_dev);
 
 /*
  * We use lowest available bit in exceptional entry for locking, one bit for
diff --git a/tools/testing/nvdimm/pmem-dax.c b/tools/testing/nvdimm/pmem-dax.c
index c9b8c48f85fc..b53596ad601b 100644
--- a/tools/testing/nvdimm/pmem-dax.c
+++ b/tools/testing/nvdimm/pmem-dax.c
@@ -15,13 +15,13 @@
 #include <pmem.h>
 #include <nd.h>
 
-long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
+long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
+		long nr_pages, void **kaddr, pfn_t *pfn)
 {
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-	resource_size_t offset = sector * 512 + pmem->data_offset;
+	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
 
-	if (unlikely(is_bad_pmem(&pmem->bb, sector, size)))
+	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
+					PFN_PHYS(nr_pages))))
 		return -EIO;
 
 	/*
@@ -34,11 +34,10 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 		*kaddr = pmem->virt_addr + offset;
 		page = vmalloc_to_page(pmem->virt_addr + offset);
 		*pfn = page_to_pfn_t(page);
-		dev_dbg_ratelimited(disk_to_dev(bdev->bd_disk)->parent,
-				"%s: sector: %#llx pfn: %#lx\n", __func__,
-				(unsigned long long) sector, page_to_pfn(page));
+		pr_debug_ratelimited("%s: pmem: %p pgoff: %#lx pfn: %#lx\n",
+				__func__, pmem, pgoff, page_to_pfn(page));
 
-		return PAGE_SIZE;
+		return 1;
 	}
 
 	*kaddr = pmem->virt_addr + offset;
@@ -49,6 +48,6 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 	 * requested range.
 	 */
 	if (unlikely(pmem->bb.count))
-		return size;
-	return pmem->size - pmem->pfn_pad - offset;
+		return nr_pages;
+	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
