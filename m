Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A8A20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299351; x=1694835351;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gvNMBXmzRliL/61+0l3Vp0DMaKfxeHPNaGSpEyGRros=;
  b=k0KEmVtqKlWm/kfTPwfHpZ0AzyatYV18oMoUSvY+noy21I/KYkSHGIWg
   eED9IAlbf5dAukDYZ9zQM7Yl0TWXirgQODPs0fBogt7XgvBK6KEZb9+N0
   6SgxmPBxyqkP7COcrh8f6/iDidYal0IJK7QNcJLmXuLrxK/T7XqihslT/
   q48iuUq3xlosI1s0Pwkj33Xv0bOZNWK2Gp+IODDe2K71Hq2I2vfvJDu4b
   b+HjaEWosVoFORftHnG2S4idGRTz8xdUeSa/4VPULxPUDtbYS9bsrwSvR
   R5WYw1KKEOZFwp0IT45HmMYofbg1TfDLVvO1J7YdmXNW6hHAxywdNgJYE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="325170327"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="325170327"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="792961964"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:50 -0700
Subject: [PATCH v2 07/18] fsdax: Update dax_insert_entry() calling
 convention to return an error
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:50 -0700
Message-ID: <166329935018.2786261.15861171979773593749.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for teaching dax_insert_entry() to take live @pgmap
references, enable it to return errors. Given the observation that all
callers overwrite the passed in entry with the return value, just update
@entry in place and convert the return code to a vm_fault_t status.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 616bac4b7df3..8382aab0d2f7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -887,14 +887,15 @@ static bool dax_fault_is_cow(const struct iomap_iter *iter)
  * already in the tree, we will skip the insertion and just dirty the PMD as
  * appropriate.
  */
-static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
-		const struct iomap_iter *iter, void *entry, pfn_t pfn,
-		unsigned long flags)
+static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
+				   const struct iomap_iter *iter, void **pentry,
+				   pfn_t pfn, unsigned long flags)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
 	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
 	bool cow = dax_fault_is_cow(iter);
+	void *entry = *pentry;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -940,7 +941,8 @@ static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
 	xas_unlock_irq(xas);
-	return entry;
+	*pentry = entry;
+	return 0;
 }
 
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
@@ -1188,9 +1190,12 @@ static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	pfn_t pfn = pfn_to_pfn_t(my_zero_pfn(vaddr));
 	vm_fault_t ret;
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, DAX_ZERO_PAGE);
+	if (ret)
+		goto out;
 
 	ret = vmf_insert_mixed(vmf->vma, vaddr, pfn);
+out:
 	trace_dax_load_hole(inode, vmf, ret);
 	return ret;
 }
@@ -1207,6 +1212,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	struct page *zero_page;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
+	vm_fault_t ret;
 	pfn_t pfn;
 
 	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
@@ -1215,8 +1221,10 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 		goto fallback;
 
 	pfn = page_to_pfn_t(zero_page);
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn,
-				  DAX_PMD | DAX_ZERO_PAGE);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn,
+			       DAX_PMD | DAX_ZERO_PAGE);
+	if (ret)
+		return ret;
 
 	if (arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(vma->vm_mm);
@@ -1568,6 +1576,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
+	vm_fault_t ret;
 	int err = 0;
 	pfn_t pfn;
 	void *kaddr;
@@ -1592,7 +1601,9 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
+	if (ret)
+		return ret;
 
 	if (write &&
 	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {

