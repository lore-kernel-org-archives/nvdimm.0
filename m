Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B674694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791889; x=1697327889;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b6C7Qe8Q1GJpUot5lHXs4yvkjjX4IgtewPJJUoytmac=;
  b=ZkpXAICss5hHzkbPvITbhzrZBDmhf1DmTWw/5kf6Sl3mKymXhDWiLAFr
   aIKPwOHk1LoePp6AW1D1QOihyEu4LsOZRUU0/udXhNLGCMReKANdWcF06
   dCcWJ5N2aOST86I5Q3FR2z4tVwIZogIwlUerR7pFgEqWqd3F8Nh5NcJX3
   hmbKsjDiGTFIkKZfp7B0+rp4Cwh4WFQw9+eq6ou0BjnmuoXikZak+ZlA3
   kDwwVYtmQNVFitlZOAYqOdPHfJiw0KzkkmyHViRW3tKis7vTXrSzHNtNn
   VRS03lTKCoZU9/CPqKu9z6FH9yolH09O6nnWwAatLRds843Axc3bsdder
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="367523198"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="367523198"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113423"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113423"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:08 -0700
Subject: [PATCH v3 12/25] fsdax: Cleanup dax_associate_entry()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 david@fromorbit.com, nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:07 -0700
Message-ID: <166579188791.2236710.2590200540568819339.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
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
 fs/dax.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 73e510ca5a70..48bc43c0c03c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -406,8 +406,7 @@ static struct dev_pagemap *folio_pgmap(struct folio *folio)
  */
 static vm_fault_t dax_associate_entry(void *entry,
 				      struct address_space *mapping,
-				      struct vm_area_struct *vma,
-				      unsigned long address, bool cow)
+				      struct vm_fault *vmf, unsigned long flags)
 {
 	unsigned long size = dax_entry_size(entry), index;
 	struct folio *folio;
@@ -416,9 +415,9 @@ static vm_fault_t dax_associate_entry(void *entry,
 	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
 		return 0;
 
-	index = linear_page_index(vma, address & ~(size - 1));
+	index = linear_page_index(vmf->vma, ALIGN(vmf->address, size));
 	dax_for_each_folio(entry, folio, i)
-		if (cow) {
+		if (flags & DAX_COW) {
 			dax_mapping_set_cow(folio);
 		} else {
 			WARN_ON_ONCE(folio->mapping);
@@ -992,8 +991,7 @@ static vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
-		ret = dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
-				cow);
+		ret = dax_associate_entry(new_entry, mapping, vmf, flags);
 		if (ret)
 			goto out;
 		/*

