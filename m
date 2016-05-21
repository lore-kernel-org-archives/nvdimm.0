Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 689611A1E1F
 for <linux-nvdimm@lists.01.org>; Sat, 21 May 2016 14:56:36 -0700 (PDT)
Subject: [ndctl PATCH 5/5] daxctl: enumeration api and unit test for "Device
 DAX"
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 May 2016 14:55:36 -0700
Message-ID: <146386773613.1884.10450413011419439850.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146386771020.1884.14405221977201209581.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Sub-systems like libnvdimm register a memory region with the kernel's
dax core which can then sub-divide the region into individual dax
devices.

Given that nfit_test devices do not support dax mappings the unit test
only verifies device dax creation, enumeration, and autodetect.

A notable difference from the ndctl api, the daxctl api is not able to
enumerate all dax-regions independently.  Instead it is a helper library
to instantiate a dax region once one has been found by libndctl, or any
other library that knows the details of the parent device for
/sys/class/dax devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/Makefile.am             |    2 
 daxctl/lib/libdaxctl-private.h |   22 ++
 daxctl/lib/libdaxctl.c         |  199 ++++++++++++++++
 daxctl/lib/libdaxctl.sym       |   19 ++
 daxctl/libdaxctl.h             |   24 ++
 ndctl/Makefile.am              |   17 +
 ndctl/lib/libndctl-private.h   |    1 
 ndctl/lib/libndctl.c           |   36 +++
 ndctl/lib/libndctl.sym         |    2 
 ndctl/libndctl.h.in            |    3 
 test/Makefile.am               |    4 
 test/libndctl.c                |  498 ++++++++++++++++++++++++++++++++++------
 util/sysfs.c                   |    1 
 13 files changed, 741 insertions(+), 87 deletions(-)

diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index a2aea16460a0..ed6d2ff51447 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -9,6 +9,8 @@ lib_LTLIBRARIES = lib/libdaxctl.la
 lib_libdaxctl_la_SOURCES =\
 	libdaxctl.h \
 	lib/libdaxctl-private.h \
+	../util/sysfs.c \
+	../util/sysfs.h \
 	../util/log.c \
 	../util/log.h \
 	lib/libdaxctl.c
diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index aef95d4aedd4..abd78fd4cc52 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -15,4 +15,26 @@
 
 #define DAXCTL_EXPORT __attribute__ ((visibility("default")))
 
+/**
+ * struct daxctl_region - container for dax_devices
+ */
+struct daxctl_region {
+	int id;
+	uuid_t uuid;
+	int refcount;
+	int devices_init;
+	char *region_path;
+	struct daxctl_ctx *ctx;
+	struct list_head devices;
+};
+
+struct daxctl_dev {
+	int id, major, minor;
+	void *dev_buf;
+	size_t buf_len;
+	char *dev_path;
+	struct list_node list;
+	unsigned long long size;
+	struct daxctl_region *region;
+};
 #endif /* _LIBDAXCTL_PRIVATE_H_ */
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 41c536c14642..a8ad58d58b81 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -13,11 +13,15 @@
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
-#include <util/log.h>
+#include <unistd.h>
+#include <sys/stat.h>
+#include <sys/types.h>
 #include <uuid/uuid.h>
 #include <ccan/list/list.h>
 #include <ccan/array_size/array_size.h>
 
+#include <util/log.h>
+#include <util/sysfs.h>
 #include <daxctl/libdaxctl.h>
 #include "libdaxctl-private.h"
 
@@ -154,3 +158,196 @@ DAXCTL_EXPORT void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority)
 {
 	ctx->ctx.log_priority = priority;
 }
+
+DAXCTL_EXPORT struct daxctl_ctx *daxctl_region_get_ctx(
+		struct daxctl_region *region)
+{
+	return region->ctx;
+}
+
+DAXCTL_EXPORT void daxctl_region_get_uuid(struct daxctl_region *region, uuid_t uu)
+{
+	uuid_copy(uu, region->uuid);
+}
+
+static void free_dev(struct daxctl_dev *dev, struct list_head *head)
+{
+	if (head)
+		list_del_from(head, &dev->list);
+	free(dev->dev_buf);
+	free(dev->dev_path);
+	free(dev);
+}
+
+DAXCTL_EXPORT void daxctl_region_unref(struct daxctl_region *region)
+{
+	struct daxctl_ctx *ctx = region->ctx;
+	struct daxctl_dev *dev, *_d;
+
+	if (!region)
+		return;
+	region->refcount--;
+	if (region->refcount)
+		return;
+
+	info(ctx, "region%d released\n", region->id);
+	list_for_each_safe(&region->devices, dev, _d, list)
+		free_dev(dev, &region->devices);
+	free(region->region_path);
+	free(region);
+}
+
+DAXCTL_EXPORT void daxctl_region_ref(struct daxctl_region *region)
+{
+	if (region)
+		region->refcount++;
+}
+
+DAXCTL_EXPORT struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx,
+		int id, uuid_t uuid, const char *path)
+{
+	struct daxctl_region *region;
+	char *region_path;
+
+	region = calloc(1, sizeof(*region));
+	if (!region)
+		return NULL;
+	region->ctx = ctx;
+	region->id = id;
+	region->refcount = 1;
+	uuid_copy(region->uuid, uuid);
+	if (asprintf(&region_path, "%s/dax", path) < 0)
+		region_path = NULL;
+	region->region_path = region_path;
+	list_head_init(&region->devices);
+
+	if (!region->region_path) {
+		daxctl_region_unref(region);
+		region = NULL;
+	}
+
+	return region;
+}
+
+static int add_dax_dev(void *parent, int id, const char *daxdev_base)
+{
+	const char *devname = devpath_to_devname(daxdev_base);
+	char *path = calloc(1, strlen(daxdev_base) + 100);
+	struct daxctl_region *region = parent;
+	struct daxctl_ctx *ctx = region->ctx;
+	struct daxctl_dev *dev, *dev_dup;
+	char buf[SYSFS_ATTR_SIZE];
+	int rc = -ENOMEM;
+	struct stat st;
+
+	if (!path)
+		return -ENOMEM;
+
+	dev = calloc(1, sizeof(*dev));
+	if (!dev)
+		goto err_dev;
+	dev->id = id;
+	dev->region = region;
+
+	sprintf(path, "/dev/%s", devname);
+	if (stat(path, &st) < 0)
+		goto err_read;
+	dev->major = major(st.st_rdev);
+	dev->minor = minor(st.st_rdev);
+
+	sprintf(path, "%s/size", daxdev_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err_read;
+	dev->size = strtoull(buf, NULL, 0);
+
+	dev->dev_path = strdup(daxdev_base);
+	if (!dev->dev_path)
+		goto err_read;
+
+	dev->dev_buf = calloc(1, strlen(daxdev_base) + 50);
+	if (!dev->dev_buf)
+		goto err_read;
+	dev->buf_len = strlen(daxdev_base) + 50;
+
+	daxctl_dev_foreach(region, dev_dup)
+		if (dev_dup->id == dev->id) {
+			free_dev(dev, NULL);
+			free(path);
+			return 1;
+		}
+
+	list_add(&region->devices, &dev->list);
+	free(path);
+	return 0;
+
+ err_read:
+	free(dev->dev_buf);
+	free(dev->dev_path);
+	free(dev);
+ err_dev:
+	free(path);
+	return rc;
+}
+
+DAXCTL_EXPORT int daxctl_region_get_id(struct daxctl_region *region)
+{
+	return region->id;
+}
+
+static void dax_devices_init(struct daxctl_region *region)
+{
+	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
+	char daxdev_fmt[50];
+
+	if (region->devices_init)
+		return;
+
+	region->devices_init = 1;
+	sprintf(daxdev_fmt, "dax%d.", region->id);
+	sysfs_device_parse(ctx, region->region_path, daxdev_fmt, region,
+			add_dax_dev);
+}
+
+DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region)
+{
+	dax_devices_init(region);
+
+	return list_top(&region->devices, struct daxctl_dev, list);
+}
+
+DAXCTL_EXPORT struct daxctl_dev *daxctl_dev_get_next(struct daxctl_dev *dev)
+{
+	struct daxctl_region *region = dev->region;
+
+	return list_next(&region->devices, dev, list);
+}
+
+DAXCTL_EXPORT struct daxctl_region *daxctl_dev_get_region(struct daxctl_dev *dev)
+{
+	return dev->region;
+}
+
+DAXCTL_EXPORT int daxctl_dev_get_id(struct daxctl_dev *dev)
+{
+	return dev->id;
+}
+
+DAXCTL_EXPORT const char *daxctl_dev_get_devname(struct daxctl_dev *dev)
+{
+	return devpath_to_devname(dev->dev_path);
+}
+
+DAXCTL_EXPORT int daxctl_dev_get_major(struct daxctl_dev *dev)
+{
+	return dev->major;
+}
+
+DAXCTL_EXPORT int daxctl_dev_get_minor(struct daxctl_dev *dev)
+{
+	return dev->minor;
+}
+
+DAXCTL_EXPORT unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev)
+{
+	return dev->size;
+}
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 7583ed2876a1..bdf3bd7da9b3 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -11,3 +11,22 @@ global:
 local:
         *;
 };
+
+LIBNDCTL_2 {
+global:
+	daxctl_region_unref;
+	daxctl_new_region;
+	daxctl_region_ref;
+	daxctl_region_unref;
+	daxctl_region_get_uuid;
+	daxctl_region_get_id;
+	daxctl_region_get_ctx;
+	daxctl_dev_get_first;
+	daxctl_dev_get_next;
+	daxctl_dev_get_region;
+	daxctl_dev_get_id;
+	daxctl_dev_get_devname;
+	daxctl_dev_get_major;
+	daxctl_dev_get_minor;
+	daxctl_dev_get_size;
+} LIBNDCTL_1;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 5b9325314108..fbffe8c538b3 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -33,6 +33,30 @@ void daxctl_set_log_priority(struct daxctl_ctx *ctx, int priority);
 void daxctl_set_userdata(struct daxctl_ctx *ctx, void *userdata);
 void *daxctl_get_userdata(struct daxctl_ctx *ctx);
 
+struct daxctl_region;
+struct daxctl_region *daxctl_new_region(struct daxctl_ctx *ctx, int id,
+		uuid_t uuid, const char *path);
+void daxctl_region_ref(struct daxctl_region *region);
+void daxctl_region_unref(struct daxctl_region *region);
+void daxctl_region_get_uuid(struct daxctl_region *region, uuid_t uu);
+int daxctl_region_get_id(struct daxctl_region *region);
+struct daxctl_ctx *daxctl_region_get_ctx(struct daxctl_region *region);
+
+struct daxctl_dev;
+struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region);
+struct daxctl_dev *daxctl_dev_get_next(struct daxctl_dev *dev);
+struct daxctl_region *daxctl_dev_get_region(struct daxctl_dev *dev);
+int daxctl_dev_get_id(struct daxctl_dev *dev);
+const char *daxctl_dev_get_devname(struct daxctl_dev *dev);
+int daxctl_dev_get_major(struct daxctl_dev *dev);
+int daxctl_dev_get_minor(struct daxctl_dev *dev);
+unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
+
+#define daxctl_dev_foreach(region, dev) \
+        for (dev = daxctl_dev_get_first(region); \
+             dev != NULL; \
+             dev = daxctl_dev_get_next(dev))
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 1e7df1da97de..c70133e762d5 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -49,13 +49,6 @@ if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
 endif
 
-if ENABLE_TEST
-ndctl_SOURCES += ../test/libndctl.c \
-		 ../test/dpa-alloc.c \
-		 ../test/parent-uuid.c \
-		 ../test/core.c
-endif
-
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
 		 ../test/pmem_namespaces.c \
@@ -70,6 +63,16 @@ ndctl_LDADD =\
 	$(KMOD_LIBS) \
 	$(JSON_LIBS)
 
+if ENABLE_TEST
+ndctl_SOURCES += ../test/libndctl.c \
+		 ../test/dpa-alloc.c \
+		 ../test/parent-uuid.c \
+		 ../test/core.c
+ndctl_LDADD += ../daxctl/lib/libdaxctl.la
+endif
+
+
+
 EXTRA_DIST += lib/libndctl.sym
 
 lib_libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 604062abc9ad..65ef86d044f2 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -140,6 +140,7 @@ struct ndctl_ctx {
 	struct udev *udev;
 	struct udev_queue *udev_queue;
 	struct kmod_ctx *kmod_ctx;
+	struct daxctl_ctx *daxctl_ctx;
 	unsigned long timeout;
 };
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index e587fdd17d1b..6860a4b6fa92 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -36,6 +36,7 @@
 
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
 #include "libndctl-private.h"
 
 static uuid_t null_uuid;
@@ -319,6 +320,7 @@ struct ndctl_pfn {
 
 struct ndctl_dax {
 	struct ndctl_pfn pfn;
+	struct daxctl_region *region;
 };
 
 /**
@@ -357,6 +359,7 @@ NDCTL_EXPORT void ndctl_set_userdata(struct ndctl_ctx *ctx, void *userdata)
  */
 NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 {
+	struct daxctl_ctx *daxctl_ctx;
 	struct kmod_ctx *kmod_ctx;
 	struct ndctl_ctx *c;
 	struct udev *udev;
@@ -373,6 +376,10 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 		goto err_kmod;
 	}
 
+	rc = daxctl_new(&daxctl_ctx);
+	if (rc)
+		goto err_daxctl;
+
 	c = calloc(1, sizeof(struct ndctl_ctx));
 	if (!c) {
 		rc = -ENOMEM;
@@ -408,15 +415,23 @@ NDCTL_EXPORT int ndctl_new(struct ndctl_ctx **ctx)
 	}
 
 	c->kmod_ctx = kmod_ctx;
+	c->daxctl_ctx = daxctl_ctx;
 
 	return 0;
  err_ctx:
+	daxctl_unref(daxctl_ctx);
+ err_daxctl:
 	kmod_unref(kmod_ctx);
  err_kmod:
 	udev_unref(udev);
 	return rc;
 }
 
+NDCTL_EXPORT struct daxctl_ctx *ndctl_get_daxctl_ctx(struct ndctl_ctx *ctx)
+{
+	return ctx->daxctl_ctx;
+}
+
 /**
  * ndctl_ref - take an additional reference on the context
  * @ctx: context established by ndctl_new()
@@ -621,6 +636,7 @@ NDCTL_EXPORT struct ndctl_ctx *ndctl_unref(struct ndctl_ctx *ctx)
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
+	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
 	free_context(ctx);
 	return NULL;
@@ -4477,3 +4493,23 @@ NDCTL_EXPORT int ndctl_dax_is_configured(struct ndctl_dax *dax)
 {
 	return ndctl_pfn_is_configured(&dax->pfn);
 }
+
+NDCTL_EXPORT struct daxctl_region *ndctl_dax_get_daxctl_region(
+		struct ndctl_dax *dax)
+{
+	struct ndctl_ctx *ctx = ndctl_dax_get_ctx(dax);
+	struct ndctl_region *region;
+	uuid_t uuid;
+	int id;
+
+	if (dax->region)
+		return dax->region;
+	region = ndctl_dax_get_region(dax);
+
+	id = ndctl_region_get_id(region);
+	ndctl_dax_get_uuid(dax, uuid);
+	dax->region = daxctl_new_region(ctx->daxctl_ctx, id, uuid,
+			dax->pfn.pfn_path);
+
+	return dax->region;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index d5b0ab624aaa..a22732467f8a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -11,6 +11,7 @@ global:
 	ndctl_unref;
 	ndctl_set_log_priority;
 	ndctl_new;
+	ndctl_get_daxctl_ctx;
 	ndctl_invalidate;
 local:
         *;
@@ -261,4 +262,5 @@ global:
 	ndctl_dax_enable;
 	ndctl_dax_delete;
 	ndctl_dax_is_configured;
+	ndctl_dax_get_daxctl_region;
 } LIBNDCTL_1;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 6a7510964ae2..e6766cef56bb 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -77,6 +77,8 @@ struct ndctl_ctx;
 struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx);
 struct ndctl_ctx *ndctl_unref(struct ndctl_ctx *ctx);
 int ndctl_new(struct ndctl_ctx **ctx);
+struct daxctl_ctx;
+struct daxctl_ctx *ndctl_get_daxctl_ctx(struct ndctl_ctx *ctx);
 void ndctl_invalidate(struct ndctl_ctx *ctx);
 void ndctl_set_log_fn(struct ndctl_ctx *ctx,
                   void (*log_fn)(struct ndctl_ctx *ctx,
@@ -603,6 +605,7 @@ struct ndctl_region *ndctl_dax_get_region(struct ndctl_dax *dax);
 int ndctl_dax_enable(struct ndctl_dax *dax);
 int ndctl_dax_delete(struct ndctl_dax *dax);
 int ndctl_dax_is_configured(struct ndctl_dax *dax);
+struct daxctl_region *ndctl_dax_get_daxctl_region(struct ndctl_dax *dax);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/test/Makefile.am b/test/Makefile.am
index 62c13146eb78..ad10caa439bf 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -32,7 +32,9 @@ check_PROGRAMS +=\
 	mmap
 endif
 
-LIBNDCTL_LIB = ../ndctl/lib/libndctl.la
+LIBNDCTL_LIB =\
+       ../ndctl/lib/libndctl.la \
+       ../daxctl/lib/libdaxctl.la
 
 libndctl_SOURCES = libndctl.c core.c
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
diff --git a/test/libndctl.c b/test/libndctl.c
index 16072fbc8819..147f69d0c27a 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -27,6 +27,7 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
+#include <daxctl/libdaxctl.h>
 #ifdef HAVE_NDCTL_H
 #include <linux/ndctl.h>
 #else
@@ -170,6 +171,13 @@ struct pfn {
 	unsigned long aligns[4];
 };
 
+struct dax {
+	int enabled;
+	uuid_t uuid;
+	enum ndctl_pfn_loc locs[2];
+	unsigned long aligns[4];
+};
+
 static struct pfn_default {
 	int enabled;
 	uuid_t uuid;
@@ -219,11 +227,22 @@ static struct pfn pfn_settings = {
 	.aligns = { 1, SZ_1G, SZ_4K, SZ_2M, },
 };
 
+static struct dax dax_settings = {
+	.enabled = 1,
+	.uuid = {  1,  2,  3,  4,  5,  6,  7, 0,
+		   8, 9,  10, 11, 12, 13, 14, 15
+	},
+	.locs = { NDCTL_PFN_LOC_RAM, NDCTL_PFN_LOC_PMEM },
+	/* order matters, successful aligns at the end */
+	.aligns = { 1, SZ_1G, SZ_4K, SZ_2M, },
+};
+
 struct namespace {
 	unsigned int id;
 	char *type;
 	struct btt *btt_settings;
 	struct pfn *pfn_settings;
+	struct dax *dax_settings;
 	unsigned long long size;
 	uuid_t uuid;
 	int do_configure;
@@ -238,7 +257,7 @@ static unsigned long blk_sector_sizes[7] = { 512, 520, 528, 4096, 4104, 4160, 42
 static unsigned long pmem_sector_sizes[1] = { 0 };
 
 static struct namespace namespace0_pmem0 = {
-	0, "namespace_pmem", &btt_settings, &pfn_settings, SZ_18M,
+	0, "namespace_pmem", &btt_settings, &pfn_settings, &dax_settings, SZ_18M,
 	{ 1, 1, 1, 1,
 	  1, 1, 1, 1,
 	  1, 1, 1, 1,
@@ -246,7 +265,7 @@ static struct namespace namespace0_pmem0 = {
 };
 
 static struct namespace namespace1_pmem0 = {
-	0, "namespace_pmem", &btt_settings, &pfn_settings, SZ_20M,
+	0, "namespace_pmem", &btt_settings, &pfn_settings, &dax_settings, SZ_20M,
 	{ 2, 2, 2, 2,
 	  2, 2, 2, 2,
 	  2, 2, 2, 2,
@@ -254,7 +273,7 @@ static struct namespace namespace1_pmem0 = {
 };
 
 static struct namespace namespace2_blk0 = {
-	0, "namespace_blk", NULL, NULL, SZ_7M,
+	0, "namespace_blk", NULL, NULL, NULL, SZ_7M,
 	{ 3, 3, 3, 3,
 	  3, 3, 3, 3,
 	  3, 3, 3, 3,
@@ -262,7 +281,7 @@ static struct namespace namespace2_blk0 = {
 };
 
 static struct namespace namespace2_blk1 = {
-	1, "namespace_blk", NULL, NULL, SZ_11M,
+	1, "namespace_blk", NULL, NULL, NULL, SZ_11M,
 	{ 4, 4, 4, 4,
 	  4, 4, 4, 4,
 	  4, 4, 4, 4,
@@ -270,7 +289,7 @@ static struct namespace namespace2_blk1 = {
 };
 
 static struct namespace namespace3_blk0 = {
-	0, "namespace_blk", NULL, NULL, SZ_7M,
+	0, "namespace_blk", NULL, NULL, NULL, SZ_7M,
 	{ 5, 5, 5, 5,
 	  5, 5, 5, 5,
 	  5, 5, 5, 5,
@@ -278,7 +297,7 @@ static struct namespace namespace3_blk0 = {
 };
 
 static struct namespace namespace3_blk1 = {
-	1, "namespace_blk", NULL, NULL, SZ_11M,
+	1, "namespace_blk", NULL, NULL, NULL, SZ_11M,
 	{ 6, 6, 6, 6,
 	  6, 6, 6, 6,
 	  6, 6, 6, 6,
@@ -286,7 +305,7 @@ static struct namespace namespace3_blk1 = {
 };
 
 static struct namespace namespace4_blk0 = {
-	0, "namespace_blk", &btt_settings, NULL, SZ_27M,
+	0, "namespace_blk", &btt_settings, NULL, NULL, SZ_27M,
 	{ 7, 7, 7, 7,
 	  7, 7, 7, 7,
 	  7, 7, 7, 7,
@@ -294,7 +313,7 @@ static struct namespace namespace4_blk0 = {
 };
 
 static struct namespace namespace5_blk0 = {
-	0, "namespace_blk", &btt_settings, NULL, SZ_27M,
+	0, "namespace_blk", &btt_settings, NULL, NULL, SZ_27M,
 	{ 8, 8, 8, 8,
 	  8, 8, 8, 8,
 	  8, 8, 8, 8,
@@ -361,7 +380,7 @@ static struct region regions0[] = {
 };
 
 static struct namespace namespace1 = {
-	0, "namespace_io", &btt_settings, &pfn_settings, SZ_32M,
+	0, "namespace_io", &btt_settings, &pfn_settings, &dax_settings, SZ_32M,
 	{ 0, 0, 0, 0,
 	  0, 0, 0, 0,
 	  0, 0, 0, 0,
@@ -429,6 +448,17 @@ static struct ndctl_pfn *get_idle_pfn(struct ndctl_region *region)
 	return NULL;
 }
 
+static struct ndctl_dax *get_idle_dax(struct ndctl_region *region)
+{
+	struct ndctl_dax *dax;
+
+	ndctl_dax_foreach(region, dax)
+		if (!ndctl_dax_is_enabled(dax) && !ndctl_dax_is_configured(dax))
+			return dax;
+
+	return NULL;
+}
+
 static struct ndctl_namespace *get_namespace_by_id(struct ndctl_region *region,
 		struct namespace *namespace)
 {
@@ -488,7 +518,7 @@ static struct ndctl_region *get_blk_region_by_dimm_handle(struct ndctl_bus *bus,
 }
 
 enum ns_mode {
-	BTT, PFN,
+	BTT, PFN, DAX,
 };
 static int check_namespaces(struct ndctl_region *region,
 		struct namespace **namespaces, enum ns_mode mode);
@@ -588,6 +618,188 @@ static int check_regions(struct ndctl_bus *bus, struct region *regions, int n,
 	return rc;
 }
 
+static int validate_dax(struct ndctl_dax *dax)
+{
+	/* TODO: make nfit_test namespaces dax capable */
+	struct ndctl_namespace *ndns = ndctl_dax_get_namespace(dax);
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	struct daxctl_region *dax_region = NULL;
+	uuid_t uuid, region_uuid;
+	struct daxctl_dev *dax_dev;
+	int rc = -ENXIO, fd, count;
+	char devpath[50];
+
+	dax_region = ndctl_dax_get_daxctl_region(dax);
+	if (!dax_region) {
+		fprintf(stderr, "%s: failed to retrieve daxctl_region\n",
+				devname);
+		return -ENXIO;
+	}
+
+	rc = -ENXIO;
+	ndctl_dax_get_uuid(dax, uuid);
+	daxctl_region_get_uuid(dax_region, region_uuid);
+	if (uuid_compare(uuid, region_uuid) != 0) {
+		char expect[40], actual[40];
+
+		uuid_unparse(region_uuid, actual);
+		uuid_unparse(uuid, expect);
+		fprintf(stderr, "%s: expected uuid: %s got: %s\n",
+				devname, expect, actual);
+		goto out;
+	}
+
+	if ((int) ndctl_region_get_id(region)
+			!= daxctl_region_get_id(dax_region)) {
+		fprintf(stderr, "%s: expected region id: %d got: %d\n",
+				devname, ndctl_region_get_id(region),
+				daxctl_region_get_id(dax_region));
+		goto out;
+	}
+
+	dax_dev = daxctl_dev_get_first(dax_region);
+	if (!dax_dev) {
+		fprintf(stderr, "%s: failed to find daxctl_dev\n",
+				devname);
+		goto out;
+	}
+
+	if (daxctl_dev_get_size(dax_dev) <= 0) {
+		fprintf(stderr, "%s: expected non-zero sized dax device\n",
+				devname);
+		goto out;
+	}
+
+	sprintf(devpath, "/dev/%s", daxctl_dev_get_devname(dax_dev));
+	fd = open(devpath, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open %s\n", devname, devpath);
+		goto out;
+	}
+	close(fd);
+
+	count = 0;
+	daxctl_dev_foreach(dax_region, dax_dev)
+		count++;
+	if (count != 1) {
+		fprintf(stderr, "%s: expected 1 dax device, got %d\n",
+				devname, count);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	rc = 0;
+
+ out:
+	daxctl_region_unref(dax_region);
+	return rc;
+}
+
+static int __check_dax_create(struct ndctl_region *region,
+		struct ndctl_namespace *ndns, struct namespace *namespace,
+		enum ndctl_pfn_loc loc, unsigned long align, uuid_t uuid)
+{
+	struct ndctl_dax *dax_seed = ndctl_region_get_dax_seed(region);
+	enum ndctl_namespace_mode mode;
+	struct ndctl_dax *dax;
+	const char *devname;
+	ssize_t rc;
+
+	dax = get_idle_dax(region);
+	if (!dax)
+		return -ENXIO;
+
+	devname = ndctl_dax_get_devname(dax);
+	fprintf(stderr, "%s: %s align: %ld\n", __func__, devname, align);
+	ndctl_dax_set_uuid(dax, uuid);
+	ndctl_dax_set_location(dax, loc);
+	ndctl_dax_set_align(dax, align);
+	ndctl_dax_set_namespace(dax, ndns);
+	rc = ndctl_dax_enable(dax);
+	if (align == SZ_1G) {
+		if (rc == 0) {
+			fprintf(stderr, "%s: expected dax enable failure with align: %lx\n",
+					devname, align);
+			return -ENXIO;
+		}
+		ndctl_dax_delete(dax);
+		return 0;
+	}
+
+	mode = ndctl_namespace_get_mode(ndns);
+	if (mode >= 0 && mode != NDCTL_NS_MODE_DAX)
+		fprintf(stderr, "%s: expected dax mode got: %d\n",
+				devname, mode);
+
+	if (namespace->ro == (rc == 0)) {
+		fprintf(stderr, "%s: expected dax enable %s, %s read-%s\n",
+				devname,
+				namespace->ro ? "failure" : "success",
+				ndctl_region_get_devname(region),
+				namespace->ro ? "only" : "write");
+		return -ENXIO;
+	}
+
+	if (dax_seed == ndctl_region_get_dax_seed(region)
+			&& dax == dax_seed) {
+		fprintf(stderr, "%s: failed to advance dax seed\n",
+				ndctl_region_get_devname(region));
+		return -ENXIO;
+	}
+
+	if (namespace->ro) {
+		ndctl_region_set_ro(region, 0);
+		rc = ndctl_dax_enable(dax);
+		fprintf(stderr, "%s: failed to enable after setting rw\n",
+				devname);
+		ndctl_region_set_ro(region, 1);
+		return -ENXIO;
+	}
+
+	rc = validate_dax(dax);
+	if (rc) {
+		fprintf(stderr, "%s: %s validate_dax failed\n", __func__,
+				devname);
+		return rc;
+	}
+
+	if (namespace->ro)
+		ndctl_region_set_ro(region, 1);
+
+	rc = ndctl_dax_delete(dax);
+	if (rc)
+		fprintf(stderr, "%s: failed to delete dax (%zd)\n", devname, rc);
+	return rc;
+}
+
+static int check_dax_create(struct ndctl_region *region,
+		struct ndctl_namespace *ndns, struct namespace *namespace)
+{
+	struct dax *dax_s = namespace->dax_settings;
+	unsigned int i, j;
+	void *buf = NULL;
+	int rc = 0;
+
+	if (!dax_s)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(dax_s->locs); i++) {
+		fprintf(stderr, "%s: %ld\n", __func__, ARRAY_SIZE(dax_s->aligns));
+		for (j = 0; j < ARRAY_SIZE(dax_s->aligns); j++) {
+			rc = __check_dax_create(region, ndns, namespace,
+					dax_s->locs[i], dax_s->aligns[j],
+					dax_s->uuid);
+			if (rc)
+				break;
+		}
+		if (rc)
+			break;
+	}
+	free(buf);
+	return rc;
+}
+
 static int __check_pfn_create(struct ndctl_region *region,
 		struct ndctl_namespace *ndns, struct namespace *namespace,
 		void *buf, enum ndctl_pfn_loc loc, unsigned long align,
@@ -896,6 +1108,14 @@ static int configure_namespace(struct ndctl_region *region,
 		}
 	}
 
+	if (mode == DAX) {
+		rc = check_dax_create(region, ndns, namespace);
+		if (rc < 0) {
+			fprintf(stderr, "%s: failed to create dax\n", devname);
+			return rc;
+		}
+	}
+
 	rc = ndctl_namespace_enable(ndns);
 	if (rc < 0)
 		fprintf(stderr, "%s: enable: %d\n", devname, rc);
@@ -990,6 +1210,81 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
 	return rc;
 }
 
+static int check_dax_autodetect(struct ndctl_bus *bus,
+		struct ndctl_namespace *ndns, void *buf,
+		struct namespace *namespace)
+{
+	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct dax *auto_dax = namespace->dax_settings;
+	struct ndctl_dax *dax, *found = NULL;
+	ssize_t rc = -ENXIO;
+	char bdev[50];
+	int fd;
+
+	ndctl_dax_foreach(region, dax) {
+		struct ndctl_namespace *dax_ndns;
+		uuid_t uu;
+
+		ndctl_dax_get_uuid(dax, uu);
+		if (uuid_compare(uu, auto_dax->uuid) != 0)
+			continue;
+		if (!ndctl_dax_is_enabled(dax))
+			continue;
+		dax_ndns = ndctl_dax_get_namespace(dax);
+		if (strcmp(ndctl_namespace_get_devname(dax_ndns), devname) != 0)
+			continue;
+		fprintf(stderr, "%s: dax_ndns: %p ndns: %p\n", __func__,
+				dax_ndns, ndns);
+		found = dax;
+		break;
+	}
+
+	if (!found)
+		return -ENXIO;
+
+	rc = validate_dax(dax);
+	if (rc) {
+		fprintf(stderr, "%s: %s validate_dax failed\n", __func__,
+				devname);
+		return rc;
+	}
+
+	rc = -ENXIO;
+
+	/* destroy dax device */
+	ndctl_dax_delete(found);
+
+	/* clear read-write, and enable raw mode */
+	ndctl_region_set_ro(region, 0);
+	ndctl_namespace_set_raw_mode(ndns, 1);
+	ndctl_namespace_enable(ndns);
+
+	/* destroy dax metadata */
+	sprintf(bdev, "/dev/%s", ndctl_namespace_get_block_device(ndns));
+	fd = open(bdev, O_RDWR|O_DIRECT|O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open %s to destroy dax\n",
+				devname, bdev);
+		goto out;
+	}
+
+	memset(buf, 0, 4096);
+	rc = pwrite(fd, buf, 4096, 4096);
+	if (rc < 4096) {
+		rc = -ENXIO;
+		fprintf(stderr, "%s: failed to overwrite dax on %s\n",
+				devname, bdev);
+	}
+ out:
+	ndctl_region_set_ro(region, namespace->ro);
+	ndctl_namespace_set_raw_mode(ndns, 0);
+	if (fd >= 0)
+		close(fd);
+
+	return rc;
+}
+
 static int check_btt_autodetect(struct ndctl_bus *bus,
 		struct ndctl_namespace *ndns, void *buf,
 		struct namespace *namespace)
@@ -1077,6 +1372,80 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
 	return rc;
 }
 
+static int validate_bdev(const char *devname, struct ndctl_btt *btt,
+		struct ndctl_pfn *pfn, struct ndctl_namespace *ndns,
+		struct namespace *namespace, void *buf)
+{
+	char bdevpath[50];
+	int fd, rc, ro;
+
+	if (btt)
+		sprintf(bdevpath, "/dev/%s",
+				ndctl_btt_get_block_device(btt));
+	else if (pfn)
+		sprintf(bdevpath, "/dev/%s",
+				ndctl_pfn_get_block_device(pfn));
+	else
+		sprintf(bdevpath, "/dev/%s",
+				ndctl_namespace_get_block_device(ndns));
+
+	fd = open(bdevpath, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(%s, O_RDONLY)\n",
+				devname, bdevpath);
+		return -ENXIO;
+	}
+
+	rc = ioctl(fd, BLKROGET, &ro);
+	if (rc < 0) {
+		fprintf(stderr, "%s: BLKROGET failed\n",
+				devname);
+		rc = -errno;
+		goto out;
+	}
+
+	if (namespace->ro != ro) {
+		fprintf(stderr, "%s: read-%s expected: read-%s\n",
+				devname, ro ? "only" : "write",
+				namespace->ro ? "only" : "write");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	ro = 0;
+	rc = ioctl(fd, BLKROSET, &ro);
+	if (rc < 0) {
+		fprintf(stderr, "%s: BLKROSET failed\n",
+				devname);
+		rc = -errno;
+		goto out;
+	}
+
+	close(fd);
+	fd = open(bdevpath, O_RDWR|O_DIRECT);
+	if (fd < 0) {
+		fprintf(stderr, "%s: failed to open(%s, O_RDWR|O_DIRECT)\n",
+				devname, bdevpath);
+		return -ENXIO;
+	}
+	if (read(fd, buf, 4096) < 4096) {
+		fprintf(stderr, "%s: failed to read %s\n",
+				devname, bdevpath);
+		rc = -ENXIO;
+		goto out;
+	}
+	if (write(fd, buf, 4096) < 4096) {
+		fprintf(stderr, "%s: failed to write %s\n",
+				devname, bdevpath);
+		rc = -ENXIO;
+		goto out;
+	}
+	rc = 0;
+ out:
+	close(fd);
+	return rc;
+}
+
 static int check_namespaces(struct ndctl_region *region,
 		struct namespace **namespaces, enum ns_mode mode)
 {
@@ -1098,8 +1467,7 @@ static int check_namespaces(struct ndctl_region *region,
 	ndns_save = NULL;
 	for (i = 0; (namespace = namespaces[i]); i++) {
 		struct ndctl_namespace *ndns;
-		char bdevpath[50];
-		int fd = -1, ro;
+		int fd = -1;
 		uuid_t uu;
 
 		snprintf(devname, sizeof(devname), "namespace%d.%d",
@@ -1114,8 +1482,10 @@ static int check_namespaces(struct ndctl_region *region,
 		for (j = 0; j < namespace->num_sector_sizes; j++) {
 			struct btt *btt_s = NULL;
 			struct pfn *pfn_s = NULL;
+			struct dax *dax_s = NULL;
 			struct ndctl_btt *btt = NULL;
 			struct ndctl_pfn *pfn = NULL;
+			struct ndctl_dax *dax = NULL;
 
 			rc = configure_namespace(region, ndns, namespace,
 					namespace->sector_sizes[j], mode);
@@ -1167,7 +1537,21 @@ static int check_namespaces(struct ndctl_region *region,
 				}
 			}
 
-			if (!btt_s && !pfn_s && !ndctl_namespace_is_enabled(ndns)) {
+			if (mode == DAX) {
+				dax_s = namespace->do_configure > 0
+					? namespace->dax_settings : NULL;
+				dax = ndctl_namespace_get_dax(ndns);
+				if (!!dax_s != !!dax) {
+					fprintf(stderr, "%s expected dax %s by default\n",
+							devname, namespace->dax_settings
+							? "enabled" : "disabled");
+					rc = -ENXIO;
+					break;
+				}
+			}
+
+			if (!btt_s && !pfn_s && !dax_s
+					&& !ndctl_namespace_is_enabled(ndns)) {
 				fprintf(stderr, "%s: expected enabled by default\n",
 						devname);
 				rc = -ENXIO;
@@ -1204,71 +1588,16 @@ static int check_namespaces(struct ndctl_region *region,
 				break;
 			}
 
-			if (btt)
-				sprintf(bdevpath, "/dev/%s",
-						ndctl_btt_get_block_device(btt));
-			else if (pfn)
-				sprintf(bdevpath, "/dev/%s",
-						ndctl_pfn_get_block_device(pfn));
+			if (dax)
+				rc = validate_dax(dax);
 			else
-				sprintf(bdevpath, "/dev/%s",
-						ndctl_namespace_get_block_device(ndns));
-
-			fd = open(bdevpath, O_RDONLY);
-			if (fd < 0) {
-				fprintf(stderr, "%s: failed to open(%s, O_RDONLY)\n",
-						devname, bdevpath);
-				rc = -ENXIO;
-				break;
-			}
-
-			rc = ioctl(fd, BLKROGET, &ro);
-			if (rc < 0) {
-				fprintf(stderr, "%s: BLKROGET failed\n",
-						devname);
-				rc = -errno;
-				break;
-			}
-
-			if (namespace->ro != ro) {
-				fprintf(stderr, "%s: read-%s expected: read-%s\n",
-						devname, ro ? "only" : "write",
-						namespace->ro ? "only" : "write");
-				rc = -ENXIO;
-				break;
-			}
-
-			ro = 0;
-			rc = ioctl(fd, BLKROSET, &ro);
-			if (rc < 0) {
-				fprintf(stderr, "%s: BLKROSET failed\n",
-						devname);
-				rc = -errno;
-				break;
-			}
-
-			close(fd);
-			fd = open(bdevpath, O_RDWR|O_DIRECT);
-			if (fd < 0) {
-				fprintf(stderr, "%s: failed to open(%s, O_RDWR|O_DIRECT)\n",
-						devname, bdevpath);
-				rc = -ENXIO;
-				break;
-			}
-			if (read(fd, buf, 4096) < 4096) {
-				fprintf(stderr, "%s: failed to read %s\n",
-						devname, bdevpath);
-				rc = -ENXIO;
-				break;
-			}
-			if (write(fd, buf, 4096) < 4096) {
-				fprintf(stderr, "%s: failed to write %s\n",
-						devname, bdevpath);
-				rc = -ENXIO;
+				rc = validate_bdev(devname, btt, pfn, ndns,
+						namespace, buf);
+			if (rc) {
+				fprintf(stderr, "%s: %s validate_%s failed\n",
+						__func__, devname, dax ? "dax" : "bdev");
 				break;
 			}
-			close(fd);
-			fd = -1;
 
 			if (ndctl_namespace_disable_invalidate(ndns) < 0) {
 				fprintf(stderr, "%s: failed to disable\n", devname);
@@ -1296,12 +1625,18 @@ static int check_namespaces(struct ndctl_region *region,
 				break;
 			}
 
+			if (dax_s && check_dax_autodetect(bus, ndns, buf,
+						namespace) < 0) {
+				fprintf(stderr, "%s, failed dax autodetect\n", devname);
+				rc = -ENXIO;
+				break;
+			}
 
 			/*
 			 * if the namespace is being tested with a btt, there is no
 			 * point testing different sector sizes for the namespace itself
 			 */
-			if (btt_s || pfn_s)
+			if (btt_s || pfn_s || dax_s)
 				break;
 
 			/*
@@ -2120,11 +2455,15 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	ndctl_region_foreach(bus, region)
 		ndctl_region_enable(region);
 
-	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), BTT);
+	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
+	if (rc)
+		return rc;
+	reset_bus(bus);
+	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
 	if (rc)
 		return rc;
 	reset_bus(bus);
-	return check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
+	return check_regions(bus, regions0, ARRAY_SIZE(regions0), BTT);
 }
 
 static int do_test1(struct ndctl_ctx *ctx, struct ndctl_test *test)
@@ -2156,6 +2495,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test)
 	struct ndctl_ctx *ctx;
 	struct kmod_module *mod;
 	struct kmod_ctx *kmod_ctx;
+	struct daxctl_ctx *daxctl_ctx;
 	int err, result = EXIT_FAILURE;
 
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
@@ -2166,6 +2506,8 @@ int test_libndctl(int loglevel, struct ndctl_test *test)
 		exit(EXIT_FAILURE);
 
 	ndctl_set_log_priority(ctx, loglevel);
+	daxctl_ctx = ndctl_get_daxctl_ctx(ctx);
+	daxctl_set_log_priority(daxctl_ctx, loglevel);
 
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (!kmod_ctx)
diff --git a/util/sysfs.c b/util/sysfs.c
index 9f6a84172e91..2b57f3ff30d7 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -88,6 +88,7 @@ int __sysfs_device_parse(struct log_ctx *ctx, const char *base_path,
 	struct dirent *de;
 	DIR *dir;
 
+	log_dbg(ctx, "base: %s dev: %s\n", base_path, dev_name);
 	dir = opendir(base_path);
 	if (!dir) {
 		log_dbg(ctx, "no \"%s\" devices found\n", dev_name);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
