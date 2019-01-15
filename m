Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93DA2211B63CA
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 20:37:13 -0800 (PST)
Subject: [daxctl PATCH v2 1/2] daxctl: Support the /sys/bus/dax ABI
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 20:24:36 -0800
Message-ID: <154752627642.1710673.17923183512691145854.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154752627111.1710673.1469336464670065810.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154752627111.1710673.1469336464670065810.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The kernel is implementing a '/sys/bus/dax' ABI to allow for alternate
device-DAX drivers to be bound to device instances.  In support of this
conversion, teach the libdaxctl subsystem-layout-specific code to parse
the new layout.

For backwards compatibility the implementation transparently and
optionally supports either '/sys/bus/dax' or '/sys/class/dax'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl-private.h |   11 ++++++
 daxctl/lib/libdaxctl.c         |   70 +++++++++++++++++++++++++++++-----------
 util/sysfs.c                   |    2 +
 3 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index f7667324026f..4a462e7245d2 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -15,6 +15,17 @@
 
 #define DAXCTL_EXPORT __attribute__ ((visibility("default")))
 
+enum dax_subsystem {
+	DAX_UNKNOWN,
+	DAX_CLASS,
+	DAX_BUS,
+};
+
+static const char *dax_subsystems[] = {
+	[DAX_CLASS] = "/sys/class/dax",
+	[DAX_BUS] = "/sys/bus/dax/devices",
+};
+
 /**
  * struct daxctl_region - container for dax_devices
  */
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 22f4210a7ea0..c2e3a52d6c7c 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -444,26 +444,38 @@ static void dax_devices_init(struct daxctl_region *region)
 {
 	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
 	char daxdev_fmt[50];
-	char *region_path;
+	size_t i;
 
 	if (region->devices_init)
 		return;
 
 	region->devices_init = 1;
 	sprintf(daxdev_fmt, "dax%d.", region->id);
-	if (asprintf(&region_path, "%s/dax", region->region_path) < 0) {
-		dbg(ctx, "region path alloc fail\n");
-		return;
+	for (i = 0; i < ARRAY_SIZE(dax_subsystems); i++) {
+		char *region_path;
+
+		if (i == DAX_BUS)
+			region_path = region->region_path;
+		else if (i == DAX_CLASS) {
+			if (asprintf(&region_path, "%s/dax",
+						region->region_path) < 0) {
+				dbg(ctx, "region path alloc fail\n");
+				continue;
+			}
+		} else
+			continue;
+		sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
+				add_dax_dev);
+		if (i == DAX_CLASS)
+			free(region_path);
 	}
-	sysfs_device_parse(ctx, region_path, daxdev_fmt, region, add_dax_dev);
-	free(region_path);
 }
 
-static char *dax_region_path(const char *base, const char *device)
+static char *dax_region_path(const char *device, enum dax_subsystem subsys)
 {
 	char *path, *region_path, *c;
 
-	if (asprintf(&path, "%s/%s", base, device) < 0)
+	if (asprintf(&path, "%s/%s", dax_subsystems[subsys], device) < 0)
 		return NULL;
 
 	/* dax_region must be the instance's direct parent */
@@ -472,7 +484,11 @@ static char *dax_region_path(const char *base, const char *device)
 	if (!region_path)
 		return NULL;
 
-	/* 'region_path' is now regionX/dax/daxX.Y', trim back to regionX */
+	/*
+	 * 'region_path' is now regionX/dax/daxX.Y' (DAX_CLASS), or
+	 * regionX/daxX.Y (DAX_BUS), trim it back to the regionX
+	 * component
+	 */
 	c = strrchr(region_path, '/');
 	if (!c) {
 		free(region_path);
@@ -480,6 +496,9 @@ static char *dax_region_path(const char *base, const char *device)
 	}
 	*c = '\0';
 
+	if (subsys == DAX_BUS)
+		return region_path;
+
 	c = strrchr(region_path, '/');
 	if (!c) {
 		free(region_path);
@@ -490,20 +509,15 @@ static char *dax_region_path(const char *base, const char *device)
 	return region_path;
 }
 
-static void dax_regions_init(struct daxctl_ctx *ctx)
+static void __dax_regions_init(struct daxctl_ctx *ctx, enum dax_subsystem subsys)
 {
-	const char *base = "/sys/class/dax";
 	struct dirent *de;
-	DIR *dir;
+	DIR *dir = NULL;
 
-	if (ctx->regions_init)
-		return;
-
-	ctx->regions_init = 1;
-
-	dir = opendir(base);
+	dir = opendir(dax_subsystems[subsys]);
 	if (!dir) {
-		dbg(ctx, "no dax regions found\n");
+		dbg(ctx, "no dax regions found via: %s\n",
+				dax_subsystems[subsys]);
 		return;
 	}
 
@@ -516,7 +530,7 @@ static void dax_regions_init(struct daxctl_ctx *ctx)
 			continue;
 		if (sscanf(de->d_name, "dax%d.%d", &region_id, &id) != 2)
 			continue;
-		dev_path = dax_region_path(base, de->d_name);
+		dev_path = dax_region_path(de->d_name, subsys);
 		if (!dev_path) {
 			err(ctx, "dax region path allocation failure\n");
 			continue;
@@ -529,6 +543,22 @@ static void dax_regions_init(struct daxctl_ctx *ctx)
 	closedir(dir);
 }
 
+static void dax_regions_init(struct daxctl_ctx *ctx)
+{
+	size_t i;
+
+	if (ctx->regions_init)
+		return;
+
+	ctx->regions_init = 1;
+
+	for (i = 0; i < ARRAY_SIZE(dax_subsystems); i++) {
+		if (i == DAX_UNKNOWN)
+			continue;
+		__dax_regions_init(ctx, i);
+	}
+}
+
 DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region)
 {
 	dax_devices_init(region);
diff --git a/util/sysfs.c b/util/sysfs.c
index 0440fd0f49a3..9f7bc1f4930f 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -91,7 +91,7 @@ int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
 	struct dirent *de;
 	DIR *dir;
 
-	log_dbg(ctx, "base: %s dev: %s\n", base_path, dev_name);
+	log_dbg(ctx, "base: '%s' dev: '%s'\n", base_path, dev_name);
 	dir = opendir(base_path);
 	if (!dir) {
 		log_dbg(ctx, "no \"%s\" devices found\n", dev_name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
