Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788970
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 05:56:32 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d17so1343959plh.10
        for <nvdimm@lists.linux.dev>; Tue, 27 Jul 2021 22:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Ndwx5sj3OOP7ioabuI7ivmApveSC+sSu/IcifkkjAA=;
        b=ggP6Xbcf3ryMs1h4pgRW6LIfAl1p5Cbyq5RCbN3PPbRSKXZtbEC01etFLpDuAgvtDa
         Q3+G/GL3OJPC1zA2Bou8/OvZaXzaeXWzd/V9XASV4up7wfTCsrwSRdtweX/lf+LvsKu/
         8boDWX5YM9YDwm7vMBfkvTBfwNALbQmTU98X9quV9Kif1bjC+MLikAz5yoAAb+z5w7TB
         Pup6297Rhdik+lRrdNbfnVo87Cy2Sy1FnZ6dc00Ze5JMj5DmJ64JjA+bkOYnK0tcNe1J
         4V7JtUL/edsIb82SjWYvO89XbpA1YhxYJ8jL2E7rUgMjzfQLIrsJy75h/fJ0RHIj5381
         vtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Ndwx5sj3OOP7ioabuI7ivmApveSC+sSu/IcifkkjAA=;
        b=A7yK5/M1kpMl8eiRGLTNLtCSREi2OtWSIFbU3Q6twMNlw/v+BDfhqQtu9s6Sz6iK6R
         Fq+ABzE1J7ttis+ZHjWrv8u3PfVBga5rbzb3HIcuXmC0+dR6XQ8/Op2LSYOtF3gvjn6A
         byO+EAzxiJcb9VJPJhxBmingn2SZ0GznYxdU6KyybSuC+Fa89FWPopGdSPC3i8VAJlp0
         wHA6su2+k4ByqIHLeq7Ayje9VMN6jGyysM3u4hWO7SsJhGRBOCE9UZ/1EPKLrQxaUGVs
         JvFWCDBPL+cDNo3dAOmp0kFKwIzWxyFNNNe6VCTI80F0z+czVbuYZ1W3RBRxBySKpRxy
         z4yA==
X-Gm-Message-State: AOAM533Oc+ZJjfwcS1gAO0D/2L6WIqeCIFgr15vm65zre+n2Q8Lh8pIL
	a2nnnSV+2WSBde9uuINw4q975tma/LyP6cTTr5Oeug==
X-Google-Smtp-Source: ABdhPJyyIr2ZOjpYgVHk5o2dqRUNDP22sIfVcT2Aove8tI1tBaiEBdauPBkzAHXRgeDQXoqLta2MOYasarDKwbDAHa0=
X-Received: by 2002:a17:902:ab91:b029:12b:8dae:b1ff with SMTP id
 f17-20020a170902ab91b029012b8daeb1ffmr21725381plr.52.1627451791951; Tue, 27
 Jul 2021 22:56:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714193542.21857-6-joao.m.martins@oracle.com>
In-Reply-To: <20210714193542.21857-6-joao.m.martins@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 27 Jul 2021 22:56:20 -0700
Message-ID: <CAPcyv4j2TZXUUi3zoJwTZ-gnNpnh4sQPC-gRXmVwNoF4N6qnxA@mail.gmail.com>
Subject: Re: [PATCH v3 05/14] mm/sparse-vmemmap: add a pgmap argument to
 section activation
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
> In support of using compound pages for devmap mappings, plumb the pgmap
> down to the vmemmap_populate implementation. Note that while altmap is
> retrievable from pgmap the memory hotplug code passes altmap without
> pgmap[*], so both need to be independently plumbed.
>
> So in addition to @altmap, pass @pgmap to sparse section populate
> functions namely:
>
>         sparse_add_section
>           section_activate
>             populate_section_memmap
>               __populate_section_memmap
>
> Passing @pgmap allows __populate_section_memmap() to both fetch the
> geometry in which memmap metadata is created for and also to let
> sparse-vmemmap fetch pgmap ranges to co-relate to a given section and pick
> whether to just reuse tail pages from past onlined sections.

Looks good to me, just one quibble below:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> [*] https://lore.kernel.org/linux-mm/20210319092635.6214-1-osalvador@suse.de/
>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  include/linux/memory_hotplug.h |  5 ++++-
>  include/linux/mm.h             |  3 ++-
>  mm/memory_hotplug.c            |  3 ++-
>  mm/sparse-vmemmap.c            |  3 ++-
>  mm/sparse.c                    | 24 +++++++++++++++---------
>  5 files changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index a7fd2c3ccb77..9b1bca80224d 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -14,6 +14,7 @@ struct mem_section;
>  struct memory_block;
>  struct resource;
>  struct vmem_altmap;
> +struct dev_pagemap;
>
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  struct page *pfn_to_online_page(unsigned long pfn);
> @@ -60,6 +61,7 @@ typedef int __bitwise mhp_t;
>  struct mhp_params {
>         struct vmem_altmap *altmap;
>         pgprot_t pgprot;
> +       struct dev_pagemap *pgmap;
>  };
>
>  bool mhp_range_allowed(u64 start, u64 size, bool need_mapping);
> @@ -333,7 +335,8 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
>                                        unsigned long nr_pages);
>  extern bool is_memblock_offlined(struct memory_block *mem);
>  extern int sparse_add_section(int nid, unsigned long pfn,
> -               unsigned long nr_pages, struct vmem_altmap *altmap);
> +               unsigned long nr_pages, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap);
>  extern void sparse_remove_section(struct mem_section *ms,
>                 unsigned long pfn, unsigned long nr_pages,
>                 unsigned long map_offset, struct vmem_altmap *altmap);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7ca22e6e694a..f244a9219ce4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3083,7 +3083,8 @@ int vmemmap_remap_alloc(unsigned long start, unsigned long end,
>
>  void *sparse_buffer_alloc(unsigned long size);
>  struct page * __populate_section_memmap(unsigned long pfn,
> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap);
> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap);
>  pgd_t *vmemmap_pgd_populate(unsigned long addr, int node);
>  p4d_t *vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node);
>  pud_t *vmemmap_pud_populate(p4d_t *p4d, unsigned long addr, int node);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8cb75b26ea4f..c728a8ff38ad 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -268,7 +268,8 @@ int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>                 /* Select all remaining pages up to the next section boundary */
>                 cur_nr_pages = min(end_pfn - pfn,
>                                    SECTION_ALIGN_UP(pfn + 1) - pfn);
> -               err = sparse_add_section(nid, pfn, cur_nr_pages, altmap);
> +               err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
> +                                        params->pgmap);
>                 if (err)
>                         break;
>                 cond_resched();
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index bdce883f9286..80d3ba30d345 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -603,7 +603,8 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
>  }
>
>  struct page * __meminit __populate_section_memmap(unsigned long pfn,
> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
>         unsigned long start = (unsigned long) pfn_to_page(pfn);
>         unsigned long end = start + nr_pages * sizeof(struct page);
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6326cdf36c4f..5310be6171f1 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -453,7 +453,8 @@ static unsigned long __init section_map_size(void)
>  }
>
>  struct page __init *__populate_section_memmap(unsigned long pfn,
> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
>         unsigned long size = section_map_size();
>         struct page *map = sparse_buffer_alloc(size);
> @@ -552,7 +553,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>                         break;
>
>                 map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
> -                               nid, NULL);
> +                               nid, NULL, NULL);
>                 if (!map) {
>                         pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
>                                __func__, nid);
> @@ -657,9 +658,10 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  static struct page * __meminit populate_section_memmap(unsigned long pfn,
> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
> -       return __populate_section_memmap(pfn, nr_pages, nid, altmap);
> +       return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
>  }
>
>  static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> @@ -728,7 +730,8 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
>  }
>  #else
>  struct page * __meminit populate_section_memmap(unsigned long pfn,
> -               unsigned long nr_pages, int nid, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
>         return kvmalloc_node(array_size(sizeof(struct page),
>                                         PAGES_PER_SECTION), GFP_KERNEL, nid);
> @@ -851,7 +854,8 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>  }
>
>  static struct page * __meminit section_activate(int nid, unsigned long pfn,
> -               unsigned long nr_pages, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
>         struct mem_section *ms = __pfn_to_section(pfn);
>         struct mem_section_usage *usage = NULL;
> @@ -883,7 +887,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>         if (nr_pages < PAGES_PER_SECTION && early_section(ms))
>                 return pfn_to_page(pfn);
>
> -       memmap = populate_section_memmap(pfn, nr_pages, nid, altmap);
> +       memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
>         if (!memmap) {
>                 section_deactivate(pfn, nr_pages, altmap);
>                 return ERR_PTR(-ENOMEM);
> @@ -898,6 +902,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>   * @start_pfn: start pfn of the memory range
>   * @nr_pages: number of pfns to add in the section
>   * @altmap: device page map
> + * @pgmap: device page map object that owns the section

Since this patch is touching the kdoc, might as well fix it up
properly for @altmap, and perhaps an alternate note for @pgmap:

@altmap: alternate pfns to allocate the memmap backing store
@pgmap: alternate compound page geometry for devmap mappings


>   *
>   * This is only intended for hotplug.
>   *
> @@ -911,7 +916,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
>   * * -ENOMEM   - Out of memory.
>   */
>  int __meminit sparse_add_section(int nid, unsigned long start_pfn,
> -               unsigned long nr_pages, struct vmem_altmap *altmap)
> +               unsigned long nr_pages, struct vmem_altmap *altmap,
> +               struct dev_pagemap *pgmap)
>  {
>         unsigned long section_nr = pfn_to_section_nr(start_pfn);
>         struct mem_section *ms;
> @@ -922,7 +928,7 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
>         if (ret < 0)
>                 return ret;
>
> -       memmap = section_activate(nid, start_pfn, nr_pages, altmap);
> +       memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
>         if (IS_ERR(memmap))
>                 return PTR_ERR(memmap);
>
> --
> 2.17.1
>
