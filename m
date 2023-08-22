Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B0220EE0
	for <nvdimm@lists.linux.dev>; Tue, 22 Aug 2023 23:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=mpxVKN0XrOyZPUir3qkyx1vYe7ttRemIdlFNxzzSyz0=; b=raHMkHp689Y0gfyMz+Wef+qS3i
	a1jKPhLRZmejFHXH8NsS7ese1qlmeeYtIDphjPAQAMvX7CAORMzKF3qlnIUSO1mYFEB0czTW+esWk
	1Xr4+LBYHqTE0Y74OP1+2iq05g5V1xpG/j95PMv32ZtqVXvhmg9tQp14OGoDjoR0yRnq4dRfrb46x
	ZoiykeabUzxVLGDEdJ2J+I+8dO/OlrfWrcwcKXkKOo/KRmR6GzekDR/QqTjYl7hE3oETk2SN1Xt15
	WJgRrdMSkZEvAQiF0XImN+N1lpnB/XeGtBKgTAjztiaUJ9UyZ9i36ko3L7mpkTQiHbPqGGuqT98Il
	36qXOw6g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qYaYo-001SqZ-BA; Tue, 22 Aug 2023 23:13:18 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	linux-mm@kvack.org
Subject: [PATCH] mm: Convert DAX lock/unlock page to lock/unlock folio
Date: Wed, 23 Aug 2023 00:13:14 +0100
Message-Id: <20230822231314.349200-1-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The one caller of DAX lock/unlock page already calls compound_head(),
so use page_folio() instead, then use a folio throughout the DAX code
to remove uses of page->mapping and page->index.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/dax.c            | 24 ++++++++++++------------
 include/linux/dax.h | 10 +++++-----
 mm/memory-failure.c | 19 +++++++------------
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 8fafecbe42b1..3380b43cb6bb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -412,23 +412,23 @@ static struct page *dax_busy_page(void *entry)
 	return NULL;
 }
 
-/*
- * dax_lock_page - Lock the DAX entry corresponding to a page
- * @page: The page whose entry we want to lock
+/**
+ * dax_lock_folio - Lock the DAX entry corresponding to a folio
+ * @folio: The folio whose entry we want to lock
  *
  * Context: Process context.
- * Return: A cookie to pass to dax_unlock_page() or 0 if the entry could
+ * Return: A cookie to pass to dax_unlock_folio() or 0 if the entry could
  * not be locked.
  */
-dax_entry_t dax_lock_page(struct page *page)
+dax_entry_t dax_lock_folio(struct folio *folio)
 {
 	XA_STATE(xas, NULL, 0);
 	void *entry;
 
-	/* Ensure page->mapping isn't freed while we look at it */
+	/* Ensure folio->mapping isn't freed while we look at it */
 	rcu_read_lock();
 	for (;;) {
-		struct address_space *mapping = READ_ONCE(page->mapping);
+		struct address_space *mapping = READ_ONCE(folio->mapping);
 
 		entry = NULL;
 		if (!mapping || !dax_mapping(mapping))
@@ -447,11 +447,11 @@ dax_entry_t dax_lock_page(struct page *page)
 
 		xas.xa = &mapping->i_pages;
 		xas_lock_irq(&xas);
-		if (mapping != page->mapping) {
+		if (mapping != folio->mapping) {
 			xas_unlock_irq(&xas);
 			continue;
 		}
-		xas_set(&xas, page->index);
+		xas_set(&xas, folio->index);
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			rcu_read_unlock();
@@ -467,10 +467,10 @@ dax_entry_t dax_lock_page(struct page *page)
 	return (dax_entry_t)entry;
 }
 
-void dax_unlock_page(struct page *page, dax_entry_t cookie)
+void dax_unlock_folio(struct folio *folio, dax_entry_t cookie)
 {
-	struct address_space *mapping = page->mapping;
-	XA_STATE(xas, &mapping->i_pages, page->index);
+	struct address_space *mapping = folio->mapping;
+	XA_STATE(xas, &mapping->i_pages, folio->index);
 
 	if (S_ISCHR(mapping->host->i_mode))
 		return;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 22cd9902345d..b463502b16e1 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -159,8 +159,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
-dax_entry_t dax_lock_page(struct page *page);
-void dax_unlock_page(struct page *page, dax_entry_t cookie);
+dax_entry_t dax_lock_folio(struct folio *folio);
+void dax_unlock_folio(struct folio *folio, dax_entry_t cookie);
 dax_entry_t dax_lock_mapping_entry(struct address_space *mapping,
 		unsigned long index, struct page **page);
 void dax_unlock_mapping_entry(struct address_space *mapping,
@@ -182,14 +182,14 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 	return -EOPNOTSUPP;
 }
 
-static inline dax_entry_t dax_lock_page(struct page *page)
+static inline dax_entry_t dax_lock_folio(struct folio *folio)
 {
-	if (IS_DAX(page->mapping->host))
+	if (IS_DAX(folio->mapping->host))
 		return ~0UL;
 	return 0;
 }
 
-static inline void dax_unlock_page(struct page *page, dax_entry_t cookie)
+static inline void dax_unlock_folio(struct folio *folio, dax_entry_t cookie)
 {
 }
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a6c3af985554..b81d6eb4e6ff 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1717,16 +1717,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
 	struct page *page = pfn_to_page(pfn);
+	struct folio *folio = page_folio(page);
 	LIST_HEAD(to_kill);
 	dax_entry_t cookie;
 	int rc = 0;
 
-	/*
-	 * Pages instantiated by device-dax (not filesystem-dax)
-	 * may be compound pages.
-	 */
-	page = compound_head(page);
-
 	/*
 	 * Prevent the inode from being freed while we are interrogating
 	 * the address_space, typically this would be handled by
@@ -1734,11 +1729,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * also prevents changes to the mapping of this pfn until
 	 * poison signaling is complete.
 	 */
-	cookie = dax_lock_page(page);
+	cookie = dax_lock_folio(folio);
 	if (!cookie)
 		return -EBUSY;
 
-	if (hwpoison_filter(page)) {
+	if (hwpoison_filter(&folio->page)) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -1760,7 +1755,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(page);
+	SetPageHWPoison(&folio->page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1769,11 +1764,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &to_kill, true);
+	collect_procs(&folio->page, &to_kill, true);
 
-	unmap_and_kill(&to_kill, pfn, page->mapping, page->index, flags);
+	unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
 unlock:
-	dax_unlock_page(page, cookie);
+	dax_unlock_folio(folio, cookie);
 	return rc;
 }
 
-- 
2.40.1

