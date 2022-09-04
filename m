Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378A57E
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257778; x=1693793778;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sipDxMIA1gHM4rUMbFjWahw5uArq5Zq1WCPqnel5xNA=;
  b=eQiLH7gvKpjWC6Ut293xKgEtm1K/8HFpx9Id/cg4nWmFS+3+aIcBFMdm
   1pCy+Da+7vlkqg0yctsp3RAzM15AzFe08L06dX50Ebcv2AAT/PljhlIxn
   obre2P/Bw5lmvznjmvNWx/3jYGUVcKEu8lYCkOeJ60BPY0S3KXuAQGQOL
   9GTZcc+/YvBou7i6eHWUXGs1toiN/sEhHGucz6NeFfaDpTUXyNSBFhrnJ
   k1pSMfN4DMyt0mZk22tqF6eMzWdL8Bd40exUbrf/LxDXU7bxhwUkyeWzh
   D/XoEab2TzXsBsDVF2BGgn3Q3/u+gTR69MOgk/XneQOENzMmWH8TlBtC0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="283193992"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="283193992"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="643384493"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:17 -0700
Subject: [PATCH 03/13] fsdax: Delete put_devmap_managed_page_refs()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:17 -0700
Message-ID: <166225777752.2351842.10384480208879805937.stgit@dwillia2-xfh.jf.intel.com>
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

Now that fsdax DMA-idle detection no longer depends on catching
transitions of page->_refcount to 1, remove
put_devmap_managed_page_refs() and associated infrastructure.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h |   30 ------------------------------
 mm/gup.c           |    3 +--
 mm/memremap.c      |   18 ------------------
 mm/swap.c          |    2 --
 4 files changed, 1 insertion(+), 52 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 557d5447ebec..24f8682d0cd7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1048,30 +1048,6 @@ vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf);
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
@@ -1168,12 +1144,6 @@ static inline void put_page(struct page *page)
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
index 499c46296fda..67dfffe97917 100644
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
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 58b20c3c300b..433500e955fb 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -507,21 +507,3 @@ void free_zone_device_page(struct page *page)
 	 */
 	set_page_count(page, 1);
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
-		wake_up_var(&page->_refcount);
-	return true;
-}
-EXPORT_SYMBOL(__put_devmap_managed_page_refs);
-#endif /* CONFIG_FS_DAX */
diff --git a/mm/swap.c b/mm/swap.c
index 9cee7f6a3809..b346dd24cde8 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -960,8 +960,6 @@ void release_pages(struct page **pages, int nr)
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page(&folio->page))
-				continue;
 			if (folio_put_testzero(folio))
 				free_zone_device_page(&folio->page);
 			continue;

