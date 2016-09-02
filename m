Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5255E1A1E0F
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 06:34:07 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH 1/2] util: make parse_smart_temperature() global
Date: Fri,  2 Sep 2016 08:32:37 -0500
Message-Id: <20160902133238.22200-2-brian.boylston@hpe.com>
In-Reply-To: <20160902133238.22200-1-brian.boylston@hpe.com>
References: <20160902133238.22200-1-brian.boylston@hpe.com>
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

Allow parse_smart_temperature() to be called by other modules with similar
temperature decoding needs.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Brian Boylston <brian.boylston@hpe.com>
---
 ndctl/util/json-smart.c | 2 +-
 ndctl/util/json.h       | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 824c51e..103af19 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -11,7 +11,7 @@
 #include <ndctl.h>
 #endif
 
-static double parse_smart_temperature(unsigned int temp)
+double parse_smart_temperature(unsigned int temp)
 {
 	bool negative = !!(temp & (1 << 15));
 	double t;
diff --git a/ndctl/util/json.h b/ndctl/util/json.h
index 7492e51..e8b1549 100644
--- a/ndctl/util/json.h
+++ b/ndctl/util/json.h
@@ -13,8 +13,13 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		bool include_idle);
 #ifdef HAVE_NDCTL_SMART
+double parse_smart_temperature(unsigned int temp);
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else
+static inline double parse_smart_temperature(unsigned int temp)
+{
+	return 0.0;
+}
 static inline struct json_object *util_dimm_health_to_json(
 		struct ndctl_dimm *dimm)
 {
-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
