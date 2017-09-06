Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE77821E97813
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 16:40:47 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: sync with v4.13 ndctl.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Sep 2017 16:37:13 -0700
Message-ID: <150474103375.36240.17226654981174432854.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

Latest ndctl.h has dropped these command definitions and we will
introduce a libndctl-nfit.h to carry them going forward.

Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/ndctl.h |   38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index d70b97da3924..5e6905c76adc 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __attribute__((packed));
 
-struct nd_cmd_trans_spa {
-	__u64 spa;
-	__u32 status;
-	__u8  flags;
-	__u8  _reserved[3];
-	__u64 trans_length;
-	__u32 num_nvdimms;
-	struct nd_nvdimm_device {
-		__u32 nfit_device_handle;
-		__u32 _reserved;
-		__u64 dpa;
-	} __attribute__((packed)) devices[0];
-
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj {
-	__u64 err_inj_spa_range_base;
-	__u64 err_inj_spa_range_length;
-	__u8  err_inj_options;
-	__u32 status;
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj_clr {
-	__u64 err_inj_clr_spa_range_base;
-	__u64 err_inj_clr_spa_range_length;
-	__u32 status;
-} __attribute__((packed));
-
-struct nd_cmd_ars_err_inj_stat {
-	__u32 status;
-	__u32 inj_err_rec_count;
-	struct nd_error_stat_query_record {
-		__u64 err_inj_stat_spa_range_base;
-		__u64 err_inj_stat_spa_range_length;
-	} __attribute__((packed)) record[0];
-} __attribute__((packed));
-
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
@@ -207,6 +170,7 @@ enum {
 enum {
 	ND_ARS_VOLATILE = 1,
 	ND_ARS_PERSISTENT = 2,
+	ND_ARS_RETURN_PREV_DATA = 1 << 1,
 	ND_CONFIG_LOCKED = 1,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
