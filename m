Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27D46210EB4E1
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/5] ndctl: fix a resource leak in
 submit_get_firmware_info
Date: Fri, 10 Aug 2018 16:56:21 -0600
Message-Id: <20180810225624.32383-3-vishal.l.verma@intel.com>
In-Reply-To: <20180810225624.32383-1-vishal.l.verma@intel.com>
References: <20180810225624.32383-1-vishal.l.verma@intel.com>
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

Static analysis reports that we leak ndctl_cmd in the above function.
Fix by adding a proper cleanup path.

Cc: Dave Jiang <dave.jiang@intel.com>
Fixes: f86369ea29e2 ("ndctl: merge firmware-update into dimm.c as another dimm operation")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/dimm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 97643a3..a4203f3 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -428,36 +428,39 @@ static int submit_get_firmware_info(struct ndctl_dimm *dimm,
 
 	rc = ndctl_cmd_submit(cmd);
 	if (rc < 0)
-		return rc;
+		goto out;
 
+	rc = -ENXIO;
 	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
 	if (status != FW_SUCCESS) {
 		fprintf(stderr, "GET FIRMWARE INFO on DIMM %s failed: %#x\n",
 				ndctl_dimm_get_devname(dimm), status);
-		return -ENXIO;
+		goto out;
 	}
 
 	fw->store_size = ndctl_cmd_fw_info_get_storage_size(cmd);
 	if (fw->store_size == UINT_MAX)
-		return -ENXIO;
+		goto out;
 
 	fw->update_size = ndctl_cmd_fw_info_get_max_send_len(cmd);
 	if (fw->update_size == UINT_MAX)
-		return -ENXIO;
+		goto out;
 
 	fw->query_interval = ndctl_cmd_fw_info_get_query_interval(cmd);
 	if (fw->query_interval == UINT_MAX)
-		return -ENXIO;
+		goto out;
 
 	fw->max_query = ndctl_cmd_fw_info_get_max_query_time(cmd);
 	if (fw->max_query == UINT_MAX)
-		return -ENXIO;
+		goto out;
 
 	fw->run_version = ndctl_cmd_fw_info_get_run_version(cmd);
 	if (fw->run_version == ULLONG_MAX)
-		return -ENXIO;
+		goto out;
 
 	rc = verify_fw_size(uctx);
+
+out:
 	ndctl_cmd_unref(cmd);
 	return rc;
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
