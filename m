Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/6] pmem: Initial version of persistent memory driver
Date: Mon, 16 Mar 2015 15:12:55 -0600
Message-Id: <1426540380-24503-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

PMEM is a new driver that presents a reserved range of memory as a
block device.  This is useful for developing with NV-DIMMs, and
can be used with volatile memory as a development platform.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk
Cc: hch@infradead.org
Cc: riel@redhat.com
---
 MAINTAINERS            |   6 +
 drivers/block/Kconfig  |  41 ++++++
 drivers/block/Makefile |   1 +
 drivers/block/pmem.c   | 330 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 378 insertions(+)
 create mode 100644 drivers/block/pmem.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 6239a30..9414b42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8052,6 +8052,12 @@ S:	Maintained
 F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
+PERSISTENT MEMORY DRIVER
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+L:	linux-nvdimm@lists.01.org
+S:	Supported
+F:	drivers/block/pmem.c
+
 RANDOM NUMBER DRIVER
 M:	"Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1b8094d..ac52f5a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -404,6 +404,47 @@ config BLK_DEV_RAM_DAX
 	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
+config BLK_DEV_PMEM
+	tristate "Persistent memory block device support"
+	help
+	  Saying Y here will allow you to use a contiguous range of reserved
+	  memory as one or more block devices.  Memory for PMEM should be
+	  reserved using the "memmap" kernel parameter.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called pmem.
+
+	  Most normal users won't need this functionality, and can thus say N
+	  here.
+
+config BLK_DEV_PMEM_START
+	int "Offset in GiB of where to start claiming space"
+	default "0"
+	depends on BLK_DEV_PMEM
+	help
+	  Starting offset in GiB that PMEM should use when claiming memory.  This
+	  memory needs to be reserved from the OS at boot time using the
+	  "memmap" kernel parameter.
+
+	  If you provide PMEM with volatile memory it will act as a volatile
+	  RAM disk and your data will not be persistent.
+
+config BLK_DEV_PMEM_COUNT
+	int "Default number of PMEM disks"
+	default "4"
+	depends on BLK_DEV_PMEM
+	help
+	  Number of equal sized block devices that PMEM should create.
+
+config BLK_DEV_PMEM_SIZE
+	int "Size in GiB of space to claim"
+	depends on BLK_DEV_PMEM
+	default "0"
+	help
+	  Amount of memory in GiB that PMEM should use when creating block
+	  devices.  This memory needs to be reserved from the OS at
+	  boot time using the "memmap" kernel parameter.
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 02b688d..9cc6c18 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_PS3_VRAM)		+= ps3vram.o
 obj-$(CONFIG_ATARI_FLOPPY)	+= ataflop.o
 obj-$(CONFIG_AMIGA_Z2RAM)	+= z2ram.o
 obj-$(CONFIG_BLK_DEV_RAM)	+= brd.o
+obj-$(CONFIG_BLK_DEV_PMEM)	+= pmem.o
 obj-$(CONFIG_BLK_DEV_LOOP)	+= loop.o
 obj-$(CONFIG_BLK_CPQ_DA)	+= cpqarray.o
 obj-$(CONFIG_BLK_CPQ_CISS_DA)  += cciss.o
diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
new file mode 100644
index 0000000..d366b9b
--- /dev/null
+++ b/drivers/block/pmem.c
@@ -0,0 +1,330 @@
+/*
+ * Persistent Memory Driver
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * This driver is heavily based on drivers/block/brd.c.
+ * Copyright (C) 2007 Nick Piggin
+ * Copyright (C) 2007 Novell Inc.
+ */
+
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/hdreg.h>
+#include <linux/highmem.h>
+#include <linux/init.h>
+#include <linux/major.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#define SECTOR_SHIFT		9
+#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
+
+/*
+ * driver-wide physical address and total_size - one single, contiguous memory
+ * region that we divide up in to same-sized devices
+ */
+phys_addr_t	phys_addr;
+void		*virt_addr;
+size_t		total_size;
+
+struct pmem_device {
+	struct request_queue	*pmem_queue;
+	struct gendisk		*pmem_disk;
+	struct list_head	pmem_list;
+
+	phys_addr_t		phys_addr;
+	void			*virt_addr;
+	size_t			size;
+};
+
+/*
+ * direct translation from (pmem,sector) => void*
+ * We do not require that sector be page aligned.
+ * The return value will point to the beginning of the page containing the
+ * given sector, not to the sector itself.
+ */
+static void *pmem_lookup_pg_addr(struct pmem_device *pmem, sector_t sector)
+{
+	size_t page_offset = sector >> PAGE_SECTORS_SHIFT;
+	size_t offset = page_offset << PAGE_SHIFT;
+
+	BUG_ON(offset >= pmem->size);
+	return pmem->virt_addr + offset;
+}
+
+/*
+ * sector is not required to be page aligned.
+ * n is at most a single page, but could be less.
+ */
+static void copy_to_pmem(struct pmem_device *pmem, const void *src,
+			sector_t sector, size_t n)
+{
+	void *dst;
+	unsigned int offset = (sector & (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
+	size_t copy;
+
+	BUG_ON(n > PAGE_SIZE);
+
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
+	dst = pmem_lookup_pg_addr(pmem, sector);
+	memcpy(dst + offset, src, copy);
+
+	if (copy < n) {
+		src += copy;
+		sector += copy >> SECTOR_SHIFT;
+		copy = n - copy;
+		dst = pmem_lookup_pg_addr(pmem, sector);
+		memcpy(dst, src, copy);
+	}
+}
+
+/*
+ * sector is not required to be page aligned.
+ * n is at most a single page, but could be less.
+ */
+static void copy_from_pmem(void *dst, struct pmem_device *pmem,
+			  sector_t sector, size_t n)
+{
+	void *src;
+	unsigned int offset = (sector & (PAGE_SECTORS - 1)) << SECTOR_SHIFT;
+	size_t copy;
+
+	BUG_ON(n > PAGE_SIZE);
+
+	copy = min_t(size_t, n, PAGE_SIZE - offset);
+	src = pmem_lookup_pg_addr(pmem, sector);
+
+	memcpy(dst, src + offset, copy);
+
+	if (copy < n) {
+		dst += copy;
+		sector += copy >> SECTOR_SHIFT;
+		copy = n - copy;
+		src = pmem_lookup_pg_addr(pmem, sector);
+		memcpy(dst, src, copy);
+	}
+}
+
+static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
+			unsigned int len, unsigned int off, int rw,
+			sector_t sector)
+{
+	void *mem = kmap_atomic(page);
+
+	if (rw == READ) {
+		copy_from_pmem(mem + off, pmem, sector, len);
+		flush_dcache_page(page);
+	} else {
+		/*
+		 * FIXME: Need more involved flushing to ensure that writes to
+		 * NVDIMMs are actually durable before returning.
+		 */
+		flush_dcache_page(page);
+		copy_to_pmem(pmem, mem + off, sector, len);
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
+	sector = bio->bi_iter.bi_sector;
+	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk)) {
+		err = -EIO;
+		goto out;
+	}
+
+	BUG_ON(bio->bi_rw & REQ_DISCARD);
+
+	rw = bio_rw(bio);
+	if (rw == READA)
+		rw = READ;
+
+	bio_for_each_segment(bvec, bio, iter) {
+		unsigned int len = bvec.bv_len;
+
+		BUG_ON(len > PAGE_SIZE);
+		pmem_do_bvec(pmem, bvec.bv_page, len,
+			    bvec.bv_offset, rw, sector);
+		sector += len >> SECTOR_SHIFT;
+	}
+
+out:
+	bio_endio(bio, err);
+}
+
+static const struct block_device_operations pmem_fops = {
+	.owner =		THIS_MODULE,
+};
+
+/* Kernel module stuff */
+static int pmem_start_gb = CONFIG_BLK_DEV_PMEM_START;
+module_param(pmem_start_gb, int, S_IRUGO);
+MODULE_PARM_DESC(pmem_start_gb, "Offset in GB of where to start claiming space");
+
+static int pmem_size_gb = CONFIG_BLK_DEV_PMEM_SIZE;
+module_param(pmem_size_gb,  int, S_IRUGO);
+MODULE_PARM_DESC(pmem_size_gb,  "Total size in GB of space to claim for all disks");
+
+static int pmem_count = CONFIG_BLK_DEV_PMEM_COUNT;
+module_param(pmem_count, int, S_IRUGO);
+MODULE_PARM_DESC(pmem_count, "Number of pmem devices to evenly split allocated space");
+
+static LIST_HEAD(pmem_devices);
+static int pmem_major;
+
+/* FIXME: move phys_addr, virt_addr, size calls up to caller */
+static struct pmem_device *pmem_alloc(int i)
+{
+	struct pmem_device *pmem;
+	struct gendisk *disk;
+	size_t disk_size = total_size / pmem_count;
+	size_t disk_sectors = disk_size / 512;
+
+	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
+	if (!pmem)
+		goto out;
+
+	pmem->phys_addr = phys_addr + i * disk_size;
+	pmem->virt_addr = virt_addr + i * disk_size;
+	pmem->size = disk_size;
+
+	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!pmem->pmem_queue)
+		goto out_free_dev;
+
+	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
+	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
+	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+
+	disk = pmem->pmem_disk = alloc_disk(0);
+	if (!disk)
+		goto out_free_queue;
+	disk->major		= pmem_major;
+	disk->first_minor	= 0;
+	disk->fops		= &pmem_fops;
+	disk->private_data	= pmem;
+	disk->queue		= pmem->pmem_queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	sprintf(disk->disk_name, "pmem%d", i);
+	set_capacity(disk, disk_sectors);
+
+	return pmem;
+
+out_free_queue:
+	blk_cleanup_queue(pmem->pmem_queue);
+out_free_dev:
+	kfree(pmem);
+out:
+	return NULL;
+}
+
+static void pmem_free(struct pmem_device *pmem)
+{
+	put_disk(pmem->pmem_disk);
+	blk_cleanup_queue(pmem->pmem_queue);
+	kfree(pmem);
+}
+
+static void pmem_del_one(struct pmem_device *pmem)
+{
+	list_del(&pmem->pmem_list);
+	del_gendisk(pmem->pmem_disk);
+	pmem_free(pmem);
+}
+
+static int __init pmem_init(void)
+{
+	int result, i;
+	struct resource *res_mem;
+	struct pmem_device *pmem, *next;
+
+	phys_addr  = (phys_addr_t) pmem_start_gb * 1024 * 1024 * 1024;
+	total_size = (size_t)	   pmem_size_gb  * 1024 * 1024 * 1024;
+
+	res_mem = request_mem_region_exclusive(phys_addr, total_size, "pmem");
+	if (!res_mem)
+		return -ENOMEM;
+
+	virt_addr = ioremap_cache(phys_addr, total_size);
+	if (!virt_addr) {
+		result = -ENOMEM;
+		goto out_release;
+	}
+
+	result = register_blkdev(0, "pmem");
+	if (result < 0) {
+		result = -EIO;
+		goto out_unmap;
+	} else
+		pmem_major = result;
+
+	for (i = 0; i < pmem_count; i++) {
+		pmem = pmem_alloc(i);
+		if (!pmem) {
+			result = -ENOMEM;
+			goto out_free;
+		}
+		list_add_tail(&pmem->pmem_list, &pmem_devices);
+	}
+
+	list_for_each_entry(pmem, &pmem_devices, pmem_list)
+		add_disk(pmem->pmem_disk);
+
+	pr_info("pmem: module loaded\n");
+	return 0;
+
+out_free:
+	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list) {
+		list_del(&pmem->pmem_list);
+		pmem_free(pmem);
+	}
+	unregister_blkdev(pmem_major, "pmem");
+
+out_unmap:
+	iounmap(virt_addr);
+
+out_release:
+	release_mem_region(phys_addr, total_size);
+	return result;
+}
+
+static void __exit pmem_exit(void)
+{
+	struct pmem_device *pmem, *next;
+
+	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list)
+		pmem_del_one(pmem);
+
+	unregister_blkdev(pmem_major, "pmem");
+	iounmap(virt_addr);
+	release_mem_region(phys_addr, total_size);
+
+	pr_info("pmem: module unloaded\n");
+}
+
+MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_LICENSE("GPL");
+module_init(pmem_init);
+module_exit(pmem_exit);
-- 
1.9.3

