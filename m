Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id ED8AE1A1E03
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:05 -0700 (PDT)
Subject: [ndctl PATCH 4/9] ndctl, list: allow limiting namespace listing
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:49 -0700
Message-ID: <146698348937.40541.3876891950806088867.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In addition to filtering by bus, dimm, and/or region, introduce
-n/--namespace to limit the listing to the given namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |    6 ++++++
 ndctl/builtin-list.c         |    6 ++++++
 util/filter.c                |   21 +++++++++++++++++++++
 util/filter.h                |    2 ++
 4 files changed, 35 insertions(+)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 792eb8e9cadb..2e362e818bbc 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -68,6 +68,12 @@ include::xable-region-options.txt[]
 [verse]
 # ndctl list --dimm=nmem0 --namespaces
 
+-n::
+--namespace=::
+	An 'namespaceX.Y' device name, or namespace region plus id tuple
+	'X.Y'. Limit the namespace list to the single identified device
+	if present.
+
 -t::
 --type=::
 	Filter listing by region type ('pmem' or 'blk')
diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index 5c5dc5a5db5b..f7447ea1310f 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -30,6 +30,7 @@ static struct {
 	const char *region;
 	const char *type;
 	const char *dimm;
+	const char *namespace;
 } param;
 
 static int did_fail;
@@ -55,6 +56,9 @@ static struct json_object *list_namespaces(struct ndctl_region *region,
 		if (!list.namespaces)
 			break;
 
+		if (!util_namespace_filter(ndns, param.namespace))
+			continue;
+
 		if (!list.idle && !util_namespace_active(ndns))
 			continue;
 
@@ -192,6 +196,8 @@ int cmd_list(int argc, const char **argv)
 				"filter by region"),
 		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
 				"filter by dimm"),
+		OPT_STRING('n', "namespace", &param.namespace, "namespace-id",
+				"filter by namespace"),
 		OPT_STRING('t', "type", &param.type, "region-type",
 				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
diff --git a/util/filter.c b/util/filter.c
index ea0f4dd2da13..97f0dec3569c 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -1,3 +1,4 @@
+#include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
 #include <limits.h>
@@ -55,6 +56,26 @@ struct ndctl_region *util_region_filter(struct ndctl_region *region,
 	return NULL;
 }
 
+struct ndctl_namespace *util_namespace_filter(struct ndctl_namespace *ndns,
+		const char *ident)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	unsigned long region_id, ndns_id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return ndns;
+
+	if (strcmp(ident, ndctl_namespace_get_devname(ndns)) == 0)
+		return ndns;
+
+	if (sscanf(ident, "%ld.%ld", &region_id, &ndns_id) == 2
+			&& ndctl_region_get_id(region) == region_id
+			&& ndctl_namespace_get_id(ndns) == ndns_id)
+		return ndns;
+
+	return NULL;
+}
+
 struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident)
 {
 	char *end = NULL;
diff --git a/util/filter.h b/util/filter.h
index 17ce895425fb..52be4c32d5bf 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -3,6 +3,8 @@
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
 		const char *ident);
+struct ndctl_namespace *util_namespace_filter(struct ndctl_namespace *ndns,
+		const char *ident);
 struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident);
 struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
 		const char *ident);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
