Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 783EC21E70D5D
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:30 -0700 (PDT)
Subject: [ndctl PATCH 3/7] ndctl: move label manipulation routines to their
 own file
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:01:46 -0700
Message-ID: <150403690602.8240.1908493698203467246.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In anticipation of pushing label functionality into the library move the
existing ndctl_dimm_zero_labels() into a new ndctl/lib/dimm.c source
file.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/Makefile.am |    1 
 ndctl/lib/dimm.c      |  106 ++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c  |  145 -------------------------------------------------
 ndctl/lib/private.h   |   57 +++++++++++++++++++
 4 files changed, 164 insertions(+), 145 deletions(-)
 create mode 100644 ndctl/lib/dimm.c

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 0f01b7d88007..d8df87d13df3 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -17,6 +17,7 @@ libndctl_la_SOURCES =\
 	../../util/log.h \
 	../../util/sysfs.c \
 	../../util/sysfs.h \
+	dimm.c \
 	libndctl.c
 
 libndctl_la_LIBADD =\
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
new file mode 100644
index 000000000000..1c613a470099
--- /dev/null
+++ b/ndctl/lib/dimm.c
@@ -0,0 +1,106 @@
+/*
+ * Copyright (c) 2014-2017, Intel Corporation.
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
+#include <ndctl/libndctl.h>
+#include <util/sysfs.h>
+#include <stdlib.h>
+#include "private.h"
+
+NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
+{
+	struct ndctl_cmd *cmd_size, *cmd_read, *cmd_write;
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	int rc;
+
+	rc = ndctl_bus_wait_probe(bus);
+	if (rc < 0)
+		return rc;
+
+	if (ndctl_dimm_is_active(dimm)) {
+		dbg(ctx, "%s: regions active, abort label write\n",
+			ndctl_dimm_get_devname(dimm));
+		return -EBUSY;
+	}
+
+	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
+	if (!cmd_size)
+		return -ENOTTY;
+	rc = ndctl_cmd_submit(cmd_size);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
+		goto out_size;
+
+	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
+	if (!cmd_read) {
+		rc = -ENOTTY;
+		goto out_size;
+	}
+	rc = ndctl_cmd_submit(cmd_read);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+		goto out_read;
+
+	cmd_write = ndctl_dimm_cmd_new_cfg_write(cmd_read);
+	if (!cmd_write) {
+		rc = -ENOTTY;
+		goto out_read;
+	}
+	if (ndctl_cmd_cfg_write_zero_data(cmd_write) < 0) {
+		rc = -ENXIO;
+		goto out_write;
+	}
+	rc = ndctl_cmd_submit(cmd_write);
+	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
+		goto out_write;
+
+	/*
+	 * If the dimm is already disabled the kernel is not holding a cached
+	 * copy of the label space.
+	 */
+	if (!ndctl_dimm_is_enabled(dimm))
+		goto out_write;
+
+	rc = ndctl_dimm_disable(dimm);
+	if (rc)
+		goto out_write;
+	rc = ndctl_dimm_enable(dimm);
+
+ out_write:
+	ndctl_cmd_unref(cmd_write);
+ out_read:
+	ndctl_cmd_unref(cmd_read);
+ out_size:
+	ndctl_cmd_unref(cmd_size);
+
+	return rc;
+}
+
+NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
+		struct ndctl_dimm *dimm)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char *path = dimm->dimm_buf;
+	int len = dimm->buf_len;
+	char buf[20];
+
+	if (snprintf(path, len, "%s/available_slots", dimm->dimm_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_dimm_get_devname(dimm));
+		return ULONG_MAX;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return ULONG_MAX;
+
+	return strtoul(buf, NULL, 0);
+}
+
+
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4c0f8a7afd57..f93ba9b8de76 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -105,63 +105,6 @@ struct ndctl_bus {
 };
 
 /**
- * struct ndctl_dimm - memory device as identified by NFIT
- * @module: kernel module (libnvdimm)
- * @handle: NFIT-handle value
- * @major: /dev/nmemX major character device number
- * @minor: /dev/nmemX minor character device number
- * @phys_id: SMBIOS physical id
- * @vendor_id: hardware component vendor
- * @device_id: hardware device id
- * @revision_id: hardware revision id
- * @node: system node-id
- * @socket: socket-id in the node
- * @imc: memory-controller-id in the socket
- * @channel: channel-id in the memory-controller
- * @dimm: dimm-id in the channel
- * @formats: number of support interfaces
- * @format: array of format interface code numbers
- */
-struct ndctl_dimm {
-	struct kmod_module *module;
-	struct ndctl_bus *bus;
-	struct ndctl_smart_ops *smart_ops;
-	unsigned int handle, major, minor, serial;
-	unsigned short phys_id;
-	unsigned short vendor_id;
-	unsigned short device_id;
-	unsigned short revision_id;
-	unsigned short subsystem_vendor_id;
-	unsigned short subsystem_device_id;
-	unsigned short subsystem_revision_id;
-	unsigned short manufacturing_date;
-	unsigned char manufacturing_location;
-	unsigned long dsm_family;
-	unsigned long dsm_mask;
-	char *unique_id;
-	char *dimm_path;
-	char *dimm_buf;
-	int health_eventfd;
-	int buf_len;
-	int id;
-	union dimm_flags {
-		unsigned long flags;
-		struct {
-			unsigned int f_map:1;
-			unsigned int f_arm:1;
-			unsigned int f_save:1;
-			unsigned int f_flush:1;
-			unsigned int f_smart:1;
-			unsigned int f_restore:1;
-			unsigned int f_notify:1;
-		};
-	} flags;
-	struct list_node list;
-	int formats;
-	int format[0];
-};
-
-/**
  * struct ndctl_mapping - dimm extent relative to a region
  * @dimm: backing dimm for the mapping
  * @offset: dimm relative offset
@@ -2214,74 +2157,6 @@ NDCTL_EXPORT ssize_t ndctl_cmd_cfg_write_zero_data(struct ndctl_cmd *cfg_write)
 	return cfg_write->iter.total_xfer;
 }
 
-NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
-{
-	struct ndctl_cmd *cmd_size, *cmd_read, *cmd_write;
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
-	int rc;
-
-	rc = ndctl_bus_wait_probe(bus);
-	if (rc < 0)
-		return rc;
-
-	if (ndctl_dimm_is_active(dimm)) {
-		dbg(ctx, "%s: regions active, abort label write\n",
-			ndctl_dimm_get_devname(dimm));
-		return -EBUSY;
-	}
-
-	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
-	if (!cmd_size)
-		return -ENOTTY;
-	rc = ndctl_cmd_submit(cmd_size);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
-		goto out_size;
-
-	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
-	if (!cmd_read) {
-		rc = -ENOTTY;
-		goto out_size;
-	}
-	rc = ndctl_cmd_submit(cmd_read);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
-		goto out_read;
-
-	cmd_write = ndctl_dimm_cmd_new_cfg_write(cmd_read);
-	if (!cmd_write) {
-		rc = -ENOTTY;
-		goto out_read;
-	}
-	if (ndctl_cmd_cfg_write_zero_data(cmd_write) < 0) {
-		rc = -ENXIO;
-		goto out_write;
-	}
-	rc = ndctl_cmd_submit(cmd_write);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
-		goto out_write;
-
-	/*
-	 * If the dimm is already disabled the kernel is not holding a cached
-	 * copy of the label space.
-	 */
-	if (!ndctl_dimm_is_enabled(dimm))
-		goto out_write;
-
-	rc = ndctl_dimm_disable(dimm);
-	if (rc)
-		goto out_write;
-	rc = ndctl_dimm_enable(dimm);
-
- out_write:
-	ndctl_cmd_unref(cmd_write);
- out_read:
-	ndctl_cmd_unref(cmd_read);
- out_size:
-	ndctl_cmd_unref(cmd_size);
-
-	return rc;
-}
-
 NDCTL_EXPORT void ndctl_cmd_unref(struct ndctl_cmd *cmd)
 {
 	if (!cmd)
@@ -2645,26 +2520,6 @@ NDCTL_EXPORT int ndctl_dimm_is_active(struct ndctl_dimm *dimm)
 	return 0;
 }
 
-NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
-		struct ndctl_dimm *dimm)
-{
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	char *path = dimm->dimm_buf;
-	int len = dimm->buf_len;
-	char buf[20];
-
-	if (snprintf(path, len, "%s/available_slots", dimm->dimm_path) >= len) {
-		err(ctx, "%s: buffer too small!\n",
-				ndctl_dimm_get_devname(dimm));
-		return ULONG_MAX;
-	}
-
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		return ULONG_MAX;
-
-	return strtoul(buf, NULL, 0);
-}
-
 NDCTL_EXPORT int ndctl_interleave_set_is_active(
 		struct ndctl_interleave_set *iset)
 {
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 8bc730d4b39a..12e3102150fd 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -34,6 +34,63 @@
 #include "hpe1.h"
 #include "msft.h"
 
+/**
+ * struct ndctl_dimm - memory device as identified by NFIT
+ * @module: kernel module (libnvdimm)
+ * @handle: NFIT-handle value
+ * @major: /dev/nmemX major character device number
+ * @minor: /dev/nmemX minor character device number
+ * @phys_id: SMBIOS physical id
+ * @vendor_id: hardware component vendor
+ * @device_id: hardware device id
+ * @revision_id: hardware revision id
+ * @node: system node-id
+ * @socket: socket-id in the node
+ * @imc: memory-controller-id in the socket
+ * @channel: channel-id in the memory-controller
+ * @dimm: dimm-id in the channel
+ * @formats: number of support interfaces
+ * @format: array of format interface code numbers
+ */
+struct ndctl_dimm {
+	struct kmod_module *module;
+	struct ndctl_bus *bus;
+	struct ndctl_smart_ops *smart_ops;
+	unsigned int handle, major, minor, serial;
+	unsigned short phys_id;
+	unsigned short vendor_id;
+	unsigned short device_id;
+	unsigned short revision_id;
+	unsigned short subsystem_vendor_id;
+	unsigned short subsystem_device_id;
+	unsigned short subsystem_revision_id;
+	unsigned short manufacturing_date;
+	unsigned char manufacturing_location;
+	unsigned long dsm_family;
+	unsigned long dsm_mask;
+	char *unique_id;
+	char *dimm_path;
+	char *dimm_buf;
+	int health_eventfd;
+	int buf_len;
+	int id;
+	union dimm_flags {
+		unsigned long flags;
+		struct {
+			unsigned int f_map:1;
+			unsigned int f_arm:1;
+			unsigned int f_save:1;
+			unsigned int f_flush:1;
+			unsigned int f_smart:1;
+			unsigned int f_restore:1;
+			unsigned int f_notify:1;
+		};
+	} flags;
+	struct list_node list;
+	int formats;
+	int format[0];
+};
+
 #define SZ_16M 0x01000000
 
 enum {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
