Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A8F22129641A
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 23:20:30 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/22] mm/hmm.c: suppress compilation warnings when
 CONFIG_HUGETLB_PAGE is not set
Date: Mon,  1 Jul 2019 08:19:59 +0200
Message-Id: <20190701062020.19239-2-hch@lst.de>
In-Reply-To: <20190701062020.19239-1-hch@lst.de>
References: <20190701062020.19239-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Jason Gunthorpe <jgg@mellanox.com>

gcc reports that several variables are defined but not used.

For the first hunk CONFIG_HUGETLB_PAGE the entire if block is already
protected by pud_huge() which is forced to 0.  None of the stuff under the
ifdef causes compilation problems as it is already stubbed out in the
header files.

For the second hunk the dummy huge_page_shift macro doesn't touch the
argument, so just inline the argument.

Link: http://lkml.kernel.org/r/20190522195151.GA23955@ziepe.ca
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/hmm.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index c5d840e34b28..c62ae414a3a2 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -788,7 +788,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 			return hmm_vma_walk_hole_(addr, end, fault,
 						write_fault, walk);
 
-#ifdef CONFIG_HUGETLB_PAGE
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 		for (i = 0; i < npages; ++i, ++pfn) {
 			hmm_vma_walk->pgmap = get_dev_pagemap(pfn,
@@ -804,9 +803,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 		}
 		hmm_vma_walk->last = end;
 		return 0;
-#else
-		return -EINVAL;
-#endif
 	}
 
 	split_huge_pud(walk->vma, pudp, addr);
@@ -1015,9 +1011,8 @@ long hmm_range_snapshot(struct hmm_range *range)
 			return -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
-			struct hstate *h = hstate_vma(vma);
-
-			if (huge_page_shift(h) != range->page_shift &&
+			if (huge_page_shift(hstate_vma(vma)) !=
+				    range->page_shift &&
 			    range->page_shift != PAGE_SHIFT)
 				return -EINVAL;
 		} else {
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
