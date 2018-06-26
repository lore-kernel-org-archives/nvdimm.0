Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77BCC202E53F3
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 19:00:34 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1DDACAC007F
 for <linux-nvdimm@lists.01.org>;
 Tue, 26 Jun 2018 11:00:27 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v2] ndctl, list: add controller temperature threshold
Date: Tue, 26 Jun 2018 11:00:12 +0900
Message-Id: <20180626020012.14097-1-qi.fuli@jp.fujitsu.com>
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

This patch is used for adding controller_temperature_threshold and
alarm_controller_temperature to list. When a dimm-controller-temperature
event fires, users need to know the current controller temperature
threshold value.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/util/json-smart.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 9482b35..6a1f294 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -47,6 +47,18 @@ static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 					"temperature_threshold", jobj);
 	}
 
+	if (alarm_control & ND_SMART_CTEMP_TRIP) {
+		unsigned int temp;
+		double t;
+
+		temp = ndctl_cmd_smart_threshold_get_ctrl_temperature(cmd);
+		t = ndctl_decode_smart_temperature(temp);
+		jobj = json_object_new_double(t);
+		if (jobj)
+			json_object_object_add(jhealth,
+				"controller_temperature_threshold", jobj);
+	}
+
 	if (alarm_control & ND_SMART_SPARE_TRIP) {
 		unsigned int spares;
 
@@ -130,12 +142,17 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 	if (flags & ND_SMART_ALARM_VALID) {
 		unsigned int alarm_flags = ndctl_cmd_smart_get_alarm_flags(cmd);
 		bool temp_flag = !!(alarm_flags & ND_SMART_TEMP_TRIP);
+		bool ctrl_temp_flag = !!(alarm_flags & ND_SMART_CTEMP_TRIP);
 		bool spares_flag = !!(alarm_flags & ND_SMART_SPARE_TRIP);
 
 		jobj = json_object_new_boolean(temp_flag);
 		if (jobj)
 			json_object_object_add(jhealth, "alarm_temperature", jobj);
 
+		jobj = json_object_new_boolean(ctrl_temp_flag);
+		if (jobj)
+			json_object_object_add(jhealth, "alarm_controller_temperature", jobj);
+
 		jobj = json_object_new_boolean(spares_flag);
 		if (jobj)
 			json_object_object_add(jhealth, "alarm_spares", jobj);
-- 
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
