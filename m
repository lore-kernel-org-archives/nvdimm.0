Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 360EC20958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 13:53:37 -0700 (PDT)
Subject: [ndctl PATCH 3/6] ndctl: update to latest ndctl.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 05 Jul 2017 13:48:50 -0700
Message-ID: <149928773074.25150.12213123383973485331.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149928771519.25150.13314997328838983545.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add the definitions for the new root-device (hid: ACPI0012) _DSMs
defined in the ACPI 6.2 specification.

Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/ndctl.h |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 3b1d703e4af1..d70b97da3924 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -105,7 +105,8 @@ struct nd_cmd_ars_cap {
 	__u32 status;
 	__u32 max_ars_out;
 	__u32 clear_err_unit;
-	__u32 reserved;
+	__u16 flags;
+	__u16 reserved;
 } __attribute__((packed));
 
 struct nd_cmd_ars_start {
@@ -144,6 +145,43 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __attribute__((packed));
 
+struct nd_cmd_trans_spa {
+	__u64 spa;
+	__u32 status;
+	__u8  flags;
+	__u8  _reserved[3];
+	__u64 trans_length;
+	__u32 num_nvdimms;
+	struct nd_nvdimm_device {
+		__u32 nfit_device_handle;
+		__u32 _reserved;
+		__u64 dpa;
+	} __attribute__((packed)) devices[0];
+
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj {
+	__u64 err_inj_spa_range_base;
+	__u64 err_inj_spa_range_length;
+	__u8  err_inj_options;
+	__u32 status;
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj_clr {
+	__u64 err_inj_clr_spa_range_base;
+	__u64 err_inj_clr_spa_range_length;
+	__u32 status;
+} __attribute__((packed));
+
+struct nd_cmd_ars_err_inj_stat {
+	__u32 status;
+	__u32 inj_err_rec_count;
+	struct nd_error_stat_query_record {
+		__u64 err_inj_stat_spa_range_base;
+		__u64 err_inj_stat_spa_range_length;
+	} __attribute__((packed)) record[0];
+} __attribute__((packed));
+
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
@@ -169,6 +207,7 @@ enum {
 enum {
 	ND_ARS_VOLATILE = 1,
 	ND_ARS_PERSISTENT = 2,
+	ND_CONFIG_LOCKED = 1,
 };
 
 static __inline__ const char *nvdimm_bus_cmd_name(unsigned cmd)
@@ -178,6 +217,7 @@ static __inline__ const char *nvdimm_bus_cmd_name(unsigned cmd)
 		[ND_CMD_ARS_START] = "ars_start",
 		[ND_CMD_ARS_STATUS] = "ars_status",
 		[ND_CMD_CLEAR_ERROR] = "clear_error",
+		[ND_CMD_CALL] = "cmd_call",
 	};
 
 	if (cmd < ARRAY_SIZE(names) && names[cmd])

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
