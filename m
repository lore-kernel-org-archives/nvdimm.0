Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6DA6321194D5D
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 07:49:03 -0800 (PST)
Date: Fri, 30 Nov 2018 07:49:02 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Fix Xarray conversion of dax_unlock_mapping_entry()
Message-ID: <20181130154902.GL10377@bombadil.infradead.org>
References: <154353682674.1676897.15440708268545845062.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154353682674.1676897.15440708268545845062.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 29, 2018 at 04:13:46PM -0800, Dan Williams wrote:
> Internal to dax_unlock_mapping_entry(), dax_unlock_entry() is used to
> store a replacement entry in the Xarray at the given xas-index with the
> DAX_LOCKED bit clear. When called, dax_unlock_entry() expects the unlocked
> value of the entry relative to the current Xarray state to be specified.
> 
> In most contexts dax_unlock_entry() is operating in the same scope as
> the matched dax_lock_entry(). However, in the dax_unlock_mapping_entry()
> case the implementation needs to recall the original entry. In the case
> where the original entry is a 'pmd' entry it is possible that the pfn
> performed to do the lookup is misaligned to the value retrieved in the
> Xarray.

So far, dax_unlock_mapping_entry only has the one caller.  I'd rather we
returned the 'entry' to the caller, then had them pass it back to the
unlock function.  That matches the flow in the rest of DAX and doesn't
pose an undue burden to the caller.

I plan to reclaim the DAX_LOCK bit (and the DAX_EMPTY bit for that
matter), instead using a special DAX_LOCK value.  DAX is almost free of
assumptions about the other bits in a locked entry, and this will remove
the assuption that there's a PMD bit in the entry.

How does this look?

diff --git a/fs/dax.c b/fs/dax.c
index 9bcce89ea18e..7681429af42f 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -351,20 +351,20 @@ static struct page *dax_busy_page(void *entry)
  * @page: The page whose entry we want to lock
  *
  * Context: Process context.
- * Return: %true if the entry was locked or does not need to be locked.
+ * Return: A cookie to pass to dax_unlock_mapping_entry() or %NULL if the
+ * entry could not be locked.
  */
-bool dax_lock_mapping_entry(struct page *page)
+void *dax_lock_mapping_entry(struct page *page)
 {
 	XA_STATE(xas, NULL, 0);
 	void *entry;
-	bool locked;
 
 	/* Ensure page->mapping isn't freed while we look at it */
 	rcu_read_lock();
 	for (;;) {
 		struct address_space *mapping = READ_ONCE(page->mapping);
 
-		locked = false;
+		entry = NULL;
 		if (!dax_mapping(mapping))
 			break;
 
@@ -375,7 +375,7 @@ bool dax_lock_mapping_entry(struct page *page)
 		 * otherwise we would not have a valid pfn_to_page()
 		 * translation.
 		 */
-		locked = true;
+		entry = (void *)1;
 		if (S_ISCHR(mapping->host->i_mode))
 			break;
 
@@ -400,22 +400,17 @@ bool dax_lock_mapping_entry(struct page *page)
 		break;
 	}
 	rcu_read_unlock();
-	return locked;
+	return entry;
 }
 
-void dax_unlock_mapping_entry(struct page *page)
+void dax_unlock_mapping_entry(struct page *page, void *entry)
 {
 	struct address_space *mapping = page->mapping;
 	XA_STATE(xas, &mapping->i_pages, page->index);
-	void *entry;
 
 	if (S_ISCHR(mapping->host->i_mode))
 		return;
 
-	rcu_read_lock();
-	entry = xas_load(&xas);
-	rcu_read_unlock();
-	entry = dax_make_entry(page_to_pfn_t(page), dax_is_pmd_entry(entry));
 	dax_unlock_entry(&xas, entry);
 }
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 450b28db9533..bc143c2d6980 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -88,8 +88,8 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
-bool dax_lock_mapping_entry(struct page *page);
-void dax_unlock_mapping_entry(struct page *page);
+void *dax_lock_mapping_entry(struct page *page);
+void dax_unlock_mapping_entry(struct page *page, void *entry);
 #else
 static inline bool bdev_dax_supported(struct block_device *bdev,
 		int blocksize)
@@ -122,14 +122,14 @@ static inline int dax_writeback_mapping_range(struct address_space *mapping,
 	return -EOPNOTSUPP;
 }
 
-static inline bool dax_lock_mapping_entry(struct page *page)
+static inline void *dax_lock_mapping_entry(struct page *page)
 {
 	if (IS_DAX(page->mapping->host))
-		return true;
-	return false;
+		return (void *)1;
+	return NULL;
 }
 
-static inline void dax_unlock_mapping_entry(struct page *page)
+static inline void dax_unlock_mapping_entry(struct page *page, void *entry)
 {
 }
 #endif
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0cd3de3550f0..3abea1e19902 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1161,6 +1161,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	LIST_HEAD(tokill);
 	int rc = -EBUSY;
 	loff_t start;
+	void *cookie;
 
 	/*
 	 * Prevent the inode from being freed while we are interrogating
@@ -1169,7 +1170,8 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	 * also prevents changes to the mapping of this pfn until
 	 * poison signaling is complete.
 	 */
-	if (!dax_lock_mapping_entry(page))
+	cookie = dax_lock_mapping_entry(page);
+	if (!cookie)
 		goto out;
 
 	if (hwpoison_filter(page)) {
@@ -1220,7 +1222,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
 unlock:
-	dax_unlock_mapping_entry(page);
+	dax_unlock_mapping_entry(page, cookie);
 out:
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
