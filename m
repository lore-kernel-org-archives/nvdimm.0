Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E3FA223FCF33
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 13:53:10 -0700 (PDT)
Subject: [ndctl PATCH] ndctl. test: fix module-taint sanity-check
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 13:50:29 -0700
Message-ID: <152114702911.748.6433135505529426881.stgit@dwillia2-desk3.amr.corp.intel.com>
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

nfit_test_init() validates that the libnvdimm modules that a test would
use are the properly instrumented external versions. If module signing
is enabled the sanity check will fail because the check expects only the
'O' flag, but unsigned external modules will have the 'O' flag and the
'E' flag set. Relax the constraint to just check for 'O'.

Fixes: 00fc65075c89 ("test: validate nfit_test modules...")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/core.c b/test/core.c
index ca983e4913f7..4b36b2d14d7b 100644
--- a/test/core.c
+++ b/test/core.c
@@ -195,7 +195,7 @@ retry:
 				break;
 			}
 
-			if (strcmp(attr, "O") != 0) {
+			if (!strchr(attr, 'O')) {
 				log_err(&log_ctx, "%s.ko: expected taint: O got: %s\n",
 						name, attr);
 				break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
