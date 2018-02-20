Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C281621CF1CF3
 for <linux-nvdimm@lists.01.org>; Tue, 20 Feb 2018 10:12:30 -0800 (PST)
Subject: [PATCH v6] ndctl: add option to list firmware information for a DIMM
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Feb 2018 11:18:28 -0700
Message-ID: <151915070801.67767.2713552470571834771.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151915058813.67767.11669588596758645038.stgit@djiang5-desk3.ch.intel.com>
References: <151915058813.67767.11669588596758645038.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding firmware output of firmware information when ndctl list -D -F is used.
Components displayed are current firmware version, next firmware version,
and if a powercycle is required (firmware updated).

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
---
 Documentation/ndctl/ndctl-list.txt |   13 +++++
 ndctl/Makefile.am                  |    1 
 ndctl/lib/firmware.c               |    2 -
 ndctl/lib/intel.c                  |   12 ++++-
 ndctl/lib/libndctl.sym             |    2 -
 ndctl/lib/private.h                |    2 -
 ndctl/libndctl.h                   |    2 -
 ndctl/list.c                       |   13 +++++
 ndctl/util/json-firmware.c         |   91 ++++++++++++++++++++++++++++++++++++
 util/json.h                        |    2 +
 10 files changed, 134 insertions(+), 6 deletions(-)
 create mode 100644 ndctl/util/json-firmware.c

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index fc07a71..02d4f04 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -110,6 +110,19 @@ include::xable-region-options.txt[]
   }
 }
 
+-F::
+--firmware::
+	Include dimm firmware info in the listing. For example:
+[verse]
+{
+  "dev":"nmem0",
+  "firmware":{
+      "current_version":0,
+      "next_version":1,
+      "need_powercycle":true
+  }
+}
+
 -X::
 --device-dax::
 	Include device-dax ("daxregion") details when a namespace is in
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 2054c1a..e0db97b 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -13,6 +13,7 @@ ndctl_SOURCES = ndctl.c \
 		test.c \
 		../util/json.c \
 		util/json-smart.c \
+		util/json-firmware.c \
 		inject-error.c \
 		update.c \
 		inject-smart.c
diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
index 1851018..f6deec5 100644
--- a/ndctl/lib/firmware.c
+++ b/ndctl/lib/firmware.c
@@ -93,7 +93,7 @@ firmware_cmd_op(fw_info_get_max_send_len, unsigned int, 0)
 firmware_cmd_op(fw_info_get_query_interval, unsigned int, 0)
 firmware_cmd_op(fw_info_get_max_query_time, unsigned int, 0)
 firmware_cmd_op(fw_info_get_run_version, unsigned long long, 0)
-firmware_cmd_op(fw_info_get_updated_version, unsigned long long, 0)
+firmware_cmd_op(fw_info_get_next_version, unsigned long long, 0)
 firmware_cmd_op(fw_start_get_context, unsigned int, 0)
 firmware_cmd_op(fw_fquery_get_fw_rev, unsigned long long, 0)
 
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 8daf5d2..c5661ed 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -433,7 +433,15 @@ intel_fw_info_get_field32(cmd, max_send_len)
 intel_fw_info_get_field32(cmd, query_interval)
 intel_fw_info_get_field32(cmd, max_query_time);
 intel_fw_info_get_field64(cmd, run_version);
-intel_fw_info_get_field64(cmd, updated_version);
+
+static unsigned long long intel_cmd_fw_info_get_next_version(
+		struct ndctl_cmd *cmd)
+{
+	if (intel_fw_get_info_valid(cmd) < 0)
+		return ULLONG_MAX;
+	return cmd->intel->info.updated_version;
+
+}
 
 static struct ndctl_cmd *intel_dimm_cmd_new_fw_start(struct ndctl_dimm *dimm)
 {
@@ -669,7 +677,7 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.fw_info_get_query_interval = intel_cmd_fw_info_get_query_interval,
 	.fw_info_get_max_query_time = intel_cmd_fw_info_get_max_query_time,
 	.fw_info_get_run_version = intel_cmd_fw_info_get_run_version,
-	.fw_info_get_updated_version = intel_cmd_fw_info_get_updated_version,
+	.fw_info_get_next_version = intel_cmd_fw_info_get_next_version,
 	.new_fw_start_update = intel_dimm_cmd_new_fw_start,
 	.fw_start_get_context = intel_cmd_fw_start_get_context,
 	.new_fw_send = intel_dimm_cmd_new_fw_send,
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index e7f9675..ac1e7cb 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -339,7 +339,7 @@ global:
 	ndctl_cmd_fw_info_get_query_interval;
 	ndctl_cmd_fw_info_get_max_query_time;
 	ndctl_cmd_fw_info_get_run_version;
-	ndctl_cmd_fw_info_get_updated_version;
+	ndctl_cmd_fw_info_get_next_version;
 	ndctl_cmd_fw_start_get_context;
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b9e3c1d..15e983a 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -314,7 +314,7 @@ struct ndctl_dimm_ops {
 	unsigned int (*fw_info_get_query_interval)(struct ndctl_cmd *);
 	unsigned int (*fw_info_get_max_query_time)(struct ndctl_cmd *);
 	unsigned long long (*fw_info_get_run_version)(struct ndctl_cmd *);
-	unsigned long long (*fw_info_get_updated_version)(struct ndctl_cmd *);
+	unsigned long long (*fw_info_get_next_version)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_fw_start_update)(struct ndctl_dimm *);
 	unsigned int (*fw_start_get_context)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_fw_send)(struct ndctl_cmd *,
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 6091ff3..e9a8110 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -620,7 +620,7 @@ unsigned int ndctl_cmd_fw_info_get_max_send_len(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_info_get_query_interval(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_info_get_max_query_time(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_info_get_run_version(struct ndctl_cmd *cmd);
-unsigned long long ndctl_cmd_fw_info_get_updated_version(struct ndctl_cmd *cmd);
+unsigned long long ndctl_cmd_fw_info_get_next_version(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
diff --git a/ndctl/list.c b/ndctl/list.c
index 37a224a..8bb9920 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -35,6 +35,7 @@ static struct {
 	bool dax;
 	bool media_errors;
 	bool human;
+	bool firmware;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -277,6 +278,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
 		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
+		OPT_BOOLEAN('F', "firmware", &list.firmware, "include firmware info"),
 		OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
 		OPT_BOOLEAN('R', "regions", &list.regions,
 				"include region info"),
@@ -420,6 +422,17 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				}
 			}
 
+			if (list.firmware) {
+				struct json_object *jfirmware;
+
+				jfirmware = util_dimm_firmware_to_json(dimm,
+						listopts_to_flags());
+				if (jfirmware)
+					json_object_object_add(jdimm,
+							"firmware",
+							jfirmware);
+			}
+
 			/*
 			 * Without a bus we are collecting dimms anonymously
 			 * across the platform.
diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
new file mode 100644
index 0000000..f7aefe4
--- /dev/null
+++ b/ndctl/util/json-firmware.c
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+#include <limits.h>
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+#include <ndctl.h>
+
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags)
+{
+	struct json_object *jfirmware = json_object_new_object();
+	struct json_object *jobj;
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint64_t run, next;
+	bool reboot = false;
+
+	if (!jfirmware)
+		return NULL;
+
+	cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
+	if (!cmd)
+		goto err;
+
+	rc = ndctl_cmd_submit(cmd);
+	if (rc || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
+		int run_err = -1;
+
+		jobj = util_json_object_hex(run_err, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "current_version",
+					jobj);
+		goto out;
+	}
+
+	run = ndctl_cmd_fw_info_get_run_version(cmd);
+	if (run == ULLONG_MAX) {
+		int run_err = -1;
+
+		jobj = util_json_object_hex(run_err, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "current_version",
+					jobj);
+		goto out;
+	}
+
+	jobj = util_json_object_hex(run, flags);
+	if (jobj)
+		json_object_object_add(jfirmware, "current_version", jobj);
+
+	next = ndctl_cmd_fw_info_get_next_version(cmd);
+	if (next == ULLONG_MAX) {
+		int next_err = -1;
+
+		jobj = util_json_object_hex(next_err, flags);
+		if (jobj)
+			json_object_object_add(jfirmware, "next_version",
+					jobj);
+		goto out;
+	}
+
+	if (next != 0) {
+		reboot = true;
+		jobj = util_json_object_hex(next, flags);
+		if (jobj)
+			json_object_object_add(jfirmware,
+					"next_version", jobj);
+	}
+
+	if (reboot) {
+		jobj = json_object_new_boolean(reboot);
+		if (jobj)
+			json_object_object_add(jfirmware,
+					"need_powercycle", jobj);
+	}
+
+	ndctl_cmd_unref(cmd);
+	return jfirmware;
+
+err:
+	json_object_put(jfirmware);
+	jfirmware = NULL;
+out:
+	if (cmd)
+		ndctl_cmd_unref(cmd);
+	return jfirmware;
+}
+
diff --git a/util/json.h b/util/json.h
index 9663475..c5d1603 100644
--- a/util/json.h
+++ b/util/json.h
@@ -52,4 +52,6 @@ struct json_object *util_json_object_size(unsigned long long size,
 struct json_object *util_json_object_hex(unsigned long long val,
 		unsigned long flags);
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
+		unsigned long flags);
 #endif /* __NDCTL_JSON_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
