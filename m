Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6EC4220E8E13
 for <linux-nvdimm@lists.01.org>; Tue, 24 Apr 2018 14:37:33 -0700 (PDT)
Subject: [PATCH] ndctl: convert namespace ops to use util_filter_walk()
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 24 Apr 2018 14:37:32 -0700
Message-ID: <152460585223.9828.17816938916320036281.stgit@djiang5-desk3.ch.intel.com>
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
duplicate code in namespace ops and provide filter functions so we can
utilize util_filter_walk() and share common code.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/namespace.c |  281 ++++++++++++++++++++++++++++-------------------------
 util/filter.c     |   11 +-
 util/filter.h     |    8 ++
 3 files changed, 162 insertions(+), 138 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index fe86d826..9c504e7f 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -35,26 +35,24 @@ static bool verbose;
 static bool force;
 static bool repair;
 static bool logfix;
-static struct parameters {
+static struct {
 	bool do_scan;
 	bool mode_default;
 	bool align_default;
 	bool autolabel;
-	const char *bus;
 	const char *map;
-	const char *type;
 	const char *uuid;
 	const char *name;
 	const char *size;
-	const char *mode;
-	const char *region;
 	const char *reconfig;
 	const char *sector_size;
 	const char *align;
-} param = {
+} ndns_action = {
 	.autolabel = true,
 };
 
+struct util_filter_params param;
+
 void builtin_xaction_namespace_reset(void)
 {
 	/*
@@ -94,26 +92,26 @@ OPT_STRING('r', "region", &param.region, "region-id", \
 OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr")
 
 #define CREATE_OPTIONS() \
-OPT_STRING('e', "reconfig", &param.reconfig, "reconfig namespace", \
+OPT_STRING('e', "reconfig", &ndns_action.reconfig, "reconfig namespace", \
 	"reconfigure existing namespace"), \
-OPT_STRING('u', "uuid", &param.uuid, "uuid", \
+OPT_STRING('u', "uuid", &ndns_action.uuid, "uuid", \
 	"specify the uuid for the namespace (default: autogenerate)"), \
-OPT_STRING('n', "name", &param.name, "name", \
+OPT_STRING('n', "name", &ndns_action.name, "name", \
 	"specify an optional free form name for the namespace"), \
-OPT_STRING('s', "size", &param.size, "size", \
+OPT_STRING('s', "size", &ndns_action.size, "size", \
 	"specify the namespace size in bytes (default: available capacity)"), \
 OPT_STRING('m', "mode", &param.mode, "operation-mode", \
 	"specify a mode for the namespace, 'sector', 'fsdax', 'devdax' or 'raw'"), \
-OPT_STRING('M', "map", &param.map, "memmap-location", \
+OPT_STRING('M', "map", &ndns_action.map, "memmap-location", \
 	"specify 'mem' or 'dev' for the location of the memmap"), \
-OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
+OPT_STRING('l', "sector-size", &ndns_action.sector_size, "lba-size", \
 	"specify the logical sector size in bytes"), \
 OPT_STRING('t', "type", &param.type, "type", \
 	"specify the type of namespace to create 'pmem' or 'blk'"), \
-OPT_STRING('a', "align", &param.align, "align", \
+OPT_STRING('a', "align", &ndns_action.align, "align", \
 	"specify the namespace alignment in bytes (default: 2M)"), \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
-OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
+OPT_BOOLEAN('L', "autolabel", &ndns_action.autolabel, "automatically initialize labels")
 
 #define CHECK_OPTIONS() \
 OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
@@ -158,7 +156,7 @@ static int set_defaults(enum device_action mode)
 				param.type);
 			rc = -EINVAL;
 		}
-	} else if (!param.reconfig && mode == ACTION_CREATE)
+	} else if (!ndns_action.reconfig && mode == ACTION_CREATE)
 		param.type = "pmem";
 
 	if (param.mode) {
@@ -180,32 +178,32 @@ static int set_defaults(enum device_action mode)
 			error("invalid mode '%s'\n", param.mode);
 			rc = -EINVAL;
 		}
-	} else if (!param.reconfig && param.type) {
+	} else if (!ndns_action.reconfig && param.type) {
 		if (strcmp(param.type, "pmem") == 0)
 			param.mode = "memory";
 		else
 			param.mode = "safe";
-		param.mode_default = true;
+		ndns_action.mode_default = true;
 	}
 
-	if (param.map) {
-		if (strcmp(param.map, "mem") == 0)
+	if (ndns_action.map) {
+		if (strcmp(ndns_action.map, "mem") == 0)
 			/* pass */;
-		else if (strcmp(param.map, "dev") == 0)
+		else if (strcmp(ndns_action.map, "dev") == 0)
 			/* pass */;
 		else {
-			error("invalid map location '%s'\n", param.map);
+			error("invalid map location '%s'\n", ndns_action.map);
 			rc = -EINVAL;
 		}
 
-		if (!param.reconfig && param.mode
+		if (!ndns_action.reconfig && param.mode
 				&& strcmp(param.mode, "memory") != 0
 				&& strcmp(param.mode, "dax") != 0) {
 			error("--map only valid for an dax mode pmem namespace\n");
 			rc = -EINVAL;
 		}
-	} else if (!param.reconfig)
-		param.map = "dev";
+	} else if (!ndns_action.reconfig)
+		ndns_action.map = "dev";
 
 	/* check for incompatible mode and type combinations */
 	if (param.type && param.mode && strcmp(param.type, "blk") == 0
@@ -215,39 +213,43 @@ static int set_defaults(enum device_action mode)
 		rc = -ENXIO;
 	}
 
-	if (param.size && parse_size64(param.size) == ULLONG_MAX) {
+	if (ndns_action.size &&
+			parse_size64(ndns_action.size) == ULLONG_MAX) {
 		error("failed to parse namespace size '%s'\n",
-				param.size);
+				ndns_action.size);
 		rc = -EINVAL;
 	}
 
-	if (param.align && parse_size64(param.align) == ULLONG_MAX) {
+	if (ndns_action.align &&
+			parse_size64(ndns_action.align) == ULLONG_MAX) {
 		error("failed to parse namespace alignment '%s'\n",
-				param.align);
+				ndns_action.align);
 		rc = -EINVAL;
-	} else if (!param.align) {
-		param.align = "2M";
-		param.align_default = true;
+	} else if (!ndns_action.align) {
+		ndns_action.align = "2M";
+		ndns_action.align_default = true;
 	}
 
-	if (param.uuid) {
+	if (ndns_action.uuid) {
 		uuid_t uuid;
 
-		if (uuid_parse(param.uuid, uuid)) {
-			error("failed to parse uuid: '%s'\n", param.uuid);
+		if (uuid_parse(ndns_action.uuid, uuid)) {
+			error("failed to parse uuid: '%s'\n",
+					ndns_action.uuid);
 			rc = -EINVAL;
 		}
 	}
 
-	if (param.sector_size) {
-		if (parse_size64(param.sector_size) == ULLONG_MAX) {
-			error("invalid sector size: %s\n", param.sector_size);
+	if (ndns_action.sector_size) {
+		if (parse_size64(ndns_action.sector_size) == ULLONG_MAX) {
+			error("invalid sector size: %s\n",
+					ndns_action.sector_size);
 			rc = -EINVAL;
 		}
 	} else if (((param.type && strcmp(param.type, "blk") == 0)
 			|| (param.mode && strcmp(param.mode, "safe") == 0))) {
 		/* default sector size for blk-type or safe-mode */
-		param.sector_size = "4096";
+		ndns_action.sector_size = "4096";
 	}
 
 	return rc;
@@ -267,7 +269,7 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	};
 	int i, rc = 0;
 
-	param.do_scan = argc == 1;
+	ndns_action.do_scan = argc == 1;
         argc = parse_options(argc, argv, options, u, 0);
 
 	rc = set_defaults(mode);
@@ -305,7 +307,7 @@ static const char *parse_namespace_options(int argc, const char **argv,
 		return NULL; /* we won't return from usage_with_options() */
 	}
 
-	return mode == ACTION_CREATE ? param.reconfig : argv[0];
+	return mode == ACTION_CREATE ? ndns_action.reconfig : argv[0];
 }
 
 #define try(prefix, op, dev, p) \
@@ -474,21 +476,22 @@ static int validate_namespace_options(struct ndctl_region *region,
 		return -EAGAIN;
 	}
 
-	if (param.size)
-		p->size = __parse_size64(param.size, &units);
+	if (ndns_action.size)
+		p->size = __parse_size64(ndns_action.size, &units);
 	else if (ndns)
 		p->size = ndctl_namespace_get_size(ndns);
 
-	if (param.uuid) {
-		if (uuid_parse(param.uuid, p->uuid) != 0) {
+	if (ndns_action.uuid) {
+		if (uuid_parse(ndns_action.uuid, p->uuid) != 0) {
 			debug("%s: invalid uuid\n", __func__);
 			return -EINVAL;
 		}
 	} else
 		uuid_generate(p->uuid);
 
-	if (param.name)
-		rc = snprintf(p->name, sizeof(p->name), "%s", param.name);
+	if (ndns_action.name)
+		rc = snprintf(p->name, sizeof(p->name), "%s",
+				ndns_action.name);
 	else if (ndns)
 		rc = snprintf(p->name, sizeof(p->name), "%s",
 				ndctl_namespace_get_alt_name(ndns));
@@ -520,11 +523,11 @@ static int validate_namespace_options(struct ndctl_region *region,
 	} else if (ndns)
 		p->mode = ndctl_namespace_get_mode(ndns);
 
-	if (param.align) {
+	if (ndns_action.align) {
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
 
-		p->align = parse_size64(param.align);
+		p->align = parse_size64(ndns_action.align);
 
 		if (p->mode == NDCTL_NS_MODE_MEMORY && p->align != SZ_2M
 				&& (!pfn || !ndctl_pfn_has_align(pfn))) {
@@ -545,7 +548,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 			debug("%s not support 'align' for devdax mode\n",
 					region_name);
 			return -EAGAIN;
-		} else if (!param.align_default
+		} else if (!ndns_action.align_default
 				&& (p->mode == NDCTL_NS_MODE_SAFE
 					|| p->mode == NDCTL_NS_MODE_RAW)) {
 			/*
@@ -565,7 +568,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		 * memory.
 		 */
 		resource = ndctl_region_get_resource(region);
-		if (param.align_default && resource < ULLONG_MAX
+		if (ndns_action.align_default && resource < ULLONG_MAX
 				&& (resource & (SZ_2M - 1))) {
 			debug("%s: falling back to a 4K alignment\n",
 					region_name);
@@ -578,7 +581,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		case SZ_1G:
 			break;
 		default:
-			error("unsupported align: %s\n", param.align);
+			error("unsupported align: %s\n", ndns_action.align);
 			return -ENXIO;
 		}
 
@@ -616,16 +619,17 @@ static int validate_namespace_options(struct ndctl_region *region,
 		p->size *= size_align;
 		p->size /= units;
 		error("'--size=' must align to interleave-width: %d and alignment: %ld\n"
-				"  did you intend --size=%lld%s?\n", ways, param.align
+				"  did you intend --size=%lld%s?\n",
+				ways, ndns_action.align
 				? p->align : SZ_4K, p->size, suffix);
 		return -EINVAL;
 	}
 
-	if (param.sector_size) {
+	if (ndns_action.sector_size) {
 		struct ndctl_btt *btt;
 		int num, i;
 
-		p->sector_size = parse_size64(param.sector_size);
+		p->sector_size = parse_size64(ndns_action.sector_size);
 		btt = ndctl_region_get_btt_seed(region);
 		if (p->mode == NDCTL_NS_MODE_SAFE) {
 			if (!btt) {
@@ -688,8 +692,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 			p->sector_size = 512;
 	}
 
-	if (param.map) {
-		if (!strcmp(param.map, "mem"))
+	if (ndns_action.map) {
+		if (!strcmp(ndns_action.map, "mem"))
 			p->loc = NDCTL_PFN_LOC_RAM;
 		else
 			p->loc = NDCTL_PFN_LOC_PMEM;
@@ -708,7 +712,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 	if (do_setup_pfn(ndns, p)) {
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 
-		if (!pfn && param.mode_default) {
+		if (!pfn && ndns_action.mode_default) {
 			debug("%s fsdax mode not available\n", region_name);
 			p->mode = NDCTL_NS_MODE_RAW;
 		} else if (!pfn) {
@@ -729,7 +733,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 		}
 	}
 
-	p->autolabel = param.autolabel;
+	p->autolabel = ndns_action.autolabel;
 
 	return 0;
 }
@@ -984,14 +988,87 @@ static int namespace_reconfig(struct ndctl_region *region,
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair, bool logfix);
 
+static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
+{
+	return true;
+}
+
+static bool filter_region(struct ndctl_region *region,
+		struct util_filter_ctx *ctx)
+{
+	struct ndns_filter_arg *nfa = ctx->ndns;
+	int rc = 0;
+	bool out = true;
+
+	if (nfa->action == ACTION_CREATE && !nfa->namespace) {
+		rc = namespace_create(region);
+		if (rc != -EAGAIN) {
+			if (rc == 0)
+				rc = 1;
+			/* don't proceed in the filter loop */
+			out = false;
+		}
+	}
+
+	nfa->rc = rc;
+	return out;
+}
+
+static void filter_namespace(struct ndctl_namespace *ndns,
+		struct util_filter_ctx *ctx)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndns_filter_arg *nfa = ctx->ndns;
+	const char *ndns_name;
+	int rc;
+
+	/* we have an error, don't do anything else */
+	if (nfa->rc < 0)
+		return;
+
+	ndns_name = ndctl_namespace_get_devname(ndns);
+	if (strcmp(nfa->namespace, "all") != 0
+			&& strcmp(nfa->namespace, ndns_name) != 0)
+		return;
+
+	switch (nfa->action) {
+	case ACTION_DISABLE:
+		rc = ndctl_namespace_disable_safe(ndns);
+		break;
+	case ACTION_ENABLE:
+		rc = ndctl_namespace_enable(ndns);
+		break;
+	case ACTION_DESTROY:
+		rc = namespace_destroy(region, ndns);
+		break;
+	case ACTION_CHECK:
+		rc = namespace_check(ndns, verbose, force, repair, logfix);
+		if (rc < 0) {
+			nfa->rc = rc;
+			return;
+		}
+	case ACTION_CREATE:
+		rc = namespace_reconfig(region, ndns);
+		if (rc < 0) {
+			nfa->rc = rc;
+			return;
+		}
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc >= 0)
+		nfa->rc++;
+}
+
 static int do_xaction_namespace(const char *namespace,
 		enum device_action action, struct ndctl_ctx *ctx)
 {
-	struct ndctl_namespace *ndns, *_n;
-	int rc = -ENXIO, success = 0;
-	struct ndctl_region *region;
-	const char *ndns_name;
-	struct ndctl_bus *bus;
+	int rc = -ENXIO;
+
+	struct util_filter_ctx fctx = { 0 };
+	struct ndns_filter_arg nfa = { 0 };
 
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
@@ -999,74 +1076,18 @@ static int do_xaction_namespace(const char *namespace,
 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, param.bus))
-			continue;
-
-		ndctl_region_foreach(bus, region) {
-			if (!util_region_filter(region, param.region))
-				continue;
-
-			if (param.type) {
-				if (strcmp(param.type, "pmem") == 0
-						&& ndctl_region_get_type(region)
-						== ND_DEVICE_REGION_PMEM)
-					/* pass */;
-				else if (strcmp(param.type, "blk") == 0
-						&& ndctl_region_get_type(region)
-						== ND_DEVICE_REGION_BLK)
-					/* pass */;
-				else
-					continue;
-			}
+	fctx.filter_bus = filter_bus;
+	fctx.filter_region = filter_region;
+	fctx.filter_namespace = filter_namespace;
+	fctx.ndns = &nfa;
+	fctx.ndns->action = action;
+	fctx.ndns->namespace = namespace;
 
-			if (action == ACTION_CREATE && !namespace) {
-				rc = namespace_create(region);
-				if (rc == -EAGAIN)
-					continue;
-				if (rc == 0)
-					rc = 1;
-				return rc;
-			}
-			ndctl_namespace_foreach_safe(region, ndns, _n) {
-				ndns_name = ndctl_namespace_get_devname(ndns);
-
-				if (strcmp(namespace, "all") != 0
-						&& strcmp(namespace, ndns_name) != 0)
-					continue;
-				switch (action) {
-				case ACTION_DISABLE:
-					rc = ndctl_namespace_disable_safe(ndns);
-					break;
-				case ACTION_ENABLE:
-					rc = ndctl_namespace_enable(ndns);
-					break;
-				case ACTION_DESTROY:
-					rc = namespace_destroy(region, ndns);
-					break;
-				case ACTION_CHECK:
-					rc = namespace_check(ndns, verbose,
-							force, repair, logfix);
-					if (rc < 0)
-						return rc;
-					break;
-				case ACTION_CREATE:
-					rc = namespace_reconfig(region, ndns);
-					if (rc < 0)
-						return rc;
-					return 1;
-				default:
-					rc = -EINVAL;
-					break;
-				}
-				if (rc >= 0)
-					success++;
-			}
-		}
-	}
+	rc = util_filter_walk(ctx, &fctx, &param);
+	if (rc < 0)
+		return rc;
 
-	if (success)
-		return success;
+	rc = nfa.rc;
 	return rc;
 }
 
@@ -1119,7 +1140,7 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 			ACTION_CREATE, create_options, xable_usage);
 	int created = do_xaction_namespace(namespace, ACTION_CREATE, ctx);
 
-	if (created < 1 && param.do_scan) {
+	if (created < 1 && ndns_action.do_scan) {
 		/*
 		 * In the default scan case we try pmem first and then
 		 * fallback to blk before giving up.
diff --git a/util/filter.c b/util/filter.c
index 6ab391a8..98e68ebe 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -18,6 +18,7 @@
 #include <sys/stat.h>
 #include <util/util.h>
 #include <sys/types.h>
+#include <ndctl/action.h>
 #include <ndctl/ndctl.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
@@ -375,7 +376,7 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 		}
 
 		ndctl_region_foreach(bus, region) {
-			struct ndctl_namespace *ndns;
+			struct ndctl_namespace *ndns, *_n;
 
 			if (!util_region_filter(region, param->region)
 					|| !util_region_filter_by_dimm(region,
@@ -394,18 +395,12 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 			if (!fctx->filter_region(region, fctx))
 				continue;
 
-			ndctl_namespace_foreach(region, ndns) {
-				enum ndctl_namespace_mode mode;
-
+			ndctl_namespace_foreach_safe(region, ndns, _n) {
 				if (!fctx->filter_namespace)
 					break;
 				if (!util_namespace_filter(ndns, param->namespace))
 					continue;
 
-				mode = ndctl_namespace_get_mode(ndns);
-				if (param->mode && mode_to_type(param->mode) != mode)
-					continue;
-
 				fctx->filter_namespace(ndns, fctx);
 			}
 		}
diff --git a/util/filter.h b/util/filter.h
index effda24b..ce3336a5 100644
--- a/util/filter.h
+++ b/util/filter.h
@@ -13,6 +13,7 @@
 #ifndef _UTIL_FILTER_H_
 #define _UTIL_FILTER_H_
 #include <stdbool.h>
+#include <ndctl/action.h>
 
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident);
 struct ndctl_region *util_region_filter(struct ndctl_region *region,
@@ -50,6 +51,12 @@ struct list_filter_arg {
 	unsigned long flags;
 };
 
+struct ndns_filter_arg {
+	enum device_action action;
+	const char *namespace;
+	int rc;
+};
+
 /*
  * struct util_filter_ctx - control and callbacks for util_filter_walk()
  * ->filter_bus() and ->filter_region() return bool because the
@@ -67,6 +74,7 @@ struct util_filter_ctx {
 	union {
 		void *arg;
 		struct list_filter_arg *list;
+		struct ndns_filter_arg *ndns;
 	};
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
