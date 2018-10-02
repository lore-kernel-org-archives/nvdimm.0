Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A6D721161680
 for <linux-nvdimm@lists.01.org>; Mon,  1 Oct 2018 20:31:49 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/5] ndctl,
 lib: add APIs for retrieving namespace badblocks
Date: Mon,  1 Oct 2018 21:31:37 -0600
Message-Id: <20181002033140.21295-2-vishal.l.verma@intel.com>
In-Reply-To: <20181002033140.21295-1-vishal.l.verma@intel.com>
References: <20181002033140.21295-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Dan Williams <dan.j.williams@intel.com>

From: Dan Williams <dan.j.williams@intel.com>

Use the new bb_iter mechanism to provide APIs that retrieve the
namespace badblocks from the kernel's block device representation in
sysfs. This paves the way for a namespace based fallback if
region-badblocks are unavailable.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[vishal] add the new global symbols to libndctl.sym
[vishal] fix the badblocks path to remove the trailing 'badblocks'
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  6 ++++++
 ndctl/libndctl.h       |  6 ++++++
 3 files changed, 54 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index d58be47..d341100 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3610,6 +3610,48 @@ NDCTL_EXPORT int ndctl_namespace_is_enabled(struct ndctl_namespace *ndns)
 	return is_enabled(ndctl_namespace_get_bus(ndns), path);
 }
 
+NDCTL_EXPORT struct badblock *ndctl_namespace_get_next_badblock(
+		struct ndctl_namespace *ndns)
+{
+	return badblocks_iter_next(&ndns->bb_iter);
+}
+
+NDCTL_EXPORT struct badblock *ndctl_namespace_get_first_badblock(
+		struct ndctl_namespace *ndns)
+{
+	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *dev = ndctl_namespace_get_devname(ndns);
+	char path[SYSFS_ATTR_SIZE];
+	ssize_t len = sizeof(path);
+	const char *bdev;
+
+	if (btt || dax) {
+		dbg(ctx, "%s: badblocks not supported for %s\n", dev,
+				btt ? "btt" : "device-dax");
+		return NULL;
+	}
+
+	if (pfn)
+		bdev = ndctl_pfn_get_block_device(pfn);
+	else
+		bdev = ndctl_namespace_get_block_device(ndns);
+
+	if (!bdev) {
+		dbg(ctx, "%s: failed to determine block device\n", dev);
+		return NULL;
+	}
+
+	if (snprintf(path, len, "/sys/block/%s", bdev) >= len) {
+		err(ctx, "%s: buffer too small!\n", dev);
+		return NULL;
+	}
+
+	return badblocks_iter_first(&ndns->bb_iter, ctx, path);
+}
+
 static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 		const char *devname)
 {
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a6849ee..185ee4a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -378,3 +378,9 @@ global:
 	ndctl_region_get_max_available_extent;
 	ndctl_cmd_smart_inject_ctrl_temperature;
 } LIBNDCTL_16;
+
+LIBNDCTL_18 {
+global:
+	ndctl_namespace_get_first_badblock;
+	ndctl_namespace_get_next_badblock;
+} LIBNDCTL_17;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 83d6c6c..500c7de 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -439,6 +439,12 @@ struct ndctl_namespace *ndctl_namespace_get_next(struct ndctl_namespace *ndns);
 	     ndns != NULL; \
 	     ndns = _ndns, \
 	     _ndns = _ndns ? ndctl_namespace_get_next(_ndns) : NULL)
+struct badblock *ndctl_namespace_get_first_badblock(struct ndctl_namespace *ndns);
+struct badblock *ndctl_namespace_get_next_badblock(struct ndctl_namespace *ndns);
+#define ndctl_namespace_badblock_foreach(ndns, badblock) \
+        for (badblock = ndctl_namespace_get_first_badblock(ndns); \
+             badblock != NULL; \
+             badblock = ndctl_namespace_get_next_badblock(ndns))
 struct ndctl_ctx *ndctl_namespace_get_ctx(struct ndctl_namespace *ndns);
 struct ndctl_bus *ndctl_namespace_get_bus(struct ndctl_namespace *ndns);
 struct ndctl_region *ndctl_namespace_get_region(struct ndctl_namespace *ndns);
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
