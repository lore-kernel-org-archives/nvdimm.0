Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 0BB2F1A1EC1
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:40:39 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: add library support for 'dax' devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:39:51 -0700
Message-ID: <146274719141.12219.9663252577433495595.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146274718628.12219.9049769475511391374.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146274718628.12219.9049769475511391374.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given a 'dax' device is simply a 'pfn' device with a different driver,
we can reuse most of the pfn API implementation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac            |   26 +++
 lib/libndctl.c          |  367 ++++++++++++++++++++++++++++++++++++++++++++---
 lib/libndctl.sym        |   25 +++
 lib/ndctl/libndctl.h.in |   38 +++++
 4 files changed, 436 insertions(+), 20 deletions(-)

diff --git a/configure.ac b/configure.ac
index c50ba3dfc1d9..aefcf09835d0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -145,6 +145,25 @@ AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
 )
 AM_CONDITIONAL([ENABLE_CLEAR_ERROR], [test "x$enable_clear_err" = "xyes"])
 
+AC_MSG_CHECKING([for device DAX support])
+AC_LANG(C)
+AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
+			#ifdef HAVE_NDCTL_H
+			#include <linux/ndctl.h>
+			#else
+			#include "ndctl.h"
+			#endif
+			]], [[
+			int x = ND_DEVICE_NAMESPACE_DAX;
+			]]
+		)], [AC_MSG_RESULT([yes])
+		     enable_dev_dax=yes
+		     AC_DEFINE([HAVE_NDCTL_DEVICE_DAX], [1],
+				[Define to 1 if ndctl.h has device DAX support.])
+		], [AC_MSG_RESULT([no])]
+)
+AM_CONDITIONAL([ENABLE_DEV_DAX], [test "x$enable_dev_dax" = "xyes"])
+
 AC_MSG_CHECKING([for SMART support])
 AC_LANG(C)
 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
@@ -181,15 +200,22 @@ AC_CONFIG_COMMANDS([gen-libndctl.h],
 		else
 			enable_clear_err=0
 		fi
+		if test "x$enable_dev_dax" = "xyes"; then
+			enable_dev_dax=1
+		else
+			enable_dev_dax=0
+		fi
 		sed -e s/HAVE_NDCTL_ARS/$enable_ars/ \
 		    -e s/HAVE_NDCTL_SMART/$enable_smart/ \
 		    -e s/HAVE_NDCTL_CLEAR_ERROR/$enable_clear_err/ \
+		    -e s/HAVE_NDCTL_DEV_DAX/$enable_dev_dax/ \
 		< lib/ndctl/libndctl.h.in > lib/ndctl/libndctl.h
 		]],
 		[[
 		enable_ars=$enable_ars
 		enable_smart=$enable_smart
 		enable_clear_err=$enable_clear_err
+		enable_dev_dax=$enable_dev_dax
 		]])
 
 AC_CHECK_HEADERS_ONCE([linux/version.h])
diff --git a/lib/libndctl.c b/lib/libndctl.c
index b98463e90342..c9ade76c26d2 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -195,6 +195,7 @@ struct ndctl_region {
 	int namespaces_init;
 	int btts_init;
 	int pfns_init;
+	int daxs_init;
 	unsigned long long size;
 	char *region_path;
 	char *region_buf;
@@ -202,11 +203,13 @@ struct ndctl_region {
 	int generation;
 	struct list_head btts;
 	struct list_head pfns;
+	struct list_head daxs;
 	struct list_head mappings;
 	struct list_head namespaces;
 	struct list_head stale_namespaces;
 	struct list_head stale_btts;
 	struct list_head stale_pfns;
+	struct list_head stale_daxs;
 	struct list_node list;
 	/**
 	 * struct ndctl_interleave_set - extra info for interleave sets
@@ -313,6 +316,10 @@ struct ndctl_pfn {
 	int id, generation;
 };
 
+struct ndctl_dax {
+	struct ndctl_pfn pfn;
+};
+
 /**
  * struct ndctl_ctx - library user context to find "nd" instances
  *
@@ -542,7 +549,7 @@ static void free_stale_btts(struct ndctl_region *region)
 		free_btt(btt, &region->stale_btts);
 }
 
-static void free_pfn(struct ndctl_pfn *pfn, struct list_head *head)
+static void __free_pfn(struct ndctl_pfn *pfn, struct list_head *head, void *to_free)
 {
 	if (head)
 		list_del_from(head, &pfn->list);
@@ -550,7 +557,17 @@ static void free_pfn(struct ndctl_pfn *pfn, struct list_head *head)
 	free(pfn->pfn_path);
 	free(pfn->pfn_buf);
 	free(pfn->bdev);
-	free(pfn);
+	free(to_free);
+}
+
+static void free_pfn(struct ndctl_pfn *pfn, struct list_head *head)
+{
+	__free_pfn(pfn, head, pfn);
+}
+
+static void free_dax(struct ndctl_dax *dax, struct list_head *head)
+{
+	__free_pfn(&dax->pfn, head, dax);
 }
 
 static void free_pfns(struct ndctl_region *region)
@@ -561,6 +578,14 @@ static void free_pfns(struct ndctl_region *region)
 		free_pfn(pfn, &region->pfns);
 }
 
+static void free_daxs(struct ndctl_region *region)
+{
+	struct ndctl_dax *dax, *_b;
+
+	list_for_each_safe(&region->daxs, dax, _b, pfn.list)
+		free_dax(dax, &region->daxs);
+}
+
 static void free_stale_pfns(struct ndctl_region *region)
 {
 	struct ndctl_pfn *pfn, *_b;
@@ -569,6 +594,14 @@ static void free_stale_pfns(struct ndctl_region *region)
 		free_pfn(pfn, &region->stale_pfns);
 }
 
+static void free_stale_daxs(struct ndctl_region *region)
+{
+	struct ndctl_dax *dax, *_b;
+
+	list_for_each_safe(&region->stale_daxs, dax, _b, pfn.list)
+		free_dax(dax, &region->stale_daxs);
+}
+
 static void free_region(struct ndctl_region *region)
 {
 	struct ndctl_bus *bus = region->bus;
@@ -582,6 +615,8 @@ static void free_region(struct ndctl_region *region)
 	free_stale_btts(region);
 	free_pfns(region);
 	free_stale_pfns(region);
+	free_daxs(region);
+	free_stale_daxs(region);
 	free_namespaces(region);
 	free_stale_namespaces(region);
 	list_del_from(&bus->regions, &region->list);
@@ -1100,6 +1135,29 @@ NDCTL_EXPORT struct ndctl_pfn *ndctl_region_get_pfn_seed(struct ndctl_region *re
 	return NULL;
 }
 
+NDCTL_EXPORT struct ndctl_dax *ndctl_region_get_dax_seed(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *path = region->region_buf;
+	int len = region->buf_len;
+	struct ndctl_dax *dax;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/dax_seed", region->region_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_region_get_devname(region));
+		return NULL;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return NULL;
+
+	ndctl_dax_foreach(region, dax)
+		if (strcmp(buf, ndctl_dax_get_devname(dax)) == 0)
+			return dax;
+	return NULL;
+}
+
 NDCTL_EXPORT int ndctl_region_get_ro(struct ndctl_region *region)
 {
 	return region->ro;
@@ -1603,8 +1661,10 @@ static int add_region(void *parent, int id, const char *region_base)
 		goto err_region;
 	list_head_init(&region->btts);
 	list_head_init(&region->pfns);
+	list_head_init(&region->daxs);
 	list_head_init(&region->stale_btts);
 	list_head_init(&region->stale_pfns);
+	list_head_init(&region->stale_daxs);
 	list_head_init(&region->mappings);
 	list_head_init(&region->namespaces);
 	list_head_init(&region->stale_namespaces);
@@ -1804,6 +1864,9 @@ static const char *ndctl_device_type_name(int type)
 	case ND_DEVICE_NAMESPACE_IO:   return "namespace_io";
 	case ND_DEVICE_NAMESPACE_PMEM: return "namespace_pmem";
 	case ND_DEVICE_NAMESPACE_BLK:  return "namespace_blk";
+#ifdef HAVE_NDCTL_DEVICE_DAX
+	case ND_DEVICE_DAX_PMEM:       return "dax_pmem";
+#endif
 	default:                       return "unknown";
 	}
 }
@@ -2401,6 +2464,7 @@ NDCTL_EXPORT void ndctl_region_cleanup(struct ndctl_region *region)
 	free_stale_namespaces(region);
 	free_stale_btts(region);
 	free_stale_pfns(region);
+	free_stale_daxs(region);
 }
 
 static int ndctl_region_disable(struct ndctl_region *region, int cleanup)
@@ -2420,9 +2484,11 @@ static int ndctl_region_disable(struct ndctl_region *region, int cleanup)
 	region->namespaces_init = 0;
 	region->btts_init = 0;
 	region->pfns_init = 0;
+	region->daxs_init = 0;
 	list_append_list(&region->stale_namespaces, &region->namespaces);
 	list_append_list(&region->stale_btts, &region->btts);
 	list_append_list(&region->stale_pfns, &region->pfns);
+	list_append_list(&region->stale_daxs, &region->daxs);
 	region->generation++;
 	if (cleanup)
 		ndctl_region_cleanup(region);
@@ -2969,6 +3035,30 @@ NDCTL_EXPORT struct ndctl_pfn *ndctl_namespace_get_pfn(struct ndctl_namespace *n
 	return NULL;
 }
 
+NDCTL_EXPORT struct ndctl_dax *ndctl_namespace_get_dax(struct ndctl_namespace *ndns)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	char *path = ndns->ndns_buf;
+	int len = ndns->buf_len;
+	struct ndctl_dax *dax;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/holder", ndns->ndns_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_namespace_get_devname(ndns));
+		return NULL;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return NULL;
+
+	ndctl_dax_foreach(region, dax)
+		if (strcmp(buf, ndctl_dax_get_devname(dax)) == 0)
+			return dax;
+	return NULL;
+}
+
 NDCTL_EXPORT const char *ndctl_namespace_get_block_device(struct ndctl_namespace *ndns)
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
@@ -3009,6 +3099,8 @@ NDCTL_EXPORT enum ndctl_namespace_mode ndctl_namespace_get_mode(
 
 	if (strcmp("memory", buf) == 0)
 		return NDCTL_NS_MODE_MEMORY;
+	if (strcmp("dax", buf) == 0)
+		return NDCTL_NS_MODE_DAX;
 	if (strcmp("raw", buf) == 0)
 		return NDCTL_NS_MODE_RAW;
 	if (strcmp("safe", buf) == 0)
@@ -3141,6 +3233,7 @@ static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath)
 
 static int add_btt(void *parent, int id, const char *btt_base);
 static int add_pfn(void *parent, int id, const char *pfn_base);
+static int add_dax(void *parent, int id, const char *dax_base);
 
 static void btts_init(struct ndctl_region *region)
 {
@@ -3168,14 +3261,29 @@ static void pfns_init(struct ndctl_region *region)
 	device_parse(bus->ctx, bus, region->region_path, pfn_fmt, region, add_pfn);
 }
 
+static void daxs_init(struct ndctl_region *region)
+{
+	struct ndctl_bus *bus = ndctl_region_get_bus(region);
+	char dax_fmt[20];
+
+	if (region->daxs_init)
+		return;
+	region->daxs_init = 1;
+
+	sprintf(dax_fmt, "dax%d.", region->id);
+	device_parse(bus->ctx, bus, region->region_path, dax_fmt, region, add_dax);
+}
+
 static void region_refresh_children(struct ndctl_region *region)
 {
 	region->namespaces_init = 0;
 	region->btts_init = 0;
 	region->pfns_init = 0;
+	region->daxs_init = 0;
 	namespaces_init(region);
 	btts_init(region);
 	pfns_init(region);
+	daxs_init(region);
 }
 
 /*
@@ -3197,14 +3305,15 @@ NDCTL_EXPORT int ndctl_namespace_enable(struct ndctl_namespace *ndns)
 
 	/*
 	 * Rescan now as successfully enabling a namespace device leads
-	 * to a new one being created, and potentially btts or pfns being
-	 * attached
+	 * to a new one being created, and potentially btts, pfns, or
+	 * daxs being attached
 	 */
 	region_refresh_children(region);
 
 	if (!ndctl_namespace_is_enabled(ndns)) {
 		struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 		struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+		struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 
 		if (btt && ndctl_btt_is_enabled(btt)) {
 			dbg(ctx, "%s: enabled via %s\n", devname,
@@ -3216,6 +3325,11 @@ NDCTL_EXPORT int ndctl_namespace_enable(struct ndctl_namespace *ndns)
 					ndctl_pfn_get_devname(pfn));
 			return 1;
 		}
+		if (dax && ndctl_dax_is_enabled(dax)) {
+			dbg(ctx, "%s: enabled via %s\n", devname,
+					ndctl_dax_get_devname(dax));
+			return 1;
+		}
 
 		err(ctx, "%s: failed to enable\n", devname);
 		return rc ? rc : -ENXIO;
@@ -3253,12 +3367,16 @@ NDCTL_EXPORT int ndctl_namespace_disable_invalidate(struct ndctl_namespace *ndns
 {
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 	int rc = 0;
 
 	if (btt)
 		rc = ndctl_btt_delete(btt);
 	if (pfn)
 		rc = ndctl_pfn_delete(pfn);
+	if (dax)
+		rc = ndctl_dax_delete(dax);
+
 	if (rc)
 		return rc;
 
@@ -3914,23 +4032,17 @@ NDCTL_EXPORT int ndctl_btt_is_configured(struct ndctl_btt *btt)
 	return 0;
 }
 
-static int add_pfn(void *parent, int id, const char *pfn_base)
+static int __add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 {
-	struct ndctl_ctx *ctx = ndctl_region_get_ctx(parent);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(pfn->region);
 	char *path = calloc(1, strlen(pfn_base) + 100);
-	struct ndctl_region *region = parent;
-	struct ndctl_pfn *pfn, *pfn_dup;
+	struct ndctl_region *region = pfn->region;
 	char buf[SYSFS_ATTR_SIZE];
 	int rc = -ENOMEM;
 
 	if (!path)
 		return -ENOMEM;
 
-	pfn = calloc(1, sizeof(*pfn));
-	if (!pfn)
-		goto err_pfn;
-	pfn->id = id;
-	pfn->region = region;
 	pfn->generation = region->generation;
 
 	pfn->pfn_path = strdup(pfn_base);
@@ -3986,6 +4098,32 @@ static int add_pfn(void *parent, int id, const char *pfn_base)
 		pfn->size = strtoull(buf, NULL, 0);
 
 	free(path);
+	return 0;
+
+ err_read:
+	free(pfn->pfn_buf);
+	free(pfn->pfn_path);
+	free(path);
+	return rc;
+}
+
+static int add_pfn(void *parent, int id, const char *pfn_base)
+{
+	struct ndctl_pfn *pfn = calloc(1, sizeof(*pfn)), *pfn_dup;
+	struct ndctl_region *region = parent;
+	int rc;
+
+	if (!pfn)
+		return -ENOMEM;
+
+	pfn->id = id;
+	pfn->region = region;
+	rc = __add_pfn(pfn, pfn_base);
+	if (rc < 0) {
+		free(pfn);
+		return rc;
+	}
+
 	ndctl_pfn_foreach(region, pfn_dup)
 		if (pfn->id == pfn_dup->id) {
 			pfn_dup->resource = pfn->resource;
@@ -3995,15 +4133,42 @@ static int add_pfn(void *parent, int id, const char *pfn_base)
 		}
 
 	list_add(&region->pfns, &pfn->list);
+
 	return 0;
+}
 
- err_read:
-	free(pfn->pfn_buf);
-	free(pfn->pfn_path);
-	free(pfn);
- err_pfn:
-	free(path);
-	return rc;
+static int add_dax(void *parent, int id, const char *dax_base)
+{
+	struct ndctl_dax *dax = calloc(1, sizeof(*dax)), *dax_dup;
+	struct ndctl_region *region = parent;
+	struct ndctl_pfn *pfn = &dax->pfn;
+	int rc;
+
+	if (!dax)
+		return -ENOMEM;
+
+	pfn->id = id;
+	pfn->region = region;
+	rc = __add_pfn(pfn, dax_base);
+	if (rc < 0) {
+		free(dax);
+		return rc;
+	}
+
+	ndctl_dax_foreach(region, dax_dup) {
+		struct ndctl_pfn *pfn_dup = &dax_dup->pfn;
+
+		if (pfn->id == pfn_dup->id) {
+			pfn_dup->resource = pfn->resource;
+			pfn_dup->size = pfn->size;
+			free_dax(dax, NULL);
+			return 1;
+		}
+	}
+
+	list_add(&region->daxs, &dax->pfn.list);
+
+	return 0;
 }
 
 NDCTL_EXPORT struct ndctl_pfn *ndctl_pfn_get_first(struct ndctl_region *region)
@@ -4311,3 +4476,165 @@ NDCTL_EXPORT int ndctl_pfn_is_configured(struct ndctl_pfn *pfn)
 
 	return 0;
 }
+
+NDCTL_EXPORT struct ndctl_dax *ndctl_dax_get_first(struct ndctl_region *region)
+{
+	daxs_init(region);
+
+	return list_top(&region->daxs, struct ndctl_dax, pfn.list);
+}
+
+NDCTL_EXPORT struct ndctl_dax *ndctl_dax_get_next(struct ndctl_dax *dax)
+{
+	struct ndctl_region *region = dax->pfn.region;
+
+	return list_next(&region->daxs, dax, pfn.list);
+}
+
+NDCTL_EXPORT unsigned int ndctl_dax_get_id(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_id(&dax->pfn);
+}
+
+NDCTL_EXPORT struct ndctl_namespace *ndctl_dax_get_namespace(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_namespace(&dax->pfn);
+}
+
+NDCTL_EXPORT void ndctl_dax_get_uuid(struct ndctl_dax *dax, uuid_t uu)
+{
+	ndctl_pfn_get_uuid(&dax->pfn, uu);
+}
+
+NDCTL_EXPORT unsigned long long ndctl_dax_get_size(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_size(&dax->pfn);
+}
+
+NDCTL_EXPORT unsigned long long ndctl_dax_get_resource(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_resource(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu)
+{
+	return ndctl_pfn_set_uuid(&dax->pfn, uu);
+}
+
+NDCTL_EXPORT enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_location(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_set_location(struct ndctl_dax *dax,
+		enum ndctl_pfn_loc loc)
+{
+	return ndctl_pfn_set_location(&dax->pfn, loc);
+}
+
+NDCTL_EXPORT unsigned long ndctl_dax_get_align(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_align(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align)
+{
+	return ndctl_pfn_set_align(&dax->pfn, align);
+}
+
+NDCTL_EXPORT int ndctl_dax_set_namespace(struct ndctl_dax *dax,
+		struct ndctl_namespace *ndns)
+{
+	return ndctl_pfn_set_namespace(&dax->pfn, ndns);
+}
+
+NDCTL_EXPORT struct ndctl_bus *ndctl_dax_get_bus(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_bus(&dax->pfn);
+}
+
+NDCTL_EXPORT struct ndctl_ctx *ndctl_dax_get_ctx(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_ctx(&dax->pfn);
+}
+
+NDCTL_EXPORT const char *ndctl_dax_get_devname(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_devname(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_is_valid(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_is_valid(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_is_enabled(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_is_enabled(&dax->pfn);
+}
+
+NDCTL_EXPORT struct ndctl_region *ndctl_dax_get_region(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_get_region(&dax->pfn);
+}
+
+NDCTL_EXPORT int ndctl_dax_enable(struct ndctl_dax *dax)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	const char *devname = ndctl_dax_get_devname(dax);
+	struct ndctl_ctx *ctx = ndctl_dax_get_ctx(dax);
+	struct ndctl_pfn *pfn = &dax->pfn;
+
+	if (ndctl_dax_is_enabled(dax))
+		return 0;
+
+	ndctl_bind(ctx, pfn->module, devname);
+
+	if (!ndctl_dax_is_enabled(dax)) {
+		err(ctx, "%s: failed to enable\n", devname);
+		return -ENXIO;
+	}
+
+	dbg(ctx, "%s: enabled\n", devname);
+
+	/*
+	 * Rescan now as successfully enabling a dax device leads to a
+	 * new one being created, and potentially the backing namespace
+	 * as well.
+	 */
+	region_refresh_children(region);
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dax_delete(struct ndctl_dax *dax)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	struct ndctl_ctx *ctx = ndctl_dax_get_ctx(dax);
+	struct ndctl_pfn *pfn = &dax->pfn;
+	int rc;
+
+	if (!ndctl_dax_is_valid(dax)) {
+		free_dax(dax, &region->stale_daxs);
+		return 0;
+	}
+
+	ndctl_unbind(ctx, pfn->pfn_path);
+
+	rc = ndctl_dax_set_namespace(dax, NULL);
+	if (rc) {
+		dbg(ctx, "%s: failed to clear namespace: %d\n",
+			ndctl_dax_get_devname(dax), rc);
+		return rc;
+	}
+
+	free_dax(dax, &region->daxs);
+	region->daxs_init = 0;
+
+	return 0;
+}
+
+NDCTL_EXPORT int ndctl_dax_is_configured(struct ndctl_dax *dax)
+{
+	return ndctl_pfn_is_configured(&dax->pfn);
+}
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index dc9e69d637da..d5b0ab624aaa 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -152,6 +152,7 @@ global:
 	ndctl_namespace_get_bus;
 	ndctl_namespace_get_btt;
 	ndctl_namespace_get_pfn;
+	ndctl_namespace_get_dax;
 	ndctl_namespace_get_region;
 	ndctl_namespace_get_id;
 	ndctl_namespace_get_devname;
@@ -236,4 +237,28 @@ global:
 	ndctl_pfn_enable;
 	ndctl_pfn_delete;
 	ndctl_pfn_is_configured;
+	ndctl_region_get_dax_seed;
+	ndctl_namespace_get_dax;
+	ndctl_dax_get_first;
+	ndctl_dax_get_next;
+	ndctl_dax_get_id;
+	ndctl_dax_get_namespace;
+	ndctl_dax_get_uuid;
+	ndctl_dax_get_size;
+	ndctl_dax_get_resource;
+	ndctl_dax_set_uuid;
+	ndctl_dax_get_location;
+	ndctl_dax_set_location;
+	ndctl_dax_get_align;
+	ndctl_dax_set_align;
+	ndctl_dax_set_namespace;
+	ndctl_dax_get_bus;
+	ndctl_dax_get_ctx;
+	ndctl_dax_get_devname;
+	ndctl_dax_is_valid;
+	ndctl_dax_is_enabled;
+	ndctl_dax_get_region;
+	ndctl_dax_enable;
+	ndctl_dax_delete;
+	ndctl_dax_is_configured;
 } LIBNDCTL_1;
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index 3241e92535a5..6a7510964ae2 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -455,6 +455,7 @@ struct ndctl_bus *ndctl_namespace_get_bus(struct ndctl_namespace *ndns);
 struct ndctl_region *ndctl_namespace_get_region(struct ndctl_namespace *ndns);
 struct ndctl_btt *ndctl_namespace_get_btt(struct ndctl_namespace *ndns);
 struct ndctl_pfn *ndctl_namespace_get_pfn(struct ndctl_namespace *ndns);
+struct ndctl_dax *ndctl_namespace_get_dax(struct ndctl_namespace *ndns);
 unsigned int ndctl_namespace_get_id(struct ndctl_namespace *ndns);
 const char *ndctl_namespace_get_devname(struct ndctl_namespace *ndns);
 unsigned int ndctl_namespace_get_type(struct ndctl_namespace *ndns);
@@ -464,6 +465,7 @@ enum ndctl_namespace_mode {
 	NDCTL_NS_MODE_MEMORY,
 	NDCTL_NS_MODE_SAFE,
 	NDCTL_NS_MODE_RAW,
+	NDCTL_NS_MODE_DAX,
 };
 enum ndctl_namespace_mode ndctl_namespace_get_mode(
 		struct ndctl_namespace *ndns);
@@ -566,6 +568,42 @@ int ndctl_pfn_enable(struct ndctl_pfn *pfn);
 int ndctl_pfn_delete(struct ndctl_pfn *pfn);
 int ndctl_pfn_is_configured(struct ndctl_pfn *pfn);
 
+#define ndctl_dax_foreach(region, dax) \
+        for (dax = ndctl_dax_get_first(region); \
+             dax != NULL; \
+             dax = ndctl_dax_get_next(dax))
+#define ndctl_dax_foreach_safe(region, dax, _dax) \
+	for (dax = ndctl_dax_get_first(region), \
+	     _dax = ndctl_dax_get_next(dax); \
+	     dax != NULL; \
+	     dax = _dax, \
+	     _dax = _dax ? ndctl_dax_get_next(_dax) : NULL)
+struct ndctl_dax *ndctl_region_get_dax_seed(struct ndctl_region *region);
+struct ndctl_dax *ndctl_namespace_get_dax(struct ndctl_namespace *ndns);
+struct ndctl_dax *ndctl_dax_get_first(struct ndctl_region *region);
+struct ndctl_dax *ndctl_dax_get_next(struct ndctl_dax *dax);
+unsigned int ndctl_dax_get_id(struct ndctl_dax *dax);
+struct ndctl_namespace *ndctl_dax_get_namespace(struct ndctl_dax *dax);
+void ndctl_dax_get_uuid(struct ndctl_dax *dax, uuid_t uu);
+unsigned long long ndctl_dax_get_size(struct ndctl_dax *dax);
+unsigned long long ndctl_dax_get_resource(struct ndctl_dax *dax);
+int ndctl_dax_set_uuid(struct ndctl_dax *dax, uuid_t uu);
+enum ndctl_pfn_loc ndctl_dax_get_location(struct ndctl_dax *dax);
+int ndctl_dax_set_location(struct ndctl_dax *dax, enum ndctl_pfn_loc loc);
+unsigned long ndctl_dax_get_align(struct ndctl_dax *dax);
+int ndctl_dax_set_align(struct ndctl_dax *dax, unsigned long align);
+int ndctl_dax_set_namespace(struct ndctl_dax *dax,
+		struct ndctl_namespace *ndns);
+struct ndctl_bus *ndctl_dax_get_bus(struct ndctl_dax *dax);
+struct ndctl_ctx *ndctl_dax_get_ctx(struct ndctl_dax *dax);
+const char *ndctl_dax_get_devname(struct ndctl_dax *dax);
+int ndctl_dax_is_valid(struct ndctl_dax *dax);
+int ndctl_dax_is_enabled(struct ndctl_dax *dax);
+struct ndctl_region *ndctl_dax_get_region(struct ndctl_dax *dax);
+int ndctl_dax_enable(struct ndctl_dax *dax);
+int ndctl_dax_delete(struct ndctl_dax *dax);
+int ndctl_dax_is_configured(struct ndctl_dax *dax);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
