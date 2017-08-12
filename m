Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA0B221D4911E
 for <linux-nvdimm@lists.01.org>; Sat, 12 Aug 2017 12:29:13 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl,
 list: add the remaining set of 'filter_by' helpers
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 12 Aug 2017 12:25:11 -0700
Message-ID: <150256591112.13073.15791513451022118526.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150256590603.13073.16819489053604962816.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150256590603.13073.16819489053604962816.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Keith Hazelet <keith.hazelet@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

We already support filtering region and bus listings by dimm, lets
extend that to the other object types. I.e. permit buses to be filtered
by regions, dimms, and namespaces; allow regions to be filtered by
dimms, and namespaces etc...

For example, to list all the DIMMs that comprise a given namespace:
  # ndctl list --dimms --namespace=7.0
  [
    {
      "dev":"nmem1",
      "id":"cdab-0a-07e0-ffffffff",
      "handle":0,
      "phys_id":0
    },
    {
      "dev":"nmem3",
      "id":"cdab-0a-07e0-fffeffff",
      "handle":256,
      "phys_id":2
    },
    {
      "dev":"nmem2",
      "id":"cdab-0a-07e0-feffffff",
      "handle":1,
      "phys_id":1
    },
    {
      "dev":"nmem4",
      "id":"cdab-0a-07e0-fefeffff",
      "handle":257,
      "phys_id":3
    }
  ]

Reported-by: Keith Hazelet <keith.hazelet@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/list.c  |   14 +++++++--
 util/filter.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util/filter.h |   10 ++++++
 3 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/ndctl/list.c b/ndctl/list.c
index c910c776c61d..1960e9f8d7b5 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -344,7 +344,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 		struct ndctl_dimm *dimm;
 
 		if (!util_bus_filter(bus, param.bus)
-				|| !util_bus_filter_by_dimm(bus, param.dimm))
+				|| !util_bus_filter_by_dimm(bus, param.dimm)
+				|| !util_bus_filter_by_region(bus, param.region)
+				|| !util_bus_filter_by_namespace(bus, param.namespace))
 			continue;
 
 		if (list.buses) {
@@ -371,7 +373,11 @@ int cmd_list(int argc, const char **argv, void *ctx)
 			if (!list.dimms)
 				break;
 
-			if (!util_dimm_filter(dimm, param.dimm))
+			if (!util_dimm_filter(dimm, param.dimm)
+					|| !util_dimm_filter_by_region(dimm,
+						param.region)
+					|| !util_dimm_filter_by_namespace(dimm,
+						param.namespace))
 				continue;
 
 			if (!list.idle && !ndctl_dimm_is_enabled(dimm))
@@ -425,7 +431,9 @@ int cmd_list(int argc, const char **argv, void *ctx)
 
 			if (!util_region_filter(region, param.region)
 					|| !util_region_filter_by_dimm(region,
-						param.dimm))
+						param.dimm)
+					|| !util_region_filter_by_namespace(region,
+						param.namespace))
 				continue;
 
 			if (type && ndctl_region_get_type(region) != type)
diff --git a/util/filter.c b/util/filter.c
index 400c11a3a80a..acc006cd1d41 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -130,6 +130,37 @@ struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
 	return NULL;
 }
 
+struct ndctl_bus *util_bus_filter_by_region(struct ndctl_bus *bus,
+		const char *ident)
+{
+	struct ndctl_region *region;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return bus;
+
+	ndctl_region_foreach(bus, region)
+		if (util_region_filter(region, ident))
+			return bus;
+	return NULL;
+}
+
+
+struct ndctl_bus *util_bus_filter_by_namespace(struct ndctl_bus *bus,
+		const char *ident)
+{
+	struct ndctl_region *region;
+	struct ndctl_namespace *ndns;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return bus;
+
+	ndctl_region_foreach(bus, region)
+		ndctl_namespace_foreach(region, ndns)
+			if (util_namespace_filter(ndns, ident))
+				return bus;
+	return NULL;
+}
+
 struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 		const char *ident)
 {
@@ -145,6 +176,65 @@ struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 	return NULL;
 }
 
+struct ndctl_dimm *util_dimm_filter_by_region(struct ndctl_dimm *dimm,
+		const char *ident)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_region *region;
+	struct ndctl_dimm *check;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return dimm;
+
+	ndctl_region_foreach(bus, region) {
+		if (!util_region_filter(region, ident))
+			continue;
+		ndctl_dimm_foreach_in_region(region, check)
+			if (check == dimm)
+				return dimm;
+	}
+
+	return NULL;
+}
+
+struct ndctl_dimm *util_dimm_filter_by_namespace(struct ndctl_dimm *dimm,
+		const char *ident)
+{
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_namespace *ndns;
+	struct ndctl_region *region;
+	struct ndctl_dimm *check;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return dimm;
+
+	ndctl_region_foreach(bus, region) {
+		ndctl_namespace_foreach(region, ndns) {
+			if (!util_namespace_filter(ndns, ident))
+				continue;
+			ndctl_dimm_foreach_in_region(region, check)
+				if (check == dimm)
+					return dimm;
+		}
+	}
+
+	return NULL;
+}
+
+struct ndctl_region *util_region_filter_by_namespace(struct ndctl_region *region,
+		const char *ident)
+{
+	struct ndctl_namespace *ndns;
+
+	if (!ident || strcmp(ident, "all") == 0)
+		return region;
+
+	ndctl_namespace_foreach(region, ndns)
+		if (util_namespace_filter(ndns, ident))
+			return region;
+	return NULL;
+}
+
 struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
 		const char *ident)
 {
diff --git a/util/filter.h b/util/filter.h
index dcc537caaaf9..aa0098d2c099 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -20,8 +20,18 @@ struct ndctl_namespace *util_namespace_filter(struct ndctl_namespace *ndns,
 struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident);
 struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
 		const char *ident);
+struct ndctl_bus *util_bus_filter_by_region(struct ndctl_bus *bus,
+		const char *ident);
+struct ndctl_bus *util_bus_filter_by_namespace(struct ndctl_bus *bus,
+		const char *ident);
 struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 		const char *ident);
+struct ndctl_dimm *util_dimm_filter_by_region(struct ndctl_dimm *dimm,
+		const char *ident);
+struct ndctl_dimm *util_dimm_filter_by_namespace(struct ndctl_dimm *dimm,
+		const char *ident);
+struct ndctl_region *util_region_filter_by_namespace(struct ndctl_region *region,
+		const char *ident);
 struct daxctl_dev *util_daxctl_dev_filter(struct daxctl_dev *dev,
 		const char *ident);
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
