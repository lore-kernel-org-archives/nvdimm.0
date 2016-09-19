Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B83CA1A1E31
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 13:59:52 -0700 (PDT)
Subject: [PATCH] tools/testing/nvdimm: fix allocation range for mock flush
 hint tables
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Sep 2016 13:56:49 -0700
Message-ID: <147431860913.2416.1876233800229605740.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit 480b6837aa57 "nvdimm: fix PHYS_PFN/PFN_PHYS mixup" identified
that we were passing an invalid address to devm_nvdimm_ioremap(). With
that fixed it exposed a bug in the memory reservation size for flush
hint tables.  Since we map a full page we need to mock a full page of
memory to back the flush hint table entries.

Cc: Oliver O'Halloran <oohall@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index dd48f421844c..f64c57bf1d4b 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -603,7 +603,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
 			return -ENOMEM;
 		sprintf(t->label[i], "label%d", i);
 
-		t->flush[i] = test_alloc(t, sizeof(u64) * NUM_HINTS,
+		t->flush[i] = test_alloc(t, max(PAGE_SIZE,
+					sizeof(u64) * NUM_HINTS),
 				&t->flush_dma[i]);
 		if (!t->flush[i])
 			return -ENOMEM;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
