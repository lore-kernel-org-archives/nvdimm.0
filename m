Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D065D2095DE48
 for <linux-nvdimm@lists.01.org>; Sat, 12 Aug 2017 12:29:08 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl, util: cleanup filter-by-dimm helpers
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 12 Aug 2017 12:25:06 -0700
Message-ID: <150256590603.13073.16819489053604962816.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Use util_dimm_filter() as a helper for these 'filter_by' routines.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/filter.c |   37 ++++---------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/util/filter.c b/util/filter.c
index 93d56928a3dc..400c11a3a80a 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -119,57 +119,28 @@ struct ndctl_dimm *util_dimm_filter(struct ndctl_dimm *dimm, const char *ident)
 struct ndctl_bus *util_bus_filter_by_dimm(struct ndctl_bus *bus,
 		const char *ident)
 {
-	char *end = NULL;
-	const char *name;
 	struct ndctl_dimm *dimm;
-	unsigned long dimm_id, id;
 
 	if (!ident || strcmp(ident, "all") == 0)
 		return bus;
 
-	dimm_id = strtoul(ident, &end, 0);
-	if (end == ident || end[0])
-		dimm_id = ULONG_MAX;
-
-	ndctl_dimm_foreach(bus, dimm) {
-		id = ndctl_dimm_get_id(dimm);
-		name = ndctl_dimm_get_devname(dimm);
-
-		if (dimm_id < ULONG_MAX && dimm_id == id)
+	ndctl_dimm_foreach(bus, dimm)
+		if (util_dimm_filter(dimm, ident))
 			return bus;
-
-		if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
-			return bus;
-	}
-
 	return NULL;
 }
 
 struct ndctl_region *util_region_filter_by_dimm(struct ndctl_region *region,
 		const char *ident)
 {
-	char *end = NULL;
-	const char *name;
 	struct ndctl_dimm *dimm;
-	unsigned long dimm_id, id;
 
 	if (!ident || strcmp(ident, "all") == 0)
 		return region;
 
-	dimm_id = strtoul(ident, &end, 0);
-	if (end == ident || end[0])
-		dimm_id = ULONG_MAX;
-
-	ndctl_dimm_foreach_in_region(region, dimm) {
-		id = ndctl_dimm_get_id(dimm);
-		name = ndctl_dimm_get_devname(dimm);
-
-		if (dimm_id < ULONG_MAX && dimm_id == id)
-			return region;
-
-		if (dimm_id == ULONG_MAX && strcmp(ident, name) == 0)
+	ndctl_dimm_foreach_in_region(region, dimm)
+		if (util_dimm_filter(dimm, ident))
 			return region;
-	}
 
 	return NULL;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
