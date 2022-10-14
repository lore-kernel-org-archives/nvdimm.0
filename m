Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCA24694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791856; x=1697327856;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WDhrLpyapWWVzBNALsAavqF2Cp5tBjhlbxEJIcuaLkE=;
  b=QljeuNlZa7vpGFpvWSzpxoTe/iAEBwkS91UubAbdV1Jr6uQyiCQm3T2M
   8RFs/uifnYydzKujoTKuCIzObEyMUkRAkC0uIcN2LmFj8fhwASf9IKS3+
   OmVh4lb30GFxxVH1QY/XdQ1ID7hnu9Ek8HEyukMgoNlG2ZdcLmsbFESNm
   65DNRwGt3fq6j/9vkpQGoPrsZUUAyYqk4MQWbTMtX9sx45N3DQI/qaQDl
   GyDxMkrOc2A0RiHIUAWotVJdhGpf+sJT6C7zduErbn858WRtHnkAlMMTK
   DobhJ+me6HgrraKFnYuu+6kJrj22kkb+z9urKu1OrfuJyWDtiyrz0UJ2h
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="292861962"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="292861962"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="630113254"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="630113254"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:57:31 -0700
Subject: [PATCH v3 06/25] fsdax: Validate DAX layouts broken before truncate
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Darrick J. Wong" <djwong@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, John Hubbard <jhubbard@nvidia.com>,
 Dave Chinner <david@fromorbit.com>, nvdimm@lists.linux.dev,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:57:31 -0700
Message-ID: <166579185112.2236710.17571345510304035858.stgit@dwillia2-xfh.jf.intel.com>
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

Now that iput_final() arranges for dax_break_layouts(), all
truncate_inode_pages() paths in the kernel ensure that no DAX pages
hosted by that inode are in use. Add warnings to assert the new entry
state transitions.

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e3deb60a792f..1d4f0072e58d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -401,13 +401,15 @@ static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 	for_each_mapped_pfn(entry, pfn) {
 		struct page *page = pfn_to_page(pfn);
 
-		WARN_ON_ONCE(trunc && !dax_page_idle(page));
 		if (dax_mapping_is_cow(page->mapping)) {
 			/* keep the CoW flag if this page is still shared */
 			if (page->index-- > 0)
 				continue;
-		} else
+		} else {
+			WARN_ON_ONCE(trunc && !dax_is_zapped(entry));
+			WARN_ON_ONCE(trunc && !dax_page_idle(page));
 			WARN_ON_ONCE(page->mapping && page->mapping != mapping);
+		}
 		page->mapping = NULL;
 		page->index = 0;
 	}

