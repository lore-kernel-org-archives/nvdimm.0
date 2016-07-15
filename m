Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id DB0F01A1F22
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 12:45:58 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: add
 ndctl_dimm_get_manufacturing_{date|location} apis
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Jul 2016 12:42:45 -0700
Message-ID: <146861176516.17090.10204922835726487624.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Kristin Jacque <kristin.jacque@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

This data is encoded in the unique_id.  Since we provide standalone
helpers to retrieve the other fields of the unique_id, do the same for
these attributes.

Reported-by: Kristin Jacque <kristin.jacque@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   24 ++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 ++
 ndctl/libndctl.h.in    |    2 ++
 test/libndctl.c        |   20 +++++++++++++++-----
 4 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 6860a4b6fa92..0722f79470c3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -133,6 +133,8 @@ struct ndctl_dimm {
 	unsigned short subsystem_vendor_id;
 	unsigned short subsystem_device_id;
 	unsigned short subsystem_revision_id;
+	unsigned short manufacturing_date;
+	unsigned char manufacturing_location;
 	unsigned long dsm_mask;
 	char *unique_id;
 	char *dimm_path;
@@ -1168,6 +1170,8 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->subsystem_vendor_id = -1;
 	dimm->subsystem_device_id = -1;
 	dimm->subsystem_revision_id = -1;
+	dimm->manufacturing_date = -1;
+	dimm->manufacturing_location = -1;
 	for (i = 0; i < formats; i++)
 		dimm->format[i] = -1;
 
@@ -1180,9 +1184,17 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	 */
 	sprintf(path, "%s/nfit/id", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		unsigned int b[9];
+
 		dimm->unique_id = strdup(buf);
 		if (!dimm->unique_id)
 			goto err_read;
+		if (sscanf(dimm->unique_id, "%02x%02x-%02x-%02x%02x-%02x%02x%02x%02x",
+					&b[0], &b[1], &b[2], &b[3], &b[4],
+					&b[5], &b[6], &b[7], &b[8]) == 9) {
+			dimm->manufacturing_date = b[3] << 8 | b[4];
+			dimm->manufacturing_location = b[2];
+		}
 	}
 
 	sprintf(path, "%s/nfit/handle", dimm_base);
@@ -1315,6 +1327,18 @@ NDCTL_EXPORT unsigned short ndctl_dimm_get_subsystem_revision(
 	return dimm->subsystem_revision_id;
 }
 
+NDCTL_EXPORT unsigned short ndctl_dimm_get_manufacturing_date(
+		struct ndctl_dimm *dimm)
+{
+	return dimm->manufacturing_date;
+}
+
+NDCTL_EXPORT unsigned char ndctl_dimm_get_manufacturing_location(
+		struct ndctl_dimm *dimm)
+{
+	return dimm->manufacturing_location;
+}
+
 NDCTL_EXPORT unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm)
 {
 	return dimm->format[0];
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a22732467f8a..6af267a04191 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -41,6 +41,8 @@ global:
 	ndctl_dimm_get_vendor;
 	ndctl_dimm_get_device;
 	ndctl_dimm_get_revision;
+	ndctl_dimm_get_manufacturing_date;
+	ndctl_dimm_get_manufacturing_location;
 	ndctl_dimm_get_subsystem_vendor;
 	ndctl_dimm_get_subsystem_device;
 	ndctl_dimm_get_subsystem_revision;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index e6766cef56bb..9e0e82acfd2f 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -124,6 +124,8 @@ unsigned short ndctl_dimm_get_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_vendor(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_device(struct ndctl_dimm *dimm);
+unsigned short ndctl_dimm_get_manufacturing_date(struct ndctl_dimm *dimm);
+unsigned char ndctl_dimm_get_manufacturing_location(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_subsystem_revision(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm);
 int ndctl_dimm_get_formats(struct ndctl_dimm *dimm);
diff --git a/test/libndctl.c b/test/libndctl.c
index b03fc27a5f0b..011d905f7fb4 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -118,6 +118,8 @@ struct dimm {
 	unsigned int handle;
 	unsigned int phys_id;
 	unsigned int subsystem_vendor;
+	unsigned short manufacturing_date;
+	unsigned char manufacturing_location;
 	union {
 		unsigned long flags;
 		struct {
@@ -136,15 +138,15 @@ struct dimm {
 	(((n & 0xfff) << 16) | ((s & 0xf) << 12) | ((i & 0xf) << 8) \
 	 | ((c & 0xf) << 4) | (d & 0xf))
 static struct dimm dimms0[] = {
-	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, { 0 }, 2, { 0x201, 0x301, }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, 0, 2016, 10, { 0 }, 2, { 0x201, 0x301, }, },
 };
 
 static struct dimm dimms1[] = {
 	{
-		DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, {
+		DIMM_HANDLE(0, 0, 0, 0, 0), 0, 0, 2016, 10, {
 			.f_arm = 1,
 			.f_save = 1,
 			.f_flush = 1,
@@ -2386,6 +2388,14 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			return -ENXIO;
 		}
 
+		if (ndctl_dimm_get_manufacturing_date(dimm)
+				!= dimms[i].manufacturing_date) {
+			fprintf(stderr, "dimm%d expected manufacturing date: %d got: %d\n",
+					i, dimms[i].manufacturing_date,
+					ndctl_dimm_get_manufacturing_date(dimm));
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
