Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E83422620E7A
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 14:24:27 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] libndctl: Add APIs for query and control of
 write_cache
Date: Fri,  6 Apr 2018 15:24:16 -0600
Message-Id: <20180406212417.16227-1-vishal.l.verma@intel.com>
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

Add APIs to get the state of write_cache for pmem namespaces, and also
to enable or disable the write_cache.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |  3 ++
 ndctl/libndctl.h       |  3 ++
 3 files changed, 82 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 580a450..1f59e2a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3918,6 +3918,82 @@ NDCTL_EXPORT int ndctl_namespace_get_numa_node(struct ndctl_namespace *ndns)
     return ndns->numa_node;
 }
 
+static int __ndctl_namespace_set_write_cache(struct ndctl_namespace *ndns,
+		int state)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	char buf[SYSFS_ATTR_SIZE];
+	int len = ndns->buf_len;
+	const char *bdev;
+	char path[50];
+
+	if (state != 1 && state != 0)
+		return -ENXIO;
+	if (pfn)
+		bdev = ndctl_pfn_get_block_device(pfn);
+	else
+		bdev = ndctl_namespace_get_block_device(ndns);
+
+	if (!bdev)
+		return -ENXIO;
+
+	if (snprintf(path, len, "/sys/block/%s/dax/write_cache", bdev) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_namespace_get_devname(ndns));
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%d\n", state);
+	return sysfs_write_attr(ctx, path, buf);
+}
+
+NDCTL_EXPORT int ndctl_namespace_enable_write_cache(
+		struct ndctl_namespace *ndns)
+{
+	return __ndctl_namespace_set_write_cache(ndns, 1);
+}
+
+NDCTL_EXPORT int ndctl_namespace_disable_write_cache(
+		struct ndctl_namespace *ndns)
+{
+	return __ndctl_namespace_set_write_cache(ndns, 0);
+}
+
+NDCTL_EXPORT int ndctl_namespace_write_cache_is_enabled(
+		struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	int len = ndns->buf_len, wc;
+	char buf[SYSFS_ATTR_SIZE];
+	const char *bdev;
+	char path[50];
+
+	if (pfn)
+		bdev = ndctl_pfn_get_block_device(pfn);
+	else
+		bdev = ndctl_namespace_get_block_device(ndns);
+
+	if (!bdev)
+		return -ENXIO;
+
+	if (snprintf(path, len, "/sys/block/%s/dax/write_cache", bdev) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_namespace_get_devname(ndns));
+		return -ENXIO;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return -ENXIO;
+
+	if (sscanf(buf, "%d", &wc) == 1)
+		if (wc)
+			return 1;
+
+	return 0;
+}
+
 NDCTL_EXPORT int ndctl_namespace_delete(struct ndctl_namespace *ndns)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 3209aef..4709c47 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -352,4 +352,7 @@ global:
 	ndctl_dimm_fw_update_supported;
 	ndctl_region_get_persistence_domain;
 	ndctl_bus_get_persistence_domain;
+	ndctl_namespace_write_cache_is_enabled;
+	ndctl_namespace_enable_write_cache;
+	ndctl_namespace_disable_write_cache;
 } LIBNDCTL_14;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 684fcd4..1ecbabb 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -490,6 +490,9 @@ struct ndctl_bb *ndctl_namespace_injection_get_next_bb(
         for (bb = ndctl_namespace_injection_get_first_bb(ndns); \
              bb != NULL; \
              bb = ndctl_namespace_injection_get_next_bb(ndns, bb))
+int ndctl_namespace_write_cache_is_enabled(struct ndctl_namespace *ndns);
+int ndctl_namespace_enable_write_cache(struct ndctl_namespace *ndns);
+int ndctl_namespace_disable_write_cache(struct ndctl_namespace *ndns);
 
 struct ndctl_btt;
 struct ndctl_btt *ndctl_btt_get_first(struct ndctl_region *region);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
