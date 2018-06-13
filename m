Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9338921197072
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 16:21:05 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, list: Add controller temperature
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Jun 2018 16:11:07 -0700
Message-ID: <152893146792.8891.9589382470202184792.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Emit the controller temperature if the smart payload includes this
field.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/util/json-smart.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 4020423bb8c8..9482b35a43d6 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -109,6 +109,16 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 			json_object_object_add(jhealth, "temperature_celsius", jobj);
 	}
 
+	if (flags & ND_SMART_CTEMP_VALID) {
+		unsigned int temp = ndctl_cmd_smart_get_ctrl_temperature(cmd);
+		double t = ndctl_decode_smart_temperature(temp);
+
+		jobj = json_object_new_double(t);
+		if (jobj)
+			json_object_object_add(jhealth,
+					"controller_temperature_celsius", jobj);
+	}
+
 	if (flags & ND_SMART_SPARES_VALID) {
 		unsigned int spares = ndctl_cmd_smart_get_spares(cmd);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
