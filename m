Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990B7E
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257790; x=1693793790;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9CRqNyu89p0LQkhJhRVAoDT4rdt25lVWtdCoNTZjeqE=;
  b=UHXjthaxSFlJP9DprNfBONc8O3bQaFJrJLfMndSe6cZy2buhJDv9728B
   At6GughteJyb9rEdgW9V+n3DE4ElphYwMJhGamhx5dwUbIKIlV6/GfekM
   yowvvt+RYxcrdulo25FBB9ozGr0XtdWq1enadZlNS7U47OPYjFBcwCpxL
   2cS2FasIOXyWXgssrdmGSt+A9oTxWVroyi8WtvLNCXsh1cNOvtJN2zXSc
   P07BnvKxDvd9RYDvQyydgb7vhBSvJen4LLbCSghdCIOMJmS8mksKByevU
   v9ecPZqsPWZP8iE4kKKnhGtiHsxRlI9EEm0HbRd23ID2BGppOGOwxwRRf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="283194019"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="283194019"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="789035742"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:29 -0700
Subject: [PATCH 05/13] fsdax: Cleanup dax_associate_entry()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:29 -0700
Message-ID: <166225778919.2351842.8691837577077340308.stgit@dwillia2-xfh.jf.intel.com>
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

Pass @vmf to drop the separate @vma and @address arguments to
dax_associate_entry(), use the existing DAX flags to convey the @cow
argument, and replace the open-coded ALIGN().

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index d2fb58a7449b..fad1c8a1d913 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -362,7 +362,7 @@ static inline void dax_mapping_set_cow(struct page *page)
  * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address, bool cow)
+				struct vm_fault *vmf, unsigned long flags)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
 	int i = 0;
@@ -370,11 +370,11 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return;
 
-	index = linear_page_index(vma, address & ~(size - 1));
+	index = linear_page_index(vmf->vma, ALIGN(vmf->address, size));
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		if (cow) {
+		if (flags & DAX_COW) {
 			dax_mapping_set_cow(page);
 		} else {
 			WARN_ON_ONCE(page->mapping);
@@ -882,8 +882,7 @@ static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
-				cow);
+		dax_associate_entry(new_entry, mapping, vmf, flags);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or

