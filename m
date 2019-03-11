Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6B0C208EB3E5
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 12:47:15 -0700 (PDT)
Subject: [PATCH] tools/testing/nvdimm: retain security state after overwrite
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 11 Mar 2019 12:47:14 -0700
Message-ID: <155233363473.16621.18394372960766895221.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Overwrite retains the security state after completion of operation.
Fix nfit_test to reflect this.

Fixes: 926f74802cb ("tools/testing/nvdimm: Add overwrite support for
nfit_test")

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index b579f962451d..c7c19ca7588f 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -146,6 +146,7 @@ static int dimm_fail_cmd_code[ARRAY_SIZE(handle)];
 struct nfit_test_sec {
 	u8 state;
 	u8 ext_state;
+	u8 old_state;
 	u8 passphrase[32];
 	u8 master_passphrase[32];
 	u64 overwrite_end_time;
@@ -1093,7 +1094,7 @@ static int nd_intel_test_cmd_overwrite(struct nfit_test *t,
 		return 0;
 	}
 
-	memset(sec->passphrase, 0, ND_INTEL_PASSPHRASE_SIZE);
+	sec->old_state = sec->state;
 	sec->state = ND_INTEL_SEC_STATE_OVERWRITE;
 	dev_dbg(dev, "overwrite progressing.\n");
 	sec->overwrite_end_time = get_jiffies_64() + 5 * HZ;
@@ -1115,7 +1116,8 @@ static int nd_intel_test_cmd_query_overwrite(struct nfit_test *t,
 
 	if (time_is_before_jiffies64(sec->overwrite_end_time)) {
 		sec->overwrite_end_time = 0;
-		sec->state = 0;
+		sec->state = sec->old_state;
+		sec->old_state = 0;
 		sec->ext_state = ND_INTEL_SEC_ESTATE_ENABLED;
 		dev_dbg(dev, "overwrite is complete\n");
 	} else

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
