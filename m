Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6320F1A1E6A
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 09:52:24 -0700 (PDT)
Subject: [PATCH 1/5] dax: fix mapping size check
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 06 Sep 2016 09:49:26 -0700
Message-ID: <147318056595.30325.8488744773976820879.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

pgoff_to_phys() validates that both the starting address and the length
of the mapping against the resource list.  We need to check for a
mapping size of PMD_SIZE not PAGE_SIZE in the pmd fault path.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 803f3953b341..29f600f2c447 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -459,7 +459,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev,
 	}
 
 	pgoff = linear_page_index(vma, pmd_addr);
-	phys = pgoff_to_phys(dax_dev, pgoff, PAGE_SIZE);
+	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
 	if (phys == -1) {
 		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
 				pgoff);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
