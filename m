Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B15921A13493
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 16:31:44 -0700 (PDT)
Subject: [PATCH v2 2/2] ndctl: add list --media-errors support
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 09 May 2017 16:31:43 -0700
Message-ID: <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
References: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
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

Adding option for ndctl list command to show badblocks for region and
device. The device badblocks are calculated from the region badblocks.
This allows the user to provide the proper badblock offset and length
for clearing later on.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: added fix to badblocks display from Toshi's testing result.

 ndctl/list.c      |   17 ++++-
 ndctl/namespace.c |    2 -
 util/json.c       |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/json.h       |    5 +-
 4 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 536d333..264b613 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -24,6 +24,7 @@ static struct {
 	bool idle;
 	bool health;
 	bool dax;
+	bool media_errs;
 } list;
 
 static struct {
@@ -99,7 +100,8 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns, list.idle, list.dax);
+		jndns = util_namespace_to_json(ndns, list.idle, list.dax,
+				list.media_errs);
 		if (!jndns) {
 			fail("\n");
 			continue;
@@ -117,7 +119,8 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 	return NULL;
 }
 
-static struct json_object *region_to_json(struct ndctl_region *region)
+static struct json_object *region_to_json(struct ndctl_region *region,
+		bool include_media_err)
 {
 	struct json_object *jregion = json_object_new_object();
 	struct json_object *jobj, *jmappings = NULL;
@@ -203,6 +206,12 @@ static struct json_object *region_to_json(struct ndctl_region *region)
 		json_object_object_add(jregion, "state", jobj);
 	}
 
+	if (include_media_err) {
+		jobj = util_region_badblocks_to_json(region);
+		if (jobj)
+			json_object_object_add(jregion, "badblocks", jobj);
+	}
+
 	list_namespaces(region, jregion, NULL, false);
 	return jregion;
  err:
@@ -240,6 +249,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		OPT_BOOLEAN('X', "device-dax", &list.dax,
 				"include device-dax info"),
 		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_BOOLEAN('M', "media-errors", &list.media_errs,
+				"include media errors"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -404,7 +415,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
 							jregions);
 			}
 
-			jregion = region_to_json(region);
+			jregion = region_to_json(region, list.media_errs);
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
index 07fd113..958ac51 100644
--- a/util/json.c
+++ b/util/json.c
@@ -233,8 +233,150 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	return NULL;
 }
 
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region)
+{
+	struct json_object *jbbs = NULL, *jbb_array, *jobj;
+	struct badblock *bb;
+	int bbs = 0;
+
+	jbb_array = json_object_new_array();
+	if (!jbb_array)
+		return NULL;
+
+	ndctl_region_badblock_foreach(region, bb) {
+		jbbs = json_object_new_object();
+		if (!jbbs)
+			goto err_array;
+
+		jobj = json_object_new_int64(bb->offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbbs, "offset", jobj);
+
+		jobj = json_object_new_int(bb->len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbbs, "length", jobj);
+
+		json_object_array_add(jbb_array, jbbs);
+		bbs++;
+	}
+
+	if (bbs)
+		return jbb_array;
+
+ err:
+	json_object_put(jbbs);
+ err_array:
+	json_object_put(jbb_array);
+	return NULL;
+}
+
+static struct json_object *dev_badblocks_to_json(struct ndctl_region *region,
+		unsigned long long dev_begin, unsigned long long dev_size)
+{
+	struct json_object *jbbs = NULL, *jbb_array, *jobj;
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
+	jbb_array = json_object_new_array();
+	if (!jbb_array)
+		return NULL;
+
+	ndctl_region_badblock_foreach(region, bb) {
+		unsigned long long bb_begin, bb_end, begin, end;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_end = bb_begin + (bb->len << 9) - 1;
+
+		if (bb_begin <= dev_begin)
+			begin = dev_begin;
+		else if (bb_begin < dev_end)
+			begin = bb_begin;
+		else
+			begin = 0;
+
+		if (begin) {
+			if (bb_end <= dev_end)
+				end = bb_end;
+			else
+				end = dev_end;
+		} else
+			continue;
+
+		offset = (begin - dev_begin) >> 9;
+		len = (end - begin + 1) >> 9;
+
+		/* add to json */
+		jbbs = json_object_new_object();
+		if (!jbbs)
+			goto err_array;
+
+		jobj = json_object_new_int64(offset);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbbs, "offset", jobj);
+
+		jobj = json_object_new_int(len);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jbbs, "length", jobj);
+
+		json_object_array_add(jbb_array, jbbs);
+		bbs++;
+	}
+
+	if (bbs)
+		return jbb_array;
+
+ err:
+	json_object_put(jbbs);
+ err_array:
+	json_object_put(jbb_array);
+	return NULL;
+}
+
+struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn)
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
+	return dev_badblocks_to_json(region, pfn_begin, pfn_size);
+}
+
+struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax)
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
+	return dev_badblocks_to_json(region, dax_begin, dax_size);
+}
+
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax)
+		bool include_idle, bool include_dax, bool include_media_err)
 {
 	struct json_object *jndns = json_object_new_object();
 	unsigned long long size = ULLONG_MAX;
@@ -317,6 +459,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
+		if (include_media_err) {
+			jobj = util_pfn_badblocks_to_json(pfn);
+			if (jobj)
+				json_object_object_add(jndns,
+						"badblocks", jobj);
+		}
 	} else if (dax) {
 		struct daxctl_region *dax_region;
 
@@ -333,6 +481,12 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			if (jobj)
 				json_object_object_add(jndns, "daxregion", jobj);
 		}
+		if (include_media_err) {
+			jobj = util_dax_badblocks_to_json(dax);
+			if (jobj)
+				json_object_object_add(jndns,
+						"badblocks", jobj);
+		}
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;
 
@@ -351,6 +505,15 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			json_object_object_add(jndns, "name", jobj);
 		}
 		bdev = ndctl_namespace_get_block_device(ndns);
+		if (include_media_err) {
+			struct ndctl_region *region =
+				ndctl_namespace_get_region(ndns);
+
+			jobj = util_region_badblocks_to_json(region);
+			if (jobj)
+				json_object_object_add(jndns,
+						"badblocks", jobj);
+		}
 	} else
 		bdev = ndctl_namespace_get_block_device(ndns);
 
diff --git a/util/json.h b/util/json.h
index 2449c2d..ef1d606 100644
--- a/util/json.h
+++ b/util/json.h
@@ -10,9 +10,12 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus);
 struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm);
 struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping);
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
-		bool include_idle, bool include_dax);
+		bool include_idle, bool include_dax, bool include_media_errs);
 struct daxctl_region;
 struct daxctl_dev;
+struct json_object *util_dax_badblocks_to_json(struct ndctl_dax *dax);
+struct json_object *util_pfn_badblocks_to_json(struct ndctl_pfn *pfn);
+struct json_object *util_region_badblocks_to_json(struct ndctl_region *region);
 struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		bool include_devs, const char *ident, bool include_idle);
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
