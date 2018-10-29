Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com
 [IPv6:2607:f8b0:4864:20::843])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C19AF2117D292
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 12:11:10 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i15-v6so10641326qtr.0
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 12:11:10 -0700 (PDT)
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Subject: [PATCH] tools/testing/nvdimm: Fix the index for dimm devices.
Date: Mon, 29 Oct 2018 15:10:54 -0400
Message-Id: <20181029191054.7694-1-msys.mizuma@gmail.com>
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
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

KASAN reports following global out of bounds access while
nfit_test is being loaded. The out of bound access happens
the following reference to dimm_fail_cmd_flags[dimm]. 'dimm' is
over than the index value, NUM_DCR (==5).

---
  static int override_return_code(int dimm, unsigned int func, int rc)
  {
          if ((1 << func) & dimm_fail_cmd_flags[dimm]) {

dimm_fail_cmd_flags[] definition:
  static unsigned long dimm_fail_cmd_flags[NUM_DCR];
---

'dimm' is the return value of get_dimm(), and get_dimm() returns 
the index of handle[] array. The handle[] has 7 index, and the
index #0 to #4 is for nfit_test.0 and #5, #6 is for nfit_test.1.
NUM_DCR is only for nfit_test.0. Let's add for nfit_test.1.

KASAN report:
==================================================================
BUG: KASAN: global-out-of-bounds in nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
Read of size 8 at addr ffffffffc10cbbe8 by task kworker/u41:0/8
...
Call Trace:
 dump_stack+0xea/0x1b0
 ? dump_stack_print_info.cold.0+0x1b/0x1b
 ? kmsg_dump_rewind_nolock+0xd9/0xd9
 print_address_description+0x65/0x22e
 ? nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
 kasan_report.cold.6+0x92/0x1a6
 nfit_test_ctl+0x47bb/0x55b0 [nfit_test]
...
The buggy address belongs to the variable:
 dimm_fail_cmd_flags+0x28/0xffffffffffffa440 [nfit_test]
==================================================================

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 tools/testing/nvdimm/test/nfit.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 9527d47a1070..38f066ce2f47 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -104,6 +104,8 @@
 enum {
 	NUM_PM  = 3,
 	NUM_DCR = 5,
+	NUM_DCR_ALL = NUM_DCR + 2, /* 5 DCRs for test.0, 2 DCRs for test.1 */
+
 	NUM_HINTS = 8,
 	NUM_BDW = NUM_DCR,
 	NUM_SPA = NUM_PM + NUM_DCR + NUM_BDW,
@@ -140,8 +142,8 @@ static u32 handle[] = {
 	[6] = NFIT_DIMM_HANDLE(1, 0, 0, 0, 1),
 };
 
-static unsigned long dimm_fail_cmd_flags[NUM_DCR];
-static int dimm_fail_cmd_code[NUM_DCR];
+static unsigned long dimm_fail_cmd_flags[NUM_DCR_ALL];
+static int dimm_fail_cmd_code[NUM_DCR_ALL];
 
 static const struct nd_intel_smart smart_def = {
 	.flags = ND_INTEL_SMART_HEALTH_VALID
@@ -205,7 +207,7 @@ struct nfit_test {
 		unsigned long deadline;
 		spinlock_t lock;
 	} ars_state;
-	struct device *dimm_dev[NUM_DCR];
+	struct device *dimm_dev[NUM_DCR_ALL];
 	struct nd_intel_smart *smart;
 	struct nd_intel_smart_threshold *smart_threshold;
 	struct badrange badrange;
@@ -2680,7 +2682,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 		u32 nfit_handle = __to_nfit_memdev(nfit_mem)->device_handle;
 		int i;
 
-		for (i = 0; i < NUM_DCR; i++)
+		for (i = 0; i < NUM_DCR_ALL; i++)
 			if (nfit_handle == handle[i])
 				dev_set_drvdata(nfit_test->dimm_dev[i],
 						nfit_mem);
-- 
2.18.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
