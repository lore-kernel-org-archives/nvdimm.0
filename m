Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C4DA203B8FF3
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 11:17:20 -0700 (PDT)
Subject: [PATCH v3 3/4] ndctl: convert region actions to use util_filter_walk()
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 26 Apr 2018 11:17:18 -0700
Message-ID: <152476663889.70161.5817620258990809275.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
References: <152476632250.70161.9698682147434730585.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

util_filter_walk() does the looping through of busses and regions. Removing
duplicate code in region ops and provide filter functions so we can
utilize util_filter_walk() and share common code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/region.c |   59 ++++++++++++++++++++++++++++++++++----------------------
 util/filter.h  |    6 ++++++
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/ndctl/region.c b/ndctl/region.c
index 9fc90808..be12a546 100644
--- a/ndctl/region.c
+++ b/ndctl/region.c
@@ -19,10 +19,7 @@
 #include <util/parse-options.h>
 #include <ndctl/libndctl.h>
 
-static struct {
-	const char *bus;
-	const char *type;
-} param;
+struct util_filter_params param;
 
 static const struct option region_options[] = {
 	OPT_STRING('b', "bus", &param.bus, "bus-id",
@@ -92,33 +89,49 @@ static int region_action(struct ndctl_region *region, enum device_action mode)
 	return 0;
 }
 
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	struct region_filter_arg *rfa = ctx->region;
+	int rc;
+
+	if (rfa->rc < 0)
+		return false;
+
+	rc = region_action(region, rfa->action);
+
+	if (rc == 0)
+		rfa->rc++;
+	else
+		rfa->rc = 0;
+
+	/* we don't need to fall through, can continue the loop */
+	return false;
+}
+
 static int do_xable_region(const char *region_arg, enum device_action mode,
 		struct ndctl_ctx *ctx)
 {
-	int rc = -ENXIO, success = 0;
-	struct ndctl_region *region;
-	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+	struct util_filter_ctx fctx = { 0 };
+	struct region_filter_arg rfa = { 0 };
 
 	if (!region_arg)
 		goto out;
 
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, param.bus))
-			continue;
-
-		ndctl_region_foreach(bus, region) {
-			const char *type = ndctl_region_get_type_name(region);
-
-			if (param.type && strcmp(param.type, type) != 0)
-				continue;
-			if (!util_region_filter(region, region_arg))
-				continue;
-			if (region_action(region, mode) == 0)
-				success++;
-		}
-	}
+	fctx.filter_bus = filter_bus;
+	fctx.filter_region = filter_region;
+	fctx.region = &rfa;
+	fctx.region->action = mode;
+	rc = util_filter_walk(ctx, &fctx, &param);
+	if (rc == 0)
+		rc = fctx.region->rc;
 
-	rc = success;
  out:
 	param.bus = NULL;
 	return rc;
diff --git a/util/filter.h b/util/filter.h
index ce3336a5..6c14a303 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -57,6 +57,11 @@ struct ndns_filter_arg {
 	int rc;
 };
 
+struct region_filter_arg {
+	enum device_action action;
+	int rc;
+};
+
 /*
  * struct util_filter_ctx - control and callbacks for util_filter_walk()
  * ->filter_bus() and ->filter_region() return bool because the
@@ -75,6 +80,7 @@ struct util_filter_ctx {
 		void *arg;
 		struct list_filter_arg *list;
 		struct ndns_filter_arg *ndns;
+		struct region_filter_arg *region;
 	};
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
