Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 479492194EB6A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:40:22 -0700 (PDT)
Subject: [PATCH v2 17/33] block: remove block_device_operations
 ->direct_access()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:34:38 -0700
Message-ID: <149222367794.32363.16995632412483706782.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that all the producers and consumers of dax interfaces have been
converted to using dax_operations on a dax_device, remove the block
device direct_access enabling.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/powerpc/sysdev/axonram.c |   23 ++++-----------------
 drivers/block/brd.c           |   15 --------------
 drivers/md/dm.c               |   13 ------------
 drivers/nvdimm/pmem.c         |   10 ---------
 drivers/s390/block/dcssblk.c  |   16 ---------------
 fs/block_dev.c                |   45 -----------------------------------------
 include/linux/blkdev.h        |   17 ---------------
 7 files changed, 4 insertions(+), 135 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ad857d5e81b1..83eb56ff1d2c 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -139,6 +139,10 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+static const struct block_device_operations axon_ram_devops = {
+	.owner		= THIS_MODULE,
+};
+
 static long
 __axon_ram_direct_access(struct axon_ram_bank *bank, pgoff_t pgoff, long nr_pages,
 		       void **kaddr, pfn_t *pfn)
@@ -150,25 +154,6 @@ __axon_ram_direct_access(struct axon_ram_bank *bank, pgoff_t pgoff, long nr_page
 	return (bank->size - offset) / PAGE_SIZE;
 }
 
-/**
- * axon_ram_direct_access - direct_access() method for block device
- * @device, @sector, @data: see block_device_operations method
- */
-static long
-axon_ram_blk_direct_access(struct block_device *device, sector_t sector,
-		       void **kaddr, pfn_t *pfn, long size)
-{
-	struct axon_ram_bank *bank = device->bd_disk->private_data;
-
-	return __axon_ram_direct_access(bank, (sector * 512) / PAGE_SIZE,
-			size / PAGE_SIZE, kaddr, pfn) * PAGE_SIZE;
-}
-
-static const struct block_device_operations axon_ram_devops = {
-	.owner		= THIS_MODULE,
-	.direct_access	= axon_ram_blk_direct_access
-};
-
 static long
 axon_ram_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 		       void **kaddr, pfn_t *pfn)
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 60f3193c9ce2..bfa4ed2c75ef 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -395,18 +395,6 @@ static long __brd_direct_access(struct brd_device *brd, pgoff_t pgoff,
 	return 1;
 }
 
-static long brd_blk_direct_access(struct block_device *bdev, sector_t sector,
-			void **kaddr, pfn_t *pfn, long size)
-{
-	struct brd_device *brd = bdev->bd_disk->private_data;
-	long nr_pages = __brd_direct_access(brd, PHYS_PFN(sector * 512),
-			PHYS_PFN(size), kaddr, pfn);
-
-	if (nr_pages < 0)
-		return nr_pages;
-	return nr_pages * PAGE_SIZE;
-}
-
 static long brd_dax_direct_access(struct dax_device *dax_dev,
 		pgoff_t pgoff, long nr_pages, void **kaddr, pfn_t *pfn)
 {
@@ -418,14 +406,11 @@ static long brd_dax_direct_access(struct dax_device *dax_dev,
 static const struct dax_operations brd_dax_ops = {
 	.direct_access = brd_dax_direct_access,
 };
-#else
-#define brd_blk_direct_access NULL
 #endif
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		brd_rw_page,
-	.direct_access =	brd_blk_direct_access,
 };
 
 /*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ef4c6f8cad47..79d5f5fd823e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -957,18 +957,6 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	return ret;
 }
 
-static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
-{
-	struct mapped_device *md = bdev->bd_disk->private_data;
-	struct dax_device *dax_dev = md->dax_dev;
-	long nr_pages = size / PAGE_SIZE;
-
-	nr_pages = dm_dax_direct_access(dax_dev, sector / PAGE_SECTORS,
-			nr_pages, kaddr, pfn);
-	return nr_pages < 0 ? nr_pages : nr_pages * PAGE_SIZE;
-}
-
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_PREFLUSH.
@@ -2823,7 +2811,6 @@ static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
-	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fbbcf8154eec..85b85633d674 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -220,19 +220,9 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
 
-static long pmem_blk_direct_access(struct block_device *bdev, sector_t sector,
-		void **kaddr, pfn_t *pfn, long size)
-{
-	struct pmem_device *pmem = bdev->bd_queue->queuedata;
-
-	return __pmem_direct_access(pmem, PHYS_PFN(sector * 512),
-			PHYS_PFN(size), kaddr, pfn);
-}
-
 static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_blk_direct_access,
 	.revalidate_disk =	nvdimm_revalidate_disk,
 };
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 682a9eb4934d..1586e11b979e 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -31,8 +31,6 @@ static int dcssblk_open(struct block_device *bdev, fmode_t mode);
 static void dcssblk_release(struct gendisk *disk, fmode_t mode);
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
-static long dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void **kaddr, pfn_t *pfn, long size);
 static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn);
 
@@ -43,7 +41,6 @@ static const struct block_device_operations dcssblk_devops = {
 	.owner   	= THIS_MODULE,
 	.open    	= dcssblk_open,
 	.release 	= dcssblk_release,
-	.direct_access 	= dcssblk_blk_direct_access,
 };
 
 static const struct dax_operations dcssblk_dax_ops = {
@@ -915,19 +912,6 @@ __dcssblk_direct_access(struct dcssblk_dev_info *dev_info, pgoff_t pgoff,
 }
 
 static long
-dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
-			void **kaddr, pfn_t *pfn, long size)
-{
-	struct dcssblk_dev_info *dev_info;
-
-	dev_info = bdev->bd_disk->private_data;
-	if (!dev_info)
-		return -ENODEV;
-	return __dcssblk_direct_access(dev_info, PHYS_PFN(secnum * 512),
-			PHYS_PFN(size), kaddr, pfn) * PAGE_SIZE;
-}
-
-static long
 dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
 {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ecbdc8f9f718..10e21465d5a9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -718,51 +718,6 @@ int bdev_write_page(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(bdev_write_page);
 
-/**
- * bdev_direct_access() - Get the address for directly-accessibly memory
- * @bdev: The device containing the memory
- * @dax: control and output parameters for ->direct_access
- *
- * If a block device is made up of directly addressable memory, this function
- * will tell the caller the PFN and the address of the memory.  The address
- * may be directly dereferenced within the kernel without the need to call
- * ioremap(), kmap() or similar.  The PFN is suitable for inserting into
- * page tables.
- *
- * Return: negative errno if an error occurs, otherwise the number of bytes
- * accessible at this address.
- */
-long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
-{
-	sector_t sector = dax->sector;
-	long avail, size = dax->size;
-	const struct block_device_operations *ops = bdev->bd_disk->fops;
-
-	/*
-	 * The device driver is allowed to sleep, in order to make the
-	 * memory directly accessible.
-	 */
-	might_sleep();
-
-	if (size < 0)
-		return size;
-	if (!blk_queue_dax(bdev_get_queue(bdev)) || !ops->direct_access)
-		return -EOPNOTSUPP;
-	if ((sector + DIV_ROUND_UP(size, 512)) >
-					part_nr_sects_read(bdev->bd_part))
-		return -ERANGE;
-	sector += get_start_sect(bdev);
-	if (sector % (PAGE_SIZE / 512))
-		return -EINVAL;
-	avail = ops->direct_access(bdev, sector, &dax->addr, &dax->pfn, size);
-	if (!avail)
-		return -ERANGE;
-	if (avail > 0 && avail & ~PAGE_MASK)
-		return -ENXIO;
-	return min(avail, size);
-}
-EXPORT_SYMBOL_GPL(bdev_direct_access);
-
 int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
 		pgoff_t *pgoff)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 612c497d1461..848f87eb1905 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1916,28 +1916,12 @@ static inline bool integrity_req_gap_front_merge(struct request *req,
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-/**
- * struct blk_dax_ctl - control and output parameters for ->direct_access
- * @sector: (input) offset relative to a block_device
- * @addr: (output) kernel virtual address for @sector populated by driver
- * @pfn: (output) page frame number for @addr populated by driver
- * @size: (input) number of bytes requested
- */
-struct blk_dax_ctl {
-	sector_t sector;
-	void *addr;
-	long size;
-	pfn_t pfn;
-};
-
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, bool);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
-	long (*direct_access)(struct block_device *, sector_t, void **, pfn_t *,
-			long);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
@@ -1956,7 +1940,6 @@ extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 extern int bdev_read_page(struct block_device *, sector_t, struct page *);
 extern int bdev_write_page(struct block_device *, sector_t, struct page *,
 						struct writeback_control *);
-extern long bdev_direct_access(struct block_device *, struct blk_dax_ctl *);
 extern int bdev_dax_supported(struct super_block *, int);
 int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
 #else /* CONFIG_BLOCK */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
