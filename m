Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 11/20] libnd,
 nd_pmem: add libnd support to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:14 -0400
Message-ID: <20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 drivers/block/Kconfig     |   11 -----
 drivers/block/Makefile    |    1 
 drivers/block/nd/Kconfig  |   27 ++++++++++++
 drivers/block/nd/Makefile |    6 +++
 drivers/block/nd/e820.c   |  100 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/pmem.c   |   47 ++++++++++-----------
 7 files changed, 157 insertions(+), 37 deletions(-)
 create mode 100644 drivers/block/nd/e820.c
 rename drivers/block/{pmem.c => nd/pmem.c} (88%)

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
index 07a6acecf4d8..964d8eb2c16f 100644
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
index d2d84451e82c..c5eaf195734d 100644
--- a/drivers/block/nd/Kconfig
+++ b/drivers/block/nd/Kconfig
@@ -68,4 +68,31 @@ config NFIT_TEST
 
 	  Say N unless you are doing development of the 'nd' subsystem.
 
+config ND_E820
+	tristate "E820: Support the E820-type-12 PMEM convention"
+	depends on X86_PMEM_LEGACY
+	default m if X86_PMEM_LEGACY
+	select LIBND
+	help
+	  Prior to ACPI 6 some platforms advertised peristent memory
+	  via type-12 e820 memory ranges.  Create a libnd bus and
+	  attach an instance of the pmem driver to these ranges.
+
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
index 0fb0891e1817..ebb212af9f15 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -14,10 +14,16 @@ endif
 
 obj-$(CONFIG_LIBND) += libnd.o
 obj-$(CONFIG_ND_ACPI) += nd_acpi.o
+obj-$(CONFIG_ND_E820) += nd_e820.o
 obj-$(CONFIG_NFIT_TEST) += test/
+obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
 
 nd_acpi-y := acpi.o
 
+nd_e820-y := e820.o
+
+nd_pmem-y := pmem.o
+
 libnd-y := core.o
 libnd-y += bus.o
 libnd-y += dimm_devs.o
diff --git a/drivers/block/nd/e820.c b/drivers/block/nd/e820.c
new file mode 100644
index 000000000000..f4db8c54248e
--- /dev/null
+++ b/drivers/block/nd/e820.c
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
+#include "libnd.h"
+
+static const struct attribute_group *nd_e820_attribute_groups[] = {
+	&nd_bus_attribute_group,
+	NULL,
+};
+
+static const struct attribute_group *nd_e820_region_attribute_groups[] = {
+	&nd_region_attribute_group,
+	&nd_device_attribute_group,
+	NULL,
+};
+
+static int nd_e820_probe(struct platform_device *pdev)
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
+	nd_desc->attr_groups = nd_e820_attribute_groups;
+	nd_desc->provider_name = "e820";
+	nd_bus = nd_bus_register(&pdev->dev, nd_desc);
+	if (!nd_bus)
+		return -ENXIO;
+
+	memset(&ndr_desc, 0, sizeof(ndr_desc));
+	ndr_desc.res = res;
+	ndr_desc.attr_groups = nd_e820_region_attribute_groups;
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
+static int nd_e820_remove(struct platform_device *pdev)
+{
+	struct nd_bus *nd_bus = platform_get_drvdata(pdev);
+
+	nd_bus_unregister(nd_bus);
+
+	return 0;
+}
+
+static struct platform_driver nd_e820_driver = {
+	.probe		= nd_e820_probe,
+	.remove		= nd_e820_remove,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "e820_pmem",
+	},
+};
+
+MODULE_ALIAS("platform:e820_pmem*");
+
+static int __init nd_e820_init(void)
+{
+	return platform_driver_register(&nd_e820_driver);
+}
+module_init(nd_e820_init);
+
+static void nd_e820_exit(void)
+{
+	platform_driver_unregister(&nd_e820_driver);
+}
+module_exit(nd_e820_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/block/pmem.c b/drivers/block/nd/pmem.c
similarity index 88%
rename from drivers/block/pmem.c
rename to drivers/block/nd/pmem.c
index e3cf9142b172..c9dd8d7eca3a 100644
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
 
@@ -206,42 +207,37 @@ static void pmem_free(struct pmem_device *pmem)
 	kfree(pmem);
 }
 
-static int pmem_probe(struct platform_device *pdev)
+static int nd_pmem_probe(struct device *dev)
 {
+	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 	struct pmem_device *pmem;
-	struct resource *res;
 
-	if (WARN_ON(pdev->num_resources > 1))
-		return -ENXIO;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
-
-	pmem = pmem_alloc(&pdev->dev, res);
+	pmem = pmem_alloc(dev, &nsio->res);
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
@@ -252,16 +248,19 @@ static int __init pmem_init(void)
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

