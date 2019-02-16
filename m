Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B336201B042A
 for <linux-nvdimm@lists.01.org>; Sat, 16 Feb 2019 09:29:49 -0800 (PST)
Date: Sat, 16 Feb 2019 09:29:48 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: find_get_entries_tag regression bisected
Message-ID: <20190216172948.GN12668@bombadil.infradead.org>
References: <CAPcyv4gs7nGnf81Lj-Hf04uhmMb2wxKzi42ajaNVCHty7PAsAQ@mail.gmail.com>
 <20190216153511.GM12668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190216153511.GM12668@bombadil.infradead.org>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balcer,
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 16, 2019 at 07:35:11AM -0800, Matthew Wilcox wrote:
> Another way to fix this would be to mask the address in dax_entry_mkclean(),
> but I think this is cleaner.

That's clearly rubbish, dax_entry_mkclean() can't possibly mask the
address.  It might be mis-aligned in another process.  But ... if it's
misaligned in another process, dax_entry_mkclean() will only clean the first
PTE associated with the PMD; it won't clean the whole thing.  I think we need
something like this:

(I'll have to split it apart to give us something to backport)

diff --git a/fs/dax.c b/fs/dax.c
index 6959837cc465..09680aa0481f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -768,7 +768,7 @@ unsigned long pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
 
 /* Walk all mappings of a given index of a file and writeprotect them */
 static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
-		unsigned long pfn)
+		pgoff_t end, unsigned long pfn)
 {
 	struct vm_area_struct *vma;
 	pte_t pte, *ptep = NULL;
@@ -776,7 +776,7 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 	spinlock_t *ptl;
 
 	i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, end) {
 		struct mmu_notifier_range range;
 		unsigned long address;
 
@@ -843,9 +843,9 @@ static void dax_entry_mkclean(struct address_space *mapping, pgoff_t index,
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		struct address_space *mapping, void *entry)
 {
-	unsigned long pfn;
+	unsigned long pfn, index;
 	long ret = 0;
-	size_t size;
+	unsigned long count;
 
 	/*
 	 * A page got tagged dirty in DAX mapping? Something is seriously
@@ -894,17 +894,18 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_unlock_irq(xas);
 
 	/*
-	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
-	 * in the middle of a PMD, the 'index' we are given will be aligned to
-	 * the start index of the PMD, as will the pfn we pull from 'entry'.
+	 * If dax_writeback_mapping_range() was given a wbc->range_start
+	 * in the middle of a PMD, the 'index' we are given needs to be
+	 * aligned to the start index of the PMD.
 	 * This allows us to flush for PMD_SIZE and not have to worry about
 	 * partial PMD writebacks.
 	 */
 	pfn = dax_to_pfn(entry);
-	size = PAGE_SIZE << dax_entry_order(entry);
+	count = 1UL << dax_entry_order(entry);
+	index = xas->xa_index &~ (count - 1);
 
-	dax_entry_mkclean(mapping, xas->xa_index, pfn);
-	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
+	dax_entry_mkclean(mapping, index, index + count - 1, pfn);
+	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), count * PAGE_SIZE);
 	/*
 	 * After we have flushed the cache, we can clear the dirty tag. There
 	 * cannot be new dirty data in the pfn after the flush has completed as
@@ -917,8 +918,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
 	dax_wake_entry(xas, entry, false);
 
-	trace_dax_writeback_one(mapping->host, xas->xa_index,
-			size >> PAGE_SHIFT);
+	trace_dax_writeback_one(mapping->host, xas->xa_index, count);
 	return ret;
 
  put_unlocked:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
