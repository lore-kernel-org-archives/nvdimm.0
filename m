Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DD64821EB88D4
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 06:18:40 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 828A6AC00D7
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 22:21:20 +0900 (JST)
Date: Fri, 01 Sep 2017 22:21:10 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 4/5] ndctl: Make new interfaces to get information by
 Physical Address
In-Reply-To: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
References: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170901222106.C28B.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


This patch makes new interfaces :
  - Confirm NFIT command is supported or not. (nfit.c)
  - Call translate SPA featture of ACPI 6.2. (nfit.c)
  - Find region by System Physical Address (libndctl.c)
  - Find DIMM by System Physical Address. (libndctl.c)

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
---
 ndctl/lib/Makefile.am  |   2 +
 ndctl/lib/libndctl.c   |  69 +++++++++++++++++++++++
 ndctl/lib/libndctl.sym |   2 +
 ndctl/lib/nfit.c       | 147 +++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/libndctl-nfit.h  |   4 ++
 ndctl/libndctl.h.in    |   4 ++
 6 files changed, 228 insertions(+)

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index d8df87d..9a7734d 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -36,6 +36,8 @@ libndctl_la_SOURCES += hpe1.c
 libndctl_la_SOURCES += msft.c
 endif
 
+libndctl_la_SOURCES += nfit.c
+
 EXTRA_DIST += libndctl.sym
 
 libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 740b6f1..6cc8e1c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -38,6 +38,7 @@
 #include <ndctl/libndctl.h>
 #include <ndctl/namespace.h>
 #include <daxctl/libdaxctl.h>
+#include <ndctl/libndctl-nfit.h>
 #include "private.h"
 
 static uuid_t null_uuid;
@@ -1570,6 +1571,74 @@ static struct ndctl_dimm *ndctl_dimm_get_by_id(struct ndctl_bus *bus, unsigned i
 	return NULL;
 }
 
+/**
+ * ndctl_region_get_by_physical_address - get region by physical address
+ * @bus: ndctl_bus instance
+ * @address: (System) Physical Address
+ *
+ * If @bus and @address is valid, returns a region address, which
+ * physical address belongs to.
+ */
+NDCTL_EXPORT struct ndctl_region *ndctl_region_get_by_physical_address(struct ndctl_bus *bus,
+		unsigned long long address)
+{
+	unsigned long long region_start, region_end;
+	struct ndctl_region *region;
+
+	ndctl_region_foreach(bus, region) {
+		region_start = ndctl_region_get_resource(region);
+		region_end = region_start + ndctl_region_get_size(region);
+		if (region_start <= address && address < region_end)
+			return region;
+	}
+
+	return NULL;
+}
+
+/**
+ * ndctl_dimm_get_by_physical_address - get ndctl_dimm pointer by physical address
+ * @bus: ndctl_bus instance
+ * @address: (System) Physical Address
+ *
+ * Returns address of ndctl_dimm on success.
+ */
+NDCTL_EXPORT struct ndctl_dimm *ndctl_dimm_get_by_physical_address(struct ndctl_bus *bus,
+	        unsigned long long address)
+{
+	int rc;
+        unsigned int handle;
+	unsigned long long dpa;
+	struct ndctl_region *region;
+
+	if (!bus)
+		return NULL;
+
+	region = ndctl_region_get_by_physical_address(bus, address);
+	if (!region)
+		return NULL;
+
+	if (ndctl_region_get_interleave_ways(region) == 1) {
+		/*
+		 * No need to ask firmware. The first dimm is iff.
+		 */
+		struct ndctl_mapping *mapping = ndctl_mapping_get_first(region);
+		if (!mapping)
+			return NULL;
+		return ndctl_mapping_get_dimm(mapping);
+	}
+
+	/*
+	 * Since the region is interleaved, we need to ask firmware about it.
+	 * If it supports Translate SPA, the dimm is returned.
+	 */
+        rc = ndctl_bus_cmd_translate_spa(bus, address, &handle, &dpa);
+        if (rc)
+                return NULL;
+
+        return ndctl_dimm_get_by_handle(bus, handle);
+}
+
+
 static int region_set_type(struct ndctl_region *region, char *path)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 3f9bf09..888108d 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -77,6 +77,7 @@ global:
 	ndctl_dimm_get_bus;
 	ndctl_dimm_get_ctx;
 	ndctl_dimm_get_by_handle;
+	ndctl_dimm_get_by_physical_address;
 	ndctl_dimm_is_active;
 	ndctl_dimm_is_enabled;
 	ndctl_dimm_disable;
@@ -136,6 +137,7 @@ global:
 	ndctl_region_get_ctx;
 	ndctl_region_get_first_dimm;
 	ndctl_region_get_next_dimm;
+	ndctl_region_get_by_physical_address;
 	ndctl_region_is_enabled;
 	ndctl_region_enable;
 	ndctl_region_disable_invalidate;
diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
new file mode 100644
index 0000000..79d966d
--- /dev/null
+++ b/ndctl/lib/nfit.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdlib.h>
+#include <ndctl/libndctl.h>
+#include "private.h"
+#include <ndctl/libndctl-nfit.h>
+
+struct ndctl_bus;
+
+/**
+ * ndctl_bus_is_nfit_cmd_supported - ask nfit command is supported on @bus.
+ * @bus: ndctl_bus instance
+ * @cmd: nfit command number (defined as NFIT_CMD_XXX in libndctl-nfit.h)
+ *
+ * Return 1: command is supported. Return 0: command is not supported.
+ *
+ */
+NDCTL_EXPORT int ndctl_bus_is_nfit_cmd_supported(struct ndctl_bus *bus,
+                int cmd)
+{
+        return !!(ndctl_bus_get_nfit_dsm_mask(bus) & (1ULL << cmd));
+}
+
+static int bus_has_translate_spa(struct ndctl_bus *bus)
+{
+	if (!ndctl_bus_has_nfit(bus))
+		return 0;
+
+	return ndctl_bus_is_nfit_cmd_supported(bus, NFIT_CMD_TRANSLATE_SPA);
+}
+
+static struct ndctl_cmd *ndctl_bus_cmd_new_translate_spa(struct ndctl_bus *bus)
+{
+	struct ndctl_cmd *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_translate_spa *translate_spa;
+	size_t size, spa_length;
+
+	spa_length = sizeof(struct nd_cmd_translate_spa)
+		+ sizeof(struct nd_nvdimm_device);
+	size = sizeof(*cmd) + sizeof(*pkg) + spa_length;
+	cmd = calloc(1, size);
+	if (!cmd)
+		return NULL;
+
+	cmd->bus = bus;
+	ndctl_cmd_ref(cmd);
+	cmd->type = ND_CMD_CALL;
+	cmd->size = size;
+	cmd->status = 1;
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	pkg->nd_command = NFIT_CMD_TRANSLATE_SPA;
+	pkg->nd_size_in = sizeof(unsigned long long);
+	pkg->nd_size_out = spa_length;
+	pkg->nd_fw_size = spa_length;
+	translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
+	cmd->firmware_status = &translate_spa->status;
+	translate_spa->translate_length = spa_length;
+
+	return cmd;
+}
+
+static int ndctl_bus_cmd_get_translate_spa(struct ndctl_cmd *cmd,
+					unsigned int *handle, unsigned long long *dpa)
+{
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_translate_spa *translate_spa;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
+
+	if (translate_spa->status == ND_TRANSLATE_SPA_STATUS_INVALID_SPA)
+		return -EINVAL;
+
+	/*
+	 * XXX: Currently NVDIMM mirroring is not supported.
+	 * Even if ACPI returned plural dimms due to mirroring,
+	 * this function returns just the first dimm.
+	 */
+
+	*handle = translate_spa->devices[0].nfit_device_handle;
+	*dpa = translate_spa->devices[0].dpa;
+
+	return 0;
+}
+
+static int is_valid_spa(struct ndctl_bus *bus, unsigned long long spa)
+{
+	return !!ndctl_region_get_by_physical_address(bus, spa);
+}
+
+/**
+ * ndctl_bus_cmd_translate_spa - call translate spa.
+ * @bus: bus which belongs to.
+ * @address: address (System Physical Address)
+ * @handle: pointer to return dimm handle
+ * @dpa: pointer to return Dimm Physical address
+ *
+ * If success, returns zero, store dimm's @handle, and @dpa.
+ */
+NDCTL_EXPORT int ndctl_bus_cmd_translate_spa(struct ndctl_bus *bus,
+	unsigned long long address, unsigned int *handle, unsigned long long *dpa)
+{
+
+	struct ndctl_cmd *cmd;
+	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_translate_spa *translate_spa;
+	int rc;
+
+	if (!bus || !handle || !dpa)
+		return -EINVAL;
+
+	if (!bus_has_translate_spa(bus))
+		return -ENOTTY;
+
+	if (!is_valid_spa(bus, address))
+		return -EINVAL;
+
+	cmd = ndctl_bus_cmd_new_translate_spa(bus);
+	if (!cmd)
+		return -ENOMEM;
+
+	pkg = (struct nd_cmd_pkg *)&cmd->cmd_buf[0];
+	translate_spa = (struct nd_cmd_translate_spa *)&pkg->nd_payload[0];
+	translate_spa->spa = address;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc) {
+		ndctl_cmd_unref(cmd);
+		return rc;
+	}
+
+	rc = ndctl_bus_cmd_get_translate_spa(cmd, handle, dpa);
+	ndctl_cmd_unref(cmd);
+
+	return rc;
+}
diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
index 1258d2e..fbeebb0 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -73,4 +73,8 @@ struct nd_cmd_ars_err_inj_stat {
 	} record[0];
 }; /* naturally packed */
 
+int ndctl_bus_is_nfit_cmd_supported(struct ndctl_bus *bus, int cmd);
+int ndctl_bus_cmd_translate_spa(struct ndctl_bus *bus,
+	unsigned long long addr, unsigned int *handle, unsigned long long *dpa);
+
 #endif /* __LIBNDCTL_NFIT_H__ */
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index bfee693..bbfb14c 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -162,6 +162,8 @@ struct ndctl_smart_ops *ndctl_dimm_get_smart_ops(struct ndctl_dimm *dimm);
 struct ndctl_ctx *ndctl_dimm_get_ctx(struct ndctl_dimm *dimm);
 struct ndctl_dimm *ndctl_dimm_get_by_handle(struct ndctl_bus *bus,
 		unsigned int handle);
+struct ndctl_dimm *ndctl_dimm_get_by_physical_address(struct ndctl_bus *bus,
+		unsigned long long address);
 int ndctl_dimm_is_active(struct ndctl_dimm *dimm);
 int ndctl_dimm_is_enabled(struct ndctl_dimm *dimm);
 int ndctl_dimm_disable(struct ndctl_dimm *dimm);
@@ -422,6 +424,8 @@ struct ndctl_ctx *ndctl_region_get_ctx(struct ndctl_region *region);
 struct ndctl_dimm *ndctl_region_get_first_dimm(struct ndctl_region *region);
 struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *region,
 		struct ndctl_dimm *dimm);
+struct ndctl_region *ndctl_region_get_by_physical_address(struct ndctl_bus *bus,
+		unsigned long long address);
 #define ndctl_dimm_foreach_in_region(region, dimm) \
         for (dimm = ndctl_region_get_first_dimm(region); \
              dimm != NULL; \



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
