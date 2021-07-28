Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60070
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 18:51:56 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so5452475pji.5
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 11:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TOKcmXzEo94iAN3IEev2/GCNTAlz4I4z5cl17b0W5PY=;
        b=YiMzmM0RaHJqrnUo6ndFY64z9GYOX9Kxi2LIYYmmSOK7FC6CXsVPNITK5KA+5xbBe2
         zz2n8UiE/TmE1RUgXES28lDNf3RhjyIk/FFxriWQqU7FRgDEvvdNaqugokIm/wrELyad
         LjWGXnn0vxn/602tWg8na8V60BVEQr0xadYNxG2eGedDirDCDzEB5BoJWHRFI5jIJN/Z
         sqLd4tICVgQPj4xqXtEGwHJqMs6+s01aIGzYUkV9CdYnlf7XAGbNi+Gmbh3ERu0rvP+D
         Lukdri/Ofz3vO7/Dpo12mjMXf0Uy+wpH8ohUO3gHdNLHC0lv7stBTCTqs7qUCmJVC5L2
         cCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TOKcmXzEo94iAN3IEev2/GCNTAlz4I4z5cl17b0W5PY=;
        b=jzizjs3ad7I3W06/yKjhE5E3ZJ+Zl/rF4hZFS4g7fLB2Af9kL0WmQWTEw5TS213yo2
         lUSu+qb5ocyyZwMSlyuqTYlGEyLcG9ke6c92vAXKLfupNc47yPnIJhiB9SYsAqPTij/z
         v2+88J3eL2d52V5JwE4oUCz5AEt/2sMdb89/drNwP3RrEz7V0H6B4jDsrq3SAQgEXpHR
         9tNKRhwyC/0V4Tl7GIYsrrYCJnA6wdFFTbia7d4IrP/7EHEv/Vtwwv26KnFEojYAKXT1
         JBqtUueqChaP06qxH5Ndb63AZbj4zUQrCoTSlCYuOQDXj7vKvhxHG3UovM/kW/aqEZyD
         Nnuw==
X-Gm-Message-State: AOAM530fprZ4tBtPprAMjSajRyByrOXaUaq3oSNt7ibcbpMbORff98B0
	okTNMMcVW4vcvHB6sh8HiQSaRXyroAAJd5HSaGs9kg==
X-Google-Smtp-Source: ABdhPJybqMYUe5zefm7Vr3S+aiJhxjyQpD/pZqJK+Uv2rjIWSl/PZ9O9rmylxXkNzgwZEvWtlaVGtW+9a+r6/aD6/Jo=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr11094772pjk.13.1627498316410;
 Wed, 28 Jul 2021 11:51:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-13-joao.m.martins@oracle.com> <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
 <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com> <CAPcyv4hRQhG+0ika-wbxSFYrpmMJHxxX456qE64PMxDoxS+Fwg@mail.gmail.com>
 <156c4fb8-46c5-d8ae-b953-837b86516ded@oracle.com>
In-Reply-To: <156c4fb8-46c5-d8ae-b953-837b86516ded@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 11:51:45 -0700
Message-ID: <CAPcyv4hmoS8QSfBY6z07w9Ywjdq8WkROFVn3b_1bsE9i9_j3UA@mail.gmail.com>
Subject: Re: [PATCH v3 12/14] device-dax: compound pagemap support
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 28, 2021 at 2:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 7/28/21 12:51 AM, Dan Williams wrote:
> > On Thu, Jul 15, 2021 at 5:01 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> On 7/15/21 12:36 AM, Dan Williams wrote:
> >>> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >> This patch is not the culprit, the flaw is early in the series, specifically the fourth patch.
> >>
> >> It needs this chunk below change on the fourth patch due to the existing elevated page ref
> >> count at zone device memmap init. put_page() called here in memunmap_pages():
> >>
> >> for (i = 0; i < pgmap->nr_ranges; i++)
> >>         for_each_device_pfn(pfn, pgmap, i)
> >>                 put_page(pfn_to_page(pfn));
> >>
> >> ... on a zone_device compound memmap would otherwise always decrease head page refcount by
> >> @geometry pfn amount (leading to the aforementioned splat you reported).
> >>
> >> diff --git a/mm/memremap.c b/mm/memremap.c
> >> index b0e7b8cf3047..79a883af788e 100644
> >> --- a/mm/memremap.c
> >> +++ b/mm/memremap.c
> >> @@ -102,15 +102,15 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
> >>         return (range->start + range_len(range)) >> PAGE_SHIFT;
> >>  }
> >>
> >> -static unsigned long pfn_next(unsigned long pfn)
> >> +static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
> >>  {
> >>         if (pfn % 1024 == 0)
> >>                 cond_resched();
> >> -       return pfn + 1;
> >> +       return pfn + pgmap_pfn_geometry(pgmap);
> >
> > The cond_resched() would need to be fixed up too to something like:
> >
> > if (pfn % (1024 << pgmap_geometry_order(pgmap)))
> >     cond_resched();
> >
> > ...because the goal is to take a break every 1024 iterations, not
> > every 1024 pfns.
> >
>
> Ah, good point.
>
> >>  }
> >>
> >>  #define for_each_device_pfn(pfn, map, i) \
> >> -       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
> >> +       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
> >>
> >>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
> >>  {
> >>
> >> It could also get this hunk below, but it is sort of redundant provided we won't touch
> >> tail page refcount through out the devmap pages lifetime. This setting of tail pages
> >> refcount to zero was in pre-v5.14 series, but it got removed under the assumption it comes
> >> from the page allocator (where tail pages are already zeroed in refcount).
> >
> > Wait, devmap pages never see the page allocator?
> >
> "where tail pages are already zeroed in refcount" this actually meant 'freshly allocated
> pages' and I was referring to commit 7118fc2906e2 ("hugetlb: address ref count racing in
> prep_compound_gigantic_page") that removed set_page_count() because the setting of page
> ref count to zero was redundant.

Ah, maybe include that reference in the changelog?

>
> Albeit devmap pages don't come from page allocator, you know separate zone and these pages
> aren't part of the regular page pools (e.g. accessible via alloc_pages()), as you are
> aware. Unless of course, we reassign them via dax_kmem, but then the way we map the struct
> pages would be regular without any devmap stuff.

Got it. I think with the back reference to that commit (7118fc2906e2)
it resolves my confusion.

>
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 96975edac0a8..469a7aa5cf38 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -6623,6 +6623,7 @@ static void __ref memmap_init_compound(struct page *page, unsigned
> >> long pfn,
> >>                 __init_zone_device_page(page + i, pfn + i, zone_idx,
> >>                                         nid, pgmap);
> >>                 prep_compound_tail(page, i);
> >> +               set_page_count(page + i, 0);
> >
> > Looks good to me and perhaps a for elevated tail page refcount at
> > teardown as a sanity check that the tail pages was never pinned
> > directly?
> >
> Sorry didn't follow completely.
>
> You meant to set tail page refcount back to 1 at teardown if it was kept to 0 (e.g.
> memunmap_pages() after put_page()) or that the refcount is indeed kept to zero after the
> put_page() in memunmap_pages() ?

The latter, i.e. would it be worth it to check that a tail page did
not get accidentally pinned instead of a head page? I'm also ok to
leave out that sanity checking for now.
