Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABA9D210E2A6A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 15:41:21 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [ndctl PATCHv4] ndctl: Add 'list' verbose options
Date: Wed,  8 Aug 2018 16:41:52 -0600
Message-Id: <20180808224152.16781-1-keith.busch@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The informational and miscellaneous flag options are becoming more
numerous, and can be difficult to remember what can be listed. This
patch adds a 'verbose' option that increases the detail listed by
automatically enabling options and less essential information.

The verbose option can be repeated multiple times to increase the
detail. There are currently three levels of verbose with output detail
documented in the ndctl list manpage.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v3 -> v4:

  Added the verbose check for namespace numa node (per Ross)

 Documentation/ndctl/ndctl-list.txt | 14 ++++++++++++++
 ndctl/list.c                       | 25 ++++++++++++++++++++++++-
 ndctl/namespace.c                  |  2 +-
 util/json.c                        | 32 ++++++++++++++++++++------------
 util/json.h                        |  1 +
 5 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index 1b5882a..c823493 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -201,6 +201,20 @@ include::xable-region-options.txt[]
   ]
 }
 
+-v::
+--verbose::
+	Increase verbosity of the output. This can be specified
+	multiple times to be even more verbose on the informational and
+	miscellaneous output, and can be used to override omitted flags
+	for showing specific information. +
+*-v*
+In addition to the enabled namespaces default output, show the numa_node,
+raw_uuid, and bad block media errors. +
+*-vv*
+Everything '-v' provides, plus automatically enable --dimms, --buses, and --regions. +
+*-vvv*
+Everything '-vv' provides, plus --health, --idle, and --firmware.
+
 include::human-option.txt[]
 
 ----
diff --git a/ndctl/list.c b/ndctl/list.c
index 82e88bb..33f111f 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -36,6 +36,7 @@ static struct {
 	bool media_errors;
 	bool human;
 	bool firmware;
+	int verbose;
 } list;
 
 static unsigned long listopts_to_flags(void)
@@ -50,6 +51,8 @@ static unsigned long listopts_to_flags(void)
 		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (list.human)
 		flags |= UTIL_JSON_HUMAN;
+	if (list.verbose)
+		flags |= UTIL_JSON_VERBOSE;
 	return flags;
 }
 
@@ -118,7 +121,7 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	json_object_object_add(jregion, "type", jobj);
 
 	numa = ndctl_region_get_numa_node(region);
-	if (numa >= 0) {
+	if (numa >= 0 && flags & UTIL_JSON_VERBOSE) {
 		jobj = json_object_new_int(numa);
 		if (jobj)
 			json_object_object_add(jregion, "numa_node", jobj);
@@ -452,6 +455,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				"include media errors"),
 		OPT_BOOLEAN('u', "human", &list.human,
 				"use human friendly number formats "),
+		OPT_INCR('v', "verbose", &list.verbose,
+				"increase output detail"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -476,6 +481,24 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			param.mode = "dax";
 	}
 
+	switch (list.verbose) {
+	default:
+	case 3:
+		list.idle = true;
+		list.firmware = true;
+		list.health = true;
+	case 2:
+		list.dimms = true;
+		list.buses = true;
+		list.regions = true;
+	case 1:
+		list.media_errors = true;
+		list.namespaces = true;
+		list.dax = true;
+	case 0:
+		break;
+	}
+
 	if (num_list_flags() == 0)
 		list.namespaces = true;
 
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index cfe0559..510553c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -423,7 +423,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
+		unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS | UTIL_JSON_VERBOSE;
 		struct json_object *jndns;
 
 		if (isatty(1))
diff --git a/util/json.c b/util/json.c
index 1332458..2d15859 100644
--- a/util/json.c
+++ b/util/json.c
@@ -664,6 +664,21 @@ static struct json_object *util_raw_uuid(struct ndctl_namespace *ndns)
 	return json_object_new_string(buf);
 }
 
+static void util_raw_uuid_to_json(struct ndctl_namespace *ndns,
+				  unsigned long flags,
+				  struct json_object *jndns)
+{
+	struct json_object *jobj;
+
+	if (!(flags & UTIL_JSON_VERBOSE))
+		return;
+
+	jobj = util_raw_uuid(ndns);
+	if (!jobj)
+		return;
+	json_object_object_add(jndns, "raw_uuid", jobj);
+}
+
 struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		unsigned long flags)
 {
@@ -752,10 +767,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-
-		jobj = util_raw_uuid(ndns);
-		if (jobj)
-			json_object_object_add(jndns, "raw_uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
 		bdev = ndctl_btt_get_block_device(btt);
 	} else if (pfn) {
 		ndctl_pfn_get_uuid(pfn, uuid);
@@ -764,9 +776,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-		jobj = util_raw_uuid(ndns);
-		if (jobj)
-			json_object_object_add(jndns, "raw_uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
 		bdev = ndctl_pfn_get_block_device(pfn);
 	} else if (dax) {
 		struct daxctl_region *dax_region;
@@ -778,9 +788,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 		if (!jobj)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
-		jobj = util_raw_uuid(ndns);
-		if (jobj)
-			json_object_object_add(jndns, "raw_uuid", jobj);
+		util_raw_uuid_to_json(ndns, flags, jndns);
 		if ((flags & UTIL_JSON_DAX) && dax_region) {
 			jobj = util_daxctl_region_to_json(dax_region, NULL,
 					flags);
@@ -827,7 +835,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	 * happens because they use pre-v1.2 labels or because they
 	 * don't have a label space (devtype=nd_namespace_io).
 	 */
-	if (sector_size < UINT_MAX) {
+	if (sector_size < UINT_MAX && flags & UTIL_JSON_VERBOSE) {
 		jobj = json_object_new_int(sector_size);
 		if (!jobj)
 			goto err;
@@ -857,7 +865,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 	}
 
 	numa = ndctl_namespace_get_numa_node(ndns);
-	if (numa >= 0) {
+	if (numa >= 0 && flags & UTIL_JSON_VERBOSE) {
 		jobj = json_object_new_int(numa);
 		if (jobj)
 			json_object_object_add(jndns, "numa_node", jobj);
diff --git a/util/json.h b/util/json.h
index aa2e976..e292973 100644
--- a/util/json.h
+++ b/util/json.h
@@ -23,6 +23,7 @@ enum util_json_flags {
 	UTIL_JSON_DAX = (1 << 2),
 	UTIL_JSON_DAX_DEVS = (1 << 3),
 	UTIL_JSON_HUMAN = (1 << 4),
+	UTIL_JSON_VERBOSE = (1 << 5),
 };
 
 struct json_object;
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
