Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 02B251A1F5C
 for <linux-nvdimm@lists.01.org>; Wed,  6 Apr 2016 17:54:40 -0700 (PDT)
Subject: [PATCH] libnvdimm, test: add mock SMART data payload
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Apr 2016 17:53:49 -0700
Message-ID: <20160407005349.30117.44157.stgit@dwillia2-desk3.jf.intel.com>
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

Provide simulated SMART data to enable the ndctl implementation of SMART
data retrieval and parsing.

The payload is defined here, "Section 4.1 SMART and Health Info
(Function Index 1)":

    http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c             |    2 ++
 include/uapi/linux/ndctl.h       |   31 ++++++++++++++++++++++++++++++-
 tools/testing/nvdimm/test/nfit.c |   25 +++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 19f822d7f652..ea805ac641e2 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -783,6 +783,8 @@ int __init nvdimm_bus_init(void)
 {
 	int rc;
 
+	BUILD_BUG_ON(sizeof(struct nd_smart_payload) != 128);
+
 	rc = bus_register(&nvdimm_bus_type);
 	if (rc)
 		return rc;
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 7cc28ab05b87..f6747b90db90 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2014-2015, Intel Corporation.
+ * Copyright (c) 2014-2016, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU Lesser General Public License,
@@ -20,6 +20,35 @@ struct nd_cmd_smart {
 	__u8 data[128];
 } __packed;
 
+enum {
+	ND_SMART_HEALTH_VALID	= 1 << 0,
+	ND_SMART_TEMP_VALID 	= 1 << 1,
+	ND_SMART_SPARES_VALID	= 1 << 2,
+	ND_SMART_ALARM_VALID	= 1 << 3,
+	ND_SMART_USED_VALID	= 1 << 4,
+	ND_SMART_SHUTDOWN_VALID	= 1 << 5,
+	ND_SMART_VENDOR_VALID	= 1 << 6,
+	ND_SMART_TEMP_TRIP	= 1 << 0,
+	ND_SMART_SPARE_TRIP	= 1 << 1,
+	ND_SMART_NON_CRITICAL_HEALTH	= 1 << 0,
+	ND_SMART_CRITICAL_HEALTH	= 1 << 1,
+	ND_SMART_FATAL_HEALTH		= 1 << 2,
+};
+
+struct nd_smart_payload {
+	__u32 flags;
+	__u8 reserved0[4];
+	__u8 health;
+	__u16 temperature;
+	__u8 spares;
+	__u8 alarm_flags;
+	__u8 life_used;
+	__u8 shutdown_state;
+	__u8 reserved1;
+	__u32 vendor_size;
+	__u8 vendor_data[108];
+} __packed;
+
 struct nd_cmd_smart_threshold {
 	__u32 status;
 	__u8 data[8];
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 3187322eeed7..54c9f3cc3d34 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -330,6 +330,27 @@ static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
 	return 0;
 }
 
+static int nfit_test_cmd_smart(struct nd_cmd_smart *smart, unsigned int buf_len)
+{
+	static const struct nd_smart_payload smart_data = {
+		.flags = ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID
+			| ND_SMART_SPARES_VALID | ND_SMART_ALARM_VALID
+			| ND_SMART_USED_VALID | ND_SMART_SHUTDOWN_VALID,
+		.health = ND_SMART_NON_CRITICAL_HEALTH,
+		.temperature = 23 * 16,
+		.spares = 75,
+		.alarm_flags = ND_SMART_SPARE_TRIP | ND_SMART_TEMP_TRIP,
+		.life_used = 5,
+		.shutdown_state = 0,
+		.vendor_size = 0,
+	};
+
+	if (buf_len < sizeof(*smart))
+		return -EINVAL;
+	memcpy(smart->data, &smart_data, sizeof(*smart));
+	return 0;
+}
+
 static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
@@ -368,6 +389,9 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			rc = nfit_test_cmd_set_config_data(buf, buf_len,
 				t->label[i]);
 			break;
+		case ND_CMD_SMART:
+			rc = nfit_test_cmd_smart(buf, buf_len);
+			break;
 		default:
 			return -ENOTTY;
 		}
@@ -1254,6 +1278,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &acpi_desc->dimm_dsm_force_en);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &acpi_desc->dimm_dsm_force_en);
+	set_bit(ND_CMD_SMART, &acpi_desc->dimm_dsm_force_en);
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
