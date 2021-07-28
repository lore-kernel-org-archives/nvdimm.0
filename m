Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982CB3481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 06:55:23 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id z3so199905plg.8
        for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 23:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P+wqmwDEEv8ieGGKNUi4neXu2kGNBU0p2AXoItaCV8Y=;
        b=TXWROAi9SFMZm0h2WYBVaBQhEp7I7JDgeTYfZ9KqQMNoxyR7MleEYdlgVqHKKrqrDO
         pBpRAI7FO7gtCV+1j5NENvsmVnCzmQ+B+WhkGV0081Jcd/sJsYWSFR3bLMGuXcwRZgOD
         LJ7BK3Jf+T3c16vPR4a2wyHRot5osayb/baEQ2gFljvVImfQwngXGCR/Rq3Wu2cag73k
         xeO3z4NqOdSPdHUMoKD/ibZh0djEvqEVp2xpowcGH853iBREyO6HZ4d6wDKoBHpvRKzF
         982noBC2nAGdIl6AesxEuNMMgUy46JnMeZ6CYBTFvcZM+VRjlEwpGirLbdkRJM/IDlxi
         pamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P+wqmwDEEv8ieGGKNUi4neXu2kGNBU0p2AXoItaCV8Y=;
        b=sNShbDqF0+H5FFFaCs/4EIHIddQgA6wO6vqBFDDf7SvKBROi64hWUWUamrIgoymlVh
         tq1HG0fUEs3s/qxypDKNcvCR2XvElMXj7oi46Rfs8FiiEEmB3M698/EXX/FxGoKZJtph
         Xe0L8KgESOGqPN8C4U4nqt0PDUJXm6bQAWe0qa022pfeDoH13eMQnG/Lngl+aXxpgreN
         QYJgzDL3IynRvsZH8uz3aqckKHFnT01uBBckB8ELK7sZgbev7/m66iYmYm4dSR2F3tqg
         qgZJnEIHiN47lZo5qDEoBpOsNmCImVhaCoB2ayzJqyVWd7xg5YjaY4/CheTlVrH/owHR
         sUDg==
X-Gm-Message-State: AOAM531ixU+n+Szx6Rq9sSjbBLu0Tzm++/0LprWxq9lIO80E4Y9thfbY
	vw18pHwl0wGFQMw7z9H2INUumXdKKqA34iAVh+288w==
X-Google-Smtp-Source: ABdhPJxcqtKUnZE7Sq/P6tCv7lFZwPW/N1pHan+qEq8/4UUbUgToWOVonAnNXpK4eDYgfM73UNhe7Ffos/5hq06k7+c=
X-Received: by 2002:a05:6a00:d53:b029:32a:2db6:1be3 with SMTP id
 n19-20020a056a000d53b029032a2db61be3mr26406300pfv.71.1627455323032; Tue, 27
 Jul 2021 23:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-9-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-9-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jul 2021 23:55:12 -0700
Message-ID: <CAPcyv4jPWSeP3jOKiEy0ko4Yy5SgAFmuD64ABgv=cRxHaQM7ew@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] mm/sparse-vmemmap: populate compound pagemaps
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
> A compound pagemap is a dev_pagemap with @align > PAGE_SIZE and it

Maybe s/compound devmap/compound devmap/ per the other planned usage
of "devmap" in the implementation?

> means that pages are mapped at a given huge page alignment and utilize
> uses compound pages as opposed to order-0 pages.
>
> Take advantage of the fact that most tail pages look the same (except
> the first two) to minimize struct page overhead. Allocate a separate
> page for the vmemmap area which contains the head page and separate for
> the next 64 pages. The rest of the subsections then reuse this tail
> vmemmap page to initialize the rest of the tail pages.
>
> Sections are arch-dependent (e.g. on x86 it's 64M, 128M or 512M) and
> when initializing compound pagemap with big enough @align (e.g. 1G

s/@align/@geometry/?

> PUD) it will cross various sections.

s/will cross various/may cross multiple/

> To be able to reuse tail pages
> across sections belonging to the same gigantic page, fetch the
> @range being mapped (nr_ranges + 1).  If the section being mapped is
> not offset 0 of the @align, then lookup the PFN of the struct page
> address that precedes it and use that to populate the entire
> section.

This sounds like code being read aloud. I would just say something like:

"The vmemmap code needs to consult @pgmap so that multiple sections
that all map the same tail data can refer back to the first copy of
that data for a given gigantic page."

>
> On compound pagemaps with 2M align, this mechanism lets 6 pages be
> saved out of the 8 necessary PFNs necessary to set the subsection's
> 512 struct pages being mapped. On a 1G compound pagemap it saves
> 4094 pages.
>
> Altmap isn't supported yet, given various restrictions in altmap pfn
> allocator, thus fallback to the already in use vmemmap_populate().  It
> is worth noting that altmap for devmap mappings was there to relieve the
> pressure of inordinate amounts of memmap space to map terabytes of pmem.
> With compound pages the motivation for altmaps for pmem gets reduced.

Looks good just some minor comments / typo fixes, and some requests
for a few more helper functions.

>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  Documentation/vm/vmemmap_dedup.rst |  27 +++++-
>  include/linux/mm.h                 |   2 +-
>  mm/memremap.c                      |   1 +
>  mm/sparse-vmemmap.c                | 133 +++++++++++++++++++++++++++--
>  4 files changed, 151 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/vm/vmemmap_dedup.rst b/Documentation/vm/vmemmap_dedup.rst
> index 215ae2ef3bce..42830a667c2a 100644
> --- a/Documentation/vm/vmemmap_dedup.rst
> +++ b/Documentation/vm/vmemmap_dedup.rst
> @@ -2,9 +2,12 @@
>
>  .. _vmemmap_dedup:
>
> -==================================
> -Free some vmemmap pages of HugeTLB
> -==================================
> +=================================================
> +Free some vmemmap pages of HugeTLB and Device DAX

How about "A vmemmap diet for HugeTLB and Device DAX"

...because in the HugeTLB case it is dynamically remapping and freeing
the pages after the fact, while Device-DAX is avoiding the allocation
in the first instance.

> +=================================================
> +
> +HugeTLB
> +=======
>
>  The struct page structures (page structs) are used to describe a physical
>  page frame. By default, there is a one-to-one mapping from a page frame to
> @@ -168,3 +171,21 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
>  (last) level. So this type of HugeTLB page can be optimized only when its
>  size of the struct page structs is greater than 2 pages.
>
> +Device DAX
> +==========
> +
> +The device-dax interface uses the same tail deduplication technique explained
> +in the previous chapter, except when used with the vmemmap in the device (altmap).
> +
> +The differences with HugeTLB are relatively minor.
> +
> +The following page sizes are supported in DAX: PAGE_SIZE (4K on x86_64),
> +PMD_SIZE (2M on x86_64) and PUD_SIZE (1G on x86_64).
> +
> +There's no remapping of vmemmap given that device-dax memory is not part of
> +System RAM ranges initialized at boot, hence the tail deduplication happens
> +at a later stage when we populate the sections.
> +
> +It only use 3 page structs for storing all information as opposed
> +to 4 on HugeTLB pages. This does not affect memory savings between both.
> +
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index f244a9219ce4..5e3e153ddd3d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3090,7 +3090,7 @@ p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
>  pmd_t *vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node);
>  pte_t *vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -                           struct vmem_altmap *altmap);
> +                           struct vmem_altmap *altmap, struct page *block);
>  void *vmemmap_alloc_block(unsigned long size, int node);
>  struct vmem_altmap;
>  void *vmemmap_alloc_block_buf(unsigned long size, int node,
> diff --git a/mm/memremap.c b/mm/memremap.c
> index ffcb924eb6a5..9198fdace903 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -345,6 +345,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid)
>  {
>         struct mhp_params params = {
>                 .altmap = pgmap_altmap(pgmap),
> +               .pgmap = pgmap,
>                 .pgprot = PAGE_KERNEL,
>         };
>         const int nr_range = pgmap->nr_range;
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 76f4158f6301..a8de6c472999 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -495,16 +495,31 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
>  }
>
>  pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
> -                                      struct vmem_altmap *altmap)
> +                                      struct vmem_altmap *altmap,
> +                                      struct page *block)
>  {
>         pte_t *pte = pte_offset_kernel(pmd, addr);
>         if (pte_none(*pte)) {
>                 pte_t entry;
>                 void *p;
>
> -               p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> -               if (!p)
> -                       return NULL;
> +               if (!block) {
> +                       p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
> +                       if (!p)
> +                               return NULL;
> +               } else {
> +                       /*
> +                        * When a PTE/PMD entry is freed from the init_mm
> +                        * there's a a free_pages() call to this page allocated
> +                        * above. Thus this get_page() is paired with the
> +                        * put_page_testzero() on the freeing path.
> +                        * This can only called by certain ZONE_DEVICE path,
> +                        * and through vmemmap_populate_compound_pages() when
> +                        * slab is available.
> +                        */
> +                       get_page(block);
> +                       p = page_to_virt(block);
> +               }
>                 entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
>                 set_pte_at(&init_mm, addr, pte, entry);
>         }
> @@ -571,7 +586,8 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  }
>
>  static int __meminit vmemmap_populate_address(unsigned long addr, int node,
> -                                             struct vmem_altmap *altmap)
> +                                             struct vmem_altmap *altmap,
> +                                             struct page *reuse, struct page **page)
>  {
>         pgd_t *pgd;
>         p4d_t *p4d;
> @@ -591,10 +607,14 @@ static int __meminit vmemmap_populate_address(unsigned long addr, int node,
>         pmd = vmemmap_pmd_populate(pud, addr, node);
>         if (!pmd)
>                 return -ENOMEM;
> -       pte = vmemmap_pte_populate(pmd, addr, node, altmap);
> +       pte = vmemmap_pte_populate(pmd, addr, node, altmap, reuse);
>         if (!pte)
>                 return -ENOMEM;
>         vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
> +
> +       if (page)
> +               *page = pte_page(*pte);
> +       return 0;
>  }
>
>  int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
> @@ -603,7 +623,97 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>         unsigned long addr = start;
>
>         for (; addr < end; addr += PAGE_SIZE) {
> -               if (vmemmap_populate_address(addr, node, altmap))
> +               if (vmemmap_populate_address(addr, node, altmap, NULL, NULL))
> +                       return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static int __meminit vmemmap_populate_range(unsigned long start,
> +                                           unsigned long end,
> +                                           int node, struct page *page)
> +{
> +       unsigned long addr = start;
> +
> +       for (; addr < end; addr += PAGE_SIZE) {
> +               if (vmemmap_populate_address(addr, node, NULL, page, NULL))
> +                       return -ENOMEM;
> +       }
> +
> +       return 0;
> +}
> +
> +static inline int __meminit vmemmap_populate_page(unsigned long addr, int node,
> +                                                 struct page **page)
> +{
> +       return vmemmap_populate_address(addr, node, NULL, NULL, page);
> +}
> +
> +static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
> +                                                    unsigned long start,
> +                                                    unsigned long end, int node,
> +                                                    struct dev_pagemap *pgmap)
> +{
> +       unsigned long offset, size, addr;
> +
> +       /*
> +        * For compound pages bigger than section size (e.g. x86 1G compound
> +        * pages with 2M subsection size) fill the rest of sections as tail
> +        * pages.
> +        *
> +        * Note that memremap_pages() resets @nr_range value and will increment
> +        * it after each range successful onlining. Thus the value or @nr_range
> +        * at section memmap populate corresponds to the in-progress range
> +        * being onlined here.
> +        */
> +       offset = PFN_PHYS(start_pfn) - pgmap->ranges[pgmap->nr_range].start;
> +       if (!IS_ALIGNED(offset, pgmap_geometry(pgmap)) &&
> +           pgmap_geometry(pgmap) > SUBSECTION_SIZE) {

How about moving the last 3 lines plus the comment to a helper so this
becomes something like:

if (compound_section_index(start_pfn, pgmap))

...where it is clear that for the Nth section in a compound page where
N is > 0, it can lookup the page data to reuse.


> +               pte_t *ptep;
> +
> +               addr = start - PAGE_SIZE;
> +
> +               /*
> +                * Sections are populated sequently and in sucession meaning
> +                * this section being populated wouldn't start if the
> +                * preceding one wasn't successful. So there is a guarantee that
> +                * the previous struct pages are mapped when trying to lookup
> +                * the last tail page.

I think you can cut this down to:

"Assuming sections are populated sequentially, the previous section's
page data can be reused."

...and maybe this can be a helper like:

compound_section_tail_page()?


> +                * the last tail page.

> +               ptep = pte_offset_kernel(pmd_off_k(addr), addr);
> +               if (!ptep)
> +                       return -ENOMEM;
> +
> +               /*
> +                * Reuse the page that was populated in the prior iteration
> +                * with just tail struct pages.
> +                */
> +               return vmemmap_populate_range(start, end, node,
> +                                             pte_page(*ptep));
> +       }
> +
> +       size = min(end - start, pgmap_pfn_geometry(pgmap) * sizeof(struct page));
> +       for (addr = start; addr < end; addr += size) {
> +               unsigned long next = addr, last = addr + size;
> +               struct page *block;
> +
> +               /* Populate the head page vmemmap page */
> +               if (vmemmap_populate_page(addr, node, NULL))
> +                       return -ENOMEM;
> +
> +               /* Populate the tail pages vmemmap page */
> +               block = NULL;
> +               next = addr + PAGE_SIZE;
> +               if (vmemmap_populate_page(next, node, &block))
> +                       return -ENOMEM;
> +
> +               /*
> +                * Reuse the previous page for the rest of tail pages
> +                * See layout diagram in Documentation/vm/vmemmap_dedup.rst
> +                */
> +               next += PAGE_SIZE;
> +               if (vmemmap_populate_range(next, last, node, block))
>                         return -ENOMEM;
>         }
>
> @@ -616,12 +726,19 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
>  {
>         unsigned long start = (unsigned long) pfn_to_page(pfn);
>         unsigned long end = start + nr_pages * sizeof(struct page);
> +       unsigned int geometry = pgmap_geometry(pgmap);
> +       int r;
>
>         if (WARN_ON_ONCE(!IS_ALIGNED(pfn, PAGES_PER_SUBSECTION) ||
>                 !IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
>                 return NULL;
>
> -       if (vmemmap_populate(start, end, nid, altmap))
> +       if (geometry > PAGE_SIZE && !altmap)
> +               r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
> +       else
> +               r = vmemmap_populate(start, end, nid, altmap);
> +
> +       if (r < 0)
>                 return NULL;
>
>         return pfn_to_page(pfn);
> --
> 2.17.1
>
