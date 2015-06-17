Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v7 09/16] libnvdimm, pmem: move pmem to drivers/nvdimm/
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jun 2015 19:14:08 -0400
Message-ID: <20150617231408.11597.28725.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617215027.11597.61414.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Prepare the pmem driver to consume PMEM namespaces emitted by regions of
an nvdimm_bus instance.  No functional change.

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/Kconfig   |   11 --
 drivers/block/Makefile  |    1 
 drivers/block/pmem.c    |  262 -----------------------------------------------
 drivers/nvdimm/Kconfig  |   23 ++++
 drivers/nvdimm/Makefile |    3 +
 drivers/nvdimm/pmem.c   |  262 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 287 insertions(+), 275 deletions(-)
 delete mode 100644 drivers/block/pmem.c
 create mode 100644 drivers/nvdimm/pmem.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index eb1fed5bd516..1b8094d4d7af 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -404,17 +404,6 @@ config BLK_DEV_RAM_DAX
 	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
-config BLK_DEV_PMEM
-	tristate "Persistent memory block device support"
-	help
-	  Saying Y here will allow you to use a contiguous range of reserved
-	  memory as one or more persistent block devices.
-
-	  To compile this driver as a module, choose M here: the module will be
-	  called 'pmem'.
-
-	  If unsure, say N.
-
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 9cc6c18a1c7e..02b688d1438d 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_PS3_VRAM)		+= ps3vram.o
 obj-$(CONFIG_ATARI_FLOPPY)	+= ataflop.o
 obj-$(CONFIG_AMIGA_Z2RAM)	+= z2ram.o
 obj-$(CONFIG_BLK_DEV_RAM)	+= brd.o
-obj-$(CONFIG_BLK_DEV_PMEM)	+= pmem.o
 obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
 obj-$(CONFIG_BLK_CPQ_DA)	+= cpqarray.o
 obj-$(CONFIG_BLK_CPQ_CISS_DA)  += cciss.o
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
deleted file mode 100644
index eabf4a8d0085..000000000000
--- a/drivers/block/pmem.c
+++ /dev/null
@@ -1,262 +0,0 @@
-/*
- * Persistent Memory Driver
- *
- * Copyright (c) 2014, Intel Corporation.
- * Copyright (c) 2015, Christoph Hellwig <hch@lst.de>.
- * Copyright (c) 2015, Boaz Harrosh <boaz@plexistor.com>.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#include <asm/cacheflush.h>
-#include <linux/blkdev.h>
-#include <linux/hdreg.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/slab.h>
-
-#define PMEM_MINORS		16
-
-struct pmem_device {
-	struct request_queue	*pmem_queue;
-	struct gendisk		*pmem_disk;
-
-	/* One contiguous memory region per device */
-	phys_addr_t		phys_addr;
-	void			*virt_addr;
-	size_t			size;
-};
-
-static int pmem_major;
-static atomic_t pmem_index;
-
-static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
-			unsigned int len, unsigned int off, int rw,
-			sector_t sector)
-{
-	void *mem = kmap_atomic(page);
-	size_t pmem_off = sector << 9;
-
-	if (rw == READ) {
-		memcpy(mem + off, pmem->virt_addr + pmem_off, len);
-		flush_dcache_page(page);
-	} else {
-		flush_dcache_page(page);
-		memcpy(pmem->virt_addr + pmem_off, mem + off, len);
-	}
-
-	kunmap_atomic(mem);
-}
-
-static void pmem_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct block_device *bdev = bio->bi_bdev;
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
-	int rw;
-	struct bio_vec bvec;
-	sector_t sector;
-	struct bvec_iter iter;
-	int err = 0;
-
-	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
-		err = -EIO;
-		goto out;
-	}
-
-	BUG_ON(bio->bi_rw & REQ_DISCARD);
-
-	rw = bio_data_dir(bio);
-	sector = bio->bi_iter.bi_sector;
-	bio_for_each_segment(bvec, bio, iter) {
-		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
-			     rw, sector);
-		sector += bvec.bv_len >> 9;
-	}
-
-out:
-	bio_endio(bio, err);
-}
-
-static int pmem_rw_page(struct block_device *bdev, sector_t sector,
-		       struct page *page, int rw)
-{
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
-
-	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
-	page_endio(page, rw & WRITE, 0);
-
-	return 0;
-}
-
-static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-			      void **kaddr, unsigned long *pfn, long size)
-{
-	struct pmem_device *pmem = bdev->bd_disk->private_data;
-	size_t offset = sector << 9;
-
-	if (!pmem)
-		return -ENODEV;
-
-	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
-
-	return pmem->size - offset;
-}
-
-static const struct block_device_operations pmem_fops = {
-	.owner =		THIS_MODULE,
-	.rw_page =		pmem_rw_page,
-	.direct_access =	pmem_direct_access,
-};
-
-static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
-{
-	struct pmem_device *pmem;
-	struct gendisk *disk;
-	int idx, err;
-
-	err = -ENOMEM;
-	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
-	if (!pmem)
-		goto out;
-
-	pmem->phys_addr = res->start;
-	pmem->size = resource_size(res);
-
-	err = -EINVAL;
-	if (!request_mem_region(pmem->phys_addr, pmem->size, "pmem")) {
-		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n", &pmem->phys_addr, pmem->size);
-		goto out_free_dev;
-	}
-
-	/*
-	 * Map the memory as non-cachable, as we can't write back the contents
-	 * of the CPU caches in case of a crash.
-	 */
-	err = -ENOMEM;
-	pmem->virt_addr = ioremap_nocache(pmem->phys_addr, pmem->size);
-	if (!pmem->virt_addr)
-		goto out_release_region;
-
-	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
-	if (!pmem->pmem_queue)
-		goto out_unmap;
-
-	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
-	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
-	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
-
-	disk = alloc_disk(PMEM_MINORS);
-	if (!disk)
-		goto out_free_queue;
-
-	idx = atomic_inc_return(&pmem_index) - 1;
-
-	disk->major		= pmem_major;
-	disk->first_minor	= PMEM_MINORS * idx;
-	disk->fops		= &pmem_fops;
-	disk->private_data	= pmem;
-	disk->queue		= pmem->pmem_queue;
-	disk->flags		= GENHD_FL_EXT_DEVT;
-	sprintf(disk->disk_name, "pmem%d", idx);
-	disk->driverfs_dev = dev;
-	set_capacity(disk, pmem->size >> 9);
-	pmem->pmem_disk = disk;
-
-	add_disk(disk);
-
-	return pmem;
-
-out_free_queue:
-	blk_cleanup_queue(pmem->pmem_queue);
-out_unmap:
-	iounmap(pmem->virt_addr);
-out_release_region:
-	release_mem_region(pmem->phys_addr, pmem->size);
-out_free_dev:
-	kfree(pmem);
-out:
-	return ERR_PTR(err);
-}
-
-static void pmem_free(struct pmem_device *pmem)
-{
-	del_gendisk(pmem->pmem_disk);
-	put_disk(pmem->pmem_disk);
-	blk_cleanup_queue(pmem->pmem_queue);
-	iounmap(pmem->virt_addr);
-	release_mem_region(pmem->phys_addr, pmem->size);
-	kfree(pmem);
-}
-
-static int pmem_probe(struct platform_device *pdev)
-{
-	struct pmem_device *pmem;
-	struct resource *res;
-
-	if (WARN_ON(pdev->num_resources > 1))
-		return -ENXIO;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	pmem = pmem_alloc(&pdev->dev, res);
-	if (IS_ERR(pmem))
-		return PTR_ERR(pmem);
-
-	platform_set_drvdata(pdev, pmem);
-
-	return 0;
-}
-
-static int pmem_remove(struct platform_device *pdev)
-{
-	struct pmem_device *pmem = platform_get_drvdata(pdev);
-
-	pmem_free(pmem);
-	return 0;
-}
-
-static struct platform_driver pmem_driver = {
-	.probe		= pmem_probe,
-	.remove		= pmem_remove,
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "pmem",
-	},
-};
-
-static int __init pmem_init(void)
-{
-	int error;
-
-	pmem_major = register_blkdev(0, "pmem");
-	if (pmem_major < 0)
-		return pmem_major;
-
-	error = platform_driver_register(&pmem_driver);
-	if (error)
-		unregister_blkdev(pmem_major, "pmem");
-	return error;
-}
-module_init(pmem_init);
-
-static void pmem_exit(void)
-{
-	platform_driver_unregister(&pmem_driver);
-	unregister_blkdev(pmem_major, "pmem");
-}
-module_exit(pmem_exit);
-
-MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 92933551f846..07a29113b870 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -1,4 +1,4 @@
-config LIBNVDIMM
+menuconfig LIBNVDIMM
 	tristate "NVDIMM (Non-Volatile Memory Device) Support"
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
@@ -13,3 +13,24 @@ config LIBNVDIMM
 	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
 	  region which exposes an mmio register set for windowed
 	  access mode to non-volatile memory.
+
+if LIBNVDIMM
+
+config BLK_DEV_PMEM
+	tristate "PMEM: Persistent memory block device support"
+	default LIBNVDIMM
+	depends on HAS_IOMEM
+	help
+	  Memory ranges for PMEM are described by either an NFIT
+	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
+	  non-standard OEM-specific E820 memory type (type-12, see
+	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
+	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
+	  Documentation/kernel-parameters.txt).  This driver converts
+	  these persistent memory ranges into block devices that are
+	  capable of DAX (direct-access) file system mappings.  See
+	  Documentation/nvdimm/nvdimm.txt for more details.
+
+	  Say Y if you want to use an NVDIMM
+
+endif
diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
index af5e2760ddbd..4d2a27f52faa 100644
--- a/drivers/nvdimm/Makefile
+++ b/drivers/nvdimm/Makefile
@@ -1,4 +1,7 @@
 obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
+obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
+
+nd_pmem-y := pmem.o
 
 libnvdimm-y := core.o
 libnvdimm-y += bus.o
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
new file mode 100644
index 000000000000..eabf4a8d0085
--- /dev/null
+++ b/drivers/nvdimm/pmem.c
@@ -0,0 +1,262 @@
+/*
+ * Persistent Memory Driver
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ * Copyright (c) 2015, Christoph Hellwig <hch@lst.de>.
+ * Copyright (c) 2015, Boaz Harrosh <boaz@plexistor.com>.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <asm/cacheflush.h>
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+
+#define PMEM_MINORS		16
+
+struct pmem_device {
+	struct request_queue	*pmem_queue;
+	struct gendisk		*pmem_disk;
+
+	/* One contiguous memory region per device */
+	phys_addr_t		phys_addr;
+	void			*virt_addr;
+	size_t			size;
+};
+
+static int pmem_major;
+static atomic_t pmem_index;
+
+static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
+			unsigned int len, unsigned int off, int rw,
+			sector_t sector)
+{
+	void *mem = kmap_atomic(page);
+	size_t pmem_off = sector << 9;
+
+	if (rw == READ) {
+		memcpy(mem + off, pmem->virt_addr + pmem_off, len);
+		flush_dcache_page(page);
+	} else {
+		flush_dcache_page(page);
+		memcpy(pmem->virt_addr + pmem_off, mem + off, len);
+	}
+
+	kunmap_atomic(mem);
+}
+
+static void pmem_make_request(struct request_queue *q, struct bio *bio)
+{
+	struct block_device *bdev = bio->bi_bdev;
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	int rw;
+	struct bio_vec bvec;
+	sector_t sector;
+	struct bvec_iter iter;
+	int err = 0;
+
+	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUG_ON(bio->bi_rw & REQ_DISCARD);
+
+	rw = bio_data_dir(bio);
+	sector = bio->bi_iter.bi_sector;
+	bio_for_each_segment(bvec, bio, iter) {
+		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
+			     rw, sector);
+		sector += bvec.bv_len >> 9;
+	}
+
+out:
+	bio_endio(bio, err);
+}
+
+static int pmem_rw_page(struct block_device *bdev, sector_t sector,
+		       struct page *page, int rw)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+
+	pmem_do_bvec(pmem, page, PAGE_CACHE_SIZE, 0, rw, sector);
+	page_endio(page, rw & WRITE, 0);
+
+	return 0;
+}
+
+static long pmem_direct_access(struct block_device *bdev, sector_t sector,
+			      void **kaddr, unsigned long *pfn, long size)
+{
+	struct pmem_device *pmem = bdev->bd_disk->private_data;
+	size_t offset = sector << 9;
+
+	if (!pmem)
+		return -ENODEV;
+
+	*kaddr = pmem->virt_addr + offset;
+	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+
+	return pmem->size - offset;
+}
+
+static const struct block_device_operations pmem_fops = {
+	.owner =		THIS_MODULE,
+	.rw_page =		pmem_rw_page,
+	.direct_access =	pmem_direct_access,
+};
+
+static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
+{
+	struct pmem_device *pmem;
+	struct gendisk *disk;
+	int idx, err;
+
+	err = -ENOMEM;
+	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
+	if (!pmem)
+		goto out;
+
+	pmem->phys_addr = res->start;
+	pmem->size = resource_size(res);
+
+	err = -EINVAL;
+	if (!request_mem_region(pmem->phys_addr, pmem->size, "pmem")) {
+		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n", &pmem->phys_addr, pmem->size);
+		goto out_free_dev;
+	}
+
+	/*
+	 * Map the memory as non-cachable, as we can't write back the contents
+	 * of the CPU caches in case of a crash.
+	 */
+	err = -ENOMEM;
+	pmem->virt_addr = ioremap_nocache(pmem->phys_addr, pmem->size);
+	if (!pmem->virt_addr)
+		goto out_release_region;
+
+	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!pmem->pmem_queue)
+		goto out_unmap;
+
+	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
+	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
+	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+
+	disk = alloc_disk(PMEM_MINORS);
+	if (!disk)
+		goto out_free_queue;
+
+	idx = atomic_inc_return(&pmem_index) - 1;
+
+	disk->major		= pmem_major;
+	disk->first_minor	= PMEM_MINORS * idx;
+	disk->fops		= &pmem_fops;
+	disk->private_data	= pmem;
+	disk->queue		= pmem->pmem_queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	sprintf(disk->disk_name, "pmem%d", idx);
+	disk->driverfs_dev = dev;
+	set_capacity(disk, pmem->size >> 9);
+	pmem->pmem_disk = disk;
+
+	add_disk(disk);
+
+	return pmem;
+
+out_free_queue:
+	blk_cleanup_queue(pmem->pmem_queue);
+out_unmap:
+	iounmap(pmem->virt_addr);
+out_release_region:
+	release_mem_region(pmem->phys_addr, pmem->size);
+out_free_dev:
+	kfree(pmem);
+out:
+	return ERR_PTR(err);
+}
+
+static void pmem_free(struct pmem_device *pmem)
+{
+	del_gendisk(pmem->pmem_disk);
+	put_disk(pmem->pmem_disk);
+	blk_cleanup_queue(pmem->pmem_queue);
+	iounmap(pmem->virt_addr);
+	release_mem_region(pmem->phys_addr, pmem->size);
+	kfree(pmem);
+}
+
+static int pmem_probe(struct platform_device *pdev)
+{
+	struct pmem_device *pmem;
+	struct resource *res;
+
+	if (WARN_ON(pdev->num_resources > 1))
+		return -ENXIO;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	pmem = pmem_alloc(&pdev->dev, res);
+	if (IS_ERR(pmem))
+		return PTR_ERR(pmem);
+
+	platform_set_drvdata(pdev, pmem);
+
+	return 0;
+}
+
+static int pmem_remove(struct platform_device *pdev)
+{
+	struct pmem_device *pmem = platform_get_drvdata(pdev);
+
+	pmem_free(pmem);
+	return 0;
+}
+
+static struct platform_driver pmem_driver = {
+	.probe		= pmem_probe,
+	.remove		= pmem_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "pmem",
+	},
+};
+
+static int __init pmem_init(void)
+{
+	int error;
+
+	pmem_major = register_blkdev(0, "pmem");
+	if (pmem_major < 0)
+		return pmem_major;
+
+	error = platform_driver_register(&pmem_driver);
+	if (error)
+		unregister_blkdev(pmem_major, "pmem");
+	return error;
+}
+module_init(pmem_init);
+
+static void pmem_exit(void)
+{
+	platform_driver_unregister(&pmem_driver);
+	unregister_blkdev(pmem_major, "pmem");
+}
+module_exit(pmem_exit);
+
+MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_LICENSE("GPL v2");

