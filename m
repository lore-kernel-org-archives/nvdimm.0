Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93BD70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:24:09 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id t3so2032821plg.9
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 13:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9pcrUQOK0ZmqOqTRwcQZ4Fm0nSq0tiCm1QRBjNm3tro=;
        b=J+S4QQP/PyH79HmD9fIAGVXiFETZUXfvuFzfIp+BmNK7D9Gz1YlfqXCvWveO6cXfqp
         T3DOmF9hblZFQRw9D+domCU2uFza8nMw15Se0rLm94k4thE85t/EpykZn5gWZKE5KPOG
         nAetGMaqTpxgNDE/KWz0L5ltBIr2jKLYrmkM82A3Syi/RNJWnE2No4WEG2WjR8H4LuVN
         YDFHveJA1jDKIoM0Mtt96fZ4aoEIt9AAKMXe4voimu6wi+1I4vteRiNg3DmNTlb6DSYC
         wHgPbRiwqeZruwxEiCyca1v+9XtCg/L2J4WwOLX5ZtTob8pJnUhJnbdJTVCOndHehmCg
         7tzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9pcrUQOK0ZmqOqTRwcQZ4Fm0nSq0tiCm1QRBjNm3tro=;
        b=dTDJQhvALyEv65nr+7tAIo4B0+RCOvt8Qz4NuCPXZZHS0V17HnH/fVxBzf+is+OlwH
         81IzCqxWiX/5GKKgnu0emcVgR8daugTQnivJZoBjZUSTLC4QletrTwrJ0TzPa1Emiuwy
         ju/2Jrt0VlCf9n1+FPxbg2/jJktFjk9yOJ6iQlw8EBkIBDyAJQ84L/vsdTAxLDNP9GzY
         bnEopwsafpeOY0p9+iK8rgpfFnvdJk6/chcMQ+E82fQ1l+DGgWwE4hAdtJ+UScONd+hY
         zmpVsbiCZEeg3IhKeOfnA9kFcHPKOK62d/e/lCRCVtE5hiCkletzpqOFIce2uX/w4LA3
         1/cg==
X-Gm-Message-State: AOAM532uePjTZxSnf5zncQSXM7qKt7unCh+LzB1KNTerjUC+iCbWfs3L
	a6H/dBUgSmrwbmYPNUzmB7ylVSxF8OM0A0KxNxAOhw==
X-Google-Smtp-Source: ABdhPJw0kVYiruKkVSXPrE01BQRySnSH3Xo2ykgaqqFpjUi0JbTpRumeXHbnQMdCqZ0SVMXsqj2Xr20vdHXDeLWFxJg=
X-Received: by 2002:a17:90b:3b47:: with SMTP id ot7mr10851017pjb.149.1627503849125;
 Wed, 28 Jul 2021 13:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-14-joao.m.martins@oracle.com> <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
 <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
In-Reply-To: <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 13:23:58 -0700
Message-ID: <CAPcyv4gkxysWT60P_A+Q18K=Zc9i5P6u69tD5g9_aLV=TW1gpA@mail.gmail.com>
Subject: Re: [PATCH v3 13/14] mm/gup: grab head page refcount once for group
 of subpages
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 28, 2021 at 1:08 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
>
>
> On 7/28/21 8:55 PM, Dan Williams wrote:
> > On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> Use try_grab_compound_head() for device-dax GUP when configured with a
> >> compound pagemap.
> >>
> >> Rather than incrementing the refcount for each page, do one atomic
> >> addition for all the pages to be pinned.
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
> >>  mm/gup.c | 53 +++++++++++++++++++++++++++++++++--------------------
> >>  1 file changed, 33 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/mm/gup.c b/mm/gup.c
> >> index 42b8b1fa6521..9baaa1c0b7f3 100644
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >> @@ -2234,31 +2234,55 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
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
> >> +               struct page *pinned_head, *head, *page = pfn_to_page(pfn);
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
> >> +               /* @end is assumed to be limited at most one compound page */
> >> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;
> >
> > Please no ternary operator for this check, but otherwise this patch
> > looks good to me.
> >
> OK. I take that you prefer this instead:
>
> unsigned long next = addr + PAGE_SIZE;
>
> [...]
>
> /* @end is assumed to be limited at most one compound page */
> if (PageCompound(head))
>         next = end;

Yup.
