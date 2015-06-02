Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v5 09/21] libnvdimm,
 nd_pmem: add libnvdimm support to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 01 Jun 2015 20:14:58 -0400
Message-ID: <20150602001458.4506.76492.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

nd_pmem attaches to persistent memory regions and namespaces emitted by
the libnvdimm subsystem, and, same as the original pmem driver, presents
the system-physical-address range as a block device.

The existing e820-type-12 to pmem setup is converted to a full libnvdimm
bus that emits an nd_namespace_io device.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/Kconfig        |    4 ++
 arch/x86/kernel/pmem.c  |   92 +++++++++++++++++++++++++++++++----------------
 drivers/block/Kconfig   |   11 ------
 drivers/block/Makefile  |    1 -
 drivers/nvdimm/Kconfig  |   17 +++++++++
 drivers/nvdimm/Makefile |    3 ++
 drivers/nvdimm/pmem.c   |   60 +++++++++++++++----------------
 7 files changed, 113 insertions(+), 75 deletions(-)
 rename drivers/{block/pmem.c => nvdimm/pmem.c} (85%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 226d5696e1d1..3fa273d47bba 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1424,6 +1424,10 @@ source "mm/Kconfig"
 
 config X86_PMEM_LEGACY
 	bool "Support non-standard NVDIMMs and ADR protected memory"
+	depends on PHYS_ADDR_T_64BIT
+	depends on BLK_DEV
+	select NVDIMM_DEVICES
+	select LIBNVDIMM
 	help
 	  Treat memory marked using the non-standard e820 type of 12 as used
 	  by the Intel Sandy Bridge-EP reference BIOS as protected memory.
diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
index 3420c874ddc5..40d734c8e3b1 100644
--- a/arch/x86/kernel/pmem.c
+++ b/arch/x86/kernel/pmem.c
@@ -1,53 +1,81 @@
 /*
  * Copyright (c) 2015, Christoph Hellwig.
+ * Copyright (c) 2015, Intel Corporation.
  */
-#include <linux/memblock.h>
 #include <linux/platform_device.h>
-#include <linux/slab.h>
+#include <linux/libnvdimm.h>
+#include <linux/module.h>
 #include <asm/e820.h>
-#include <asm/page_types.h>
-#include <asm/setup.h>
 
-static __init void register_pmem_device(struct resource *res)
+static void e820_pmem_release(struct device *dev)
 {
-	struct platform_device *pdev;
-	int error;
+	struct nvdimm_bus *nvdimm_bus = dev->platform_data;
 
-	pdev = platform_device_alloc("pmem", PLATFORM_DEVID_AUTO);
-	if (!pdev)
-		return;
+	if (nvdimm_bus)
+		nvdimm_bus_unregister(nvdimm_bus);
+}
 
-	error = platform_device_add_resources(pdev, res, 1);
-	if (error)
-		goto out_put_pdev;
+static struct platform_device e820_pmem = {
+	.name = "e820_pmem",
+	.id = -1,
+	.dev = {
+		.release = e820_pmem_release,
+	},
+};
 
-	error = platform_device_add(pdev);
-	if (error)
-		goto out_put_pdev;
-	return;
+static const struct attribute_group *e820_pmem_attribute_groups[] = {
+	&nvdimm_bus_attribute_group,
+	NULL,
+};
 
-out_put_pdev:
-	dev_warn(&pdev->dev, "failed to add 'pmem' (persistent memory) device!\n");
-	platform_device_put(pdev);
-}
+static const struct attribute_group *e820_pmem_region_attribute_groups[] = {
+	&nd_region_attribute_group,
+	&nd_device_attribute_group,
+	NULL,
+};
 
-static __init int register_pmem_devices(void)
+static __init int register_e820_pmem(void)
 {
-	int i;
+	static struct nvdimm_bus_descriptor nd_desc;
+	struct device *dev = &e820_pmem.dev;
+	struct nvdimm_bus *nvdimm_bus;
+	int rc, i;
+
+	rc = platform_device_register(&e820_pmem);
+	if (rc)
+		return rc;
+
+	nd_desc.attr_groups = e820_pmem_attribute_groups;
+	nd_desc.provider_name = "e820";
+	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
+	if (!nvdimm_bus)
+		goto err;
+	dev->platform_data = nvdimm_bus;
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
+		struct resource res = {
+			.flags	= IORESOURCE_MEM,
+			.start	= ei->addr,
+			.end	= ei->addr + ei->size - 1,
+		};
+		struct nd_region_desc ndr_desc;
+
+		if (ei->type != E820_PRAM)
+			continue;
 
-		if (ei->type == E820_PRAM) {
-			struct resource res = {
-				.flags	= IORESOURCE_MEM,
-				.start	= ei->addr,
-				.end	= ei->addr + ei->size - 1,
-			};
-			register_pmem_device(&res);
-		}
+		memset(&ndr_desc, 0, sizeof(ndr_desc));
+		ndr_desc.res = &res;
+		ndr_desc.attr_groups = e820_pmem_region_attribute_groups;
+		if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
+			goto err;
 	}
 
 	return 0;
+
+ err:
+	dev_err(dev, "failed to register legacy persistent memory ranges\n");
+	platform_device_unregister(&e820_pmem);
+	return -ENXIO;
 }
-device_initcall(register_pmem_devices);
+late_initcall(register_e820_pmem);
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
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 24b51dbc8215..020acf860258 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -17,4 +17,21 @@ if NVDIMM_DEVICES
 config LIBNVDIMM
 	tristate
 
+config BLK_DEV_PMEM
+	tristate "PMEM: Persistent memory block device support"
+	depends on LIBNVDIMM
+	default LIBNVDIMM
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
diff --git a/drivers/block/pmem.c b/drivers/nvdimm/pmem.c
similarity index 85%
rename from drivers/block/pmem.c
rename to drivers/nvdimm/pmem.c
index eabf4a8d0085..cf5d53eda9e5 100644
--- a/drivers/block/pmem.c
+++ b/drivers/nvdimm/pmem.c
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
+		.name = "nd_pmem",
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

