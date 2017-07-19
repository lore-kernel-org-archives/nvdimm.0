Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F8E821D147CD
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:42 -0700 (PDT)
Subject: [ndctl PATCH 3/6] daxctl: fix support for multiple instances
 per-region id
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:12 -0700
Message-ID: <150048919232.12895.17807760474089186301.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If libnvdimm registers namespace0.0 and namespace0.1 as
device-dax-regions there will be 2 entries in /sys/class/dax, dax0.0 and
dax0.1. However, libdaxctl does not account for the fact that these two
devices are hosted by 2 separate parent devices. Fix this assumption and
create separate regions for each distinct parent that can be enumerated
via /sys/class/dax.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |   52 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 41af6ee92300..0919ea47d817 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -232,7 +232,7 @@ static struct daxctl_region *add_dax_region(void *parent, int id,
 	dbg(ctx, "%s: \'%s\'\n", __func__, base);
 
 	daxctl_region_foreach(ctx, region_dup)
-		if (region_dup->id == id)
+		if (strcmp(region_dup->region_path, base) == 0)
 			return region_dup;
 
 	path = calloc(1, strlen(base) + 100);
@@ -438,20 +438,48 @@ static void dax_devices_init(struct daxctl_region *region)
 
 	region->devices_init = 1;
 	sprintf(daxdev_fmt, "dax%d.", region->id);
-	region_path = strdup(region->region_path);
-	if (region_path) {
-		char *c = strrchr(region_path, '_');
-
-		/* convert <devpath>/dax_region to <devpath>/dax */
-		*c = '\0';
-		sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
-				add_dax_dev);
+	if (asprintf(&region_path, "%s/dax", region->region_path) < 0) {
+		dbg(ctx, "region path alloc fail\n");
+		return;
 	}
+	sysfs_device_parse(ctx, region_path, daxdev_fmt, region, add_dax_dev);
 	free(region_path);
 }
 
+static char *dax_region_path(const char *base, const char *device)
+{
+	char *path, *region_path, *c;
+
+	if (asprintf(&path, "%s/%s", base, device) < 0)
+		return NULL;
+
+	/* dax_region must be the instance's direct parent */
+	region_path = canonicalize_file_name(path);
+	free(path);
+	if (!region_path)
+		return NULL;
+
+	/* 'region_path' is now regionX/dax/daxX.Y', trim back to regionX */
+	c = strrchr(region_path, '/');
+	if (!c) {
+		free(region_path);
+		return NULL;
+	}
+	*c = '\0';
+
+	c = strrchr(region_path, '/');
+	if (!c) {
+		free(region_path);
+		return NULL;
+	}
+	*c = '\0';
+
+	return region_path;
+}
+
 static void dax_regions_init(struct daxctl_ctx *ctx)
 {
+	const char *base = "/sys/class/dax";
 	struct dirent *de;
 	DIR *dir;
 
@@ -460,7 +488,7 @@ static void dax_regions_init(struct daxctl_ctx *ctx)
 
 	ctx->regions_init = 1;
 
-	dir = opendir("/sys/class/dax");
+	dir = opendir(base);
 	if (!dir) {
 		dbg(ctx, "no dax regions found\n");
 		return;
@@ -475,11 +503,11 @@ static void dax_regions_init(struct daxctl_ctx *ctx)
 			continue;
 		if (sscanf(de->d_name, "dax%d.%d", &region_id, &id) != 2)
 			continue;
-		if (asprintf(&dev_path, "/sys/class/dax/%s/device", de->d_name) < 0) {
+		dev_path = dax_region_path(base, de->d_name);
+		if (!dev_path) {
 			err(ctx, "dax region path allocation failure\n");
 			continue;
 		}
-
 		region = add_dax_region(ctx, region_id, dev_path);
 		free(dev_path);
 		if (!region)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
