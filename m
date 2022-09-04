Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910577E
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257784; x=1693793784;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPcXvDmR3bCtwmu5PpDvm6C3RP1zngXbItUU55SD49w=;
  b=GgenHIGuNp7A5E1B1OXT3eu1rRgaCKLZXaLAc7zePBD9mU0D7ytzm9Ey
   JdVZ/+MqSMY2KuGnqQ9l/dnvKhvhsoknKrYDFDDXsuKrL0sF1LHbx17mq
   buzEhW45wtX6MQHGsPAbFXthTB2dbkeRH5OpivKUdHa2MCmqYSBBKAUgz
   tZO8gpF1f1fL15tZ6LG05hzU4HhqgG7B/WqXX8/bsLkZrezHXUgO/a6FR
   5Fye5TdfDW10mZFE7dyqS+BuiYusYkJdff5jv7JwN8RjEczVA0sWUiAn7
   D1mg9ME8OfX7iR9Sqbm/vqbIwBxYHbSazBAwZpuKnfzU9+VXHFxAlif0Q
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="276599747"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="276599747"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="702523932"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:23 -0700
Subject: [PATCH 04/13] fsdax: Update dax_insert_entry() calling convention
 to return an error
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:23 -0700
Message-ID: <166225778308.2351842.10359830461531484766.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com>
References: <166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com>
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
index aceb587bc27e..d2fb58a7449b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -853,14 +853,15 @@ static bool dax_fault_is_cow(const struct iomap_iter *iter)
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
@@ -906,7 +907,8 @@ static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
 	xas_unlock_irq(xas);
-	return entry;
+	*pentry = entry;
+	return 0;
 }
 
 static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
@@ -1154,9 +1156,12 @@ static vm_fault_t dax_load_hole(struct xa_state *xas, struct vm_fault *vmf,
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
@@ -1173,6 +1178,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	struct page *zero_page;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
+	vm_fault_t ret;
 	pfn_t pfn;
 
 	zero_page = mm_get_huge_zero_page(vmf->vma->vm_mm);
@@ -1181,8 +1187,10 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
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
@@ -1534,6 +1542,7 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	loff_t pos = (loff_t)xas->xa_index << PAGE_SHIFT;
 	bool write = iter->flags & IOMAP_WRITE;
 	unsigned long entry_flags = pmd ? DAX_PMD : 0;
+	vm_fault_t ret;
 	int err = 0;
 	pfn_t pfn;
 	void *kaddr;
@@ -1558,7 +1567,9 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
-	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
+	ret = dax_insert_entry(xas, vmf, iter, entry, pfn, entry_flags);
+	if (ret)
+		return ret;
 
 	if (write &&
 	    srcmap->type != IOMAP_HOLE && srcmap->addr != iomap->addr) {

