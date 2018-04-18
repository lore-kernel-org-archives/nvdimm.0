Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E716220E8CB6
 for <linux-nvdimm@lists.01.org>; Tue, 17 Apr 2018 23:34:22 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 41421AC02D2
 for <linux-nvdimm@lists.01.org>;
 Wed, 18 Apr 2018 15:34:11 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v2] ndctl,
 filter: refacor util_<obj>_filter() to support multiple
 space-seperated arguments
Date: Wed, 18 Apr 2018 15:32:42 +0900
Message-Id: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
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

This patch refactors util_<obj>_filter to support multiple space-seperated
arguments. Currently, only one <object> can be filtered by <object>'s name
in util_<obj>_filter(). As a result, when users want to moniotr multiple
dimms, they have to run multiple monitor processes. This feature teachs the
util_dimm_filter() that the "ident" argument maybe a space-seperatd string
which includes multiple dimm_names. Therefore the monitor can filter
multiple dimms in one process.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Change log since v1:
  - Removing OPT_STRING_LIST from parse-option

---
 util/filter.c | 141 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 92 insertions(+), 49 deletions(-)

diff --git a/util/filter.c b/util/filter.c
index 6ab391a..0d3cc02 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -25,101 +25,144 @@
 
 #define NUMA_NO_NODE    (-1)
 
-struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident)
+struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *__ident)
 {
-	char *end = NULL;
+	char *end = NULL, *ident, *save;
 	unsigned long bus_id, id;
-	const char *provider, *devname;
+	const char *provider, *devname, *name;
 
-	if (!ident || strcmp(ident, "all") == 0)
+	if (!__ident || strcmp(__ident, "all") == 0)
 		return bus;
 
-	bus_id = strtoul(ident, &end, 0);
-	if (end == ident || end[0])
-		bus_id = ULONG_MAX;
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
 
-	provider = ndctl_bus_get_provider(bus);
-	devname = ndctl_bus_get_devname(bus);
-	id = ndctl_bus_get_id(bus);
+	for (name = strtok_r(ident, " ", &save); name;
+			name = strtok_r(NULL, " ", &save)) {
+		bus_id = strtoul(ident, &end, 0);
+		if (end == ident || end[0])
+			bus_id = ULONG_MAX;
 
-	if (bus_id < ULONG_MAX && bus_id == id)
-		return bus;
+		provider = ndctl_bus_get_provider(bus);
+		devname = ndctl_bus_get_devname(bus);
+		id = ndctl_bus_get_id(bus);
 
-	if (bus_id == ULONG_MAX && (strcmp(ident, provider) == 0
-				|| strcmp(ident, devname) == 0))
-		return bus;
+		if (bus_id < ULONG_MAX && bus_id == id)
+			break;
 
+		if (bus_id == ULONG_MAX && (strcmp(provider, name) == 0
+				|| strcmp(devname, name) == 0))
+			break;
+	}
+	free(ident);
+
+	if (name)
+		return bus;
 	return NULL;
 }
 
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
-		const char *ident)
+		const char *__ident)
 {
-	char *end = NULL;
-	const char *name;
+	char *end = NULL, *ident, *save;
+	const char *name, *region_name;
 	unsigned long region_id, id;
 
-	if (!ident || strcmp(ident, "all") == 0)
+	if (!__ident || strcmp(__ident, "all") == 0)
 		return region;
 
-	region_id = strtoul(ident, &end, 0);
-	if (end == ident || end[0])
-		region_id = ULONG_MAX;
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
 
-	name = ndctl_region_get_devname(region);
-	id = ndctl_region_get_id(region);
+	for (name = strtok_r(ident, " ", &save); name;
+			name = strtok_r(NULL, " ", &save)) {
+		region_id = strtoul(ident, &end, 0);
+		if (end == ident || end[0])
+			region_id = ULONG_MAX;
 
-	if (region_id < ULONG_MAX && region_id == id)
-		return region;
+		region_name = ndctl_region_get_devname(region);
+		id = ndctl_region_get_id(region);
 
-	if (region_id == ULONG_MAX && strcmp(ident, name) == 0)
-		return region;
+		if (region_id < ULONG_MAX && region_id == id)
+			break;
+
+		if (region_id == ULONG_MAX && strcmp(region_name, name) == 0)
+			break;
+	}
+	free(ident);
 
+	if (name)
+		return region;
 	return NULL;
 }
 
 struct ndctl_namespace *util_namespace_filter(struct ndctl_namespace *ndns,
-		const char *ident)
+		const char *__ident)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
 	unsigned long region_id, ndns_id;
+	const char *name;
+	char *ident, *save;
 
-	if (!ident || strcmp(ident, "all") == 0)
+	if (!__ident || strcmp(__ident, "all") == 0)
 		return ndns;
 
-	if (strcmp(ident, ndctl_namespace_get_devname(ndns)) == 0)
-		return ndns;
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
 
-	if (sscanf(ident, "%ld.%ld", &region_id, &ndns_id) == 2
-			&& ndctl_region_get_id(region) == region_id
-			&& ndctl_namespace_get_id(ndns) == ndns_id)
-		return ndns;
+	for (name = strtok_r(ident, " ", &save); name;
+			name = strtok_r(NULL, " ", &save)) {
+		if (strcmp(name, ndctl_namespace_get_devname(ndns)) == 0)
+			break;
+
+		if (sscanf(name, "%ld.%ld", &region_id, &ndns_id) == 2
+				&& ndctl_region_get_id(region) == region_id
+				&& ndctl_namespace_get_id(ndns) == ndns_id)
+			break;
+	}
+	free(ident);
 
+	if (name)
+		return ndns;
 	return NULL;
 }
 
-struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident)
+struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm,
+		const char *__ident)
 {
-	char *end = NULL;
-	const char *name;
+	char *end = NULL, *ident, *save;
+	const char *name, *dimm_name;
 	unsigned long dimm_id, id;
 
-	if (!ident || strcmp(ident, "all") == 0)
+	if (!__ident || strcmp(__ident, "all") == 0)
 		return dimm;
 
-	dimm_id = strtoul(ident, &end, 0);
-	if (end == ident || end[0])
-		dimm_id = ULONG_MAX;
+	ident = strdup(__ident);
+	if (!ident)
+		return NULL;
 
-	name = ndctl_dimm_get_devname(dimm);
-	id = ndctl_dimm_get_id(dimm);
+	for (name = strtok_r(ident, " ", &save); name;
+			name = strtok_r(NULL, " ", &save)) {
+		dimm_id = strtoul(ident, &end, 0);
+		if (end == ident || end[0])
+			dimm_id = ULONG_MAX;
 
-	if (dimm_id < ULONG_MAX && dimm_id == id)
-		return dimm;
+		dimm_name = ndctl_dimm_get_devname(dimm);
+		id = ndctl_dimm_get_id(dimm);
 
-	if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
-		return dimm;
+		if (dimm_id < ULONG_MAX && dimm_id == id)
+			break;
+
+		if (dimm_id == ULONG_MAX && strcmp(dimm_name, name) == 0)
+			break;
+	}
+	free(ident);
 
+	if (name)
+		return dimm;
 	return NULL;
 }
 
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
