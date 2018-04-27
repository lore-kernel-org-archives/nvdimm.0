Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38DF921EBD1DF
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 11:18:36 -0700 (PDT)
Subject: [PATCH v4 1/4] ndctl: convert namespace actions to use
 util_filter_params
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 27 Apr 2018 11:18:34 -0700
Message-ID: <152485311474.47995.14489426172073650323.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152485300486.47995.7487206758776476576.stgit@djiang5-desk3.ch.intel.com>
References: <152485300486.47995.7487206758776476576.stgit@djiang5-desk3.ch.intel.com>
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

In preparation of moving to using util_filter_walk, moving parts of
namespace params to util_filter_params.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index fe86d826..e61f500c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -40,14 +40,11 @@ static struct parameters {
 	bool mode_default;
 	bool align_default;
 	bool autolabel;
-	const char *bus;
 	const char *map;
-	const char *type;
 	const char *uuid;
 	const char *name;
 	const char *size;
 	const char *mode;
-	const char *region;
 	const char *reconfig;
 	const char *sector_size;
 	const char *align;
@@ -55,6 +52,8 @@ static struct parameters {
 	.autolabel = true,
 };
 
+struct util_filter_params uf_param;
+
 void builtin_xaction_namespace_reset(void)
 {
 	/*
@@ -87,9 +86,9 @@ struct parsed_parameters {
 	}})
 
 #define BASE_OPTIONS() \
-OPT_STRING('b', "bus", &param.bus, "bus-id", \
+OPT_STRING('b', "bus", &uf_param.bus, "bus-id", \
 	"limit namespace to a bus with an id or provider of <bus-id>"), \
-OPT_STRING('r', "region", &param.region, "region-id", \
+OPT_STRING('r', "region", &uf_param.region, "region-id", \
 	"limit namespace to a region with an id or name of <region-id>"), \
 OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
 
@@ -108,7 +107,7 @@ OPT_STRING('M', "map", &param.map, "memmap-location", \
 	"specify 'mem' or 'dev' for the location of the memmap"), \
 OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
 	"specify the logical sector size in bytes"), \
-OPT_STRING('t', "type", &param.type, "type", \
+OPT_STRING('t', "type", &uf_param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
 OPT_STRING('a', "align", &param.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
@@ -148,18 +147,18 @@ static int set_defaults(enum device_action mode)
 {
 	int rc = 0;
 
-	if (param.type) {
-		if (strcmp(param.type, "pmem") == 0)
+	if (uf_param.type) {
+		if (strcmp(uf_param.type, "pmem") == 0)
 			/* pass */;
-		else if (strcmp(param.type, "blk") == 0)
+		else if (strcmp(uf_param.type, "blk") == 0)
 			/* pass */;
 		else {
 			error("invalid type '%s', must be either 'pmem' or 'blk'\n",
-				param.type);
+				uf_param.type);
 			rc = -EINVAL;
 		}
 	} else if (!param.reconfig && mode == ACTION_CREATE)
-		param.type = "pmem";
+		uf_param.type = "pmem";
 
 	if (param.mode) {
 		if (strcmp(param.mode, "safe") == 0)
@@ -180,8 +179,8 @@ static int set_defaults(enum device_action mode)
 			error("invalid mode '%s'\n", param.mode);
 			rc = -EINVAL;
 		}
-	} else if (!param.reconfig && param.type) {
-		if (strcmp(param.type, "pmem") == 0)
+	} else if (!param.reconfig && uf_param.type) {
+		if (strcmp(uf_param.type, "pmem") == 0)
 			param.mode = "memory";
 		else
 			param.mode = "safe";
@@ -208,7 +207,7 @@ static int set_defaults(enum device_action mode)
 		param.map = "dev";
 
 	/* check for incompatible mode and type combinations */
-	if (param.type && param.mode && strcmp(param.type, "blk") == 0
+	if (uf_param.type && param.mode && strcmp(uf_param.type, "blk") == 0
 			&& (strcmp(param.mode, "memory") == 0
 				|| strcmp(param.mode, "dax") == 0)) {
 		error("only 'pmem' namespaces support dax operation\n");
@@ -244,7 +243,7 @@ static int set_defaults(enum device_action mode)
 			error("invalid sector size: %s\n", param.sector_size);
 			rc = -EINVAL;
 		}
-	} else if (((param.type && strcmp(param.type, "blk") == 0)
+	} else if (((uf_param.type && strcmp(uf_param.type, "blk") == 0)
 			|| (param.mode && strcmp(param.mode, "safe") == 0))) {
 		/* default sector size for blk-type or safe-mode */
 		param.sector_size = "4096";
@@ -1000,19 +999,19 @@ static int do_xaction_namespace(const char *namespace,
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
         ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, param.bus))
+		if (!util_bus_filter(bus, uf_param.bus))
 			continue;
 
 		ndctl_region_foreach(bus, region) {
-			if (!util_region_filter(region, param.region))
+			if (!util_region_filter(region, uf_param.region))
 				continue;
 
-			if (param.type) {
-				if (strcmp(param.type, "pmem") == 0
+			if (uf_param.type) {
+				if (strcmp(uf_param.type, "pmem") == 0
 						&& ndctl_region_get_type(region)
 						== ND_DEVICE_REGION_PMEM)
 					/* pass */;
-				else if (strcmp(param.type, "blk") == 0
+				else if (strcmp(uf_param.type, "blk") == 0
 						&& ndctl_region_get_type(region)
 						== ND_DEVICE_REGION_BLK)
 					/* pass */;
@@ -1125,7 +1124,7 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 		 * fallback to blk before giving up.
 		 */
 		memset(&param, 0, sizeof(param));
-		param.type = "blk";
+		uf_param.type = "blk";
 		set_defaults(ACTION_CREATE);
 		created = do_xaction_namespace(NULL, ACTION_CREATE, ctx);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
