Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86CC8210DC1B7
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 08:35:26 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id AB087AC01D8
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 00:35:17 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH] ndctl,
 list: emit alarm_enable_<field> and clarify misc list items
Date: Wed,  8 Aug 2018 00:35:14 +0900
Message-Id: <20180807153514.31748-1-qi.fuli@jp.fujitsu.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds alarm_enable_<field> to list. Therefore, users can know
if the "ndclt inject-smart --<field>-alarm=on/off" works or not.

Users may confuse "alarm_enable" with "alarm_flag" and "media_temperature"
with "ctrl_temperature", this patch also used to clarify these items.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/util/json-smart.c | 45 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 6a1f294..a0677a6 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -39,34 +39,61 @@ static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 		unsigned int temp;
 		double t;
 
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_media_temperature", jobj);
 		temp = ndctl_cmd_smart_threshold_get_temperature(cmd);
 		t = ndctl_decode_smart_temperature(temp);
 		jobj = json_object_new_double(t);
 		if (jobj)
 			json_object_object_add(jhealth,
-					"temperature_threshold", jobj);
+					"media_temperature_threshold", jobj);
+	} else {
+		jobj = json_object_new_boolean(false);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_media_temperature", jobj);
 	}
 
 	if (alarm_control & ND_SMART_CTEMP_TRIP) {
 		unsigned int temp;
 		double t;
 
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_ctrl_temperature", jobj);
 		temp = ndctl_cmd_smart_threshold_get_ctrl_temperature(cmd);
 		t = ndctl_decode_smart_temperature(temp);
 		jobj = json_object_new_double(t);
 		if (jobj)
 			json_object_object_add(jhealth,
-				"controller_temperature_threshold", jobj);
+				"ctrl_temperature_threshold", jobj);
+	} else {
+		jobj = json_object_new_boolean(false);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_ctrl_temperature", jobj);
 	}
 
 	if (alarm_control & ND_SMART_SPARE_TRIP) {
 		unsigned int spares;
 
+		jobj = json_object_new_boolean(true);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_spares", jobj);
 		spares = ndctl_cmd_smart_threshold_get_spares(cmd);
 		jobj = json_object_new_int(spares);
 		if (jobj)
 			json_object_object_add(jhealth,
 					"spares_threshold", jobj);
+	} else {
+		jobj = json_object_new_boolean(false);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"alarm_enable_spares", jobj);
 	}
 
  out:
@@ -118,7 +145,8 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 
 		jobj = json_object_new_double(t);
 		if (jobj)
-			json_object_object_add(jhealth, "temperature_celsius", jobj);
+			json_object_object_add(jhealth,
+					"media_temperature_celsius", jobj);
 	}
 
 	if (flags & ND_SMART_CTEMP_VALID) {
@@ -128,7 +156,7 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 		jobj = json_object_new_double(t);
 		if (jobj)
 			json_object_object_add(jhealth,
-					"controller_temperature_celsius", jobj);
+					"ctrl_temperature_celsius", jobj);
 	}
 
 	if (flags & ND_SMART_SPARES_VALID) {
@@ -147,15 +175,18 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 
 		jobj = json_object_new_boolean(temp_flag);
 		if (jobj)
-			json_object_object_add(jhealth, "alarm_temperature", jobj);
+			json_object_object_add(jhealth,
+					"alarm_flag_media_temperature", jobj);
 
 		jobj = json_object_new_boolean(ctrl_temp_flag);
 		if (jobj)
-			json_object_object_add(jhealth, "alarm_controller_temperature", jobj);
+			json_object_object_add(jhealth,
+					"alarm_flag_ctrl_temperature", jobj);
 
 		jobj = json_object_new_boolean(spares_flag);
 		if (jobj)
-			json_object_object_add(jhealth, "alarm_spares", jobj);
+			json_object_object_add(jhealth,
+					"alarm_flag_spares", jobj);
 	}
 
 	smart_threshold_to_json(dimm, jhealth);
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
