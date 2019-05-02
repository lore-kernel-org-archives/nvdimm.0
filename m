Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552634075.2015392.3371070426600230054.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190501232517.crbmgcuk7u4gvujr@soleen.tm1wkky2jk1uhgkn0ivaxijq1c.bx.internal.cloudapp.net>
In-Reply-To: <20190501232517.crbmgcuk7u4gvujr@soleen.tm1wkky2jk1uhgkn0ivaxijq1c.bx.internal.cloudapp.net>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 1 May 2019 23:07:21 -0700
Message-ID: <CAPcyv4hxy86gWN3ncTQmHi8DT31k8YzsweMfGHgCh=sORMQQcg@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] mm/sparsemem: Introduce struct mem_section_usage
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 1, 2019 at 4:25 PM Pavel Tatashin <pasha.tatashin@soleen.com> wrote:
>
> On 19-04-17 11:39:00, Dan Williams wrote:
> > Towards enabling memory hotplug to track partial population of a
> > section, introduce 'struct mem_section_usage'.
> >
> > A pointer to a 'struct mem_section_usage' instance replaces the existing
> > pointer to a 'pageblock_flags' bitmap. Effectively it adds one more
> > 'unsigned long' beyond the 'pageblock_flags' (usemap) allocation to
> > house a new 'map_active' bitmap.  The new bitmap enables the memory
> > hot{plug,remove} implementation to act on incremental sub-divisions of a
> > section.
> >
> > The primary motivation for this functionality is to support platforms
> > that mix "System RAM" and "Persistent Memory" within a single section,
> > or multiple PMEM ranges with different mapping lifetimes within a single
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
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  include/linux/mmzone.h |   23 ++++++++++++--
> >  mm/memory_hotplug.c    |   18 ++++++-----
> >  mm/page_alloc.c        |    2 +
> >  mm/sparse.c            |   81 ++++++++++++++++++++++++------------------------
> >  4 files changed, 71 insertions(+), 53 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 70394cabaf4e..f0bbd85dc19a 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1160,6 +1160,19 @@ static inline unsigned long section_nr_to_pfn(unsigned long sec)
> >  #define SECTION_ALIGN_UP(pfn)        (((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
> >  #define SECTION_ALIGN_DOWN(pfn)      ((pfn) & PAGE_SECTION_MASK)
> >
> > +#define SECTION_ACTIVE_SIZE ((1UL << SECTION_SIZE_BITS) / BITS_PER_LONG)
> > +#define SECTION_ACTIVE_MASK (~(SECTION_ACTIVE_SIZE - 1))
> > +
> > +struct mem_section_usage {
> > +     /*
> > +      * SECTION_ACTIVE_SIZE portions of the section that are populated in
> > +      * the memmap
> > +      */
> > +     unsigned long map_active;
>
> I think this should be proportional to section_size / subsection_size.
> For example, on intel section size = 128M, and subsection is 2M, so
> 64bits work nicely. But, on arm64 section size if 1G, so subsection is
> 16M.
>
> On the other hand 16M is already much better than what we have: with 1G
> section size and 2M pmem alignment we guaranteed to loose 1022M. And
> with 16M subsection it is only 14M.

I'm ok with it being 16M for now unless it causes a problem in
practice, i.e. something like the minimum hardware mapping alignment
for physical memory being less than 16M.
