Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 441AF82081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:39:01 -0800 (PST)
Subject: [ndctl PATCH 3/6] daxctl: add dax region iteration apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:34:52 -0800
Message-ID: <148143809204.11895.2157829231565692211.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add support for generically iterating all the dax regions in the system.
The duplicate device handling code handles any regions that were
'created' with daxctl_new_region() rather than 'scanned' in the daxctl
context.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl-private.h |    3 +
 daxctl/lib/libdaxctl.c         |   93 ++++++++++++++++++++++++++++++++++++----
 daxctl/lib/libdaxctl.sym       |    2 +
 daxctl/libdaxctl.h             |   10 ++++
 ndctl/lib/libndctl-private.h   |    1 
 5 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index 2d17f40b6ea9..f7667324026f 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -28,9 +28,10 @@ struct daxctl_region {
 	void *region_buf;
 	int devices_init;
 	char *region_path;
-	unsigned int align;
+	unsigned long align;
 	unsigned long long size;
 	struct daxctl_ctx *ctx;
+	struct list_node list;
 	struct list_head devices;
 };
 
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index a40a84a3c1bb..019f31b5067c 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <dirent.h>
 #include <unistd.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -39,6 +40,8 @@ struct daxctl_ctx {
 	struct log_ctx ctx;
 	int refcount;
 	void *userdata;
+	int regions_init;
+	struct list_head regions;
 };
 
 /**
@@ -88,6 +91,7 @@ DAXCTL_EXPORT int daxctl_new(struct daxctl_ctx **ctx)
 	info(c, "ctx %p created\n", c);
 	dbg(c, "log_priority=%d\n", c->ctx.log_priority);
 	*ctx = c;
+	list_head_init(&c->regions);
 
 	return 0;
 }
@@ -180,10 +184,23 @@ static void free_dev(struct daxctl_dev *dev, struct list_head *head)
 	free(dev);
 }
 
+static void free_region(struct daxctl_region *region, struct list_head *head)
+{
+	struct daxctl_dev *dev, *_d;
+
+	list_for_each_safe(&region->devices, dev, _d, list)
+		free_dev(dev, &region->devices);
+	if (head)
+		list_del_from(head, &region->list);
+	free(region->region_path);
+	free(region->region_buf);
+	free(region->devname);
+	free(region);
+}
+
 DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 {
 	struct daxctl_ctx *ctx;
-	struct daxctl_dev *dev, *_d;
 
 	if (!region)
 		return;
@@ -193,12 +210,7 @@ DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
 
 	ctx = region->ctx;
 	dbg(ctx, "%s: %s\n", __func__, daxctl_region_get_devname(region));
-	list_for_each_safe(&region->devices, dev, _d, list)
-		free_dev(dev, &region->devices);
-	free(region->region_path);
-	free(region->region_buf);
-	free(region->devname);
-	free(region);
+	free_region(region, &ctx->regions);
 }
 
 DAXCTL_EXPORT void daxctl_region_ref(struct daxctl_region *region)
@@ -209,12 +221,17 @@ DAXCTL_EXPORT void daxctl_region_ref(struct daxctl_region *region)
 
 static void *add_dax_region(void *parent, int id, const char *base)
 {
-	char *path = calloc(1, strlen(base) + 100);
+	struct daxctl_region *region, *region_dup;
 	const char *attrs = "dax_region";
 	struct daxctl_ctx *ctx = parent;
-	struct daxctl_region *region;
 	char buf[SYSFS_ATTR_SIZE];
+	char *path;
+
+	daxctl_region_foreach(ctx, region_dup)
+		if (region_dup->id == id)
+			return region_dup;
 
+	path = calloc(1, strlen(base) + 100);
 	if (!path)
 		return NULL;
 
@@ -248,6 +265,8 @@ static void *add_dax_region(void *parent, int id, const char *base)
 		goto err_read;
 	region->buf_len = strlen(path) + REGION_BUF_SIZE;
 
+	list_add(&ctx->regions, &region->list);
+
 	free(path);
 	return region;
 
@@ -339,7 +358,7 @@ DAXCTL_EXPORT int daxctl_region_get_id(struct daxctl_region *region)
 	return region->id;
 }
 
-DAXCTL_EXPORT unsigned int daxctl_region_get_align(struct daxctl_region *region)
+DAXCTL_EXPORT unsigned long daxctl_region_get_align(struct daxctl_region *region)
 {
 	return region->align;
 }
@@ -426,6 +445,44 @@ static void dax_devices_init(struct daxctl_region *region)
 	free(region_path);
 }
 
+static void dax_regions_init(struct daxctl_ctx *ctx)
+{
+	struct dirent *de;
+	DIR *dir;
+
+	if (ctx->regions_init)
+		return;
+
+	ctx->regions_init = 1;
+
+	dir = opendir("/sys/class/dax");
+	if (!dir) {
+		dbg(ctx, "no dax regions found\n");
+		return;
+	}
+
+	while ((de = readdir(dir)) != NULL) {
+		struct daxctl_region *region;
+		int id, region_id;
+		char *dev_path;
+
+		if (de->d_ino == 0)
+			continue;
+		if (sscanf(de->d_name, "dax%d.%d", &region_id, &id) != 2)
+			continue;
+		if (asprintf(&dev_path, "/sys/class/dax/%s/device", de->d_name) < 0) {
+			err(ctx, "dax region path allocation failure\n");
+			continue;
+		}
+
+		region = add_dax_region(ctx, region_id, dev_path);
+		free(dev_path);
+		if (!region)
+			err(ctx, "add_dax_region() for %s failed\n", de->d_name);
+	}
+	closedir(dir);
+}
+
 DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region)
 {
 	dax_devices_init(region);
@@ -440,6 +497,22 @@ DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_next(struct daxctl_dev *dev)
 	return list_next(&region->devices, dev, list);
 }
 
+DAXCTL_EXPORT struct daxctl_region *daxctl_region_get_first(
+		struct daxctl_ctx *ctx)
+{
+	dax_regions_init(ctx);
+
+	return list_top(&ctx->regions, struct daxctl_region, list);
+}
+
+DAXCTL_EXPORT struct daxctl_region *daxctl_region_get_next(
+		struct daxctl_region *region)
+{
+	struct daxctl_ctx *ctx = region->ctx;
+
+	return list_next(&ctx->regions, region, list);
+}
+
 DAXCTL_EXPORT struct daxctl_region *daxctl_dev_get_region(struct daxctl_dev *dev)
 {
 	return dev->region;
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index eef97f2546c0..1b1104dbe74c 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -42,4 +42,6 @@ LIBDAXCTL_4 {
 global:
 	daxctl_region_get_size;
 	daxctl_region_get_align;
+	daxctl_region_get_first;
+	daxctl_region_get_next;
 } LIBDAXCTL_3;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 42ed15b508e5..071cb1b17e6e 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -36,6 +36,8 @@ void *daxctl_get_userdata(struct daxctl_ctx *ctx);
 struct daxctl_region;
 struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id,
 		uuid_t uuid, const char *path);
+struct daxctl_region *daxctl_region_get_first(struct daxctl_ctx *ctx);
+struct daxctl_region *daxctl_region_get_next(struct daxctl_region *region);
 void daxctl_region_ref(struct daxctl_region *region);
 void daxctl_region_unref(struct daxctl_region *region);
 void daxctl_region_get_uuid(struct daxctl_region *region, uuid_t uu);
@@ -44,7 +46,7 @@ struct daxctl_ctx *daxctl_region_get_ctx(struct daxctl_region *region);
 unsigned long long daxctl_region_get_available_size(
 		struct daxctl_region *region);
 unsigned long long daxctl_region_get_size(struct daxctl_region *region);
-unsigned int daxctl_region_get_align(struct daxctl_region *region);
+unsigned long daxctl_region_get_align(struct daxctl_region *region);
 const char *daxctl_region_get_devname(struct daxctl_region *region);
 struct daxctl_dev *daxctl_region_get_dev_seed(struct daxctl_region *region);
 
@@ -63,6 +65,12 @@ unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
              dev != NULL; \
              dev = daxctl_dev_get_next(dev))
 
+
+#define daxctl_region_foreach(ctx, region) \
+        for (region = daxctl_region_get_first(ctx); \
+             region != NULL; \
+             region = daxctl_region_get_next(region))
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 050431850c66..778dbb508ead 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -135,6 +135,7 @@ struct ndctl_ctx {
 	/* log_ctx must be first member for ndctl_set_log_fn compat */
 	struct log_ctx ctx;
 	int refcount;
+	int regions_init;
 	void *userdata;
 	struct list_head busses;
 	int busses_init;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
