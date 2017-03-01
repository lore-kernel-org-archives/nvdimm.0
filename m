Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7348A821CF
 for <linux-nvdimm@lists.01.org>; Wed,  1 Mar 2017 01:16:36 -0800 (PST)
Subject: [PATCH 1/2] tools/testing/nvdimm: make iset cookie predictable
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 01 Mar 2017 01:11:24 -0800
Message-ID: <148835948457.28806.60862861470412098.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148835947931.28806.15339584183213827869.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148835947931.28806.15339584183213827869.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For testing changes to the iset cookie algorithm we need a value that is
constant from run-to-run.

Stop including dynamic data in the emulated region_offset values. Also,
pick values that sort in a different order depending on whether the
comparison is a memcmp() of two 8-byte arrays or subtraction of two
64-bit values.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 45be8b55a663..798f17655433 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -887,7 +887,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 0+1;
 	memdev->region_index = 4+1;
 	memdev->region_size = SPA0_SIZE/2;
-	memdev->region_offset = t->spa_set_dma[0];
+	memdev->region_offset = 1;
 	memdev->address = 0;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 2;
@@ -902,7 +902,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 0+1;
 	memdev->region_index = 5+1;
 	memdev->region_size = SPA0_SIZE/2;
-	memdev->region_offset = t->spa_set_dma[0] + SPA0_SIZE/2;
+	memdev->region_offset = (1 << 8);
 	memdev->address = 0;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 2;
@@ -917,7 +917,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 1+1;
 	memdev->region_index = 4+1;
 	memdev->region_size = SPA1_SIZE/4;
-	memdev->region_offset = t->spa_set_dma[1];
+	memdev->region_offset = (1 << 16);
 	memdev->address = SPA0_SIZE/2;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 4;
@@ -932,7 +932,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 1+1;
 	memdev->region_index = 5+1;
 	memdev->region_size = SPA1_SIZE/4;
-	memdev->region_offset = t->spa_set_dma[1] + SPA1_SIZE/4;
+	memdev->region_offset = (1 << 24);
 	memdev->address = SPA0_SIZE/2;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 4;
@@ -947,7 +947,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 1+1;
 	memdev->region_index = 6+1;
 	memdev->region_size = SPA1_SIZE/4;
-	memdev->region_offset = t->spa_set_dma[1] + 2*SPA1_SIZE/4;
+	memdev->region_offset = (1ULL << 32);
 	memdev->address = SPA0_SIZE/2;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 4;
@@ -962,7 +962,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 	memdev->range_index = 1+1;
 	memdev->region_index = 7+1;
 	memdev->region_size = SPA1_SIZE/4;
-	memdev->region_offset = t->spa_set_dma[1] + 3*SPA1_SIZE/4;
+	memdev->region_offset = (1ULL << 40);
 	memdev->address = SPA0_SIZE/2;
 	memdev->interleave_index = 0;
 	memdev->interleave_ways = 4;
@@ -1380,7 +1380,7 @@ static void nfit_test0_setup(struct nfit_test *t)
 		memdev->range_index = 11+1;
 		memdev->region_index = 9+1;
 		memdev->region_size = SPA0_SIZE;
-		memdev->region_offset = t->spa_set_dma[2];
+		memdev->region_offset = (1ULL << 48);
 		memdev->address = 0;
 		memdev->interleave_index = 0;
 		memdev->interleave_ways = 1;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
