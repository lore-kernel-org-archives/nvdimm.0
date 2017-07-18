Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DD302095D8CC
 for <linux-nvdimm@lists.01.org>; Tue, 18 Jul 2017 13:30:40 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: correctly propagate errors from sysfs_write_attr
Date: Tue, 18 Jul 2017 14:30:55 -0600
Message-Id: <20170718203055.11179-1-vishal.l.verma@intel.com>
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

In libndctl, if a sysfs_write_attr failed, we simply returned ENXIO,
which would print a confusing error message ("unsupported
configuration") for something like EACCESS..

Propagate the actuall return from the sysfs helper in all the call
sites. Also use strerror() instead of open-coding a translation of error
messages in create-namespace.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 95 +++++++++++++++++++++++++++++-----------------------
 ndctl/namespace.c    | 13 ++-----
 2 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 68d8064..dda1345 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1050,7 +1050,7 @@ NDCTL_EXPORT int ndctl_region_set_ro(struct ndctl_region *region, int ro)
 {
 	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	char *path = region->region_buf;
-	int len = region->buf_len;
+	int len = region->buf_len, rc;
 
 	if (snprintf(path, len, "%s/read_only", region->region_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -1059,8 +1059,9 @@ NDCTL_EXPORT int ndctl_region_set_ro(struct ndctl_region *region, int ro)
 	}
 
 	ro = !!ro;
-	if (sysfs_write_attr(ctx, path, ro ? "1\n" : "0\n") < 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, ro ? "1\n" : "0\n");
+	if (rc < 0)
+		return rc;
 
 	region->ro = ro;
 	return ro;
@@ -3235,7 +3236,7 @@ NDCTL_EXPORT int ndctl_namespace_set_raw_mode(struct ndctl_namespace *ndns,
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	char *path = ndns->ndns_buf;
-	int len = ndns->buf_len;
+	int len = ndns->buf_len, rc;
 
 	if (snprintf(path, len, "%s/force_raw", ndns->ndns_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -3244,8 +3245,9 @@ NDCTL_EXPORT int ndctl_namespace_set_raw_mode(struct ndctl_namespace *ndns,
 	}
 
 	raw_mode = !!raw_mode;
-	if (sysfs_write_attr(ctx, path, raw_mode ? "1\n" : "0\n") < 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, raw_mode ? "1\n" : "0\n");
+	if (rc < 0)
+		return rc;
 
 	ndns->raw_mode = raw_mode;
 	return raw_mode;
@@ -3602,7 +3604,7 @@ NDCTL_EXPORT int ndctl_namespace_set_uuid(struct ndctl_namespace *ndns, uuid_t u
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	char *path = ndns->ndns_buf;
-	int len = ndns->buf_len;
+	int len = ndns->buf_len, rc;
 	char uuid[40];
 
 	if (snprintf(path, len, "%s/uuid", ndns->ndns_path) >= len) {
@@ -3612,8 +3614,9 @@ NDCTL_EXPORT int ndctl_namespace_set_uuid(struct ndctl_namespace *ndns, uuid_t u
 	}
 
 	uuid_unparse(uu, uuid);
-	if (sysfs_write_attr(ctx, path, uuid) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, uuid);
+	if (rc != 0)
+		return rc;
 	memcpy(ndns->uuid, uu, sizeof(uuid_t));
 	return 0;
 }
@@ -3645,7 +3648,7 @@ NDCTL_EXPORT int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	char *path = ndns->ndns_buf;
-	int len = ndns->buf_len;
+	int len = ndns->buf_len, rc;
 	char sector_str[40];
 	int i;
 
@@ -3659,8 +3662,9 @@ NDCTL_EXPORT int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 	}
 
 	sprintf(sector_str, "%d\n", sector_size);
-	if (sysfs_write_attr(ctx, path, sector_str) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, sector_str);
+	if (rc != 0)
+		return rc;
 
 	for (i = 0; i < ndns->lbasize.num; i++)
 		if (ndns->lbasize.supported[i] == sector_size)
@@ -3680,7 +3684,7 @@ NDCTL_EXPORT int ndctl_namespace_set_alt_name(struct ndctl_namespace *ndns,
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	char *path = ndns->ndns_buf;
-	int len = ndns->buf_len;
+	int len = ndns->buf_len, rc;
 	char *buf;
 
 	if (!ndns->alt_name)
@@ -3699,9 +3703,10 @@ NDCTL_EXPORT int ndctl_namespace_set_alt_name(struct ndctl_namespace *ndns,
 	if (!buf)
 		return -ENOMEM;
 
-	if (sysfs_write_attr(ctx, path, buf) < 0) {
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0) {
 		free(buf);
-		return -ENXIO;
+		return rc;
 	}
 
 	free(ndns->alt_name);
@@ -3724,7 +3729,7 @@ static int namespace_set_size(struct ndctl_namespace *ndns,
 {
 	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
 	char *path = ndns->ndns_buf;
-	int len = ndns->buf_len;
+	int len = ndns->buf_len, rc;
 	char buf[SYSFS_ATTR_SIZE];
 
 	if (snprintf(path, len, "%s/size", ndns->ndns_path) >= len) {
@@ -3734,8 +3739,9 @@ static int namespace_set_size(struct ndctl_namespace *ndns,
 	}
 
 	sprintf(buf, "%#llx\n", size);
-	if (sysfs_write_attr(ctx, path, buf) < 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
 
 	ndns->size = size;
 	return 0;
@@ -4008,7 +4014,7 @@ NDCTL_EXPORT int ndctl_btt_set_uuid(struct ndctl_btt *btt, uuid_t uu)
 {
 	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
 	char *path = btt->btt_buf;
-	int len = btt->buf_len;
+	int len = btt->buf_len, rc;
 	char uuid[40];
 
 	if (snprintf(path, len, "%s/uuid", btt->btt_path) >= len) {
@@ -4018,8 +4024,9 @@ NDCTL_EXPORT int ndctl_btt_set_uuid(struct ndctl_btt *btt, uuid_t uu)
 	}
 
 	uuid_unparse(uu, uuid);
-	if (sysfs_write_attr(ctx, path, uuid) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, uuid);
+	if (rc != 0)
+		return rc;
 	memcpy(btt->uuid, uu, sizeof(uuid_t));
 	return 0;
 }
@@ -4029,7 +4036,7 @@ NDCTL_EXPORT int ndctl_btt_set_sector_size(struct ndctl_btt *btt,
 {
 	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
 	char *path = btt->btt_buf;
-	int len = btt->buf_len;
+	int len = btt->buf_len, rc;
 	char sector_str[40];
 	int i;
 
@@ -4040,8 +4047,9 @@ NDCTL_EXPORT int ndctl_btt_set_sector_size(struct ndctl_btt *btt,
 	}
 
 	sprintf(sector_str, "%d\n", sector_size);
-	if (sysfs_write_attr(ctx, path, sector_str) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, sector_str);
+	if (rc != 0)
+		return rc;
 
 	for (i = 0; i < btt->lbasize.num; i++)
 		if (btt->lbasize.supported[i] == sector_size)
@@ -4053,8 +4061,8 @@ NDCTL_EXPORT int ndctl_btt_set_namespace(struct ndctl_btt *btt,
 		struct ndctl_namespace *ndns)
 {
 	struct ndctl_ctx *ctx = ndctl_btt_get_ctx(btt);
+	int len = btt->buf_len, rc;
 	char *path = btt->btt_buf;
-	int len = btt->buf_len;
 
 	if (snprintf(path, len, "%s/namespace", btt->btt_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -4062,9 +4070,10 @@ NDCTL_EXPORT int ndctl_btt_set_namespace(struct ndctl_btt *btt,
 		return -ENXIO;
 	}
 
-	if (sysfs_write_attr(ctx, path, ndns
-				? ndctl_namespace_get_devname(ndns) : "\n"))
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, ndns
+				? ndctl_namespace_get_devname(ndns) : "\n");
+	if (rc != 0)
+		return rc;
 
 	btt->ndns = ndns;
 	return 0;
@@ -4407,8 +4416,8 @@ NDCTL_EXPORT unsigned long long ndctl_pfn_get_resource(struct ndctl_pfn *pfn)
 NDCTL_EXPORT int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
+	int len = pfn->buf_len, rc;
 	char *path = pfn->pfn_buf;
-	int len = pfn->buf_len;
 	char uuid[40];
 
 	if (snprintf(path, len, "%s/uuid", pfn->pfn_path) >= len) {
@@ -4418,8 +4427,9 @@ NDCTL_EXPORT int ndctl_pfn_set_uuid(struct ndctl_pfn *pfn, uuid_t uu)
 	}
 
 	uuid_unparse(uu, uuid);
-	if (sysfs_write_attr(ctx, path, uuid) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, uuid);
+	if (rc != 0)
+		return rc;
 	memcpy(pfn->uuid, uu, sizeof(uuid_t));
 	return 0;
 }
@@ -4433,8 +4443,8 @@ NDCTL_EXPORT int ndctl_pfn_set_location(struct ndctl_pfn *pfn,
 		enum ndctl_pfn_loc loc)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
+	int len = pfn->buf_len, rc;
 	char *path = pfn->pfn_buf;
-	int len = pfn->buf_len;
 	const char *locations[] = {
 		[NDCTL_PFN_LOC_NONE] = "none",
 		[NDCTL_PFN_LOC_RAM] = "ram",
@@ -4456,8 +4466,9 @@ NDCTL_EXPORT int ndctl_pfn_set_location(struct ndctl_pfn *pfn,
 		return -ENXIO;
 	}
 
-	if (sysfs_write_attr(ctx, path, locations[loc]) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, locations[loc]);
+	if (rc != 0)
+		return rc;
 	pfn->loc = loc;
 	return 0;
 }
@@ -4486,8 +4497,8 @@ NDCTL_EXPORT int ndctl_pfn_has_align(struct ndctl_pfn *pfn)
 NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
+	int len = pfn->buf_len, rc;
 	char *path = pfn->pfn_buf;
-	int len = pfn->buf_len;
 	char align_str[40];
 
 	if (snprintf(path, len, "%s/align", pfn->pfn_path) >= len) {
@@ -4497,8 +4508,9 @@ NDCTL_EXPORT int ndctl_pfn_set_align(struct ndctl_pfn *pfn, unsigned long align)
 	}
 
 	sprintf(align_str, "%lu\n", align);
-	if (sysfs_write_attr(ctx, path, align_str) != 0)
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, align_str);
+	if (rc != 0)
+		return rc;
 	pfn->align = align;
 	return 0;
 }
@@ -4507,8 +4519,8 @@ NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
 		struct ndctl_namespace *ndns)
 {
 	struct ndctl_ctx *ctx = ndctl_pfn_get_ctx(pfn);
+	int len = pfn->buf_len, rc;
 	char *path = pfn->pfn_buf;
-	int len = pfn->buf_len;
 
 	if (snprintf(path, len, "%s/namespace", pfn->pfn_path) >= len) {
 		err(ctx, "%s: buffer too small!\n",
@@ -4516,9 +4528,10 @@ NDCTL_EXPORT int ndctl_pfn_set_namespace(struct ndctl_pfn *pfn,
 		return -ENXIO;
 	}
 
-	if (sysfs_write_attr(ctx, path, ndns
-				? ndctl_namespace_get_devname(ndns) : "\n"))
-		return -ENXIO;
+	rc = sysfs_write_attr(ctx, path, ndns
+				? ndctl_namespace_get_devname(ndns) : "\n");
+	if (rc != 0)
+		return rc;
 
 	pfn->ndns = ndns;
 	return 0;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index a9576ce..e4ae31a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -978,17 +978,8 @@ int cmd_create_namespace(int argc, const char **argv, void *ctx)
 	}
 
 	if (created < 0 || (!namespace && created < 1)) {
-		char *reason = "";
-
-		if (created == -EAGAIN)
-			reason = ": no suitable capacity found";
-		else if (created == -ENXIO)
-			reason = ": unsupported configuration";
-		else if (created == -EINVAL)
-			reason = ": invalid argument";
-
-		fprintf(stderr, "failed to %s namespace%s\n", namespace
-				? "reconfigure" : "create", reason);
+		fprintf(stderr, "failed to %s namespace: %s\n", namespace
+				? "reconfigure" : "create", strerror(-created));
 		if (!namespace)
 			created = -ENODEV;
 	}
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
