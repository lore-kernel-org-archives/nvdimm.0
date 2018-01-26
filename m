Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4C632222C241
 for <linux-nvdimm@lists.01.org>; Fri, 26 Jan 2018 09:49:41 -0800 (PST)
Subject: [PATCH 2/2] libnvdimm/nfit_test: adding support for unit testing
 enable LSS status
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 26 Jan 2018 10:55:11 -0700
Message-ID: <151698931169.35603.12024978051282705885.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151698930627.35603.14847307775995809534.stgit@djiang5-desk3.ch.intel.com>
References: <151698930627.35603.14847307775995809534.stgit@djiang5-desk3.ch.intel.com>
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

Adding support code to simulate the enabling of LSS status in support of
the Intel DSM v1.6 Function Index 10: Enable Latch System Shutdown Status.
This is only for testing of libndctl support for LSS enable. The actual
functionality requires a reboot and therefore is not simulated. The enable
value is not recorded in nfit_test since there's no DSM to actually query
the current status of the LSS enable.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/test/nfit.c      |   34 +++++++++++++++++++++++++++++++++
 tools/testing/nvdimm/test/nfit_test.h |    6 ++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 3d999f193471..21dfc0e134c0 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -821,6 +821,35 @@ static int nfit_test_cmd_ars_inject_status(struct nfit_test *t,
 	return 0;
 }
 
+static int nd_intel_test_cmd_set_lss_status(struct nfit_test *t,
+		struct nd_intel_lss *nd_cmd, unsigned int buf_len)
+{
+	struct device *dev = &t->pdev.dev;
+
+	if (buf_len < sizeof(*nd_cmd))
+		return -EINVAL;
+
+	switch (nd_cmd->enable) {
+	case 0:
+		nd_cmd->status = 0;
+		dev_dbg(dev, "%s: Latch System Shutdown Status disabled\n",
+				__func__);
+		break;
+	case 1:
+		nd_cmd->status = 0;
+		dev_dbg(dev, "%s: Latch System Shutdown Status enabled\n",
+				__func__);
+		break;
+	default:
+		dev_warn(dev, "Unknown enable value: %#x\n", nd_cmd->enable);
+		nd_cmd->status = 0x3;
+		break;
+	}
+
+
+	return 0;
+}
+
 static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 {
 	int i;
@@ -872,6 +901,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				return i;
 
 			switch (func) {
+			case ND_INTEL_ENABLE_LSS_STATUS:
+				return nd_intel_test_cmd_set_lss_status(t,
+						buf, buf_len);
 			case ND_INTEL_FW_GET_INFO:
 				return nd_intel_test_get_fw_info(t, buf,
 						buf_len, i - t->dcr_idx);
@@ -1996,6 +2028,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_INTEL_FW_SEND_DATA, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_FW_FINISH_UPDATE, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_FW_FINISH_QUERY, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_INTEL_ENABLE_LSS_STATUS, &acpi_desc->dimm_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -2093,6 +2126,7 @@ static void nfit_test1_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_CLEAR_ERROR, &acpi_desc->bus_cmd_force_en);
+	set_bit(ND_INTEL_ENABLE_LSS_STATUS, &acpi_desc->dimm_cmd_force_en);
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index be8fa8ec0615..428344519cdf 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -86,6 +86,7 @@ struct nd_cmd_ars_err_inj_stat {
 
 #define ND_INTEL_SMART			 1
 #define ND_INTEL_SMART_THRESHOLD	 2
+#define ND_INTEL_ENABLE_LSS_STATUS	10
 #define ND_INTEL_FW_GET_INFO		12
 #define ND_INTEL_FW_START_UPDATE	13
 #define ND_INTEL_FW_SEND_DATA		14
@@ -212,6 +213,11 @@ struct nd_intel_fw_finish_query {
 	__u64 updated_fw_rev;
 } __packed;
 
+struct nd_intel_lss {
+	__u8 enable;
+	__u32 status;
+} __packed;
+
 union acpi_object;
 typedef void *acpi_handle;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
