Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3F5E38032B
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 13:38:47 -0800 (PST)
Subject: [PATCH 1/4] ndctl: add function to acquire region resource
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 14:38:46 -0700
Message-ID: <148883632643.72901.10933593390557883209.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
References: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding helper function to acquire the physical base address of the
ND region.


Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/libndctl.c   |   21 +++++++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 3 files changed, 23 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 565c969..3a2530d 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1053,6 +1053,27 @@ NDCTL_EXPORT int ndctl_region_set_ro(struct ndctl_region *region, int ro)
 	return ro;
 }
 
+NDCTL_EXPORT unsigned long long ndctl_region_get_resource(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *path = region->region_buf;
+	int len = region->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	if (snprintf(path, len, "%s/resource", region->region_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_region_get_devname(region));
+		return ULLONG_MAX;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0)
+		return ULLONG_MAX;
+
+	return strtoull(buf, NULL, 0);
+}
+
 NDCTL_EXPORT const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd)
 {
 	return nvdimm_bus_cmd_name(cmd);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index be2e368..ca5165a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -137,6 +137,7 @@ global:
 	ndctl_region_get_interleave_set;
 	ndctl_region_get_ro;
 	ndctl_region_set_ro;
+	ndctl_region_get_resource;
 	ndctl_interleave_set_get_first;
 	ndctl_interleave_set_get_next;
 	ndctl_interleave_set_is_active;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index c27581d..d38aa45 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -388,6 +388,7 @@ struct ndctl_namespace *ndctl_region_get_namespace_seed(
 		struct ndctl_region *region);
 int ndctl_region_get_ro(struct ndctl_region *region);
 int ndctl_region_set_ro(struct ndctl_region *region, int ro);
+unsigned long long ndctl_region_get_resource(struct ndctl_region *region);
 struct ndctl_btt *ndctl_region_get_btt_seed(struct ndctl_region *region);
 struct ndctl_pfn *ndctl_region_get_pfn_seed(struct ndctl_region *region);
 unsigned int ndctl_region_get_nstype(struct ndctl_region *region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
