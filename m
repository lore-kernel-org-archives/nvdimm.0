Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B34D121DF8073
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 08:49:17 -0700 (PDT)
Subject: [PATCH] libnvdimm: clean up command definitions
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Aug 2017 08:45:32 -0700
Message-ID: <150393513271.10003.253995897844648312.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Remove the command payloads that do not have an associated libnvdimm
ioctl. I.e. remove the payloads that would only ever be carried in the
ND_CMD_CALL envelope. This prevents userspace from growing unnecessary
dependencies on this kernel header when userspace already has everything
it needs to craft and send these commands.

Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/uapi/linux/ndctl.h |   37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c54264d8e..3f03567631cb 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __packed;
 
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
-	} __packed devices[0];
-
-} __packed;
-
-struct nd_cmd_ars_err_inj {
-	__u64 err_inj_spa_range_base;
-	__u64 err_inj_spa_range_length;
-	__u8  err_inj_options;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_clr {
-	__u64 err_inj_clr_spa_range_base;
-	__u64 err_inj_clr_spa_range_length;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_stat {
-	__u32 status;
-	__u32 inj_err_rec_count;
-	struct nd_error_stat_query_record {
-		__u64 err_inj_stat_spa_range_base;
-		__u64 err_inj_stat_spa_range_length;
-	} __packed record[0];
-} __packed;
-
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
