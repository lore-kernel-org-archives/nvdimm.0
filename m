Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 441EA21E0B9F2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 16:05:12 -0800 (PST)
Subject: [PATCH] ndctl: add option to list firmware information for a DIMM
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 12 Feb 2018 17:11:02 -0700
Message-ID: <151848066201.13592.3757378386488366418.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding firmware output of firmware information when ndctl list -D -F is used.
Components displayed are current firmware version, updated firmware version,
and if a coldboot is required (firmware updated).

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-list.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index fc07a71..85b87d4 100644
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
+      "coldboot_required":true
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
diff --git a/ndctl/list.c b/ndctl/list.c
index 37a224a..ebe0a67 100644
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
@@ -420,6 +422,25 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				}
 			}
 
+			if (list.firmware) {
+				struct json_object *jfirmware;
+
+				jfirmware = util_dimm_firmware_to_json(dimm);
+				if (jfirmware)
+					json_object_object_add(jdimm,
+							"firmware",
+							jfirmware);
+				else if (ndctl_dimm_is_cmd_supported(dimm,
+							ND_CMD_CALL)) {
+					/*
+					 * Failed to retrieve firmware
+					 * version.
+					 */
+					fail("\n");
+					continue;
+				}
+			}
+
 			/*
 			 * Without a bus we are collecting dimms anonymously
 			 * across the platform.
diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
new file mode 100644
index 0000000..0010493
--- /dev/null
+++ b/ndctl/util/json-firmware.c
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <limits.h>
+#include <util/json.h>
+#include <uuid/uuid.h>
+#include <json-c/json.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+#include <ndctl.h>
+
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm)
+{
+	struct json_object *jfirmware = json_object_new_object();
+	struct json_object *jobj;
+	struct ndctl_cmd *cmd;
+	int rc;
+	uint64_t run, updated;
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
+		jobj = json_object_new_string("unknown");
+		if (jobj)
+			json_object_object_add(jfirmware, "version",
+					jobj);
+		goto out;
+	}
+
+	run = ndctl_cmd_fw_info_get_run_version(cmd);
+	if (run == ULLONG_MAX) {
+		jobj = json_object_new_string("unknown");
+		if (jobj)
+			json_object_object_add(jfirmware, "current_version",
+					jobj);
+		goto out;
+	}
+
+	jobj = json_object_new_int64(run);
+	if (jobj)
+		json_object_object_add(jfirmware, "current_version", jobj);
+
+	updated = ndctl_cmd_fw_info_get_updated_version(cmd);
+	if (updated == ULLONG_MAX) {
+		jobj = json_object_new_string("unknown");
+		if (jobj)
+			json_object_object_add(jfirmware, "next_version",
+					jobj);
+		goto out;
+	}
+
+	if (updated == 0) {
+		jobj = json_object_new_string("none");
+		if (jobj)
+			json_object_object_add(jfirmware, "next_version",
+					jobj);
+	} else {
+		reboot = true;
+		jobj = json_object_new_int64(updated);
+		if (jobj)
+			json_object_object_add(jfirmware,
+					"next_version", jobj);
+	}
+
+	if (reboot) {
+		jobj = json_object_new_boolean(reboot);
+		if (jobj)
+			json_object_object_add(jfirmware,
+					"coldboot_required", jobj);
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
index 9663475..8504d5c 100644
--- a/util/json.h
+++ b/util/json.h
@@ -52,4 +52,5 @@ struct json_object *util_json_object_size(unsigned long long size,
 struct json_object *util_json_object_hex(unsigned long long val,
 		unsigned long flags);
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
+struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm);
 #endif /* __NDCTL_JSON_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
