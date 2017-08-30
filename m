Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6F4721E2BE4E
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 19:15:13 -0700 (PDT)
Subject: [ndctl PATCH v2 06/10] ndctl: refactor region type setting
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 19:11:30 -0700
Message-ID: <150405909062.22171.14671734486415875234.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
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

When a region is updated after initializing labels it may potentially
change types. For now factor out type setting into a helper so that it
can later be triggered by a new ndctl_dimm_init_labels().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |   44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 86abeb6cc577..3d37ded69c26 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1552,6 +1552,32 @@ static struct ndctl_dimm *ndctl_dimm_get_by_id(struct ndctl_bus *bus, unsigned i
 	return NULL;
 }
 
+static int region_set_type(struct ndctl_region *region, char *path)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	sprintf(path, "%s/nstype", region->region_path);
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+	region->nstype = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/set_cookie", region->region_path);
+	if (region->nstype == ND_DEVICE_NAMESPACE_PMEM) {
+		rc = sysfs_read_attr(ctx, path, buf);
+		if (rc < 0)
+			return rc;
+		region->iset.cookie = strtoull(buf, NULL, 0);
+		dbg(ctx, "%s: iset-%#.16llx added\n",
+				ndctl_region_get_devname(region),
+				region->iset.cookie);
+	}
+
+	return 0;
+}
+
 static void *add_region(void *parent, int id, const char *region_base)
 {
 	char buf[SYSFS_ATTR_SIZE];
@@ -1575,6 +1601,7 @@ static void *add_region(void *parent, int id, const char *region_base)
 	list_head_init(&region->mappings);
 	list_head_init(&region->namespaces);
 	list_head_init(&region->stale_namespaces);
+	region->region_path = (char *) region_base;
 	region->bus = bus;
 	region->id = id;
 
@@ -1588,11 +1615,6 @@ static void *add_region(void *parent, int id, const char *region_base)
 		goto err_read;
 	region->num_mappings = strtoul(buf, NULL, 0);
 
-	sprintf(path, "%s/nstype", region_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	region->nstype = strtoul(buf, NULL, 0);
-
 	sprintf(path, "%s/nfit/range_index", region_base);
 	if (ndctl_bus_has_nfit(bus)) {
 		if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -1601,15 +1623,6 @@ static void *add_region(void *parent, int id, const char *region_base)
 	} else
 		region->range_index = -1;
 
-	sprintf(path, "%s/set_cookie", region_base);
-	if (region->nstype == ND_DEVICE_NAMESPACE_PMEM) {
-		if (sysfs_read_attr(ctx, path, buf) < 0)
-			goto err_read;
-		region->iset.cookie = strtoull(buf, NULL, 0);
-		dbg(ctx, "region%d: iset-%#.16llx added\n", id,
-				region->iset.cookie);
-	}
-
 	sprintf(path, "%s/read_only", region_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1620,6 +1633,9 @@ static void *add_region(void *parent, int id, const char *region_base)
 		goto err_read;
 	region->module = to_module(ctx, buf);
 
+	if (region_set_type(region, path) < 0)
+		goto err_read;
+
         region->region_buf = calloc(1, strlen(region_base) + 50);
         if (!region->region_buf)
                 goto err_read;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
