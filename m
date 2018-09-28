Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C34AD21106FA6
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:45:01 -0700 (PDT)
Subject: [PATCH v2 3/5] nfit_test: Add overwrite support for nfit_test
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 15:45:00 -0700
Message-ID: <153817470075.19407.12696397727175523377.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
References: <153817460190.19407.1009470794996360570.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

With the implementation of Intel NVDIMM DSM overwrite, we are adding unit
test to nfit_test for testing of overwrite operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/acpi/nfit/intel.h        |    1 +
 tools/testing/nvdimm/test/nfit.c |   55 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 65d57a6abbc2..c7426ebf3d08 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -19,6 +19,7 @@ extern const struct nvdimm_security_ops *intel_security_ops;
 #define ND_INTEL_STATUS_INVALID_PASS	11
 #define ND_INTEL_STATUS_OVERWRITE_UNSUPPORTED	0x10007
 #define ND_INTEL_STATUS_OQUERY_INPROGRESS	0x10007
+#define ND_INTEL_STATUS_OQUERY_SEQUENCE_ERR	0x20007
 
 #define ND_INTEL_SEC_STATE_ENABLED	0x02
 #define ND_INTEL_SEC_STATE_LOCKED	0x04
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 1d7ae7aecb46..ee09ea84823a 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -149,6 +149,7 @@ static int dimm_fail_cmd_code[NUM_DCR];
 struct nfit_test_sec {
 	u8 state;
 	u8 passphrase[32];
+	u64 overwrite_end_time;
 } dimm_sec_info[NUM_DCR];
 
 static const struct nd_intel_smart smart_def = {
@@ -1072,6 +1073,50 @@ static int nd_intel_test_cmd_secure_erase(struct nfit_test *t,
 	return 0;
 }
 
+static int nd_intel_test_cmd_overwrite(struct nfit_test *t,
+		struct nd_intel_overwrite *nd_cmd,
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
+
+	if ((sec->state & ND_INTEL_SEC_STATE_ENABLED) &&
+			memcmp(nd_cmd->passphrase, sec->passphrase,
+				ND_INTEL_PASSPHRASE_SIZE) != 0) {
+		nd_cmd->status = ND_INTEL_STATUS_INVALID_PASS;
+		dev_dbg(dev, "overwrite: wrong passphrase\n");
+		return 0;
+	}
+
+	memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+	sec->state = ND_INTEL_SEC_STATE_OVERWRITE;
+	dev_dbg(dev, "overwrite progressing.\n");
+	sec->overwrite_end_time = get_jiffies_64() + 5 * HZ;
+
+	return 0;
+}
+
+static int nd_intel_test_cmd_query_overwrite(struct nfit_test *t,
+		struct nd_intel_query_overwrite *nd_cmd,
+		unsigned int buf_len, int dimm)
+{
+	struct device *dev = &t->pdev.dev;
+	struct nfit_test_sec *sec = &dimm_sec_info[dimm];
+
+	if (!(sec->state & ND_INTEL_SEC_STATE_OVERWRITE)) {
+		nd_cmd->status = ND_INTEL_STATUS_OQUERY_SEQUENCE_ERR;
+		return 0;
+	}
+
+	if (time_is_before_jiffies64(sec->overwrite_end_time)) {
+		sec->overwrite_end_time = 0;
+		sec->state = 0;
+		dev_dbg(dev, "overwrite is complete\n");
+	} else
+		nd_cmd->status = ND_INTEL_STATUS_OQUERY_INPROGRESS;
+	return 0;
+}
+
 static int get_dimm(struct nfit_mem *nfit_mem, unsigned int func)
 {
 	int i;
@@ -1143,6 +1188,14 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 				rc = nd_intel_test_cmd_secure_erase(t,
 						buf, buf_len, i);
 				break;
+			case NVDIMM_INTEL_OVERWRITE:
+				rc = nd_intel_test_cmd_overwrite(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
+			case NVDIMM_INTEL_QUERY_OVERWRITE:
+				rc = nd_intel_test_cmd_query_overwrite(t,
+						buf, buf_len, i - t->dcr_idx);
+				break;
 			case ND_INTEL_ENABLE_LSS_STATUS:
 				rc = nd_intel_test_cmd_set_lss_status(t,
 						buf, buf_len);
@@ -2378,6 +2431,8 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(NVDIMM_INTEL_UNLOCK_UNIT, &acpi_desc->dimm_cmd_force_en);
 	set_bit(NVDIMM_INTEL_FREEZE_LOCK, &acpi_desc->dimm_cmd_force_en);
 	set_bit(NVDIMM_INTEL_SECURE_ERASE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_OVERWRITE, &acpi_desc->dimm_cmd_force_en);
+	set_bit(NVDIMM_INTEL_QUERY_OVERWRITE, &acpi_desc->dimm_cmd_force_en);
 }
 
 static void nfit_test1_setup(struct nfit_test *t)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
