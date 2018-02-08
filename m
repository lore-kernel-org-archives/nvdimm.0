Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD01522361E5D
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 12:18:55 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2] libnvdimm,
 testing: Add emulation for smart injection commands
Date: Thu,  8 Feb 2018 13:24:38 -0700
Message-Id: <20180208202438.1173-1-vishal.l.verma@intel.com>
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

Add support for the smart injection command in the nvdimm unit test
framework. This allows for directly injecting to smart fields and flags
that are supported in the injection command. If the injected values are
past the threshold, then an acpi notification is also triggered.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c      | 43 +++++++++++++++++++++++++++++++++--
 tools/testing/nvdimm/test/nfit_test.h | 16 +++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 42ee1798971d..90aefef4065f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -708,7 +708,9 @@ static void smart_notify(struct device *bus_dev,
 				>= thresh->media_temperature)
 			|| ((thresh->alarm_control & ND_INTEL_SMART_CTEMP_TRIP)
 				&& smart->ctrl_temperature
-				>= thresh->ctrl_temperature)) {
+				>= thresh->ctrl_temperature)
+			|| (smart->health != ND_INTEL_SMART_NON_CRITICAL_HEALTH)
+			|| (smart->shutdown_state != 0)) {
 		device_lock(bus_dev);
 		__acpi_nvdimm_notify(dimm_dev, 0x81);
 		device_unlock(bus_dev);
@@ -734,6 +736,35 @@ static int nfit_test_cmd_smart_set_threshold(
 	return 0;
 }
 
+static int nfit_test_cmd_smart_inject(
+		struct nd_intel_smart_inject *inj,
+		unsigned int buf_len,
+		struct nd_intel_smart_threshold *thresh,
+		struct nd_intel_smart *smart,
+		struct device *bus_dev, struct device *dimm_dev)
+{
+	if (buf_len != sizeof(*inj)) {
+		pr_err("TEST: size mismatch. buf = %d, struct = %d\n",
+			buf_len, sizeof(*inj));
+		return -EINVAL;
+	}
+
+	if (inj->mtemp_enable)
+		smart->media_temperature = inj->media_temperature;
+	if (inj->spare_enable)
+		smart->spares = inj->spares;
+	if (inj->fatal_enable)
+		smart->health = ND_INTEL_SMART_FATAL_HEALTH;
+	if (inj->unsafe_shutdown_enable) {
+		smart->shutdown_state = 1;
+		smart->shutdown_count++;
+	}
+	inj->status = 0;
+	smart_notify(bus_dev, dimm_dev, smart, thresh);
+
+	return 0;
+}
+
 static void uc_error_notify(struct work_struct *work)
 {
 	struct nfit_test *t = container_of(work, typeof(*t), work);
@@ -934,6 +965,13 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 							t->dcr_idx],
 						&t->smart[i - t->dcr_idx],
 						&t->pdev.dev, t->dimm_dev[i]);
+			case ND_INTEL_SMART_INJECT:
+				return nfit_test_cmd_smart_inject(buf,
+						buf_len,
+						&t->smart_threshold[i -
+							t->dcr_idx],
+						&t->smart[i - t->dcr_idx],
+						&t->pdev.dev, t->dimm_dev[i]);
 			default:
 				return -ENOTTY;
 			}
@@ -1209,7 +1247,7 @@ static void smart_init(struct nfit_test *t)
 		.alarm_control = ND_INTEL_SMART_SPARE_TRIP
 			| ND_INTEL_SMART_TEMP_TRIP,
 		.media_temperature = 40 * 16,
-		.ctrl_temperature = 30 * 16,
+		.ctrl_temperature = 35 * 16,
 		.spares = 5,
 	};
 	const struct nd_intel_smart smart_data = {
@@ -2015,6 +2053,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_INTEL_SMART, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_SMART_THRESHOLD, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_INTEL_SMART_SET_THRESHOLD, &acpi_desc->dimm_cmd_force_en);
+	set_bit(ND_INTEL_SMART_INJECT, &acpi_desc->dimm_cmd_force_en);
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_cmd_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_cmd_force_en);
diff --git a/tools/testing/nvdimm/test/nfit_test.h b/tools/testing/nvdimm/test/nfit_test.h
index 428344519cdf..33752e06ff8d 100644
--- a/tools/testing/nvdimm/test/nfit_test.h
+++ b/tools/testing/nvdimm/test/nfit_test.h
@@ -93,6 +93,7 @@ struct nd_cmd_ars_err_inj_stat {
 #define ND_INTEL_FW_FINISH_UPDATE	15
 #define ND_INTEL_FW_FINISH_QUERY	16
 #define ND_INTEL_SMART_SET_THRESHOLD	17
+#define ND_INTEL_SMART_INJECT		18
 
 #define ND_INTEL_SMART_HEALTH_VALID             (1 << 0)
 #define ND_INTEL_SMART_SPARES_VALID             (1 << 1)
@@ -111,6 +112,10 @@ struct nd_cmd_ars_err_inj_stat {
 #define ND_INTEL_SMART_NON_CRITICAL_HEALTH      (1 << 0)
 #define ND_INTEL_SMART_CRITICAL_HEALTH          (1 << 1)
 #define ND_INTEL_SMART_FATAL_HEALTH             (1 << 2)
+#define ND_INTEL_SMART_INJECT_MTEMP		(1 << 0)
+#define ND_INTEL_SMART_INJECT_SPARE		(1 << 1)
+#define ND_INTEL_SMART_INJECT_FATAL		(1 << 2)
+#define ND_INTEL_SMART_INJECT_SHUTDOWN		(1 << 3)
 
 struct nd_intel_smart {
 	__u32 status;
@@ -158,6 +163,17 @@ struct nd_intel_smart_set_threshold {
 	__u32 status;
 } __packed;
 
+struct nd_intel_smart_inject {
+	__u64 flags;
+	__u8 mtemp_enable;
+	__u16 media_temperature;
+	__u8 spare_enable;
+	__u8 spares;
+	__u8 fatal_enable;
+	__u8 unsafe_shutdown_enable;
+	__u32 status;
+} __packed;
+
 #define INTEL_FW_STORAGE_SIZE		0x100000
 #define INTEL_FW_MAX_SEND_LEN		0xFFEC
 #define INTEL_FW_QUERY_INTERVAL		250000
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
