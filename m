Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEE9522618157
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 16:35:21 -0700 (PDT)
Subject: [PATCH v3] ndctl: add support in libndctl to provide deep flush
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 10 Apr 2018 16:35:20 -0700
Message-ID: <152340324102.45936.18343395170318650700.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Providing an API call in libndctl to support accessing the region deep_flush
in sysfs.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v3: 
- Add "\n" to sysfs write. (Dan)
- add O_CLOEXEC to open() call for sysfs. (Dan)

v2: Cover case where deep_flush doesn't exist, i.e. memmap=nn!ss. (Dan)

 ndctl/lib/libndctl.c   |   35 +++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h       |    1 +
 3 files changed, 37 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 580a450e..03a18985 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -181,6 +181,8 @@ struct ndctl_region {
 	FILE *badblocks;
 	struct badblock bb;
 	enum ndctl_persistence_domain persistence_domain;
+	/* file descriptor for deep flush sysfs entry */
+	int flush_fd;
 };
 
 /**
@@ -511,6 +513,8 @@ static void free_region(struct ndctl_region *region)
 	free(region->region_path);
 	if (region->badblocks)
 		fclose(region->badblocks);
+	if (region->flush_fd > 0)
+		close(region->flush_fd);
 	free(region);
 }
 
@@ -1049,6 +1053,14 @@ NDCTL_EXPORT unsigned long long ndctl_region_get_resource(struct ndctl_region *r
 	return strtoull(buf, NULL, 0);
 }
 
+NDCTL_EXPORT int ndctl_region_deep_flush(struct ndctl_region *region)
+{
+	int rc = pwrite(region->flush_fd, "1\n", 1, 0);
+
+	return (rc == -1) ? -errno : 0;
+}
+
+
 NDCTL_EXPORT const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd)
 {
 	return nvdimm_bus_cmd_name(cmd);
@@ -1791,6 +1803,7 @@ static void *add_region(void *parent, int id, const char *region_base)
 	struct ndctl_bus *bus = parent;
 	struct ndctl_ctx *ctx = bus->ctx;
 	char *path = calloc(1, strlen(region_base) + 100);
+	int perm;
 
 	if (!path)
 		return NULL;
@@ -1866,6 +1879,28 @@ static void *add_region(void *parent, int id, const char *region_base)
 	else
 		region->persistence_domain = region_get_pd_type(buf);
 
+	sprintf(path, "%s/deep_flush", region_base);
+	region->flush_fd = open(path, O_RDWR | O_CLOEXEC);
+	if (region->flush_fd == -1) {
+		/* for those that do not export deep_flush sysfs file */
+		if (errno == ENOENT)
+			goto out;
+		else
+			goto err_read;
+	}
+
+	if (pread(region->flush_fd, buf, 1, 0) == -1) {
+		close(region->flush_fd);
+		goto err_read;
+	}
+
+	perm = strtol(buf, NULL, 0);
+	if (perm == 0) {
+		region->flush_fd = -1;
+		close(region->flush_fd);
+	}
+
+ out:
 	free(path);
 	return region;
 
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 3209aefe..38cc3b9a 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -352,4 +352,5 @@ global:
 	ndctl_dimm_fw_update_supported;
 	ndctl_region_get_persistence_domain;
 	ndctl_bus_get_persistence_domain;
+	ndctl_region_deep_flush;
 } LIBNDCTL_14;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index cf6a77fd..1a622ae5 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -365,6 +365,7 @@ int ndctl_region_enable(struct ndctl_region *region);
 int ndctl_region_disable_invalidate(struct ndctl_region *region);
 int ndctl_region_disable_preserve(struct ndctl_region *region);
 void ndctl_region_cleanup(struct ndctl_region *region);
+int ndctl_region_deep_flush(struct ndctl_region *region);
 
 struct ndctl_interleave_set;
 struct ndctl_interleave_set *ndctl_region_get_interleave_set(

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
