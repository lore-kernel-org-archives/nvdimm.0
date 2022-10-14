Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004CC4695
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791879; x=1697327879;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dRBEo+va9LdTaMALBHzem55il8qhSDS6I2rVZ6WlqEM=;
  b=gTjy+6SZp0N1E6u1YhLAzDKJDAYCwfZjo18sdITKimPojITSQhYCNbox
   EDLltESVjwzhHmQ/KONf7iQdVdJ0gIFWMla9D72YVrWPr1Q2TJj0CfbA7
   mh7EXtoB7Bv5f2yg8Ci11OrLZFm1m7WcajvAzFEknPLZdJ12snc/ymB8X
   lN8P0mYaOUBft4Nq2+L4trDPkyrpkS7cU/tzauVeQJ3Vv/gLKMCKGENIB
   RiMkmVnSyiV4CmXa1HhBck5YgwO5g0aNRv18v+AKKNLAk5a4rs5A0Kh9O
   RCmJ6IfYicJeROgeyc3GS5wLF6VXgrkHfcy5jkFZEihXSDIvHjC1j6TXq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="367523132"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="367523132"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113300"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113300"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:43 -0700
Subject: [PATCH v3 08/25] fsdax: Update dax_insert_entry() calling
 convention to return an error
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:43 -0700
Message-ID: <166579186334.2236710.388332274317019999.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
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
 fs/dax.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6990a6e7df9f..1f6c1abfe0c9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -907,14 +907,15 @@ static bool dax_fault_is_cow(const struct iomap_iter *iter)
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
@@ -960,7 +961,9 @@ static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
 	xas_unlock_irq(xas);
-	return entry;
+
+	*pentry = entry;
+	return 0;
 }
 
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
@@ -1206,9 +1209,12 @@ static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
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
@@ -1225,6 +1231,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	struct page *zero_page;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
+	vm_fault_t ret;
 	pfn_t pfn;
 
 	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
@@ -1233,8 +1240,10 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
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
@@ -1587,6 +1596,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
 	int err = 0, id;
+	vm_fault_t ret;
 	pfn_t pfn;
 	void *kaddr;
 
@@ -1613,8 +1623,10 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 	}
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
 	dax_read_unlock(id);
+	if (ret)
+		return ret;
 
 	if (write &&
 	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {

