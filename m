Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 1F6721A1E9E
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 16:58:14 -0700 (PDT)
Subject: [ndctl PATCH 1/2] ndctl: add ndctl_dimm_get_unique_id() api
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2016 16:57:25 -0700
Message-ID: <146171504515.32030.1423804537625453932.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146171495520.32030.11537526996792266896.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146171495520.32030.11537526996792266896.stgit@dwillia2-desk3.amr.corp.intel.com>
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

ACPI 6.1 defines a common format for identifying a DIMM.  See section
5.2.25.9 "NVDIMM representation format".  If the kernel supports this
identifier it can be read from dimmX/nfit/id and retrieved via this api.
If the kernel does not export a dimm id this api returns NULL.

Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c          |   38 +++++++++++++++++++++++++++++++-------
 lib/libndctl.sym        |    1 +
 lib/ndctl/libndctl.h.in |    1 +
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index 58b7fa9d6666..d33081cce8ed 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -129,6 +129,7 @@ struct ndctl_dimm {
 	unsigned short device_id;
 	unsigned short revision_id;
 	unsigned long dsm_mask;
+	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
 	int buf_len;
@@ -587,6 +588,18 @@ static void free_region(struct ndctl_region *region)
 	free(region);
 }
 
+static void free_dimm(struct ndctl_dimm *dimm)
+{
+	if (!dimm)
+		return;
+	free(dimm->unique_id);
+	free(dimm->dimm_buf);
+	free(dimm->dimm_path);
+	if (dimm->module)
+		kmod_module_unref(dimm->module);
+	free(dimm);
+}
+
 static void free_bus(struct ndctl_bus *bus, struct list_head *head)
 {
 	struct ndctl_dimm *dimm, *_d;
@@ -594,10 +607,7 @@ static void free_bus(struct ndctl_bus *bus, struct list_head *head)
 
 	list_for_each_safe(&bus->dimms, dimm, _d, list) {
 		list_del_from(&bus->dimms, &dimm->list);
-		free(dimm->dimm_path);
-		free(dimm->dimm_buf);
-		kmod_module_unref(dimm->module);
-		free(dimm);
+		free_dimm(dimm);
 	}
 	list_for_each_safe(&bus->regions, region, _r, list)
 		free_region(region);
@@ -1245,6 +1255,17 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (!ndctl_bus_has_nfit(bus))
 		goto out;
 
+	/*
+	 * 'unique_id' may not be available on older kernels, so don't
+	 * fail if the read fails.
+	 */
+	sprintf(path, "%s/nfit/id", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		dimm->unique_id = strdup(buf);
+		if (!dimm->unique_id)
+			goto err_read;
+	}
+
 	sprintf(path, "%s/nfit/handle", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1293,9 +1314,7 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	return 0;
 
  err_read:
-	free(dimm->dimm_buf);
-	free(dimm->dimm_path);
-	free(dimm);
+	free_dimm(dimm);
  err_dimm:
 	free(path);
 	return rc;
@@ -1381,6 +1400,11 @@ NDCTL_EXPORT unsigned int ndctl_dimm_get_id(struct ndctl_dimm *dimm)
 	return dimm->id;
 }
 
+NDCTL_EXPORT const char *ndctl_dimm_get_unique_id(struct ndctl_dimm *dimm)
+{
+	return dimm->unique_id;
+}
+
 NDCTL_EXPORT unsigned int ndctl_dimm_get_serial(struct ndctl_dimm *dimm)
 {
 	return dimm->serial;
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 17a9085dd092..06dd50a6bb15 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -47,6 +47,7 @@ global:
 	ndctl_dimm_get_minor;
 	ndctl_dimm_get_serial;
 	ndctl_dimm_get_id;
+	ndctl_dimm_get_unique_id;
 	ndctl_dimm_get_devname;
 	ndctl_dimm_get_cmd_name;
 	ndctl_dimm_has_errors;
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index 4b0b25fb7cba..29845eb88843 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -126,6 +126,7 @@ int ndctl_dimm_get_formatN(struct ndctl_dimm *dimm, int i);
 unsigned int ndctl_dimm_get_major(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_minor(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_id(struct ndctl_dimm *dimm);
+const char *ndctl_dimm_get_unique_id(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_serial(struct ndctl_dimm *dimm);
 const char *ndctl_dimm_get_cmd_name(struct ndctl_dimm *dimm, int cmd);
 int ndctl_dimm_is_cmd_supported(struct ndctl_dimm *dimm, int cmd);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
