Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155677652226.2336373.8700273400832001094.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155677653785.2336373.11131100812252340469.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190502074803.GA3495@linux>
In-Reply-To: <20190502074803.GA3495@linux>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 2 May 2019 07:03:45 -0700
Message-ID: <CAPcyv4jPG56sf4hHaKEoacQbDEpcMrr4fJVEwkxGjcWcCmieNQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] mm/sparsemem: Add helpers track active portions
 of a section at boot
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Jane Chu <jane.chu@oracle.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 2, 2019 at 12:48 AM Oscar Salvador <osalvador@suse.de> wrote:
>
> On Wed, May 01, 2019 at 10:55:37PM -0700, Dan Williams wrote:
> > Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
> > section active bitmask, each bit representing 2MB (SECTION_SIZE (128M) /
> > map_active bitmask length (64)). If it turns out that 2MB is too large
> > of an active tracking granularity it is trivial to increase the size of
> > the map_active bitmap.
> >
> > The implications of a partially populated section is that pfn_valid()
> > needs to go beyond a valid_section() check and read the sub-section
> > active ranges from the bitmask.
> >
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Logan Gunthorpe <logang@deltatee.com>
> > Tested-by: Jane Chu <jane.chu@oracle.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Unfortunately I did not hear back about the comments/questions I made for this
> in the previous version.

Apologies, yes, will incorporate.

>
> > ---
> >  include/linux/mmzone.h |   29 ++++++++++++++++++++++++++++-
> >  mm/page_alloc.c        |    4 +++-
> >  mm/sparse.c            |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 79 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 6726fc175b51..cffde898e345 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1175,6 +1175,8 @@ struct mem_section_usage {
> >       unsigned long pageblock_flags[0];
> >  };
> >
> > +void section_active_init(unsigned long pfn, unsigned long nr_pages);
> > +
> >  struct page;
> >  struct page_ext;
> >  struct mem_section {
> > @@ -1312,12 +1314,36 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> >
> >  extern int __highest_present_section_nr;
> >
> > +static inline int section_active_index(phys_addr_t phys)
> > +{
> > +     return (phys & ~(PA_SECTION_MASK)) / SECTION_ACTIVE_SIZE;
> > +}
> > +
> > +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> > +static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
> > +{
> > +     int idx = section_active_index(PFN_PHYS(pfn));
> > +
> > +     return !!(ms->usage->map_active & (1UL << idx));
>
> section_active_mask() also converts the value to address/size.
> Why do we need to convert the values and we cannot work with pfn/pages instead?
> It should be perfectly possible unless I am missing something.
>
> The only thing required would be to export earlier your:
>
> +#define PAGES_PER_SUB_SECTION (SECTION_ACTIVE_SIZE / PAGE_SIZE)
> +#define PAGE_SUB_SECTION_MASK (~(PAGES_PER_SUB_SECTION-1))
>
> and change section_active_index to:
>
> static inline int section_active_index(unsigned long pfn)
> {
>         return (pfn & ~(PAGE_SECTION_MASK)) / SUB_SECTION_ACTIVE_PAGES;
> }
>
> In this way we do need to shift the values every time and we can work with them
> directly.
> Maybe you made it work this way because a reason I am missing.
>
> > +static unsigned long section_active_mask(unsigned long pfn,
> > +             unsigned long nr_pages)
> > +{
> > +     int idx_start, idx_size;
> > +     phys_addr_t start, size;
> > +
> > +     if (!nr_pages)
> > +             return 0;
> > +
> > +     start = PFN_PHYS(pfn);
> > +     size = PFN_PHYS(min(nr_pages, PAGES_PER_SECTION
> > +                             - (pfn & ~PAGE_SECTION_MASK)));
>
> It seems to me that we already picked the lowest value back in
> section_active_init, so we should be fine if we drop the min() here?
>
> Another thing is why do we need to convert the values to address/size, and we
> cannot work with pfns/pages.
> Unless I am missing something it should be possible.

Right, I believe the physical address conversion was a holdover from a
previous version and these helpers can be cleaned up to be pfn based,
good catch.

>
> > +     size = ALIGN(size, SECTION_ACTIVE_SIZE);
> > +
> > +     idx_start = section_active_index(start);
> > +     idx_size = section_active_index(size);
> > +
> > +     if (idx_size == 0)
> > +             return -1;
>
> Maybe we would be better off converting that -1 into something like "FULL_SECTION",
> or at least dropping a comment there that "-1" means that the section is fully
> populated.

Agreed, I'll add a #define.

Thanks Oscar.
