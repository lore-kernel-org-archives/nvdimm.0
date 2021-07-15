Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A01572
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 19:48:12 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id a6so305410pgw.3
        for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 12:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ipm8QD7K3E5dbp5V+AEYlrbDnPV1RoLwZuoSKWf1+iU=;
        b=V5Nhf2bBzxQ7dJXGqjDI4fyMwQHSwC36VuNizwrQG7HCCIbygTVsNkLV8RRysHPw+O
         K2cs3w9+Aawe6aMNRlxh0bTtCxcQuaMKYYJPrbOaWDl2+Nx+2dh9J2a61abvmopeyezK
         xT6XJE56y51pUxRPiDX17mU6QStyN1s14G/NaxmY5HyVhd2HC4HRVGenqLEaBxo0nnS0
         MW4y9hk15/R6QoUNrPJ9wTdnwT4L0t49j/TslYACjFtcbboi4xhuBHT38d7ZQJW/+EY9
         iwNP/FRspItJAvcnCg4+nLk/iNrqDl6gWGH51Lh9sybG/3tbn+3Ww16RI5aQFGdhFwEC
         Ewcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ipm8QD7K3E5dbp5V+AEYlrbDnPV1RoLwZuoSKWf1+iU=;
        b=leLt6a6K/niFOH0t84afo1OlzzIrDnHDdq5Rzp2NOEwu9slW64mq7FgCIiMQOF5mRK
         kHytcOl8wdUWsiRKaUJAR0i8kJSIIwKrOBOuo3s+h05FgfxVdx7xnB7e1F2VhnM1zom/
         gVKkXYpvKXbqFUfk2UiTu9hBjr1WoTa1Bsto8kYVOmlt/QG+2TSkBsuSsk33k8iUM4hC
         xUsGw/V33nvUmqnhbCq5b5mN73Ssd2e7kRFn1GUMcVgnp8w034XqI2i12KQvGbfzKmz9
         7D6kk6q5iVF/HCdtmuTGVKcC6EVvXtSgOG/gUknIr9tO2XlPjbGFpucF55BKrjyHWXsy
         eekA==
X-Gm-Message-State: AOAM531azGClxPnmVgPURvUwj0f/H78UlqATcyXf5RhcMxsh/xnYfSpb
	ksbvOHKBlmxyrUKj7uFJFX4YBbcgBTScAzY7argmNw==
X-Google-Smtp-Source: ABdhPJyBSmsoLLILXgdjI3Ptnk3RNrpSN7cdW3We0nxVBU5tpdX+mYriTC/pSfbEZ9FWhDgYAw1sIlmascojCZ8h2l4=
X-Received: by 2002:aa7:92d2:0:b029:32d:e0aa:6570 with SMTP id
 k18-20020aa792d20000b029032de0aa6570mr6420477pfa.31.1626378491822; Thu, 15
 Jul 2021 12:48:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-5-joao.m.martins@oracle.com> <CAPcyv4jwd_dzTH1H+cbiKqfK5=Xaa9JY=EVKHhPbjicVZA-URQ@mail.gmail.com>
 <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
In-Reply-To: <d73793a8-7540-c473-0e30-0880341c2baf@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jul 2021 12:48:01 -0700
Message-ID: <CAPcyv4igDypf04H2bK0G3cR=4ZrND2VL4UoSUN5zeLVa_vbfiA@mail.gmail.com>
Subject: Re: [PATCH v3 04/14] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 15, 2021 at 5:52 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
>
>
> On 7/15/21 2:08 AM, Dan Williams wrote:
> > On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> Add a new align property for struct dev_pagemap which specifies that a
> >
> > s/align/@geometry/
> >
> Yeap, updated.
>
> >> pagemap is composed of a set of compound pages of size @align,
> >
> > s/@align/@geometry/
> >
> Yeap, updated.
>
> >> instead of
> >> base pages. When a compound page geometry is requested, all but the first
> >> page are initialised as tail pages instead of order-0 pages.
> >>
> >> For certain ZONE_DEVICE users like device-dax which have a fixed page size,
> >> this creates an opportunity to optimize GUP and GUP-fast walkers, treating
> >> it the same way as THP or hugetlb pages.
> >>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> >> ---
> >>  include/linux/memremap.h | 17 +++++++++++++++++
> >>  mm/memremap.c            |  8 ++++++--
> >>  mm/page_alloc.c          | 34 +++++++++++++++++++++++++++++++++-
> >>  3 files changed, 56 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> >> index 119f130ef8f1..e5ab6d4525c1 100644
> >> --- a/include/linux/memremap.h
> >> +++ b/include/linux/memremap.h
> >> @@ -99,6 +99,10 @@ struct dev_pagemap_ops {
> >>   * @done: completion for @internal_ref
> >>   * @type: memory type: see MEMORY_* in memory_hotplug.h
> >>   * @flags: PGMAP_* flags to specify defailed behavior
> >> + * @geometry: structural definition of how the vmemmap metadata is populated.
> >> + *     A zero or PAGE_SIZE defaults to using base pages as the memmap metadata
> >> + *     representation. A bigger value but also multiple of PAGE_SIZE will set
> >> + *     up compound struct pages representative of the requested geometry size.
> >>   * @ops: method table
> >>   * @owner: an opaque pointer identifying the entity that manages this
> >>   *     instance.  Used by various helpers to make sure that no
> >> @@ -114,6 +118,7 @@ struct dev_pagemap {
> >>         struct completion done;
> >>         enum memory_type type;
> >>         unsigned int flags;
> >> +       unsigned long geometry;
> >>         const struct dev_pagemap_ops *ops;
> >>         void *owner;
> >>         int nr_range;
> >> @@ -130,6 +135,18 @@ static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
> >>         return NULL;
> >>  }
> >>
> >> +static inline unsigned long pgmap_geometry(struct dev_pagemap *pgmap)
> >> +{
> >> +       if (!pgmap || !pgmap->geometry)
> >> +               return PAGE_SIZE;
> >> +       return pgmap->geometry;
> >> +}
> >> +
> >> +static inline unsigned long pgmap_pfn_geometry(struct dev_pagemap *pgmap)
> >> +{
> >> +       return PHYS_PFN(pgmap_geometry(pgmap));
> >> +}
> >
> > Are both needed? Maybe just have ->geometry natively be in nr_pages
> > units directly, because pgmap_pfn_geometry() makes it confusing
> > whether it's a geometry of the pfn or the geometry of the pgmap.
> >
> I use pgmap_geometry() largelly when we manipulate memmap in sparse-vmemmap code, as we
> deal with addresses/offsets/subsection-size. While using pgmap_pfn_geometry for code that
> deals with PFN initialization. For this patch I could remove the confusion.
>
> And actually maybe I can just store the pgmap_geometry() value in bytes locally in
> vmemmap_populate_compound_pages() and we can remove this extra helper.
>
> >> +
> >>  #ifdef CONFIG_ZONE_DEVICE
> >>  bool pfn_zone_device_reserved(unsigned long pfn);
> >>  void *memremap_pages(struct dev_pagemap *pgmap, int nid);
> >> diff --git a/mm/memremap.c b/mm/memremap.c
> >> index 805d761740c4..ffcb924eb6a5 100644
> >> --- a/mm/memremap.c
> >> +++ b/mm/memremap.c
> >> @@ -318,8 +318,12 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
> >>         memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
> >>                                 PHYS_PFN(range->start),
> >>                                 PHYS_PFN(range_len(range)), pgmap);
> >> -       percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
> >> -                       - pfn_first(pgmap, range_id));
> >> +       if (pgmap_geometry(pgmap) > PAGE_SIZE)
> >
> > This would become
> >
> > if (pgmap_geometry(pgmap) > 1)
> >
> >> +               percpu_ref_get_many(pgmap->ref, (pfn_end(pgmap, range_id)
> >> +                       - pfn_first(pgmap, range_id)) / pgmap_pfn_geometry(pgmap));
> >
> > ...and this would be pgmap_geometry()
> >
> >> +       else
> >> +               percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
> >> +                               - pfn_first(pgmap, range_id));
> >>         return 0;
> >>
> Let me adjust accordingly.
>
> >>  err_add_memory:
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 79f3b38afeca..188cb5f8c308 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -6597,6 +6597,31 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> >>         }
> >>  }
> >>
> >> +static void __ref memmap_init_compound(struct page *page, unsigned long pfn,
> >
> > I'd feel better if @page was renamed @head... more below:
> >
> Oh yeah -- definitely more readable.
>
> >> +                                       unsigned long zone_idx, int nid,
> >> +                                       struct dev_pagemap *pgmap,
> >> +                                       unsigned long nr_pages)
> >> +{
> >> +       unsigned int order_align = order_base_2(nr_pages);
> >> +       unsigned long i;
> >> +
> >> +       __SetPageHead(page);
> >> +
> >> +       for (i = 1; i < nr_pages; i++) {
> >
> > The switch of loop styles is jarring. I.e. the switch from
> > memmap_init_zone_device() that is using pfn, end_pfn, and a local
> > 'struct page *' variable to this helper using pfn + i and a mix of
> > helpers (__init_zone_device_page,  prep_compound_tail) that have
> > different expectations of head page + tail_idx and current page.
> >
> > I.e. this reads more obviously correct to me, but maybe I'm just in
> > the wrong headspace:
> >
> >         for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
> >                 struct page *page = pfn_to_page(pfn);
> >
> >                 __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >                 prep_compound_tail(head, pfn - head_pfn);
> >
> Personally -- and I am dubious given I have been staring at this code -- I find that what
> I wrote a little better as it follows more what compound page initialization does. Like
> it's easier for me to read that I am initializing a number of tail pages and a head page
> (for a known geometry size).
>
> Additionally, it's unnecessary (and a tiny ineficient?) to keep doing pfn_to_page(pfn)
> provided ZONE_DEVICE requires SPARSEMEM_VMEMMAP and so your page pointers are all
> contiguous and so for any given PFN we can avoid having deref vmemmap vaddrs back and
> forth. Which is the second reason I pass a page, and iterate over its tails based on a
> head page pointer. But I was at too minds when writing this, so if the there's no added
> inefficiency I can rewrite like the above.

I mainly just don't want 2 different styles between
memmap_init_zone_device() and this helper. So if the argument is that
"it's inefficient to use pfn_to_page() here" then why does the caller
use pfn_to_page()? I won't argue too much for one way or the other,
I'm still biased towards my rewrite, but whatever you pick just make
the style consistent.

>
> >> +               __init_zone_device_page(page + i, pfn + i, zone_idx,
> >> +                                       nid, pgmap);
> >> +               prep_compound_tail(page, i);
> >> +
> >> +               /*
> >> +                * The first and second tail pages need to
> >> +                * initialized first, hence the head page is
> >> +                * prepared last.
> >
> > I'd change this comment to say why rather than restate what can be
> > gleaned from the code. It's actually not clear to me why this order is
> > necessary.
> >
> So the first tail page stores mapcount_ptr and compound order, and the
> second tail page stores pincount_ptr. prep_compound_head() does this:
>
>         set_compound_order(page, order);
>         atomic_set(compound_mapcount_ptr(page), -1);
>         if (hpage_pincount_available(page))
>                 atomic_set(compound_pincount_ptr(page), 0);
>
> So we need those tail pages initialized first prior to initializing the head.
>
> I can expand the comment above to make it clear why we need first and second tail pages.

Thanks!

> >> +                */
> >> +               if (i == 2)
> >> +                       prep_compound_head(page, order_align);
> >> +       }
> >> +}
> >> +
> >>  void __ref memmap_init_zone_device(struct zone *zone,
> >>                                    unsigned long start_pfn,
> >>                                    unsigned long nr_pages,
> >> @@ -6605,6 +6630,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >>         unsigned long pfn, end_pfn = start_pfn + nr_pages;
> >>         struct pglist_data *pgdat = zone->zone_pgdat;
> >>         struct vmem_altmap *altmap = pgmap_altmap(pgmap);
> >> +       unsigned int pfns_per_compound = pgmap_pfn_geometry(pgmap);
> >>         unsigned long zone_idx = zone_idx(zone);
> >>         unsigned long start = jiffies;
> >>         int nid = pgdat->node_id;
> >> @@ -6622,10 +6648,16 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >>                 nr_pages = end_pfn - start_pfn;
> >>         }
> >>
> >> -       for (pfn = start_pfn; pfn < end_pfn; pfn++) {
> >> +       for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
> >>                 struct page *page = pfn_to_page(pfn);
> >>
> >>                 __init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
> >> +
> >> +               if (pfns_per_compound == 1)
> >> +                       continue;
> >> +
> >> +               memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> >> +                                    pfns_per_compound);
> >
> > I otherwise don't see anything broken with this patch, so feel free to include:
> >
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> >
> > ...on the resend with the fixups.
> >
> Thanks.
>
> I will wait whether you still want to retain the tag provided the implied changes
> fixing the failure you reported.

Yeah, tag is still valid.
