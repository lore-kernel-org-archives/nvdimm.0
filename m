Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F98221F3C1BF
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 13:40:40 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v2 4/4] nfit_test: when clearing poison,
 also remove badrange entries
Date: Mon,  9 Oct 2017 14:41:59 -0600
Message-Id: <20171009204159.26489-5-vishal.l.verma@intel.com>
In-Reply-To: <20171009204159.26489-1-vishal.l.verma@intel.com>
References: <20171009204159.26489-1-vishal.l.verma@intel.com>
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

The injected badrange entries can only be cleared from the kernel's
accounting by writing to the affected blocks, so when such a write sends
the clear errror DSM to nfit_test, also clear the ranges from
nfit_test's badrange list. This lets an 'ARS Inject error status' DSM to
return the correct status, omitting the cleared ranges.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 43f948e..e400418 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -344,7 +344,8 @@ static int nfit_test_cmd_ars_status(struct ars_state *ars_state,
 	return 0;
 }
 
-static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
+static int nfit_test_cmd_clear_error(struct nfit_test *t,
+		struct nd_cmd_clear_error *clear_err,
 		unsigned int buf_len, int *cmd_rc)
 {
 	const u64 mask = NFIT_TEST_CLEAR_ERR_UNIT - 1;
@@ -354,12 +355,7 @@ static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
 	if ((clear_err->address & mask) || (clear_err->length & mask))
 		return -EINVAL;
 
-	/*
-	 * Report 'all clear' success for all commands even though a new
-	 * scrub will find errors again.  This is enough to have the
-	 * error removed from the 'badblocks' tracking in the pmem
-	 * driver.
-	 */
+	badrange_forget(&t->badrange, clear_err->address, clear_err->length);
 	clear_err->status = 0;
 	clear_err->cleared = clear_err->length;
 	*cmd_rc = 0;
@@ -687,7 +683,7 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 					cmd_rc);
 			break;
 		case ND_CMD_CLEAR_ERROR:
-			rc = nfit_test_cmd_clear_error(buf, buf_len, cmd_rc);
+			rc = nfit_test_cmd_clear_error(t, buf, buf_len, cmd_rc);
 			break;
 		default:
 			return -ENOTTY;
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
