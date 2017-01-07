Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E8B1681A58
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:44 -0800 (PST)
Subject: [ndctl PATCH 6/7] ndctl, {enable,disable}-region: filter by type
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:38 -0800
Message-ID: <148375335820.38836.1562013725964258644.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Allow the region to be selected by type. For example, disable all pmem:

	ndctl disable-region -t pmem all

One case this is useful for is scripting the bring-up of individual
namespaces rather than the default of all at once and in parallel. For
example:

* blacklist the nd_pmem module
* disable all pmem regions
* load the nd_pmem module
* individually enable pmem regions

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xable-region.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/ndctl/builtin-xable-region.c b/ndctl/builtin-xable-region.c
index 50cbdef5b339..0d46192fe6a4 100644
--- a/ndctl/builtin-xable-region.c
+++ b/ndctl/builtin-xable-region.c
@@ -6,11 +6,16 @@
 #include <util/parse-options.h>
 #include <ndctl/libndctl.h>
 
-static const char *region_bus;
+static struct {
+	const char *bus;
+	const char *type;
+} param;
 
 static const struct option region_options[] = {
-	OPT_STRING('b', "bus", &region_bus, "bus-id",
+	OPT_STRING('b', "bus", &param.bus, "bus-id",
 			"<region> must be on a bus with an id/provider of <bus-id>"),
+	OPT_STRING('t', "type", &param.type, "region-type",
+			"<region> must be of the specified type"),
 	OPT_END(),
 };
 
@@ -33,6 +38,20 @@ static const char *parse_region_options(int argc, const char **argv,
 		usage_with_options(u, region_options);
 		return NULL; /* we won't return from usage_with_options() */
 	}
+
+	if (param.type) {
+		if (strcmp(param.type, "pmem") == 0)
+			/* pass */;
+		else if (strcmp(param.type, "blk") == 0)
+			/* pass */;
+		else {
+			error("unknown region type '%s', should be 'pmem' or 'blk'\n",
+					param.type);
+			usage_with_options(u, region_options);
+			return NULL;
+		}
+	}
+
 	return argv[0];
 }
 
@@ -47,10 +66,14 @@ static int do_xable_region(const char *region_arg,
 		goto out;
 
         ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, region_bus))
+		if (!util_bus_filter(bus, param.bus))
 			continue;
 
 		ndctl_region_foreach(bus, region) {
+			const char *type = ndctl_region_get_type_name(region);
+
+			if (param.type && strcmp(param.type, type) != 0)
+				continue;
 			if (!util_region_filter(region, region_arg))
 				continue;
 			if (xable_fn(region) == 0)
@@ -60,7 +83,7 @@ static int do_xable_region(const char *region_arg,
 
 	rc = success;
  out:
-	region_bus = NULL;
+	param.bus = NULL;
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
