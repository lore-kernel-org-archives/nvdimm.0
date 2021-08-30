Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500863FC1
	for <nvdimm@lists.linux.dev>; Mon, 30 Aug 2021 13:07:44 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id 4so1403952qvp.3
        for <nvdimm@lists.linux.dev>; Mon, 30 Aug 2021 06:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1qnygVIdbO5qF5LsQbT9hI/Ok2qT9hqw4DyjZOskK38=;
        b=FCbsWnp1YMdAAs88hVebCbV+bCns5Qdb54WRn1kBoOvfwzfzSYGllmcv2DaVXBUGrI
         biw7fjnU8dNz9qKs3ofhsuUdDhf4gGecWEpgv10rtdqNCC7NPCan0ag12uLILA3uv9Fl
         fX0YQZ2JcmSufsB1g80pckdiEbo8/wZnrbP8BbDziymWYLQ3fOUE4ZnjLs5NcZ+0d17K
         iSRlJ3Is1H/85BygstMwNJTywr4UlawNJPo9wpKRj3iVwFhu4dMYpCrVtmpDZ2psxdfb
         lwKdvNMD850i7auhmlR5sIu+zbhpuWIzHkUXgM1FUBWa7cs1mtmF+05dWg/lVzgo+IJe
         P3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1qnygVIdbO5qF5LsQbT9hI/Ok2qT9hqw4DyjZOskK38=;
        b=YeBpjVihKXt4pJiPHeKX93FypOlXlUZCwuus6vv+iOixf9KDH/oRTkLE3jhyNbAdek
         sk+k2mz8dkqwKHxdV+kt6KnnJe/+sg4s6Xi2PHQn+gBd9oHeoRQl3jbk5b8p4DAZiBBa
         P3KM+WjD27yMh4yul1/ujnhaUisxpIUYRcjWn6oRyztTLRZos0qXzft9mDFW8EQD4TgM
         9mgjsO1EkD2u7JAMnmb3JvgzJFiAaIK1/uakUToW5yxVkjhTUfa/D4RmegritpQTPoxg
         YUxocrkgRNoMsnOYCFUWqSr6B9/TUpC1hxH3pcOV54Z0vu0paz+KoZWFN23MmsaWT6pX
         7uWw==
X-Gm-Message-State: AOAM530CekBobScitBkmXuz4W4n4QzMV9sKJmt2fVP9RL4YjdnfEotA2
	2J+SLuXcGYaUShjFkHbLj8DoIg==
X-Google-Smtp-Source: ABdhPJyJOTt2clWfHDjZgw7CKauIEY9N24woeOtrgL67oYkMzCrstsgj0LDvTSCcn/YsRwfBoO1BSw==
X-Received: by 2002:a05:6214:250f:: with SMTP id gf15mr23180471qvb.2.1630328863099;
        Mon, 30 Aug 2021 06:07:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id c4sm9235157qkf.122.2021.08.30.06.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 06:07:42 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mKh0n-007CHr-Ea; Mon, 30 Aug 2021 10:07:41 -0300
Date: Mon, 30 Aug 2021 10:07:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <20210830130741.GO1200268@ziepe.ca>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20210827162552.GK1200268@ziepe.ca>
 <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da90638d-d97f-bacb-f0fa-01f5fd9f2504@oracle.com>

On Fri, Aug 27, 2021 at 07:34:54PM +0100, Joao Martins wrote:
> On 8/27/21 5:25 PM, Jason Gunthorpe wrote:
> > On Fri, Aug 27, 2021 at 03:58:13PM +0100, Joao Martins wrote:
> > 
> >>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> >>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
> >>  			     unsigned long end, unsigned int flags,
> >>  			     struct page **pages, int *nr)
> >>  {
> >> -	int nr_start = *nr;
> >> +	int refs, nr_start = *nr;
> >>  	struct dev_pagemap *pgmap = NULL;
> >>  	int ret = 1;
> >>  
> >>  	do {
> >> -		struct page *page = pfn_to_page(pfn);
> >> +		struct page *head, *page = pfn_to_page(pfn);
> >> +		unsigned long next = addr + PAGE_SIZE;
> >>  
> >>  		pgmap = get_dev_pagemap(pfn, pgmap);
> >>  		if (unlikely(!pgmap)) {
> >> @@ -2252,16 +2265,25 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
> >>  			ret = 0;
> >>  			break;
> >>  		}
> >> -		SetPageReferenced(page);
> >> -		pages[*nr] = page;
> >> -		if (unlikely(!try_grab_page(page, flags))) {
> >> -			undo_dev_pagemap(nr, nr_start, flags, pages);
> >> +
> >> +		head = compound_head(page);
> >> +		/* @end is assumed to be limited at most one compound page */
> >> +		if (PageHead(head))
> >> +			next = end;
> >> +		refs = record_subpages(page, addr, next, pages + *nr);
> >> +
> >> +		SetPageReferenced(head);
> >> +		if (unlikely(!try_grab_compound_head(head, refs, flags))) {
> >> +			if (PageHead(head))
> >> +				ClearPageReferenced(head);
> >> +			else
> >> +				undo_dev_pagemap(nr, nr_start, flags, pages);
> >>  			ret = 0;
> >>  			break;
> > 
> > Why is this special cased for devmap?
> > 
> > Shouldn't everything processing pud/pmds/etc use the same basic loop
> > that is similar in idea to the 'for_each_compound_head' scheme in
> > unpin_user_pages_dirty_lock()?
> > 
> > Doesn't that work for all the special page type cases here?
> 
> We are iterating over PFNs to create an array of base pages (regardless of page table
> type), rather than iterating over an array of pages to work on. 

That is part of it, yes, but the slow bit here is to minimally find
the head pages and do the atomics on them, much like the
unpin_user_pages_dirty_lock()

I would think this should be designed similar to how things work on
the unpin side.

Sweep the page tables to find a proper start/end - eg even if a
compound is spread across multiple pte/pmd/pud/etc we should find a
linear range of starting PFN (ie starting page*) and npages across as
much of the page tables as we can manage. This is the same as where
things end up in the unpin case where all the contiguous PFNs are
grouped togeher into a range.

Then 'assign' that range to the output array which requires walking
over each compount_head in the range and pinning it, then writing out
the tail pages to the output struct page array.

And this approach should apply universally no matter what is under the
pte's - ie huge pages, THPs and devmaps should all be treated the same
way. Currently each case is different, like above which is unique to
device_huge.

The more we can process groups of pages in bulks the faster the whole
thing will be.

Jason





Given that all these gup
> functions already give you the boundary (end of pmd or end of pud, etc) then we just need
> to grab the ref to pgmap and head page and save the tails. But sadly we need to handle the
> base page case which is why there's this outer loop exists sadly. If it was just head
> pages we wouldn't need the outer loop (and hence no for_each_compound_head, like the
> hugetlb variant).
> 
> But maybe I am being dense and you just mean to replace the outer loop with
> for_each_compound_range(). I am a little stuck on the part that I anyways need to record
> back the tail pages when iterating over the (single) head page. So I feel that it wouldn't
> bring that much improvement, unless I missed your point.
> 
> 	Joao
> 
