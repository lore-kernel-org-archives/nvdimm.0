Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DD4621A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 11:01:43 -0700 (PDT)
Subject: [PATCH v6] ndctl: add list --media-errors support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 11 May 2017 11:01:42 -0700
Message-ID: <149452561607.28242.9327540807726189144.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI NFIT enabled platforms provide media errors as absolute phyiscal
address offsets. Add an option to ndctl to display those media errors
tranlsated to region and namespace device level offsets in an "ndctl
list" listing. BTT badblocks show is not supported in this iteration and
will come later.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2: added fix to badblocks display from Toshi's testing result.
v3: fixed naming issues from Dan's comments.
    fixed badblocks boundary offset calculations from Toshi's testing.
v4: Add indicator to show badblocks exist or not, per Toshi's comments.
v5: Add BTT badblock_count from Toshi and Dan's comments.
v6: Fix badblock_count to total number of bbs and not range per Toshi.

 ndctl/list.c      |   25 +++++-
 ndctl/namespace.c |    2 
 util/json.c       |  218 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/json.h       |   10 ++
 4 files changed, 247 insertions(+), 8 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 536d333..8d912e6 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -24,6 +24,7 @@ static struct {
 	bool idle;
 	bool health;
 	bool dax;
+	bool media_errors;
 } list;
 
 static struct {
@@ -99,7 +100,8 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns, list.idle, list.dax);
+		jndns = util_namespace_to_json(ndns, list.idle, list.dax,
+				list.media_errors);
 		if (!jndns) {
 			fail("\n");
 			continue;
@@ -117,12 +119,14 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 	return NULL;
 }
 
-static struct json_object *region_to_json(struct ndctl_region *region)
+static struct json_object *region_to_json(struct ndctl_region *region,
+		bool include_media_err)
 {
 	struct json_object *jregion = json_object_new_object();
-	struct json_object *jobj, *jmappings = NULL;
+	struct json_object *jobj, *jobj2, *jmappings = NULL;
 	struct ndctl_interleave_set *iset;
 	struct ndctl_mapping *mapping;
+	unsigned int bb_count;
 
 	if (!jregion)
 		return NULL;
@@ -203,6 +207,17 @@ static struct json_object *region_to_json(struct ndctl_region *region)
 		json_object_object_add(jregion, "state", jobj);
 	}
 
+	jobj2 = util_region_badblocks_to_json(region, include_media_err,
+			&bb_count);
+	jobj = json_object_new_int(bb_count);
+	if (!jobj) {
+		json_object_put(jobj2);
+		goto err;
+	}
+	json_object_object_add(jregion, "badblock_count", jobj);
+	if (include_media_err && jobj2)
+		json_object_object_add(jregion, "badblocks", jobj2);
+
 	list_namespaces(region, jregion, NULL, false);
 	return jregion;
  err:
@@ -240,6 +255,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		OPT_BOOLEAN('X', "device-dax", &list.dax,
 				"include device-dax info"),
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_BOOLEAN('M', "media-errors", &list.media_errors,
+				"include media errors"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -404,7 +421,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 							jregions);
 			}
 
-			jregion = region_to_json(region);
+			jregion = region_to_json(region, list.media_errors);
 			if (!jregion) {
 				fail("\n");
 				continue;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 89b9b6a..6e150b1 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -392,7 +392,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		struct json_object *jndns = util_namespace_to_json(ndns, 0, 1);
+		struct json_object *jndns = util_namespace_to_json(ndns, 0, 1, 0);
 
 		if (jndns)
 			printf("%s\n", json_object_to_json_string_ext(jndns,
diff --git a/util/json.c b/util/json.c
index 07fd113..5bd7b00 100644
--- a/util/json.c
+++ b/util/json.c
@@ -233,19 +233,199 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	return NULL;
 }
 
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
+		bool include_media_errors, unsigned int *bb_count)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	struct badblock *bb;
+	int bbs = 0;
+
+	if (include_media_errors) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	}
+
+	ndctl_region_badblock_foreach(region, bb) {
+		if (include_media_errors) {
+			jbb = json_object_new_object();
+			if (!jbb)
+				goto err_array;
+
+			jobj = json_object_new_int64(bb->offset);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jbb, "offset", jobj);
+
+			jobj = json_object_new_int(bb->len);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jbb, "length", jobj);
+
+			json_object_array_add(jbbs, jbb);
+		}
+
+		bbs += bb->len;
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
+static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
+		unsigned long long dev_begin, unsigned long long dev_size,
+		bool include_media_errors, unsigned int *bb_count)
+{
+	struct json_object *jbb = NULL, *jbbs = NULL, *jobj;
+	unsigned long long region_begin, dev_end, offset;
+	unsigned int len, bbs = 0;
+	struct badblock *bb;
+
+	region_begin = ndctl_region_get_resource(region);
+	if (region_begin == ULLONG_MAX)
+		return NULL;
+
+	dev_end = dev_begin + dev_size - 1;
+
+	if (include_media_errors) {
+		jbbs = json_object_new_array();
+		if (!jbbs)
+			return NULL;
+	}
+
+	ndctl_region_badblock_foreach(region, bb) {
+		unsigned long long bb_begin, bb_end, begin, end;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_end = bb_begin + (bb->len << 9) - 1;
+
+		if (bb_end <= dev_begin || bb_begin >= dev_end)
+			continue;
+
+		if (bb_begin < dev_begin)
+			begin = dev_begin;
+		else
+			begin = bb_begin;
+
+		if (bb_end > dev_end)
+			end = dev_end;
+		else
+			end = bb_end;
+
+		offset = (begin - dev_begin) >> 9;
+		len = (end - begin + 1) >> 9;
+
+		if (include_media_errors) {
+			/* add to json */
+			jbb = json_object_new_object();
+			if (!jbb)
+				goto err_array;
+
+			jobj = json_object_new_int64(offset);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jbb, "offset", jobj);
+
+			jobj = json_object_new_int(len);
+			if (!jobj)
+				goto err;
+			json_object_object_add(jbb, "length", jobj);
+
+			json_object_array_add(jbbs, jbb);
+		}
+		bbs += bb->len;
+	}
+
+	*bb_count = bbs;
+
+	if (bbs)
+		return jbbs;
+
+ err:
+	json_object_put(jbb);
+ err_array:
+	json_object_put(jbbs);
+	return NULL;
+}
+
+struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
+		bool include_media_errors, unsigned int *bb_count)
+{
+	struct ndctl_region *region = ndctl_pfn_get_region(pfn);
+	unsigned long long pfn_begin, pfn_size;
+
+	pfn_begin = ndctl_pfn_get_resource(pfn);
+	if (pfn_begin == ULLONG_MAX)
+		return NULL;
+
+	pfn_size = ndctl_pfn_get_size(pfn);
+	if (pfn_size == ULLONG_MAX)
+		return NULL;
+
+	return dev_badblocks_to_json(region, pfn_begin, pfn_size,
+			include_media_errors, bb_count);
+}
+
+struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
+		bool include_media_errors, unsigned int *bb_count)
+{
+	struct ndctl_region *region = ndctl_btt_get_region(btt);
+	struct ndctl_namespace *ndns = ndctl_btt_get_namespace(btt);
+	unsigned long long btt_begin, btt_size;
+
+	btt_begin = ndctl_namespace_get_resource(ndns);
+	if (btt_begin == ULLONG_MAX)
+		return NULL;
+
+	btt_size = ndctl_btt_get_size(btt);
+	if (btt_size == ULLONG_MAX)
+		return NULL;
+
+	return dev_badblocks_to_json(region, btt_begin, btt_size,
+			include_media_errors, bb_count);
+}
+
+struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
+		bool include_media_errors, unsigned int *bb_count)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	unsigned long long dax_begin, dax_size;
+
+	dax_begin = ndctl_dax_get_resource(dax);
+	if (dax_begin == ULLONG_MAX)
+		return NULL;
+
+	dax_size = ndctl_dax_get_size(dax);
+	if (dax_size == ULLONG_MAX)
+		return NULL;
+
+	return dev_badblocks_to_json(region, dax_begin, dax_size,
+			include_media_errors, bb_count);
+}
+
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax)
+		bool include_idle, bool include_dax,
+		bool include_media_errors)
 {
 	struct json_object *jndns = json_object_new_object();
 	unsigned long long size = ULLONG_MAX;
 	enum ndctl_namespace_mode mode;
-	struct json_object *jobj;
+	struct json_object *jobj, *jobj2;
 	const char *bdev = NULL;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
 	struct ndctl_dax *dax;
 	char buf[40];
 	uuid_t uuid;
+	unsigned int bb_count;
 
 	if (!jndns)
 		return NULL;
@@ -368,6 +548,40 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		json_object_object_add(jndns, "state", jobj);
 	}
 
+	if (pfn)
+		jobj2 = util_pfn_badblocks_to_json(pfn, include_media_errors,
+				&bb_count);
+	else if (dax)
+		jobj2 = util_dax_badblocks_to_json(dax, include_media_errors,
+				&bb_count);
+	else if (btt) {
+		jobj2 = util_btt_badblocks_to_json(btt, include_media_errors,
+				&bb_count);
+		/*
+		 * Discard the jobj2, the badblocks for BTT is not,
+		 * accurate and there will be a good method to caculate
+		 * them later. We just want a bb count and not the specifics
+		 * for now.
+		 */
+		jobj2 = NULL;
+	} else {
+		struct ndctl_region *region =
+			ndctl_namespace_get_region(ndns);
+
+		jobj2 = util_region_badblocks_to_json(region,
+				include_media_errors, &bb_count);
+	}
+
+	jobj = json_object_new_int(bb_count);
+	if (!jobj) {
+		json_object_put(jobj2);
+		goto err;
+	}
+
+	json_object_object_add(jndns, "badblock_count", jobj);
+	if (include_media_errors && jobj2)
+			json_object_object_add(jndns, "badblocks", jobj2);
+
 	return jndns;
  err:
 	json_object_put(jndns);
diff --git a/util/json.h b/util/json.h
index 2449c2d..b3bc208 100644
--- a/util/json.h
+++ b/util/json.h
@@ -10,9 +10,17 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax);
+		bool include_idle, bool include_dax, bool include_media_errs);
 struct daxctl_region;
 struct daxctl_dev;
+struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax,
+		bool include_media_errors, unsigned int *bb_count);
+struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn,
+		bool include_media_errors, unsigned int *bb_count);
+struct json_object *util_btt_badblocks_to_json(struct ndctl_btt *btt,
+		bool include_media_errors, unsigned int *bb_count);
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region,
+		bool include_media_errors, unsigned int *bb_count);
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		bool include_devs, const char *ident, bool include_idle);
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
