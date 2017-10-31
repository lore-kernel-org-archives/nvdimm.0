Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D0392034C089
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 16:25:24 -0700 (PDT)
Subject: [PATCH 14/15] dax: associate mappings with inodes,
 and warn if dma collides with truncate
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 16:22:51 -0700
Message-ID: <150949217152.24061.9869502311102659784.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Catch cases where truncate encounters pages that are still under active
dma. This warning is a canary for potential data corruption as truncated
blocks could be allocated to a new file while the device is still
perform i/o.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c                 |   56 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm_types.h |   20 ++++++++++++----
 kernel/memremap.c        |   10 ++++----
 3 files changed, 76 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ac6497dcfebd..fd5d385988d1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -297,6 +297,55 @@ static void put_unlocked_mapping_entry(struct address_space *mapping,
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
+static unsigned long dax_entry_size(void *entry)
+{
+	if (dax_is_zero_entry(entry))
+		return 0;
+	else if (dax_is_empty_entry(entry))
+		return 0;
+	else if (dax_is_pmd_entry(entry))
+		return HPAGE_SIZE;
+	else
+		return PAGE_SIZE;
+}
+
+#define for_each_entry_pfn(entry, pfn, end_pfn) \
+	for (pfn = dax_radix_pfn(entry), \
+			end_pfn = pfn + dax_entry_size(entry) / PAGE_SIZE; \
+			pfn < end_pfn; \
+			pfn++)
+
+static void dax_associate_entry(void *entry, struct inode *inode)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(page->inode);
+		page->inode = inode;
+	}
+}
+
+static void dax_disassociate_entry(void *entry, struct inode *inode, bool trunc)
+{
+	unsigned long pfn, end_pfn;
+
+	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
+		return;
+
+	for_each_entry_pfn(entry, pfn, end_pfn) {
+		struct page *page = pfn_to_page(pfn);
+
+		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
+		WARN_ON_ONCE(page->inode && page->inode != inode);
+		page->inode = NULL;
+	}
+}
+
 /*
  * Find radix tree entry at given index. If it points to an exceptional entry,
  * return it with the radix tree entry locked. If the radix tree doesn't
@@ -403,6 +452,7 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 		}
 
 		if (pmd_downgrade) {
+			dax_disassociate_entry(entry, mapping->host, false);
 			radix_tree_delete(&mapping->page_tree, index);
 			mapping->nrexceptional--;
 			dax_wake_mapping_entry_waiter(mapping, index, entry,
@@ -452,6 +502,7 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
 	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
 		goto out;
+	dax_disassociate_entry(entry, mapping->host, trunc);
 	radix_tree_delete(page_tree, index);
 	mapping->nrexceptional--;
 	ret = 1;
@@ -529,6 +580,7 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 {
 	struct radix_tree_root *page_tree = &mapping->page_tree;
 	unsigned long pfn = pfn_t_to_pfn(pfn_t);
+	struct inode *inode = mapping->host;
 	pgoff_t index = vmf->pgoff;
 	void *new_entry;
 
@@ -548,6 +600,10 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
 
 	spin_lock_irq(&mapping->tree_lock);
 	new_entry = dax_radix_locked_entry(pfn, flags);
+	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+		dax_disassociate_entry(entry, inode, false);
+		dax_associate_entry(new_entry, inode);
+	}
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 46f4ecf5479a..dd976851e8d8 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -118,11 +118,21 @@ struct page {
 					 * Can be used as a generic list
 					 * by the page owner.
 					 */
-		struct dev_pagemap *pgmap; /* ZONE_DEVICE pages are never on an
-					    * lru or handled by a slab
-					    * allocator, this points to the
-					    * hosting device page map.
-					    */
+		struct {
+			/*
+			 * ZONE_DEVICE pages are never on an lru or handled by
+			 * a slab allocator, this points to the hosting device
+			 * page map.
+			 */
+			struct dev_pagemap *pgmap;
+			/*
+			 * inode association for MEMORY_DEVICE_FS_DAX page-idle
+			 * callbacks. Note that we don't use ->mapping since
+			 * that has hard coded page-cache assumptions in
+			 * several paths.
+			 */
+			struct inode *inode;
+		};
 		struct {		/* slub per cpu partial pages */
 			struct page *next;	/* Next partial slab */
 #ifdef CONFIG_64BIT
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 8a4ebfe9db4e..f9a2929fc310 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -441,13 +441,13 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct page *page = pfn_to_page(pfn);
 
 		/*
-		 * ZONE_DEVICE pages union ->lru with a ->pgmap back
-		 * pointer.  It is a bug if a ZONE_DEVICE page is ever
-		 * freed or placed on a driver-private list.  Seed the
-		 * storage with LIST_POISON* values.
+		 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer
+		 * and ->inode (for the MEMORY_DEVICE_FS_DAX case) association.
+		 * It is a bug if a ZONE_DEVICE page is ever freed or placed on
+		 * a driver-private list.
 		 */
-		list_del(&page->lru);
 		page->pgmap = pgmap;
+		page->inode = NULL;
 		percpu_ref_get(ref);
 		if (!(++i % 1024))
 			cond_resched();

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
