Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 09/21] libnd,
 nd_pmem: add libnd support to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 May 2015 16:57:00 -0400
Message-ID: <20150520205700.32249.9798.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mingo@kernel.org, Boaz Harrosh <boaz@plexistor.com>, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, jmoyer@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

nd_pmem attaches to persistent memory regions and namespaces emitted by
the libnd subsystem, and, same as the original pmem driver, presents the
system-physical-address range as a block device.

The existing e820-type-12 to pmem setup is converted to a full libnd bus
that emits an nd_namespace_io device.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kernel/pmem.c    |    2 -
 drivers/block/Kconfig     |   19 ++++-----
 drivers/block/Makefile    |    2 -
 drivers/block/e820_pmem.c |  100 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/Kconfig  |   17 ++++++++
 drivers/block/nd/Makefile |    3 +
 drivers/block/nd/pmem.c   |   60 +++++++++++++--------------
 7 files changed, 159 insertions(+), 44 deletions(-)
 create mode 100644 drivers/block/e820_pmem.c
 rename drivers/block/{pmem.c => nd/pmem.c} (85%)

diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
index 3420c874ddc5..279328c42f87 100644
--- a/arch/x86/kernel/pmem.c
+++ b/arch/x86/kernel/pmem.c
@@ -13,7 +13,7 @@ static __init void register_pmem_device(struct resource *res)
 	struct platform_device *pdev;
 	int error;
 
-	pdev = platform_device_alloc("pmem", PLATFORM_DEVID_AUTO);
+	pdev = platform_device_alloc("e820_pmem", PLATFORM_DEVID_AUTO);
 	if (!pdev)
 		return;
 
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index dfe40e5ca9bd..4c2cfb91755f 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -323,6 +323,14 @@ config BLK_DEV_NVME
 
 source "drivers/block/nd/Kconfig"
 
+config E820_PMEM
+	tristate "E820 defined Persistent Memory (legacy)"
+	depends on PHYS_ADDR_T_64BIT
+	depends on X86_PMEM_LEGACY
+	default m if X86_PMEM_LEGACY
+	select ND_DEVICES
+	select LIBND
+
 config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
@@ -406,17 +414,6 @@ config BLK_DEV_RAM_DAX
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
index 07a6acecf4d8..4cd5f8a919d8 100644
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
@@ -25,6 +24,7 @@ obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
 obj-$(CONFIG_ND_DEVICES)	+= nd/
+obj-$(CONFIG_E820_PMEM)		+= e820_pmem.o
 obj-$(CONFIG_BLK_DEV_SKD)	+= skd.o
 obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
 
diff --git a/drivers/block/e820_pmem.c b/drivers/block/e820_pmem.c
new file mode 100644
index 000000000000..48c33e43f39e
--- /dev/null
+++ b/drivers/block/e820_pmem.c
@@ -0,0 +1,100 @@
+/*
+ * libnd e820 support
+ *
+ * Copyright (c) 2014-2015, Intel Corporation.
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
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/libnd.h>
+
+static const struct attribute_group *e820_pmem_attribute_groups[] = {
+	&nd_bus_attribute_group,
+	NULL,
+};
+
+static const struct attribute_group *e820_pmem_region_attribute_groups[] = {
+	&nd_region_attribute_group,
+	&nd_device_attribute_group,
+	NULL,
+};
+
+static int e820_pmem_probe(struct platform_device *pdev)
+{
+	struct nd_bus_descriptor *nd_desc;
+	struct nd_region_desc ndr_desc;
+	struct nd_bus *nd_bus;
+	struct resource *res;
+
+	if (WARN_ON(pdev->num_resources > 1))
+		return -ENXIO;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENXIO;
+
+	nd_desc = devm_kzalloc(&pdev->dev, sizeof(*nd_desc), GFP_KERNEL);
+	if (!nd_desc)
+		return -ENOMEM;
+
+	nd_desc->attr_groups = e820_pmem_attribute_groups;
+	nd_desc->provider_name = "e820";
+	nd_bus = nd_bus_register(&pdev->dev, nd_desc);
+	if (!nd_bus)
+		return -ENXIO;
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	ndr_desc.res = res;
+	ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
+	if (!nd_pmem_region_create(nd_bus, &ndr_desc)) {
+		nd_bus_unregister(nd_bus);
+		return -ENXIO;
+	}
+
+	platform_set_drvdata(pdev, nd_bus);
+
+	return 0;
+}
+
+static int e820_pmem_remove(struct platform_device *pdev)
+{
+	struct nd_bus *nd_bus = platform_get_drvdata(pdev);
+
+	nd_bus_unregister(nd_bus);
+
+	return 0;
+}
+
+static struct platform_driver e820_pmem_driver = {
+	.probe		= e820_pmem_probe,
+	.remove		= e820_pmem_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "e820_pmem",
+	},
+};
+
+MODULE_ALIAS("platform:e820_pmem*");
+
+static int __init e820_pmem_init(void)
+{
+	return platform_driver_register(&e820_pmem_driver);
+}
+module_init(e820_pmem_init);
+
+static void e820_pmem_exit(void)
+{
+	platform_driver_unregister(&e820_pmem_driver);
+}
+module_exit(e820_pmem_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
index 9b909c21afa1..03f572f0e3d0 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -17,4 +17,21 @@ if ND_DEVICES
 config LIBND
 	tristate
 
+config BLK_DEV_PMEM
+	tristate "PMEM: Persistent memory block device support"
+	depends on LIBND
+	default LIBND
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
index 235d9e6be94a..6f539f01fa82 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -1,4 +1,7 @@
 obj-$(CONFIG_LIBND) += libnd.o
+obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
+
+nd_pmem-y := pmem.o
 
 libnd-y := core.o
 libnd-y += bus.o
diff --git a/drivers/block/pmem.c b/drivers/block/nd/pmem.c
similarity index 85%
rename from drivers/block/pmem.c
rename to drivers/block/nd/pmem.c
index eabf4a8d0085..529a1444a918 100644
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
@@ -23,6 +23,8 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
+#include <linux/nd.h>
+#include "nd.h"
 
 #define PMEM_MINORS		16
 
@@ -37,7 +39,6 @@ struct pmem_device {
 };
 
 static int pmem_major;
-static atomic_t pmem_index;
 
 static void pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 			unsigned int len, unsigned int off, int rw,
@@ -118,11 +119,11 @@ static const struct block_device_operations pmem_fops = {
 	.direct_access =	pmem_direct_access,
 };
 
-static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
+static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res, int id)
 {
 	struct pmem_device *pmem;
 	struct gendisk *disk;
-	int idx, err;
+	int err;
 
 	err = -ENOMEM;
 	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
@@ -159,15 +160,13 @@ static struct pmem_device *pmem_alloc(struct device *dev, struct resource *res)
 	if (!disk)
 		goto out_free_queue;
 
-	idx = atomic_inc_return(&pmem_index) - 1;
-
 	disk->major		= pmem_major;
-	disk->first_minor	= PMEM_MINORS * idx;
+	disk->first_minor	= PMEM_MINORS * id;
 	disk->fops		= &pmem_fops;
 	disk->private_data	= pmem;
 	disk->queue		= pmem->pmem_queue;
 	disk->flags		= GENHD_FL_EXT_DEVT;
-	sprintf(disk->disk_name, "pmem%d", idx);
+	sprintf(disk->disk_name, "pmem%d", id);
 	disk->driverfs_dev = dev;
 	set_capacity(disk, pmem->size >> 9);
 	pmem->pmem_disk = disk;
@@ -198,42 +197,38 @@ static void pmem_free(struct pmem_device *pmem)
 	kfree(pmem);
 }
 
-static int pmem_probe(struct platform_device *pdev)
+static int nd_pmem_probe(struct device *dev)
 {
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 	struct pmem_device *pmem;
-	struct resource *res;
-
-	if (WARN_ON(pdev->num_resources > 1))
-		return -ENXIO;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
 
-	pmem = pmem_alloc(&pdev->dev, res);
+	pmem = pmem_alloc(dev, &nsio->res, nd_region->id);
 	if (IS_ERR(pmem))
 		return PTR_ERR(pmem);
 
-	platform_set_drvdata(pdev, pmem);
+	dev_set_drvdata(dev, pmem);
 
 	return 0;
 }
 
-static int pmem_remove(struct platform_device *pdev)
+static int nd_pmem_remove(struct device *dev)
 {
-	struct pmem_device *pmem = platform_get_drvdata(pdev);
+	struct pmem_device *pmem = dev_get_drvdata(dev);
 
 	pmem_free(pmem);
 	return 0;
 }
 
-static struct platform_driver pmem_driver = {
-	.probe		= pmem_probe,
-	.remove		= pmem_remove,
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "pmem",
+MODULE_ALIAS("pmem");
+MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
+static struct nd_device_driver nd_pmem_driver = {
+	.probe = nd_pmem_probe,
+	.remove = nd_pmem_remove,
+	.drv = {
+		.name = "pmem",
 	},
+	.type = ND_DRIVER_NAMESPACE_IO,
 };
 
 static int __init pmem_init(void)
@@ -244,16 +239,19 @@ static int __init pmem_init(void)
 	if (pmem_major < 0)
 		return pmem_major;
 
-	error = platform_driver_register(&pmem_driver);
-	if (error)
+	error = nd_driver_register(&nd_pmem_driver);
+	if (error) {
 		unregister_blkdev(pmem_major, "pmem");
-	return error;
+		return error;
+	}
+
+	return 0;
 }
 module_init(pmem_init);
 
 static void pmem_exit(void)
 {
-	platform_driver_unregister(&pmem_driver);
+	driver_unregister(&nd_pmem_driver.drv);
 	unregister_blkdev(pmem_major, "pmem");
 }
 module_exit(pmem_exit);

