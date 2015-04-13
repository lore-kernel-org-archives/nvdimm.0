Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 13 Apr 2015 11:33:09 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] PMEM driver for v4.1
Message-ID: <20150413093309.GA30219@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boaz@plexistor.com>
List-ID: <linux-nvdimm@lists.01.org>

Linus,

Please pull the latest x86-pmem-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-pmem-for-linus

   # HEAD: 4c1eaa2344fb26bb5e936fb4d8ee307343ea0089 drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()

This is the initial support for the pmem block device driver: 
persistent non-volatile memory space mapped into the system's physical 
memory space as large physical memory regions.

The driver is based on Intel code, written by Ross Zwisler, with fixes 
by Boaz Harrosh, integrated with x86 e820 memory resource management 
and tidied up by Christoph Hellwig.

Note that there were two other separate pmem driver submissions to 
lkml: but apparently all parties (Ross Zwisler, Boaz Harrosh) are 
reasonably happy with this initial version.

This version enables minimal support that enables persistent memory 
devices out in the wild to work as block devices, identified through a 
magic (non-standard) e820 flag and auto-discovered if 
CONFIG_X86_PMEM_LEGACY=y, or added explicitly through manipulating the 
memory maps via the "memmap=..." boot option with the new, special '!' 
modifier character.

Limitations: this is a regular block device, and since the pmem areas 
are not struct page backed, they are invisible to the rest of the 
system (other than the block IO device), so direct IO to/from pmem 
areas, direct mmap() or XIP is not possible yet. The page cache will 
also shadow and double buffer pmem contents, etc.

Initial support is for x86.

 Thanks,

	Ingo

------------------>
Christoph Hellwig (1):
      x86/mm: Add support for the non-standard protected e820 type

Ingo Molnar (1):
      drivers/block/pmem: Fix 32-bit build warning in pmem_alloc()

Ross Zwisler (1):
      drivers/block/pmem: Add a driver for persistent memory


 Documentation/kernel-parameters.txt |   6 +
 MAINTAINERS                         |   6 +
 arch/x86/Kconfig                    |  10 ++
 arch/x86/include/uapi/asm/e820.h    |  10 ++
 arch/x86/kernel/Makefile            |   1 +
 arch/x86/kernel/e820.c              |  26 +++-
 arch/x86/kernel/pmem.c              |  53 ++++++++
 drivers/block/Kconfig               |  11 ++
 drivers/block/Makefile              |   1 +
 drivers/block/pmem.c                | 262 ++++++++++++++++++++++++++++++++++++
 10 files changed, 380 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/kernel/pmem.c
 create mode 100644 drivers/block/pmem.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index bfcb1a62a7b4..c87122dd790f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1965,6 +1965,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			         or
 			         memmap=0x10000$0x18690000
 
+	memmap=nn[KMG]!ss[KMG]
+			[KNL,X86] Mark specific memory as protected.
+			Region of memory to be used, from ss to ss+nn.
+			The memory region may be marked as e820 type 12 (0xc)
+			and is NVDIMM or ADR memory.
+
 	memory_corruption_check=0/1 [X86]
 			Some BIOSes seem to corrupt the first 64k of
 			memory when doing things like suspend/resume.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1de6afa8ee51..4517613dc638 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8071,6 +8071,12 @@ S:	Maintained
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b7d31ca55187..9e3bcd6f4a48 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1430,6 +1430,16 @@ config ILLEGAL_POINTER_VALUE
 
 source "mm/Kconfig"
 
+config X86_PMEM_LEGACY
+	bool "Support non-standard NVDIMMs and ADR protected memory"
+	help
+	  Treat memory marked using the non-standard e820 type of 12 as used
+	  by the Intel Sandy Bridge-EP reference BIOS as protected memory.
+	  The kernel will offer these regions to the 'pmem' driver so
+	  they can be used for persistent storage.
+
+	  Say Y if unsure.
+
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
 	depends on HIGHMEM
diff --git a/arch/x86/include/uapi/asm/e820.h b/arch/x86/include/uapi/asm/e820.h
index d993e33f5236..960a8a9dc4ab 100644
--- a/arch/x86/include/uapi/asm/e820.h
+++ b/arch/x86/include/uapi/asm/e820.h
@@ -33,6 +33,16 @@
 #define E820_NVS	4
 #define E820_UNUSABLE	5
 
+/*
+ * This is a non-standardized way to represent ADR or NVDIMM regions that
+ * persist over a reboot.  The kernel will ignore their special capabilities
+ * unless the CONFIG_X86_PMEM_LEGACY=y option is set.
+ *
+ * ( Note that older platforms also used 6 for the same type of memory,
+ *   but newer versions switched to 12 as 6 was assigned differently.  Some
+ *   time they will learn... )
+ */
+#define E820_PRAM	12
 
 /*
  * reserved RAM used by kernel itself
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cdb1b70ddad0..971f18cd9ca0 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_KVM_GUEST)		+= kvm.o kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
+obj-$(CONFIG_X86_PMEM_LEGACY)	+= pmem.o
 
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 46201deee923..11cc7d54ec3f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -149,6 +149,9 @@ static void __init e820_print_type(u32 type)
 	case E820_UNUSABLE:
 		printk(KERN_CONT "unusable");
 		break;
+	case E820_PRAM:
+		printk(KERN_CONT "persistent (type %u)", type);
+		break;
 	default:
 		printk(KERN_CONT "type %u", type);
 		break;
@@ -343,7 +346,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 		 * continue building up new bios map based on this
 		 * information
 		 */
-		if (current_type != last_type)	{
+		if (current_type != last_type || current_type == E820_PRAM) {
 			if (last_type != 0)	 {
 				new_bios[new_bios_entry].size =
 					change_point[chgidx]->addr - last_addr;
@@ -688,6 +691,7 @@ void __init e820_mark_nosave_regions(unsigned long limit_pfn)
 			register_nosave_region(pfn, PFN_UP(ei->addr));
 
 		pfn = PFN_DOWN(ei->addr + ei->size);
+
 		if (ei->type != E820_RAM && ei->type != E820_RESERVED_KERN)
 			register_nosave_region(PFN_UP(ei->addr), pfn);
 
@@ -748,7 +752,7 @@ u64 __init early_reserve_e820(u64 size, u64 align)
 /*
  * Find the highest page frame number we have available
  */
-static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn)
 {
 	int i;
 	unsigned long last_pfn = 0;
@@ -759,7 +763,11 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 		unsigned long start_pfn;
 		unsigned long end_pfn;
 
-		if (ei->type != type)
+		/*
+		 * Persistent memory is accounted as ram for purposes of
+		 * establishing max_pfn and mem_map.
+		 */
+		if (ei->type != E820_RAM && ei->type != E820_PRAM)
 			continue;
 
 		start_pfn = ei->addr >> PAGE_SHIFT;
@@ -784,12 +792,12 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 }
 unsigned long __init e820_end_of_ram_pfn(void)
 {
-	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
+	return e820_end_pfn(MAX_ARCH_PFN);
 }
 
 unsigned long __init e820_end_of_low_ram_pfn(void)
 {
-	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
+	return e820_end_pfn(1UL << (32-PAGE_SHIFT));
 }
 
 static void early_panic(char *msg)
@@ -866,6 +874,9 @@ static int __init parse_memmap_one(char *p)
 	} else if (*p == '$') {
 		start_at = memparse(p+1, &p);
 		e820_add_region(start_at, mem_size, E820_RESERVED);
+	} else if (*p == '!') {
+		start_at = memparse(p+1, &p);
+		e820_add_region(start_at, mem_size, E820_PRAM);
 	} else
 		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
@@ -907,6 +918,7 @@ static inline const char *e820_type_to_string(int e820_type)
 	case E820_ACPI:	return "ACPI Tables";
 	case E820_NVS:	return "ACPI Non-volatile Storage";
 	case E820_UNUSABLE:	return "Unusable memory";
+	case E820_PRAM: return "Persistent RAM";
 	default:	return "reserved";
 	}
 }
@@ -940,7 +952,9 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (((e820.map[i].type != E820_RESERVED) &&
+		     (e820.map[i].type != E820_PRAM)) ||
+		     res->start < (1ULL<<20)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
new file mode 100644
index 000000000000..3420c874ddc5
--- /dev/null
+++ b/arch/x86/kernel/pmem.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2015, Christoph Hellwig.
+ */
+#include <linux/memblock.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <asm/e820.h>
+#include <asm/page_types.h>
+#include <asm/setup.h>
+
+static __init void register_pmem_device(struct resource *res)
+{
+	struct platform_device *pdev;
+	int error;
+
+	pdev = platform_device_alloc("pmem", PLATFORM_DEVID_AUTO);
+	if (!pdev)
+		return;
+
+	error = platform_device_add_resources(pdev, res, 1);
+	if (error)
+		goto out_put_pdev;
+
+	error = platform_device_add(pdev);
+	if (error)
+		goto out_put_pdev;
+	return;
+
+out_put_pdev:
+	dev_warn(&pdev->dev, "failed to add 'pmem' (persistent memory) device!\n");
+	platform_device_put(pdev);
+}
+
+static __init int register_pmem_devices(void)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+
+		if (ei->type == E820_PRAM) {
+			struct resource res = {
+				.flags	= IORESOURCE_MEM,
+				.start	= ei->addr,
+				.end	= ei->addr + ei->size - 1,
+			};
+			register_pmem_device(&res);
+		}
+	}
+
+	return 0;
+}
+device_initcall(register_pmem_devices);
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 1b8094d4d7af..eb1fed5bd516 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -404,6 +404,17 @@ config BLK_DEV_RAM_DAX
 	  and will prevent RAM block device backing store memory from being
 	  allocated from highmem (only a problem for highmem systems).
 
+config BLK_DEV_PMEM
+	tristate "Persistent memory block device support"
+	help
+	  Saying Y here will allow you to use a contiguous range of reserved
+	  memory as one or more persistent block devices.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called 'pmem'.
+
+	  If unsure, say N.
+
 config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media"
 	depends on !UML
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 02b688d1438d..9cc6c18a1c7e 100644
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
index 000000000000..eabf4a8d0085
--- /dev/null
+++ b/drivers/block/pmem.c
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
