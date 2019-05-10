Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155718596657.130019.17139634728875079809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155718597192.130019.7128788290111464258.stgit@dwillia2-desk3.amr.corp.intel.com>
 <dd7b53bd986d79a94ac0b08e32336e44@suse.de>
In-Reply-To: <dd7b53bd986d79a94ac0b08e32336e44@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 May 2019 12:38:43 -0700
Message-ID: <CAPcyv4i1zQb-D-8iB3hr8ipMHH2yV8ssxh+Zeh2aeMw0ZJASfg@mail.gmail.com>
Subject: Re: [PATCH v8 01/12] mm/sparsemem: Introduce struct mem_section_usage
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, owner-linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 10, 2019 at 6:30 AM <osalvador@suse.de> wrote:
>
> On 2019-05-07 01:39, Dan Williams wrote:
> > Towards enabling memory hotplug to track partial population of a
> > section, introduce 'struct mem_section_usage'.
> >
> > A pointer to a 'struct mem_section_usage' instance replaces the
> > existing
> > pointer to a 'pageblock_flags' bitmap. Effectively it adds one more
> > 'unsigned long' beyond the 'pageblock_flags' (usemap) allocation to
> > house a new 'subsection_map' bitmap.  The new bitmap enables the memory
> > hot{plug,remove} implementation to act on incremental sub-divisions of
> > a
> > section.
> >
> > The default SUBSECTION_SHIFT is chosen to keep the 'subsection_map' no
> > larger than a single 'unsigned long' on the major architectures.
> > Alternatively an architecture can define ARCH_SUBSECTION_SHIFT to
> > override the default PMD_SHIFT. Note that PowerPC needs to use
> > ARCH_SUBSECTION_SHIFT to workaround PMD_SHIFT being a non-constant
> > expression on PowerPC.
> >
> > The primary motivation for this functionality is to support platforms
> > that mix "System RAM" and "Persistent Memory" within a single section,
> > or multiple PMEM ranges with different mapping lifetimes within a
> > single
> > section. The section restriction for hotplug has caused an ongoing saga
> > of hacks and bugs for devm_memremap_pages() users.
> >
> > Beyond the fixups to teach existing paths how to retrieve the 'usemap'
> > from a section, and updates to usemap allocation path, there are no
> > expected behavior changes.
> >
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Logan Gunthorpe <logang@deltatee.com>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Michael Ellerman <mpe@ellerman.id.au>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  arch/powerpc/include/asm/sparsemem.h |    3 +
> >  include/linux/mmzone.h               |   48 +++++++++++++++++++-
> >  mm/memory_hotplug.c                  |   18 ++++----
> >  mm/page_alloc.c                      |    2 -
> >  mm/sparse.c                          |   81
> > +++++++++++++++++-----------------
> >  5 files changed, 99 insertions(+), 53 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/sparsemem.h
> > b/arch/powerpc/include/asm/sparsemem.h
> > index 3192d454a733..1aa3c9303bf8 100644
> > --- a/arch/powerpc/include/asm/sparsemem.h
> > +++ b/arch/powerpc/include/asm/sparsemem.h
> > @@ -10,6 +10,9 @@
> >   */
> >  #define SECTION_SIZE_BITS       24
> >
> > +/* Reflect the largest possible PMD-size as the subsection-size
> > constant */
> > +#define ARCH_SUBSECTION_SHIFT 24
> > +
>
> I guess this is done because PMD_SHIFT is defined at runtime rather at
> compile time,
> right?

Correct, PowerPC has:

    #define PMD_SHIFT (PAGE_SHIFT + PTE_INDEX_SIZE)
    #define PTE_INDEX_SIZE  __pte_index_size

...where __pte_index_size is variable established at kernel init time.

> >  #endif /* CONFIG_SPARSEMEM */
> >
> >  #ifdef CONFIG_MEMORY_HOTPLUG
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 70394cabaf4e..ef8d878079f9 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1160,6 +1160,44 @@ static inline unsigned long
> > section_nr_to_pfn(unsigned long sec)
> >  #define SECTION_ALIGN_UP(pfn)        (((pfn) + PAGES_PER_SECTION - 1) &
> > PAGE_SECTION_MASK)
> >  #define SECTION_ALIGN_DOWN(pfn)      ((pfn) & PAGE_SECTION_MASK)
> >
> > +/*
> > + * SUBSECTION_SHIFT must be constant since it is used to declare
> > + * subsection_map and related bitmaps without triggering the
> > generation
> > + * of variable-length arrays. The most natural size for a subsection
> > is
> > + * a PMD-page. For architectures that do not have a constant PMD-size
> > + * ARCH_SUBSECTION_SHIFT can be set to a constant max size, or
> > otherwise
> > + * fallback to 2MB.
> > + */
> > +#if defined(ARCH_SUBSECTION_SHIFT)
> > +#define SUBSECTION_SHIFT (ARCH_SUBSECTION_SHIFT)
> > +#elif defined(PMD_SHIFT)
> > +#define SUBSECTION_SHIFT (PMD_SHIFT)
> > +#else
> > +/*
> > + * Memory hotplug enabled platforms avoid this default because they
> > + * either define ARCH_SUBSECTION_SHIFT, or PMD_SHIFT is a constant,
> > but
> > + * this is kept as a backstop to allow compilation on
> > + * !ARCH_ENABLE_MEMORY_HOTPLUG archs.
> > + */
> > +#define SUBSECTION_SHIFT 21
> > +#endif
> > +
> > +#define PFN_SUBSECTION_SHIFT (SUBSECTION_SHIFT - PAGE_SHIFT)
> > +#define PAGES_PER_SUBSECTION (1UL << PFN_SUBSECTION_SHIFT)
> > +#define PAGE_SUBSECTION_MASK ((~(PAGES_PER_SUBSECTION-1)))
> > +
> > +#if SUBSECTION_SHIFT > SECTION_SIZE_BITS
> > +#error Subsection size exceeds section size
> > +#else
> > +#define SUBSECTIONS_PER_SECTION (1UL << (SECTION_SIZE_BITS -
> > SUBSECTION_SHIFT))
> > +#endif
>
> On powerpc, SUBSECTIONS_PER_SECTION will equal 1 (so one big section),
> is that to be expected?

Yes, it turns out that PowerPC has no real need for subsection support
since they were already using small 16MB sections from day one.

> Will subsection_map_init handle this right?

Yes, should work as subsection_map_index() will always return 0. Which
means that 'end' will always be 0:

    pfns = min(nr_pages, PAGES_PER_SECTION
        - (pfn & ~PAGE_SECTION_MASK));
    end = subsection_map_index(pfn + pfns - 1);

...and then the bitmap manipulation:

    bitmap_set(ms->usage->subsection_map, idx, end - idx + 1);

...will only ever set bit0.
