Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B805A3481
	for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 23:51:54 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id f13so494209plj.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 16:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MWdRDaBfoW5PPzzR7Hq7j4SJL6MRL4DymqLhS8uwcpU=;
        b=uu+mARo/11EfZ3JgX9cseNPjnRu/OEw1UbYrBE+Pe///dniIaeVlWuUP8bC98QGNnk
         zsiIUgi4DOenKBbUoznrHWM1+E9rJ1KFvDcBoEertOz+G0oR7ZBajO2WQDxNc22KHBOM
         hKaIGiBfQxcXhplZULU3i+4U1Dt0IBSTP8RKw2DOGh1IMmoPyMJLDNI+KcLaTNsXmeuq
         Qi4YirUR1wh5crzK59kqnYkdMdlPXa97aq5os5vBUQeMTNNEFXapI5hUF83HQt7+g+Vw
         Pw28mqqfK0euq7E1FrLIZSJLLINgjlDR5oD94hc6/3T8/qR2GPePGqlzV2SkORmKdf/4
         Z4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MWdRDaBfoW5PPzzR7Hq7j4SJL6MRL4DymqLhS8uwcpU=;
        b=M5HFW4zcWNRG30i4LlaCli9h87W1qC5tOKXTGyrJ1Tm7oRRoAPwNy5myokB+rjRPYS
         hjQSFVF4LNqM2QMlAoL3uFfS3Nzo8POmLRgRNxEGYml6QwSXBrrbUEc3kPRau0taUOdC
         X3TsER4a+pzaIIm2jqm/CQ9BZRqMPPEEdWnmlm+q1EupXzX093gs81rzH2QZKWjluiBe
         gbjZ4WUXgDJ4QyiVeuRncDN/DnPdoObP1p7kF/A1LoAmAzBYfOA14C87gkIkJzGU+p17
         +Ux6muSEQkYuqx2Qu+kbX088gkdpsHR/qBnw10IFtkgN6re6WbOC7WyP1+cpfjyjUGuz
         AjvA==
X-Gm-Message-State: AOAM533Sryk1/TOpbKKA1EMoXPbbC0TOWSHzEwas4F4Cw66f2chp6bl2
	lBuR7ooVzHwNq8vB0EwoO0epxX60dQc2BI8XtSnxaA==
X-Google-Smtp-Source: ABdhPJx7m66XqlSlNSIxMIRPDrdT8mKgrEeYJQaSly6V49raVmDKExqC5qQXY0gqPfJK+81APv/4wb6J6saf9VnmR+8=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr25016662pfv.71.1627429914201; Tue, 27
 Jul 2021 16:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-13-joao.m.martins@oracle.com> <CAPcyv4h5c9afuxXy=UhrRr_tTwHB62RODyCKWNFU5TumXHc76A@mail.gmail.com>
 <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com>
In-Reply-To: <f7217b61-c845-eaed-501e-c9e7067a6b87@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jul 2021 16:51:43 -0700
Message-ID: <CAPcyv4hRQhG+0ika-wbxSFYrpmMJHxxX456qE64PMxDoxS+Fwg@mail.gmail.com>
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

On Thu, Jul 15, 2021 at 5:01 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 7/15/21 12:36 AM, Dan Williams wrote:
> > On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> Use the newly added compound pagemap facility which maps the assigned dax
> >> ranges as compound pages at a page size of @align. Currently, this means,
> >> that region/namespace bootstrap would take considerably less, given that
> >> you would initialize considerably less pages.
> >>
> >> On setups with 128G NVDIMMs the initialization with DRAM stored struct
> >> pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
> >> than a 1msec with 1G pages.
> >>
> >> dax devices are created with a fixed @align (huge page size) which is
> >> enforced through as well at mmap() of the device. Faults, consequently
> >> happen too at the specified @align specified at the creation, and those
> >> don't change through out dax device lifetime. MCEs poisons a whole dax
> >> huge page, as well as splits occurring at the configured page size.
> >>
> >
> > Hi Joao,
> >
> > With this patch I'm hitting the following with the 'device-dax' test [1].
> >
> Ugh, I can reproduce it too -- apologies for the oversight.

No worries.

>
> This patch is not the culprit, the flaw is early in the series, specifically the fourth patch.
>
> It needs this chunk below change on the fourth patch due to the existing elevated page ref
> count at zone device memmap init. put_page() called here in memunmap_pages():
>
> for (i = 0; i < pgmap->nr_ranges; i++)
>         for_each_device_pfn(pfn, pgmap, i)
>                 put_page(pfn_to_page(pfn));
>
> ... on a zone_device compound memmap would otherwise always decrease head page refcount by
> @geometry pfn amount (leading to the aforementioned splat you reported).
>
> diff --git a/mm/memremap.c b/mm/memremap.c
> index b0e7b8cf3047..79a883af788e 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -102,15 +102,15 @@ static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
>         return (range->start + range_len(range)) >> PAGE_SHIFT;
>  }
>
> -static unsigned long pfn_next(unsigned long pfn)
> +static unsigned long pfn_next(struct dev_pagemap *pgmap, unsigned long pfn)
>  {
>         if (pfn % 1024 == 0)
>                 cond_resched();
> -       return pfn + 1;
> +       return pfn + pgmap_pfn_geometry(pgmap);

The cond_resched() would need to be fixed up too to something like:

if (pfn % (1024 << pgmap_geometry_order(pgmap)))
    cond_resched();

...because the goal is to take a break every 1024 iterations, not
every 1024 pfns.

>  }
>
>  #define for_each_device_pfn(pfn, map, i) \
> -       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(pfn))
> +       for (pfn = pfn_first(map, i); pfn < pfn_end(map, i); pfn = pfn_next(map, pfn))
>
>  static void dev_pagemap_kill(struct dev_pagemap *pgmap)
>  {
>
> It could also get this hunk below, but it is sort of redundant provided we won't touch
> tail page refcount through out the devmap pages lifetime. This setting of tail pages
> refcount to zero was in pre-v5.14 series, but it got removed under the assumption it comes
> from the page allocator (where tail pages are already zeroed in refcount).

Wait, devmap pages never see the page allocator?

>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 96975edac0a8..469a7aa5cf38 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6623,6 +6623,7 @@ static void __ref memmap_init_compound(struct page *page, unsigned
> long pfn,
>                 __init_zone_device_page(page + i, pfn + i, zone_idx,
>                                         nid, pgmap);
>                 prep_compound_tail(page, i);
> +               set_page_count(page + i, 0);

Looks good to me and perhaps a for elevated tail page refcount at
teardown as a sanity check that the tail pages was never pinned
directly?

>
>                 /*
>                  * The first and second tail pages need to
