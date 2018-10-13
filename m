Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 962C721173C62
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 21:41:25 -0700 (PDT)
Subject: [ndctl PATCH] test, dsm-fail: Cleanup leftover debug
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Oct 2018 21:29:37 -0700
Message-ID: <153940497765.1425803.8798243923079683083.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Prints from a debug session got committed, delete them.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dsm-fail.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 6845f818c8da..6e812aec008f 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -291,48 +291,39 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 			&log_ctx);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = test_dimms_enable(bus, victim, true);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = test_regions_enable(bus, victim, victim_region, true, 2);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_SIZE, 0, &log_ctx);
 	if (rc)
 		goto out;
 
 	ndctl_region_foreach(bus, region)
 		ndctl_region_disable_invalidate(region);
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = dimms_disable(bus);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 
 	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, -EACCES,
 			&log_ctx);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+
 	rc = test_dimms_enable(bus, victim, false);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = test_regions_enable(bus, victim, victim_region, false, 0);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, 0, &log_ctx);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 	rc = dimms_disable(bus);
 	if (rc)
 		goto out;
-	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 
  out:
 	err = rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
