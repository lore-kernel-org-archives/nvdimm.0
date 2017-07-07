Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 567AC21CF25AC
 for <linux-nvdimm@lists.01.org>; Fri,  7 Jul 2017 13:42:00 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl, list: convert json control flags to bit-flags
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Jul 2017 13:37:14 -0700
Message-ID: <149945983420.8106.11115958268447823152.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149945982889.8106.13607379131149182964.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149945982889.8106.13607379131149182964.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Before we go to add new flags to pass through the json helpers, convert the
existing control flags to bit flags.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/list.c     |   17 ++++++++++++++---
 ndctl/list.c      |   25 ++++++++++++++++++-------
 ndctl/namespace.c |    3 ++-
 util/json.c       |   54 ++++++++++++++++++++++++++---------------------------
 util/json.h       |   14 ++++++++++----
 5 files changed, 70 insertions(+), 43 deletions(-)

diff --git a/daxctl/list.c b/daxctl/list.c
index 3e3f822b0ea1..e213df138f07 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -28,6 +28,17 @@ static struct {
 	bool idle;
 } list;
 
+static unsigned long listopts_to_flags(void)
+{
+	unsigned long flags = 0;
+
+	if (list.devs)
+		flags |= UTIL_JSON_DAX;
+	if (list.idle)
+		flags |= UTIL_JSON_IDLE;
+	return flags;
+}
+
 static struct {
 	const char *dev;
 	int region_id;
@@ -102,15 +113,15 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			}
 
 			jregion = util_daxctl_region_to_json(region,
-					list.devs, param.dev, list.idle);
+					param.dev, listopts_to_flags());
 			if (!jregion) {
 				fail("\n");
 				continue;
 			}
 			json_object_array_add(jregions, jregion);
 		} else if (list.devs)
-			jdevs = util_daxctl_devs_to_list(region,
-					jdevs, param.dev, list.idle);
+			jdevs = util_daxctl_devs_to_list(region, jdevs,
+					param.dev, listopts_to_flags());
 	}
 
 	if (jregions)
diff --git a/ndctl/list.c b/ndctl/list.c
index ad710ed70de5..7ecfcc91b0ec 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -39,6 +39,19 @@ static struct {
 	bool media_errors;
 } list;
 
+static unsigned long listopts_to_flags(void)
+{
+	unsigned long flags = 0;
+
+	if (list.idle)
+		flags |= UTIL_JSON_IDLE;
+	if (list.media_errors)
+		flags |= UTIL_JSON_MEDIA_ERRORS;
+	if (list.dax)
+		flags |= UTIL_JSON_DAX;
+	return flags;
+}
+
 static struct {
 	const char *bus;
 	const char *region;
@@ -112,8 +125,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns, list.idle, list.dax,
-				list.media_errors);
+		jndns = util_namespace_to_json(ndns, listopts_to_flags());
 		if (!jndns) {
 			fail("\n");
 			continue;
@@ -132,7 +144,7 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 }
 
 static struct json_object *region_to_json(struct ndctl_region *region,
-		bool include_media_errors)
+		unsigned long flags)
 {
 	struct json_object *jregion = json_object_new_object();
 	struct json_object *jobj, *jbbs, *jmappings = NULL;
@@ -219,8 +231,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		json_object_object_add(jregion, "state", jobj);
 	}
 
-	jbbs = util_region_badblocks_to_json(region, include_media_errors,
-			&bb_count);
+	jbbs = util_region_badblocks_to_json(region, &bb_count, flags);
 	if (bb_count) {
 		jobj = json_object_new_int(bb_count);
 		if (!jobj) {
@@ -229,7 +240,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 		}
 		json_object_object_add(jregion, "badblock_count", jobj);
 	}
-	if (include_media_errors && jbbs)
+	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
 	list_namespaces(region, jregion, NULL, false);
@@ -435,7 +446,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 							jregions);
 			}
 
-			jregion = region_to_json(region, list.media_errors);
+			jregion = region_to_json(region, listopts_to_flags());
 			if (!jregion) {
 				fail("\n");
 				continue;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 778a65d02c2a..b28936cfd3ec 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -397,7 +397,8 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns, 0, 1, 0);
+		struct json_object *jndns = util_namespace_to_json(ndns,
+				UTIL_JSON_DAX);
 
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,
diff --git a/util/json.c b/util/json.c
index a9b733a76f05..1863bca10121 100644
--- a/util/json.c
+++ b/util/json.c
@@ -161,7 +161,8 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev)
 }
 
 struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
-		struct json_object *jdevs, const char *ident, bool include_idle)
+		struct json_object *jdevs, const char *ident,
+		unsigned long flags)
 {
 	struct daxctl_dev *dev;
 
@@ -171,7 +172,7 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 		if (!util_daxctl_dev_filter(dev, ident))
 			continue;
 
-		if (!include_idle && !daxctl_dev_get_size(dev))
+		if (!(flags & UTIL_JSON_IDLE) && !daxctl_dev_get_size(dev))
 			continue;
 
 		if (!jdevs) {
@@ -193,7 +194,7 @@ struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 }
 
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
-		bool include_devs, const char *ident, bool include_idle)
+		const char *ident, unsigned long flags)
 {
 	unsigned long align;
 	struct json_object *jregion, *jobj;
@@ -232,10 +233,10 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		json_object_object_add(jregion, "align", jobj);
 	}
 
-	if (!include_devs)
+	if (!(flags & UTIL_JSON_DAX))
 		return jregion;
 
-	jobj = util_daxctl_devs_to_list(region, NULL, ident, include_idle);
+	jobj = util_daxctl_devs_to_list(region, NULL, ident, flags);
 	if (jobj)
 		json_object_object_add(jregion, "devices", jobj);
 
@@ -246,20 +247,20 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 }
 
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
-		bool include_media_errors, unsigned int *bb_count)
+		unsigned int *bb_count, unsigned long flags)
 {
 	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
 	struct badblock *bb;
 	int bbs = 0;
 
-	if (include_media_errors) {
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
 		jbbs = json_object_new_array();
 		if (!jbbs)
 			return NULL;
 	}
 
 	ndctl_region_badblock_foreach(region, bb) {
-		if (include_media_errors) {
+		if (flags & UTIL_JSON_MEDIA_ERRORS) {
 			jbb = json_object_new_object();
 			if (!jbb)
 				goto err_array;
@@ -294,7 +295,7 @@ struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
 
 static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		unsigned long long dev_begin, unsigned long long dev_size,
-		bool include_media_errors, unsigned int *bb_count)
+		unsigned int *bb_count, unsigned long flags)
 {
 	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
 	unsigned long long region_begin, dev_end, offset;
@@ -307,7 +308,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 
 	dev_end = dev_begin + dev_size - 1;
 
-	if (include_media_errors) {
+	if (flags & UTIL_JSON_MEDIA_ERRORS) {
 		jbbs = json_object_new_array();
 		if (!jbbs)
 			return NULL;
@@ -335,7 +336,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 		offset = (begin - dev_begin) >> 9;
 		len = (end - begin + 1) >> 9;
 
-		if (include_media_errors) {
+		if (flags & UTIL_JSON_MEDIA_ERRORS) {
 			/* add to json */
 			jbb = json_object_new_object();
 			if (!jbb)
@@ -369,7 +370,7 @@ static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
 }
 
 static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
-		bool include_media_errors, unsigned int *bb_count)
+		unsigned int *bb_count, unsigned long flags)
 {
 	struct ndctl_region *region = ndctl_pfn_get_region(pfn);
 	unsigned long long pfn_begin, pfn_size;
@@ -383,7 +384,7 @@ static struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
 		return NULL;
 
 	return dev_badblocks_to_json(region, pfn_begin, pfn_size,
-			include_media_errors, bb_count);
+			bb_count, flags);
 }
 
 static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
@@ -409,11 +410,11 @@ static void util_btt_badblocks_to_json(struct ndctl_btt *btt,
 	 * FIXME: switch to native BTT badblocks representation
 	 * when / if the kernel provides it.
 	 */
-	dev_badblocks_to_json(region, begin, size, false, bb_count);
+	dev_badblocks_to_json(region, begin, size, bb_count, 0);
 }
 
 static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
-		bool include_media_errors, unsigned int *bb_count)
+		unsigned int *bb_count, unsigned long flags)
 {
 	struct ndctl_region *region = ndctl_dax_get_region(dax);
 	unsigned long long dax_begin, dax_size;
@@ -427,12 +428,11 @@ static struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
 		return NULL;
 
 	return dev_badblocks_to_json(region, dax_begin, dax_size,
-			include_media_errors, bb_count);
+			bb_count, flags);
 }
 
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax,
-		bool include_media_errors)
+		unsigned long flags)
 {
 	struct json_object *jndns = json_object_new_object();
 	struct json_object *jobj, *jbbs = NULL;
@@ -526,10 +526,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-		if (include_dax) {
+		if (flags & UTIL_JSON_DAX) {
 			dax_region = ndctl_dax_get_daxctl_region(dax);
-			jobj = util_daxctl_region_to_json(dax_region,
-					true, NULL, include_idle);
+			jobj = util_daxctl_region_to_json(dax_region, NULL,
+					flags);
 			if (jobj)
 				json_object_object_add(jndns, "daxregion", jobj);
 		}
@@ -576,17 +576,15 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	}
 
 	if (pfn)
-		jbbs = util_pfn_badblocks_to_json(pfn, include_media_errors,
-				&bb_count);
+		jbbs = util_pfn_badblocks_to_json(pfn, &bb_count, flags);
 	else if (dax)
-		jbbs = util_dax_badblocks_to_json(dax, include_media_errors,
-				&bb_count);
+		jbbs = util_dax_badblocks_to_json(dax, &bb_count, flags);
 	else if (btt)
 		util_btt_badblocks_to_json(btt, &bb_count);
 	else
 		jbbs = util_region_badblocks_to_json(
-				ndctl_namespace_get_region(ndns),
-				include_media_errors, &bb_count);
+				ndctl_namespace_get_region(ndns), &bb_count,
+				flags);
 
 	if (bb_count) {
 		jobj = json_object_new_int(bb_count);
@@ -597,7 +595,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "badblock_count", jobj);
 	}
 
-	if (include_media_errors && jbbs)
+	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jndns, "badblocks", jbbs);
 
 	return jndns;
diff --git a/util/json.h b/util/json.h
index 966478466313..19d5ffc4376e 100644
--- a/util/json.h
+++ b/util/json.h
@@ -16,23 +16,29 @@
 #include <stdbool.h>
 #include <ndctl/libndctl.h>
 
+enum util_json_flags {
+	UTIL_JSON_IDLE = (1 << 0),
+	UTIL_JSON_MEDIA_ERRORS = (1 << 1),
+	UTIL_JSON_DAX = (1 << 2),
+};
+
 struct json_object;
 void util_display_json_array(FILE *f_out, struct json_object *jarray, int jflag);
 struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax, bool include_media_errs);
+		unsigned long flags);
 struct daxctl_region;
 struct daxctl_dev;
 struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
-		bool include_media_errors, unsigned int *bb_count);
+		unsigned int *bb_count, unsigned long flags);
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
-		bool include_devs, const char *ident, bool include_idle);
+		const char *ident, unsigned long flags);
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);
 struct json_object *util_daxctl_devs_to_list(struct daxctl_region *region,
 		struct json_object *jdevs, const char *ident,
-		bool include_idle);
+		unsigned long flags);
 #ifdef HAVE_NDCTL_SMART
 struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm);
 #else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
