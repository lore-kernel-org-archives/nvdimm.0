Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id F00551A1F89
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 16:31:54 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: add
 ndctl_dimm_get_subsystem_{vendor|device|rev_id} apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Apr 2016 16:31:06 -0700
Message-ID: <146197266650.7588.13786076772465535000.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Ryon Jensen <ryon.jensen@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Similar to PCI device subsystem identifiers, these values are used by
upper level management software.

Reported-by: Ryon Jensen <ryon.jensen@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c          |   48 ++++++++++++++++++++++++++++++++++++++++-------
 lib/libndctl.sym        |    3 +++
 lib/ndctl/libndctl.h.in |    3 +++
 test/libndctl.c         |   19 ++++++++++++++-----
 4 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index d33081cce8ed..b98463e90342 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -128,6 +128,9 @@ struct ndctl_dimm {
 	unsigned short vendor_id;
 	unsigned short device_id;
 	unsigned short revision_id;
+	unsigned short subsystem_vendor_id;
+	unsigned short subsystem_device_id;
+	unsigned short subsystem_revision_id;
 	unsigned long dsm_mask;
 	char *unique_id;
 	char *dimm_path;
@@ -1245,10 +1248,13 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 
 	dimm->handle = -1;
 	dimm->phys_id = -1;
-	dimm->vendor_id = -1;
 	dimm->serial = -1;
+	dimm->vendor_id = -1;
 	dimm->device_id = -1;
 	dimm->revision_id = -1;
+	dimm->subsystem_vendor_id = -1;
+	dimm->subsystem_device_id = -1;
+	dimm->subsystem_revision_id = -1;
 	for (i = 0; i < formats; i++)
 		dimm->format[i] = -1;
 
@@ -1276,16 +1282,14 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 		goto err_read;
 	dimm->phys_id = strtoul(buf, NULL, 0);
 
-	sprintf(path, "%s/nfit/vendor", dimm_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		dimm->vendor_id = -1;
-	else
-		dimm->vendor_id = strtoul(buf, NULL, 0);
-
 	sprintf(path, "%s/nfit/serial", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->serial = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/nfit/vendor", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->vendor_id = strtoul(buf, NULL, 0);
+
 	sprintf(path, "%s/nfit/device", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->device_id = strtoul(buf, NULL, 0);
@@ -1294,6 +1298,18 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->revision_id = strtoul(buf, NULL, 0);
 
+	sprintf(path, "%s/nfit/subsystem_vendor", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->subsystem_vendor_id = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/nfit/subsystem_device", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->subsystem_device_id = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/nfit/subsystem_rev_id", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		dimm->subsystem_revision_id = strtoul(buf, NULL, 0);
+
 	dimm->formats = formats;
 	sprintf(path, "%s/nfit/format", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -1368,6 +1384,24 @@ NDCTL_EXPORT unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm)
 	return dimm->revision_id;
 }
 
+NDCTL_EXPORT unsigned short ndctl_dimm_get_subsystem_vendor(
+		struct ndctl_dimm *dimm)
+{
+	return dimm->subsystem_vendor_id;
+}
+
+NDCTL_EXPORT unsigned short ndctl_dimm_get_subsystem_device(
+		struct ndctl_dimm *dimm)
+{
+	return dimm->subsystem_device_id;
+}
+
+NDCTL_EXPORT unsigned short ndctl_dimm_get_subsystem_revision(
+		struct ndctl_dimm *dimm)
+{
+	return dimm->subsystem_revision_id;
+}
+
 NDCTL_EXPORT unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm)
 {
 	return dimm->format[0];
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 06dd50a6bb15..dc9e69d637da 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -40,6 +40,9 @@ global:
 	ndctl_dimm_get_vendor;
 	ndctl_dimm_get_device;
 	ndctl_dimm_get_revision;
+	ndctl_dimm_get_subsystem_vendor;
+	ndctl_dimm_get_subsystem_device;
+	ndctl_dimm_get_subsystem_revision;
 	ndctl_dimm_get_format;
 	ndctl_dimm_get_formats;
 	ndctl_dimm_get_formatN;
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index 29845eb88843..3241e92535a5 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -120,6 +120,9 @@ unsigned short ndctl_dimm_get_phys_id(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm);
+unsigned short ndctl_dimm_get_subsystem_vendor(struct ndctl_dimm *dimm);
+unsigned short ndctl_dimm_get_subsystem_device(struct ndctl_dimm *dimm);
+unsigned short ndctl_dimm_get_subsystem_revision(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_formats(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_formatN(struct ndctl_dimm *dimm, int i);
diff --git a/test/libndctl.c b/test/libndctl.c
index dcd4d509659e..fb4a2eac74f9 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -116,6 +116,7 @@ static const char *NFIT_PROVIDER1 = "nfit_test.1";
 struct dimm {
 	unsigned int handle;
 	unsigned int phys_id;
+	unsigned int subsystem_vendor;
 	union {
 		unsigned long flags;
 		struct {
@@ -134,15 +135,15 @@ struct dimm {
 	(((n & 0xfff) << 16) | ((s & 0xf) << 12) | ((i & 0xf) << 8) \
 	 | ((c & 0xf) << 4) | (d & 0xf))
 static struct dimm dimms0[] = {
-	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, { 0 }, 2, { 0x201, 0x301, }, },
 };
 
 static struct dimm dimms1[] = {
 	{
-		DIMM_HANDLE(0, 0, 0, 0, 0), 0, {
+		DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, {
 			.f_arm = 1,
 			.f_save = 1,
 			.f_flush = 1,
@@ -2052,6 +2053,14 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			}
 		}
 
+		if (ndctl_dimm_get_subsystem_vendor(dimm)
+				!= dimms[i].subsystem_vendor) {
+			fprintf(stderr, "dimm%d expected subsystem vendor: %d got: %d\n",
+					i, dimms[i].subsystem_vendor,
+					ndctl_dimm_get_subsystem_vendor(dimm));
+			return -ENXIO;
+		}
+
 		rc = check_commands(bus, dimm, bus_commands, dimm_commands, test);
 		if (rc)
 			return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
