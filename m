Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5939D70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 19:56:04 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so11819705pjb.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 12:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hjw/5hPfcSAnUDtkGO7dLZoRiawjIU1v57wTHZKdYCc=;
        b=t3PfB1msBLB28JyzEIMcKXwRsHMPWdoEN3TENtYZlt2tYrmfA0vJeqRHiG6LEJgYXc
         6U1MlRMdS5sumPb5IGtGvzY9zqiqrCwE88JT7X7eACtneUkCx3IXPgwzLRp20tWezGbV
         3tfofj2uFWoi/9fyyMoVjsrz4WkZtCRozGny3Fs1G98xiCHbsQbCPGzAoEAzhTwFkQdc
         eG4K/g/2vBogT6hHN99sA0UBpTckeriuQ2G3l8nzGbdDZ1a4c+xWHpvbJWhCI2SPFXak
         mb1SI5+oF4QcRdj8tbtXnLi7Q6f1k3GDMiLzEqiIgmM1Eo+lUEeuSbV4S9IZlON/3CZN
         1FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hjw/5hPfcSAnUDtkGO7dLZoRiawjIU1v57wTHZKdYCc=;
        b=GJFMF0GkQhx9Eo0jHm2BoqIc9PmRhtC54QL99Ss1+eNbKoZ0LhybBfFlPqCi3pOmtG
         GG97n0HIEojgbk7wLtRtGNGJ2GSMSEdPxOF4yo+Reb9rHm0sFZaJRw6y6+F86hKGQwhO
         W38SU/J/yRWG/XrbXEMcgHCFqrbx0Zhm86I2feQLYhHn5oAKiFFqgUfqHFPN9COpNeZ/
         H4ZOi0UfpNODUV3yEEuvOIiO52kfA7ePCLXxzNhHbOe3yRzwvqC/7lvGi6B4NfX7c5V2
         rTijbE/C75OawxFFbr4Uj3ai7b3y0K/L/gLP7ueZ3biSaHJW47oC/Q4AGamNXfxLlgrc
         VQtw==
X-Gm-Message-State: AOAM5328iw3NUwAE3t9ShsGxCbC6HXzAVL9V09O8I2FSr/4IYZPPStbk
	r+H6hqlAyCifS/nbKc4y2VTRVFpkdyFauG0F/haHvw==
X-Google-Smtp-Source: ABdhPJwr07MbmYenDrsCXLzA/k3E+4LlKYbMRwTmY0e+U3JwUORF0A3zdz8QcxmndAVjTfm9JaG1BaDYu23LMCTIpkc=
X-Received: by 2002:a17:902:7d91:b029:12b:45b0:736b with SMTP id
 a17-20020a1709027d91b029012b45b0736bmr1123726plm.79.1627502163850; Wed, 28
 Jul 2021 12:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-14-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-14-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 12:55:53 -0700
Message-ID: <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
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

On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> Use try_grab_compound_head() for device-dax GUP when configured with a
> compound pagemap.
>
> Rather than incrementing the refcount for each page, do one atomic
> addition for all the pages to be pinned.
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
>  mm/gup.c | 53 +++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 42b8b1fa6521..9baaa1c0b7f3 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2234,31 +2234,55 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
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
> +               struct page *pinned_head, *head, *page = pfn_to_page(pfn);
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
> +               /* @end is assumed to be limited at most one compound page */
> +               next = PageCompound(head) ? end : addr + PAGE_SIZE;

Please no ternary operator for this check, but otherwise this patch
looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>


> +               refs = record_subpages(page, addr, next, pages + *nr);
> +
> +               SetPageReferenced(head);
> +               pinned_head = try_grab_compound_head(head, refs, flags);
> +               if (!pinned_head) {
> +                       if (PageCompound(head)) {
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
> @@ -2318,17 +2342,6 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long addr,
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
