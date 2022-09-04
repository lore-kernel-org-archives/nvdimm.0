Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF321FBF
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257831; x=1693793831;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pmXSmi9LguX30LS/sFbhN9mBClDXZExgw2W8d8OhiMU=;
  b=nmqO8q1vr1nfFuD47qmt3eDwoZhfSlO8JKFrOqX7ScHyP47LHi5407yG
   CKQCfz8VI/duj0JVl46Aqbg4e64/2P7QkFZetGzDQ4gJWb7DIfSMIk3eo
   D0vZQYc1OgvWpn+hZ6yFFo2U5yNO9arSzGGNuAhJv1EvVPPoy8JBiyAyb
   1XlBf7vRALzteeUnIDkqP1QumNUnXjUzthWOKXufuLt/V+XJsgugtS29B
   anIeghZ4uIogXZPAekGJFfD+tT8l4P8XSR6hpyWnlZBbY8uwh88hMkXO5
   lDo9YV6GUvNRGocD7cNSS1c1EW2kdeH27LbaLiH7WW4SvkYSZRd/VKMPg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="296207748"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="296207748"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:17:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="590497071"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:17:10 -0700
Subject: [PATCH 12/13] devdax: Use dax_insert_entry() +
 dax_delete_mapping_entry()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:17:09 -0700
Message-ID: <166225782976.2351842.16939728802182084191.stgit@dwillia2-xfh.jf.intel.com>
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

Track entries and take pgmap references at mapping insertion time.
Revoke mappings and drop the associated pgmap references at device
destruction or inode eviction time. With this in place, and the fsdax
equivalent already in place, the gup code no longer needs to consider
PTE_DEVMAP as an indicator to get a pgmap reference before taking a page
reference.

In other words, GUP takes additional references on mapped pages. Until
now, DAX in all its forms was failing to take references at mapping
time. With that fixed there is no longer a requirement for the gup to
manage @pgmap references. That cleanup is saved for a follow-on patch.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c     |    2 +
 drivers/dax/device.c  |   73 +++++++++++++++++++++++++++++--------------------
 drivers/dax/mapping.c |    3 ++
 3 files changed, 47 insertions(+), 31 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..f4dd9b8b88a9 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -384,7 +384,7 @@ void kill_dev_dax(struct dev_dax *dev_dax)
 	struct inode *inode = dax_inode(dax_dev);
 
 	kill_dax(dax_dev);
-	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+	truncate_inode_pages(inode->i_mapping, 0);
 
 	/*
 	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 5494d745ced5..7f306939807e 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -73,38 +73,15 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 	return -1;
 }
 
-static void dax_set_mapping(struct vm_fault *vmf, pfn_t pfn,
-			      unsigned long fault_size)
-{
-	unsigned long i, nr_pages = fault_size / PAGE_SIZE;
-	struct file *filp = vmf->vma->vm_file;
-	struct dev_dax *dev_dax = filp->private_data;
-	pgoff_t pgoff;
-
-	/* mapping is only set on the head */
-	if (dev_dax->pgmap->vmemmap_shift)
-		nr_pages = 1;
-
-	pgoff = linear_page_index(vmf->vma,
-			ALIGN(vmf->address, fault_size));
-
-	for (i = 0; i < nr_pages; i++) {
-		struct page *page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
-
-		page = compound_head(page);
-		if (page->mapping)
-			continue;
-
-		page->mapping = filp->f_mapping;
-		page->index = pgoff + i;
-	}
-}
-
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
@@ -128,7 +105,16 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, 0);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, 0);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
 }
@@ -136,10 +122,14 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
@@ -171,7 +161,16 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PMD_ORDER);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PMD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -180,10 +179,14 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 				struct vm_fault *vmf)
 {
+	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pud_addr = vmf->address & PUD_MASK;
+	XA_STATE(xas, &mapping->i_pages, vmf->pgoff);
 	struct device *dev = &dev_dax->dev;
 	phys_addr_t phys;
+	vm_fault_t ret;
 	pgoff_t pgoff;
+	void *entry;
 	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
@@ -216,7 +219,16 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 
 	pfn = phys_to_pfn_t(phys, PFN_DEV|PFN_MAP);
 
-	dax_set_mapping(vmf, pfn, fault_size);
+	entry = dax_grab_mapping_entry(&xas, mapping, PUD_ORDER);
+	if (xa_is_internal(entry))
+		return xa_to_internal(entry);
+
+	ret = dax_insert_entry(&xas, vmf, &entry, pfn, DAX_PUD);
+
+	dax_unlock_entry(&xas, entry);
+
+	if (ret)
+		return ret;
 
 	return vmf_insert_pfn_pud(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
 }
@@ -494,3 +506,4 @@ MODULE_LICENSE("GPL v2");
 module_init(dax_init);
 module_exit(dax_exit);
 MODULE_ALIAS_DAX_DEVICE(0);
+MODULE_IMPORT_NS(DAX);
diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index 6eaa0fe33c16..b9851cfd4cbd 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -261,6 +261,7 @@ void dax_unlock_entry(struct xa_state *xas, void *entry)
 	WARN_ON(!dax_is_locked(old));
 	dax_wake_entry(xas, entry, WAKE_NEXT);
 }
+EXPORT_SYMBOL_NS_GPL(dax_unlock_entry, DAX);
 
 /*
  * Return: The entry stored at this location before it was locked.
@@ -674,6 +675,7 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 	xas_unlock_irq(xas);
 	return xa_mk_internal(VM_FAULT_FALLBACK);
 }
+EXPORT_SYMBOL_NS_GPL(dax_grab_mapping_entry, DAX);
 
 /**
  * dax_layout_pinned_page_range - find first pinned page in @mapping
@@ -875,6 +877,7 @@ vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 	*pentry = entry;
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(dax_insert_entry, DAX);
 
 int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 		      struct address_space *mapping, void *entry)

