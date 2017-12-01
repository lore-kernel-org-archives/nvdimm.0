Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BF5321A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:22 -0800 (PST)
Subject: [ndctl PATCH 01/17] libndctl: rename dimm dsm_mask to cmd_mask
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:24:34 -0800
Message-ID: <151217067433.28402.11135884903229702993.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for converting the NVDIMM_FAMILY_INTEL support to use
ND_CMD_CALL for SMART and other operations, rename dsm_mask to cmd_mask.
"DSM" is ACPI specific and the Linux kernel ND_CMD number are generic
numbers that Linux understands for any NVDIMM bus, ACPI-defined or not.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |   26 +++++++++++++-------------
 ndctl/lib/private.h  |    6 +++---
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 44348463dc0a..bb47c9d1f522 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -622,7 +622,7 @@ static int device_parse(struct ndctl_ctx *ctx, struct ndctl_bus *bus,
 	return sysfs_device_parse(ctx, base_path, dev_name, parent, add_dev);
 }
 
-static int to_dsm_index(const char *name, int dimm)
+static int to_cmd_index(const char *name, int dimm)
 {
 	const char *(*cmd_name_fn)(unsigned cmd);
 	int i, end_cmd;
@@ -650,7 +650,7 @@ static int to_dsm_index(const char *name, int dimm)
 
 static unsigned long parse_commands(char *commands, int dimm)
 {
-	unsigned long dsm_mask = 0;
+	unsigned long cmd_mask = 0;
 	char *start, *end;
 
 	start = commands;
@@ -658,12 +658,12 @@ static unsigned long parse_commands(char *commands, int dimm)
 		int cmd;
 
 		*end = '\0';
-		cmd = to_dsm_index(start, dimm);
+		cmd = to_cmd_index(start, dimm);
 		if (cmd)
-			dsm_mask |= 1 << cmd;
+			cmd_mask |= 1 << cmd;
 		start = end + 1;
 	}
-	return dsm_mask;
+	return cmd_mask;
 }
 
 static void parse_nfit_mem_flags(struct ndctl_dimm *dimm, char *flags)
@@ -740,7 +740,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 	sprintf(path, "%s/device/commands", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-	bus->dsm_mask = parse_commands(buf, 0);
+	bus->cmd_mask = parse_commands(buf, 0);
 
 	sprintf(path, "%s/device/nfit/revision", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0) {
@@ -1016,7 +1016,7 @@ NDCTL_EXPORT const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd)
 NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
 		int cmd)
 {
-	return !!(bus->dsm_mask & (1ULL << cmd));
+	return !!(bus->cmd_mask & (1ULL << cmd));
 }
 
 NDCTL_EXPORT unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus)
@@ -1202,7 +1202,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	sprintf(path, "%s/commands", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
-	dimm->dsm_mask = parse_commands(buf, 1);
+	dimm->cmd_mask = parse_commands(buf, 1);
 
 	dimm->dimm_buf = calloc(1, strlen(dimm_base) + 50);
 	if (!dimm->dimm_buf)
@@ -1231,7 +1231,7 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->subsystem_revision_id = -1;
 	dimm->manufacturing_date = -1;
 	dimm->manufacturing_location = -1;
-	dimm->dsm_family = -1;
+	dimm->cmd_family = -1;
 	for (i = 0; i < formats; i++)
 		dimm->format[i] = -1;
 
@@ -1304,10 +1304,10 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 
 	sprintf(path, "%s/nfit/family", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
-		dimm->dsm_family = strtoul(buf, NULL, 0);
-	if (dimm->dsm_family == NVDIMM_FAMILY_HPE1)
+		dimm->cmd_family = strtoul(buf, NULL, 0);
+	if (dimm->cmd_family == NVDIMM_FAMILY_HPE1)
 		dimm->smart_ops = hpe1_smart_ops;
-	if (dimm->dsm_family == NVDIMM_FAMILY_MSFT)
+	if (dimm->cmd_family == NVDIMM_FAMILY_MSFT)
 		dimm->smart_ops = msft_smart_ops;
 
 	dimm->formats = formats;
@@ -1524,7 +1524,7 @@ NDCTL_EXPORT int ndctl_dimm_failed_map(struct ndctl_dimm *dimm)
 NDCTL_EXPORT int ndctl_dimm_is_cmd_supported(struct ndctl_dimm *dimm,
 		int cmd)
 {
-	return !!(dimm->dsm_mask & (1ULL << cmd));
+	return !!(dimm->cmd_mask & (1ULL << cmd));
 }
 
 NDCTL_EXPORT int ndctl_dimm_get_health_eventfd(struct ndctl_dimm *dimm)
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 499316b3b19d..64bc5aee1134 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -75,8 +75,8 @@ struct ndctl_dimm {
 	unsigned short subsystem_revision_id;
 	unsigned short manufacturing_date;
 	unsigned char manufacturing_location;
-	unsigned long dsm_family;
-	unsigned long dsm_mask;
+	unsigned long cmd_family;
+	unsigned long cmd_mask;
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
@@ -155,7 +155,7 @@ struct ndctl_bus {
 	size_t buf_len;
 	char *wait_probe_path;
 	char *scrub_path;
-	unsigned long dsm_mask;
+	unsigned long cmd_mask;
 	unsigned long nfit_dsm_mask;
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
