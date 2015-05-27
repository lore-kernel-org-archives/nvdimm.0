Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 02/21] libnd,
 nfit: initial libnd infrastructure and NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 May 2015 18:24:53 -0400
Message-ID: <20150527222453.17965.42506.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mingo@kernel.org, sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Lv Zheng <lv.zheng@intel.com>, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

A libnd bus is the anchor device for registering nvdimm resources and
interfaces, for example, a character control device, nvdimm devices,
and I/O region devices.  The ACPI NFIT (NVDIMM Firmware Interface Table)
is one possible platform description for such non-volatile memory
resources in a system.  The nfit.ko driver attaches to the "ACPI0012"
device that indicates the presence of the NFIT and parses the table to
register a libnd bus instance.

Cc: <linux-acpi@vger.kernel.org>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/Kconfig          |   15 +
 drivers/acpi/Makefile         |    1 
 drivers/acpi/nfit.c           |  444 +++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/nfit.h           |   89 ++++++++
 drivers/block/Kconfig         |    2 
 drivers/block/Makefile        |    1 
 drivers/block/nd/Kconfig      |   20 ++
 drivers/block/nd/Makefile     |    3 
 drivers/block/nd/core.c       |   67 ++++++
 drivers/block/nd/nd-private.h |   23 ++
 include/acpi/actbl1.h         |  154 ++++++++++++++
 include/acpi/acuuid.h         |   89 ++++++++
 include/linux/libnd.h         |   34 +++
 13 files changed, 942 insertions(+)
 create mode 100644 drivers/acpi/nfit.c
 create mode 100644 drivers/acpi/nfit.h
 create mode 100644 drivers/block/nd/Kconfig
 create mode 100644 drivers/block/nd/Makefile
 create mode 100644 drivers/block/nd/core.c
 create mode 100644 drivers/block/nd/nd-private.h
 create mode 100644 include/acpi/acuuid.h
 create mode 100644 include/linux/libnd.h

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index e6c3ddd92665..84d046d4ed17 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -375,6 +375,21 @@ config ACPI_REDUCED_HARDWARE_ONLY
 
 	  If you are unsure what to do, do not enable this option.
 
+config ACPI_NFIT
+	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
+	depends on PHYS_ADDR_T_64BIT
+	depends on BLK_DEV
+	select ND_DEVICES
+	select LIBND
+	help
+	  Infrastructure to probe ACPI 6 compliant platforms for
+	  NVDIMMs (NFIT) and register a libnd device tree.  In
+	  addition to storage devices this also enables libnd to pass
+	  ACPI._DSM messages for platform/dimm configuration.
+
+	  To compile this driver as a module, choose M here:
+	  the module will be called nfit.
+
 source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 623b117ad1a2..cd91093b7acf 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_ACPI_PCI_SLOT)	+= pci_slot.o
 obj-$(CONFIG_ACPI_PROCESSOR)	+= processor.o
 obj-y				+= container.o
 obj-$(CONFIG_ACPI_THERMAL)	+= thermal.o
+obj-$(CONFIG_ACPI_NFIT)		+= nfit.o
 obj-y				+= acpi_memhotplug.o
 obj-$(CONFIG_ACPI_HOTPLUG_IOAPIC) += ioapic.o
 obj-$(CONFIG_ACPI_BATTERY)	+= battery.o
diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
new file mode 100644
index 000000000000..13132a16901c
--- /dev/null
+++ b/drivers/acpi/nfit.c
@@ -0,0 +1,444 @@
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
+#include <linux/list_sort.h>
+#include <linux/module.h>
+#include <linux/libnd.h>
+#include <linux/list.h>
+#include <linux/acpi.h>
+#include "nfit.h"
+
+static u8 nfit_uuid[NFIT_UUID_MAX][16];
+
+static const u8 *to_nfit_uuid(enum nfit_uuids id)
+{
+	return nfit_uuid[id];
+}
+
+static int acpi_nfit_ctl(struct nd_bus_descriptor *nd_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len)
+{
+	return -ENOTTY;
+}
+
+static const char *spa_type_name(u16 type)
+{
+	switch (type) {
+	case NFIT_SPA_VOLATILE: return "volatile";
+	case NFIT_SPA_PM: return "pmem";
+	case NFIT_SPA_DCR: return "dimm-control-region";
+	case NFIT_SPA_BDW: return "block-data-window";
+	default: return "unknown";
+	}
+}
+
+static int nfit_spa_type(struct acpi_nfit_system_address *spa)
+{
+	int i;
+
+	for (i = 0; i < NFIT_UUID_MAX; i++)
+		if (memcmp(to_nfit_uuid(i), spa->range_guid, 16) == 0)
+			return i;
+	return -1;
+}
+
+static void *add_table(struct acpi_nfit_desc *acpi_desc, void *table, const void *end)
+{
+	struct device *dev = acpi_desc->dev;
+	struct acpi_nfit_header *hdr;
+	void *err = ERR_PTR(-ENOMEM);
+
+	if (table >= end)
+		return NULL;
+
+	hdr = (struct acpi_nfit_header *) table;
+	switch (hdr->type) {
+	case ACPI_NFIT_TYPE_SYSTEM_ADDRESS: {
+		struct nfit_spa *nfit_spa = devm_kzalloc(dev, sizeof(*nfit_spa),
+				GFP_KERNEL);
+		struct acpi_nfit_system_address *spa = table;
+
+		if (!nfit_spa)
+			return err;
+		INIT_LIST_HEAD(&nfit_spa->list);
+		nfit_spa->spa = spa;
+		list_add_tail(&nfit_spa->list, &acpi_desc->spas);
+		dev_dbg(dev, "%s: spa index: %d type: %s\n", __func__,
+				spa->range_index,
+				spa_type_name(nfit_spa_type(spa)));
+		break;
+	}
+	case ACPI_NFIT_TYPE_MEMORY_MAP: {
+		struct nfit_memdev *nfit_memdev = devm_kzalloc(dev,
+				sizeof(*nfit_memdev), GFP_KERNEL);
+		struct acpi_nfit_memory_map *memdev = table;
+
+		if (!nfit_memdev)
+			return err;
+		INIT_LIST_HEAD(&nfit_memdev->list);
+		nfit_memdev->memdev = memdev;
+		list_add_tail(&nfit_memdev->list, &acpi_desc->memdevs);
+		dev_dbg(dev, "%s: memdev handle: %#x spa: %d dcr: %d\n",
+				__func__, memdev->device_handle, memdev->range_index,
+				memdev->region_index);
+		break;
+	}
+	case ACPI_NFIT_TYPE_CONTROL_REGION: {
+		struct nfit_dcr *nfit_dcr = devm_kzalloc(dev, sizeof(*nfit_dcr),
+				GFP_KERNEL);
+		struct acpi_nfit_control_region *dcr = table;
+
+		if (!nfit_dcr)
+			return err;
+		INIT_LIST_HEAD(&nfit_dcr->list);
+		nfit_dcr->dcr = dcr;
+		list_add_tail(&nfit_dcr->list, &acpi_desc->dcrs);
+		dev_dbg(dev, "%s: dcr index: %d windows: %d\n", __func__,
+				dcr->region_index, dcr->windows);
+		break;
+	}
+	case ACPI_NFIT_TYPE_DATA_REGION: {
+		struct nfit_bdw *nfit_bdw = devm_kzalloc(dev, sizeof(*nfit_bdw),
+				GFP_KERNEL);
+		struct acpi_nfit_data_region *bdw = table;
+
+		if (!nfit_bdw)
+			return err;
+		INIT_LIST_HEAD(&nfit_bdw->list);
+		nfit_bdw->bdw = bdw;
+		list_add_tail(&nfit_bdw->list, &acpi_desc->bdws);
+		dev_dbg(dev, "%s: bdw dcr: %d windows: %d\n", __func__,
+				bdw->region_index, bdw->windows);
+		break;
+	}
+	/* TODO */
+	case ACPI_NFIT_TYPE_INTERLEAVE:
+		dev_dbg(dev, "%s: idt\n", __func__);
+		break;
+	case ACPI_NFIT_TYPE_FLUSH_ADDRESS:
+		dev_dbg(dev, "%s: flush\n", __func__);
+		break;
+	case ACPI_NFIT_TYPE_SMBIOS:
+		dev_dbg(dev, "%s: smbios\n", __func__);
+		break;
+	default:
+		dev_err(dev, "unknown table '%d' parsing nfit\n", hdr->type);
+		break;
+	}
+
+	return table + hdr->length;
+}
+
+static void nfit_mem_find_spa_bdw(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem)
+{
+	u32 device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
+	u16 dcr_index = nfit_mem->dcr->region_index;
+	struct nfit_spa *nfit_spa;
+
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		u16 range_index = nfit_spa->spa->range_index;
+		int type = nfit_spa_type(nfit_spa->spa);
+		struct nfit_memdev *nfit_memdev;
+
+		if (type != NFIT_SPA_BDW)
+			continue;
+
+		list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+			if (nfit_memdev->memdev->range_index != range_index)
+				continue;
+			if (nfit_memdev->memdev->device_handle != device_handle)
+				continue;
+			if (nfit_memdev->memdev->region_index != dcr_index)
+				continue;
+
+			nfit_mem->spa_bdw = nfit_spa->spa;
+			return;
+		}
+	}
+
+	dev_dbg(acpi_desc->dev, "SPA-BDW not found for SPA-DCR %d\n",
+			nfit_mem->spa_dcr->range_index);
+	nfit_mem->bdw = NULL;
+}
+
+static int nfit_mem_add(struct acpi_nfit_desc *acpi_desc,
+		struct nfit_mem *nfit_mem, struct acpi_nfit_system_address *spa)
+{
+	u16 dcr_index = __to_nfit_memdev(nfit_mem)->region_index;
+	struct nfit_dcr *nfit_dcr;
+	struct nfit_bdw *nfit_bdw;
+
+	list_for_each_entry(nfit_dcr, &acpi_desc->dcrs, list) {
+		if (nfit_dcr->dcr->region_index != dcr_index)
+			continue;
+		nfit_mem->dcr = nfit_dcr->dcr;
+		break;
+	}
+
+	if (!nfit_mem->dcr) {
+		dev_dbg(acpi_desc->dev, "SPA %d missing:%s%s\n", spa->range_index,
+				__to_nfit_memdev(nfit_mem) ? "" : " MEMDEV",
+				nfit_mem->dcr ? "" : " DCR");
+		return -ENODEV;
+	}
+
+	/*
+	 * We've found enough to create an nd_dimm, optionally
+	 * find an associated BDW
+	 */
+	list_add(&nfit_mem->list, &acpi_desc->dimms);
+
+	list_for_each_entry(nfit_bdw, &acpi_desc->bdws, list) {
+		if (nfit_bdw->bdw->region_index != dcr_index)
+			continue;
+		nfit_mem->bdw = nfit_bdw->bdw;
+		break;
+	}
+
+	if (!nfit_mem->bdw)
+		return 0;
+
+	nfit_mem_find_spa_bdw(acpi_desc, nfit_mem);
+	return 0;
+}
+
+static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
+		struct acpi_nfit_system_address *spa)
+{
+	struct nfit_mem *nfit_mem, *found;
+	struct nfit_memdev *nfit_memdev;
+	int type = nfit_spa_type(spa);
+	u16 dcr_index;
+
+	switch (type) {
+	case NFIT_SPA_DCR:
+	case NFIT_SPA_PM:
+		break;
+	default:
+		return 0;
+	}
+
+	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
+		int rc;
+
+		if (nfit_memdev->memdev->range_index != spa->range_index)
+			continue;
+		found = NULL;
+		dcr_index = nfit_memdev->memdev->region_index;
+		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list)
+			if (__to_nfit_memdev(nfit_mem)->region_index == dcr_index) {
+				found = nfit_mem;
+				break;
+			}
+
+		if (found)
+			nfit_mem = found;
+		else {
+			nfit_mem = devm_kzalloc(acpi_desc->dev,
+					sizeof(*nfit_mem), GFP_KERNEL);
+			if (!nfit_mem)
+				return -ENOMEM;
+			INIT_LIST_HEAD(&nfit_mem->list);
+		}
+
+		if (type == NFIT_SPA_DCR) {
+			/* multiple dimms may share a SPA when interleaved */
+			nfit_mem->spa_dcr = spa;
+			nfit_mem->memdev_dcr = nfit_memdev->memdev;
+		} else {
+			/*
+			 * A single dimm may belong to multiple SPA-PM
+			 * ranges, record at least one in addition to
+			 * any SPA-DCR range.
+			 */
+			nfit_mem->memdev_pmem = nfit_memdev->memdev;
+		}
+
+		if (found)
+			continue;
+
+		rc = nfit_mem_add(acpi_desc, nfit_mem, spa);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int nfit_mem_cmp(void *priv, struct list_head *__a, struct list_head *__b)
+{
+	struct nfit_mem *a = container_of(__a, typeof(*a), list);
+	struct nfit_mem *b = container_of(__b, typeof(*b), list);
+	u32 handleA, handleB;
+
+	handleA = __to_nfit_memdev(a)->device_handle;
+	handleB = __to_nfit_memdev(b)->device_handle;
+	if (handleA < handleB)
+		return -1;
+	else if (handleA > handleB)
+		return 1;
+	return 0;
+}
+
+static int nfit_mem_init(struct acpi_nfit_desc *acpi_desc)
+{
+	struct nfit_spa *nfit_spa;
+
+	/*
+	 * For each SPA-DCR or SPA-PMEM address range find its
+	 * corresponding MEMDEV(s).  From each MEMDEV find the
+	 * corresponding DCR.  Then, if we're operating on a SPA-DCR,
+	 * try to find a SPA-BDW and a corresponding BDW that references
+	 * the DCR.  Throw it all into an nfit_mem object.  Note, that
+	 * BDWs are optional.
+	 */
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
+		int rc;
+
+		rc = nfit_mem_dcr_init(acpi_desc, nfit_spa->spa);
+		if (rc)
+			return rc;
+	}
+
+	list_sort(NULL, &acpi_desc->dimms, nfit_mem_cmp);
+
+	return 0;
+}
+
+static int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
+{
+	struct device *dev = acpi_desc->dev;
+	const void *end;
+	u8 *data;
+
+	INIT_LIST_HEAD(&acpi_desc->spas);
+	INIT_LIST_HEAD(&acpi_desc->dcrs);
+	INIT_LIST_HEAD(&acpi_desc->bdws);
+	INIT_LIST_HEAD(&acpi_desc->memdevs);
+	INIT_LIST_HEAD(&acpi_desc->dimms);
+
+	data = (u8 *) acpi_desc->nfit;
+	end = data + sz;
+	data += sizeof(struct acpi_table_nfit);
+	while (!IS_ERR_OR_NULL(data))
+		data = add_table(acpi_desc, data, end);
+
+	if (IS_ERR(data)) {
+		dev_dbg(dev, "%s: nfit table parsing error: %ld\n", __func__,
+				PTR_ERR(data));
+		return PTR_ERR(data);
+	}
+
+	if (nfit_mem_init(acpi_desc) != 0)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int acpi_nfit_add(struct acpi_device *adev)
+{
+	struct nd_bus_descriptor *nd_desc;
+	struct acpi_nfit_desc *acpi_desc;
+	struct device *dev = &adev->dev;
+	struct acpi_table_header *tbl;
+	acpi_status status = AE_OK;
+	acpi_size sz;
+	int rc;
+
+	status = acpi_get_table_with_size("NFIT", 0, &tbl, &sz);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "failed to find NFIT\n");
+		return -ENXIO;
+	}
+
+	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
+	if (!acpi_desc)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, acpi_desc);
+	acpi_desc->dev = dev;
+	acpi_desc->nfit = (struct acpi_table_nfit *) tbl;
+	nd_desc = &acpi_desc->nd_desc;
+	nd_desc->provider_name = "ACPI.NFIT";
+	nd_desc->ndctl = acpi_nfit_ctl;
+
+	acpi_desc->nd_bus = nd_bus_register(dev, nd_desc);
+	if (!acpi_desc->nd_bus)
+		return -ENXIO;
+
+	rc = acpi_nfit_init(acpi_desc, sz);
+	if (rc) {
+		nd_bus_unregister(acpi_desc->nd_bus);
+		return rc;
+	}
+	return 0;
+}
+
+static int acpi_nfit_remove(struct acpi_device *adev)
+{
+	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(&adev->dev);
+
+	nd_bus_unregister(acpi_desc->nd_bus);
+	return 0;
+}
+
+static const struct acpi_device_id acpi_nfit_ids[] = {
+	{ "ACPI0012", 0 },
+	{ "", 0 },
+};
+MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
+
+static struct acpi_driver acpi_nfit_driver = {
+	.name = KBUILD_MODNAME,
+	.ids = acpi_nfit_ids,
+	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,
+	.ops = {
+		.add = acpi_nfit_add,
+		.remove = acpi_nfit_remove,
+	},
+};
+
+static __init int nfit_init(void)
+{
+	BUILD_BUG_ON(sizeof(struct acpi_table_nfit) != 40);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_system_address) != 56);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_memory_map) != 48);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_interleave) != 20);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_smbios) != 9);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_control_region) != 80);
+	BUILD_BUG_ON(sizeof(struct acpi_nfit_data_region) != 40);
+
+	acpi_str_to_uuid(UUID_VOLATILE_MEMORY, nfit_uuid[NFIT_SPA_VOLATILE]);
+	acpi_str_to_uuid(UUID_PERSISTENT_MEMORY, nfit_uuid[NFIT_SPA_PM]);
+	acpi_str_to_uuid(UUID_CONTROL_REGION, nfit_uuid[NFIT_SPA_DCR]);
+	acpi_str_to_uuid(UUID_DATA_REGION, nfit_uuid[NFIT_SPA_BDW]);
+	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_VDISK]);
+	acpi_str_to_uuid(UUID_VOLATILE_VIRTUAL_CD, nfit_uuid[NFIT_SPA_VCD]);
+	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_DISK, nfit_uuid[NFIT_SPA_PDISK]);
+	acpi_str_to_uuid(UUID_PERSISTENT_VIRTUAL_CD, nfit_uuid[NFIT_SPA_PCD]);
+	acpi_str_to_uuid(UUID_NFIT_BUS, nfit_uuid[NFIT_DEV_BUS]);
+	acpi_str_to_uuid(UUID_NFIT_DIMM, nfit_uuid[NFIT_DEV_DIMM]);
+
+	return acpi_bus_register_driver(&acpi_nfit_driver);
+}
+
+static __exit void nfit_exit(void)
+{
+	acpi_bus_unregister_driver(&acpi_nfit_driver);
+}
+
+module_init(nfit_init);
+module_exit(nfit_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
new file mode 100644
index 000000000000..ff72da9c9694
--- /dev/null
+++ b/drivers/acpi/nfit.h
@@ -0,0 +1,89 @@
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
+#include <linux/types.h>
+#include <linux/libnd.h>
+#include <linux/uuid.h>
+#include <linux/acpi.h>
+#include <acpi/acuuid.h>
+
+#define UUID_NFIT_BUS "2f10e7a4-9e91-11e4-89d3-123b93f75cba"
+#define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
+
+enum nfit_uuids {
+	NFIT_SPA_VOLATILE,
+	NFIT_SPA_PM,
+	NFIT_SPA_DCR,
+	NFIT_SPA_BDW,
+	NFIT_SPA_VDISK,
+	NFIT_SPA_VCD,
+	NFIT_SPA_PDISK,
+	NFIT_SPA_PCD,
+	NFIT_DEV_BUS,
+	NFIT_DEV_DIMM,
+	NFIT_UUID_MAX,
+};
+
+struct nfit_spa {
+	struct acpi_nfit_system_address *spa;
+	struct list_head list;
+};
+
+struct nfit_dcr {
+	struct acpi_nfit_control_region *dcr;
+	struct list_head list;
+};
+
+struct nfit_bdw {
+	struct acpi_nfit_data_region *bdw;
+	struct list_head list;
+};
+
+struct nfit_memdev {
+	struct acpi_nfit_memory_map *memdev;
+	struct list_head list;
+};
+
+/* assembled tables for a given dimm/memory-device */
+struct nfit_mem {
+	struct acpi_nfit_memory_map *memdev_dcr;
+	struct acpi_nfit_memory_map *memdev_pmem;
+	struct acpi_nfit_control_region *dcr;
+	struct acpi_nfit_data_region *bdw;
+	struct acpi_nfit_system_address *spa_dcr;
+	struct acpi_nfit_system_address *spa_bdw;
+	struct list_head list;
+};
+
+struct acpi_nfit_desc {
+	struct nd_bus_descriptor nd_desc;
+	struct acpi_table_nfit *nfit;
+	struct list_head memdevs;
+	struct list_head dimms;
+	struct list_head spas;
+	struct list_head dcrs;
+	struct list_head bdws;
+	struct nd_bus *nd_bus;
+	struct device *dev;
+};
+
+static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfit_mem)
+{
+	if (nfit_mem->memdev_dcr)
+		return nfit_mem->memdev_dcr;
+	return nfit_mem->memdev_pmem;
+}
+#endif /* __NFIT_H__ */
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
index 9cc6c18a1c7e..07a6acecf4d8 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_CDROM_PKTCDVD)	+= pktcdvd.o
 obj-$(CONFIG_MG_DISK)		+= mg_disk.o
 obj-$(CONFIG_SUNVDC)		+= sunvdc.o
 obj-$(CONFIG_BLK_DEV_NVME)	+= nvme.o
+obj-$(CONFIG_ND_DEVICES)	+= nd/
 obj-$(CONFIG_BLK_DEV_SKD)	+= skd.o
 obj-$(CONFIG_BLK_DEV_OSD)	+= osdblk.o
 
diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
new file mode 100644
index 000000000000..9b909c21afa1
--- /dev/null
+++ b/drivers/block/nd/Kconfig
@@ -0,0 +1,20 @@
+menuconfig ND_DEVICES
+	bool "NVDIMM (Non-Volatile Memory Device) Support"
+	help
+	  Generic support for non-volatile memory devices including
+	  ACPI-6-NFIT defined resources.  On platforms that define an
+	  NFIT, or otherwise can discover NVDIMM resources, a libnd
+	  bus is registered to advertise PMEM (persistent memory)
+	  namespaces (/dev/pmemX) and BLK (sliding mmio window(s))
+	  namespaces (/dev/ndX). A PMEM namespace refers to a memory
+	  resource that may span multiple DIMMs and support DAX (see
+	  CONFIG_DAX).  A BLK namespace refers to an NVDIMM control
+	  region which exposes an mmio register set for windowed
+	  access mode to non-volatile memory.
+
+if ND_DEVICES
+
+config LIBND
+	tristate
+
+endif
diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
new file mode 100644
index 000000000000..a647ff6cf557
--- /dev/null
+++ b/drivers/block/nd/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_LIBND) += libnd.o
+
+libnd-y := core.o
diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
new file mode 100644
index 000000000000..15b89ce1a9af
--- /dev/null
+++ b/drivers/block/nd/core.c
@@ -0,0 +1,67 @@
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
+#include <linux/device.h>
+#include <linux/libnd.h>
+#include <linux/slab.h>
+#include "nd-private.h"
+
+static DEFINE_IDA(nd_ida);
+
+static void nd_bus_release(struct device *dev)
+{
+	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
+
+	ida_simple_remove(&nd_ida, nd_bus->id);
+	kfree(nd_bus);
+}
+
+struct nd_bus *nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nd_desc)
+{
+	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
+	int rc;
+
+	if (!nd_bus)
+		return NULL;
+	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	if (nd_bus->id < 0) {
+		kfree(nd_bus);
+		return NULL;
+	}
+	nd_bus->nd_desc = nd_desc;
+	nd_bus->dev.parent = parent;
+	nd_bus->dev.release = nd_bus_release;
+	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
+	rc = device_register(&nd_bus->dev);
+	if (rc) {
+		dev_dbg(&nd_bus->dev, "device registration failed: %d\n", rc);
+		put_device(&nd_bus->dev);
+		return NULL;
+	}
+
+	return nd_bus;
+}
+EXPORT_SYMBOL_GPL(nd_bus_register);
+
+void nd_bus_unregister(struct nd_bus *nd_bus)
+{
+	if (!nd_bus)
+		return;
+	device_unregister(&nd_bus->dev);
+}
+EXPORT_SYMBOL_GPL(nd_bus_unregister);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Intel Corporation");
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
new file mode 100644
index 000000000000..a107a19ffa9c
--- /dev/null
+++ b/drivers/block/nd/nd-private.h
@@ -0,0 +1,23 @@
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
+#ifndef __ND_PRIVATE_H__
+#define __ND_PRIVATE_H__
+#include <linux/device.h>
+#include <linux/libnd.h>
+
+struct nd_bus {
+	struct nd_bus_descriptor *nd_desc;
+	struct device dev;
+	int id;
+};
+#endif /* __ND_PRIVATE_H__ */
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index b80b0e6dabc5..b0e431dbfd9e 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -71,6 +71,7 @@
 #define ACPI_SIG_SBST           "SBST"	/* Smart Battery Specification Table */
 #define ACPI_SIG_SLIT           "SLIT"	/* System Locality Distance Information Table */
 #define ACPI_SIG_SRAT           "SRAT"	/* System Resource Affinity Table */
+#define ACPI_SIG_NFIT           "NFIT"	/* NVDIMM Firmware Interface Table */
 
 /*
  * All tables must be byte-packed to match the ACPI specification, since
@@ -908,6 +909,159 @@ struct acpi_msct_proximity {
 
 /*******************************************************************************
  *
+ * NFIT - NVDIMM Interface Table (ACPI 6.0)
+ *        Version 1
+ *
+ ******************************************************************************/
+
+struct acpi_table_nfit {
+	struct acpi_table_header header;	/* Common ACPI table header */
+	u32 reserved;		/* Reserved, must be zero */
+};
+
+/* Subtable header for NFIT */
+
+struct acpi_nfit_header {
+	u16 type;
+	u16 length;
+};
+
+/* Values for subtable type in struct acpi_nfit_header */
+
+enum acpi_nfit_type {
+	ACPI_NFIT_TYPE_SYSTEM_ADDRESS = 0,
+	ACPI_NFIT_TYPE_MEMORY_MAP = 1,
+	ACPI_NFIT_TYPE_INTERLEAVE = 2,
+	ACPI_NFIT_TYPE_SMBIOS = 3,
+	ACPI_NFIT_TYPE_CONTROL_REGION = 4,
+	ACPI_NFIT_TYPE_DATA_REGION = 5,
+	ACPI_NFIT_TYPE_FLUSH_ADDRESS = 6,
+	ACPI_NFIT_TYPE_RESERVED = 7	/* 7 and greater are reserved */
+};
+
+/*
+ * NFIT Subtables
+ */
+
+/* 0: System Physical Address Range Structure */
+
+struct acpi_nfit_system_address {
+	struct acpi_nfit_header header;
+	u16 range_index;
+	u16 flags;
+	u32 reserved;		/* Reseved, must be zero */
+	u32 proximity_domain;
+	u8 range_guid[16];
+	u64 address;
+	u64 length;
+	u64 memory_mapping;
+};
+
+/* Flags */
+
+#define ACPI_NFIT_ADD_ONLINE_ONLY       (1)	/* 00: Add/Online Operation Only */
+#define ACPI_NFIT_PROXIMITY_VALID       (1<<1)	/* 01: Proximity Domain Valid */
+
+/* Range Type GUIDs appear in the include/acuuid.h file */
+
+/* 1: Memory Device to System Address Range Map Structure */
+
+struct acpi_nfit_memory_map {
+	struct acpi_nfit_header header;
+	u32 device_handle;
+	u16 physical_id;
+	u16 region_id;
+	u16 range_index;
+	u16 region_index;
+	u64 region_size;
+	u64 region_offset;
+	u64 address;
+	u16 interleave_index;
+	u16 interleave_ways;
+	u16 flags;
+	u16 reserved;		/* Reserved, must be zero */
+};
+
+/* Flags */
+
+#define ACPI_NFIT_MEM_SAVE_FAILED       (1)	/* 00: Last SAVE to Memory Device failed */
+#define ACPI_NFIT_MEM_RESTORE_FAILED    (1<<1)	/* 01: Last RESTORE from Memory Device failed */
+#define ACPI_NFIT_MEM_FLUSH_FAILED      (1<<2)	/* 02: Platform flush failed */
+#define ACPI_NFIT_MEM_ARMED             (1<<3)	/* 03: Memory Device observed to be not armed */
+#define ACPI_NFIT_MEM_HEALTH_OBSERVED   (1<<4)	/* 04: Memory Device observed SMART/health events */
+#define ACPI_NFIT_MEM_HEALTH_ENABLED    (1<<5)	/* 05: SMART/health events enabled */
+
+/* 2: Interleave Structure */
+
+struct acpi_nfit_interleave {
+	struct acpi_nfit_header header;
+	u16 interleave_index;
+	u16 reserved;		/* Reserved, must be zero */
+	u32 line_count;
+	u32 line_size;
+	u32 line_offset[1];	/* Variable length */
+};
+
+/* 3: SMBIOS Management Information Structure */
+
+struct acpi_nfit_smbios {
+	struct acpi_nfit_header header;
+	u32 reserved;		/* Reserved, must be zero */
+	u8 data[1];		/* Variable length */
+};
+
+/* 4: NVDIMM Control Region Structure */
+
+struct acpi_nfit_control_region {
+	struct acpi_nfit_header header;
+	u16 region_index;
+	u16 vendor_id;
+	u16 device_id;
+	u16 revision_id;
+	u16 subsystem_vendor_id;
+	u16 subsystem_device_id;
+	u16 subsystem_revision_id;
+	u8 reserved[6];		/* Reserved, must be zero */
+	u32 serial_number;
+	u16 code;
+	u16 windows;
+	u64 window_size;
+	u64 command_offset;
+	u64 command_size;
+	u64 status_offset;
+	u64 status_size;
+	u16 flags;
+	u8 reserved1[6];	/* Reserved, must be zero */
+};
+
+/* Flags */
+
+#define ACPI_NFIT_CONTROL_BUFFERED      (1)	/* Block Data Windows implementation is buffered */
+
+/* 5: NVDIMM Block Data Window Region Structure */
+
+struct acpi_nfit_data_region {
+	struct acpi_nfit_header header;
+	u16 region_index;
+	u16 windows;
+	u64 offset;
+	u64 size;
+	u64 capacity;
+	u64 start_address;
+};
+
+/* 6: Flush Hint Address Structure */
+
+struct acpi_nfit_flush_address {
+	struct acpi_nfit_header header;
+	u32 device_handle;
+	u16 hint_count;
+	u8 reserved[6];		/* Reserved, must be zero */
+	u64 hint_address[1];	/* Variable length */
+};
+
+/*******************************************************************************
+ *
  * SBST - Smart Battery Specification Table
  *        Version 1
  *
diff --git a/include/acpi/acuuid.h b/include/acpi/acuuid.h
new file mode 100644
index 000000000000..80fe8cf74d7a
--- /dev/null
+++ b/include/acpi/acuuid.h
@@ -0,0 +1,89 @@
+/******************************************************************************
+ *
+ * Name: acuuid.h - ACPI-related UUID/GUID definitions
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2015, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#ifndef __ACUUID_H__
+#define __ACUUID_H__
+
+/*
+ * Note1: UUIDs and GUIDs are defined to be identical in ACPI.
+ *
+ * Note2: This file is standalone and should remain that way.
+ */
+
+/* Controllers */
+
+#define UUID_GPIO_CONTROLLER            "4f248f40-d5e2-499f-834c-27758ea1cd3f"
+#define UUID_USB_CONTROLLER             "ce2ee385-00e6-48cb-9f05-2edb927c4899"
+#define UUID_SATA_CONTROLLER            "e4db149b-fcfe-425b-a6d8-92357d78fc7f"
+
+/* Devices */
+
+#define UUID_PCI_HOST_BRIDGE            "33db4d5b-1ff7-401c-9657-7441c03dd766"
+#define UUID_I2C_DEVICE                 "3cdff6f7-4267-4555-ad05-b30a3d8938de"
+#define UUID_POWER_BUTTON               "dfbcf3c5-e7a5-44e6-9c1f-29c76f6e059c"
+
+/* Interfaces */
+
+#define UUID_DEVICE_LABELING            "e5c937d0-3553-4d7a-9117-ea4d19c3434d"
+#define UUID_PHYSICAL_PRESENCE          "3dddfaa6-361b-4eb4-a424-8d10089d1653"
+
+/* NVDIMM - NFIT table */
+
+#define UUID_VOLATILE_MEMORY            "7305944f-fdda-44e3-b16c-3f22d252e5d0"
+#define UUID_PERSISTENT_MEMORY          "66f0d379-b4f3-4074-ac43-0d3318b78cdb"
+#define UUID_CONTROL_REGION             "92f701f6-13b4-405d-910b-299367e8234c"
+#define UUID_DATA_REGION                "91af0530-5d86-470e-a6b0-0a2db9408249"
+#define UUID_VOLATILE_VIRTUAL_DISK      "77ab535a-45fc-624b-5560-f7b281d1f96e"
+#define UUID_VOLATILE_VIRTUAL_CD        "3d5abd30-4175-87ce-6d64-d2ade523c4bb"
+#define UUID_PERSISTENT_VIRTUAL_DISK    "5cea02c9-4d07-69d3-269f-4496fbe096f9"
+#define UUID_PERSISTENT_VIRTUAL_CD      "08018188-42cd-bb48-100f-5387d53ded3d"
+
+/* Miscellaneous */
+
+#define UUID_PLATFORM_CAPABILITIES      "0811b06e-4a27-44f9-8d60-3cbbc22e7b48"
+#define UUID_DYNAMIC_ENUMERATION        "d8c1a3a6-be9b-4c9b-91bf-c3cb81fc5daf"
+#define UUID_BATTERY_THERMAL_LIMIT      "4c2067e3-887d-475c-9720-4af1d3ed602e"
+#define UUID_THERMAL_EXTENSIONS         "14d399cd-7a27-4b18-8fb4-7cb7b9f4e500"
+#define UUID_DEVICE_PROPERTIES          "daffd814-6eba-4d8c-8a91-bc9bbf4aa301"
+
+#endif				/* __AUUID_H__ */
diff --git a/include/linux/libnd.h b/include/linux/libnd.h
new file mode 100644
index 000000000000..8e4441002868
--- /dev/null
+++ b/include/linux/libnd.h
@@ -0,0 +1,34 @@
+/*
+ * libnd - Non-volatile-memory Devices Subsystem
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
+#ifndef __LIBND_H__
+#define __LIBND_H__
+struct nd_dimm;
+struct nd_bus_descriptor;
+typedef int (*ndctl_fn)(struct nd_bus_descriptor *nd_desc,
+		struct nd_dimm *nd_dimm, unsigned int cmd, void *buf,
+		unsigned int buf_len);
+
+struct nd_bus_descriptor {
+	unsigned long dsm_mask;
+	char *provider_name;
+	ndctl_fn ndctl;
+};
+
+struct nd_bus;
+struct device;
+struct nd_bus *nd_bus_register(struct device *parent,
+		struct nd_bus_descriptor *nfit_desc);
+void nd_bus_unregister(struct nd_bus *nd_bus);
+#endif /* __LIBND_H__ */

