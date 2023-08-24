Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE95511CAF
	for <nvdimm@lists.linux.dev>; Thu, 24 Aug 2023 19:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bxGSQaQnVA4hIwzA12Yd9pYCiIRpb/YVzNA3UfqZ3hg=; b=fo/4IZfo/s2ZjVVoMkNBK+jCmd
	sohdweDvkbRvFwOkHj2mSpIyPqS2IfLRUW7AOI6cCtxCvLx6JCyVEz8hoZipWan0bnTluISZbggBG
	9YMmcSAHimXr1ziKb80KiiEcebgQOQq4XAWYCOCj3U+WDxDdPwHWjQvAFYFXvA5qFtYBrY/Oj2Yvr
	SoVKpgNAM1D5UaHVQoeqmpGx9OH0zDqqw2BecykHqKRlqkhvJyGGD9TT7VFYHdxcWJxUDVSpBFD5P
	UMVObnEugNUC2G0LXfmOJeZKZ4HvKYm35oNrJnQfo7dRbQuAPCfx7aFILNqikUdkhxgjAY6wQpzcN
	W+v7Pt4w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1qZFho-00CaIa-P1; Thu, 24 Aug 2023 19:09:20 +0000
Date: Thu, 24 Aug 2023 20:09:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: Convert DAX lock/unlock page to lock/unlock folio
Message-ID: <ZOeq4HJwCULHPtaU@casper.infradead.org>
References: <20230822231314.349200-1-willy@infradead.org>
 <df52b1f7-7645-b9cd-4cea-d3e08897c297@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df52b1f7-7645-b9cd-4cea-d3e08897c297@oracle.com>

On Thu, Aug 24, 2023 at 11:24:20AM -0700, Jane Chu wrote:
> 
> On 8/22/2023 4:13 PM, Matthew Wilcox (Oracle) wrote:
> [..]
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index a6c3af985554..b81d6eb4e6ff 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -1717,16 +1717,11 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
> >   		struct dev_pagemap *pgmap)
> >   {
> >   	struct page *page = pfn_to_page(pfn);
> 
> Looks like the above line, that is, the 'page' pointer is no longer needed.

So ...

It seems to me that currently handling of hwpoison for DAX memory is
handled on a per-allocation basis but it should probably be handled
on a per-page basis eventually?

If so, we'd want to do something like this ...

+++ b/mm/memory-failure.c
@@ -1755,7 +1755,9 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
         * Use this flag as an indication that the dax page has been
         * remapped UC to prevent speculative consumption of poison.
         */
-       SetPageHWPoison(&folio->page);
+       SetPageHWPoison(page);
+       if (folio_test_large(folio))
+               folio_set_has_hwpoisoned(folio);

        /*
         * Unlike System-RAM there is no possibility to swap in a
@@ -1766,7 +1768,8 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
        flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
        collect_procs(&folio->page, &to_kill, true);

-       unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
+       unmap_and_kill(&to_kill, pfn, folio->mapping,
+                       folio->index + folio_page_idx(folio, page), flags);
 unlock:
        dax_unlock_folio(folio, cookie);
        return rc;

But this is a change in current behaviour and I didn't want to think
through the implications of all of this.  Would you like to take on this
project?  ;-)


My vague plan for hwpoison in the memdesc world is that poison is always
handled on a per-page basis (by means of setting page->memdesc to a
hwpoison data structure).  If the allocation contains multiple pages,
then we set a flag somewhere like the current has_hwpoisoned flag.
