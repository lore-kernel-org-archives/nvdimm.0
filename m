Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 12/21] nd_pmem: add NFIT support to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:36:18 -0400
Message-ID: <20150418013618.25237.99555.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

nd_pmem attaches to persistent memory regions and namespaces emitted by
the nd subsystem, and, same as the original pmem driver, presents the
system-physical-address range as a block device.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/Kconfig     |   11 -------
 drivers/block/Makefile    |    1 -
 drivers/block/nd/Kconfig  |   17 +++++++++++
 drivers/block/nd/Makefile |    3 ++
 drivers/block/nd/pmem.c   |   72 +++++++++++++++++++++++++++++++++++++++------
 5 files changed, 83 insertions(+), 21 deletions(-)
 rename drivers/block/{pmem.c => nd/pmem.c} (81%)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index dfe40e5ca9bd..1cef4ffb16c5 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -406,17 +406,6 @@ config BLK_DEV_RAM_DAX
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
index 18b27bb9cd2d..3a2f15be66a3 100644
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
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 6c15d10bf4e0..38eae5f0ae4b 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -72,4 +72,21 @@ config NFIT_TEST
 
 	  Say N unless you are doing development of the 'nd' subsystem.
 
+config BLK_DEV_PMEM
+	tristate "PMEM: Persistent memory block device support"
+	depends on ND_CORE || X86_PMEM_LEGACY
+	default ND_CORE
+	help
+	  Memory ranges for PMEM are described by either an NFIT
+	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
+	  non-standard OEM-specific E820 memory type (type-12, see
+	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
+	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
+	  Documentation/kernel-parameters.txt).  This driver converts
+	  these persistent memory ranges into block devices that are
+	  capable of DAX (direct-access) file system mappings.  See
+	  Documentation/blockdev/nd.txt for more details.
+
+	  Say Y if you want to use a NVDIMM described by NFIT
+
 endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index 769ddc34f974..c0194d52e5ad 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -16,6 +16,7 @@ endif
 
 obj-$(CONFIG_ND_CORE) += nd.o
 obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
+obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 
 nd_acpi-y := acpi.o
 
@@ -26,3 +27,5 @@ nd-y += dimm.o
 nd-y += region_devs.o
 nd-y += region.o
 nd-y += namespace_devs.o
+
+nd_pmem-y := pmem.o
diff --git a/drivers/block/pmem.c b/drivers/block/nd/pmem.c
similarity index 81%
rename from drivers/block/pmem.c
rename to drivers/block/nd/pmem.c
index eabf4a8d0085..cd83a9a98d89 100644
--- a/drivers/block/pmem.c
+++ b/drivers/block/nd/pmem.c
@@ -1,7 +1,7 @@
 /*
  * Persistent Memory Driver
  *
- * Copyright (c) 2014, Intel Corporation.
+ * Copyright (c) 2014-2015, Intel Corporation.
  * Copyright (c) 2015, Christoph Hellwig <hch@lst.de>.
  * Copyright (c) 2015, Boaz Harrosh <boaz@plexistor.com>.
  *
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/nd.h>
 
 #define PMEM_MINORS		16
 
@@ -34,10 +35,11 @@ struct pmem_device {
 	phys_addr_t		phys_addr;
 	void			*virt_addr;
 	size_t			size;
+	int			id;
 };
 
 static int pmem_major;
-static atomic_t pmem_index;
+static DEFINE_IDA(pmem_ida);
 
 static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			unsigned int len, unsigned int off, int rw,
@@ -122,20 +124,26 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 {
 	struct pmem_device *pmem;
 	struct gendisk *disk;
-	int idx, err;
+	int err;
 
 	err = -ENOMEM;
 	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
 		goto out;
 
+	pmem->id = ida_simple_get(&pmem_ida, 0, 0, GFP_KERNEL);
+	if (pmem->id < 0) {
+		err = pmem->id;
+		goto out_free_dev;
+	}
+
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
 
 	err = -EINVAL;
 	if (!request_mem_region(pmem->phys_addr, pmem->size, "pmem")) {
 		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n", &pmem->phys_addr, pmem->size);
-		goto out_free_dev;
+		goto out_free_ida;
 	}
 
 	/*
@@ -159,15 +167,13 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 	if (!disk)
 		goto out_free_queue;
 
-	idx = atomic_inc_return(&pmem_index) - 1;
-
 	disk->major		= pmem_major;
-	disk->first_minor	= PMEM_MINORS * idx;
+	disk->first_minor	= PMEM_MINORS * pmem->id;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
-	sprintf(disk->disk_name, "pmem%d", idx);
+	sprintf(disk->disk_name, "pmem%d", pmem->id);
 	disk->driverfs_dev = dev;
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
@@ -182,6 +188,8 @@ out_unmap:
 	iounmap(pmem->virt_addr);
 out_release_region:
 	release_mem_region(pmem->phys_addr, pmem->size);
+out_free_ida:
+	ida_simple_remove(&pmem_ida, pmem->id);
 out_free_dev:
 	kfree(pmem);
 out:
@@ -195,6 +203,7 @@ static void pmem_free(struct pmem_device *pmem)
 	blk_cleanup_queue(pmem->pmem_queue);
 	iounmap(pmem->virt_addr);
 	release_mem_region(pmem->phys_addr, pmem->size);
+	ida_simple_remove(&pmem_ida, pmem->id);
 	kfree(pmem);
 }
 
@@ -236,6 +245,39 @@ static struct platform_driver pmem_driver = {
 	},
 };
 
+static int nd_pmem_probe(struct device *dev)
+{
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
+	struct pmem_device *pmem;
+
+	pmem = pmem_alloc(dev, &nsio->res);
+	if (IS_ERR(pmem))
+		return PTR_ERR(pmem);
+
+	dev_set_drvdata(dev, pmem);
+
+	return 0;
+}
+
+static int nd_pmem_remove(struct device *dev)
+{
+	struct pmem_device *pmem = dev_get_drvdata(dev);
+
+	pmem_free(pmem);
+	return 0;
+}
+
+MODULE_ALIAS("pmem");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
+static struct nd_device_driver nd_pmem_driver = {
+	.probe = nd_pmem_probe,
+	.remove = nd_pmem_remove,
+	.drv = {
+		.name = "pmem",
+	},
+	.type = ND_DRIVER_NAMESPACE_IO,
+};
+
 static int __init pmem_init(void)
 {
 	int error;
@@ -244,9 +286,20 @@ static int __init pmem_init(void)
 	if (pmem_major < 0)
 		return pmem_major;
 
+	error = nd_driver_register(&nd_pmem_driver);
+	if (error)
+		goto out_unregister_blkdev;
+
 	error = platform_driver_register(&pmem_driver);
 	if (error)
-		unregister_blkdev(pmem_major, "pmem");
+		goto out_unregister_nd;
+
+	return 0;
+
+ out_unregister_nd:
+	driver_unregister(&nd_pmem_driver.drv);
+ out_unregister_blkdev:
+	unregister_blkdev(pmem_major, "pmem");
 	return error;
 }
 module_init(pmem_init);
@@ -254,6 +307,7 @@ module_init(pmem_init);
 static void pmem_exit(void)
 {
 	platform_driver_unregister(&pmem_driver);
+	driver_unregister(&nd_pmem_driver.drv);
 	unregister_blkdev(pmem_major, "pmem");
 }
 module_exit(pmem_exit);

