Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: vishal@kernel.org
Subject: [PATCH 2/3] libnvdimm: Add a poison list
Date: Sun, 20 Dec 2015 02:18:41 -0700
Message-Id: <1450603122-7205-3-git-send-email-vishal@kernel.org>
In-Reply-To: <1450603122-7205-1-git-send-email-vishal@kernel.org>
References: <1450603122-7205-1-git-send-email-vishal@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Moyer <jmoyer@redhat.com>, Linda Knippers <linda.knippers@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Vishal Verma <vishal.l.verma@intel.com>

During region creation, perform Address Range Scrubs (ARS) for the SPA
(System Physical Address) ranges to retrieve known poison locations from
firmware. Add a new data structure 'nd_poison' which is used as a list
in nvdimm_bus to store these poison locations for subsequent consumption
by the pmem driver.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/acpi/nfit.c       | 193 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/core.c     |  63 +++++++++++++++
 drivers/nvdimm/nd-core.h  |   1 +
 drivers/nvdimm/nd.h       |   6 ++
 include/linux/libnvdimm.h |   2 +
 5 files changed, 265 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index e7ed39b..bd8726d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
+#include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/acpi.h>
 #include <linux/sort.h>
@@ -1473,6 +1474,195 @@ static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
 	/* devm will free nfit_blk */
 }
 
+static int ars_get_cap(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_cap *cmd, u64 addr, u64 length)
+{
+	cmd->address = addr;
+	cmd->length = length;
+
+	return nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, cmd,
+			sizeof(*cmd));
+}
+
+static int ars_do_start(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_start *cmd, u64 addr, u64 length)
+{
+	int rc;
+
+	cmd->address = addr;
+	cmd->length = length;
+	cmd->type = ND_ARS_PERSISTENT;
+
+	while (1) {
+		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_START, cmd,
+				sizeof(*cmd));
+		if (rc)
+			return rc;
+		switch (cmd->status) {
+		case 0:
+			return 0;
+		case 1:
+			/* ARS unsupported, but we should never get here */
+			return 0;
+		case 2:
+			return -EINVAL;
+		case 3:
+			/* ARS is in progress */
+			msleep(1000);
+			break;
+		default:
+			return -ENXIO;
+		}
+	}
+}
+
+static int ars_get_status(struct nvdimm_bus_descriptor *nd_desc,
+		struct nd_cmd_ars_status *cmd)
+{
+	int rc;
+
+	while (1) {
+		rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_STATUS, cmd,
+			sizeof(*cmd));
+		if (rc || cmd->status & 0xffff)
+			return -ENXIO;
+
+		/* Check extended status (Upper two bytes) */
+		switch (cmd->status & 0xffff0000) {
+		case 0:
+			return 0;
+		case 1:
+			/* ARS is in progress */
+			msleep(1000);
+			break;
+		case 2:
+			/* No ARS performed for the current boot */
+		default:
+			return -ENXIO;
+		}
+	}
+}
+
+static int ars_status_process_records(struct nvdimm_bus *nvdimm_bus,
+		struct nd_cmd_ars_status *ars_status, u64 start)
+{
+	int rc;
+	u32 i;
+
+	/*
+	 * The address field returned by ars_status should be either
+	 * less than or equal to the address we last started ARS for.
+	 * The (start, length) returned by ars_status should also have
+	 * non-zero overlap with the range we started ARS for.
+	 * If this is not the case, bail.
+	 */
+	if (ars_status->address > start ||
+			(ars_status->address + ars_status->length < start))
+		return -ENXIO;
+
+	for (i = 0; i < ars_status->num_records; i++) {
+		rc = nvdimm_bus_add_poison(nvdimm_bus,
+				ars_status->records[i].err_address,
+				ars_status->records[i].length);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
+		struct nd_region_desc *ndr_desc)
+{
+	struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
+	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
+	struct nd_cmd_ars_status *ars_status = NULL;
+	struct nd_cmd_ars_start *ars_start = NULL;
+	struct nd_cmd_ars_cap *ars_cap = NULL;
+	u64 start, len, cur, remaining;
+	int rc;
+
+	ars_cap = kzalloc(sizeof(*ars_cap), GFP_KERNEL);
+	if (!ars_cap)
+		return -ENOMEM;
+
+	start = ndr_desc->res->start;
+	len = ndr_desc->res->end - ndr_desc->res->start + 1;
+
+	rc = ars_get_cap(nd_desc, ars_cap, start, len);
+	if (rc)
+		goto out;
+
+	/* If ARS is unsupported, skip this but continue initialization */
+	if (ars_cap->status & 0xffff) {
+		dev_warn(acpi_desc->dev,
+			"ARS unsupported, won't construct an error list\n");
+		goto out;
+	}
+
+	/*
+	 * Check if a full-range ARS has been run. If so, use those results
+	 * without having to start a new ARS.
+	 */
+	ars_status = kzalloc(ars_cap->max_ars_out + sizeof(*ars_status),
+			GFP_KERNEL);
+	if (!ars_status) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = ars_get_status(nd_desc, ars_status);
+	if (rc)
+		goto out;
+
+	if (ars_status->address <= start &&
+		(ars_status->address + ars_status->length >= start + len)) {
+		rc = ars_status_process_records(nvdimm_bus, ars_status, start);
+		goto out;
+	}
+
+	/*
+	 * ARS_STATUS can overflow if the number of poison entries found is
+	 * greater than the maximum buffer size (ars_cap->max_ars_out)
+	 * To detect overflow, check if the length field of ars_status
+	 * is less than the length we supplied. If so, process the
+	 * error entries we got, adjust the start point, and start again
+	 */
+	ars_start = kzalloc(sizeof(*ars_start), GFP_KERNEL);
+	if (!ars_start)
+		return -ENOMEM;
+
+	cur = start;
+	remaining = len;
+	do {
+		u64 done, end;
+
+		rc = ars_do_start(nd_desc, ars_start, cur, remaining);
+		if (rc)
+			goto out;
+
+		rc = ars_get_status(nd_desc, ars_status);
+		if (rc)
+			goto out;
+
+		rc = ars_status_process_records(nvdimm_bus, ars_status, cur);
+		if (rc)
+			goto out;
+
+		end = min(cur + remaining,
+			ars_status->address + ars_status->length);
+		done = end - cur;
+		cur += done;
+		remaining -= done;
+	} while (remaining);
+
+ out:
+	kfree(ars_cap);
+	kfree(ars_start);
+	kfree(ars_status);
+	return rc;
+}
+
 static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		struct nd_mapping *nd_mapping, struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_memory_map *memdev,
@@ -1585,6 +1775,9 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	nvdimm_bus = acpi_desc->nvdimm_bus;
 	if (nfit_spa_type(spa) == NFIT_SPA_PM) {
+		rc = acpi_nfit_find_poison(acpi_desc, ndr_desc);
+		if (rc)
+			return rc;
 		if (!nvdimm_pmem_region_create(nvdimm_bus, ndr_desc))
 			return -ENOMEM;
 	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 82c49bb..8c882c8 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -325,6 +325,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	if (!nvdimm_bus)
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
+	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
 	mutex_init(&nvdimm_bus->reconfig_mutex);
@@ -359,6 +360,67 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 }
 EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
 
+struct list_head *nvdimm_bus_get_poison_list(struct nvdimm_bus *nvdimm_bus)
+{
+	return &nvdimm_bus->poison_list;
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_get_poison_list);
+
+static int __add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+{
+	struct nd_poison *pl;
+
+	pl = kzalloc(sizeof(*pl), GFP_KERNEL);
+	if (!pl)
+		return -ENOMEM;
+
+	pl->start = addr;
+	pl->length = length;
+	list_add_tail(&pl->list, &nvdimm_bus->poison_list);
+
+	return 0;
+}
+
+int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
+{
+	struct nd_poison *pl;
+
+	if (list_empty(&nvdimm_bus->poison_list))
+		return __add_poison(nvdimm_bus, addr, length);
+
+	/*
+	 * There is a chance this is a duplicate, check for those first.
+	 * This will be the common case as ARS_STATUS returns all known
+	 * errors in the SPA space, and we can't query it per region
+	 */
+	list_for_each_entry(pl, &nvdimm_bus->poison_list, list)
+		if (pl->start == addr) {
+			/* If length has changed, update this list entry */
+			if (pl->length != length)
+				pl->length = length;
+			return 0;
+		}
+
+	/*
+	 * If not a duplicate or a simple length update, add the entry as is,
+	 * as any overlapping ranges will get resolved when the list is consumed
+	 * and converted to badblocks
+	 */
+	return __add_poison(nvdimm_bus, addr, length);
+}
+EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
+
+static void free_poison_list(struct list_head *poison_list)
+{
+	struct nd_poison *pl, *next;
+
+	list_for_each_entry_safe(pl, next, poison_list, list) {
+		list_del(&pl->list);
+		kfree(pl);
+	}
+	list_del_init(poison_list);
+}
+
 static int child_unregister(struct device *dev, void *data)
 {
 	/*
@@ -385,6 +447,7 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus)
 
 	nd_synchronize();
 	device_for_each_child(&nvdimm_bus->dev, NULL, child_unregister);
+	free_poison_list(&nvdimm_bus->poison_list);
 	nvdimm_bus_destroy_ndctl(nvdimm_bus);
 
 	device_unregister(&nvdimm_bus->dev);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 159aed5..29acdaa 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -30,6 +30,7 @@ struct nvdimm_bus {
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
+	struct list_head poison_list;
 	struct mutex reconfig_mutex;
 };
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 417e521..ba91fcd 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -38,6 +38,12 @@ enum {
 #endif
 };
 
+struct nd_poison {
+	u64 start;
+	u64 length;
+	struct list_head list;
+};
+
 struct nvdimm_drvdata {
 	struct device *dev;
 	int nsindex_size;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3f021dc..43b82a0 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -116,6 +116,8 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 
 }
 
+struct list_head *nvdimm_bus_get_poison_list(struct nvdimm_bus *nvdimm_bus);
+int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
 struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc, struct module *module);
 #define nvdimm_bus_register(parent, desc) \
-- 
2.5.0

