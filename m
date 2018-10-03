Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A83321130E45
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 15:26:19 -0700 (PDT)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net
 [16.220.97.129])
 by g9t5008.houston.hpe.com (Postfix) with ESMTP id 577D959
 for <linux-nvdimm@lists.01.org>; Wed,  3 Oct 2018 22:26:18 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] ndctl, check-labels: correct check-labels message wording
Date: Wed,  3 Oct 2018 17:29:01 -0500
Message-Id: <20181003222901.44438-1-elliott@hpe.com>
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

ndctl check-labels prints the number of labels, not the number of
nmems. Changed the print for:

$ ndctl check-labels nmem0 nmem1
from:
    successfully verified 510 nmems
to:
    successfully verified 510 nmem labels

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 ndctl/dimm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index a4203f3..699ab57 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1147,7 +1147,7 @@ int cmd_check_labels(int argc, const char **argv, void *ctx)
 	int count = dimm_action(argc, argv, ctx, action_check, base_options,
 			"ndctl check-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
 
-	fprintf(stderr, "successfully verified %d nmem%s\n",
+	fprintf(stderr, "successfully verified %d nmem label%s\n",
 			count >= 0 ? count : 0, count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
