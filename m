Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 885A51A1E12
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:02 -0700 (PDT)
Subject: [ndctl PATCH 2/8] libdaxctl: add daxctl_region_get_available_size()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:38 -0700
Message-ID: <147136809892.27902.4723323881586951882.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Retrieve the available_size attribute for a given dax_region.

As a side effect this rework region->region_path to carry the actual
path without the "dax" class prefix for finding child device-dax
instances.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl-private.h |    3 ++
 daxctl/lib/libdaxctl.c         |   53 ++++++++++++++++++++++++++++++++++------
 daxctl/lib/libdaxctl.sym       |    6 +++++
 daxctl/libdaxctl.h             |    3 ++
 4 files changed, 57 insertions(+), 8 deletions(-)

diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index abd78fd4cc52..a2924f1e93f5 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -18,10 +18,13 @@
 /**
  * struct daxctl_region - container for dax_devices
  */
+#define REGION_BUF_SIZE 50
 struct daxctl_region {
 	int id;
 	uuid_t uuid;
 	int refcount;
+	size_t buf_len;
+	void *region_buf;
 	int devices_init;
 	char *region_path;
 	struct daxctl_ctx *ctx;
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 9d71a2952630..4f6bbc0cd7a6 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -191,10 +191,11 @@ DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 		return;
 
 	ctx = region->ctx;
-	info(ctx, "region%d released\n", region->id);
+	dbg(ctx, "%s: %s\n", __func__, daxctl_region_get_devname(region));
 	list_for_each_safe(&region->devices, dev, _d, list)
 		free_dev(dev, &region->devices);
 	free(region->region_path);
+	free(region->region_buf);
 	free(region);
 }
 
@@ -208,7 +209,6 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
 		int id, uuid_t uuid, const char *path)
 {
 	struct daxctl_region *region;
-	char *region_path;
 
 	region = calloc(1, sizeof(*region));
 	if (!region)
@@ -217,16 +217,18 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
 	region->id = id;
 	region->refcount = 1;
 	uuid_copy(region->uuid, uuid);
-	if (asprintf(&region_path, "%s/dax", path) < 0)
-		region_path = NULL;
-	region->region_path = region_path;
+	region->region_path = strdup(path);
 	list_head_init(&region->devices);
+	region->buf_len = strlen(region->region_path) + REGION_BUF_SIZE;
+	region->region_buf = calloc(1, region->buf_len);
 
-	if (!region->region_path) {
+	if (!region->region_path || !region->region_buf) {
 		daxctl_region_unref(region);
 		region = NULL;
 	}
 
+	dbg(ctx, "%s: %s\n", __func__, daxctl_region_get_devname(region));
+
 	return region;
 }
 
@@ -295,18 +297,53 @@ DAXCTL_EXPORT int daxctl_region_get_id(struct daxctl_region *region)
 	return region->id;
 }
 
+DAXCTL_EXPORT const char *daxctl_region_get_devname(struct daxctl_region *region)
+{
+        return devpath_to_devname(region->region_path);
+}
+
+DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
+		struct daxctl_region *region)
+{
+	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
+	char *path = region->region_buf;
+	char buf[SYSFS_ATTR_SIZE], *end;
+	int len = region->buf_len;
+	unsigned long long avail;
+
+	if (snprintf(path, len, "%s/dax_region/available_size",
+				region->region_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_region_get_devname(region));
+		return 0;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return 0;
+
+	avail = strtoull(buf, &end, 0);
+	if (buf[0] && *end == '\0')
+		return avail;
+	return 0;
+}
+
 static void dax_devices_init(struct daxctl_region *region)
 {
 	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
 	char daxdev_fmt[50];
+	char *region_path;
 
 	if (region->devices_init)
 		return;
 
 	region->devices_init = 1;
 	sprintf(daxdev_fmt, "dax%d.", region->id);
-	sysfs_device_parse(ctx, region->region_path, daxdev_fmt, region,
-			add_dax_dev);
+	if (asprintf(&region_path, "%s/dax", region->region_path) < 0)
+		region_path = NULL;
+	if (region_path)
+		sysfs_device_parse(ctx, region_path, daxdev_fmt, region,
+				add_dax_dev);
+	free(region_path);
 }
 
 DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region)
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index bdf3bd7da9b3..6fb11d8757cf 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -30,3 +30,9 @@ global:
 	daxctl_dev_get_minor;
 	daxctl_dev_get_size;
 } LIBNDCTL_1;
+
+LIBDAXCTL_3 {
+global:
+	daxctl_region_get_available_size;
+	daxctl_region_get_devname;
+} LIBNDCTL_2;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index fbffe8c538b3..ada20ee1e9dd 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -41,6 +41,9 @@ void daxctl_region_unref(struct daxctl_region *region);
 void daxctl_region_get_uuid(struct daxctl_region *region, uuid_t uu);
 int daxctl_region_get_id(struct daxctl_region *region);
 struct daxctl_ctx *daxctl_region_get_ctx(struct daxctl_region *region);
+unsigned long long daxctl_region_get_available_size(
+		struct daxctl_region *region);
+const char *daxctl_region_get_devname(struct daxctl_region *region);
 
 struct daxctl_dev;
 struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
