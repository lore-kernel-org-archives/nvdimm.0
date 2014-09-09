Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <540F2977.7010006@plexistor.com>
Date: Tue, 09 Sep 2014 19:23:19 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH v2] pmem: Initial version of persistent memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

PMEM is a new driver that presents a reserved range of memory as a
block device.  This is useful for developing with NV-DIMMs, and
can be used with volatile memory as a development platform.

[boaz]
SQUASHME: pmem: Remove unused #include headers
SQUASHME: pmem: Request from fdisk 4k alignment
SQUASHME: pmem: Let each device manage private memory region
SQUASHME: pmem: Support of multiple memory regions

The API to pmem module a single string parameter named "map"
of the form:
		 map=mapS[,mapS...]

		 where mapS=nn[KMG]$ss[KMG],
		 or    mapS=nn[KMG]@ss[KMG],

		 nn=size, ss=offset

Just like the Kernel command line map && memmap parameters,
so anything you did at grub just copy/paste to here.

The "@" form is exactly the same as the "$" form only that
at bash prompt we need to escape the "$" with \$ so also
support the '@' char for convenience.

For each specified mapS there will be a device created.

[This is the accumulated version of the driver developed by
 multiple programmers. To see the real history of these
 patches see:
	git://git.open-osd.org/pmem.git
	https://github.com/01org/prd
 This patch is based on:
	[673302b] pmem: KISS, remove register_blkdev
]

TODO: Add Documentation/blockdev/pmem.txt

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 MAINTAINERS            |   6 +
 drivers/block/Kconfig  |  13 ++
 drivers/block/Makefile |   1 +
 drivers/block/pmem.c   | 385 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 405 insertions(+)
 create mode 100644 drivers/block/pmem.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 5e7866a..2724ede 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7504,6 +7504,12 @@ S:	Maintained
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
index 014a1cf..5da8cbf 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -403,6 +403,19 @@ config BLK_DEV_XIP
 	  will prevent RAM block device backing store memory from being
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
index 0000000..0fcda58
--- /dev/null
+++ b/drivers/block/pmem.c
@@ -0,0 +1,385 @@
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
+#include <linux/blkdev.h>
+#include <linux/hdreg.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+
+#define SECTOR_SHIFT		9
+#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
+
+struct pmem_device {
+	struct request_queue	*pmem_queue;
+	struct gendisk		*pmem_disk;
+	struct list_head	pmem_list;
+
+	/* One contiguous memory region per device */
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
+static char *map;
+module_param(map, charp, S_IRUGO);
+MODULE_PARM_DESC(map,
+	"pmem device mapping: map=mapS[,mapS...] where:\n"
+	"mapS=nn[KMG]$ss[KMG] or mapS=nn[KMG]@ss[KMG], nn=size, ss=offset.");
+
+static LIST_HEAD(pmem_devices);
+static int pmem_major;
+
+/* pmem->phys_addr and pmem->size need to be set.
+ * Will then set virt_addr if successful.
+ */
+int pmem_mapmem(struct pmem_device *pmem)
+{
+	struct resource *res_mem;
+	int err;
+
+	res_mem = request_mem_region_exclusive(pmem->phys_addr, pmem->size,
+					       "pmem");
+	if (!res_mem) {
+		pr_warn("pmem: request_mem_region_exclusive phys=0x%llx size=0x%zx failed\n",
+			   pmem->phys_addr, pmem->size);
+		return -EINVAL;
+	}
+
+	pmem->virt_addr = ioremap_cache(pmem->phys_addr, pmem->size);
+	if (unlikely(!pmem->virt_addr)) {
+		err = -ENXIO;
+		goto out_release;
+	}
+	return 0;
+
+out_release:
+	release_mem_region(pmem->phys_addr, pmem->size);
+	return err;
+}
+
+void pmem_unmapmem(struct pmem_device *pmem)
+{
+	if (unlikely(!pmem->virt_addr))
+		return;
+
+	iounmap(pmem->virt_addr);
+	release_mem_region(pmem->phys_addr, pmem->size);
+	pmem->virt_addr = NULL;
+}
+
+static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
+				      int i)
+{
+	struct pmem_device *pmem;
+	struct gendisk *disk;
+	int err;
+
+	if (unlikely((phys_addr & ~PAGE_MASK) || (disk_size & ~PAGE_MASK))) {
+		pr_err("phys_addr=0x%llx disk_size=0x%zx must be 4k aligned\n",
+		       phys_addr, disk_size);
+		err = -EINVAL;
+		goto out;
+	}
+
+	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
+	if (unlikely(!pmem)) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	pmem->phys_addr = phys_addr;
+	pmem->size = disk_size;
+
+	err = pmem_mapmem(pmem);
+	if (unlikely(err))
+		goto out_free_dev;
+
+	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
+	if (unlikely(!pmem->pmem_queue)) {
+		err = -ENOMEM;
+		goto out_unmap;
+	}
+
+	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
+	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
+	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
+
+	/* This is so fdisk will align partitions on 4k, because of
+	 * direct_access API needing 4k alignment, returning a PFN
+	 */
+	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
+	pmem->pmem_queue->limits.io_min = 512; /* Don't use the accessor */
+
+	disk = alloc_disk(0);
+	if (unlikely(!disk)) {
+		err = -ENOMEM;
+		goto out_free_queue;
+	}
+
+	disk->major		= pmem_major;
+	disk->first_minor	= 0;
+	disk->fops		= &pmem_fops;
+	disk->private_data	= pmem;
+	disk->queue		= pmem->pmem_queue;
+	disk->flags		= GENHD_FL_EXT_DEVT;
+	sprintf(disk->disk_name, "pmem%d", i);
+	set_capacity(disk, disk_size >> SECTOR_SHIFT);
+	pmem->pmem_disk = disk;
+
+	return pmem;
+
+out_free_queue:
+	blk_cleanup_queue(pmem->pmem_queue);
+out_unmap:
+	pmem_unmapmem(pmem);
+out_free_dev:
+	kfree(pmem);
+out:
+	return ERR_PTR(err);
+}
+
+static void pmem_free(struct pmem_device *pmem)
+{
+	put_disk(pmem->pmem_disk);
+	blk_cleanup_queue(pmem->pmem_queue);
+	pmem_unmapmem(pmem);
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
+static int pmem_parse_map_one(char *map, phys_addr_t *start, size_t *size)
+{
+	char *p = map;
+
+	*size = (size_t)memparse(p, &p);
+	if ((p == map) || ((*p != '$') && (*p != '@')))
+		return -EINVAL;
+
+	if (!*(++p))
+		return -EINVAL;
+
+	*start = (phys_addr_t)memparse(p, &p);
+
+	return *p == '\0' ? 0 : -EINVAL;
+}
+
+static int __init pmem_init(void)
+{
+	int result, i;
+	struct pmem_device *pmem, *next;
+	char *p, *pmem_map = map;
+
+	if (!pmem_map) {
+		pr_err("pmem: must specify map=nn@ss parameter.\n");
+		return -EINVAL;
+	}
+
+	result = register_blkdev(0, "pmem");
+	if (result < 0)
+		return -EIO;
+	else
+		pmem_major = result;
+
+	i = 0;
+	while ((p = strsep(&pmem_map, ",")) != NULL) {
+		phys_addr_t phys_addr;
+		size_t disk_size;
+
+		if (!*p)
+			continue;
+		result = pmem_parse_map_one(p, &phys_addr, &disk_size);
+		if (result)
+			goto out_free;
+		pmem = pmem_alloc(phys_addr, disk_size, i);
+		if (IS_ERR(pmem)) {
+			result = PTR_ERR(pmem);
+			goto out_free;
+		}
+		list_add_tail(&pmem->pmem_list, &pmem_devices);
+		++i;
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
+	pr_info("pmem: module unloaded\n");
+}
+
+MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
+MODULE_LICENSE("GPL");
+module_init(pmem_init);
+module_exit(pmem_exit);
-- 
1.9.3


