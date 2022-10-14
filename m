Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCCD4694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791959; x=1697327959;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=35GC+dPtkI8JDDm0wyE1ckiLPki/MRlOI+/f8wSKCbo=;
  b=ePeENYBgtM3TR2z9zUB1+Ob3JFHPe3yOTrAOCnjjgoW/LOklDo9b2kwF
   6l6Z9PRC+x1lr2H51YSC2iAYvSXarQzUVMVuUh+ce2EHlqO5PuRwsevmL
   LqFoMjFKABO2EPyCPt5I0HfFntnPS01l3R3SxKgw5hIv33Lbdb0ANtLR8
   oIBjpomcb/BhOlo5+1Dsgt3lJu/omGxgid52uMzQl/T/Y6FJEptC6vHbI
   b5ymdfA782YxUSPiruB0hCdBsXFalnNrCIgu4W9+UiNaA137/e+Z9kjHF
   B0zP4HChuMiDE6LXoGsf02mqJdHZOCJ4XvGXgjdEDDDgLKsRmYIrcg984
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="285224925"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="285224925"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:59:18 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="605541393"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="605541393"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:59:18 -0700
Subject: [PATCH v3 24/25] mm/meremap_pages: Delete
 put_devmap_managed_page_refs()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 John Hubbard <jhubbard@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Jason Gunthorpe <jgg@nvidia.com>, david@fromorbit.com, nvdimm@lists.linux.dev,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:59:17 -0700
Message-ID: <166579195789.2236710.7946318795534242314.stgit@dwillia2-xfh.jf.intel.com>
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

Now that fsdax DMA-idle detection no longer depends on catching
transitions of page->_refcount to 1, and all users of pgmap pages get
access to them via pgmap_request_folios(), remove
put_devmap_managed_page_refs() and associated infrastructure. This
includes the pgmap references taken at the beginning of time for each
page because those @pgmap references are now arbitrated via
pgmap_request_folios().

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h |   30 ------------------------------
 mm/gup.c           |    6 ++----
 mm/memremap.c      |   38 --------------------------------------
 mm/swap.c          |    2 --
 4 files changed, 2 insertions(+), 74 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8bbcccbc5565..c63dfc804f1e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1082,30 +1082,6 @@ vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf);
  *   back into memory.
  */
 
-#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
-DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
-
-bool __put_devmap_managed_page_refs(struct page *page, int refs);
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
-{
-	if (!static_branch_unlikely(&devmap_managed_key))
-		return false;
-	if (!is_zone_device_page(page))
-		return false;
-	return __put_devmap_managed_page_refs(page, refs);
-}
-#else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
-{
-	return false;
-}
-#endif /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-
-static inline bool put_devmap_managed_page(struct page *page)
-{
-	return put_devmap_managed_page_refs(page, 1);
-}
-
 /* 127: arbitrary random number, small enough to assemble well */
 #define folio_ref_zero_or_close_to_overflow(folio) \
 	((unsigned int) folio_ref_count(folio) + 127u <= 127u)
@@ -1202,12 +1178,6 @@ static inline void put_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
 
-	/*
-	 * For some devmap managed pages we need to catch refcount transition
-	 * from 2 to 1:
-	 */
-	if (put_devmap_managed_page(&folio->page))
-		return;
 	folio_put(folio);
 }
 
diff --git a/mm/gup.c b/mm/gup.c
index ce00a4c40da8..e49b1f46faa5 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -87,8 +87,7 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		if (!put_devmap_managed_page_refs(&folio->page, refs))
-			folio_put_refs(folio, refs);
+		folio_put_refs(folio, refs);
 		goto retry;
 	}
 
@@ -184,8 +183,7 @@ static void gup_put_folio(struct folio *folio, int refs, unsigned int flags)
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	if (!put_devmap_managed_page_refs(&folio->page, refs))
-		folio_put_refs(folio, refs);
+	folio_put_refs(folio, refs);
 }
 
 /**
diff --git a/mm/memremap.c b/mm/memremap.c
index 368ff41c560b..53fe30bb79bb 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -94,19 +94,6 @@ bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn)
 	return false;
 }
 
-static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
-{
-	const struct range *range = &pgmap->ranges[range_id];
-
-	return (range->start + range_len(range)) >> PAGE_SHIFT;
-}
-
-static unsigned long pfn_len(struct dev_pagemap *pgmap, unsigned long range_id)
-{
-	return (pfn_end(pgmap, range_id) -
-		pfn_first(pgmap, range_id)) >> pgmap->vmemmap_shift;
-}
-
 static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
 	struct range *range = &pgmap->ranges[range_id];
@@ -138,10 +125,6 @@ void memunmap_pages(struct dev_pagemap *pgmap)
 	int i;
 
 	percpu_ref_kill(&pgmap->ref);
-	if (pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    pgmap->type != MEMORY_DEVICE_COHERENT)
-		for (i = 0; i < pgmap->nr_range; i++)
-			percpu_ref_put_many(&pgmap->ref, pfn_len(pgmap, i));
 
 	wait_for_completion(&pgmap->done);
 
@@ -267,9 +250,6 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	if (pgmap->type != MEMORY_DEVICE_PRIVATE &&
-	    pgmap->type != MEMORY_DEVICE_COHERENT)
-		percpu_ref_get_many(&pgmap->ref, pfn_len(pgmap, range_id));
 	return 0;
 
 err_add_memory:
@@ -584,21 +564,3 @@ void pgmap_release_folios(struct folio *folio, int nr_folios)
 	for (iter = folio, i = 0; i < nr_folios; iter = folio_next(folio), i++)
 		folio_put(iter);
 }
-
-#ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page_refs(struct page *page, int refs)
-{
-	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
-		return false;
-
-	/*
-	 * fsdax page refcounts are 1-based, rather than 0-based: if
-	 * refcount is 1, then the page is free and the refcount is
-	 * stable because nobody holds a reference on the page.
-	 */
-	if (page_ref_sub_return(page, refs) == 1)
-		wake_up_var(page);
-	return true;
-}
-EXPORT_SYMBOL(__put_devmap_managed_page_refs);
-#endif /* CONFIG_FS_DAX */
diff --git a/mm/swap.c b/mm/swap.c
index 955930f41d20..0742b84fbf17 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1003,8 +1003,6 @@ void release_pages(struct page **pages, int nr)
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page(&folio->page))
-				continue;
 			if (folio_put_testzero(folio))
 				free_zone_device_page(&folio->page);
 			continue;

