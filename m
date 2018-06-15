Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85CD52110C83B
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:47:27 -0700 (PDT)
Subject: [PATCH 3/3] tools/testing/nvdimm: Make DSM failure code injection
 an override
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:37:30 -0700
Message-ID: <152902305016.10541.6695000206945040942.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152902303439.10541.13027910074116606464.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152902303439.10541.13027910074116606464.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In order to emulate the behavior of the NVDIMM_FAMILY_INTEL DSMs
nfit_test needs the ability to execute the DSM and then override the
return code.

Split the current return code injection from get_dimm() and apply at
after the function has executed to override the return status.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   49 +++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 17 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 4ea385be528f..6f19d6e28f5f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -882,6 +882,16 @@ static int nd_intel_test_cmd_set_lss_status(struct nfit_test *t,
 	return 0;
 }
 
+static int override_return_code(int dimm, unsigned int func, int rc)
+{
+	if ((1 << func) & dimm_fail_cmd_flags[dimm]) {
+		if (dimm_fail_cmd_code[dimm])
+			return dimm_fail_cmd_code[dimm];
+		return -EIO;
+	}
+	return rc;
+}
+
 static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 {
 	int i;
@@ -892,13 +902,6 @@ static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 			break;
 	if (i >= ARRAY_SIZE(handle))
 		return -ENXIO;
-
-	if ((1 << func) & dimm_fail_cmd_flags[i]) {
-		if (dimm_fail_cmd_code[i])
-			return dimm_fail_cmd_code[i];
-		return -EIO;
-	}
-
 	return i;
 }
 
@@ -937,48 +940,59 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 
 			switch (func) {
 			case ND_INTEL_ENABLE_LSS_STATUS:
-				return nd_intel_test_cmd_set_lss_status(t,
+				rc = nd_intel_test_cmd_set_lss_status(t,
 						buf, buf_len);
+				break;
 			case ND_INTEL_FW_GET_INFO:
-				return nd_intel_test_get_fw_info(t, buf,
+				rc = nd_intel_test_get_fw_info(t, buf,
 						buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_FW_START_UPDATE:
-				return nd_intel_test_start_update(t, buf,
+				rc = nd_intel_test_start_update(t, buf,
 						buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_FW_SEND_DATA:
-				return nd_intel_test_send_data(t, buf,
+				rc = nd_intel_test_send_data(t, buf,
 						buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_FW_FINISH_UPDATE:
-				return nd_intel_test_finish_fw(t, buf,
+				rc = nd_intel_test_finish_fw(t, buf,
 						buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_FW_FINISH_QUERY:
-				return nd_intel_test_finish_query(t, buf,
+				rc = nd_intel_test_finish_query(t, buf,
 						buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_SMART:
-				return nfit_test_cmd_smart(buf, buf_len,
+				rc = nfit_test_cmd_smart(buf, buf_len,
 						&t->smart[i - t->dcr_idx]);
+				break;
 			case ND_INTEL_SMART_THRESHOLD:
-				return nfit_test_cmd_smart_threshold(buf,
+				rc = nfit_test_cmd_smart_threshold(buf,
 						buf_len,
 						&t->smart_threshold[i -
 							t->dcr_idx]);
+				break;
 			case ND_INTEL_SMART_SET_THRESHOLD:
-				return nfit_test_cmd_smart_set_threshold(buf,
+				rc = nfit_test_cmd_smart_set_threshold(buf,
 						buf_len,
 						&t->smart_threshold[i -
 							t->dcr_idx],
 						&t->smart[i - t->dcr_idx],
 						&t->pdev.dev, t->dimm_dev[i]);
+				break;
 			case ND_INTEL_SMART_INJECT:
-				return nfit_test_cmd_smart_inject(buf,
+				rc = nfit_test_cmd_smart_inject(buf,
 						buf_len,
 						&t->smart_threshold[i -
 							t->dcr_idx],
 						&t->smart[i - t->dcr_idx],
 						&t->pdev.dev, t->dimm_dev[i]);
+				break;
 			default:
 				return -ENOTTY;
 			}
+			return override_return_code(i, func, rc);
 		}
 
 		if (!test_bit(cmd, &cmd_mask)
@@ -1004,6 +1018,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		default:
 			return -ENOTTY;
 		}
+		return override_return_code(i, func, rc);
 	} else {
 		struct ars_state *ars_state = &t->ars_state;
 		struct nd_cmd_pkg *call_pkg = buf;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
