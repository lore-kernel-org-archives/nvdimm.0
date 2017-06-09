Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9684C21967BC4
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 09:33:45 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [ndctl PATCH] Report the Health Status Detail for the HPE1 DSM family
Date: Fri,  9 Jun 2017 12:34:31 -0400
Message-ID: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
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

This patch adds a new interface to provide additional Health Status Detail.
This information is reported as part of the Smart Health with the HPE1
DSM family so the function for the other families is NULL by default.  If
the field is available, the ndctl --health option will decode
the bits that make up the field.  If the DSM family doesn't support
this function, no additional information is provided.

With this change a healthy NVDIMM-N that supports this information 
would report something like this:

{
    "dev":"nmem6",
    "id":"802c-0f-1612-122eb278",
    "health":{
      "health_state":"ok",
      "temperature_celsius":25.000000,
      "spares_percentage":99, 
      "alarm_temperature":false, 
      "alarm_spares":false,   
      "temperature_threshold":50.000000,
      "spares_threshold":20,
      "life_used_percentage":0,  
      "shutdown_state":"clean", 
      "health_status_detail":[
        "ok"
      ]
    }
  }

An ailing NVDIMM-N could report one or more health status
conditions, sometime like this:

{
    "dev":"nmem6",
    "id":"802c-0f-1612-122eb278",
    "health":{
      "health_state":"ok",
      "temperature_celsius":25.000000,
      "spares_percentage":99,
      "alarm_temperature":false,
      "alarm_spares":false,
      "temperature_threshold":50.000000,
      "spares_threshold":20,
      "life_used_percentage":0,
      "shutdown_state":"clean",
      "health_status_detail":[
        "energy_source_error",
        "arm_error",
      ]
    }
  }

Signed-off-by: Linda Knippers <linda.knippers@hpe.com>
---
 ndctl/lib/libndctl-hpe1.c    | 12 +++++++++++
 ndctl/lib/libndctl-private.h |  1 +
 ndctl/lib/libndctl-smart.c   |  2 ++
 ndctl/lib/libndctl.sym       |  1 +
 ndctl/libndctl.h.in          |  5 +++++
 ndctl/ndctl.h                |  1 +
 ndctl/util/json-smart.c      | 49 ++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 71 insertions(+)

diff --git a/ndctl/lib/libndctl-hpe1.c b/ndctl/lib/libndctl-hpe1.c
index ec54252..23b76a4 100644
--- a/ndctl/lib/libndctl-hpe1.c
+++ b/ndctl/lib/libndctl-hpe1.c
@@ -63,6 +63,7 @@ static struct ndctl_cmd *hpe1_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_USED_VALID;
 	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_SHUTDOWN_VALID;
 	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_VENDOR_VALID;
+	hpe1->u.smart.in_valid_flags |= NDN_HPE1_SMART_DETAIL_VALID;
 
 	cmd->firmware_status = &hpe1->u.smart.status;
 
@@ -104,6 +105,8 @@ static unsigned int hpe1_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 		flags |= ND_SMART_SHUTDOWN_VALID;
 	if (hpe1flags & NDN_HPE1_SMART_VENDOR_VALID)
 		flags |= ND_SMART_VENDOR_VALID;
+	if (hpe1flags & NDN_HPE1_SMART_DETAIL_VALID)
+		flags |= ND_SMART_DETAIL_VALID;
 
 	return flags;
 }
@@ -282,6 +285,14 @@ static unsigned int hpe1_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd)
 
 	return CMD_HPE1_SMART_THRESH(cmd)->spare_block_threshold;
 }
+static unsigned int hpe1_cmd_smart_get_detail(struct ndctl_cmd *cmd)
+{
+	if (hpe1_smart_valid(cmd) < 0)
+		return UINT_MAX;
+
+	return CMD_HPE1_SMART(cmd)->mod_hlth_stat;
+}
+
 
 struct ndctl_smart_ops * const hpe1_smart_ops = &(struct ndctl_smart_ops) {
 	.new_smart = hpe1_dimm_cmd_new_smart,
@@ -298,4 +309,5 @@ struct ndctl_smart_ops * const hpe1_smart_ops = &(struct ndctl_smart_ops) {
 	.smart_threshold_get_alarm_control = hpe1_cmd_smart_threshold_get_alarm_control,
 	.smart_threshold_get_temperature = hpe1_cmd_smart_threshold_get_temperature,
 	.smart_threshold_get_spares = hpe1_cmd_smart_threshold_get_spares,
+	.smart_get_detail = hpe1_cmd_smart_get_detail,
 };
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 8f10fbc..cb2ddbd 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -223,6 +223,7 @@ struct ndctl_smart_ops {
 	unsigned int (*smart_threshold_get_alarm_control)(struct ndctl_cmd *);
 	unsigned int (*smart_threshold_get_temperature)(struct ndctl_cmd *);
 	unsigned int (*smart_threshold_get_spares)(struct ndctl_cmd *);
+	unsigned int (*smart_get_detail)(struct ndctl_cmd *);
 };
 
 #if HAS_SMART == 1
diff --git a/ndctl/lib/libndctl-smart.c b/ndctl/lib/libndctl-smart.c
index 73a49ef..890fa47 100644
--- a/ndctl/lib/libndctl-smart.c
+++ b/ndctl/lib/libndctl-smart.c
@@ -63,6 +63,7 @@ smart_cmd_op(ndctl_cmd_smart_get_vendor_data, smart_get_vendor_data, unsigned ch
 smart_cmd_op(ndctl_cmd_smart_threshold_get_alarm_control, smart_threshold_get_alarm_control, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_threshold_get_temperature, smart_threshold_get_temperature, unsigned int, 0)
 smart_cmd_op(ndctl_cmd_smart_threshold_get_spares, smart_threshold_get_spares, unsigned int, 0)
+smart_cmd_op(ndctl_cmd_smart_get_detail, smart_get_detail, unsigned int, 0)
 
 /*
  * The following intel_dimm_*() and intel_smart_*() functions implement
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 9bc36a3..ba7cc9b 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -112,6 +112,7 @@ global:
 	ndctl_cmd_smart_threshold_get_alarm_control;
 	ndctl_cmd_smart_threshold_get_temperature;
 	ndctl_cmd_smart_threshold_get_spares;
+	ndctl_cmd_smart_get_detail;
 	ndctl_dimm_zero_labels;
 	ndctl_dimm_get_available_labels;
 	ndctl_region_get_first;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 2c45d2d..6ad595e 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -283,6 +283,7 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_smart_threshold(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_smart_threshold_get_alarm_control(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_temperature(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_smart_threshold_get_spares(struct ndctl_cmd *cmd);
+unsigned int ndctl_cmd_smart_get_detail(struct ndctl_cmd *cmd);
 #else
 static inline struct ndctl_cmd *ndctl_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
@@ -344,6 +345,10 @@ static inline unsigned int ndctl_cmd_smart_threshold_get_spares(
 {
 	return 0;
 }
+static inline unsigned int ndctl_cmd_smart_get_detail(struct ndctl_cmd *cmd)
+{
+	return 0;
+}
 #endif
 
 struct ndctl_cmd *ndctl_dimm_cmd_new_vendor_specific(struct ndctl_dimm *dimm,
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 3b1d703..0bdf96f 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -28,6 +28,7 @@ struct nd_cmd_smart {
 #define ND_SMART_ALARM_VALID	(1 << 9)
 #define ND_SMART_SHUTDOWN_VALID	(1 << 10)
 #define ND_SMART_VENDOR_VALID	(1 << 11)
+#define ND_SMART_DETAIL_VALID	(1 << 13)
 #define ND_SMART_SPARE_TRIP	(1 << 0)
 #define ND_SMART_TEMP_TRIP	(1 << 1)
 #define ND_SMART_CTEMP_TRIP	(1 << 2)
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index aaaa0de..f191a96 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -22,6 +22,7 @@
 #else
 #include <ndctl.h>
 #endif
+#include "lib/ndctl-hpe1.h"
 
 static double parse_smart_temperature(unsigned int temp)
 {
@@ -163,6 +164,53 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 			json_object_object_add(jhealth, "shutdown_state", jobj);
 	}
 
+#define json_health_detail(jobj, jstring, detail, bit, string) \
+{ \
+	if (detail & bit) { \
+		jstring = json_object_new_string(string); \
+		if (jstring) \
+			json_object_array_add(jobj, jstring); \
+	} \
+}
+
+	if (flags & ND_SMART_DETAIL_VALID) {
+		unsigned int detail = ndctl_cmd_smart_get_detail(cmd);
+		json_object *jstring = NULL;
+
+		jobj = json_object_new_array();
+		if (detail) {
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_ES_FAILURE, "energy_source_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_CTLR_FAILURE, "controller_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_UE_TRIP, "UC_ECC_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_CE_TRIP, "CE_trip")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_SAVE_FAILED, "save_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_RESTORE_FAILED, "restore_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_ARM_FAILED, "arm_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_ERASE_FAILED, "erase_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_CONFIG_ERROR, "config_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_FW_ERROR, "firmware_error")
+			json_health_detail(jobj, jstring, detail,
+				NDN_HPE1_SMART_VENDOR_ERROR, "vendor_specific_error")
+		} else {
+			jstring = json_object_new_string("ok");
+			if (jstring)
+				json_object_array_add(jobj, jstring);
+		}
+		if (jobj)
+			json_object_object_add(jhealth, "health_status_detail",
+				jobj);
+	}
+
 	ndctl_cmd_unref(cmd);
 	return jhealth;
  err:
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
