Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F551FBF
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257801; x=1693793801;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xVQvjYo1znKhjHAgKaHx9Jqu5HLN8DrX7hpEaKrWHI0=;
  b=ZUZhLybVCfHKu+D2vwBgFxihVHvLHTdr8DSNIk4/P1VwvIdtq61seYN3
   ddp0k4+j/7V3kXmKkeQ3y1bS1VPj6q0+hM5zfKBKt8SvIbA8k6L+JBDja
   2wuCIGinhVIejn5DFbtuAcWWOM3mQ0yQwBSRpuv83LFV8z47gFAp9NMO3
   uR9iAEndycXBdXO5OrqkNDI4ot4Q8eUipBdHCmCrNB0eEkSRCE6d6ZTyv
   9aEaaCzR7tEJXuAA3GbCdEIpZE7Fm1912jPuMudJsABSkGEsv4rqshc/1
   YJjwO8/BQUm8h4zsPJBPdnIdnk28LpVxlpxhcY79qyxehMIu23l2vv0Vd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="360158766"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="360158766"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:41 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="643384601"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:41 -0700
Subject: [PATCH 07/13] fsdax: Manage pgmap references at entry insertion and
 deletion
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:40 -0700
Message-ID: <166225780079.2351842.2977488896744053462.stgit@dwillia2-xfh.jf.intel.com>
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

The percpu_ref in 'struct dev_pagemap' is used to coordinate active
mappings of device-memory with the device-removal / unbind path. It
enables the semantic that initiating device-removal (or
device-driver-unbind) blocks new mapping and DMA attempts, and waits for
mapping revocation or inflight DMA to complete.

Expand the scope of the reference count to pin the DAX device active at
mapping time and not later at the first gup event. With a device
reference being held while any page on that device is mapped the need to
manage pgmap reference counts in the gup code is eliminated. That
cleanup is saved for a follow-on change.

For now, teach dax_insert_entry() and dax_delete_mapping_entry() to take
and drop pgmap references respectively.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c                 |   30 ++++++++++++++++++++++++------
 include/linux/memremap.h |   18 ++++++++++++++----
 mm/memremap.c            |   13 ++++++++-----
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 65d55c5ecdef..b23222b0dae4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -370,14 +370,24 @@ static inline void dax_mapping_set_cow(struct page *page)
  * whether this entry is shared by multiple files.  If so, set the page->mapping
  * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
-static void dax_associate_entry(void *entry, struct address_space *mapping,
-				struct vm_fault *vmf, unsigned long flags)
+static vm_fault_t dax_associate_entry(void *entry,
+				      struct address_space *mapping,
+				      struct vm_fault *vmf, unsigned long flags)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
+	struct dev_pagemap *pgmap;
 	int i = 0;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
+		return 0;
+
+	if (!size)
+		return 0;
+
+	pfn = dax_to_pfn(entry);
+	pgmap = get_dev_pagemap_many(pfn, NULL, PHYS_PFN(size));
+	if (!pgmap)
+		return VM_FAULT_SIGBUS;
 
 	index = linear_page_index(vmf->vma, ALIGN(vmf->address, size));
 	for_each_mapped_pfn(entry, pfn) {
@@ -391,19 +401,27 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 			page->index = index + i++;
 		}
 	}
+
+	return 0;
 }
 
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 		bool trunc)
 {
-	unsigned long pfn;
+	unsigned long size = dax_entry_size(entry), pfn;
+	struct page *page;
 
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
+	if (!size)
+		return;
+
+	page = pfn_to_page(dax_to_pfn(entry));
+	put_dev_pagemap_many(page->pgmap, PHYS_PFN(size));
 
+	for_each_mapped_pfn(entry, pfn) {
+		page = pfn_to_page(pfn);
 		WARN_ON_ONCE(trunc && page_maybe_dma_pinned(page));
 		if (dax_mapping_is_cow(page->mapping)) {
 			/* keep the CoW flag if this page is still shared */
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index c3b4cc84877b..fd57407e7f3d 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -191,8 +191,13 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap);
+struct dev_pagemap *get_dev_pagemap_many(unsigned long pfn,
+					 struct dev_pagemap *pgmap, int refs);
+static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
+						  struct dev_pagemap *pgmap)
+{
+	return get_dev_pagemap_many(pfn, pgmap, 1);
+}
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
@@ -244,10 +249,15 @@ static inline unsigned long memremap_compat_align(void)
 }
 #endif /* CONFIG_ZONE_DEVICE */
 
-static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
+static inline void put_dev_pagemap_many(struct dev_pagemap *pgmap, int refs)
 {
 	if (pgmap)
-		percpu_ref_put(&pgmap->ref);
+		percpu_ref_put_many(&pgmap->ref, refs);
+}
+
+static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
+{
+	put_dev_pagemap_many(pgmap, 1);
 }
 
 #endif /* _LINUX_MEMREMAP_H_ */
diff --git a/mm/memremap.c b/mm/memremap.c
index 433500e955fb..4debe7b211ae 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -430,15 +430,16 @@ void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns)
 }
 
 /**
- * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
+ * get_dev_pagemap_many() - take new live references(s) on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
  * @pgmap: optional known pgmap that already has a reference
+ * @refs: number of references to take
  *
  * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
  * is non-NULL but does not cover @pfn the reference to it will be released.
  */
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+struct dev_pagemap *get_dev_pagemap_many(unsigned long pfn,
+					 struct dev_pagemap *pgmap, int refs)
 {
 	resource_size_t phys = PFN_PHYS(pfn);
 
@@ -454,13 +455,15 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
-	if (pgmap && !percpu_ref_tryget_live(&pgmap->ref))
+	if (pgmap && !percpu_ref_tryget_live_rcu(&pgmap->ref))
 		pgmap = NULL;
+	if (pgmap && refs > 1)
+		percpu_ref_get_many(&pgmap->ref, refs - 1);
 	rcu_read_unlock();
 
 	return pgmap;
 }
-EXPORT_SYMBOL_GPL(get_dev_pagemap);
+EXPORT_SYMBOL_GPL(get_dev_pagemap_many);
 
 void free_zone_device_page(struct page *page)
 {

