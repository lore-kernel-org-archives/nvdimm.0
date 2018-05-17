Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9222207E4DF3
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 11:45:05 -0700 (PDT)
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red
 Hat Linux)) id 1fJNth-00013q-Gj
 for linux-nvdimm@lists.01.org; Thu, 17 May 2018 18:45:05 +0000
Date: Thu, 17 May 2018 11:45:05 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] dax: dax_insert_mapping_entry always succeeds
Message-ID: <20180517184505.GF26718@bombadil.infradead.org>
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


Another bugfix from the XArray work; please queue for merge.

>From 4a53cab1968d2a1022f35d00b29519970ef624e9 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <mawilcox@microsoft.com>
Date: Thu, 29 Mar 2018 22:47:50 -0400
Subject: [PATCH] dax: dax_insert_mapping_entry always succeeds

It does not return an error, so we don't need to check the return value
for IS_ERR().  Indeed, it is a bug to do so; with a sufficiently large
PFN, a legitimate DAX entry may be mistaken for an error return.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/dax.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index f643e8fc34ee..99c5084b845c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1005,19 +1005,13 @@ static vm_fault_t dax_load_hole(struct address_space *mapping, void *entry,
 {
 	struct inode *inode = mapping->host;
 	unsigned long vaddr = vmf->address;
-	vm_fault_t ret = VM_FAULT_NOPAGE;
-	void *entry2;
+	vm_fault_t ret;
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 
-	entry2 = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
+	dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_ZERO_PAGE, false);
-	if (IS_ERR(entry2)) {
-		ret = VM_FAULT_SIGBUS;
-		goto out;
-	}
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
-out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
@@ -1327,10 +1321,6 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						 0, write && !sync);
-		if (IS_ERR(entry)) {
-			error = PTR_ERR(entry);
-			goto error_finish_iomap;
-		}
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
@@ -1411,8 +1401,6 @@ static vm_fault_t dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 	pfn = page_to_pfn_t(zero_page);
 	ret = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 			DAX_PMD | DAX_ZERO_PAGE, false);
-	if (IS_ERR(ret))
-		goto fallback;
 
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
@@ -1534,8 +1522,6 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 		entry = dax_insert_mapping_entry(mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
-		if (IS_ERR(entry))
-			goto finish_iomap;
 
 		/*
 		 * If we are doing synchronous page fault and inode needs fsync,
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
