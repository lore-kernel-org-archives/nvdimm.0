Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A337F2095D209
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 09:55:14 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 6/7] libnvdimm: New ACPI 6.2 DSM functions
Date: Thu, 29 Jun 2017 10:56:31 -0600
Message-Id: <9286ed0ad85e3f0dd60e13439d6faa939847a9ab.1498754314.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1498754314.git.jerry.hoemann@hpe.com>
References: <cover.1498754314.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.2 added new NVDIMM root DSM functions.  Define their
data structures.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index e23c37f..e15768f 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -105,7 +105,8 @@ struct nd_cmd_ars_cap {
 	__u32 status;
 	__u32 max_ars_out;
 	__u32 clear_err_unit;
-	__u32 reserved;
+	__u16 flags;
+	__u16 reserved;
 } __packed;
 
 struct nd_cmd_ars_start {
@@ -144,6 +145,43 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __packed;
 
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
+	} __packed devices[0];
+
+} __packed;
+
+struct nd_cmd_ars_err_inj {
+	__u64 err_inj_spa_range_base;
+	__u64 err_inj_spa_range_length;
+	__u8  err_inj_options;
+	__u32 status;
+} __packed;
+
+struct nd_cmd_ars_err_inj_clr {
+	__u64 err_inj_clr_spa_range_base;
+	__u64 err_inj_clr_spa_range_length;
+	__u32 status;
+} __packed;
+
+struct nd_cmd_ars_err_inj_stat {
+	__u32 status;
+	__u32 inj_err_rec_count;
+	struct nd_error_stat_query_record {
+		__u64 err_inj_stat_spa_range_base;
+		__u64 err_inj_stat_spa_range_length;
+	} __packed record[0];
+} __packed;
+
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
