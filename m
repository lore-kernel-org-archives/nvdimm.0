Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C1EB21954068
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:05:02 -0700 (PDT)
Subject: [ndctl PATCH 2/5] test, libndctl: gate dax and pfn tests on 4.8
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:59:09 -0700
Message-ID: <149272194976.23427.2063717455117169640.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The current tests require the nfit_test conversion from cma to vmalloc.
Disable the tests on earlier kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 39822ee71c0e..f5a6abe50edd 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2405,16 +2405,21 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	ndctl_region_foreach(bus, region)
 		ndctl_region_enable(region);
 
-	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
+	/* pfn and dax tests require vmalloc-enabled nfit_test */
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
 		rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
 		if (rc)
 			return rc;
 		reset_bus(bus);
 	}
-	rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
-	if (rc)
-		return rc;
-	reset_bus(bus);
+
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
+		rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
+		if (rc)
+			return rc;
+		reset_bus(bus);
+	}
+
 	return check_regions(bus, regions0, ARRAY_SIZE(regions0), BTT);
 }
 
@@ -2464,7 +2469,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	daxctl_set_log_priority(daxctl_ctx, loglevel);
 	ndctl_set_private_data(ctx, test);
 
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
