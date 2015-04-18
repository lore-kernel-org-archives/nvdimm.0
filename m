Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 03/21] nd_acpi: initial core implementation and nfit skeleton
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:30 -0400
Message-ID: <20150418013530.25237.28383.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

1/ Autodetect an NFIT table for the ACPI namespace device with _HID of
   "ACPI0012"

2/ Skeleton implementation to register an NFIT bus.

The NFIT provided by ACPI is the primary method by which platforms will
discover NVDIMM resources.  However, the intent of the
nfit_bus_descriptor abstraction is to contain "provider" specific
details, leaving the nd core to be NFIT-provider agnostic.  This
flexibility is exploited in later patches to implement special purpose
providers of test and custom-defined NFITs.

Cc: <linux-acpi@vger.kernel.org>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/Kconfig     |    2 
 drivers/block/Makefile    |    1 
 drivers/block/nd/Kconfig  |   44 ++++++++++
 drivers/block/nd/Makefile |    6 +
 drivers/block/nd/acpi.c   |  112 +++++++++++++++++++++++++
 drivers/block/nd/core.c   |   48 +++++++++++
 drivers/block/nd/nfit.h   |  201 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 414 insertions(+)
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
 create mode 100644 drivers/block/nd/acpi.c
 create mode 100644 drivers/block/nd/core.c
 create mode 100644 drivers/block/nd/nfit.h

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index eb1fed5bd516..dfe40e5ca9bd 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -321,6 +321,8 @@ config BLK_DEV_NVME
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvme.
 
+source "drivers/block/nd/Kconfig"
+
 config BLK_DEV_SKD
 	tristate "STEC S1120 Block Driver"
 	depends on PCI
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 9cc6c18a1c7e..18b27bb9cd2d 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
 obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
+obj-$(CONFIG_NFIT_DEVICES)	+= nd/
 obj-$(CONFIG_BLK_DEV_SKD)	+= skd.o
 obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
 
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
new file mode 100644
index 000000000000..5fa74f124b3e
--- /dev/null
+++ b/drivers/block/nd/Kconfig
@@ -0,0 +1,44 @@
+config ND_ARCH_HAS_IOREMAP_CACHE
+	depends on (X86 || IA64 || ARM || ARM64 || SH || XTENSA)
+	def_bool y
+
+menuconfig NFIT_DEVICES
+	bool "NVDIMM (NFIT) Support"
+	depends on ND_ARCH_HAS_IOREMAP_CACHE
+	depends on PHYS_ADDR_T_64BIT
+	help
+	  Support for non-volatile memory devices defined by the NVDIMM
+	  Firmware Interface Table. (NFIT)  On platforms that define an
+	  NFIT, via ACPI, or other means, a "nd_bus" is registered to
+	  advertise PM (persistent memory) namespaces (/dev/pmemX) and
+	  BLOCK (sliding block data window) namespaces (/dev/ndX). A PM
+	  namespace refers to a system-physical-address-range than may
+	  span multiple DIMMs and support DAX (see CONFIG_DAX).  A BLOCK
+	  namespace refers to a NVDIMM control region which exposes a
+	  register-based windowed access mode to non-volatile memory.
+	  See the NVDIMM Firmware Interface Table specification for more
+	  details.
+
+if NFIT_DEVICES
+
+config ND_CORE
+	tristate "Core: Generic 'nd' Device Model"
+	help
+	  Platform agnostic device model for an NFIT-defined bus.
+	  Publishes resources for a NFIT-persistent-memory driver and/or
+	  NFIT-block-data-window driver to attach.  Exposes a device
+	  topology under a "ndX" bus device and a "/dev/ndctl<N>"
+	  dimm-ioctl message passing interface per registered NFIT
+	  instance.  A userspace library "ndctl" provides an API to
+	  enumerate/manage this subsystem.
+
+config NFIT_ACPI
+	tristate "NFIT ACPI: Discover ACPI-Namespace NFIT Devices"
+	select ND_CORE
+	depends on ACPI
+	help
+	  Infrastructure to probe the ACPI namespace for NVDIMMs and
+	  register the platform-global NFIT blob with the core.  Also
+	  enables the core to craft ACPI._DSM messages for platform/dimm
+	  configuration.
+endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
new file mode 100644
index 000000000000..22701ab7dcae
--- /dev/null
+++ b/drivers/block/nd/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_ND_CORE) += nd.o
+obj-$(CONFIG_NFIT_ACPI) += nd_acpi.o
+
+nd_acpi-y := acpi.o
+
+nd-y := core.o
diff --git a/drivers/block/nd/acpi.c b/drivers/block/nd/acpi.c
new file mode 100644
index 000000000000..48db723d7a90
--- /dev/null
+++ b/drivers/block/nd/acpi.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/list.h>
+#include <linux/acpi.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include "nfit.h"
+
+enum {
+	NFIT_ACPI_NOTIFY_TABLE = 0x80,
+};
+
+struct acpi_nfit {
+	struct nfit_bus_descriptor nfit_desc;
+	struct acpi_device *dev;
+	struct nd_bus *nd_bus;
+};
+
+static int nd_acpi_ctl(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len)
+{
+	return -ENOTTY;
+}
+
+static int nd_acpi_add(struct acpi_device *dev)
+{
+	struct nfit_bus_descriptor *nfit_desc;
+	struct acpi_table_header *tbl;
+	acpi_status status = AE_OK;
+	struct acpi_nfit *nfit;
+	acpi_size sz;
+
+	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
+	if (ACPI_FAILURE(status)) {
+		dev_err(&dev->dev, "failed to find NFIT\n");
+		return -ENXIO;
+	}
+
+	nfit = devm_kzalloc(&dev->dev, sizeof(*nfit), GFP_KERNEL);
+	if (!nfit)
+		return -ENOMEM;
+	nfit->dev = dev;
+	nfit_desc = &nfit->nfit_desc;
+	nfit_desc->nfit_base = (void __iomem *) tbl;
+	nfit_desc->nfit_size = sz;
+	nfit_desc->provider_name = "ACPI.NFIT";
+	nfit_desc->nfit_ctl = nd_acpi_ctl;
+
+	nfit->nd_bus = nfit_bus_register(&dev->dev, nfit_desc);
+	if (!nfit->nd_bus)
+		return -ENXIO;
+
+	dev_set_drvdata(&dev->dev, nfit);
+	return 0;
+}
+
+static int nd_acpi_remove(struct acpi_device *dev)
+{
+	struct acpi_nfit *nfit = dev_get_drvdata(&dev->dev);
+
+	nfit_bus_unregister(nfit->nd_bus);
+	return 0;
+}
+
+static void nd_acpi_notify(struct acpi_device *dev, u32 event)
+{
+	/* TODO: handle ACPI_NOTIFY_BUS_CHECK notification */
+	dev_dbg(&dev->dev, "%s: event: %d\n", __func__, event);
+}
+
+static const struct acpi_device_id nd_acpi_ids[] = {
+	{ "ACPI0012", 0 },
+	{ "", 0 },
+};
+MODULE_DEVICE_TABLE(acpi, nd_acpi_ids);
+
+static struct acpi_driver nd_acpi_driver = {
+	.name = KBUILD_MODNAME,
+	.ids = nd_acpi_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = nd_acpi_add,
+		.remove = nd_acpi_remove,
+		.notify = nd_acpi_notify
+	},
+};
+
+static __init int nd_acpi_init(void)
+{
+	return acpi_bus_register_driver(&nd_acpi_driver);
+}
+
+static __exit void nd_acpi_exit(void)
+{
+	acpi_bus_unregister_driver(&nd_acpi_driver);
+}
+
+module_init(nd_acpi_init);
+module_exit(nd_acpi_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
new file mode 100644
index 000000000000..8df8d315b726
--- /dev/null
+++ b/drivers/block/nd/core.c
@@ -0,0 +1,48 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/export.h>
+#include <linux/module.h>
+#include "nfit.h"
+
+struct nd_bus *nfit_bus_register(struct device *parent,
+		struct nfit_bus_descriptor *nfit_desc)
+{
+	return NULL;
+}
+EXPORT_SYMBOL(nfit_bus_register);
+
+void nfit_bus_unregister(struct nd_bus *nd_bus)
+{
+}
+EXPORT_SYMBOL(nfit_bus_unregister);
+
+static __init int nd_core_init(void)
+{
+	BUILD_BUG_ON(sizeof(struct nfit) != 40);
+	BUILD_BUG_ON(sizeof(struct nfit_spa) != 56);
+	BUILD_BUG_ON(sizeof(struct nfit_mem) != 48);
+	BUILD_BUG_ON(sizeof(struct nfit_idt) != 16);
+	BUILD_BUG_ON(sizeof(struct nfit_smbios) != 8);
+	BUILD_BUG_ON(sizeof(struct nfit_dcr) != 80);
+	BUILD_BUG_ON(sizeof(struct nfit_bdw) != 40);
+
+	return 0;
+}
+
+static __exit void nd_core_exit(void)
+{
+}
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
+module_init(nd_core_init);
+module_exit(nd_core_exit);
diff --git a/drivers/block/nd/nfit.h b/drivers/block/nd/nfit.h
new file mode 100644
index 000000000000..56a3b2dad124
--- /dev/null
+++ b/drivers/block/nd/nfit.h
@@ -0,0 +1,201 @@
+/*
+ * NVDIMM Firmware Interface Table - NFIT
+ *
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __NFIT_H__
+#define __NFIT_H__
+
+#include <linux/types.h>
+
+enum {
+	NFIT_TABLE_SPA = 0,
+	NFIT_TABLE_MEM = 1,
+	NFIT_TABLE_IDT = 2,
+	NFIT_TABLE_SMBIOS = 3,
+	NFIT_TABLE_DCR = 4,
+	NFIT_TABLE_BDW = 5,
+	NFIT_TABLE_FLUSH = 6,
+	NFIT_SPA_VOLATILE = 0,
+	NFIT_SPA_PM = 1,
+	NFIT_SPA_DCR = 2,
+	NFIT_SPA_BDW = 3,
+	NFIT_SPA_VDISK = 4,
+	NFIT_SPA_VCD = 5,
+	NFIT_SPA_PDISK = 6,
+	NFIT_SPA_PCD = 7,
+	NFIT_SPAF_DCR_HOT_ADD = 1 << 0,
+	NFIT_SPAF_PDVALID = 1 << 1,
+	NFIT_MEMF_SAVE_FAIL = 1 << 0,
+	NFIT_MEMF_RESTORE_FAIL = 1 << 1,
+	NFIT_MEMF_FLUSH_FAIL = 1 << 2,
+	NFIT_MEMF_UNARMED = 1 << 3,
+	NFIT_MEMF_NOTIFY_SMART = 1 << 4,
+	NFIT_MEMF_SMART_READY = 1 << 5,
+	NFIT_DCRF_BUFFERED = 1 << 0,
+};
+
+/**
+ * struct nfit - Nvdimm Firmware Interface Table
+ * @signature: "NFIT"
+ * @length: sum of size of this table plus all appended subtables
+ */
+struct nfit {
+	__u8 signature[4];
+	__le32 length;
+	__u8 revision;
+	__u8 checksum;
+	__u8 oemid[6];
+	__le64 oem_tbl_id;
+	__le32 oem_revision;
+	__le32 creator_id;
+	__le32 creator_revision;
+	__le32 reserved;
+} __packed;
+
+/**
+ * struct nfit_spa - System Physical Address Range Descriptor Table
+ */
+struct nfit_spa {
+	__le16 type;
+	__le16 length;
+	__le16 spa_index;
+	__le16 flags;
+	__le32 reserved;
+	__le32 proximity_domain;
+	__u8 type_uuid[16];
+	__le64 spa_base;
+	__le64 spa_length;
+	__le64 mem_attr;
+} __packed;
+
+/**
+ * struct nfit_mem - Memory Device to SPA Mapping Table
+ */
+struct nfit_mem {
+	__le16 type;
+	__le16 length;
+	__le32 nfit_handle;
+	__le16 phys_id;
+	__le16 region_id;
+	__le16 spa_index;
+	__le16 dcr_index;
+	__le64 region_len;
+	__le64 region_spa_offset;
+	__le64 region_dpa;
+	__le16 idt_index;
+	__le16 interleave_ways;
+	__le16 flags;
+	__le16 reserved;
+} __packed;
+
+/**
+ * struct nfit_idt - Interleave description Table
+ */
+struct nfit_idt {
+	__le16 type;
+	__le16 length;
+	__le16 idt_index;
+	__le16 reserved;
+	__le32 num_lines;
+	__le32 line_size;
+	__le32 line_offset[0];
+} __packed;
+
+/**
+ * struct nfit_smbios - SMBIOS Management Information Table
+ */
+struct nfit_smbios {
+	__le16 type;
+	__le16 length;
+	__le32 reserved;
+	__u8 data[0];
+} __packed;
+
+/**
+ * struct nfit_dcr - NVDIMM Control Region Table
+ * @fic: Format Interface Code
+ * @cmd_offset: command registers relative to block control window
+ * @status_offset: status registers relative to block control window
+ */
+struct nfit_dcr {
+	__le16 type;
+	__le16 length;
+	__le16 dcr_index;
+	__le16 vendor_id;
+	__le16 device_id;
+	__le16 revision_id;
+	__le16 sub_vendor_id;
+	__le16 sub_device_id;
+	__le16 sub_revision_id;
+	__u8 reserved[6];
+	__le32 serial_number;
+	__le16 fic;
+	__le16 num_bcw;
+	__le64 bcw_size;
+	__le64 cmd_offset;
+	__le64 cmd_size;
+	__le64 status_offset;
+	__le64 status_size;
+	__le16 flags;
+	__u8 reserved2[6];
+} __packed;
+
+/**
+ * struct nfit_bdw - NVDIMM Block Data Window Region Table
+ */
+struct nfit_bdw {
+	__le16 type;
+	__le16 length;
+	__le16 dcr_index;
+	__le16 num_bdw;
+	__le64 bdw_offset;
+	__le64 bdw_size;
+	__le64 blk_capacity;
+	__le64 blk_offset;
+} __packed;
+
+/**
+ * struct nfit_flush - Flush Hint Address Structure
+ */
+struct nfit_flush {
+	__le16 type;
+	__le16 length;
+	__le32 nfit_handle;
+	__le16 num_hints;
+	__u8 reserved[6];
+	__le64 hint_addr[0];
+};
+
+struct nd_dimm;
+struct nfit_bus_descriptor;
+typedef int (*nfit_ctl_fn)(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len);
+
+typedef int (*nfit_add_dimm_fn)(struct nfit_bus_descriptor *nfit_desc,
+		struct nd_dimm *nd_dimm);
+
+struct nfit_bus_descriptor {
+	unsigned long dsm_mask;
+	void __iomem *nfit_base;
+	size_t nfit_size;
+	char *provider_name;
+	nfit_ctl_fn nfit_ctl;
+	nfit_add_dimm_fn add_dimm;
+};
+
+struct nd_bus;
+struct nd_bus *nfit_bus_register(struct device *parent,
+		struct nfit_bus_descriptor *nfit_desc);
+void nfit_bus_unregister(struct nd_bus *nd_bus);
+#endif /* __NFIT_H__ */

