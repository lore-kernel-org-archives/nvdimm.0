Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F8DE802D4
 for <linux-nvdimm@lists.01.org>; Fri,  3 Mar 2017 22:14:25 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 1/7] libndctl: add a ndctl_namespace_is_active helper
Date: Fri,  3 Mar 2017 23:13:01 -0700
Message-Id: <20170304061307.13530-2-vishal.l.verma@intel.com>
In-Reply-To: <20170304061307.13530-1-vishal.l.verma@intel.com>
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
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

The pattern of checking if a namespace is currently active was repeated
in many places. Convert the scattered usage into a libndctl API. This
gets rid of util_namespace_active from util/json.c which was an awkward
place for this anyway.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/builtin-list.c   |  2 +-
 ndctl/lib/libndctl.c   | 15 +++++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h.in    |  2 ++
 util/json.c            | 17 +----------------
 util/json.h            |  1 -
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index e8d0070..536d333 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -84,7 +84,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 		if (param.mode && mode_to_type(param.mode) != mode)
 			continue;
 
-		if (!list.idle && !util_namespace_active(ndns))
+		if (!list.idle && !ndctl_namespace_is_active(ndns))
 			continue;
 
 		if (!jnamespaces) {
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 565c969..8396e48 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3208,6 +3208,21 @@ static void region_refresh_children(struct ndctl_region *region)
 	daxs_init(region);
 }
 
+NDCTL_EXPORT bool ndctl_namespace_is_active(struct ndctl_namespace *ndns)
+{
+	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
+
+	if ((btt && ndctl_btt_is_enabled(btt))
+			|| (pfn && ndctl_pfn_is_enabled(pfn))
+			|| (dax && ndctl_dax_is_enabled(dax))
+			|| (!btt && !pfn && !dax
+				&& ndctl_namespace_is_enabled(ndns)))
+		return true;
+	return false;
+}
+
 /*
  * Return 0 if enabled, < 0 if failed to enable, and > 0 if claimed by
  * another device and that device is enabled.  In the > 0 case a
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index be2e368..5f47a22 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -171,6 +171,7 @@ global:
 	ndctl_namespace_enable;
 	ndctl_namespace_disable;
 	ndctl_namespace_disable_invalidate;
+	ndctl_namespace_is_active;
 	ndctl_namespace_is_valid;
 	ndctl_namespace_is_configured;
 	ndctl_namespace_delete;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index c27581d..c70215c 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -13,6 +13,7 @@
 #ifndef _LIBNDCTL_H_
 #define _LIBNDCTL_H_
 
+#include <stdbool.h>
 #include <stdarg.h>
 #include <unistd.h>
 
@@ -483,6 +484,7 @@ int ndctl_namespace_is_enabled(struct ndctl_namespace *ndns);
 int ndctl_namespace_enable(struct ndctl_namespace *ndns);
 int ndctl_namespace_disable(struct ndctl_namespace *ndns);
 int ndctl_namespace_disable_invalidate(struct ndctl_namespace *ndns);
+bool ndctl_namespace_is_active(struct ndctl_namespace *ndns);
 int ndctl_namespace_is_valid(struct ndctl_namespace *ndns);
 int ndctl_namespace_is_configured(struct ndctl_namespace *ndns);
 int ndctl_namespace_delete(struct ndctl_namespace *ndns);
diff --git a/util/json.c b/util/json.c
index d6a8d4c..82d8073 100644
--- a/util/json.c
+++ b/util/json.c
@@ -86,21 +86,6 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm)
 	return NULL;
 }
 
-bool util_namespace_active(struct ndctl_namespace *ndns)
-{
-	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
-	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
-	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
-
-	if ((btt && ndctl_btt_is_enabled(btt))
-			|| (pfn && ndctl_pfn_is_enabled(pfn))
-			|| (dax && ndctl_dax_is_enabled(dax))
-			|| (!btt && !pfn && !dax
-				&& ndctl_namespace_is_enabled(ndns)))
-		return true;
-	return false;
-}
-
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
 {
 	const char *devname = daxctl_dev_get_devname(dev);
@@ -334,7 +319,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "blockdev", jobj);
 	}
 
-	if (!util_namespace_active(ndns)) {
+	if (!ndctl_namespace_is_active(ndns)) {
 		jobj = json_object_new_string("disabled");
 		if (!jobj)
 			goto err;
diff --git a/util/json.h b/util/json.h
index a9afb2d..2449c2d 100644
--- a/util/json.h
+++ b/util/json.h
@@ -6,7 +6,6 @@
 
 struct json_object;
 void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
-bool util_namespace_active(struct ndctl_namespace *ndns);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
