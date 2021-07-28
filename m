Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809363481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 16:09:07 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so10821962pjb.0
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 09:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCQLDiGzGaw5khKMcicFqIWA7WbxBFG59Mi4mmTKjP0=;
        b=Zh7MdYG5QgOP64vqrb7lbYeY93i3cwWAvTTjVgdU6ZiR5NgBFW3bdALx6J7uPOQoRb
         6B23hH/qIey5KgUh98nt4YGqo+DWrvTNM+ZaDIEddtjOUPjuJSw2CTBiXfvfiFGFp9i5
         mg7Kcb8eH5gsWTYezGJgQIh5losNkyz74gS7NSLLqEkItB7FaKz+dpKyLfeqwVFWtvds
         GGFjQzbJ9vfYvbLEyiYfwWqVkI86pfpezrWtplwONff5jp66jw9DY2yrdvpLhGwoV6zj
         VHjeU2lt95i22FfdytELXe06fUp59d1EpQgfecz6Z6GEWwwV8xAgqklIozocVIxfS2sm
         4sZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCQLDiGzGaw5khKMcicFqIWA7WbxBFG59Mi4mmTKjP0=;
        b=uPUnzVEF6kWSdFrMz6nCQSs1TtnTMChFs3V7L4mGGe2s5OjStbsV8Ia51uGzSIUC1h
         4Ax+bOX6vm83mXUmDCSetCd3pRRvCvqaU7eQXykTo7sTlqAi6PySJ1sCUdF/xTagw7Lt
         dw7KUH9xTjPrf2HcKDBfGuIFEuJjsz0FyrBSBgBIF7LnWxx3eM1X7m/fAIfSvYcxumKM
         9IYXWfEn29yIMY8rRPQXPkfSwkS3C65yAgm+GTrzCKni3tqYOaggnP1zP9jTEgdXoAjG
         a0Wl6uKJNNlKwyRo9VCqVSUkRlRrbu017jRtqTNkwZl4rcHqFnJpDMpvgyEWBlKzZh+9
         eAKA==
X-Gm-Message-State: AOAM530lRk2hzCcKlbbCdRgP2z2GJ5hmhIwdFckfEQxsSIenzkpBv9Mt
	6HqE4Hlt7zEMz7u7FQsE+iunw+yTV9LjD++uGNoyrg==
X-Google-Smtp-Source: ABdhPJwhvTdmZ49xWIqwGIKOae57+qV07eOtZyDgQmpn/2iflEi2gfPYAwXeBWCiOl/KnWL8UWSxbu19S+E3ldWNuf8=
X-Received: by 2002:a17:902:ab91:b029:12b:8dae:b1ff with SMTP id
 f17-20020a170902ab91b029012b8daeb1ffmr407924plr.52.1627488547209; Wed, 28 Jul
 2021 09:09:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-10-joao.m.martins@oracle.com> <CAPcyv4gDndA612+1BKZcR518K_Rt3Q1gWpqK24KOqvoFp_PNGg@mail.gmail.com>
 <dd8f9a7a-1036-bda9-73a0-a2c6bcad5a56@oracle.com>
In-Reply-To: <dd8f9a7a-1036-bda9-73a0-a2c6bcad5a56@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 09:08:56 -0700
Message-ID: <CAPcyv4iROoeKcVTKpVyUr+hrmKJxj7QnCS5pGPAnhLDvChHXJw@mail.gmail.com>
Subject: Re: [PATCH v3 09/14] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 28, 2021 at 8:56 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 7/28/21 8:28 AM, Dan Williams wrote:
> > On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> +       /*
> >> +        * With compound page geometry and when struct pages are stored in ram
> >> +        * (!altmap) most tail pages are reused. Consequently, the amount of
> >> +        * unique struct pages to initialize is a lot smaller that the total
> >> +        * amount of struct pages being mapped.
> >> +        * See vmemmap_populate_compound_pages().
> >> +        */
> >> +       if (!altmap)
> >> +               nr_pages = min_t(unsigned long, nr_pages,
> >
> > What's the scenario where nr_pages is < 128? Shouldn't alignment
> > already be guaranteed?
> >
> Oh yeah, that's right.
>
> >> +                                2 * (PAGE_SIZE/sizeof(struct page)));
> >
> >
> >> +
> >>         __SetPageHead(page);
> >>
> >>         for (i = 1; i < nr_pages; i++) {
> >> @@ -6657,7 +6669,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
> >>                         continue;
> >>
> >>                 memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> >> -                                    pfns_per_compound);
> >> +                                    altmap, pfns_per_compound);
> >
> > This feels odd, memmap_init_compound() doesn't really care about
> > altmap, what do you think about explicitly calculating the parameters
> > that memmap_init_compound() needs and passing them in?
> >
> > Not a strong requirement to change, but take another look at let me know.
> >
>
> Yeah, memmap_init_compound() indeed doesn't care about @altmap itself -- but a previous
> comment was to abstract this away in memmap_init_compound() given the mix of complexity in
> memmap_init_zone_device() PAGE_SIZE geometry case and the compound case:
>
> https://lore.kernel.org/linux-mm/CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com/
>
> Before this was called @ntails above and I hide that calculation in memmap_init_compound().
>
> But I can move this back to the caller:
>
> memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>         (!altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : pfns_per_compound);
>
> Or with another helper like:
>
> #define compound_nr_pages(__altmap, __nr_pages) \
>                 (!__altmap ? 2 * (PAGE_SIZE/sizeof(struct page))) : __nr_pages);
>
> memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
>                      compound_nr_pages(altmap, pfns_per_compound));

I like the helper, but I'd go further to make it a function with a
comment that it is a paired / mild layering violation with explicit
knowledge of how the sparse_vmemmap() internals handle compound pages
in the presence of an altmap. I.e. if someone later goes to add altmap
support, leave them a breadcrumb that they need to update both
locations.
