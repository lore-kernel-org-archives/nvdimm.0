Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 14F251A1F6C
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 18:08:26 -0700 (PDT)
Subject: [ndctl PATCH 5/5] ndctl, list: add 'filter by dimm' capability
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 18:07:25 -0700
Message-ID: <20160407010725.30641.58180.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
References: <20160407010659.30641.26139.stgit@dwillia2-desk3.jf.intel.com>
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

This is to support scenarios where the user is searching for information
relative to a given dimm.  For example if a dimm is faltering, this
command can show all the namespaces impacted if the dimm failed:

	ndctl list -d nmem0 -N

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |    8 ++++
 builtin-list.c               |   13 ++++++-
 util/filter.c                |   83 ++++++++++++++++++++++++++++++++++++++++++
 util/filter.h                |    5 +++
 4 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 36398aa34b42..0a23ea130a1e 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -60,6 +60,14 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
+-d::
+--dimm=::
+	An 'nmemX' device name, or dimm id number. Filter listing by
+	devices that reference the given dimm. For example to see all
+	namespaces comprised of storage capacity on nmem0:
+[verse]
+# ndctl list --dimm=nmem0 --namespaces
+
 -t::
 --type=::
 	Filter listing by region type ('pmem' or 'blk')
diff --git a/builtin-list.c b/builtin-list.c
index 8b65767c37be..885f61297a3c 100644
--- a/builtin-list.c
+++ b/builtin-list.c
@@ -29,6 +29,7 @@ static struct {
 	const char *bus;
 	const char *region;
 	const char *type;
+	const char *dimm;
 } param;
 
 static int did_fail;
@@ -197,6 +198,8 @@ int cmd_list(int argc, const char **argv)
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
 		OPT_STRING('r', "region", &param.region, "region-id",
 				"filter by region"),
+		OPT_STRING('d', "dimm", &param.dimm, "dimm-id",
+				"filter by dimm"),
 		OPT_STRING('t', "type", &param.type, "region-type",
 				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
@@ -254,7 +257,8 @@ int cmd_list(int argc, const char **argv)
 		struct ndctl_region *region;
 		struct ndctl_dimm *dimm;
 
-		if (!util_bus_filter(bus, param.bus))
+		if (!util_bus_filter(bus, param.bus)
+				|| !util_bus_filter_by_dimm(bus, param.dimm))
 			continue;
 
 		if (list.buses) {
@@ -281,6 +285,9 @@ int cmd_list(int argc, const char **argv)
 			if (!list.dimms)
 				break;
 
+			if (!util_dimm_filter(dimm, param.dimm))
+				continue;
+
 			if (!list.idle && !ndctl_dimm_is_enabled(dimm))
 				continue;
 
@@ -320,7 +327,9 @@ int cmd_list(int argc, const char **argv)
 		ndctl_region_foreach(bus, region) {
 			struct json_object *jregion;
 
-			if (!util_region_filter(region, param.region))
+			if (!util_region_filter(region, param.region)
+					|| !util_region_filter_by_dimm(region,
+						param.dimm))
 				continue;
 
 			if (type && ndctl_region_get_type(region) != type)
diff --git a/util/filter.c b/util/filter.c
index 8c8dbf1a8887..ea0f4dd2da13 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -54,3 +54,86 @@ struct ndctl_region *util_region_filter(struct ndctl_region *region,
 
 	return NULL;
 }
+
+struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident)
+{
+	char *end = NULL;
+	const char *name;
+	unsigned long dimm_id, id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return dimm;
+
+	dimm_id = strtoul(ident, &end, 0);
+	if (end == ident || end[0])
+		dimm_id = ULONG_MAX;
+
+	name = ndctl_dimm_get_devname(dimm);
+	id = ndctl_dimm_get_id(dimm);
+
+	if (dimm_id < ULONG_MAX && dimm_id == id)
+		return dimm;
+
+	if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
+		return dimm;
+
+	return NULL;
+}
+
+struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
+		const char *ident)
+{
+	char *end = NULL;
+	const char *name;
+	struct ndctl_dimm *dimm;
+	unsigned long dimm_id, id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return bus;
+
+	dimm_id = strtoul(ident, &end, 0);
+	if (end == ident || end[0])
+		dimm_id = ULONG_MAX;
+
+	ndctl_dimm_foreach(bus, dimm) {
+		id = ndctl_dimm_get_id(dimm);
+		name = ndctl_dimm_get_devname(dimm);
+
+		if (dimm_id < ULONG_MAX && dimm_id == id)
+			return bus;
+
+		if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
+			return bus;
+	}
+
+	return NULL;
+}
+
+struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
+		const char *ident)
+{
+	char *end = NULL;
+	const char *name;
+	struct ndctl_dimm *dimm;
+	unsigned long dimm_id, id;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return region;
+
+	dimm_id = strtoul(ident, &end, 0);
+	if (end == ident || end[0])
+		dimm_id = ULONG_MAX;
+
+	ndctl_dimm_foreach_in_region(region, dimm) {
+		id = ndctl_dimm_get_id(dimm);
+		name = ndctl_dimm_get_devname(dimm);
+
+		if (dimm_id < ULONG_MAX && dimm_id == id)
+			return region;
+
+		if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
+			return region;
+	}
+
+	return NULL;
+}
diff --git a/util/filter.h b/util/filter.h
index bc5c2557a65c..17ce895425fb 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -3,4 +3,9 @@
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
 		const char *ident);
+struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident);
+struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
+		const char *ident);
+struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
+		const char *ident);
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
