Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E85621D49C72
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:06:10 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, list: export mapping position data
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 04 Aug 2017 18:01:59 -0700
Message-ID: <150189491949.17448.10332575350032968235.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If the kernel provides position data include it in the region mapping
listing.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   16 ++++++++++++++--
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 util/json.c            |    9 +++++++++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index dda134549842..c2e0efbd87b0 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -166,6 +166,7 @@ struct ndctl_dimm {
  * @dimm: backing dimm for the mapping
  * @offset: dimm relative offset
  * @length: span of the extent
+ * @position: interleave-order of the extent
  *
  * This data can be used to identify the dimm ranges contributing to a
  * region / interleave-set and identify how regions alias each other.
@@ -174,6 +175,7 @@ struct ndctl_mapping {
 	struct ndctl_region *region;
 	struct ndctl_dimm *dimm;
 	unsigned long long offset, length;
+	int position;
 	struct list_node list;
 };
 
@@ -2723,6 +2725,7 @@ static void mappings_init(struct ndctl_region *region)
 		unsigned long long offset, length;
 		struct ndctl_dimm *dimm;
 		unsigned int dimm_id;
+		int position, match;
 
 		sprintf(mapping_path, "%s/mapping%d", region->region_path, i);
 		if (sysfs_read_attr(ctx, mapping_path, buf) < 0) {
@@ -2731,8 +2734,11 @@ static void mappings_init(struct ndctl_region *region)
 			continue;
 		}
 
-		if (sscanf(buf, "nmem%u,%llu,%llu", &dimm_id, &offset,
-					&length) != 3) {
+		match = sscanf(buf, "nmem%u,%llu,%llu,%d", &dimm_id, &offset,
+				&length, &position);
+		if (match < 4)
+			position = -1;
+		if (match < 3) {
 			err(ctx, "bus%d mapping parse failure\n",
 					ndctl_bus_get_id(bus));
 			continue;
@@ -2756,6 +2762,7 @@ static void mappings_init(struct ndctl_region *region)
 		mapping->offset = offset;
 		mapping->length = length;
 		mapping->dimm = dimm;
+		mapping->position = position;
 		list_add(&region->mappings, &mapping->list);
 	}
 	free(mapping_path);
@@ -2790,6 +2797,11 @@ NDCTL_EXPORT unsigned long long ndctl_mapping_get_length(struct ndctl_mapping *m
 	return mapping->length;
 }
 
+NDCTL_EXPORT int ndctl_mapping_get_position(struct ndctl_mapping *mapping)
+{
+	return mapping->position;
+}
+
 NDCTL_EXPORT struct ndctl_region *ndctl_mapping_get_region(
 		struct ndctl_mapping *mapping)
 {
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 0e592435ff70..b8ac65f2917f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -157,6 +157,7 @@ global:
 	ndctl_mapping_get_region;
 	ndctl_mapping_get_offset;
 	ndctl_mapping_get_length;
+	ndctl_mapping_get_position;
 	ndctl_namespace_get_first;
 	ndctl_namespace_get_next;
 	ndctl_namespace_get_ctx;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 200c5cf8781a..855d883c3380 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -460,6 +460,7 @@ struct ndctl_bus *ndctl_mapping_get_bus(struct ndctl_mapping *mapping);
 struct ndctl_region *ndctl_mapping_get_region(struct ndctl_mapping *mapping);
 unsigned long long ndctl_mapping_get_offset(struct ndctl_mapping *mapping);
 unsigned long long ndctl_mapping_get_length(struct ndctl_mapping *mapping);
+int ndctl_mapping_get_position(struct ndctl_mapping *mapping);
 
 struct ndctl_namespace;
 struct ndctl_namespace *ndctl_namespace_get_first(struct ndctl_region *region);
diff --git a/util/json.c b/util/json.c
index 5f1492711c47..98165b789ff8 100644
--- a/util/json.c
+++ b/util/json.c
@@ -737,6 +737,7 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
 	struct json_object *jmapping = json_object_new_object();
 	struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
 	struct json_object *jobj;
+	int position;
 
 	if (!jmapping)
 		return NULL;
@@ -756,6 +757,14 @@ struct json_object *util_mapping_to_json(struct ndctl_mapping *mapping,
 		goto err;
 	json_object_object_add(jmapping, "length", jobj);
 
+	position = ndctl_mapping_get_position(mapping);
+	if (position >= 0) {
+		jobj = json_object_new_int(position);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jmapping, "position", jobj);
+	}
+
 	return jmapping;
  err:
 	json_object_put(jmapping);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
