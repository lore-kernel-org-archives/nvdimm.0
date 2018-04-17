Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23D4A2263DD68
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 23:40:15 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 67E32AC01EE
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 15:40:12 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH 2/2] ndctl,
 list: change -b -d -r -n options to support multiple arguments
Date: Tue, 17 Apr 2018 15:38:48 +0900
Message-Id: <20180417063848.5585-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
References: <20180417063848.5585-1-qi.fuli@jp.fujitsu.com>
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

This patch changes --bus, --dimm, --region --namespace options to
OPT_STRING_LIST in order to support multiple arguments. 
Users can specify multiple dimm like following:

	ndctl list --dimm="nmem1 nmem2" --bus="ndbus0 ndbus1"
	ndctl list -d "nmem1 nmem2" -b "ndbus0 ndbus1"

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/list.c  | 35 ++++++++++++++++------
 util/filter.c | 81 ++++++++++++++++++++++++++++++++++++---------------
 util/filter.h |  9 +++---
 3 files changed, 88 insertions(+), 37 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index 6cf7c39..14da736 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -129,11 +129,23 @@ static struct json_object *region_to_json(struct ndctl_region *region,
 	ndctl_mapping_foreach(region, mapping) {
 		struct ndctl_dimm *dimm = ndctl_mapping_get_dimm(mapping);
 		struct json_object *jmapping;
+		struct string_list_node *sln;
+		bool flag = false;
 
 		if (!list.dimms)
 			break;
 
-		if (!util_dimm_filter(dimm, param.dimm))
+		if (!list_empty(&param.dimm)) {
+			list_for_each(&param.dimm, sln, list) {
+				if (util_dimm_filter(dimm, sln->str)) {
+					flag = true;
+					break;
+				}
+			}
+		} else
+			flag = true;
+
+		if (!flag)
 			continue;
 
 		if (!list.idle && !ndctl_dimm_is_enabled(dimm))
@@ -415,14 +427,19 @@ static int num_list_flags(void)
 
 int cmd_list(int argc, const char **argv, void *ctx)
 {
+	list_head_init(&param.bus);
+	list_head_init(&param.dimm);
+	list_head_init(&param.region);
+	list_head_init(&param.namespace);
 	const struct option options[] = {
-		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
-		OPT_STRING('r', "region", &param.region, "region-id",
+		OPT_STRING_LIST('b', "bus", &param.bus, "bus-id",
+				"filter by bus"),
+		OPT_STRING_LIST('r', "region", &param.region, "region-id",
 				"filter by region"),
-		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+		OPT_STRING_LIST('d', "dimm", &param.dimm, "dimm-id",
 				"filter by dimm"),
-		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
-				"filter by namespace id"),
+		OPT_STRING_LIST('n', "namespace", &param.namespace,
+				"namespace-id", "filter by namespace id"),
 		OPT_STRING('m', "mode", &param.mode, "namespace-mode",
 				"filter by namespace mode"),
 		OPT_STRING('t', "type", &param.type, "region-type",
@@ -461,9 +478,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		usage_with_options(u, options);
 
 	if (num_list_flags() == 0) {
-		list.buses = !!param.bus;
-		list.regions = !!param.region;
-		list.dimms = !!param.dimm;
+		list.buses = !list_empty(&param.bus);
+		list.regions = !list_empty(&param.region);
+		list.dimms = !list_empty(&param.dimm);
 		if (list.dax && !param.mode)
 			param.mode = "dax";
 	}
diff --git a/util/filter.c b/util/filter.c
index 6ab391a..3313f53 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -303,13 +303,47 @@ static enum ndctl_namespace_mode mode_to_type(const char *mode)
 	return NDCTL_NS_MODE_UNKNOWN;
 }
 
+#define util_field_filter_by_list(field, list_head) \
+if (!list_empty(list_head)) { \
+	list_for_each(list_head, sln, list) { \
+		if (util_##field##_filter(field, sln->str)) { \
+			flag = true; \
+			break; \
+		} \
+	} \
+} else \
+	flag = true; \
+\
+if (flag) \
+	flag = false; \
+else \
+	continue;
+
+#define util_field_filter_by_list_item(field, item, list_head) \
+if (!list_empty(list_head)) { \
+	list_for_each(list_head, sln, list) { \
+		if (util_##field##_filter_by_##item(field, sln->str)) { \
+			flag = true; \
+			break; \
+		} \
+	} \
+} else \
+	flag = true; \
+\
+if (flag) \
+	flag = false; \
+else \
+	continue;
+
 int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 		struct util_filter_params *param)
 {
 	struct ndctl_bus *bus;
+	struct string_list_node *sln;
 	unsigned int type = 0;
 	int numa_node = NUMA_NO_NODE;
 	char *end = NULL;
+	bool flag = false;
 
 	if (param->type && (strcmp(param->type, "pmem") != 0
 				&& strcmp(param->type, "blk") != 0)) {
@@ -349,11 +383,11 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 		struct ndctl_region *region;
 		struct ndctl_dimm *dimm;
 
-		if (!util_bus_filter(bus, param->bus)
-				|| !util_bus_filter_by_dimm(bus, param->dimm)
-				|| !util_bus_filter_by_region(bus, param->region)
-				|| !util_bus_filter_by_namespace(bus, param->namespace))
-			continue;
+		util_field_filter_by_list(bus, &param->bus);
+		util_field_filter_by_list_item(bus, dimm, &param->dimm);
+		util_field_filter_by_list_item(bus, region, &param->region);
+		util_field_filter_by_list_item(bus, namespace,
+					&param->namespace);
 
 		if (!fctx->filter_bus(bus, fctx))
 			continue;
@@ -362,27 +396,25 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 			if (!fctx->filter_dimm)
 				break;
 
-			if (!util_dimm_filter(dimm, param->dimm)
-					|| !util_dimm_filter_by_region(dimm,
-						param->region)
-					|| !util_dimm_filter_by_namespace(dimm,
-						param->namespace)
-					|| !util_dimm_filter_by_numa_node(dimm,
-						numa_node))
+			util_field_filter_by_list(dimm, &param->dimm);
+			util_field_filter_by_list_item(dimm, region,
+					&param->region);
+			util_field_filter_by_list_item(dimm, namespace,
+					&param->namespace);
+			if (!util_dimm_filter_by_numa_node(dimm, numa_node))
 				continue;
 
 			fctx->filter_dimm(dimm, fctx);
 		}
 
 		ndctl_region_foreach(bus, region) {
-			struct ndctl_namespace *ndns;
+			struct ndctl_namespace *namespace;
 
-			if (!util_region_filter(region, param->region)
-					|| !util_region_filter_by_dimm(region,
-						param->dimm)
-					|| !util_region_filter_by_namespace(region,
-						param->namespace))
-				continue;
+			util_field_filter_by_list(region, &param->region);
+			util_field_filter_by_list_item(region, dimm,
+					&param->dimm);
+			util_field_filter_by_list_item(region, namespace,
+					&param->namespace);
 
 			if (numa_node != NUMA_NO_NODE &&
 			    ndctl_region_get_numa_node(region) != numa_node)
@@ -394,19 +426,20 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 			if (!fctx->filter_region(region, fctx))
 				continue;
 
-			ndctl_namespace_foreach(region, ndns) {
+			ndctl_namespace_foreach(region, namespace) {
 				enum ndctl_namespace_mode mode;
 
 				if (!fctx->filter_namespace)
 					break;
-				if (!util_namespace_filter(ndns, param->namespace))
-					continue;
 
-				mode = ndctl_namespace_get_mode(ndns);
+				util_field_filter_by_list(namespace,
+						&param->namespace);
+
+				mode = ndctl_namespace_get_mode(namespace);
 				if (param->mode && mode_to_type(param->mode) != mode)
 					continue;
 
-				fctx->filter_namespace(ndns, fctx);
+				fctx->filter_namespace(namespace, fctx);
 			}
 		}
 	}
diff --git a/util/filter.h b/util/filter.h
index effda24..4b21cb3 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -13,6 +13,7 @@
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
 #include <stdbool.h>
+#include <ccan/list/list.h>
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
@@ -71,12 +72,12 @@ struct util_filter_ctx {
 };
 
 struct util_filter_params {
-	const char *bus;
-	const char *region;
+	struct list_head bus;
+	struct list_head dimm;
+	struct list_head region;
+	struct list_head namespace;
 	const char *type;
-	const char *dimm;
 	const char *mode;
-	const char *namespace;
 	const char *numa_node;
 };
 
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
