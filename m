Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B982565
	for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 13:49:56 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id a16so765837plh.13
        for <nvdimm@lists.linux.dev>; Tue, 29 Mar 2022 06:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5g/0QWFd98PH+GDbIHxo8Dsrvq3fGfzY+G57IkW5WS4=;
        b=5jTksSyqDEj2RjKSzOYdzXajZNOJ+ImYqLNcdNfjk1dYvzTzQ0ix1xjuWpsKGO4tvV
         XmJevgQbARoI/SiYwUK5zVXHRhySAkQhL/qfjlq+swp2iMm7NKrVsqLl6nlUbcz70IXi
         fAdPp9yiKRDbsldcR7qEx9Ixpseip+7ALWVwC1GMERZ8QU3IGXmm33o5IfaHuNuamKTX
         6KSlQTGCA7VCxdOZUJrTp+Ren6ihHc+Z972wetIf+Dzfhd3HK27eiZlzXK5F3DRwHbb9
         ethRFkrtkCiYCerP8pGR0oq+yNkeae4YOj+fop++hsrBsVszD/GfXQ0SX5ZH8mn6eMsx
         V7Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5g/0QWFd98PH+GDbIHxo8Dsrvq3fGfzY+G57IkW5WS4=;
        b=Y1aMQYADgPw4CQOVw+fB2+9CTAykYdIq2YC6zXZMjBgUNGiBPubEyFauDX+DokGDnY
         amHYikRBPiymfzgdq4Qwxvtyv7XIUbbwUCWLLEUBsuMGs3oE4tRZRRYtUoOauNWfkYgY
         EHdqUeswkL7K1U0zuP3nnj1w5Q71xwzwh38g6Xvh7xYTSI/ijRIv9gYQnmFinksiBkOY
         TCLXsPchKmSS32dQ5gS0LYYQrpVj0JWCh0YgPOotAh1QPy9v2Q2WSy6fLW9DUClfjcCS
         OqRIcSiAXX4npPCoq6QSFs69gosIvGT7KUZFVLhnsmlAtV+b2g4GJ6xWyq804Fsd6vs0
         VCBQ==
X-Gm-Message-State: AOAM531nF9UZSxuG3FgTc98FL8NDqa3gwJZbHv1DZo2emEgqL6qQTKxs
	urgSSTES7/a5MXbLZWIgmBcgJw==
X-Google-Smtp-Source: ABdhPJzrBTv1qO1OUayF66SVnLQDlK+xwrvlhNk2hu/mbWXxrmyumWfoQ0v8Vs1PXGVwMLfleNNFqw==
X-Received: by 2002:a17:902:650e:b0:153:99d4:9151 with SMTP id b14-20020a170902650e00b0015399d49151mr31133954plk.20.1648561795808;
        Tue, 29 Mar 2022 06:49:55 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id o14-20020a056a0015ce00b004fab49cd65csm20911293pfu.205.2022.03.29.06.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:49:55 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	shy828301@gmail.com,
	rcampbell@nvidia.com,
	hughd@google.com,
	xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com,
	zwisler@kernel.org,
	hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	duanxiongchun@bytedance.com,
	smuchun@gmail.com,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
Date: Tue, 29 Mar 2022 21:48:50 +0800
Message-Id: <20220329134853.68403-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220329134853.68403-1-songmuchun@bytedance.com>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The page_mkclean_one() is supposed to be used with the pfn that has a
associated struct page, but not all the pfns (e.g. DAX) have a struct
page. Introduce a new function pfn_mkclean_range() to cleans the PTEs
(including PMDs) mapped with range of pfns which has no struct page
associated with them. This helper will be used by DAX device in the
next patch to make pfns clean.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/rmap.h |  3 +++
 mm/internal.h        | 26 +++++++++++++--------
 mm/rmap.c            | 65 +++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 74 insertions(+), 20 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index b58ddb8b2220..a6ec0d3e40c1 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -263,6 +263,9 @@ unsigned long page_address_in_vma(struct page *, struct vm_area_struct *);
  */
 int folio_mkclean(struct folio *);
 
+int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
+		      struct vm_area_struct *vma);
+
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
 /*
diff --git a/mm/internal.h b/mm/internal.h
index f45292dc4ef5..ff873944749f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -516,26 +516,22 @@ void mlock_page_drain(int cpu);
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * At what user virtual address is page expected in vma?
- * Returns -EFAULT if all of the page is outside the range of vma.
- * If page is a compound head, the entire compound page is considered.
+ * * Return the start of user virtual address at the specific offset within
+ * a vma.
  */
 static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
+		  struct vm_area_struct *vma)
 {
-	pgoff_t pgoff;
 	unsigned long address;
 
-	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
-	pgoff = page_to_pgoff(page);
 	if (pgoff >= vma->vm_pgoff) {
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		/* Check for address beyond vma (or wrapped through 0?) */
 		if (address < vma->vm_start || address >= vma->vm_end)
 			address = -EFAULT;
-	} else if (PageHead(page) &&
-		   pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
+	} else if (pgoff + nr_pages - 1 >= vma->vm_pgoff) {
 		/* Test above avoids possibility of wrap to 0 on 32-bit */
 		address = vma->vm_start;
 	} else {
@@ -545,6 +541,18 @@ vma_address(struct page *page, struct vm_area_struct *vma)
 }
 
 /*
+ * Return the start of user virtual address of a page within a vma.
+ * Returns -EFAULT if all of the page is outside the range of vma.
+ * If page is a compound head, the entire compound page is considered.
+ */
+static inline unsigned long
+vma_address(struct page *page, struct vm_area_struct *vma)
+{
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
+}
+
+/*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
diff --git a/mm/rmap.c b/mm/rmap.c
index 723682ddb9e8..ad5cf0e45a73 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -929,12 +929,12 @@ int folio_referenced(struct folio *folio, int is_locked,
 	return pra.referenced;
 }
 
-static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
-			    unsigned long address, void *arg)
+static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 {
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	int cleaned = 0;
+	struct vm_area_struct *vma = pvmw->vma;
 	struct mmu_notifier_range range;
-	int *cleaned = arg;
+	unsigned long address = pvmw->address;
 
 	/*
 	 * We have to assume the worse case ie pmd for invalidation. Note that
@@ -942,16 +942,16 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 				0, vma, vma->vm_mm, address,
-				vma_address_end(&pvmw));
+				vma_address_end(pvmw));
 	mmu_notifier_invalidate_range_start(&range);
 
-	while (page_vma_mapped_walk(&pvmw)) {
+	while (page_vma_mapped_walk(pvmw)) {
 		int ret = 0;
 
-		address = pvmw.address;
-		if (pvmw.pte) {
+		address = pvmw->address;
+		if (pvmw->pte) {
 			pte_t entry;
-			pte_t *pte = pvmw.pte;
+			pte_t *pte = pvmw->pte;
 
 			if (!pte_dirty(*pte) && !pte_write(*pte))
 				continue;
@@ -964,7 +964,7 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			pmd_t *pmd = pvmw.pmd;
+			pmd_t *pmd = pvmw->pmd;
 			pmd_t entry;
 
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
@@ -991,11 +991,22 @@ static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
 		if (ret)
-			(*cleaned)++;
+			cleaned++;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
 
+	return cleaned;
+}
+
+static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
+			     unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	int *cleaned = arg;
+
+	*cleaned += page_vma_mkclean_one(&pvmw);
+
 	return true;
 }
 
@@ -1033,6 +1044,38 @@ int folio_mkclean(struct folio *folio)
 EXPORT_SYMBOL_GPL(folio_mkclean);
 
 /**
+ * pfn_mkclean_range - Cleans the PTEs (including PMDs) mapped with range of
+ *                     [@pfn, @pfn + @nr_pages) at the specific offset (@pgoff)
+ *                     within the @vma of shared mappings. And since clean PTEs
+ *                     should also be readonly, write protects them too.
+ * @pfn: start pfn.
+ * @nr_pages: number of physically contiguous pages srarting with @pfn.
+ * @pgoff: page offset that the @pfn mapped with.
+ * @vma: vma that @pfn mapped within.
+ *
+ * Returns the number of cleaned PTEs (including PMDs).
+ */
+int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
+		      struct vm_area_struct *vma)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.pfn		= pfn,
+		.nr_pages	= nr_pages,
+		.pgoff		= pgoff,
+		.vma		= vma,
+		.flags		= PVMW_SYNC,
+	};
+
+	if (invalid_mkclean_vma(vma, NULL))
+		return 0;
+
+	pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
+	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
+
+	return page_vma_mkclean_one(&pvmw);
+}
+
+/**
  * page_move_anon_rmap - move a page to our anon_vma
  * @page:	the page to move to our anon_vma
  * @vma:	the vma the page belongs to
-- 
2.11.0

