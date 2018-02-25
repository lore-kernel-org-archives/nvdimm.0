Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1926920955F1A
 for <linux-nvdimm@lists.01.org>; Sat, 24 Feb 2018 19:06:27 -0800 (PST)
Subject: [ndctl PATCH] ndctl,
 list: refactor core topology walking into util_filter_walk()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 24 Feb 2018 19:03:25 -0800
Message-ID: <151952780557.18856.16567756084992647908.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The ability to walk the nvdimm device hierarchy and take action on
device objects at each level depending on filter parameters is
generically useful. The first intended consumer of this infrastructure
is monitoring functionality. Given that events can be generated from
buses, regions, namespaces, and dimms, util_filter_walk() can be used to
select a subset of that topology for various monitoring tasks.

Consider monitor tasks like "run the 'page administrator' script if
any DIMM event happens on namespace0.0, and log everything else".

        ndctl monitor --dimm-events=all -n namespace0.0 --run=page_admin.sh
        ndctl monitor --log

util_filter_walk() implements the 'filter any object by any other
object' mechanism.

Cc: Qi Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/list.c  |  496 ++++++++++++++++++++++++---------------------------------
 util/filter.c |  112 +++++++++++++
 util/filter.h |   48 ++++++
 3 files changed, 370 insertions(+), 286 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 8bb99206e929..af1c0246cbcb 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -53,14 +53,7 @@ static unsigned long listopts_to_flags(void)
 	return flags;
 }
 
-static struct {
-	const char *bus;
-	const char *region;
-	const char *type;
-	const char *dimm;
-	const char *mode;
-	const char *namespace;
-} param;
+struct util_filter_params param;
 
 static int did_fail;
 static int jflag = JSON_C_TO_STRING_PRETTY;
@@ -72,82 +65,6 @@ do { \
 			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
 } while (0)
 
-static enum ndctl_namespace_mode mode_to_type(const char *mode)
-{
-	if (!mode)
-		return -ENXIO;
-
-	if (strcasecmp(param.mode, "memory") == 0)
-		return NDCTL_NS_MODE_MEMORY;
-	else if (strcasecmp(param.mode, "fsdax") == 0)
-		return NDCTL_NS_MODE_MEMORY;
-	else if (strcasecmp(param.mode, "sector") == 0)
-		return NDCTL_NS_MODE_SAFE;
-	else if (strcasecmp(param.mode, "safe") == 0)
-		return NDCTL_NS_MODE_SAFE;
-	else if (strcasecmp(param.mode, "dax") == 0)
-		return NDCTL_NS_MODE_DAX;
-	else if (strcasecmp(param.mode, "devdax") == 0)
-		return NDCTL_NS_MODE_DAX;
-	else if (strcasecmp(param.mode, "raw") == 0)
-		return NDCTL_NS_MODE_RAW;
-
-	return NDCTL_NS_MODE_UNKNOWN;
-}
-
-static struct json_object *list_namespaces(struct ndctl_region *region,
-		struct json_object *container, struct json_object *jnamespaces,
-		bool continue_array)
-{
-	struct ndctl_namespace *ndns;
-
-	ndctl_namespace_foreach(region, ndns) {
-		enum ndctl_namespace_mode mode = ndctl_namespace_get_mode(ndns);
-		struct json_object *jndns;
-
-		/* are we emitting namespaces? */
-		if (!list.namespaces)
-			break;
-
-		if (!util_namespace_filter(ndns, param.namespace))
-			continue;
-
-		if (param.mode && mode_to_type(param.mode) != mode)
-			continue;
-
-		if (!list.idle && !ndctl_namespace_is_active(ndns))
-			continue;
-
-		if (!jnamespaces) {
-			jnamespaces = json_object_new_array();
-			if (!jnamespaces) {
-				fail("\n");
-				continue;
-			}
-
-			if (container)
-				json_object_object_add(container, "namespaces",
-						jnamespaces);
-		}
-
-		jndns = util_namespace_to_json(ndns, listopts_to_flags());
-		if (!jndns) {
-			fail("\n");
-			continue;
-		}
-
-		json_object_array_add(jnamespaces, jndns);
-	}
-
-	/*
-	 * We we are collecting namespaces anonymously across the
-	 * platform / bus
-	 */
-	if (continue_array)
-		return jnamespaces;
-	return NULL;
-}
-
 static struct json_object *region_to_json(struct ndctl_region *region,
 		unsigned long flags)
 {
@@ -249,7 +166,6 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	if ((flags & UTIL_JSON_MEDIA_ERRORS) && jbbs)
 		json_object_object_add(jregion, "badblocks", jbbs);
 
-	list_namespaces(region, jregion, NULL, false);
 	return jregion;
  err:
 	fail("\n");
@@ -257,242 +173,176 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	return NULL;
 }
 
-static int num_list_flags(void)
+static void filter_namespace(struct ndctl_namespace *ndns,
+		struct util_filter_ctx *ctx)
 {
-	return list.buses + list.dimms + list.regions + list.namespaces;
-}
-
-int cmd_list(int argc, const char **argv, void *ctx)
-{
-	const struct option options[] = {
-		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
-		OPT_STRING('r', "region", &param.region, "region-id",
-				"filter by region"),
-		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
-				"filter by dimm"),
-		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
-				"filter by namespace id"),
-		OPT_STRING('m', "mode", &param.mode, "namespace-mode",
-				"filter by namespace mode"),
-		OPT_STRING('t', "type", &param.type, "region-type",
-				"filter by region-type"),
-		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
-		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
-		OPT_BOOLEAN('F', "firmware", &list.firmware, "include firmware info"),
-		OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
-		OPT_BOOLEAN('R', "regions", &list.regions,
-				"include region info"),
-		OPT_BOOLEAN('N', "namespaces", &list.namespaces,
-				"include namespace info (default)"),
-		OPT_BOOLEAN('X', "device-dax", &list.dax,
-				"include device-dax info"),
-		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
-		OPT_BOOLEAN('M', "media-errors", &list.media_errors,
-				"include media errors"),
-		OPT_BOOLEAN('u', "human", &list.human,
-				"use human friendly number formats "),
-		OPT_END(),
-	};
-	const char * const u[] = {
-		"ndctl list [<options>]",
-		NULL
-	};
-	struct json_object *jnamespaces = NULL;
-	struct json_object *jregions = NULL;
-	struct json_object *jdimms = NULL;
-	struct json_object *jbuses = NULL;
-	struct ndctl_bus *bus;
-	unsigned int type = 0;
-	int i;
+	struct json_object *jndns;
+	struct list_filter_arg *lfa = ctx->list;
+	struct json_object *container = lfa->jregion ? lfa->jregion : lfa->jbus;
 
-        argc = parse_options(argc, argv, options, u, 0);
-	for (i = 0; i < argc; i++)
-		error("unknown parameter \"%s\"\n", argv[i]);
-	if (param.type && (strcmp(param.type, "pmem") != 0
-				&& strcmp(param.type, "blk") != 0)) {
-		error("unknown type \"%s\" must be \"pmem\" or \"blk\"\n",
-				param.type);
-		argc++;
-	}
+	if (!list.idle && !ndctl_namespace_is_active(ndns))
+		return;
 
-	if (argc)
-		usage_with_options(u, options);
+	if (!lfa->jnamespaces) {
+		lfa->jnamespaces = json_object_new_array();
+		if (!lfa->jnamespaces) {
+			fail("\n");
+			return;
+		}
 
-	if (num_list_flags() == 0) {
-		list.buses = !!param.bus;
-		list.regions = !!param.region;
-		list.dimms = !!param.dimm;
-		if (list.dax && !param.mode)
-			param.mode = "dax";
+		if (container)
+			json_object_object_add(container, "namespaces",
+					lfa->jnamespaces);
 	}
 
-	if (num_list_flags() == 0)
-		list.namespaces = true;
-
-	if (param.type) {
-		if (strcmp(param.type, "pmem") == 0)
-			type = ND_DEVICE_REGION_PMEM;
-		else
-			type = ND_DEVICE_REGION_BLK;
+	jndns = util_namespace_to_json(ndns, lfa->flags);
+	if (!jndns) {
+		fail("\n");
+		return;
 	}
 
-	if (mode_to_type(param.mode) == NDCTL_NS_MODE_UNKNOWN) {
-		error("invalid mode: '%s'\n", param.mode);
-		return -EINVAL;
-	}
+	json_object_array_add(lfa->jnamespaces, jndns);
+}
 
-	ndctl_bus_foreach(ctx, bus) {
-		struct json_object *jbus = NULL;
-		struct ndctl_region *region;
-		struct ndctl_dimm *dimm;
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	struct list_filter_arg *lfa = ctx->list;
+	struct json_object *jbus = lfa->jbus;
+	struct json_object *jregion;
 
-		if (!util_bus_filter(bus, param.bus)
-				|| !util_bus_filter_by_dimm(bus, param.dimm)
-				|| !util_bus_filter_by_region(bus, param.region)
-				|| !util_bus_filter_by_namespace(bus, param.namespace))
-			continue;
+	if (!list.regions)
+		return true;
 
-		if (list.buses) {
-			if (!jbuses) {
-				jbuses = json_object_new_array();
-				if (!jbuses) {
-					fail("\n");
-					continue;
-				}
-			}
+	if (!list.idle && !ndctl_region_is_enabled(region))
+		return true;
 
-			jbus = util_bus_to_json(bus);
-			if (!jbus) {
-				fail("\n");
-				continue;
-			}
-			json_object_array_add(jbuses, jbus);
+	if (!lfa->jregions) {
+		lfa->jregions = json_object_new_array();
+		if (!lfa->jregions) {
+			fail("\n");
+			return false;
 		}
 
-		ndctl_dimm_foreach(bus, dimm) {
-			struct json_object *jdimm;
-
-			/* are we emitting dimms? */
-			if (!list.dimms)
-				break;
+		if (jbus)
+			json_object_object_add(jbus, "regions",
+					lfa->jregions);
+	}
 
-			if (!util_dimm_filter(dimm, param.dimm)
-					|| !util_dimm_filter_by_region(dimm,
-						param.region)
-					|| !util_dimm_filter_by_namespace(dimm,
-						param.namespace))
-				continue;
+	jregion = region_to_json(region, lfa->flags);
+	if (!jregion) {
+		fail("\n");
+		return false;
+	}
+	lfa->jregion = jregion;
 
-			if (!list.idle && !ndctl_dimm_is_enabled(dimm))
-				continue;
+	/*
+	 * Without a bus we are collecting regions anonymously across
+	 * the platform.
+	 */
+	json_object_array_add(lfa->jregions, jregion);
+	return true;
+}
 
-			if (!jdimms) {
-				jdimms = json_object_new_array();
-				if (!jdimms) {
-					fail("\n");
-					continue;
-				}
+static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx)
+{
+	struct list_filter_arg *lfa = ctx->list;
+	struct json_object *jdimm;
 
-				if (jbus)
-					json_object_object_add(jbus, "dimms", jdimms);
-			}
+	if (!list.idle && !ndctl_dimm_is_enabled(dimm))
+		return;
 
-			jdimm = util_dimm_to_json(dimm, listopts_to_flags());
-			if (!jdimm) {
-				fail("\n");
-				continue;
-			}
+	if (!lfa->jdimms) {
+		lfa->jdimms = json_object_new_array();
+		if (!lfa->jdimms) {
+			fail("\n");
+			return;
+		}
 
-			if (list.health) {
-				struct json_object *jhealth;
-
-				jhealth = util_dimm_health_to_json(dimm);
-				if (jhealth)
-					json_object_object_add(jdimm, "health",
-							jhealth);
-				else if (ndctl_dimm_is_cmd_supported(dimm,
-							ND_CMD_SMART)) {
-					/*
-					 * Failed to retrieve health data from
-					 * a dimm that otherwise supports smart
-					 * data retrieval commands.
-					 */
-					fail("\n");
-					continue;
-				}
-			}
+		if (lfa->jbus)
+			json_object_object_add(lfa->jbus, "dimms", lfa->jdimms);
+	}
 
-			if (list.firmware) {
-				struct json_object *jfirmware;
+	jdimm = util_dimm_to_json(dimm, lfa->flags);
+	if (!jdimm) {
+		fail("\n");
+		return;
+	}
 
-				jfirmware = util_dimm_firmware_to_json(dimm,
-						listopts_to_flags());
-				if (jfirmware)
-					json_object_object_add(jdimm,
-							"firmware",
-							jfirmware);
-			}
+	if (list.health) {
+		struct json_object *jhealth;
 
+		jhealth = util_dimm_health_to_json(dimm);
+		if (jhealth)
+			json_object_object_add(jdimm, "health", jhealth);
+		else if (ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART)) {
 			/*
-			 * Without a bus we are collecting dimms anonymously
-			 * across the platform.
+			 * Failed to retrieve health data from a dimm
+			 * that otherwise supports smart data retrieval
+			 * commands.
 			 */
-			json_object_array_add(jdimms, jdimm);
+			fail("\n");
+			return;
 		}
+	}
 
-		ndctl_region_foreach(bus, region) {
-			struct json_object *jregion;
-
-			if (!util_region_filter(region, param.region)
-					|| !util_region_filter_by_dimm(region,
-						param.dimm)
-					|| !util_region_filter_by_namespace(region,
-						param.namespace))
-				continue;
-
-			if (type && ndctl_region_get_type(region) != type)
-				continue;
+	if (list.firmware) {
+		struct json_object *jfirmware;
 
-			if (!list.regions) {
-				jnamespaces = list_namespaces(region, jbus,
-						jnamespaces, true);
-				continue;
-			}
+		jfirmware = util_dimm_firmware_to_json(dimm, lfa->flags);
+		if (jfirmware)
+			json_object_object_add(jdimm, "firmware", jfirmware);
+	}
 
-			if (!list.idle && !ndctl_region_is_enabled(region))
-				continue;
+	/*
+	 * Without a bus we are collecting dimms anonymously across the
+	 * platform.
+	 */
+	json_object_array_add(lfa->jdimms, jdimm);
+}
 
-			if (!jregions) {
-				jregions = json_object_new_array();
-				if (!jregions) {
-					fail("\n");
-					continue;
-				}
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	struct list_filter_arg *lfa = ctx->list;
 
-				if (jbus)
-					json_object_object_add(jbus, "regions",
-							jregions);
-			}
+	/*
+	 * These sub-objects are local to a bus and, if present, have
+	 * been added as a child of a parent object on the last
+	 * iteration.
+	 */
+	if (lfa->jbuses) {
+		lfa->jdimms = NULL;
+		lfa->jregion = NULL;
+		lfa->jregions = NULL;
+		lfa->jnamespaces = NULL;
+	}
 
-			jregion = region_to_json(region, listopts_to_flags());
-			if (!jregion) {
-				fail("\n");
-				continue;
-			}
+	if (!list.buses)
+		return true;
 
-			/*
-			 * Without a bus we are collecting regions anonymously
-			 * across the platform.
-			 */
-			json_object_array_add(jregions, jregion);
+	if (!lfa->jbuses) {
+		lfa->jbuses = json_object_new_array();
+		if (!lfa->jbuses) {
+			fail("\n");
+			return false;
 		}
+	}
 
-		if (jbuses) {
-			jdimms = NULL;
-			jregions = NULL;
-			jnamespaces = NULL;
-		}
+	lfa->jbus = util_bus_to_json(bus);
+	if (!lfa->jbus) {
+		fail("\n");
+		return false;
 	}
+	json_object_array_add(lfa->jbuses, lfa->jbus);
+	return true;
+}
+
+static int list_display(struct list_filter_arg *lfa)
+{
+	struct json_object *jnamespaces = lfa->jnamespaces;
+	struct json_object *jregions = lfa->jregions;
+	struct json_object *jdimms = lfa->jdimms;
+	struct json_object *jbuses = lfa->jbuses;
 
 	if (jbuses)
 		util_display_json_array(stdout, jbuses, jflag);
@@ -520,8 +370,82 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		util_display_json_array(stdout, jregions, jflag);
 	else if (jnamespaces)
 		util_display_json_array(stdout, jnamespaces, jflag);
+	return 0;
+}
+
+static int num_list_flags(void)
+{
+	return list.buses + list.dimms + list.regions + list.namespaces;
+}
+
+int cmd_list(int argc, const char **argv, void *ctx)
+{
+	const struct option options[] = {
+		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
+		OPT_STRING('r', "region", &param.region, "region-id",
+				"filter by region"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
+		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
+				"filter by namespace id"),
+		OPT_STRING('m', "mode", &param.mode, "namespace-mode",
+				"filter by namespace mode"),
+		OPT_STRING('t', "type", &param.type, "region-type",
+				"filter by region-type"),
+		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
+		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
+		OPT_BOOLEAN('F', "firmware", &list.firmware, "include firmware info"),
+		OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
+		OPT_BOOLEAN('R', "regions", &list.regions,
+				"include region info"),
+		OPT_BOOLEAN('N', "namespaces", &list.namespaces,
+				"include namespace info (default)"),
+		OPT_BOOLEAN('X', "device-dax", &list.dax,
+				"include device-dax info"),
+		OPT_BOOLEAN('i', "idle", &list.idle, "include idle devices"),
+		OPT_BOOLEAN('M', "media-errors", &list.media_errors,
+				"include media errors"),
+		OPT_BOOLEAN('u', "human", &list.human,
+				"use human friendly number formats "),
+		OPT_END(),
+	};
+	const char * const u[] = {
+		"ndctl list [<options>]",
+		NULL
+	};
+	struct util_filter_ctx fctx = { 0 };
+	struct list_filter_arg lfa = { 0 };
+	int i, rc;
+
+        argc = parse_options(argc, argv, options, u, 0);
+	for (i = 0; i < argc; i++)
+		error("unknown parameter \"%s\"\n", argv[i]);
+	if (argc)
+		usage_with_options(u, options);
+
+	if (num_list_flags() == 0) {
+		list.buses = !!param.bus;
+		list.regions = !!param.region;
+		list.dimms = !!param.dimm;
+		if (list.dax && !param.mode)
+			param.mode = "dax";
+	}
+
+	if (num_list_flags() == 0)
+		list.namespaces = true;
+
+	fctx.filter_bus = filter_bus;
+	fctx.filter_dimm = list.dimms ? filter_dimm : NULL;
+	fctx.filter_region = filter_region;
+	fctx.filter_namespace = list.namespaces ? filter_namespace : NULL;
+	fctx.list = &lfa;
+	lfa.flags = listopts_to_flags();
+
+	rc = util_filter_walk(ctx, &fctx, &param);
+	if (rc)
+		return rc;
 
-	if (did_fail)
+	if (list_display(&lfa) || did_fail)
 		return -ENOMEM;
 	return 0;
 }
diff --git a/util/filter.c b/util/filter.c
index acc006cd1d41..b0b7fdf149df 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -14,6 +14,8 @@
 #include <string.h>
 #include <stdlib.h>
 #include <limits.h>
+#include <util/util.h>
+#include <ndctl/ndctl.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
@@ -254,3 +256,113 @@ struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
 
 	return NULL;
 }
+
+static enum ndctl_namespace_mode mode_to_type(const char *mode)
+{
+	if (!mode)
+		return -ENXIO;
+
+	if (strcasecmp(mode, "memory") == 0)
+		return NDCTL_NS_MODE_MEMORY;
+	else if (strcasecmp(mode, "fsdax") == 0)
+		return NDCTL_NS_MODE_MEMORY;
+	else if (strcasecmp(mode, "sector") == 0)
+		return NDCTL_NS_MODE_SAFE;
+	else if (strcasecmp(mode, "safe") == 0)
+		return NDCTL_NS_MODE_SAFE;
+	else if (strcasecmp(mode, "dax") == 0)
+		return NDCTL_NS_MODE_DAX;
+	else if (strcasecmp(mode, "devdax") == 0)
+		return NDCTL_NS_MODE_DAX;
+	else if (strcasecmp(mode, "raw") == 0)
+		return NDCTL_NS_MODE_RAW;
+
+	return NDCTL_NS_MODE_UNKNOWN;
+}
+
+int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
+		struct util_filter_params *param)
+{
+	struct ndctl_bus *bus;
+	unsigned int type = 0;
+
+	if (param->type && (strcmp(param->type, "pmem") != 0
+				&& strcmp(param->type, "blk") != 0)) {
+		error("unknown type \"%s\" must be \"pmem\" or \"blk\"\n",
+				param->type);
+		return -EINVAL;
+	}
+
+	if (param->type) {
+		if (strcmp(param->type, "pmem") == 0)
+			type = ND_DEVICE_REGION_PMEM;
+		else
+			type = ND_DEVICE_REGION_BLK;
+	}
+
+	if (mode_to_type(param->mode) == NDCTL_NS_MODE_UNKNOWN) {
+		error("invalid mode: '%s'\n", param->mode);
+		return -EINVAL;
+	}
+
+	ndctl_bus_foreach(ctx, bus) {
+		struct ndctl_region *region;
+		struct ndctl_dimm *dimm;
+
+		if (!util_bus_filter(bus, param->bus)
+				|| !util_bus_filter_by_dimm(bus, param->dimm)
+				|| !util_bus_filter_by_region(bus, param->region)
+				|| !util_bus_filter_by_namespace(bus, param->namespace))
+			continue;
+
+		if (!fctx->filter_bus(bus, fctx))
+			continue;
+
+		ndctl_dimm_foreach(bus, dimm) {
+			if (!fctx->filter_dimm)
+				break;
+
+			if (!util_dimm_filter(dimm, param->dimm)
+					|| !util_dimm_filter_by_region(dimm,
+						param->region)
+					|| !util_dimm_filter_by_namespace(dimm,
+						param->namespace))
+				continue;
+
+			fctx->filter_dimm(dimm, fctx);
+		}
+
+		ndctl_region_foreach(bus, region) {
+			struct ndctl_namespace *ndns;
+
+			if (!util_region_filter(region, param->region)
+					|| !util_region_filter_by_dimm(region,
+						param->dimm)
+					|| !util_region_filter_by_namespace(region,
+						param->namespace))
+				continue;
+
+			if (type && ndctl_region_get_type(region) != type)
+				continue;
+
+			if (!fctx->filter_region(region, fctx))
+				continue;
+
+			ndctl_namespace_foreach(region, ndns) {
+				enum ndctl_namespace_mode mode;
+
+				if (!fctx->filter_namespace)
+					break;
+				if (!util_namespace_filter(ndns, param->namespace))
+					continue;
+
+				mode = ndctl_namespace_get_mode(ndns);
+				if (param->mode && mode_to_type(param->mode) != mode)
+					continue;
+
+				fctx->filter_namespace(ndns, fctx);
+			}
+		}
+	}
+	return 0;
+}
diff --git a/util/filter.h b/util/filter.h
index aa0098d2c099..aea5a71e472c 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -12,6 +12,8 @@
  */
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
+#include <stdbool.h>
+
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
 		const char *ident);
@@ -34,4 +36,50 @@ struct ndctl_region *util_region_filter_by_namespace(struct ndctl_region *region
 		const char *ident);
 struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
 		const char *ident);
+
+struct json_object;
+
+/* json object hierarchy for the util_filter_walk() performed by cmd_list() */
+struct list_filter_arg {
+	struct json_object *jnamespaces;
+	struct json_object *jregions;
+	struct json_object *jdimms;
+	struct json_object *jbuses;
+	struct json_object *jregion;
+	struct json_object *jbus;
+	unsigned long flags;
+};
+
+/*
+ * struct util_filter_ctx - control and callbacks for util_filter_walk()
+ * ->filter_bus() and ->filter_region() return bool because the
+ * child-object filter routines can not be called if the parent context
+ * is not established. ->filter_dimm() and ->filter_namespace() are leaf
+ * objects, so no child dependencies to check.
+ */
+struct util_filter_ctx {
+	bool (*filter_bus)(struct ndctl_bus *bus, struct util_filter_ctx *ctx);
+	void (*filter_dimm)(struct ndctl_dimm *dimm, struct util_filter_ctx *ctx);
+	bool (*filter_region)(struct ndctl_region *region,
+			struct util_filter_ctx *ctx);
+	void (*filter_namespace)(struct ndctl_namespace *ndns,
+			struct util_filter_ctx *ctx);
+	union {
+		void *arg;
+		struct list_filter_arg *list;
+	};
+};
+
+struct util_filter_params {
+	const char *bus;
+	const char *region;
+	const char *type;
+	const char *dimm;
+	const char *mode;
+	const char *namespace;
+};
+
+struct ndctl_ctx;
+int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
+		struct util_filter_params *param);
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
