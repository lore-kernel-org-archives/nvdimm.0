Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FBE421962301
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 11:16:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/5] ndctl, lib: refactor badblocks retrieval routines
Date: Wed,  3 Oct 2018 12:15:02 -0600
Message-Id: <20181003181506.17682-1-vishal.l.verma@intel.com>
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

The kernel provides two locations in sysfs that contain badblocks
information. The only one ndctl currently uses is region based
badblocks. The problem with this is that this requires root privileges
to calculate namespace-offset badblocks. Since the kernel already
provides a world readable location for namespace badblocks, we can fall
back to that.

Refactor the badblocks retrieval routines to use a bb_iter structure
that contains information for what badblocks file in sysfs to use, to
prepare for a direct namespace-badblocks fallback.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[vishal] remove an error print triggered by opening an invalid file
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 141 +++++++++++++++++++++++--------------------
 ndctl/lib/private.h  |   6 ++
 2 files changed, 82 insertions(+), 65 deletions(-)

No changes since v1

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 481b110..d58be47 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -178,8 +178,7 @@ struct ndctl_region {
 		int state;
 		unsigned long long cookie;
 	} iset;
-	FILE *badblocks;
-	struct badblock bb;
+	struct badblocks_iter bb_iter;
 	enum ndctl_persistence_domain persistence_domain;
 	/* file descriptor for deep flush sysfs entry */
 	int flush_fd;
@@ -376,6 +375,77 @@ NDCTL_EXPORT struct ndctl_ctx *ndctl_ref(struct ndctl_ctx *ctx)
 	return ctx;
 }
 
+static void badblocks_iter_free(struct badblocks_iter *bb_iter)
+{
+	if (bb_iter->file)
+		fclose(bb_iter->file);
+}
+
+static int badblocks_iter_init(struct badblocks_iter *bb_iter, const char *path)
+{
+	char *bb_path;
+	int rc = 0;
+
+	/* if the file is already open */
+	if (bb_iter->file) {
+		fclose(bb_iter->file);
+		bb_iter->file = NULL;
+	}
+
+	if (asprintf(&bb_path, "%s/badblocks", path) < 0)
+		return -errno;
+
+	bb_iter->file = fopen(bb_path, "re");
+	if (!bb_iter->file) {
+		rc = -errno;
+		free(bb_path);
+		return rc;
+	}
+
+	free(bb_path);
+	return rc;
+}
+
+static struct badblock *badblocks_iter_next(struct badblocks_iter *bb_iter)
+{
+	int rc;
+	char *buf = NULL;
+	size_t rlen = 0;
+
+	if (!bb_iter->file)
+		return NULL;
+
+	rc = getline(&buf, &rlen, bb_iter->file);
+	if (rc == -1) {
+		free(buf);
+		return NULL;
+	}
+
+	rc = sscanf(buf, "%llu %u", &bb_iter->bb.offset, &bb_iter->bb.len);
+	free(buf);
+	if (rc != 2) {
+		fclose(bb_iter->file);
+		bb_iter->file = NULL;
+		bb_iter->bb.offset = 0;
+		bb_iter->bb.len = 0;
+		return NULL;
+	}
+
+	return &bb_iter->bb;
+}
+
+static struct badblock *badblocks_iter_first(struct badblocks_iter *bb_iter,
+		struct ndctl_ctx *ctx, const char *path)
+{
+	int rc;
+
+	rc = badblocks_iter_init(bb_iter, path);
+	if (rc < 0)
+		return NULL;
+
+	return badblocks_iter_next(bb_iter);
+}
+
 static void free_namespace(struct ndctl_namespace *ndns, struct list_head *head)
 {
 	struct ndctl_bb *bb, *next;
@@ -511,8 +581,7 @@ static void free_region(struct ndctl_region *region)
 	kmod_module_unref(region->module);
 	free(region->region_buf);
 	free(region->region_path);
-	if (region->badblocks)
-		fclose(region->badblocks);
+	badblocks_iter_free(&region->bb_iter);
 	if (region->flush_fd > 0)
 		close(region->flush_fd);
 	free(region);
@@ -2253,73 +2322,15 @@ NDCTL_EXPORT int ndctl_region_get_numa_node(struct ndctl_region *region)
 	return region->numa_node;
 }
 
-static int regions_badblocks_init(struct ndctl_region *region)
-{
-	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
-	char *bb_path;
-	int rc = 0;
-
-	/* if the file is already open */
-	if (region->badblocks) {
-		fclose(region->badblocks);
-		region->badblocks = NULL;
-	}
-
-	if (asprintf(&bb_path, "%s/badblocks",
-				region->region_path) < 0) {
-		rc = -errno;
-		err(ctx, "region badblocks path allocation failure\n");
-		return rc;
-	}
-
-	region->badblocks = fopen(bb_path, "re");
-	if (!region->badblocks) {
-		rc = -errno;
-		free(bb_path);
-		return rc;
-	}
-
-	free(bb_path);
-	return rc;
-}
-
 NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
 {
-	int rc;
-	char *buf = NULL;
-	size_t rlen = 0;
-
-	if (!region->badblocks)
-		return NULL;
-
-	rc = getline(&buf, &rlen, region->badblocks);
-	if (rc == -1) {
-		free(buf);
-		return NULL;
-	}
-
-	rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
-	free(buf);
-	if (rc != 2) {
-		fclose(region->badblocks);
-		region->badblocks = NULL;
-		region->bb.offset = 0;
-		region->bb.len = 0;
-		return NULL;
-	}
-
-	return &region->bb;
+	return badblocks_iter_next(&region->bb_iter);
 }
 
 NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region)
 {
-	int rc;
-
-	rc = regions_badblocks_init(region);
-	if (rc < 0)
-		return NULL;
-
-	return ndctl_region_get_next_badblock(region);
+	return badblocks_iter_first(&region->bb_iter,
+			ndctl_region_get_ctx(region), region->region_path);
 }
 
 NDCTL_EXPORT enum ndctl_persistence_domain
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b6e438a..d8ed614 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -185,6 +185,11 @@ struct ndctl_lbasize {
 	int num;
 };
 
+struct badblocks_iter {
+	struct badblock bb;
+	FILE *file;
+};
+
 /**
  * struct ndctl_namespace - device claimed by the nd_blk or nd_pmem driver
  * @module: kernel module
@@ -209,6 +214,7 @@ struct ndctl_namespace {
 	int generation;
 	unsigned long long resource, size;
 	enum ndctl_namespace_mode enforce_mode;
+	struct badblocks_iter bb_iter;
 	char *alt_name;
 	uuid_t uuid;
 	struct ndctl_lbasize lbasize;
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
