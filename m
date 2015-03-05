Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <54F84420.40209@plexistor.com>
Date: Thu, 05 Mar 2015 13:55:12 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: [PATCH 1/8] pmem: Initial version of persistent memory driver
References: <54F82CE0.4040502@plexistor.com> <54F830D4.7030205@plexistor.com>
In-Reply-To: <54F830D4.7030205@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Ross Zwisler <ross.zwisler@linux.intel.com>

PMEM is a new driver That supports any physical contiguous iomem range
as a single block device. The driver has support for as many as needed
iomem ranges each as its own device.

The driver is not only good for NvDIMMs, It is good for any flat memory
mapped device. We've used it with NvDIMMs, Kernel reserved DRAM
(memmap= on command line), PCIE Battery backed memory cards, VM shared
memory, and so on.

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
 This patch is based on (git://git.open-osd.org/pmem.git):
	[5ccf703] SQUASHME: Don't clobber the map module param

<list-of-changes>
[boaz]
SQUASHME: pmem: Remove unused #include headers
SQUASHME: pmem: Request from fdisk 4k alignment
SQUASHME: pmem: Let each device manage private memory region
SQUASHME: pmem: Support of multiple memory regions
SQUASHME: pmem: Micro optimization the hotpath 001
SQUASHME: pmem: no need to copy a page at a time
SQUASHME: pmem that 4k sector thing
SQUASHME: pmem: Cleanliness is neat
SQUASHME: Don't clobber the map module param
SQUASHME: pmem: Few changes to Initial version of pmem
SQUASHME: Changes to copyright text (trivial)
</list-of-changes>

TODO: Add Documentation/blockdev/pmem.txt

Need-signed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 MAINTAINERS            |   7 ++
 drivers/block/Kconfig  |  18 +++
 drivers/block/Makefile |   1 +
 drivers/block/pmem.c   | 334 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 360 insertions(+)
 create mode 100644 drivers/block/pmem.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ddc5a8c..21c5384 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8053,6 +8053,13 @@ S:	Maintained
 F:	Documentation/blockdev/ramdisk.txt
 F:	drivers/block/brd.c
 
+PERSISTENT MEMORY DRIVER
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Boaz Harrosh <boaz@plexistor.com>
+L:	linux-nvdimm@lists.01.org
+S:	Supported
+F:	drivers/block/pmem.c
+
 RANDOM NUMBER DRIVER
 M:	"Theodore Ts'o" <tytso@mit.edu>
 S:	Maintained
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1b8094d..1530c2a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -404,6 +404,24 @@ config BLK_DEV_RAM_DAX
 	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
+config BLK_DEV_PMEM
+	tristate "pmem: Persistent memory block device support"
+	help
+	  If you have Persistent memory in your system say Y/m
+	  here. The driver can support real Persistent memory chips
+	  such as NVDIMMs , as well as volatile memory that was set
+	  aside from Kernel use by the "memmap" kernel parameter.
+	  And/or any contiguous physical memory ranges that you want
+	  to represent as a block device. (Even PCIE flat memory mapped
+	  devices)
+	  See Documentation/block/pmem.txt for how to use
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called pmem. Created Devices will be named: /dev/pmemX
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
index 0000000..02cd118
--- /dev/null
+++ b/drivers/block/pmem.c
@@ -0,0 +1,334 @@
+/*
+ * Persistent Memory Driver
+ * Copyright (c) 2014, Intel Corporation.
+ * Copyright (c) 2014, Boaz Harrosh <boaz@plexistor.com>.
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
+ * This driver's skeleton is based on drivers/block/brd.c.
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
+#include <linux/string.h>
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
+static void pmem_do_bvec(struct pmem_device *pmem, struct page *page, uint len,
+			 uint off, int rw, sector_t sector)
+{
+	void *mem = kmap_atomic(page);
+	size_t pmem_off = sector << 9;
+
+	BUG_ON(pmem_off >= pmem->size);
+
+	if (rw == READ) {
+		memcpy(mem + off, pmem->virt_addr + pmem_off, len);
+		flush_dcache_page(page);
+	} else {
+		/*
+		 * FIXME: Need more involved flushing to ensure that writes to
+		 * NVDIMMs are actually durable before returning.
+		 */
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
+	if (unlikely(bio_end_sector(bio) > get_capacity(bdev->bd_disk))) {
+		err = -EIO;
+		goto out;
+	}
+
+	if (WARN_ON(bio->bi_rw & REQ_DISCARD)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rw = bio_rw(bio);
+	if (rw == READA)
+		rw = READ;
+
+	sector = bio->bi_iter.bi_sector;
+	bio_for_each_segment(bvec, bio, iter) {
+		/* NOTE: There is a legend saying that bv_len might be
+		 * bigger than PAGE_SIZE in the case that bv_page points to
+		 * a physical contiguous PFN set. But for us it is fine because
+		 * it means the Kernel virtual mapping is also contiguous. And
+		 * on the pmem side we are always contiguous both virtual and
+		 * physical
+		 */
+		pmem_do_bvec(pmem, bvec.bv_page, bvec.bv_len, bvec.bv_offset,
+			     rw, sector);
+		sector += bvec.bv_len >> 9;
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
+	if (unlikely(!res_mem)) {
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
+#define PMEM_ALIGNMEM PAGE_SIZE
+
+static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
+				      int i)
+{
+	struct pmem_device *pmem;
+	struct gendisk *disk;
+	int err;
+
+	if (unlikely((phys_addr & (PMEM_ALIGNMEM - 1)) ||
+		     (disk_size & (PMEM_ALIGNMEM - 1)))) {
+		pr_err("phys_addr=0x%llx disk_size=0x%zx must be 0x%lx aligned\n",
+		       phys_addr, disk_size, PMEM_ALIGNMEM);
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
+	set_capacity(disk, disk_size >> 9);
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
+	char *p, *pmem_map, *map_dup;
+
+	if (unlikely(!map || !*map)) {
+		pr_err("pmem: must specify map=nn@ss parameter.\n");
+		return -EINVAL;
+	}
+
+	result = register_blkdev(0, "pmem");
+	if (unlikely(result < 0))
+		return -EIO;
+
+	pmem_major = result;
+
+	map_dup = pmem_map = kstrdup(map, GFP_KERNEL);
+	if (unlikely(!pmem_map)) {
+		pr_debug("pmem_init strdup(%s) failed\n", map);
+		return -ENOMEM;
+	}
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
+	pr_info("pmem: module loaded map=%s\n", map);
+	kfree(map_dup);
+	return 0;
+
+out_free:
+	list_for_each_entry_safe(pmem, next, &pmem_devices, pmem_list) {
+		list_del(&pmem->pmem_list);
+		pmem_free(pmem);
+	}
+	kfree(map_dup);
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


