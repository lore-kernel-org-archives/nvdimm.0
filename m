Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1976720954CA4
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 13:59:59 -0800 (PST)
Subject: [PATCH 1/2] ndctl: add more error outs to update firmware and
 enable verbose debug
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 21 Feb 2018 15:05:58 -0700
Message-ID: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
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

update-firmware is missing verbose option for debug outputs. Also adding
additional error outs to give better indication if something has failed
and why.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/update.c |   99 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 30 deletions(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index 877d37f..fc26acf 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -104,7 +104,7 @@ static int verify_fw_size(struct update_context *uctx)
 	struct fw_info *fw = &uctx->dimm_fw;
 
 	if (uctx->fw_size > fw->store_size) {
-		error("Firmware file size greater than DIMM store\n");
+		error("Firmware file size greater than DIMM store");
 		return -ENOSPC;
 	}
 
@@ -119,16 +119,20 @@ static int submit_get_firmware_info(struct update_context *uctx)
 	struct fw_info *fw = &uctx->dimm_fw;
 
 	cmd = ndctl_dimm_cmd_new_fw_get_info(uctx->dimm);
-	if (!cmd)
+	if (!cmd) {
+		error("%s: Fail to get new cmd", __func__);
 		return -ENXIO;
+	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc < 0)
+	if (rc < 0) {
+		error("%s: Fail to submit cmd", __func__);
 		return rc;
+	}
 
 	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 	if (status != FW_SUCCESS) {
-		error("GET FIRMWARE INFO failed: %#x\n", status);
+		error("GET FIRMWARE INFO failed: %#x", status);
 		return -ENXIO;
 	}
 
@@ -165,18 +169,22 @@ static int submit_start_firmware_upload(struct update_context *uctx)
 	struct fw_info *fw = &uctx->dimm_fw;
 
 	cmd = ndctl_dimm_cmd_new_fw_start_update(uctx->dimm);
-	if (!cmd)
+	if (!cmd) {
+		error("%s: Fail to get new cmd", __func__);
 		return -ENXIO;
+	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc < 0)
+	if (rc < 0) {
+		error("%s: Fail to submit cmd", __func__);
 		return rc;
+	}
 
 	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 	if (status != FW_SUCCESS) {
-		error("START FIRMWARE UPDATE failed: %#x\n", status);
+		error("START FIRMWARE UPDATE failed: %#x", status);
 		if (status == FW_EBUSY)
-			error("Another firmware upload in progress or finished.\n");
+			error("Another firmware upload in progress or finished.");
 		return -ENXIO;
 	}
 
@@ -196,8 +204,11 @@ static int get_fw_data_from_file(int fd, void *buf, uint32_t len,
 
 	while (len) {
 		rc = pread(fd, buf, len, offset);
-		if (rc < 0)
-			return -errno;
+		if (rc < 0) {
+			rc = -errno;
+			perror("pread");
+			return rc;
+		}
 		len -= rc;
 	}
 
@@ -241,7 +252,7 @@ static int send_firmware(struct update_context *uctx)
 
 		status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 		if (status != FW_SUCCESS) {
-			error("SEND FIRMWARE failed: %#x\n", status);
+			error("SEND FIRMWARE failed: %#x", status);
 			rc = -ENXIO;
 			goto cleanup;
 		}
@@ -267,16 +278,20 @@ static int submit_finish_firmware(struct update_context *uctx)
 	enum ND_FW_STATUS status;
 
 	cmd = ndctl_dimm_cmd_new_fw_finish(uctx->start);
-	if (!cmd)
+	if (!cmd) {
+		error("%s: Fail to get new cmd", __func__);
 		return -ENXIO;
+	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc < 0)
+	if (rc < 0) {
+		error("%s: Fail to submit cmd", __func__);
 		goto out;
+	}
 
 	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 	if (status != FW_SUCCESS) {
-		error("FINISH FIRMWARE UPDATE failed: %#x\n", status);
+		error("FINISH FIRMWARE UPDATE failed: %#x", status);
 		rc = -ENXIO;
 		goto out;
 	}
@@ -302,7 +317,7 @@ static int submit_abort_firmware(struct update_context *uctx)
 
 	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 	if (!(status & ND_CMD_STATUS_FIN_ABORTED)) {
-		error("FW update abort failed: %#x\n", status);
+		error("FW update abort failed: %#x", status);
 		rc = -ENXIO;
 		goto out;
 	}
@@ -412,36 +427,42 @@ static int update_firmware(struct update_context *uctx)
 	int rc;
 
 	rc = submit_get_firmware_info(uctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("Unable to get firmware info");
 		return rc;
+	}
 
 	rc = submit_start_firmware_upload(uctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("Unable to start firmware upload");
 		return rc;
+	}
 
 	printf("Uploading %s to DIMM %s\n", uctx->fw_path, uctx->dimm_id);
 
 	rc = send_firmware(uctx);
 	if (rc < 0) {
-		error("Firmware send failed. Aborting...\n");
+		error("Firmware send failed. Aborting...");
 		rc = submit_abort_firmware(uctx);
 		if (rc < 0)
-			error("Aborting update sequence failed\n");
+			error("Aborting update sequence failed");
 		return rc;
 	}
 
 	rc = submit_finish_firmware(uctx);
 	if (rc < 0) {
-		error("Unable to end update sequence\n");
+		error("Unable to end update sequence");
 		rc = submit_abort_firmware(uctx);
 		if (rc < 0)
-			error("Aborting update sequence failed\n");
+			error("Aborting update sequence failed");
 		return rc;
 	}
 
 	rc = query_fw_finish_status(uctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("Query Firmware Finish Status failed");
 		return rc;
+	}
 
 	return 0;
 }
@@ -468,27 +489,34 @@ static int verify_fw_file(struct update_context *uctx)
 	int rc;
 
 	uctx->fw_fd = open(uctx->fw_path, O_RDONLY);
-	if (uctx->fw_fd < 0)
-		return -errno;
+	if (uctx->fw_fd < 0) {
+		rc = -errno;
+		error("Unable to open file %s: %d", uctx->fw_path, rc);
+		return rc;
+	}
 
 	rc = flock(uctx->fw_fd, LOCK_EX | LOCK_NB);
 	if (rc < 0) {
+		error("Unable to flock() file %s: %d", uctx->fw_path, rc);
 		rc = -errno;
 		goto cleanup;
 	}
 
 	if (fstat(uctx->fw_fd, &st) < 0) {
+		error("Unable to fstat() file %s: %d", uctx->fw_path, rc);
 		rc = -errno;
 		goto cleanup;
 	}
 
 	if (!S_ISREG(st.st_mode)) {
+		error("%s is not a regular file", uctx->fw_path);
 		rc = -EINVAL;
 		goto cleanup;
 	}
 
 	uctx->fw_size = st.st_size;
 	if (uctx->fw_size == 0) {
+		error("%s has file size of 0", uctx->fw_path);
 		rc = -EINVAL;
 		goto cleanup;
 	}
@@ -502,12 +530,14 @@ cleanup:
 
 int cmd_update_firmware(int argc, const char **argv, void *ctx)
 {
+	bool verbose;
 	struct update_context uctx = { 0 };
 	const struct option options[] = {
 		OPT_STRING('f', "firmware", &uctx.fw_path,
 				"file-name", "name of firmware"),
 		OPT_STRING('d', "dimm", &uctx.dimm_id, "dimm-id",
 				"dimm to be updated"),
+		OPT_BOOLEAN('v', "verbose", &verbose, "emit extra debug messages to stderr"),
 		OPT_END(),
 	};
 	const char * const u[] = {
@@ -518,33 +548,42 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 
 	argc = parse_options(argc, argv, options, u, 0);
 	for (i = 0; i < argc; i++)
-		error("unknown parameter \"%s\"\n", argv[i]);
+		error("unknown parameter \"%s\"", argv[i]);
 	if (argc)
 		usage_with_options(u, options);
 
+	if (verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
 	if (!uctx.fw_path) {
-		error("No firmware file provided\n");
+		error("No firmware file provided");
 		usage_with_options(u, options);
 		return -EINVAL;
 	}
 
 	if (!uctx.dimm_id) {
-		error("No DIMM ID provided\n");
+		error("No DIMM ID provided");
 		usage_with_options(u, options);
 		return -EINVAL;
 	}
 
 	rc = verify_fw_file(&uctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("Failed to verify firmware file %s", uctx.fw_path);
 		return rc;
+	}
 
 	rc = get_ndctl_dimm(&uctx, ctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("DIMM %s not found", uctx.dimm_id);
 		return rc;
+	}
 
 	rc = update_firmware(&uctx);
-	if (rc < 0)
+	if (rc < 0) {
+		error("Update firmware failed");
 		return rc;
+	}
 
 	if (uctx.start)
 		ndctl_cmd_unref(uctx.start);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
