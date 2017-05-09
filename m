Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DEBE21A13493
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 16:30:38 -0700 (PDT)
Subject: [PATCH v2 1/2] ndctl: add foreach helper for region badblocks in
 libndctl
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 09 May 2017 16:30:37 -0700
Message-ID: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
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

The helper function allow iteration through the badblocks file that's part
of the region sysfs attributes. This will support the region list badblocks
code that's coming.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: added cleanup of opened badblocks file from Dan's comments.

 ndctl/lib/libndctl.c   |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 +
 ndctl/libndctl.h.in    |   10 ++++++
 3 files changed, 86 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ac1fc63..c651000 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -229,6 +229,8 @@ struct ndctl_region {
 		int state;
 		unsigned long long cookie;
 	} iset;
+	FILE *badblocks;
+	struct badblock bb;
 };
 
 /**
@@ -594,6 +596,8 @@ static void free_region(struct ndctl_region *region)
 	kmod_module_unref(region->module);
 	free(region->region_buf);
 	free(region->region_path);
+	if (region->badblocks)
+		fclose(region->badblocks);
 	free(region);
 }
 
@@ -1867,6 +1871,76 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *
 	return NULL;
 }
 
+static int regions_badblocks_init(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	char *bb_path;
+	int rc = 0;
+
+	/* if the file is already open */
+	if (region->badblocks) {
+		fclose(region->badblocks);
+		region->badblocks = NULL;
+	}
+
+	if (asprintf(&bb_path, "%s/badblocks",
+				region->region_path) < 0) {
+		rc = -errno;
+		err(ctx, "region badblocks path allocation failure\n");
+		return rc;
+	}
+
+	region->badblocks = fopen(bb_path, "re");
+	if (!region->badblocks) {
+		rc = -errno;
+		free(bb_path);
+		return -rc;
+	}
+
+	free(bb_path);
+	return rc;
+}
+
+NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
+{
+	int rc;
+	char *buf = NULL;
+	size_t rlen = 0;
+
+	if (!region->badblocks)
+		return NULL;
+
+	rc = getline(&buf, &rlen, region->badblocks);
+	if (rc == -1) {
+		free(buf);
+		return NULL;
+	}
+
+	rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
+	free(buf);
+	if (rc != 2) {
+		/* end of the road, clean up */
+		fclose(region->badblocks);
+		region->badblocks = NULL;
+		region->bb.offset = 0;
+		region->bb.len = 0;
+		return NULL;
+	}
+
+	return &region->bb;
+}
+
+NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region)
+{
+	int rc;
+
+	rc = regions_badblocks_init(region);
+	if (rc < 0)
+		return NULL;
+
+	return ndctl_region_get_next_badblock(region);
+}
+
 static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
 {
 	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b5a085c..9bc36a3 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -140,6 +140,8 @@ global:
 	ndctl_region_get_ro;
 	ndctl_region_set_ro;
 	ndctl_region_get_resource;
+	ndctl_region_get_first_badblock;
+	ndctl_region_get_next_badblock;
 	ndctl_interleave_set_get_first;
 	ndctl_interleave_set_get_next;
 	ndctl_interleave_set_is_active;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 6ee8a35..2c45d2d 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -372,6 +372,10 @@ int ndctl_cmd_get_status(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_get_firmware_status(struct ndctl_cmd *cmd);
 int ndctl_cmd_submit(struct ndctl_cmd *cmd);
 
+struct badblock {
+	unsigned long long offset;
+	unsigned int len;
+};
 struct ndctl_region;
 struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
 struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
@@ -379,6 +383,12 @@ struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
         for (region = ndctl_region_get_first(bus); \
              region != NULL; \
              region = ndctl_region_get_next(region))
+struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region);
+struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region);
+#define ndctl_region_badblock_foreach(region, badblock) \
+        for (badblock = ndctl_region_get_first_badblock(region); \
+             badblock != NULL; \
+             badblock = ndctl_region_get_next_badblock(region))
 unsigned int ndctl_region_get_id(struct ndctl_region *region);
 const char *ndctl_region_get_devname(struct ndctl_region *region);
 unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
