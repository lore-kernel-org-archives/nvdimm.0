Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A38EB21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:31 -0800 (PST)
Subject: [ndctl PATCH 14/17] ndctl,
 smart: move smart temperature parsing to a library routine
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:44 -0800
Message-ID: <151217074412.28402.914175135907454573.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Similar to the 'ndctl list' command, consumers of the smart apis need to
be able to convert the encoded smart temperature to a number.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c    |   13 +++++++++++++
 ndctl/lib/libndctl.sym  |    1 +
 ndctl/libndctl.h        |    1 +
 ndctl/util/json-smart.c |   17 ++---------------
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 8471dd8c4f89..01788f47fbd0 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -74,6 +74,19 @@ NDCTL_EXPORT size_t ndctl_sizeof_namespace_label(void)
 	return offsetof(struct namespace_label, type_guid);
 }
 
+NDCTL_EXPORT double ndctl_decode_smart_temperature(unsigned int temp)
+{
+	bool negative = !!(temp & (1 << 15));
+	double t;
+
+	temp &= ~(1 << 15);
+	t = temp;
+	t /= 16;
+	if (negative)
+		t *= -1;
+	return t;
+}
+
 struct ndctl_ctx;
 
 /**
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6d9a04282c7d..2ace9420b158 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -321,4 +321,5 @@ global:
 	ndctl_cmd_smart_threshold_set_media_temperature;
 	ndctl_cmd_smart_threshold_set_ctrl_temperature;
 	ndctl_cmd_smart_threshold_set_spares;
+	ndctl_decode_smart_temperature;
 } LIBNDCTL_13;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 0dfd373e7897..e9da20e57f32 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -74,6 +74,7 @@ extern "C" {
 size_t ndctl_min_namespace_size(void);
 size_t ndctl_sizeof_namespace_index(void);
 size_t ndctl_sizeof_namespace_label(void);
+double ndctl_decode_smart_temperature(unsigned int temp);
 
 struct ndctl_ctx;
 struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx);
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 7aabf4f3aebe..4020423bb8c8 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -18,19 +18,6 @@
 #include <ccan/array_size/array_size.h>
 #include <ndctl.h>
 
-static double parse_smart_temperature(unsigned int temp)
-{
-	bool negative = !!(temp & (1 << 15));
-	double t;
-
-	temp &= ~(1 << 15);
-	t = temp;
-	t /= 16;
-	if (negative)
-		t *= -1;
-	return t;
-}
-
 static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 		struct json_object *jhealth)
 {
@@ -53,7 +40,7 @@ static void smart_threshold_to_json(struct ndctl_dimm *dimm,
 		double t;
 
 		temp = ndctl_cmd_smart_threshold_get_temperature(cmd);
-		t = parse_smart_temperature(temp);
+		t = ndctl_decode_smart_temperature(temp);
 		jobj = json_object_new_double(t);
 		if (jobj)
 			json_object_object_add(jhealth,
@@ -115,7 +102,7 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 
 	if (flags & ND_SMART_TEMP_VALID) {
 		unsigned int temp = ndctl_cmd_smart_get_temperature(cmd);
-		double t = parse_smart_temperature(temp);
+		double t = ndctl_decode_smart_temperature(temp);
 
 		jobj = json_object_new_double(t);
 		if (jobj)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
