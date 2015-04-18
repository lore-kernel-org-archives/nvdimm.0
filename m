Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 04/21] nd: create an 'nd_bus' from an 'nfit_desc'
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Apr 2015 21:35:35 -0400
Message-ID: <20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Basic allocation and parsing of an nfit table.  This is infrastructure
for walking the list of "System Physical Address (SPA) Range Tables",
and "Memory device to SPA" to create "region" devices representing
persistent-memory (PMEM) or a dimm block data window set (BLK).

Note, BLK windows may be interleaved.  The nd_mem object tracks all the
tables needed for carrying out BLK I/O operations.  For the interleaved
case there may be multiple nd_mem instances per dimm-control-region
(DCR).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/core.c       |  438 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/nd-private.h |   61 ++++++
 drivers/block/nd/nfit.h       |   25 ++
 3 files changed, 523 insertions(+), 1 deletion(-)
 create mode 100644 drivers/block/nd/nd-private.h

diff --git a/drivers/block/nd/core.c b/drivers/block/nd/core.c
index 8df8d315b726..d126799e7ff7 100644
--- a/drivers/block/nd/core.c
+++ b/drivers/block/nd/core.c
@@ -10,19 +10,455 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <linux/list_sort.h>
 #include <linux/export.h>
 #include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/uuid.h>
+#include <linux/io.h>
+#include "nd-private.h"
 #include "nfit.h"
 
-struct nd_bus *nfit_bus_register(struct device *parent,
+static DEFINE_IDA(nd_ida);
+
+static bool warn_checksum;
+module_param(warn_checksum, bool, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(warn_checksum, "Turn checksum errors into warnings");
+
+static void nd_bus_release(struct device *dev)
+{
+	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
+	struct nd_memdev *nd_memdev, *_memdev;
+	struct nd_spa *nd_spa, *_spa;
+	struct nd_mem *nd_mem, *_mem;
+	struct nd_dcr *nd_dcr, *_dcr;
+	struct nd_bdw *nd_bdw, *_bdw;
+
+	list_for_each_entry_safe(nd_spa, _spa, &nd_bus->spas, list) {
+		list_del_init(&nd_spa->list);
+		kfree(nd_spa);
+	}
+	list_for_each_entry_safe(nd_dcr, _dcr, &nd_bus->dcrs, list) {
+		list_del_init(&nd_dcr->list);
+		kfree(nd_dcr);
+	}
+	list_for_each_entry_safe(nd_bdw, _bdw, &nd_bus->bdws, list) {
+		list_del_init(&nd_bdw->list);
+		kfree(nd_bdw);
+	}
+	list_for_each_entry_safe(nd_memdev, _memdev, &nd_bus->memdevs, list) {
+		list_del_init(&nd_memdev->list);
+		kfree(nd_memdev);
+	}
+	list_for_each_entry_safe(nd_mem, _mem, &nd_bus->dimms, list) {
+		list_del_init(&nd_mem->list);
+		kfree(nd_mem);
+	}
+
+	ida_simple_remove(&nd_ida, nd_bus->id);
+	kfree(nd_bus);
+}
+
+struct nd_bus *to_nd_bus(struct device *dev)
+{
+	struct nd_bus *nd_bus = container_of(dev, struct nd_bus, dev);
+
+	WARN_ON(nd_bus->dev.release != nd_bus_release);
+	return nd_bus;
+}
+
+static void *nd_bus_new(struct device *parent,
 		struct nfit_bus_descriptor *nfit_desc)
 {
+	struct nd_bus *nd_bus = kzalloc(sizeof(*nd_bus), GFP_KERNEL);
+	int rc;
+
+	if (!nd_bus)
+		return NULL;
+	INIT_LIST_HEAD(&nd_bus->spas);
+	INIT_LIST_HEAD(&nd_bus->dcrs);
+	INIT_LIST_HEAD(&nd_bus->bdws);
+	INIT_LIST_HEAD(&nd_bus->memdevs);
+	INIT_LIST_HEAD(&nd_bus->dimms);
+	nd_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
+	if (nd_bus->id < 0) {
+		kfree(nd_bus);
+		return NULL;
+	}
+	nd_bus->nfit_desc = nfit_desc;
+	nd_bus->dev.parent = parent;
+	nd_bus->dev.release = nd_bus_release;
+	dev_set_name(&nd_bus->dev, "ndbus%d", nd_bus->id);
+	rc = device_register(&nd_bus->dev);
+	if (rc) {
+		dev_dbg(&nd_bus->dev, "device registration failed: %d\n", rc);
+		put_device(&nd_bus->dev);
+		return NULL;
+	}
+	return nd_bus;
+}
+
+struct nfit_table_header {
+	__le16 type;
+	__le16 length;
+};
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
+static int nfit_spa_type(struct nfit_spa __iomem *nfit_spa)
+{
+	__u8 uuid[16];
+
+	memcpy_fromio(uuid, &nfit_spa->type_uuid, sizeof(uuid));
+
+	if (memcmp(&nfit_spa_uuid_volatile, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_VOLATILE;
+
+	if (memcmp(&nfit_spa_uuid_pm, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_PM;
+
+	if (memcmp(&nfit_spa_uuid_dcr, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_DCR;
+
+	if (memcmp(&nfit_spa_uuid_bdw, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_BDW;
+
+	if (memcmp(&nfit_spa_uuid_vdisk, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_VDISK;
+
+	if (memcmp(&nfit_spa_uuid_vcd, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_VCD;
+
+	if (memcmp(&nfit_spa_uuid_pdisk, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_PDISK;
+
+	if (memcmp(&nfit_spa_uuid_pcd, uuid, sizeof(uuid)) == 0)
+		return NFIT_SPA_PCD;
+
+	return -1;
+}
+
+static void __iomem *add_table(struct nd_bus *nd_bus, void __iomem *table,
+		const void __iomem *end)
+{
+	struct nfit_table_header __iomem *hdr;
+	void *ret = NULL;
+
+	if (table >= end)
+		goto err;
+
+	ret = ERR_PTR(-ENOMEM);
+	hdr = (struct nfit_table_header __iomem *) table;
+	switch (readw(&hdr->type)) {
+	case NFIT_TABLE_SPA: {
+		struct nd_spa *nd_spa = kzalloc(sizeof(*nd_spa), GFP_KERNEL);
+		struct nfit_spa __iomem *nfit_spa = table;
+
+		if (!nd_spa)
+			goto err;
+		INIT_LIST_HEAD(&nd_spa->list);
+		nd_spa->nfit_spa = nfit_spa;
+		list_add_tail(&nd_spa->list, &nd_bus->spas);
+		dev_dbg(&nd_bus->dev, "%s: spa index: %d type: %s\n", __func__,
+				readw(&nfit_spa->spa_index),
+				spa_type_name(nfit_spa_type(nfit_spa)));
+		break;
+	}
+	case NFIT_TABLE_MEM: {
+		struct nd_memdev *nd_memdev = kzalloc(sizeof(*nd_memdev),
+						     GFP_KERNEL);
+		struct nfit_mem __iomem *nfit_mem = table;
+
+		if (!nd_memdev)
+			goto err;
+		INIT_LIST_HEAD(&nd_memdev->list);
+		nd_memdev->nfit_mem = nfit_mem;
+		list_add_tail(&nd_memdev->list, &nd_bus->memdevs);
+		dev_dbg(&nd_bus->dev, "%s: memdev handle: %#x spa: %d dcr: %d\n",
+				__func__, readl(&nfit_mem->nfit_handle),
+				readw(&nfit_mem->spa_index),
+				readw(&nfit_mem->dcr_index));
+		break;
+	}
+	case NFIT_TABLE_DCR: {
+		struct nd_dcr *nd_dcr = kzalloc(sizeof(*nd_dcr), GFP_KERNEL);
+		struct nfit_dcr __iomem *nfit_dcr = table;
+
+		if (!nd_dcr)
+			goto err;
+		INIT_LIST_HEAD(&nd_dcr->list);
+		nd_dcr->nfit_dcr = nfit_dcr;
+		list_add_tail(&nd_dcr->list, &nd_bus->dcrs);
+		dev_dbg(&nd_bus->dev, "%s: dcr index: %d num_bcw: %d\n",
+				__func__, readw(&nfit_dcr->dcr_index),
+				readw(&nfit_dcr->num_bcw));
+		break;
+	}
+	case NFIT_TABLE_BDW: {
+		struct nd_bdw *nd_bdw = kzalloc(sizeof(*nd_bdw), GFP_KERNEL);
+		struct nfit_bdw __iomem *nfit_bdw = table;
+
+		if (!nd_bdw)
+			goto err;
+		INIT_LIST_HEAD(&nd_bdw->list);
+		nd_bdw->nfit_bdw = nfit_bdw;
+		list_add_tail(&nd_bdw->list, &nd_bus->bdws);
+		dev_dbg(&nd_bus->dev, "%s: bdw dcr: %d num_bdw: %d\n", __func__,
+				readw(&nfit_bdw->dcr_index),
+				readw(&nfit_bdw->num_bdw));
+		break;
+	}
+	/* TODO */
+	case NFIT_TABLE_IDT:
+		dev_dbg(&nd_bus->dev, "%s: idt\n", __func__);
+		break;
+	case NFIT_TABLE_FLUSH:
+		dev_dbg(&nd_bus->dev, "%s: flush\n", __func__);
+		break;
+	case NFIT_TABLE_SMBIOS:
+		dev_dbg(&nd_bus->dev, "%s: smbios\n", __func__);
+		break;
+	default:
+		dev_err(&nd_bus->dev, "unknown table '%d' parsing nfit\n",
+				readw(&hdr->type));
+		ret = ERR_PTR(-EINVAL);
+		goto err;
+	}
+
+	return table + readw(&hdr->length);
+ err:
+	return (void __iomem *) ret;
+}
+
+void nd_mem_find_spa_bdw(struct nd_bus *nd_bus, struct nd_mem *nd_mem)
+{
+	u32 nfit_handle = readl(&nd_mem->nfit_mem_dcr->nfit_handle);
+	u16 dcr_index = readw(&nd_mem->nfit_dcr->dcr_index);
+	struct nd_spa *nd_spa;
+
+	list_for_each_entry(nd_spa, &nd_bus->spas, list) {
+		u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
+		int type = nfit_spa_type(nd_spa->nfit_spa);
+		struct nd_memdev *nd_memdev;
+
+		if (type != NFIT_SPA_BDW)
+			continue;
+
+		list_for_each_entry(nd_memdev, &nd_bus->memdevs, list) {
+			if (readw(&nd_memdev->nfit_mem->spa_index) != spa_index)
+				continue;
+			if (readl(&nd_memdev->nfit_mem->nfit_handle) != nfit_handle)
+				continue;
+			if (readw(&nd_memdev->nfit_mem->dcr_index) != dcr_index)
+				continue;
+
+			nd_mem->nfit_spa_bdw = nd_spa->nfit_spa;
+			return;
+		}
+	}
+
+	dev_dbg(&nd_bus->dev, "SPA-BDW not found for SPA-DCR %d\n",
+			readw(&nd_mem->nfit_spa_dcr->spa_index));
+	nd_mem->nfit_bdw = NULL;
+}
+
+static void nd_mem_add(struct nd_bus *nd_bus, struct nd_mem *nd_mem)
+{
+	u16 dcr_index = readw(&nd_mem->nfit_mem_dcr->dcr_index);
+	u16 spa_index = readw(&nd_mem->nfit_spa_dcr->spa_index);
+	struct nd_dcr *nd_dcr;
+	struct nd_bdw *nd_bdw;
+
+	list_for_each_entry(nd_dcr, &nd_bus->dcrs, list) {
+		if (readw(&nd_dcr->nfit_dcr->dcr_index) != dcr_index)
+			continue;
+		nd_mem->nfit_dcr = nd_dcr->nfit_dcr;
+		break;
+	}
+
+	if (!nd_mem->nfit_dcr) {
+		dev_dbg(&nd_bus->dev, "SPA-DCR %d missing:%s%s\n",
+				spa_index, nd_mem->nfit_mem_dcr ? "" : " MEMDEV",
+				nd_mem->nfit_dcr ? "" : " DCR");
+		kfree(nd_mem);
+		return;
+	}
+
+	/*
+	 * We've found enough to create an nd_dimm, optionally
+	 * find an associated BDW
+	 */
+	list_add(&nd_mem->list, &nd_bus->dimms);
+
+	list_for_each_entry(nd_bdw, &nd_bus->bdws, list) {
+		if (readw(&nd_bdw->nfit_bdw->dcr_index) != dcr_index)
+			continue;
+		nd_mem->nfit_bdw = nd_bdw->nfit_bdw;
+		break;
+	}
+
+	if (!nd_mem->nfit_bdw)
+		return;
+
+	nd_mem_find_spa_bdw(nd_bus, nd_mem);
+}
+
+static int nd_mem_cmp(void *priv, struct list_head *__a, struct list_head *__b)
+{
+	struct nd_mem *a = container_of(__a, typeof(*a), list);
+	struct nd_mem *b = container_of(__b, typeof(*b), list);
+	u32 handleA, handleB;
+
+	handleA = readl(&a->nfit_mem_dcr->nfit_handle);
+	handleB = readl(&b->nfit_mem_dcr->nfit_handle);
+	if (handleA < handleB)
+		return -1;
+	else if (handleA > handleB)
+		return 1;
+	return 0;
+}
+
+static int nd_mem_init(struct nd_bus *nd_bus)
+{
+	struct nd_spa *nd_spa;
+
+	/*
+	 * For each SPA-DCR address range find its corresponding
+	 * MEMDEV(s).  From each MEMDEV find the corresponding DCR.
+	 * Then, try to find a SPA-BDW and a corresponding BDW that
+	 * references the DCR.  Throw it all into an nd_mem object.
+	 * Note, that BDWs are optional.
+	 */
+	list_for_each_entry(nd_spa, &nd_bus->spas, list) {
+		u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
+		int type = nfit_spa_type(nd_spa->nfit_spa);
+		struct nd_mem *nd_mem, *found;
+		struct nd_memdev *nd_memdev;
+		u16 dcr_index;
+
+		if (type != NFIT_SPA_DCR)
+			continue;
+
+		/* multiple dimms may share a SPA_DCR when interleaved */
+		list_for_each_entry(nd_memdev, &nd_bus->memdevs, list) {
+			if (readw(&nd_memdev->nfit_mem->spa_index) != spa_index)
+				continue;
+			found = NULL;
+			dcr_index = readw(&nd_memdev->nfit_mem->dcr_index);
+			list_for_each_entry(nd_mem, &nd_bus->dimms, list)
+				if (readw(&nd_mem->nfit_mem_dcr->dcr_index)
+						== dcr_index) {
+					found = nd_mem;
+					break;
+			}
+			if (found)
+				continue;
+
+			nd_mem = kzalloc(sizeof(*nd_mem), GFP_KERNEL);
+			if (!nd_mem)
+				return -ENOMEM;
+			INIT_LIST_HEAD(&nd_mem->list);
+			nd_mem->nfit_spa_dcr = nd_spa->nfit_spa;
+			nd_mem->nfit_mem_dcr = nd_memdev->nfit_mem;
+			nd_mem_add(nd_bus, nd_mem);
+		}
+	}
+
+	list_sort(NULL, &nd_bus->dimms, nd_mem_cmp);
+
+	return 0;
+}
+
+static struct nd_bus *nd_bus_probe(struct nd_bus *nd_bus)
+{
+	struct nfit_bus_descriptor *nfit_desc = nd_bus->nfit_desc;
+	struct nfit __iomem *nfit = nfit_desc->nfit_base;
+	void __iomem *base = nfit;
+	const void __iomem *end;
+	u8 sum, signature[4];
+	u8 __iomem *data;
+	size_t size, i;
+	int rc;
+
+	size = nd_bus->nfit_desc->nfit_size;
+	if (size < sizeof(struct nfit))
+		goto err;
+
+	size = min_t(u32, size, readl(&nfit->length));
+	data = (u8 __iomem *) base;
+	for (i = 0, sum = 0; i < size; i++)
+		sum += readb(data + i);
+	if (sum != 0 && !warn_checksum) {
+		dev_dbg(&nd_bus->dev, "%s: nfit checksum failure\n", __func__);
+		goto err;
+	}
+	WARN_TAINT_ONCE(sum != 0, TAINT_FIRMWARE_WORKAROUND,
+			"nfit checksum failure, continuing...\n");
+
+	memcpy_fromio(signature, &nfit->signature, sizeof(signature));
+	if (memcmp(signature, "NFIT", 4) != 0) {
+		dev_dbg(&nd_bus->dev, "%s: nfit signature mismatch\n",
+				__func__);
+		goto err;
+	}
+
+	end = base + size;
+	base += sizeof(struct nfit);
+	base = add_table(nd_bus, base, end);
+	while (!IS_ERR_OR_NULL(base))
+		base = add_table(nd_bus, base, end);
+
+	if (IS_ERR(base)) {
+		dev_dbg(&nd_bus->dev, "%s: nfit table parsing error: %ld\n",
+				__func__, PTR_ERR(base));
+		goto err;
+	}
+
+	rc = nd_mem_init(nd_bus);
+	if (rc)
+		goto err;
+
+	return nd_bus;
+ err:
+	put_device(&nd_bus->dev);
 	return NULL;
+
+}
+
+struct nd_bus *nfit_bus_register(struct device *parent,
+		struct nfit_bus_descriptor *nfit_desc)
+{
+	static DEFINE_MUTEX(mutex);
+	struct nd_bus *nd_bus;
+
+	/* enforce single bus at a time registration */
+	mutex_lock(&mutex);
+	nd_bus = nd_bus_new(parent, nfit_desc);
+	nd_bus = nd_bus_probe(nd_bus);
+	mutex_unlock(&mutex);
+
+	if (!nd_bus)
+		return NULL;
+
+	return nd_bus;
 }
 EXPORT_SYMBOL(nfit_bus_register);
 
 void nfit_bus_unregister(struct nd_bus *nd_bus)
 {
+	if (!nd_bus)
+		return;
+	device_unregister(&nd_bus->dev);
 }
 EXPORT_SYMBOL(nfit_bus_unregister);
 
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
new file mode 100644
index 000000000000..0ede8818f320
--- /dev/null
+++ b/drivers/block/nd/nd-private.h
@@ -0,0 +1,61 @@
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
+extern struct list_head nd_bus_list;
+extern struct mutex nd_bus_list_mutex;
+
+struct nd_bus {
+	struct nfit_bus_descriptor *nfit_desc;
+	struct list_head memdevs;
+	struct list_head dimms;
+	struct list_head spas;
+	struct list_head dcrs;
+	struct list_head bdws;
+	struct list_head list;
+	struct device dev;
+	int id;
+};
+
+struct nd_spa {
+	struct nfit_spa __iomem *nfit_spa;
+	struct list_head list;
+};
+
+struct nd_dcr {
+	struct nfit_dcr __iomem *nfit_dcr;
+	struct list_head list;
+};
+
+struct nd_bdw {
+	struct nfit_bdw __iomem *nfit_bdw;
+	struct list_head list;
+};
+
+struct nd_memdev {
+	struct nfit_mem __iomem *nfit_mem;
+	struct list_head list;
+};
+
+/* assembled tables for a given dimm */
+struct nd_mem {
+	struct nfit_mem __iomem *nfit_mem_dcr;
+	struct nfit_dcr __iomem *nfit_dcr;
+	struct nfit_bdw __iomem *nfit_bdw;
+	struct nfit_spa __iomem *nfit_spa_dcr;
+	struct nfit_spa __iomem *nfit_spa_bdw;
+	struct list_head list;
+};
+struct nd_bus *to_nd_bus(struct device *dev);
+#endif /* __ND_PRIVATE_H__ */
diff --git a/drivers/block/nd/nfit.h b/drivers/block/nd/nfit.h
index 56a3b2dad124..72c317d04cb2 100644
--- a/drivers/block/nd/nfit.h
+++ b/drivers/block/nd/nfit.h
@@ -16,6 +16,31 @@
 #define __NFIT_H__
 
 #include <linux/types.h>
+#include <linux/uuid.h>
+
+static const uuid_le nfit_spa_uuid_volatile __maybe_unused = UUID_LE(0x7305944f,
+		0xfdda, 0x44e3, 0xb1, 0x6c, 0x3f, 0x22, 0xd2, 0x52, 0xe5, 0xd0);
+
+static const uuid_le nfit_spa_uuid_pm __maybe_unused = UUID_LE(0x66f0d379,
+		0xb4f3, 0x4074, 0xac, 0x43, 0x0d, 0x33, 0x18, 0xb7, 0x8c, 0xdb);
+
+static const uuid_le nfit_spa_uuid_dcr __maybe_unused = UUID_LE(0x92f701f6,
+		0x13b4, 0x405d, 0x91, 0x0b, 0x29, 0x93, 0x67, 0xe8, 0x23, 0x4c);
+
+static const uuid_le nfit_spa_uuid_bdw __maybe_unused = UUID_LE(0x91af0530,
+		0x5d86, 0x470e, 0xa6, 0xb0, 0x0a, 0x2d, 0xb9, 0x40, 0x82, 0x49);
+
+static const uuid_le nfit_spa_uuid_vdisk __maybe_unused = UUID_LE(0x77ab535a,
+		0x45fc, 0x624b, 0x55, 0x60, 0xf7, 0xb2, 0x81, 0xd1, 0xf9, 0x6e);
+
+static const uuid_le nfit_spa_uuid_vcd __maybe_unused = UUID_LE(0x3d5abd30,
+		0x4175, 0x87ce, 0x6d, 0x64, 0xd2, 0xad, 0xe5, 0x23, 0xc4, 0xbb);
+
+static const uuid_le nfit_spa_uuid_pdisk __maybe_unused = UUID_LE(0x5cea02c9,
+		0x4d07, 0x69d3, 0x26, 0x9f, 0x44, 0x96, 0xfb, 0xe0, 0x96, 0xf9);
+
+static const uuid_le nfit_spa_uuid_pcd __maybe_unused = UUID_LE(0x08018188,
+		0x42cd, 0xbb48, 0x10, 0x0f, 0x53, 0x87, 0xd5, 0x3d, 0xed, 0x3d);
 
 enum {
 	NFIT_TABLE_SPA = 0,

