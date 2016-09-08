Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 500C61A1E59
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 10:38:29 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH] util: fix dimm health alarm trip reporting
Date: Thu,  8 Sep 2016 12:36:54 -0500
Message-Id: <20160908173654.31479-1-brian.boylston@hpe.com>
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

Use ndctl_cmd_smart_get_alarm_flags() instead of
ndctl_cmd_smart_get_spares() to populate "alarm_temperature" and
"alarm_spares".

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/util/json-smart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 824c51e..94519da 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -120,7 +120,7 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 	}
 
 	if (flags & ND_SMART_ALARM_VALID) {
-		unsigned int alarm_flags = ndctl_cmd_smart_get_spares(cmd);
+		unsigned int alarm_flags = ndctl_cmd_smart_get_alarm_flags(cmd);
 		bool temp_flag = !!(alarm_flags & ND_SMART_TEMP_TRIP);
 		bool spares_flag = !!(alarm_flags & ND_SMART_SPARE_TRIP);
 
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
