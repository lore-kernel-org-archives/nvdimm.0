Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 273C82034D8C5
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 22:55:31 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 8891FAC00D4
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 16:01:24 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH] ndctl, list: add ndctl_filter_opts for sharing filter
Date: Thu, 22 Feb 2018 16:00:34 +0900
Message-Id: <20180222070034.5160-1-qi.fuli@jp.fujitsu.com>
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

I wrote a patch for refactoring cmd_list(). It would be appreciated
if you could check it.

This patch refactors the filter in cmd_list() into ndctl_filter_opts
object with callback functions. So that the filter used for matching
a given object can be shared between "list" and "monitor".

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/list.c | 142 +++++++++++++++++++++++++++++++++++++++--------------------
 ndctl/list.h |  35 +++++++++++++++
 2 files changed, 129 insertions(+), 48 deletions(-)
 create mode 100644 ndctl/list.h

diff --git a/ndctl/list.c b/ndctl/list.c
index 37a224a..c1a095d 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -22,7 +22,7 @@
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/array_size/array_size.h>
-
+#include "list.h"
 #include <ndctl.h>
 
 static struct {
@@ -52,7 +52,7 @@ static unsigned long listopts_to_flags(void)
 	return flags;
 }
 
-static struct {
+static struct parameter {
 	const char *bus;
 	const char *region;
 	const char *type;
@@ -61,6 +61,13 @@ static struct {
 	const char *namespace;
 } param;
 
+struct ndctl_filter_opts *ndfop = &(struct ndctl_filter_opts) {
+	.match_bus = util_match_bus,
+	.match_dimm = util_match_dimm,
+	.match_region = util_match_region,
+	.match_namespace = util_match_namespace,
+};
+
 static int did_fail;
 static int jflag = JSON_C_TO_STRING_PRETTY;
 
@@ -108,15 +115,17 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 		if (!list.namespaces)
 			break;
 
-		if (!util_namespace_filter(ndns, param.namespace))
-			continue;
-
 		if (param.mode && mode_to_type(param.mode) != mode)
 			continue;
 
 		if (!list.idle && !ndctl_namespace_is_active(ndns))
 			continue;
 
+		jndns = ndfop->match_namespace(ndns, &param,
+				listopts_to_flags());
+		if(!jndns)
+			continue;
+
 		if (!jnamespaces) {
 			jnamespaces = json_object_new_array();
 			if (!jnamespaces) {
@@ -129,12 +138,6 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 						jnamespaces);
 		}
 
-		jndns = util_namespace_to_json(ndns, listopts_to_flags());
-		if (!jndns) {
-			fail("\n");
-			continue;
-		}
-
 		json_object_array_add(jnamespaces, jndns);
 	}
 
@@ -261,6 +264,74 @@ static int num_list_flags(void)
 	return list.buses + list.dimms + list.regions + list.namespaces;
 }
 
+struct json_object *util_match_bus(struct ndctl_bus *bus, void *ctx,
+			unsigned long flags)
+{
+	struct parameter *pa = (struct parameter*)ctx;
+	struct json_object *jbus = NULL;
+	if (!util_bus_filter(bus, pa->bus)
+			|| !util_bus_filter_by_dimm(bus, pa->dimm)
+			|| !util_bus_filter_by_region(bus, pa->region)
+			|| !util_bus_filter_by_namespace(bus, pa->namespace))
+		return NULL;
+	jbus = util_bus_to_json(bus);
+	if (!jbus) {
+		fail("\n");
+		return NULL;
+	}
+	return jbus;
+}
+
+struct json_object *util_match_dimm(struct ndctl_dimm *dimm, void *ctx,
+			unsigned long flags)
+{
+	struct parameter *pa = (struct parameter*)ctx;
+	struct json_object *jdimm = NULL;
+	if (!util_dimm_filter(dimm, pa->dimm)
+			|| !util_dimm_filter_by_region(dimm, pa->region)
+			|| !util_dimm_filter_by_namespace(dimm, pa->namespace))
+		return NULL;
+	jdimm = util_dimm_to_json(dimm, flags);
+	if (!jdimm) {
+		fail("\n");
+		return NULL;
+	}
+	return jdimm;
+}
+
+struct json_object *util_match_region(struct ndctl_region *region, void *ctx,
+			unsigned long flags)
+{
+	struct parameter *pa = (struct parameter*)ctx;
+	struct json_object *jregion = NULL;
+	if (!util_region_filter(region, pa->region)
+			|| !util_region_filter_by_dimm(region, pa->dimm)
+			|| !util_region_filter_by_namespace(region,
+				pa->namespace))
+		return NULL;
+	jregion = region_to_json(region, flags);
+	if (!jregion) {
+		fail("\n");
+		return NULL;
+	}
+	return jregion;
+}
+
+struct json_object *util_match_namespace(struct ndctl_namespace *namespace,
+			void *ctx, unsigned long flags)
+{
+	struct parameter *pa = (struct parameter*)ctx;
+	struct json_object *jndns = NULL;
+	if (!util_namespace_filter(namespace, pa->namespace))
+		return NULL;
+	jndns = util_namespace_to_json(namespace, flags);
+	if (!jndns) {
+		fail("\n");
+		return NULL;
+	}
+	return jndns;
+}
+
 int cmd_list(int argc, const char **argv, void *ctx)
 {
 	const struct option options[] = {
@@ -341,15 +412,12 @@ int cmd_list(int argc, const char **argv, void *ctx)
 
 	ndctl_bus_foreach(ctx, bus) {
 		struct json_object *jbus = NULL;
+		jbus = ndfop->match_bus(bus, &param, 0);
+		if (!jbus)
+			continue;
 		struct ndctl_region *region;
 		struct ndctl_dimm *dimm;
 
-		if (!util_bus_filter(bus, param.bus)
-				|| !util_bus_filter_by_dimm(bus, param.dimm)
-				|| !util_bus_filter_by_region(bus, param.region)
-				|| !util_bus_filter_by_namespace(bus, param.namespace))
-			continue;
-
 		if (list.buses) {
 			if (!jbuses) {
 				jbuses = json_object_new_array();
@@ -358,12 +426,6 @@ int cmd_list(int argc, const char **argv, void *ctx)
 					continue;
 				}
 			}
-
-			jbus = util_bus_to_json(bus);
-			if (!jbus) {
-				fail("\n");
-				continue;
-			}
 			json_object_array_add(jbuses, jbus);
 		}
 
@@ -374,11 +436,10 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			if (!list.dimms)
 				break;
 
-			if (!util_dimm_filter(dimm, param.dimm)
-					|| !util_dimm_filter_by_region(dimm,
-						param.region)
-					|| !util_dimm_filter_by_namespace(dimm,
-						param.namespace))
+			jdimm = ndfop->match_dimm(dimm, &param,
+					listopts_to_flags());
+
+			if (!jdimm)
 				continue;
 
 			if (!list.idle && !ndctl_dimm_is_enabled(dimm))
@@ -392,13 +453,8 @@ int cmd_list(int argc, const char **argv, void *ctx)
 				}
 
 				if (jbus)
-					json_object_object_add(jbus, "dimms", jdimms);
-			}
-
-			jdimm = util_dimm_to_json(dimm, listopts_to_flags());
-			if (!jdimm) {
-				fail("\n");
-				continue;
+					json_object_object_add(jbus, "dimms",
+							jdimms);
 			}
 
 			if (list.health) {
@@ -429,12 +485,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 
 		ndctl_region_foreach(bus, region) {
 			struct json_object *jregion;
-
-			if (!util_region_filter(region, param.region)
-					|| !util_region_filter_by_dimm(region,
-						param.dimm)
-					|| !util_region_filter_by_namespace(region,
-						param.namespace))
+			jregion = ndfop->match_region(region, &param,
+					listopts_to_flags());
+			if (!jregion)
 				continue;
 
 			if (type && ndctl_region_get_type(region) != type)
@@ -460,13 +513,6 @@ int cmd_list(int argc, const char **argv, void *ctx)
 					json_object_object_add(jbus, "regions",
 							jregions);
 			}
-
-			jregion = region_to_json(region, listopts_to_flags());
-			if (!jregion) {
-				fail("\n");
-				continue;
-			}
-
 			/*
 			 * Without a bus we are collecting regions anonymously
 			 * across the platform.
diff --git a/ndctl/list.h b/ndctl/list.h
new file mode 100644
index 0000000..e24e73d
--- /dev/null
+++ b/ndctl/list.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c) 2018, FUJITSU LIMITED. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef _LIST_H_
+#define _LIST_H_
+
+struct ndctl_filter_opts {
+	struct json_object *(*match_bus)(struct ndctl_bus *bus, void *ctx,
+			unsigned long flags);
+	struct json_object *(*match_dimm)(struct ndctl_dimm *dimm, void *ctx,
+			unsigned long flags);
+	struct json_object *(*match_region)(struct ndctl_region *region,
+			void *ctx, unsigned long flags);
+	struct json_object *(*match_namespace)(struct ndctl_namespace *namespace,
+			void *ctx, unsigned long flags);
+};
+struct json_object *util_match_bus(struct ndctl_bus *bus, void *ctx,
+			unsigned long flags);
+struct json_object *util_match_dimm(struct ndctl_dimm *dimm, void *ctx,
+			unsigned long flags);
+struct json_object *util_match_region(struct ndctl_region *region, void *ctx,
+			unsigned long flags);
+struct json_object *util_match_namespace(struct ndctl_namespace *namespace,
+			void *ctx, unsigned long flags);
+#endif
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
