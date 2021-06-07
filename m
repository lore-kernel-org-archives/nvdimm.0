Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2B429CA
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 19:22:20 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id y12so2764896pgk.6
        for <nvdimm@lists.linux.dev>; Mon, 07 Jun 2021 12:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3zPHda5Eu8IgQ46+81n6D3OdDX3g9IIVYAByx6ZBnig=;
        b=z20QtLbfAJd7oHlum4Qs6HfAHi3umMyRcrkAF3SJsoIkRXJ9mrfpKO59P5AjLICobY
         Q4dZx4bspVgkU+9bUQ25UW3kYxqi6rpWJ/S2G29h1Ktmt5H9WIrkqaSotmXs+GS0WYy9
         XN6zqMHuCOvyr3rr1LGZFtDgOsrMJSaRdsf2ky/jhrHk7VEI3Bh6xzF3IJgRLHMYUMA9
         JMETTNbCj6Z2Iu2fS/p5CwQfNL4e2tKooD56ikL9cvoPGKG+s3FLUV0b626Pff0whYdY
         76FMCxvXo7pVl9Gj9pdqkccbiTaz29W51LbK5OTPU6yQiThZ423ysUqpaE4fqGhnDgi5
         zeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3zPHda5Eu8IgQ46+81n6D3OdDX3g9IIVYAByx6ZBnig=;
        b=U+wz8AKRzNKBfEs/8F97QuzO9J3pnDS3qKVXSGIrFAptR8weg48JxCgBeASBUrByYU
         Jx6n5o2ue4CaTN/kNyQn4/d82S0R+XYiQ8OrYJLQWz7F/jt9glnYh3fHcsFYocV9DZA4
         Is/BfZ93iqpqPC64NbFb9TC/P5a90eODO/CYKuk3MfSPoVpPke98seXwofI4Zzytulb+
         9a3qdtYafE15+QyQUOe4C8un6rqbQTwR8gVh2kIJkemFhulXc620hy/8R1eWdvl207gq
         YTuIL2OkPdnttpt3DYUPg7LoTreg8DLBhpW6XnsEOQPzgfkDECdT8n8Tqjm/z1rjUPoO
         41KQ==
X-Gm-Message-State: AOAM532YQnf3OizZLDqTZA3zPWJF240Ckw2vIcf0qx0BlvQwlQKoY59U
	HzI2gHfJBeEHe6rDhoXVmmBU4614mLe/NgycuZKeug==
X-Google-Smtp-Source: ABdhPJyDlreH5gTdqnxqG9FPdoq4rz6XwMEzycuoWdAIo1/+PmsHE82a8Jp6K9jRevaG0bqKAfcd2W4fboXXweJPkVM=
X-Received: by 2002:a63:4653:: with SMTP id v19mr18851786pgk.240.1623093740178;
 Mon, 07 Jun 2021 12:22:20 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-12-joao.m.martins@oracle.com> <CAPcyv4gYkBZ2x_=rOEDD+FsP0vdn4=JF-VrcYmR=TsrADDcb1A@mail.gmail.com>
 <fdf0cf7e-086e-ba12-0aba-84d4819df6e5@oracle.com>
In-Reply-To: <fdf0cf7e-086e-ba12-0aba-84d4819df6e5@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jun 2021 12:22:08 -0700
Message-ID: <CAPcyv4jwozKLt02aSmQJPA10OO2C-OD09_mcKEWhKoWDPm6mqg@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] mm/gup: grab head page refcount once for group
 of subpages
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 7, 2021 at 8:22 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 6/2/21 2:05 AM, Dan Williams wrote:
> > On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> Much like hugetlbfs or THPs, treat device pagemaps with
> >> compound pages like the rest of GUP handling of compound pages.
> >>
> >
> > How about:
> >
> > "Use try_grab_compound_head() for device-dax GUP when configured with
> > a compound pagemap."
> >
> Yeap, a bit clearer indeed.
>
> >> Rather than incrementing the refcount every 4K, we record
> >> all sub pages and increment by @refs amount *once*.
> >
> > "Rather than incrementing the refcount for each page, do one atomic
> > addition for all the pages to be pinned."
> >
> ACK.
>
> >>
> >> Performance measured by gup_benchmark improves considerably
> >> get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:
> >>
> >>  $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
> >> (get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
> >> (pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
> >> [altmap]
> >> (get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
> >> (pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms
> >
> > Hmm what is altmap representing here? The altmap case does not support
> > compound geometry,
>
> It does support compound geometry and so we use compound pages with altmap case.
> What altmap doesn't support is the memory savings in the vmemmap that can be
> done when using compound pages. That's what is represented here.

Ah, I missed that detail, might be good to mention this in the
Documentation/vm/ overview doc for this capability.

>
> > so this last test is comparing pinning this amount
> > of memory without compound pages where the memmap is in PMEM to the
> > speed *with* compound pages and the memmap in DRAM?
> >
> The test compares pinning this amount of memory with compound pages placed
> in PMEM and in DRAM. It just exposes just how ineficient this can get if huge pages aren't
> represented with compound pages.

Got it.

>
> >>
> >>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
> >> (get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
> >> (pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
> >> [altmap with -m 127004]
> >> (get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
> >> (pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms
> >>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> >> ---
> >>  mm/gup.c | 52 ++++++++++++++++++++++++++++++++--------------------
> >>  1 file changed, 32 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/mm/gup.c b/mm/gup.c
> >> index b3e647c8b7ee..514f12157a0f 100644
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >> @@ -2159,31 +2159,54 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
> >>  }
> >>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
> >>
> >> +
> >> +static int record_subpages(struct page *page, unsigned long addr,
> >> +                          unsigned long end, struct page **pages)
> >> +{
> >> +       int nr;
> >> +
> >> +       for (nr = 0; addr != end; addr += PAGE_SIZE)
> >> +               pages[nr++] = page++;
> >> +
> >> +       return nr;
> >> +}
> >> +
> >>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
> >>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
> >>                              unsigned long end, unsigned int flags,
> >>                              struct page **pages, int *nr)
> >>  {
> >> -       int nr_start = *nr;
> >> +       int refs, nr_start = *nr;
> >>         struct dev_pagemap *pgmap = NULL;
> >>
> >>         do {
> >> -               struct page *page = pfn_to_page(pfn);
> >> +               struct page *head, *page = pfn_to_page(pfn);
> >> +               unsigned long next;
> >>
> >>                 pgmap = get_dev_pagemap(pfn, pgmap);
> >>                 if (unlikely(!pgmap)) {
> >>                         undo_dev_pagemap(nr, nr_start, flags, pages);
> >>                         return 0;
> >>                 }
> >> -               SetPageReferenced(page);
> >> -               pages[*nr] = page;
> >> -               if (unlikely(!try_grab_page(page, flags))) {
> >> -                       undo_dev_pagemap(nr, nr_start, flags, pages);
> >> +
> >> +               head = compound_head(page);
> >> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;
> >
> > This looks a tad messy, and makes assumptions that upper layers are
> > not sending this routine multiple huge pages to map. next should be
> > set to the next compound page, not end.
>
> Although for devmap (and same could be said for hugetlbfs), __gup_device_huge() (as called
> by __gup_device_huge_{pud,pmd}) would only ever be called on a compound page which
> represents the same level, as opposed to many compound pages i.e. @end already represents
> the next compound page of the PMD or PUD level.
>
> But of course, should we represent devmap pages in geometries other than the values of
> hpagesize/align other than PMD or PUD size then it's true that relying on @end value being
> next compound page is fragile. But so as the rest of the surrounding code.

Ok, for now maybe a:

/* @end is assumed to be limited at most 1 compound page */

...would remind whoever refactors this later about the assumption.

>
> >
> >> +               refs = record_subpages(page, addr, next, pages + *nr);
> >> +
> >> +               SetPageReferenced(head);
> >> +               head = try_grab_compound_head(head, refs, flags);
> >> +               if (!head) {
> >> +                       if (PageCompound(head)) {
> >
> > @head is NULL here, I think you wanted to rename the result of
> > try_grab_compound_head() to something like pinned_head so that you
> > don't undo the work you did above.
>
> Yes. pinned_head is what I actually should have written. Let me fix that.
>
> > However I feel like there's one too
> > PageCompund() checks.
> >
>
> I agree, but I am not fully sure how I can remove them :(

If you fix the bug above that's sufficient for me, I may be wishing
for something more pretty but is not possible in practice...

>
> The previous approach was to separate the logic into two distinct helpers namely
> __gup_device_huge() and __gup_device_compound_huge(). But that sort of special casing
> wasn't a good idea, so I tried merging both cases in __gup_device_huge() solely
> differentiating on PageCompound().
>
> I could make this slightly less bad by moving the error case PageCompound checks to
> undo_dev_pagemap() and record_subpages().
>
> But we still have the pagemap refcount to be taken until your other series removes the
> need for it. So perhaps I should place the remaining PageCompound based check inside
> record_subpages to accomodate the PAGE_SIZE geometry case (similarly hinted by Jason in
> the previous version but that I didn't fully address).
>
> How does the above sound?

Sounds worth a try, but not a hard requirement for this to move
forward from my perspective.

>
> longterm once we stop having devmap use non compound struct pages on PMDs/PUDs and the
> pgmap refcount on gup is removed then perhaps we can move to existing regular huge page
> path that is not devmap specific.
>

Ok.
