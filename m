Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D2E70
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 01:05:46 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id e22so841609pgv.10
        for <nvdimm@lists.linux.dev>; Tue, 01 Jun 2021 18:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dj6Ypj9Mh6dX5Wwhjl2tsupXxG/c9V6GNw07cEPy0U8=;
        b=dRIr40D6m1tlJWtVPwKqj7evZl3eVyjnAnOzE5dZIhTh+4BagCSHPpufnzhTb6HISc
         raPXYfMgpB73k46S6rHEgIBeCpLLF7InlXgtObQ9Rm0tev7aG90w8oc7LI+TH04VhR/3
         xbOF39OlUvPFxHOD5djsM/gF1Sx0H+2+TtzQGittUvFInMWwh0WeEE7t+CQIR6A9MPHp
         6GG6nIvY9ioWNXWML4Yn1HW3INmi2NKQFH4bTb6T2kaAg1wmeedwmBvqsTOe1G7EEIQ0
         vJhW5MJEUiEwipHmKPixm2WVojAXrYfD+3pT8rQHuruzeIoKOyGe2nOwE4AwySd44yMT
         2CxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dj6Ypj9Mh6dX5Wwhjl2tsupXxG/c9V6GNw07cEPy0U8=;
        b=F5bsy4j5W+f05kxyeR0kWD9d57wTeDc+1iOmT/BAtvQMK5n0D5ZfgAeq8LVuMKIBLj
         0rKQJLqD59pcLmJwUh6mX2UP26aOoG8ux9FRMywx+4IE3owYf4cgnZWvHOmiWCBVmmQ2
         0SA9xTgSytHFHX7huBqD67feHfl9eJcnn4YxdTmKceC4TOAV0Kap9r1W4rk61YYYdD/O
         5KbaOEJo8ReOZc/lUCQ6NNH6RxAxa7U8AGxz/sjroFJmcW+QKQ/hjHK0002DindaHU1d
         z4BSgoIL+hGLCFd2zO7yTlPrID3UHwbU4U3SKLq8bjY9/2iFHulaYCU0MdHH6pHFzJBi
         5IFQ==
X-Gm-Message-State: AOAM530+QVwvcB7GXEtSmpHCUb5S1qRY6z6NMeHK7Q61c0Eoa7Y9F9l6
	epkWIYSgYegeVu7+yfC5rcpDrnqfiHlbOBRgbMTixw==
X-Google-Smtp-Source: ABdhPJxiaFfAVthzNGmqLVy7QrYJPcX1QwPYXM1zy5gj+Gc8CtbANGyGEG+JnJ/T92mBn6JK97k2x0ttABA1Whokkr8=
X-Received: by 2002:a63:4653:: with SMTP id v19mr8717030pgk.240.1622595945932;
 Tue, 01 Jun 2021 18:05:45 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210325230938.30752-1-joao.m.martins@oracle.com> <20210325230938.30752-12-joao.m.martins@oracle.com>
In-Reply-To: <20210325230938.30752-12-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Jun 2021 18:05:34 -0700
Message-ID: <CAPcyv4gYkBZ2x_=rOEDD+FsP0vdn4=JF-VrcYmR=TsrADDcb1A@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] mm/gup: grab head page refcount once for group
 of subpages
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 25, 2021 at 4:10 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Much like hugetlbfs or THPs, treat device pagemaps with
> compound pages like the rest of GUP handling of compound pages.
>

How about:

"Use try_grab_compound_head() for device-dax GUP when configured with
a compound pagemap."

> Rather than incrementing the refcount every 4K, we record
> all sub pages and increment by @refs amount *once*.

"Rather than incrementing the refcount for each page, do one atomic
addition for all the pages to be pinned."

>
> Performance measured by gup_benchmark improves considerably
> get_user_pages_fast() and pin_user_pages_fast() with NVDIMMs:
>
>  $ gup_test -f /dev/dax1.0 -m 16384 -r 10 -S [-u,-a] -n 512 -w
> (get_user_pages_fast 2M pages) ~59 ms -> ~6.1 ms
> (pin_user_pages_fast 2M pages) ~87 ms -> ~6.2 ms
> [altmap]
> (get_user_pages_fast 2M pages) ~494 ms -> ~9 ms
> (pin_user_pages_fast 2M pages) ~494 ms -> ~10 ms

Hmm what is altmap representing here? The altmap case does not support
compound geometry, so this last test is comparing pinning this amount
of memory without compound pages where the memmap is in PMEM to the
speed *with* compound pages and the memmap in DRAM?

>
>  $ gup_test -f /dev/dax1.0 -m 129022 -r 10 -S [-u,-a] -n 512 -w
> (get_user_pages_fast 2M pages) ~492 ms -> ~49 ms
> (pin_user_pages_fast 2M pages) ~493 ms -> ~50 ms
> [altmap with -m 127004]
> (get_user_pages_fast 2M pages) ~3.91 sec -> ~70 ms
> (pin_user_pages_fast 2M pages) ~3.97 sec -> ~74 ms
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  mm/gup.c | 52 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 32 insertions(+), 20 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index b3e647c8b7ee..514f12157a0f 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2159,31 +2159,54 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
>  }
>  #endif /* CONFIG_ARCH_HAS_PTE_SPECIAL */
>
> +
> +static int record_subpages(struct page *page, unsigned long addr,
> +                          unsigned long end, struct page **pages)
> +{
> +       int nr;
> +
> +       for (nr = 0; addr != end; addr += PAGE_SIZE)
> +               pages[nr++] = page++;
> +
> +       return nr;
> +}
> +
>  #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>  static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>                              unsigned long end, unsigned int flags,
>                              struct page **pages, int *nr)
>  {
> -       int nr_start = *nr;
> +       int refs, nr_start = *nr;
>         struct dev_pagemap *pgmap = NULL;
>
>         do {
> -               struct page *page = pfn_to_page(pfn);
> +               struct page *head, *page = pfn_to_page(pfn);
> +               unsigned long next;
>
>                 pgmap = get_dev_pagemap(pfn, pgmap);
>                 if (unlikely(!pgmap)) {
>                         undo_dev_pagemap(nr, nr_start, flags, pages);
>                         return 0;
>                 }
> -               SetPageReferenced(page);
> -               pages[*nr] = page;
> -               if (unlikely(!try_grab_page(page, flags))) {
> -                       undo_dev_pagemap(nr, nr_start, flags, pages);
> +
> +               head = compound_head(page);
> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;

This looks a tad messy, and makes assumptions that upper layers are
not sending this routine multiple huge pages to map. next should be
set to the next compound page, not end.

> +               refs = record_subpages(page, addr, next, pages + *nr);
> +
> +               SetPageReferenced(head);
> +               head = try_grab_compound_head(head, refs, flags);
> +               if (!head) {
> +                       if (PageCompound(head)) {

@head is NULL here, I think you wanted to rename the result of
try_grab_compound_head() to something like pinned_head so that you
don't undo the work you did above. However I feel like there's one too
PageCompund() checks.


> +                               ClearPageReferenced(head);
> +                               put_dev_pagemap(pgmap);
> +                       } else {
> +                               undo_dev_pagemap(nr, nr_start, flags, pages);
> +                       }
>                         return 0;
>                 }
> -               (*nr)++;
> -               pfn++;
> -       } while (addr += PAGE_SIZE, addr != end);
> +               *nr += refs;
> +               pfn += refs;
> +       } while (addr += (refs << PAGE_SHIFT), addr != end);
>
>         if (pgmap)
>                 put_dev_pagemap(pgmap);
> @@ -2243,17 +2266,6 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
>  }
>  #endif
>
> -static int record_subpages(struct page *page, unsigned long addr,
> -                          unsigned long end, struct page **pages)
> -{
> -       int nr;
> -
> -       for (nr = 0; addr != end; addr += PAGE_SIZE)
> -               pages[nr++] = page++;
> -
> -       return nr;
> -}
> -
>  #ifdef CONFIG_ARCH_HAS_HUGEPD
>  static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
>                                       unsigned long sz)
> --
> 2.17.1
>
