Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C57A20955F3E
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 04:14:50 -0800 (PST)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] acpi, nfit: remove redundant __func__ in dev_dbg
Date: Fri,  2 Mar 2018 13:20:49 +0100
Message-Id: <20180302122049.13900-1-jthumshirn@suse.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dynamic debug can be instructed to add the function name to the debug
output using the +f switch, so there is no need for the nfit module to
do it again. If a user decides to add the +f switch for nfit's dynamic
debug this results in double prints of the function name like the
following:

[ 2391.935383] acpi_nfit_ctl: nfit ACPI0012:00: acpi_nfit_ctl:nmem8 cmd: 10: func: 1 input length: 0

Thus remove the stray __func__ printing.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/acpi/nfit/core.c | 75 +++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bbe48ad20886..39ad06143e78 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -476,8 +476,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		in_buf.buffer.length = call_pkg->nd_size_in;
 	}
 
-	dev_dbg(dev, "%s:%s cmd: %d: func: %d input length: %d\n",
-			__func__, dimm_name, cmd, func, in_buf.buffer.length);
+	dev_dbg(dev, "%s cmd: %d: func: %d input length: %d\n",
+		dimm_name, cmd, func, in_buf.buffer.length);
 	print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
 			in_buf.buffer.pointer,
 			min_t(u32, 256, in_buf.buffer.length), true);
@@ -506,8 +506,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	}
 
 	if (!out_obj) {
-		dev_dbg(dev, "%s:%s _DSM failed cmd: %s\n", __func__, dimm_name,
-				cmd_name);
+		dev_dbg(dev, "%s _DSM failed cmd: %s\n", dimm_name, cmd_name);
 		return -EINVAL;
 	}
 
@@ -528,13 +527,13 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	}
 
 	if (out_obj->package.type != ACPI_TYPE_BUFFER) {
-		dev_dbg(dev, "%s:%s unexpected output object type cmd: %s type: %d\n",
-				__func__, dimm_name, cmd_name, out_obj->type);
+		dev_dbg(dev, "%s unexpected output object type cmd: %s type: %d\n",
+				dimm_name, cmd_name, out_obj->type);
 		rc = -EINVAL;
 		goto out;
 	}
 
-	dev_dbg(dev, "%s:%s cmd: %s output length: %d\n", __func__, dimm_name,
+	dev_dbg(dev, "%s cmd: %s output length: %d\n", dimm_name,
 			cmd_name, out_obj->buffer.length);
 	print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
 			out_obj->buffer.pointer,
@@ -546,14 +545,14 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 				out_obj->buffer.length - offset);
 
 		if (offset + out_size > out_obj->buffer.length) {
-			dev_dbg(dev, "%s:%s output object underflow cmd: %s field: %d\n",
-					__func__, dimm_name, cmd_name, i);
+			dev_dbg(dev, "%s output object underflow cmd: %s field: %d\n",
+					dimm_name, cmd_name, i);
 			break;
 		}
 
 		if (in_buf.buffer.length + offset + out_size > buf_len) {
-			dev_dbg(dev, "%s:%s output overrun cmd: %s field: %d\n",
-					__func__, dimm_name, cmd_name, i);
+			dev_dbg(dev, "%s output overrun cmd: %s field: %d\n",
+					dimm_name, cmd_name, i);
 			rc = -ENXIO;
 			goto out;
 		}
@@ -655,7 +654,7 @@ static bool add_spa(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_spa->list);
 	memcpy(nfit_spa->spa, spa, sizeof(*spa));
 	list_add_tail(&nfit_spa->list, &acpi_desc->spas);
-	dev_dbg(dev, "%s: spa index: %d type: %s\n", __func__,
+	dev_dbg(dev, "spa index: %d type: %s\n",
 			spa->range_index,
 			spa_type_name(nfit_spa_type(spa)));
 	return true;
@@ -684,8 +683,8 @@ static bool add_memdev(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_memdev->list);
 	memcpy(nfit_memdev->memdev, memdev, sizeof(*memdev));
 	list_add_tail(&nfit_memdev->list, &acpi_desc->memdevs);
-	dev_dbg(dev, "%s: memdev handle: %#x spa: %d dcr: %d flags: %#x\n",
-			__func__, memdev->device_handle, memdev->range_index,
+	dev_dbg(dev, "memdev handle: %#x spa: %d dcr: %d flags: %#x\n",
+			memdev->device_handle, memdev->range_index,
 			memdev->region_index, memdev->flags);
 	return true;
 }
@@ -727,7 +726,7 @@ static bool add_dcr(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_dcr->list);
 	memcpy(nfit_dcr->dcr, dcr, sizeof_dcr(dcr));
 	list_add_tail(&nfit_dcr->list, &acpi_desc->dcrs);
-	dev_dbg(dev, "%s: dcr index: %d windows: %d\n", __func__,
+	dev_dbg(dev, "dcr index: %d windows: %d\n",
 			dcr->region_index, dcr->windows);
 	return true;
 }
@@ -754,7 +753,7 @@ static bool add_bdw(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_bdw->list);
 	memcpy(nfit_bdw->bdw, bdw, sizeof(*bdw));
 	list_add_tail(&nfit_bdw->list, &acpi_desc->bdws);
-	dev_dbg(dev, "%s: bdw dcr: %d windows: %d\n", __func__,
+	dev_dbg(dev, "bdw dcr: %d windows: %d\n",
 			bdw->region_index, bdw->windows);
 	return true;
 }
@@ -793,7 +792,7 @@ static bool add_idt(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_idt->list);
 	memcpy(nfit_idt->idt, idt, sizeof_idt(idt));
 	list_add_tail(&nfit_idt->list, &acpi_desc->idts);
-	dev_dbg(dev, "%s: idt index: %d num_lines: %d\n", __func__,
+	dev_dbg(dev, "idt index: %d num_lines: %d\n",
 			idt->interleave_index, idt->line_count);
 	return true;
 }
@@ -833,7 +832,7 @@ static bool add_flush(struct acpi_nfit_desc *acpi_desc,
 	INIT_LIST_HEAD(&nfit_flush->list);
 	memcpy(nfit_flush->flush, flush, sizeof_flush(flush));
 	list_add_tail(&nfit_flush->list, &acpi_desc->flushes);
-	dev_dbg(dev, "%s: nfit_flush handle: %d hint_count: %d\n", __func__,
+	dev_dbg(dev, "nfit_flush handle: %d hint_count: %d\n",
 			flush->device_handle, flush->hint_count);
 	return true;
 }
@@ -846,7 +845,7 @@ static bool add_platform_cap(struct acpi_nfit_desc *acpi_desc,
 
 	mask = (1 << (pcap->highest_capability + 1)) - 1;
 	acpi_desc->platform_cap = pcap->capabilities & mask;
-	dev_dbg(dev, "%s: cap: %#x\n", __func__, acpi_desc->platform_cap);
+	dev_dbg(dev, "cap: %#x\n", acpi_desc->platform_cap);
 	return true;
 }
 
@@ -893,7 +892,7 @@ static void *add_table(struct acpi_nfit_desc *acpi_desc,
 			return err;
 		break;
 	case ACPI_NFIT_TYPE_SMBIOS:
-		dev_dbg(dev, "%s: smbios\n", __func__);
+		dev_dbg(dev, "smbios\n");
 		break;
 	case ACPI_NFIT_TYPE_CAPABILITIES:
 		if (!add_platform_cap(acpi_desc, table))
@@ -1621,7 +1620,7 @@ void __acpi_nvdimm_notify(struct device *dev, u32 event)
 	struct nfit_mem *nfit_mem;
 	struct acpi_nfit_desc *acpi_desc;
 
-	dev_dbg(dev->parent, "%s: %s: event: %d\n", dev_name(dev), __func__,
+	dev_dbg(dev->parent, "%s: event: %d\n", dev_name(dev),
 			event);
 
 	if (event != NFIT_NOTIFY_DIMM_HEALTH) {
@@ -2338,7 +2337,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	nvdimm = nd_blk_region_to_dimm(ndbr);
 	nfit_mem = nvdimm_provider_data(nvdimm);
 	if (!nfit_mem || !nfit_mem->dcr || !nfit_mem->bdw) {
-		dev_dbg(dev, "%s: missing%s%s%s\n", __func__,
+		dev_dbg(dev, "missing%s%s%s\n",
 				nfit_mem ? "" : " nfit_mem",
 				(nfit_mem && nfit_mem->dcr) ? "" : " dcr",
 				(nfit_mem && nfit_mem->bdw) ? "" : " bdw");
@@ -2357,7 +2356,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	mmio->addr.base = devm_nvdimm_memremap(dev, nfit_mem->spa_bdw->address,
                         nfit_mem->spa_bdw->length, nd_blk_memremap_flags(ndbr));
 	if (!mmio->addr.base) {
-		dev_dbg(dev, "%s: %s failed to map bdw\n", __func__,
+		dev_dbg(dev, "%s failed to map bdw\n",
 				nvdimm_name(nvdimm));
 		return -ENOMEM;
 	}
@@ -2368,8 +2367,8 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_bdw,
 			nfit_mem->memdev_bdw->interleave_ways);
 	if (rc) {
-		dev_dbg(dev, "%s: %s failed to init bdw interleave\n",
-				__func__, nvdimm_name(nvdimm));
+		dev_dbg(dev, "%s failed to init bdw interleave\n",
+				nvdimm_name(nvdimm));
 		return rc;
 	}
 
@@ -2380,7 +2379,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	mmio->addr.base = devm_nvdimm_ioremap(dev, nfit_mem->spa_dcr->address,
 			nfit_mem->spa_dcr->length);
 	if (!mmio->addr.base) {
-		dev_dbg(dev, "%s: %s failed to map dcr\n", __func__,
+		dev_dbg(dev, "%s failed to map dcr\n",
 				nvdimm_name(nvdimm));
 		return -ENOMEM;
 	}
@@ -2391,15 +2390,15 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	rc = nfit_blk_init_interleave(mmio, nfit_mem->idt_dcr,
 			nfit_mem->memdev_dcr->interleave_ways);
 	if (rc) {
-		dev_dbg(dev, "%s: %s failed to init dcr interleave\n",
-				__func__, nvdimm_name(nvdimm));
+		dev_dbg(dev, "%s failed to init dcr interleave\n",
+				nvdimm_name(nvdimm));
 		return rc;
 	}
 
 	rc = acpi_nfit_blk_get_flags(nd_desc, nvdimm, nfit_blk);
 	if (rc < 0) {
-		dev_dbg(dev, "%s: %s failed get DIMM flags\n",
-				__func__, nvdimm_name(nvdimm));
+		dev_dbg(dev, "%s failed get DIMM flags\n",
+				nvdimm_name(nvdimm));
 		return rc;
 	}
 
@@ -2655,8 +2654,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		return 0;
 
 	if (spa->range_index == 0 && !nfit_spa_is_virtual(spa)) {
-		dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
-				__func__);
+		dev_dbg(acpi_desc->dev, "detected invalid spa index\n");
 		return 0;
 	}
 
@@ -3142,8 +3140,7 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
 		data = add_table(acpi_desc, &prev, data, end);
 
 	if (IS_ERR(data)) {
-		dev_dbg(dev, "%s: nfit table parsing error: %ld\n", __func__,
-				PTR_ERR(data));
+		dev_dbg(dev, "nfit table parsing error: %ld\n",	PTR_ERR(data));
 		rc = PTR_ERR(data);
 		goto out_unlock;
 	}
@@ -3259,7 +3256,7 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
 	}
 	acpi_desc->ars_start_flags = flags;
 	queue_work(nfit_wq, &acpi_desc->work);
-	dev_dbg(dev, "%s: ars_scan triggered\n", __func__);
+	dev_dbg(dev, "ars_scan triggered\n");
 	mutex_unlock(&acpi_desc->init_mutex);
 
 	return 0;
@@ -3366,8 +3363,8 @@ static int acpi_nfit_add(struct acpi_device *adev)
 			rc = acpi_nfit_init(acpi_desc, obj->buffer.pointer,
 					obj->buffer.length);
 		else
-			dev_dbg(dev, "%s invalid type %d, ignoring _FIT\n",
-				 __func__, (int) obj->type);
+			dev_dbg(dev, "invalid type %d, ignoring _FIT\n",
+				(int) obj->type);
 		kfree(buf.pointer);
 	} else
 		/* skip over the lead-in header table */
@@ -3396,7 +3393,7 @@ static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
 
 	if (!dev->driver) {
 		/* dev->driver may be null if we're being removed */
-		dev_dbg(dev, "%s: no driver found for dev\n", __func__);
+		dev_dbg(dev, "no driver found for dev\n");
 		return;
 	}
 
@@ -3442,7 +3439,7 @@ static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
 
 void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
 {
-	dev_dbg(dev, "%s: event: 0x%x\n", __func__, event);
+	dev_dbg(dev, "event: 0x%x\n", event);
 
 	switch (event) {
 	case NFIT_NOTIFY_UPDATE:
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
