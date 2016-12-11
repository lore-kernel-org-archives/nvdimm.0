Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBE3082081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:38:55 -0800 (PST)
Subject: [ndctl PATCH 2/6] libdaxctl: add daxctl_region_get_{id, size,
 align} apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:34:46 -0800
Message-ID: <148143808682.11895.3625276610774731857.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Retrieve the basic geometry and identification attributes of a region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl-private.h |    3 +
 daxctl/lib/libdaxctl.c         |   93 +++++++++++++++++++++++++++++++---------
 daxctl/lib/libdaxctl.sym       |   14 ++++--
 daxctl/libdaxctl.h             |    2 +
 4 files changed, 87 insertions(+), 25 deletions(-)

diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index a2924f1e93f5..2d17f40b6ea9 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -23,10 +23,13 @@ struct daxctl_region {
 	int id;
 	uuid_t uuid;
 	int refcount;
+	char *devname;
 	size_t buf_len;
 	void *region_buf;
 	int devices_init;
 	char *region_path;
+	unsigned int align;
+	unsigned long long size;
 	struct daxctl_ctx *ctx;
 	struct list_head devices;
 };
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 06605de85fc3..a40a84a3c1bb 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -197,6 +197,7 @@ DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 		free_dev(dev, &region->devices);
 	free(region->region_path);
 	free(region->region_buf);
+	free(region->devname);
 	free(region);
 }
 
@@ -206,32 +207,68 @@ DAXCTL_EXPORT void daxctl_region_ref(struct daxctl_region *region)
 		region->refcount++;
 }
 
-DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
-		int id, uuid_t uuid, const char *path)
+static void *add_dax_region(void *parent, int id, const char *base)
 {
+	char *path = calloc(1, strlen(base) + 100);
+	const char *attrs = "dax_region";
+	struct daxctl_ctx *ctx = parent;
 	struct daxctl_region *region;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (!path)
+		return NULL;
 
 	region = calloc(1, sizeof(*region));
 	if (!region)
-		return NULL;
-	region->ctx = ctx;
+		goto err_region;
+
 	region->id = id;
+	region->align = -1;
+	region->size = -1;
+	region->ctx = ctx;
 	region->refcount = 1;
-	uuid_copy(region->uuid, uuid);
+	list_head_init(&region->devices);
+	region->devname = strdup(devpath_to_devname(base));
 
+	sprintf(path, "%s/%s/size", base, attrs);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		region->size = strtoull(buf, NULL, 0);
+
+	sprintf(path, "%s/%s/align", base, attrs);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		region->align = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/%s", base, attrs);
 	region->region_path = strdup(path);
-	if (!region->region_path) {
-		free(region);
-		return NULL;
-	}
+	if (!region->region_path)
+		goto err_read;
 
-	list_head_init(&region->devices);
-	region->buf_len = strlen(region->region_path) + REGION_BUF_SIZE;
-	region->region_buf = calloc(1, region->buf_len);
-	if (!region->region_buf) {
-		daxctl_region_unref(region);
+	region->region_buf = calloc(1, strlen(path) + REGION_BUF_SIZE);
+	if (!region->region_buf)
+		goto err_read;
+	region->buf_len = strlen(path) + REGION_BUF_SIZE;
+
+	free(path);
+	return region;
+
+ err_read:
+	free(region->region_buf);
+	free(region->region_path);
+	free(region);
+ err_region:
+	free(path);
+	return NULL;
+}
+
+DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
+		int id, uuid_t uuid, const char *path)
+{
+	struct daxctl_region *region;
+
+	region = add_dax_region(ctx, id, path);
+	if (!region)
 		return NULL;
-	}
+	uuid_copy(region->uuid, uuid);
 
 	dbg(ctx, "%s: %s\n", __func__, daxctl_region_get_devname(region));
 
@@ -302,9 +339,19 @@ DAXCTL_EXPORT int daxctl_region_get_id(struct daxctl_region *region)
 	return region->id;
 }
 
+DAXCTL_EXPORT unsigned int daxctl_region_get_align(struct daxctl_region *region)
+{
+	return region->align;
+}
+
+DAXCTL_EXPORT unsigned long long daxctl_region_get_size(struct daxctl_region *region)
+{
+	return region->size;
+}
+
 DAXCTL_EXPORT const char *daxctl_region_get_devname(struct daxctl_region *region)
 {
-        return devpath_to_devname(region->region_path);
+	return region->devname;
 }
 
 DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
@@ -316,7 +363,7 @@ DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
 	int len = region->buf_len;
 	unsigned long long avail;
 
-	if (snprintf(path, len, "%s/dax_region/available_size",
+	if (snprintf(path, len, "%s/available_size",
 				region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				daxctl_region_get_devname(region));
@@ -341,7 +388,7 @@ DAXCTL_EXPORT struct daxctl_dev *daxctl_region_get_dev_seed(
 	char buf[SYSFS_ATTR_SIZE];
 	struct daxctl_dev *dev;
 
-	if (snprintf(path, len, "%s/dax_region/seed", region->region_path) >= len) {
+	if (snprintf(path, len, "%s/seed", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				daxctl_region_get_devname(region));
 		return NULL;
@@ -367,11 +414,15 @@ static void dax_devices_init(struct daxctl_region *region)
 
 	region->devices_init = 1;
 	sprintf(daxdev_fmt, "dax%d.", region->id);
-	if (asprintf(&region_path, "%s/dax", region->region_path) < 0)
-		region_path = NULL;
-	if (region_path)
+	region_path = strdup(region->region_path);
+	if (region_path) {
+		char *c = strrchr(region_path, '_');
+
+		/* convert <devpath>/dax_region to <devpath>/dax */
+		*c = '\0';
 		sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
 				add_dax_dev);
+	}
 	free(region_path);
 }
 
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index e74d75bf7847..eef97f2546c0 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -1,4 +1,4 @@
-LIBNDCTL_1 {
+LIBDAXCTL_1 {
 global:
 	daxctl_get_userdata;
 	daxctl_set_userdata;
@@ -12,7 +12,7 @@ local:
         *;
 };
 
-LIBNDCTL_2 {
+LIBDAXCTL_2 {
 global:
 	daxctl_region_unref;
 	daxctl_new_region;
@@ -29,11 +29,17 @@ global:
 	daxctl_dev_get_major;
 	daxctl_dev_get_minor;
 	daxctl_dev_get_size;
-} LIBNDCTL_1;
+} LIBDAXCTL_1;
 
 LIBDAXCTL_3 {
 global:
 	daxctl_region_get_available_size;
 	daxctl_region_get_devname;
 	daxctl_region_get_dev_seed;
-} LIBNDCTL_2;
+} LIBDAXCTL_2;
+
+LIBDAXCTL_4 {
+global:
+	daxctl_region_get_size;
+	daxctl_region_get_align;
+} LIBDAXCTL_3;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index bb7aa363a605..42ed15b508e5 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -43,6 +43,8 @@ int daxctl_region_get_id(struct daxctl_region *region);
 struct daxctl_ctx *daxctl_region_get_ctx(struct daxctl_region *region);
 unsigned long long daxctl_region_get_available_size(
 		struct daxctl_region *region);
+unsigned long long daxctl_region_get_size(struct daxctl_region *region);
+unsigned int daxctl_region_get_align(struct daxctl_region *region);
 const char *daxctl_region_get_devname(struct daxctl_region *region);
 struct daxctl_dev *daxctl_region_get_dev_seed(struct daxctl_region *region);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
