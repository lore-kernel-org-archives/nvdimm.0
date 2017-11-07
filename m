Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A4252034D834
 for <linux-nvdimm@lists.01.org>; Tue,  7 Nov 2017 14:46:39 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] nfit_test: stricter bounds checking for error injection
 commands
Date: Tue,  7 Nov 2017 15:48:21 -0700
Message-Id: <20171107224821.12196-1-vishal.l.verma@intel.com>
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

Ensure that the in/out sizes passed in the nd_cmd_package are sane for
the fixed output size commands (i.e. inject error and clear injected
error).

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/test/nfit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 323a4bc..3a2655b 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -488,7 +488,7 @@ static int nfit_test_cmd_ars_error_inject(struct nfit_test *t,
 {
 	int rc;
 
-	if (buf_len < sizeof(*err_inj)) {
+	if (buf_len != sizeof(*err_inj)) {
 		rc = -EINVAL;
 		goto err;
 	}
@@ -519,7 +519,7 @@ static int nfit_test_cmd_ars_inject_clear(struct nfit_test *t,
 {
 	int rc;
 
-	if (buf_len < sizeof(*err_clr)) {
+	if (buf_len != sizeof(*err_clr)) {
 		rc = -EINVAL;
 		goto err;
 	}
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
