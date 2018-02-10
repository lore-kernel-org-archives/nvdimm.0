Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90EBD223DB799
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 21:27:02 -0800 (PST)
Subject: [ndctl PATCH] ndctl, hugetlb: skip, don't fail
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Feb 2018 21:23:43 -0800
Message-ID: <151824022366.4967.8494321995118743101.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The hugetlb test has x86 assumptions. Skip instead of fail to enable
package build environments that run the unit tests.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/hugetlb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/test/hugetlb.c b/test/hugetlb.c
index a08a93ad40f3..11b7a3d25bb2 100644
--- a/test/hugetlb.c
+++ b/test/hugetlb.c
@@ -13,12 +13,10 @@ static int test_hugetlb(void)
 	for (i = 0; i < (int) ARRAY_SIZE(aligns); i++) {
 		fprintf(stderr, "%s: page_size: %#lx\n", __func__, aligns[i]);
 		rc = test_dax_directio(-1, aligns[i], NULL, 0);
-		if (rc == -ENOMEM || rc == -EACCES)
-			return 77;
-		else if (rc == -ENOENT && aligns[i] == SZ_1G)
+		if (rc == -ENOENT && aligns[i] == SZ_1G)
 			continue; /* system not configured for 1G pages */
 		else if (rc)
-			return rc;
+			return 77;
 	}
 	return 0;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
