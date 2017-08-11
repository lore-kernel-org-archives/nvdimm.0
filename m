Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD5D721D2DCF1
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 16:57:56 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH] ndctl: New structure definitions.
Date: Thu, 10 Aug 2017 18:00:00 -0600
Message-Id: <20170811000000.18672-1-jerry.hoemann@hpe.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add structure definitions newly published/modified in v0.85:

https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf


Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 ndctl/lib/ndctl-hpe1.h | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/ndctl-hpe1.h b/ndctl/lib/ndctl-hpe1.h
index b050831..ba071fd 100644
--- a/ndctl/lib/ndctl-hpe1.h
+++ b/ndctl/lib/ndctl-hpe1.h
@@ -30,6 +30,10 @@ enum {
 	NDN_HPE1_CMD_ERRINJ_QUERY = 18,
 	NDN_HPE1_CMD_ERRINJ_INJECT = 19,
 	NDN_HPE1_CMD_ERRINJ_STATUS = 20,
+	NDN_HPE1_CMD_I2C_READ      = 21,
+	NDN_HPE1_CMD_I2C_WRITE     = 22,
+	NDN_HPE1_CMD_I2C_BLK_READ  = 23,
+	NDN_HPE1_CMD_I2C_BLK_WRITE = 24,
 };
 
 /* NDN_HPE1_CMD_SMART */
@@ -103,7 +107,11 @@ struct ndn_hpe1_smart_data {
 	__u8	res2;
 	__u16	energy_src_total_runtime;
 	__u16	vndr_spec_data_size;
-	__u8	vnd_spec_data[60];
+	__u8	vnd_spec_data[28];
+	__u64	failed_save_cnt;
+	__u64	failed_restore_cnt;
+	__u64	failed_arm_cnt;
+	__u64	failed_flush_cnt;
 } __attribute__((packed));
 
 struct ndn_hpe1_smart {
@@ -312,6 +320,42 @@ struct ndn_hpe1_get_inj_err_status {
 	__u8	err_inj_opt;
 } __attribute__((packed));
 
+/* NDN_HPE1_CMD_I2C_READ */
+struct ndn_hpe1_i2c_read {
+	__u8	in_page;
+	__u8	in_offset;
+	__u32	status;
+	__u8	reg_value;
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_I2C_WRITE */
+struct ndn_hpe1_i2c_write {
+	__u8	in_page;
+	__u8	in_offset;
+	__u8	in_value;
+	__u32	status;
+} __attribute__((packed));
+
+
+/* NDN_HPE1_CMD_I2C_BLK_READ */
+struct ndn_hpe1_i2c_blk_read {
+	__u8	in_type;
+	__u16	in_reg_id;
+	__u8	in_blk_id;
+	__u32	status;
+	__u8	data[32];
+} __attribute__((packed));
+
+/* NDN_HPE1_CMD_I2C_BLK_WRITE */
+struct ndn_hpe1_i2c_blk_write {
+	__u8	in_type;
+	__u16	in_reg_id;
+	__u8	in_blk_id;
+	__u8	in_data[32];
+	__u32	status;
+} __attribute__((packed));
+
+
 union ndn_hpe1_cmd {
 	__u64					query;
 	struct ndn_hpe1_smart			smart;
@@ -326,6 +370,10 @@ union ndn_hpe1_cmd {
 	struct ndn_hpe1_query_err_inj_cap	err_cap;
 	struct ndn_hpe1_inj_err			inj_err;
 	struct ndn_hpe1_get_inj_err_status	inj_err_stat;
+	struct ndn_hpe1_i2c_read		i2c_read;
+	struct ndn_hpe1_i2c_write		i2c_write;
+	struct ndn_hpe1_i2c_blk_read		i2c_blk_read;
+	struct ndn_hpe1_i2c_blk_write		i2c_blk_write;
 
 	unsigned char				buf[128];
 };
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
