Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 748B6203B99D2
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 01:42:57 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 53489AC0166
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 17:42:50 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH] ndctl, list: add controller temperature threshold
Date: Mon, 25 Jun 2018 17:42:17 +0900
Message-Id: <20180625084217.10608-1-qi.fuli@jp.fujitsu.com>
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

This patch adds controller temperature threshold to list.
When the dimm-controller-temperature event fires, users need to know
the current controller temperature threshold value.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/util/json-smart.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 9482b35..d590b0c 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -47,6 +47,18 @@ static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 					"temperature_threshold", jobj);
 	}
 
+	if (alarm_control & ND_SMART_TEMP_TRIP) {
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
 
-- 
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
