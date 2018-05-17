Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA3E5207E36B1
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 11:37:12 -0700 (PDT)
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red
 Hat Linux)) id 1fJNm3-0007Nx-Mu
 for linux-nvdimm@lists.01.org; Thu, 17 May 2018 18:37:11 +0000
Date: Thu, 17 May 2018 11:37:11 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] dax: Fix use of zero page
Message-ID: <20180517183711.GE26718@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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


I plucked this patch from my XArray work.  It seems self-contained enough
that it could go into the DAX tree for merging this cycle.

>From 8cb56f4ba36af38814ca7b8ba030a66384e59a21 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <mawilcox@microsoft.com>
Date: Thu, 29 Mar 2018 22:41:18 -0400
Subject: [PATCH] dax: Fix use of zero page

Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
works on MIPS and s390.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6a26626f20f3..f643e8fc34ee 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1006,17 +1006,9 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
-	struct page *zero_page;
 	void *entry2;
-	pfn_t pfn;
-
-	zero_page = ZERO_PAGE(0);
-	if (unlikely(!zero_page)) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
+	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
-	pfn = page_to_pfn_t(zero_page);
 	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_ZERO_PAGE, false);
 	if (IS_ERR(entry2)) {
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
