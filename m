Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4CD1211F8886
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:39:34 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 2/3] ndctl/list.c: simplify flags handling
Date: Fri, 29 Jun 2018 17:39:26 -0600
Message-Id: <20180629233927.6232-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
References: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Kani, Toshi" <toshi.kani@hpe.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ndctl/list.c keeps track of a set of enum util_json_flags which are based
on the command line options passed in.  This handling is a little messy,
though.  We have an accessor function, listopts_to_flags(), which is used
multiple times.  We sometimes pass the flags around as function arguments,
and we also have a copy stashed in the local struct list_filter_arg called
"lfa".  In some functions we access the flags in multiple ways.

These flags are local to ndctl/list.c, are set exactly once per invocation
and never change.  Create a variable local to that file, initialize it once
and use it everywhere.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 ndctl/list.c  | 54 +++++++++++++++++++++++++++---------------------------
 util/filter.h |  1 -
 2 files changed, 27 insertions(+), 28 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 030d73f..32f679b 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -38,20 +38,7 @@ static struct {
 	bool firmware;
 } list;
 
-static unsigned long listopts_to_flags(void)
-{
-	unsigned long flags = 0;
-
-	if (list.idle)
-		flags |= UTIL_JSON_IDLE;
-	if (list.media_errors)
-		flags |= UTIL_JSON_MEDIA_ERRORS;
-	if (list.dax)
-		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
-	if (list.human)
-		flags |= UTIL_JSON_HUMAN;
-	return flags;
-}
+static unsigned long list_flags;
 
 struct util_filter_params param;
 
@@ -64,8 +51,7 @@ do { \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
-static struct json_object *region_to_json(struct ndctl_region *region,
-		unsigned long flags)
+static struct json_object *region_to_json(struct ndctl_region *region)
 {
 	struct json_object *jregion = json_object_new_object();
 	struct json_object *jobj, *jbbs, *jmappings = NULL;
@@ -83,13 +69,13 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		goto err;
 	json_object_object_add(jregion, "dev", jobj);
 
-	jobj = util_json_object_size(ndctl_region_get_size(region), flags);
+	jobj = util_json_object_size(ndctl_region_get_size(region), list_flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jregion, "size", jobj);
 
 	jobj = util_json_object_size(ndctl_region_get_available_size(region),
-			flags);
+			list_flags);
 	if (!jobj)
 		goto err;
 	json_object_object_add(jregion, "available_size", jobj);
@@ -118,7 +104,8 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	iset = ndctl_region_get_interleave_set(region);
 	if (iset) {
 		jobj = util_json_object_hex(
-				ndctl_interleave_set_get_cookie(iset), flags);
+				ndctl_interleave_set_get_cookie(iset),
+				list_flags);
 		if (!jobj)
 			fail("\n");
 		else
@@ -147,7 +134,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 			json_object_object_add(jregion, "mappings", jmappings);
 		}
 
-		jmapping = util_mapping_to_json(mapping, listopts_to_flags());
+		jmapping = util_mapping_to_json(mapping, list_flags);
 		if (!jmapping) {
 			fail("\n");
 			continue;
@@ -162,7 +149,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		json_object_object_add(jregion, "state", jobj);
 	}
 
-	jbbs = util_region_badblocks_to_json(region, &bb_count, flags);
+	jbbs = util_region_badblocks_to_json(region, &bb_count, list_flags);
 	if (bb_count) {
 		jobj = json_object_new_int(bb_count);
 		if (!jobj) {
@@ -171,7 +158,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		}
 		json_object_object_add(jregion, "badblock_count", jobj);
 	}
-	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
+	if ((list_flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
 	pd = ndctl_region_get_persistence_domain(region);
@@ -222,7 +209,7 @@ static void filter_namespace(struct ndctl_namespace *ndns,
 					lfa->jnamespaces);
 	}
 
-	jndns = util_namespace_to_json(ndns, lfa->flags);
+	jndns = util_namespace_to_json(ndns, list_flags);
 	if (!jndns) {
 		fail("\n");
 		return;
@@ -256,7 +243,7 @@ static bool filter_region(struct ndctl_region *region,
 					lfa->jregions);
 	}
 
-	jregion = region_to_json(region, lfa->flags);
+	jregion = region_to_json(region);
 	if (!jregion) {
 		fail("\n");
 		return false;
@@ -297,7 +284,7 @@ static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
 			json_object_object_add(lfa->jbus, "dimms", lfa->jdimms);
 	}
 
-	jdimm = util_dimm_to_json(dimm, lfa->flags);
+	jdimm = util_dimm_to_json(dimm, list_flags);
 	if (!jdimm) {
 		fail("\n");
 		return;
@@ -323,7 +310,7 @@ static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
 	if (list.firmware) {
 		struct json_object *jfirmware;
 
-		jfirmware = util_dimm_firmware_to_json(dimm, lfa->flags);
+		jfirmware = util_dimm_firmware_to_json(dimm, list_flags);
 		if (jfirmware)
 			json_object_object_add(jdimm, "firmware", jfirmware);
 	}
@@ -412,6 +399,18 @@ static int num_list_flags(void)
 	return list.buses + list.dimms + list.regions + list.namespaces;
 }
 
+static void init_list_flags(void)
+{
+	if (list.idle)
+		list_flags |= UTIL_JSON_IDLE;
+	if (list.media_errors)
+		list_flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (list.dax)
+		list_flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
+	if (list.human)
+		list_flags |= UTIL_JSON_HUMAN;
+}
+
 int cmd_list(int argc, const char **argv, void *ctx)
 {
 	const struct option options[] = {
@@ -470,12 +469,13 @@ int cmd_list(int argc, const char **argv, void *ctx)
 	if (num_list_flags() == 0)
 		list.namespaces = true;
 
+	init_list_flags();
+
 	fctx.filter_bus = filter_bus;
 	fctx.filter_dimm = list.dimms ? filter_dimm : NULL;
 	fctx.filter_region = filter_region;
 	fctx.filter_namespace = list.namespaces ? filter_namespace : NULL;
 	fctx.list = &lfa;
-	lfa.flags = listopts_to_flags();
 
 	rc = util_filter_walk(ctx, &fctx, &param);
 	if (rc)
diff --git a/util/filter.h b/util/filter.h
index effda24..c410df2 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -47,7 +47,6 @@ struct list_filter_arg {
 	struct json_object *jbuses;
 	struct json_object *jregion;
 	struct json_object *jbus;
-	unsigned long flags;
 };
 
 /*
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
