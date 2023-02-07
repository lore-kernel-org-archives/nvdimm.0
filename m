Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F7B7498
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797419; x=1707333419;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=bxTULUN/8ZXVephSEG1rQaVuAB/E2/402xTmOeVwcm4=;
  b=O2AoxW7IrM3UVKK9IbRU6N7r7KqIuksc4sne11pgMbQa22x0qsicOIf1
   xSsVINKB+QnysQiUnFHINxqWJ5EUY/HhJ2Nm0RsHErzhcjYXEbX0Jyv3D
   +q98S4FQIZIbYRFOIk3ZFys4mL7U4YfofDYRd2hDrjmy9FqxGS6bTdR3y
   tHWy5nBiw9X4hP7Nyq1L8fbFJKbybgwU6e1AoqTcSXAs9bNirQXczZ/tU
   e0EQXnN04NqoeUx/aTRtrY1r/Nvq+D/vsIgVvggC2J9iQplgyKo4UZwFZ
   4ZZfVbRxsCNDPbrmJwzABaFZroHlh5ntsfwSHhBnXC79rqz83QEOGPVoK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331734019"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331734019"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649824"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649824"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:56 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:33 -0700
Subject: [PATCH ndctl 7/7] cxl/list: Enumerate device-dax properties for
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=10531;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=nqDpw/iPPsTQNXEO59+3Kou9ZGEkQ8PKTtvTXnKYUCc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi+pjchdbSce+rLb0t6sVpzhzcdqmyi2nvdMNn/M2
 0RfXd/dUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIkYczH8U7nSveq8r5SeW/+0
 iG12J/4qS203O2MsbLjSzeHhReYDLIwM86atsnu/vDk7PXNiA2ME9/LKieVJbZvCE/nn/bwwN9W
 NAQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

From: Dan Williams <dan.j.williams@intel.com>

Recently the kernel added support for routing newly mapped CXL regions to
device-dax. Include the json representation of a DAX region beneath its
host CXL region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[vishal: fix missing dsxctl/json.h include in cxl/json.c]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-list.txt   | 31 +++++++++++++++++++++++++++++++
 Documentation/cxl/lib/libcxl.txt |  7 +++++++
 cxl/lib/private.h                |  1 +
 cxl/lib/libcxl.c                 | 39 +++++++++++++++++++++++++++++++++++++++
 cxl/filter.h                     |  3 +++
 cxl/libcxl.h                     |  1 +
 cxl/filter.c                     |  1 +
 cxl/json.c                       | 16 ++++++++++++++++
 cxl/list.c                       |  2 ++
 cxl/lib/libcxl.sym               |  1 +
 cxl/lib/meson.build              |  1 +
 cxl/meson.build                  |  3 +++
 12 files changed, 106 insertions(+)

diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
index 3410d49..c64d65d 100644
--- a/Documentation/cxl/cxl-list.txt
+++ b/Documentation/cxl/cxl-list.txt
@@ -380,6 +380,37 @@ OPTIONS
 --regions::
 	Include region objects in the listing.
 
+-X::
+--dax::
+	Append DAX information to region listings
+----
+# cxl list -RXu
+{
+  "region":"region4",
+  "resource":"0xf010000000",
+  "size":"512.00 MiB (536.87 MB)",
+  "interleave_ways":2,
+  "interleave_granularity":4096,
+  "decode_state":"commit",
+  "daxregion":{
+    "id":4,
+    "size":"512.00 MiB (536.87 MB)",
+    "align":2097152,
+    "devices":[
+      {
+        "chardev":"dax4.0",
+        "size":"512.00 MiB (536.87 MB)",
+        "target_node":0,
+        "align":2097152,
+        "mode":"system-ram",
+        "online_memblocks":0,
+        "total_memblocks":4
+      }
+    ]
+  }
+}
+----
+
 -r::
 --region::
 	Specify CXL region device name(s), or device id(s), to filter the listing.
diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index dbc4b56..31bc855 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -568,6 +568,7 @@ int cxl_region_clear_target(struct cxl_region *region, int position);
 int cxl_region_clear_all_targets(struct cxl_region *region);
 int cxl_region_decode_commit(struct cxl_region *region);
 int cxl_region_decode_reset(struct cxl_region *region);
+struct daxctl_region *cxl_region_get_daxctl_region(struct cxl_region *region);
 ----
 
 A region's resource attribute is the Host Physical Address at which the region's
@@ -587,6 +588,12 @@ The 'decode_commit' and 'decode_reset' attributes reserve and free DPA space
 on a given memdev by allocating an endpoint decoder, and programming it based
 on the region's interleave geometry.
 
+Once a region is active it is attached to either the NVDIMM subsystem
+where its properties can be interrogated by ndctl, or the DAX subsystem
+where its properties can be interrogated by daxctl. The helper
+cxl_region_get_daxctl_region() returns an 'struct daxctl_region *' that
+can be used with other libdaxctl APIs.
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 306dc3a..d648992 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -150,6 +150,7 @@ struct cxl_region {
 	unsigned int interleave_granularity;
 	enum cxl_decode_state decode_state;
 	enum cxl_decoder_mode mode;
+	struct daxctl_region *dax_region;
 	struct kmod_module *module;
 	struct list_head mappings;
 };
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index c5b9b18..81855f4 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -26,6 +26,7 @@
 #include <util/bitmap.h>
 #include <cxl/cxl_mem.h>
 #include <cxl/libcxl.h>
+#include <daxctl/libdaxctl.h>
 #include "private.h"
 
 /**
@@ -49,6 +50,7 @@ struct cxl_ctx {
 	struct list_head memdevs;
 	struct list_head buses;
 	struct kmod_ctx *kmod_ctx;
+	struct daxctl_ctx *daxctl_ctx;
 	void *private_data;
 };
 
@@ -231,6 +233,7 @@ CXL_EXPORT void *cxl_get_private_data(struct cxl_ctx *ctx)
  */
 CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 {
+	struct daxctl_ctx *daxctl_ctx;
 	struct udev_queue *udev_queue;
 	struct kmod_ctx *kmod_ctx;
 	struct udev *udev;
@@ -241,6 +244,10 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	if (!c)
 		return -ENOMEM;
 
+	rc = daxctl_new(&daxctl_ctx);
+	if (rc)
+		goto err_daxctl;
+
 	kmod_ctx = kmod_new(NULL, NULL);
 	if (check_kmod(kmod_ctx) != 0) {
 		rc = -ENXIO;
@@ -267,6 +274,7 @@ CXL_EXPORT int cxl_new(struct cxl_ctx **ctx)
 	list_head_init(&c->memdevs);
 	list_head_init(&c->buses);
 	c->kmod_ctx = kmod_ctx;
+	c->daxctl_ctx = daxctl_ctx;
 	c->udev = udev;
 	c->udev_queue = udev_queue;
 	c->timeout = 5000;
@@ -278,6 +286,8 @@ err_udev_queue:
 err_udev:
 	kmod_unref(kmod_ctx);
 err_kmod:
+	daxctl_unref(daxctl_ctx);
+err_daxctl:
 	free(c);
 	return rc;
 }
@@ -321,6 +331,7 @@ CXL_EXPORT void cxl_unref(struct cxl_ctx *ctx)
 	udev_queue_unref(ctx->udev_queue);
 	udev_unref(ctx->udev);
 	kmod_unref(ctx->kmod_ctx);
+	daxctl_unref(ctx->daxctl_ctx);
 	info(ctx, "context %p released\n", ctx);
 	free(ctx);
 }
@@ -746,6 +757,34 @@ cxl_region_get_target_decoder(struct cxl_region *region, int position)
 	return decoder;
 }
 
+CXL_EXPORT struct daxctl_region *
+cxl_region_get_daxctl_region(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *path = region->dev_buf;
+	int len = region->buf_len;
+	uuid_t uuid = { 0 };
+	struct stat st;
+
+	if (region->dax_region)
+		return region->dax_region;
+
+	if (snprintf(region->dev_buf, len, "%s/dax_region%d", region->dev_path,
+		     region->id) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return NULL;
+	}
+
+	if (stat(path, &st) < 0)
+		return NULL;
+
+	region->dax_region =
+		daxctl_new_region(ctx->daxctl_ctx, region->id, uuid, path);
+
+	return region->dax_region;
+}
+
 CXL_EXPORT int cxl_region_set_size(struct cxl_region *region,
 				   unsigned long long size)
 {
diff --git a/cxl/filter.h b/cxl/filter.h
index b9f1350..c486514 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -28,6 +28,7 @@ struct cxl_filter_params {
 	bool health;
 	bool partition;
 	bool alert_config;
+	bool dax;
 	int verbose;
 	struct log_ctx ctx;
 };
@@ -80,6 +81,8 @@ static inline unsigned long cxl_filter_to_flags(struct cxl_filter_params *param)
 		flags |= UTIL_JSON_PARTITION;
 	if (param->alert_config)
 		flags |= UTIL_JSON_ALERT_CONFIG;
+	if (param->dax)
+		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	return flags;
 }
 
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 904156c..54d9f10 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -279,6 +279,7 @@ unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
 struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
 						  int position);
+struct daxctl_region *cxl_region_get_daxctl_region(struct cxl_region *region);
 int cxl_region_set_size(struct cxl_region *region, unsigned long long size);
 int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu);
 int cxl_region_set_interleave_ways(struct cxl_region *region,
diff --git a/cxl/filter.c b/cxl/filter.c
index 90b13be..f90cbc8 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -11,6 +11,7 @@
 
 #include "filter.h"
 #include "json.h"
+#include "../daxctl/json.h"
 
 static const char *which_sep(const char *filter)
 {
diff --git a/cxl/json.c b/cxl/json.c
index f625380..6eb5b8f 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -10,6 +10,7 @@
 
 #include "filter.h"
 #include "json.h"
+#include "../daxctl/json.h"
 
 static struct json_object *util_cxl_memdev_health_to_json(
 		struct cxl_memdev *memdev, unsigned long flags)
@@ -889,7 +890,22 @@ struct json_object *util_cxl_region_to_json(struct cxl_region *region,
 
 	util_cxl_mappings_append_json(jregion, region, flags);
 
+	if (flags & UTIL_JSON_DAX) {
+		struct daxctl_region *dax_region;
+
+		dax_region = cxl_region_get_daxctl_region(region);
+		if (dax_region) {
+			jobj = util_daxctl_region_to_json(dax_region, NULL,
+							  flags);
+			if (jobj)
+				json_object_object_add(jregion, "daxregion",
+						       jobj);
+		}
+	}
+
 	json_object_set_userdata(jregion, region, NULL);
+
+
 	return jregion;
 }
 
diff --git a/cxl/list.c b/cxl/list.c
index 4e77aeb..c01154e 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -45,6 +45,7 @@ static const struct option options[] = {
 	OPT_STRING('r', "region", &param.region_filter, "region name",
 		   "filter by CXL region name(s)"),
 	OPT_BOOLEAN('R', "regions", &param.regions, "include CXL regions"),
+	OPT_BOOLEAN('X', "dax", &param.dax, "include CXL DAX region enumeration"),
 	OPT_BOOLEAN('i', "idle", &param.idle, "include disabled devices"),
 	OPT_BOOLEAN('u', "human", &param.human,
 		    "use human friendly number formats"),
@@ -116,6 +117,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 		param.health = true;
 		param.partition = true;
 		param.alert_config = true;
+		param.dax = true;
 		/* fallthrough */
 	case 2:
 		param.idle = true;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 84f60ad..1c6177c 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -247,4 +247,5 @@ LIBCXL_5 {
 global:
 	cxl_region_get_mode;
 	cxl_decoder_create_ram_region;
+	cxl_region_get_daxctl_region;
 } LIBCXL_4;
diff --git a/cxl/lib/meson.build b/cxl/lib/meson.build
index 60b9de7..422a351 100644
--- a/cxl/lib/meson.build
+++ b/cxl/lib/meson.build
@@ -16,6 +16,7 @@ cxl = library('cxl',
     uuid,
     kmod,
     libudev,
+    daxctl_dep,
   ],
   version : libcxl_version,
   install : true,
diff --git a/cxl/meson.build b/cxl/meson.build
index f2474aa..4ead163 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -7,6 +7,8 @@ cxl_src = [
   'memdev.c',
   'json.c',
   'filter.c',
+  '../daxctl/json.c',
+  '../daxctl/filter.c',
 ]
 
 cxl_tool = executable('cxl',
@@ -14,6 +16,7 @@ cxl_tool = executable('cxl',
   include_directories : root_inc,
   dependencies : [
     cxl_dep,
+    daxctl_dep,
     util_dep,
     uuid,
     kmod,

-- 
2.39.1

