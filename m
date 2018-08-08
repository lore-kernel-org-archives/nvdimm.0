Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5B6D210D97AF
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 19:43:54 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 84A19AC00ED
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 11:43:49 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v2] ndctl, list: add alarm_enable_<field> to list
Date: Wed,  8 Aug 2018 11:43:35 +0900
Message-Id: <20180808024335.12793-1-qi.fuli@jp.fujitsu.com>
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

This patch adds alarm_enable_<field> to list, so that users could check
if the "ndctl inject-smart --<field>-alarm=on/off" works well or not.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
v1 -> v2:
 remove the renaming for list items.

 ndctl/util/json-smart.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 6a1f294..e25483d 100644
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
 					"temperature_threshold", jobj);
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
 				"controller_temperature_threshold", jobj);
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
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
