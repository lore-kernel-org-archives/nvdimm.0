Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24DA210F
	for <nvdimm@lists.linux.dev>; Fri,  8 Sep 2023 19:53:14 +0000 (UTC)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 388JYwxu022380;
	Fri, 8 Sep 2023 19:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2023-03-30;
 bh=kUiZ5r4t+hxzPPGJ7LIQG9W0+FalRtmlfoj/bAGU40w=;
 b=zNMNShdpzfax1lwjavlr150Jt39LZMXSVTVpMcJRkVrPzO3Qaf2GprustFr0YnmvZwio
 9SgVhGYuo3sVMPWA2FVs7J8BMuLC1yt0cXihDOO81ZahUFbqzU5+lo22d7hnLITJPuyj
 G/PgxWMmVkPbK7RDjLbiPjBLpOOI0UYw2nD1hXb7DcSVbLaSGLS2cwjdm1HstQIAnXPS
 Fw1yq7+g6JSyCC4Jle7+S9n+mDZThttM1ggaq74xLBJyywysQx5b+HSbKl+mJowliSi1
 hrRU5qBwOAjgk66Mll0zm4O6pn7VvgpPRz21Gzm5UAquMRB1oLmL+KJdvKsVaszWBksl /A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t09w0816b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Sep 2023 19:52:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 388INr3n017274;
	Fri, 8 Sep 2023 19:52:33 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3suuga2etm-1;
	Fri, 08 Sep 2023 19:52:33 +0000
From: Jane Chu <jane.chu@oracle.com>
To: willy@infradead.org, akpm@linux-foundation.org, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, naoya.horiguchi@nec.com, linux-mm@kvack.org
Subject: [PATCH v2] mm: Convert DAX lock/unlock page to lock/unlock folio
Date: Fri,  8 Sep 2023 13:52:15 -0600
Message-Id: <20230908195215.176586-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-08_15,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309080180
X-Proofpoint-GUID: SD0FvxhVkT6_fIBvgkRl-oXpTKMbZSSS
X-Proofpoint-ORIG-GUID: SD0FvxhVkT6_fIBvgkRl-oXpTKMbZSSS
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

The one caller of DAX lock/unlock page already calls compound_head(),
so use page_folio() instead, then use a folio throughout the DAX code
to remove uses of page->mapping and page->index.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/dax.c            | 24 ++++++++++++------------
 include/linux/dax.h | 10 +++++-----
 mm/memory-failure.c | 29 ++++++++++++++++-------------
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 906ecbd541a3..c70d4da047db 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -426,23 +426,23 @@ static struct page *dax_busy_page(void *entry)
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
@@ -461,11 +461,11 @@ dax_entry_t dax_lock_page(struct page *page)
 
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
@@ -481,10 +481,10 @@ dax_entry_t dax_lock_page(struct page *page)
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
index 261944ec0887..711deb72c109 100644
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
index fe121fdb05f7..90e04fedebbc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1710,20 +1710,23 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
 }
 
+/*
+ * Only dev_pagemap pages get here, such as fsdax when the filesystem
+ * either do not claim or fails to claim a hwpoison event, or devdax.
+ * The fsdax pages are initialized per base page, and the devdax pages
+ * could be initialized either as base pages, or as compound pages with
+ * vmemmap optimization enabled. Devdax is simplistic in its dealing with
+ * hwpoison, such that, if a subpage of a compound page is poisoned,
+ * simply mark the compound head page is by far sufficient.
+ */
 static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 		struct dev_pagemap *pgmap)
 {
-	struct page *page = pfn_to_page(pfn);
+	struct folio *folio = page_folio(pfn_to_page(pfn));
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
@@ -1731,11 +1734,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
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
@@ -1757,7 +1760,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(page);
+	SetPageHWPoison(&folio->page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1766,11 +1769,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
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
 

base-commit: 727dbda16b83600379061c4ca8270ef3e2f51922
-- 
2.18.4

