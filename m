Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B92D682081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:38:50 -0800 (PST)
Subject: [ndctl PATCH 1/6] util, sysfs: convert add_dev_fn to return the device
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:34:41 -0800
Message-ID: <148143808173.11895.14120957888754123590.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Currently daxctl_new_region() adds a new region outside of
sysfs_device_parse(). As we go to add support for scanning all
dax_regions in a system we'll want to unigy daxctl_new_region() with
an add_dax_region() + sysfs_device_parse() scheme. Changing add_dev_fn
to return the device it added allows daxctl_new_region() to use the
eventual add_dax_region() as a helper.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |   11 ++---
 ndctl/lib/libndctl.c   |  112 ++++++++++++++++++++----------------------------
 util/sysfs.c           |   15 +++---
 util/sysfs.h           |    2 -
 4 files changed, 59 insertions(+), 81 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 4d97ce32f067..06605de85fc3 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -238,7 +238,7 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
 	return region;
 }
 
-static int add_dax_dev(void *parent, int id, const char *daxdev_base)
+static void *add_dax_dev(void *parent, int id, const char *daxdev_base)
 {
 	const char *devname = devpath_to_devname(daxdev_base);
 	char *path = calloc(1, strlen(daxdev_base) + 100);
@@ -246,11 +246,10 @@ static int add_dax_dev(void *parent, int id, const char *daxdev_base)
 	struct daxctl_ctx *ctx = region->ctx;
 	struct daxctl_dev *dev, *dev_dup;
 	char buf[SYSFS_ATTR_SIZE];
-	int rc = -ENOMEM;
 	struct stat st;
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	dev = calloc(1, sizeof(*dev));
 	if (!dev)
@@ -282,12 +281,12 @@ static int add_dax_dev(void *parent, int id, const char *daxdev_base)
 		if (dev_dup->id == dev->id) {
 			free_dev(dev, NULL);
 			free(path);
-			return 1;
+			return dev_dup;
 		}
 
 	list_add(&region->devices, &dev->list);
 	free(path);
-	return 0;
+	return dev;
 
  err_read:
 	free(dev->dev_buf);
@@ -295,7 +294,7 @@ static int add_dax_dev(void *parent, int id, const char *daxdev_base)
 	free(dev);
  err_dev:
 	free(path);
-	return rc;
+	return NULL;
 }
 
 DAXCTL_EXPORT int daxctl_region_get_id(struct daxctl_region *region)
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index eed418936a38..ff74c483076e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -784,16 +784,15 @@ static void parse_nfit_mem_flags(struct ndctl_dimm *dimm, char *flags)
 				ndctl_dimm_get_devname(dimm), flags);
 }
 
-static int add_bus(void *parent, int id, const char *ctl_base)
+static void *add_bus(void *parent, int id, const char *ctl_base)
 {
-	int rc = -ENOMEM;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_ctx *ctx = parent;
 	struct ndctl_bus *bus, *bus_dup;
 	char *path = calloc(1, strlen(ctl_base) + 100);
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	bus = calloc(1, sizeof(*bus));
 	if (!bus)
@@ -803,7 +802,6 @@ static int add_bus(void *parent, int id, const char *ctl_base)
 	bus->ctx = ctx;
 	bus->id = id;
 
-	rc = -EINVAL;
 	sprintf(path, "%s/dev", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0
 			|| sscanf(buf, "%d:%d", &bus->major, &bus->minor) != 2)
@@ -827,7 +825,6 @@ static int add_bus(void *parent, int id, const char *ctl_base)
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
 
-	rc = -ENOMEM;
 	bus->provider = strdup(buf);
 	if (!bus->provider)
 		goto err_read;
@@ -851,24 +848,23 @@ static int add_bus(void *parent, int id, const char *ctl_base)
 					ndctl_bus_get_provider(bus)) == 0) {
 			free_bus(bus, NULL);
 			free(path);
-			return 1;
+			return bus_dup;
 		}
 
 	list_add(&ctx->busses, &bus->list);
+	free(path);
 
-	rc = 0;
-	goto out;
+	return bus;
 
  err_dev_path:
  err_read:
 	free(bus->provider);
 	free(bus->bus_buf);
 	free(bus);
- out:
  err_bus:
 	free(path);
 
-	return rc;
+	return NULL;
 }
 
 static void busses_init(struct ndctl_ctx *ctx)
@@ -1117,17 +1113,17 @@ static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
 static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
 
-static int add_dimm(void *parent, int id, const char *dimm_base)
+static void *add_dimm(void *parent, int id, const char *dimm_base)
 {
+	int formats, i;
 	struct ndctl_dimm *dimm;
 	char buf[SYSFS_ATTR_SIZE];
-	int rc = -ENOMEM, formats, i;
 	struct ndctl_bus *bus = parent;
 	struct ndctl_ctx *ctx = bus->ctx;
 	char *path = calloc(1, strlen(dimm_base) + 100);
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	sprintf(path, "%s/nfit/formats", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -1141,8 +1137,6 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->bus = bus;
 	dimm->id = id;
 
-	rc = -ENXIO;
-
 	sprintf(path, "%s/dev", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1270,13 +1264,13 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	list_add(&bus->dimms, &dimm->list);
 	free(path);
 
-	return 0;
+	return dimm;
 
  err_read:
 	free_dimm(dimm);
  err_dimm:
 	free(path);
-	return rc;
+	return NULL;
 }
 
 static void dimms_init(struct ndctl_bus *bus)
@@ -1551,9 +1545,8 @@ static struct ndctl_dimm *ndctl_dimm_get_by_id(struct ndctl_bus *bus, unsigned i
 	return NULL;
 }
 
-static int add_region(void *parent, int id, const char *region_base)
+static void *add_region(void *parent, int id, const char *region_base)
 {
-	int rc = -ENOMEM;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_region *region;
 	struct ndctl_bus *bus = parent;
@@ -1561,7 +1554,7 @@ static int add_region(void *parent, int id, const char *region_base)
 	char *path = calloc(1, strlen(region_base) + 100);
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	region = calloc(1, sizeof(*region));
 	if (!region)
@@ -1578,7 +1571,6 @@ static int add_region(void *parent, int id, const char *region_base)
 	region->bus = bus;
 	region->id = id;
 
-	rc = -EINVAL;
 	sprintf(path, "%s/size", region_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1633,7 +1625,7 @@ static int add_region(void *parent, int id, const char *region_base)
 	list_add(&bus->regions, &region->list);
 
 	free(path);
-	return 0;
+	return region;
 
  err_read:
 	free(region->region_buf);
@@ -1641,7 +1633,7 @@ static int add_region(void *parent, int id, const char *region_base)
  err_region:
 	free(path);
 
-	return rc;
+	return NULL;
 }
 
 static void regions_init(struct ndctl_bus *bus)
@@ -2736,7 +2728,7 @@ static char *get_block_device(struct ndctl_ctx *ctx, const char *block_path)
 static int parse_lbasize_supported(struct ndctl_ctx *ctx, const char *devname,
 		const char *buf, struct ndctl_lbasize *lba);
 
-static int add_namespace(void *parent, int id, const char *ndns_base)
+static void *add_namespace(void *parent, int id, const char *ndns_base)
 {
 	const char *devname = devpath_to_devname(ndns_base);
 	char *path = calloc(1, strlen(ndns_base) + 100);
@@ -2745,10 +2737,9 @@ static int add_namespace(void *parent, int id, const char *ndns_base)
 	struct ndctl_bus *bus = region->bus;
 	struct ndctl_ctx *ctx = bus->ctx;
 	char buf[SYSFS_ATTR_SIZE];
-	int rc = -ENOMEM;
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	ndns = calloc(1, sizeof(*ndns));
 	if (!ndns)
@@ -2804,7 +2795,6 @@ static int add_namespace(void *parent, int id, const char *ndns_base)
 			goto err_read;
 		if (strlen(buf) && uuid_parse(buf, ndns->uuid) < 0) {
 			dbg(ctx, "%s:%s\n", path, buf);
-			rc = -EINVAL;
 			goto err_read;
 		}
 		break;
@@ -2830,12 +2820,12 @@ static int add_namespace(void *parent, int id, const char *ndns_base)
 		if (ndns_dup->id == ndns->id) {
 			free_namespace(ndns, NULL);
 			free(path);
-			return 1;
+			return ndns_dup;
 		}
 
 	list_add(&region->namespaces, &ndns->list);
 	free(path);
-	return 0;
+	return ndns;
 
  err_read:
 	free(ndns->ndns_buf);
@@ -2844,7 +2834,7 @@ static int add_namespace(void *parent, int id, const char *ndns_base)
 	free(ndns);
  err_namespace:
 	free(path);
-	return rc;
+	return NULL;
 }
 
 static void namespaces_init(struct ndctl_region *region)
@@ -3154,9 +3144,9 @@ static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath)
 	return sysfs_write_attr(ctx, path, devname);
 }
 
-static int add_btt(void *parent, int id, const char *btt_base);
-static int add_pfn(void *parent, int id, const char *pfn_base);
-static int add_dax(void *parent, int id, const char *dax_base);
+static void *add_btt(void *parent, int id, const char *btt_base);
+static void *add_pfn(void *parent, int id, const char *pfn_base);
+static void *add_dax(void *parent, int id, const char *dax_base);
 
 static void btts_init(struct ndctl_region *region)
 {
@@ -3610,7 +3600,7 @@ static int parse_lbasize_supported(struct ndctl_ctx *ctx, const char *devname,
 	return -ENXIO;
 }
 
-static int add_btt(void *parent, int id, const char *btt_base)
+static void *add_btt(void *parent, int id, const char *btt_base)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(parent);
 	const char *devname = devpath_to_devname(btt_base);
@@ -3618,10 +3608,9 @@ static int add_btt(void *parent, int id, const char *btt_base)
 	struct ndctl_region *region = parent;
 	struct ndctl_btt *btt, *btt_dup;
 	char buf[SYSFS_ATTR_SIZE];
-	int rc = -ENOMEM;
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	btt = calloc(1, sizeof(*btt));
 	if (!btt)
@@ -3647,10 +3636,8 @@ static int add_btt(void *parent, int id, const char *btt_base)
 	sprintf(path, "%s/uuid", btt_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-	if (strlen(buf) && uuid_parse(buf, btt->uuid) < 0) {
-		rc = -EINVAL;
+	if (strlen(buf) && uuid_parse(buf, btt->uuid) < 0)
 		goto err_read;
-	}
 
 	sprintf(path, "%s/sector_size", btt_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -3669,11 +3656,11 @@ static int add_btt(void *parent, int id, const char *btt_base)
 		if (btt->id == btt_dup->id) {
 			btt_dup->size = btt->size;
 			free_btt(btt, NULL);
-			return 1;
+			return btt_dup;
 		}
 
 	list_add(&region->btts, &btt->list);
-	return 0;
+	return btt;
 
  err_read:
 	free(btt->lbasize.supported);
@@ -3682,7 +3669,7 @@ static int add_btt(void *parent, int id, const char *btt_base)
 	free(btt);
  err_btt:
 	free(path);
-	return rc;
+	return NULL;
 }
 
 NDCTL_EXPORT struct ndctl_btt *ndctl_btt_get_first(struct ndctl_region *region)
@@ -3967,16 +3954,15 @@ NDCTL_EXPORT int ndctl_btt_is_configured(struct ndctl_btt *btt)
 	return 0;
 }
 
-static int __add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
+static void *__add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(pfn->region);
 	char *path = calloc(1, strlen(pfn_base) + 100);
 	struct ndctl_region *region = pfn->region;
 	char buf[SYSFS_ATTR_SIZE];
-	int rc = -ENOMEM;
 
 	if (!path)
-		return -ENOMEM;
+		return NULL;
 
 	pfn->generation = region->generation;
 
@@ -3997,10 +3983,8 @@ static int __add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 	sprintf(path, "%s/uuid", pfn_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-	if (strlen(buf) && uuid_parse(buf, pfn->uuid) < 0) {
-		rc = -EINVAL;
+	if (strlen(buf) && uuid_parse(buf, pfn->uuid) < 0)
 		goto err_read;
-	}
 
 	sprintf(path, "%s/mode", pfn_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -4033,30 +4017,28 @@ static int __add_pfn(struct ndctl_pfn *pfn, const char *pfn_base)
 		pfn->size = strtoull(buf, NULL, 0);
 
 	free(path);
-	return 0;
+	return pfn;
 
  err_read:
 	free(pfn->pfn_buf);
 	free(pfn->pfn_path);
 	free(path);
-	return rc;
+	return NULL;
 }
 
-static int add_pfn(void *parent, int id, const char *pfn_base)
+static void *add_pfn(void *parent, int id, const char *pfn_base)
 {
 	struct ndctl_pfn *pfn = calloc(1, sizeof(*pfn)), *pfn_dup;
 	struct ndctl_region *region = parent;
-	int rc;
 
 	if (!pfn)
-		return -ENOMEM;
+		return NULL;
 
 	pfn->id = id;
 	pfn->region = region;
-	rc = __add_pfn(pfn, pfn_base);
-	if (rc < 0) {
+	if (!__add_pfn(pfn, pfn_base)) {
 		free(pfn);
-		return rc;
+		return NULL;
 	}
 
 	ndctl_pfn_foreach(region, pfn_dup)
@@ -4064,30 +4046,28 @@ static int add_pfn(void *parent, int id, const char *pfn_base)
 			pfn_dup->resource = pfn->resource;
 			pfn_dup->size = pfn->size;
 			free_pfn(pfn, NULL);
-			return 1;
+			return pfn_dup;
 		}
 
 	list_add(&region->pfns, &pfn->list);
 
-	return 0;
+	return pfn;
 }
 
-static int add_dax(void *parent, int id, const char *dax_base)
+static void *add_dax(void *parent, int id, const char *dax_base)
 {
 	struct ndctl_dax *dax = calloc(1, sizeof(*dax)), *dax_dup;
 	struct ndctl_region *region = parent;
 	struct ndctl_pfn *pfn = &dax->pfn;
-	int rc;
 
 	if (!dax)
-		return -ENOMEM;
+		return NULL;
 
 	pfn->id = id;
 	pfn->region = region;
-	rc = __add_pfn(pfn, dax_base);
-	if (rc < 0) {
+	if (!__add_pfn(pfn, dax_base)) {
 		free(dax);
-		return rc;
+		return NULL;
 	}
 
 	ndctl_dax_foreach(region, dax_dup) {
@@ -4097,13 +4077,13 @@ static int add_dax(void *parent, int id, const char *dax_base)
 			pfn_dup->resource = pfn->resource;
 			pfn_dup->size = pfn->size;
 			free_dax(dax, NULL);
-			return 1;
+			return dax_dup;
 		}
 	}
 
 	list_add(&region->daxs, &dax->pfn.list);
 
-	return 0;
+	return dax;
 }
 
 NDCTL_EXPORT struct ndctl_pfn *ndctl_pfn_get_first(struct ndctl_region *region)
diff --git a/util/sysfs.c b/util/sysfs.c
index 2b57f3ff30d7..31d1a898eba2 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -98,7 +98,8 @@ int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
 	while ((de = readdir(dir)) != NULL) {
 		char *dev_path;
 		char fmt[20];
-		int id, rc;
+		void *dev;
+		int id;
 
 		sprintf(fmt, "%s%%d", dev_name);
 		if (de->d_ino == 0)
@@ -111,16 +112,14 @@ int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
 			continue;
 		}
 
-		rc = add_dev(parent, id, dev_path);
+		dev = add_dev(parent, id, dev_path);
 		free(dev_path);
-		if (rc < 0) {
+		if (!dev) {
 			add_errors++;
-			log_err(ctx, "%s%d: add_dev() failed: %d\n",
-					dev_name, id, rc);
-		} else if (rc == 0) {
-			log_dbg(ctx, "%s%d: added\n", dev_name, id);
+			log_err(ctx, "%s%d: add_dev() failed\n",
+					dev_name, id);
 		} else
-			log_dbg(ctx, "%s%d: duplicate\n", dev_name, id);
+			log_dbg(ctx, "%s%d: processed\n", dev_name, id);
 	}
 	closedir(dir);
 
diff --git a/util/sysfs.h b/util/sysfs.h
index 6a7b6449adcb..fb169c6da80a 100644
--- a/util/sysfs.h
+++ b/util/sysfs.h
@@ -15,7 +15,7 @@
 
 #include <string.h>
 
-typedef int (*add_dev_fn)(void *parent, int id, const char *dev_path);
+typedef void *(*add_dev_fn)(void *parent, int id, const char *dev_path);
 
 #define SYSFS_ATTR_SIZE 1024
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
