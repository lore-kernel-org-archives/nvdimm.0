Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 086B51A1F83
 for <linux-nvdimm@lists.01.org>; Tue,  5 Apr 2016 17:37:55 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: add ndctl_dimm_get_{formats|formatN}
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 05 Apr 2016 17:37:03 -0700
Message-ID: <20160406003703.6821.64797.stgit@dwillia2-desk3.jf.intel.com>
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

Add apis to return the alternative format interface codes that a given
dimm supports.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c          |   42 +++++++++++++++++++++++++++++++++++-------
 lib/libndctl.sym        |    2 ++
 lib/ndctl/libndctl.h.in |    2 ++
 test/libndctl.c         |   33 +++++++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index b628243df651..26de91af8a63 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -111,12 +111,13 @@ struct ndctl_bus {
  * @vendor_id: hardware component vendor
  * @device_id: hardware device id
  * @revision_id: hardware revision id
- * @format_id: format interface code number
  * @node: system node-id
  * @socket: socket-id in the node
  * @imc: memory-controller-id in the socket
  * @channel: channel-id in the memory-controller
  * @dimm: dimm-id in the channel
+ * @formats: number of support interfaces
+ * @format: array of format interface code numbers
  */
 struct ndctl_dimm {
 	struct kmod_module *module;
@@ -126,7 +127,6 @@ struct ndctl_dimm {
 	unsigned short vendor_id;
 	unsigned short device_id;
 	unsigned short revision_id;
-	unsigned short format_id;
 	unsigned long dsm_mask;
 	char *dimm_path;
 	char *dimm_buf;
@@ -143,6 +143,8 @@ struct ndctl_dimm {
 		};
 	};
 	struct list_node list;
+	int formats;
+	int format[0];
 };
 
 /**
@@ -1179,7 +1181,7 @@ static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
 
 static int add_dimm(void *parent, int id, const char *dimm_base)
 {
-	int rc = -ENOMEM;
+	int rc, formats, i;
 	struct ndctl_dimm *dimm;
 	char buf[SYSFS_ATTR_SIZE];
 	struct ndctl_bus *bus = parent;
@@ -1189,7 +1191,13 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (!path)
 		return -ENOMEM;
 
-	dimm = calloc(1, sizeof(*dimm));
+	sprintf(path, "%s/nfit/formats", dimm_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		formats = 1;
+	else
+		formats = strtoul(buf, NULL, 0);
+
+	dimm = calloc(1, sizeof(*dimm) + sizeof(int) * formats);
 	if (!dimm)
 		goto err_dimm;
 	dimm->bus = bus;
@@ -1228,7 +1236,9 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->serial = -1;
 	dimm->device_id = -1;
 	dimm->revision_id = -1;
-	dimm->format_id = -1;
+	for (i = 0; i < formats; i++)
+		dimm->format[i] = -1;
+
 	if (!ndctl_bus_has_nfit(bus))
 		goto out;
 
@@ -1260,9 +1270,15 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		dimm->revision_id = strtoul(buf, NULL, 0);
 
+	dimm->formats = formats;
 	sprintf(path, "%s/nfit/format", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
-		dimm->format_id = strtoul(buf, NULL, 0);
+		dimm->format[0] = strtoul(buf, NULL, 0);
+	for (i = 1; i < formats; i++) {
+		sprintf(path, "%s/nfit/format%d", dimm_base, i);
+		if (sysfs_read_attr(ctx, path, buf) == 0)
+			dimm->format[i] = strtoul(buf, NULL, 0);
+	}
 
 	sprintf(path, "%s/nfit/flags", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
@@ -1332,7 +1348,19 @@ NDCTL_EXPORT unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm)
 
 NDCTL_EXPORT unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm)
 {
-	return dimm->format_id;
+	return dimm->format[0];
+}
+
+NDCTL_EXPORT int ndctl_dimm_get_formats(struct ndctl_dimm *dimm)
+{
+	return dimm->formats;
+}
+
+NDCTL_EXPORT int ndctl_dimm_get_formatN(struct ndctl_dimm *dimm, int i)
+{
+	if (i < dimm->formats && i >= 0)
+		return dimm->format[i];
+	return -EINVAL;
 }
 
 NDCTL_EXPORT unsigned int ndctl_dimm_get_major(struct ndctl_dimm *dimm)
diff --git a/lib/libndctl.sym b/lib/libndctl.sym
index 9df2b5a6e89d..5ff8848ee6d3 100644
--- a/lib/libndctl.sym
+++ b/lib/libndctl.sym
@@ -41,6 +41,8 @@ global:
 	ndctl_dimm_get_device;
 	ndctl_dimm_get_revision;
 	ndctl_dimm_get_format;
+	ndctl_dimm_get_formats;
+	ndctl_dimm_get_formatN;
 	ndctl_dimm_get_major;
 	ndctl_dimm_get_minor;
 	ndctl_dimm_get_serial;
diff --git a/lib/ndctl/libndctl.h.in b/lib/ndctl/libndctl.h.in
index 831f7822e91f..2a05e0ba477c 100644
--- a/lib/ndctl/libndctl.h.in
+++ b/lib/ndctl/libndctl.h.in
@@ -121,6 +121,8 @@ unsigned short ndctl_dimm_get_vendor(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_device(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_revision(struct ndctl_dimm *dimm);
 unsigned short ndctl_dimm_get_format(struct ndctl_dimm *dimm);
+int ndctl_dimm_get_formats(struct ndctl_dimm *dimm);
+int ndctl_dimm_get_formatN(struct ndctl_dimm *dimm, int i);
 unsigned int ndctl_dimm_get_major(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_minor(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_get_id(struct ndctl_dimm *dimm);
diff --git a/test/libndctl.c b/test/libndctl.c
index 0cab89208867..0e9c830e68a1 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -126,29 +126,31 @@ struct dimm {
 			unsigned int f_restore:1;
 		};
 	};
+	int formats;
+	int format[2];
 };
 
 #define DIMM_HANDLE(n, s, i, c, d) \
 	(((n & 0xfff) << 16) | ((s & 0xf) << 12) | ((i & 0xf) << 8) \
 	 | ((c & 0xf) << 4) | (d & 0xf))
 static struct dimm dimms0[] = {
-	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, { 0 }, },
-	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, { 0 }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, { 0 }, },
-	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, { 0 }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 0), 0, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 0, 0, 1), 1, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 0), 2, { 0 }, 2, { 0x201, 0x301, }, },
+	{ DIMM_HANDLE(0, 0, 1, 0, 1), 3, { 0 }, 2, { 0x201, 0x301, }, },
 };
 
 static struct dimm dimms1[] = {
 	{
-		DIMM_HANDLE(0, 0, 0, 0, 0), 0,
-		{
+		DIMM_HANDLE(0, 0, 0, 0, 0), 0, {
 			.f_arm = 1,
 			.f_save = 1,
 			.f_flush = 1,
 			.f_smart = 1,
 			.f_restore = 1,
 		},
-	}
+		1, { 0x101, },
+	},
 };
 
 static struct btt {
@@ -1886,7 +1888,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 		unsigned long bus_commands, unsigned long dimm_commands,
 		struct ndctl_test *test)
 {
-	int i, rc;
+	int i, j, rc;
 
 	for (i = 0; i < n; i++) {
 		struct ndctl_dimm *dimm = get_dimm_by_handle(bus, dimms[i].handle);
@@ -1930,6 +1932,21 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			return -ENXIO;
 		}
 
+		if (ndctl_dimm_get_formats(dimm) != dimms[i].formats) {
+			fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
+					i, dimms[i].formats,
+					ndctl_dimm_get_formats(dimm));
+			return -ENXIO;
+		}
+		for (j = 0; j < dimms[i].formats; j++) {
+			if (ndctl_dimm_get_formatN(dimm, j) != dimms[i].format[j]) {
+				fprintf(stderr, "dimm%d expected format[%d]: %d got: %d\n",
+						i, j, dimms[i].format[j],
+						ndctl_dimm_get_formatN(dimm, j));
+				return -ENXIO;
+			}
+		}
+
 		rc = check_commands(bus, dimm, bus_commands, dimm_commands, test);
 		if (rc)
 			return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
