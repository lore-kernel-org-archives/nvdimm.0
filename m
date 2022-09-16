Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7CC20EA
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 03:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663299356; x=1694835356;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j5tRXbceFLZcGlHWWzLaIriWLFbXvQfVW7h15WIRvnM=;
  b=cP40VITSej6TQI1/QYC9Yg9/sQHn52hVcedf9FR0sL4miakk+Rfd/jsa
   QxPYv2+DFIyBzP035b48vgz8A8fazzkKIdFk547BDSbaQ7H2em4uSVJYr
   r5mUmPrYXq+0TPg56n0gv+72OIC7Lt/c6sDw72oCoANGZvEFDk6oOO72m
   9v9wrG2EsoxX0gQw0vqhiTL5U/UKZKEBULgAC1eQTi/1Q+LJFN7gs0KZu
   prryLVUQGCM1TMSSWuQcjZI+ebDPTkBCGnOvrjrkn+XOIpQS3Iox7mGVS
   o8w5cpEdvC32VhLXFEtiErlrs9BPS2nu+QuIslY5aV6zgG0UbtUYoGNpb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="285943190"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="285943190"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="648099914"
Received: from colinlix-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.29.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 20:35:56 -0700
Subject: [PATCH v2 08/18] fsdax: Cleanup dax_associate_entry()
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org
Date: Thu, 15 Sep 2022 20:35:56 -0700
Message-ID: <166329935598.2786261.15591591637555586864.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
References: <166329930818.2786261.6086109734008025807.stgit@dwillia2-xfh.jf.intel.com>
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
index 8382aab0d2f7..bd5c6b6e371e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -368,7 +368,7 @@ static inline void dax_mapping_set_cow(struct page *page)
  * FS_DAX_MAPPING_COW, and use page->index as refcount.
  */
 static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address, bool cow)
+				struct vm_fault *vmf, unsigned long flags)
 {
 	unsigned long size = dax_entry_size(entry), pfn, index;
 	int i = 0;
@@ -376,11 +376,11 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
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
@@ -916,8 +916,7 @@ static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
-				cow);
+		dax_associate_entry(new_entry, mapping, vmf, flags);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or

