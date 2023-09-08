Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FAC1C39
	for <nvdimm@lists.linux.dev>; Fri,  8 Sep 2023 21:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/4z8i7AX+PLEbxPYrZo2ykPvlfyQVolxcCS6XSqOafA=; b=kUBiQv47wzBkLCeSQ8vPkDO5VE
	RKZG4q/MFs6Y5TAecQf4xeSZEvDXm784Mf/1sQ58TpUj67mpN1Pl+SqpjHeiuN2Q1X8V4bDi+lLvA
	2atv2vsrrbIPD+anZ3fribWg139FHBcEp1ya4DjW8ZQ0QyEf0zhxamydT0/x5the7nnIgD+mQoiUh
	u6VzT+yfY8FQmd7EXqMpholXhI4r/VWWZhU/ZpoIxEExcPb9WWb5fmkvV6z6CLBCpq5FDiX27Riev
	2UnJ0mkrS5C/EjeJPEKuxky4fyoW/nWhup9OFQ4B3lZSuBjaKQmZNISkVdGOpGnTZxr/FUXe1eFhb
	HWZNQFrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qeii4-002MuE-Ql; Fri, 08 Sep 2023 21:08:12 +0000
Date: Fri, 8 Sep 2023 22:08:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, naoya.horiguchi@nec.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Convert DAX lock/unlock page to lock/unlock folio
Message-ID: <ZPuNPKz4fMfvTe//@casper.infradead.org>
References: <20230908195215.176586-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230908195215.176586-1-jane.chu@oracle.com>

On Fri, Sep 08, 2023 at 01:52:15PM -0600, Jane Chu wrote:

You need to put a From: line at the top of this so that if someone
applies this it shows me as author rather than you.

> The one caller of DAX lock/unlock page already calls compound_head(),
> so use page_folio() instead, then use a folio throughout the DAX code
> to remove uses of page->mapping and page->index.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---

You should say what changed from v1 here.  Also Naoya Horiguchi offered
an Acked-by tag that would be appropriate to include.

>  fs/dax.c            | 24 ++++++++++++------------
>  include/linux/dax.h | 10 +++++-----
>  mm/memory-failure.c | 29 ++++++++++++++++-------------
>  3 files changed, 33 insertions(+), 30 deletions(-)

> +++ b/mm/memory-failure.c
> @@ -1710,20 +1710,23 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>  	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
>  }
>  
> +/*
> + * Only dev_pagemap pages get here, such as fsdax when the filesystem
> + * either do not claim or fails to claim a hwpoison event, or devdax.
> + * The fsdax pages are initialized per base page, and the devdax pages
> + * could be initialized either as base pages, or as compound pages with
> + * vmemmap optimization enabled. Devdax is simplistic in its dealing with
> + * hwpoison, such that, if a subpage of a compound page is poisoned,
> + * simply mark the compound head page is by far sufficient.
> + */
>  static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>  		struct dev_pagemap *pgmap)
>  {
> -	struct page *page = pfn_to_page(pfn);
> +	struct folio *folio = page_folio(pfn_to_page(pfn));

We have a pfn_folio() (which does the same thing, but may not always)

