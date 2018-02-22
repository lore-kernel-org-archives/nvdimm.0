Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 328E6208F7AAD
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 12:43:48 -0800 (PST)
Subject: [PATCH v2 4/4] ndctl: accept DIMM name without -d option
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 22 Feb 2018 13:49:48 -0700
Message-ID: <151933258802.36856.4324987007442257845.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
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

Making update-firmware in sync with other ndctl syntax and accept DIMM
id without using a switch. The -d option will still be accepted. Now
it will accept multiple dimm ids as well as the "all" option.
i.e.
ndctl update-firmware -f file.bin nmem0 nmem1

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/update.c |  119 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 78 insertions(+), 41 deletions(-)

diff --git a/Documentation/ndctl/ndctl-update-firmware.txt b/Documentation/ndctl/ndctl-update-firmware.txt
index d742302..6d74c11 100644
--- a/Documentation/ndctl/ndctl-update-firmware.txt
+++ b/Documentation/ndctl/ndctl-update-firmware.txt
@@ -8,7 +8,18 @@ ndctl-update-firmware - provides updating of NVDIMM firmware
 SYNOPSIS
 --------
 [verse]
-'ndctl update-firmware' -f <firmware_file> -d <dimm name>
+'ndctl update-firmware' <nmem0> [<nmem1>..<nmemN>] [<options>]
+
+This command updates the persistent DIMM's firmware.
+
+OPTIONS
+-------
+-f::
+--firmware::
+	firmware file to be updated.
+-v::
+--verbose::
+	turn on verbose/debug option
 
 COPYRIGHT
 ---------
diff --git a/ndctl/update.c b/ndctl/update.c
index b148b70..acf2a64 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -467,32 +467,6 @@ static int update_firmware(struct update_context *uctx)
 	return 0;
 }
 
-static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
-{
-	struct ndctl_dimm *dimm;
-	struct ndctl_bus *bus;
-	int rc = -ENODEV;
-
-	ndctl_bus_foreach(ctx, bus)
-		ndctl_dimm_foreach(bus, dimm) {
-			if (!util_dimm_filter(dimm, uctx->dimm_id))
-				continue;
-			if (!ndctl_dimm_fw_update_supported(dimm)) {
-				error("DIMM firmware update not supported by the kernel.");
-				return -ENOTSUP;
-			}
-			uctx->dimm = dimm;
-			rc = update_firmware(uctx);
-			if (rc < 0) {
-				error("Update firmware for dimm %s failed\n",
-						ndctl_dimm_get_devname(dimm));
-				continue;
-			}
-		}
-
-	return rc;
-}
-
 static int verify_fw_file(struct update_context *uctx)
 {
 	struct stat st;
@@ -538,6 +512,29 @@ cleanup:
 	return rc;
 }
 
+static int process_dimm(struct update_context *uctx, const char *dimm_id,
+		struct ndctl_dimm *dimm)
+{
+	int rc;
+
+	if (!util_dimm_filter(dimm, dimm_id))
+		return -ENODEV;
+	if (!ndctl_dimm_fw_update_supported(dimm)) {
+		error("DIMM firmware update not supported by the kernel.");
+		return -ENOTSUP;
+	}
+
+	uctx->dimm = dimm;
+	rc = update_firmware(uctx);
+	if (rc < 0) {
+		error("Update firmware for dimm %s failed\n",
+				ndctl_dimm_get_devname(dimm));
+		return rc;
+	}
+
+	return -ENODEV;
+}
+
 int cmd_update_firmware(int argc, const char **argv, void *ctx)
 {
 	bool verbose;
@@ -554,13 +551,34 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 		"ndctl update_firmware [<options>]",
 		NULL
 	};
-	int i, rc;
+	int i, rc, err = 0;
+	unsigned long id;
 
 	argc = parse_options(argc, argv, options, u, 0);
-	for (i = 0; i < argc; i++)
-		error("unknown parameter \"%s\"", argv[i]);
-	if (argc)
+
+	if (argc == 0 && !uctx.dimm_id)
 		usage_with_options(u, options);
+	if (!uctx.dimm_id) {
+		for (i = 0; i < argc; i++) {
+			if (strcmp(argv[i], "all") == 0) {
+				argv[0] = "all";
+				argc = 1;
+				break;
+			}
+
+			if (sscanf(argv[i], "nmem%lu", &id) != 1) {
+				fprintf(stderr,
+					"'%s' is not a valid dimm name\n",
+					argv[i]);
+				err++;
+			}
+		}
+
+		if (err == argc) {
+			usage_with_options(u, options);
+			return -EINVAL;
+		}
+	}
 
 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
@@ -571,25 +589,44 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 		return -EINVAL;
 	}
 
-	if (!uctx.dimm_id) {
-		error("No DIMM ID provided");
-		usage_with_options(u, options);
-		return -EINVAL;
-	}
-
 	rc = verify_fw_file(&uctx);
 	if (rc < 0) {
 		error("Failed to verify firmware file %s", uctx.fw_path);
 		return rc;
 	}
 
-	rc = get_ndctl_dimm(&uctx, ctx);
-	if (rc < 0) {
-		if (rc == -ENODEV)
-			error("DIMM %s not found", uctx.dimm_id);
-		return rc;
+	for (i = 0; i < argc; i++) {
+		struct ndctl_dimm *dimm;
+		struct ndctl_bus *bus;
+
+		if (sscanf(argv[i], "nmem%lu", &id) != 1
+				&& strcmp(argv[i], "all") != 0)
+			continue;
+
+		ndctl_bus_foreach(ctx, bus)
+			ndctl_dimm_foreach(bus, dimm) {
+				rc = process_dimm(&uctx, argv[i], dimm);
+				if (rc < 0) {
+					if (rc == -ENOTSUP)
+						goto cleanup;
+					continue;
+				}
+			}
 	}
 
+	if (uctx.dimm_id) {
+		struct ndctl_dimm *dimm;
+		struct ndctl_bus *bus;
+
+		ndctl_bus_foreach(ctx, bus)
+			ndctl_dimm_foreach(bus, dimm) {
+				rc = process_dimm(&uctx, uctx.dimm_id, dimm);
+				if (rc < 0)
+					goto cleanup;
+			}
+	}
+
+cleanup:
 	if (uctx.start)
 		ndctl_cmd_unref(uctx.start);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
