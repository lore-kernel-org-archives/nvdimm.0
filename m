Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BCD70
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 20:03:46 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id c16so4060509plh.7
        for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 13:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ysiezwmUDKNp3rn8Q5rCeBfDu4fXUowOvIaq6qVfJpk=;
        b=HiFP9loVMUO4hRquds0WVPuR1si66/KJQBlD2s/zRa088LCmX170Cp0xZvhpWf0FTR
         N89x2qqyKKLbQ7R8RIKM7bbhweRkk3QnSErta57Qms3EVyyNlRKF0kFTcgvSTcxzBeCF
         KVOnv6J4dQtycBhvuj5XOvRKiOKoUZTsiqKU4hZv/Jmyh2wXdvY2N9uXaCVI6/YIRO8S
         o155amXcVZgG827Fg20Sz/Q4+aeiW17hr1LBqhR0erxgF6mVVkYW4FPAa1bq5jB+lUA5
         HRfH7yPcN5JU+MPplfk1C6F8a41Q1LOxNbHJHL6vafMXAKuPu7GSzotuuFf95n1OyS+F
         IhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ysiezwmUDKNp3rn8Q5rCeBfDu4fXUowOvIaq6qVfJpk=;
        b=ltekNUBU0OJjmJSnjYnah7sZ+LAmEZibEYcxwD+E+Dch4dRRv6NZX6sopMStoUmv1q
         G+qPPH40cyG0/JefmZKERCBEwddx9fxZ19IMZe02W30KpbU4ewJX28QgfYbjpELcjKws
         AL2kF8n+kXQ9OGu06OIDzslADtnhwgOPQl/iERQLbZz4df3N5luemVsGIIzJWGzkCEr9
         sQWK9kMujfzKms5GzeCcI4Tw5wbCvpA6JM9EbhYHNDh2JHthLamWsxZgcsHKa6jlGV29
         e3f8rBUFAn3AZ5T+UtI/fgnjU4kITl9P+YJf1UVOyazKQWpktyNw/Wya1UXf7cAUgUoh
         aydQ==
X-Gm-Message-State: AOAM532RwSywQOHPVri0z7eTi0iedl4yuG49CGcR4sRRUw2kYeZ9LXHC
	eanQT51d4qzDcw5JXG79XWxxrV7ynt3LkYqjhp3WkQ==
X-Google-Smtp-Source: ABdhPJwi3G9UPIvnUOytayOncvGXXGvlBIn9QgvS7o9bcb3fkVRHVqAK9b4va/PEzzOC7XR8pvxTdJZc658a3Uz7f8A=
X-Received: by 2002:a17:90a:1196:: with SMTP id e22mr10963441pja.168.1627502626028;
 Wed, 28 Jul 2021 13:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-15-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-15-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jul 2021 13:03:35 -0700
Message-ID: <CAPcyv4jC9He7tnTnbiracHZ9P9XSWsH4pJMKFip6-nSbsBWyrg@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] mm/sparse-vmemmap: improve memory savings for
 compound pud geometry
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
> Currently, for compound PUD mappings, the implementation consumes 40MB
> per TB but it can be optimized to 16MB per TB with the approach
> detailed below.
>
> Right now basepages are used to populate the PUD tail pages, and it
> picks the address of the previous page of the subsection that precedes
> the memmap being initialized.  This is done when a given memmap
> address isn't aligned to the pgmap @geometry (which is safe to do because
> @ranges are guaranteed to be aligned to @geometry).
>
> For pagemaps with an align which spans various sections, this means
> that PMD pages are unnecessarily allocated for reusing the same tail
> pages.  Effectively, on x86 a PUD can span 8 sections (depending on
> config), and a page is being  allocated a page for the PMD to reuse
> the tail vmemmap across the rest of the PTEs. In short effecitvely the
> PMD cover the tail vmemmap areas all contain the same PFN. So instead
> of doing this way, populate a new PMD on the second section of the
> compound page (tail vmemmap PMD), and then the following sections
> utilize the preceding PMD previously populated which only contain
> tail pages).
>
> After this scheme for an 1GB pagemap aligned area, the first PMD
> (section) would contain head page and 32767 tail pages, where the
> second PMD contains the full 32768 tail pages.  The latter page gets
> its PMD reused across future section mapping of the same pagemap.
>
> Besides fewer pagetable entries allocated, keeping parity with
> hugepages in the directmap (as done by vmemmap_populate_hugepages()),
> this further increases savings per compound page. Rather than
> requiring 8 PMD page allocations only need 2 (plus two base pages
> allocated for head and tail areas for the first PMD). 2M pages still
> require using base pages, though.

This looks good to me now, modulo the tail_page helper discussed
previously. Thanks for the diagram, makes it clearer what's happening.

I don't see any red flags that would prevent a reviewed-by when you
send the next spin.

>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  Documentation/vm/vmemmap_dedup.rst | 109 +++++++++++++++++++++++++++++
>  include/linux/mm.h                 |   3 +-
>  mm/sparse-vmemmap.c                |  74 +++++++++++++++++---
>  3 files changed, 174 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
> index 42830a667c2a..96d9f5f0a497 100644
> --- a/Documentation/vm/vmemmap_dedup.rst
> +++ b/Documentation/vm/vmemmap_dedup.rst
> @@ -189,3 +189,112 @@ at a later stage when we populate the sections.
>  It only use 3 page structs for storing all information as opposed
>  to 4 on HugeTLB pages. This does not affect memory savings between both.
>
> +Additionally, it further extends the tail page deduplication with 1GB
> +device-dax compound pages.
> +
> +E.g.: A 1G device-dax page on x86_64 consists in 4096 page frames, split
> +across 8 PMD page frames, with the first PMD having 2 PTE page frames.
> +In total this represents a total of 40960 bytes per 1GB page.
> +
> +Here is how things look after the previously described tail page deduplication
> +technique.
> +
> +   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
> + +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
> + |           |    |    0     |     |     0     | -------------> |      0      |
> + |           |    +----------+     +-----------+                +-------------+
> + |           |                     |     1     | -------------> |      1      |
> + |           |                     +-----------+                +-------------+
> + |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
> + |           |                     +-----------+                   | | | | | |
> + |           |                     |     3     | ------------------+ | | | | |
> + |           |                     +-----------+                     | | | | |
> + |           |                     |     4     | --------------------+ | | | |
> + |   PMD 0   |                     +-----------+                       | | | |
> + |           |                     |     5     | ----------------------+ | | |
> + |           |                     +-----------+                         | | |
> + |           |                     |     ..    | ------------------------+ | |
> + |           |                     +-----------+                           | |
> + |           |                     |     511   | --------------------------+ |
> + |           |                     +-----------+                             |
> + |           |                                                               |
> + |           |                                                               |
> + |           |                                                               |
> + +-----------+     page frames                                               |
> + +-----------+ -> +----------+ --> +-----------+    mapping to               |
> + |           |    |  1 .. 7  |     |    512    | ----------------------------+
> + |           |    +----------+     +-----------+                             |
> + |           |                     |    ..     | ----------------------------+
> + |           |                     +-----------+                             |
> + |           |                     |    ..     | ----------------------------+
> + |           |                     +-----------+                             |
> + |           |                     |    ..     | ----------------------------+
> + |           |                     +-----------+                             |
> + |           |                     |    ..     | ----------------------------+
> + |    PMD    |                     +-----------+                             |
> + |  1 .. 7   |                     |    ..     | ----------------------------+
> + |           |                     +-----------+                             |
> + |           |                     |    ..     | ----------------------------+
> + |           |                     +-----------+                             |
> + |           |                     |    4095   | ----------------------------+
> + +-----------+                     +-----------+
> +
> +Page frames of PMD 1 through 7 are allocated and mapped to the same PTE page frame
> +that contains stores tail pages. As we can see in the diagram, PMDs 1 through 7
> +all look like the same. Therefore we can map PMD 2 through 7 to PMD 1 page frame.
> +This allows to free 6 vmemmap pages per 1GB page, decreasing the overhead per
> +1GB page from 40960 bytes to 16384 bytes.
> +
> +Here is how things look after PMD tail page deduplication.
> +
> +   device-dax      page frames   struct pages(4096 pages)     page frame(2 pages)
> + +-----------+ -> +----------+ --> +-----------+   mapping to   +-------------+
> + |           |    |    0     |     |     0     | -------------> |      0      |
> + |           |    +----------+     +-----------+                +-------------+
> + |           |                     |     1     | -------------> |      1      |
> + |           |                     +-----------+                +-------------+
> + |           |                     |     2     | ----------------^ ^ ^ ^ ^ ^ ^
> + |           |                     +-----------+                   | | | | | |
> + |           |                     |     3     | ------------------+ | | | | |
> + |           |                     +-----------+                     | | | | |
> + |           |                     |     4     | --------------------+ | | | |
> + |   PMD 0   |                     +-----------+                       | | | |
> + |           |                     |     5     | ----------------------+ | | |
> + |           |                     +-----------+                         | | |
> + |           |                     |     ..    | ------------------------+ | |
> + |           |                     +-----------+                           | |
> + |           |                     |     511   | --------------------------+ |
> + |           |                     +-----------+                             |
> + |           |                                                               |
> + |           |                                                               |
> + |           |                                                               |
> + +-----------+     page frames                                               |
> + +-----------+ -> +----------+ --> +-----------+    mapping to               |
> + |           |    |    1     |     |    512    | ----------------------------+
> + |           |    +----------+     +-----------+                             |
> + |           |     ^ ^ ^ ^ ^ ^     |    ..     | ----------------------------+
> + |           |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    ..     | ----------------------------+
> + |           |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    ..     | ----------------------------+
> + |           |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    ..     | ----------------------------+
> + |   PMD 1   |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    ..     | ----------------------------+
> + |           |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    ..     | ----------------------------+
> + |           |     | | | | | |     +-----------+                             |
> + |           |     | | | | | |     |    4095   | ----------------------------+
> + +-----------+     | | | | | |     +-----------+
> + |   PMD 2   | ----+ | | | | |
> + +-----------+       | | | | |
> + |   PMD 3   | ------+ | | | |
> + +-----------+         | | | |
> + |   PMD 4   | --------+ | | |
> + +-----------+           | | |
> + |   PMD 5   | ----------+ | |
> + +-----------+             | |
> + |   PMD 6   | ------------+ |
> + +-----------+               |
> + |   PMD 7   | --------------+
> + +-----------+
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5e3e153ddd3d..e9dc3e2de7be 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3088,7 +3088,8 @@ struct page * __populate_section_memmap(unsigned long pfn,
>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>  p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> -pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
> +pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
> +                           struct page *block);
>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
>                             struct vmem_altmap *altmap, struct page *block);
>  void *vmemmap_alloc_block(unsigned long size, int node);
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index a8de6c472999..68041ca9a797 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -537,13 +537,22 @@ static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
>         return p;
>  }
>
> -pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
> +pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node,
> +                                      struct page *block)
>  {
>         pmd_t *pmd = pmd_offset(pud, addr);
>         if (pmd_none(*pmd)) {
> -               void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> -               if (!p)
> -                       return NULL;
> +               void *p;
> +
> +               if (!block) {
> +                       p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +                       if (!p)
> +                               return NULL;
> +               } else {
> +                       /* See comment in vmemmap_pte_populate(). */
> +                       get_page(block);
> +                       p = page_to_virt(block);
> +               }
>                 pmd_populate_kernel(&init_mm, pmd, p);
>         }
>         return pmd;
> @@ -585,15 +594,14 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>         return pgd;
>  }
>
> -static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> -                                             struct vmem_altmap *altmap,
> -                                             struct page *reuse, struct page **page)
> +static int __meminit vmemmap_populate_pmd_address(unsigned long addr, int node,
> +                                                 struct vmem_altmap *altmap,
> +                                                 struct page *reuse, pmd_t **ptr)
>  {
>         pgd_t *pgd;
>         p4d_t *p4d;
>         pud_t *pud;
>         pmd_t *pmd;
> -       pte_t *pte;
>
>         pgd = vmemmap_pgd_populate(addr, node);
>         if (!pgd)
> @@ -604,9 +612,24 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>         pud = vmemmap_pud_populate(p4d, addr, node);
>         if (!pud)
>                 return -ENOMEM;
> -       pmd = vmemmap_pmd_populate(pud, addr, node);
> +       pmd = vmemmap_pmd_populate(pud, addr, node, reuse);
>         if (!pmd)
>                 return -ENOMEM;
> +       if (ptr)
> +               *ptr = pmd;
> +       return 0;
> +}
> +
> +static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> +                                             struct vmem_altmap *altmap,
> +                                             struct page *reuse, struct page **page)
> +{
> +       pmd_t *pmd;
> +       pte_t *pte;
> +
> +       if (vmemmap_populate_pmd_address(addr, node, altmap, NULL, &pmd))
> +               return -ENOMEM;
> +
>         pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
>         if (!pte)
>                 return -ENOMEM;
> @@ -650,6 +673,20 @@ static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
>         return vmemmap_populate_address(addr, node, NULL, NULL, page);
>  }
>
> +static int __meminit vmemmap_populate_pmd_range(unsigned long start,
> +                                               unsigned long end,
> +                                               int node, struct page *page)
> +{
> +       unsigned long addr = start;
> +
> +       for (; addr < end; addr += PMD_SIZE) {
> +               if (vmemmap_populate_pmd_address(addr, node, NULL, page, NULL))
> +                       return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
>  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>                                                      unsigned long start,
>                                                      unsigned long end, int node,
> @@ -670,6 +707,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>         offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
>         if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
>             pgmap_geometry(pgmap) > SUBSECTION_SIZE) {
> +               pmd_t *pmdp;
>                 pte_t *ptep;
>
>                 addr = start - PAGE_SIZE;
> @@ -681,11 +719,25 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>                  * the previous struct pages are mapped when trying to lookup
>                  * the last tail page.
>                  */
> -               ptep = pte_offset_kernel(pmd_off_k(addr), addr);
> -               if (!ptep)
> +               pmdp = pmd_off_k(addr);
> +               if (!pmdp)
> +                       return -ENOMEM;
> +
> +               /*
> +                * Reuse the tail pages vmemmap pmd page
> +                * See layout diagram in Documentation/vm/vmemmap_dedup.rst
> +                */
> +               if (offset % pgmap_geometry(pgmap) > PFN_PHYS(PAGES_PER_SECTION))
> +                       return vmemmap_populate_pmd_range(start, end, node,
> +                                                         pmd_page(*pmdp));
> +
> +               /* See comment above when pmd_off_k() is called. */
> +               ptep = pte_offset_kernel(pmdp, addr);
> +               if (pte_none(*ptep))
>                         return -ENOMEM;
>
>                 /*
> +                * Populate the tail pages vmemmap pmd page.
>                  * Reuse the page that was populated in the prior iteration
>                  * with just tail struct pages.
>                  */
> --
> 2.17.1
>
