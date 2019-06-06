Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 572622194D3B8
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jun 2019 11:16:43 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id i8so2843842oth.10
 for <linux-nvdimm@lists.01.org>; Thu, 06 Jun 2019 11:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155977191770.2443951.1506588644989416699.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190606172110.GC31194@linux>
In-Reply-To: <20190606172110.GC31194@linux>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jun 2019 11:16:31 -0700
Message-ID: <CAPcyv4jy-TN9xzWd_tJW0ezbZoXJCQozWwcQcTfJwzTcy2BGMQ@mail.gmail.com>
Subject: Re: [PATCH v9 07/12] mm/sparsemem: Prepare for sub-section ranges
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 6, 2019 at 10:21 AM Oscar Salvador <osalvador@suse.de> wrote:
>
> On Wed, Jun 05, 2019 at 02:58:37PM -0700, Dan Williams wrote:
> > Prepare the memory hot-{add,remove} paths for handling sub-section
> > ranges by plumbing the starting page frame and number of pages being
> > handled through arch_{add,remove}_memory() to
> > sparse_{add,remove}_one_section().
> >
> > This is simply plumbing, small cleanups, and some identifier renames. No
> > intended functional changes.
> >
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Logan Gunthorpe <logang@deltatee.com>
> > Cc: Oscar Salvador <osalvador@suse.de>
> > Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  include/linux/memory_hotplug.h |    5 +-
> >  mm/memory_hotplug.c            |  114 +++++++++++++++++++++++++---------------
> >  mm/sparse.c                    |   15 ++---
> >  3 files changed, 81 insertions(+), 53 deletions(-)
> >
> > diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> > index 79e0add6a597..3ab0282b4fe5 100644
> > --- a/include/linux/memory_hotplug.h
> > +++ b/include/linux/memory_hotplug.h
> > @@ -348,9 +348,10 @@ extern int add_memory_resource(int nid, struct resource *resource);
> >  extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
> >               unsigned long nr_pages, struct vmem_altmap *altmap);
> >  extern bool is_memblock_offlined(struct memory_block *mem);
> > -extern int sparse_add_one_section(int nid, unsigned long start_pfn,
> > -                               struct vmem_altmap *altmap);
> > +extern int sparse_add_section(int nid, unsigned long pfn,
> > +             unsigned long nr_pages, struct vmem_altmap *altmap);
> >  extern void sparse_remove_one_section(struct mem_section *ms,
> > +             unsigned long pfn, unsigned long nr_pages,
> >               unsigned long map_offset, struct vmem_altmap *altmap);
> >  extern struct page *sparse_decode_mem_map(unsigned long coded_mem_map,
> >                                         unsigned long pnum);
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 4b882c57781a..399bf78bccc5 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -252,51 +252,84 @@ void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
> >  }
> >  #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
> >
> > -static int __meminit __add_section(int nid, unsigned long phys_start_pfn,
> > -                                struct vmem_altmap *altmap)
> > +static int __meminit __add_section(int nid, unsigned long pfn,
> > +             unsigned long nr_pages, struct vmem_altmap *altmap)
> >  {
> >       int ret;
> >
> > -     if (pfn_valid(phys_start_pfn))
> > +     if (pfn_valid(pfn))
> >               return -EEXIST;
> >
> > -     ret = sparse_add_one_section(nid, phys_start_pfn, altmap);
> > +     ret = sparse_add_section(nid, pfn, nr_pages, altmap);
> >       return ret < 0 ? ret : 0;
> >  }
> >
> > +static int check_pfn_span(unsigned long pfn, unsigned long nr_pages,
> > +             const char *reason)
> > +{
> > +     /*
> > +      * Disallow all operations smaller than a sub-section and only
> > +      * allow operations smaller than a section for
> > +      * SPARSEMEM_VMEMMAP. Note that check_hotplug_memory_range()
> > +      * enforces a larger memory_block_size_bytes() granularity for
> > +      * memory that will be marked online, so this check should only
> > +      * fire for direct arch_{add,remove}_memory() users outside of
> > +      * add_memory_resource().
> > +      */
> > +     unsigned long min_align;
> > +
> > +     if (IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP))
> > +             min_align = PAGES_PER_SUBSECTION;
> > +     else
> > +             min_align = PAGES_PER_SECTION;
> > +     if (!IS_ALIGNED(pfn, min_align)
> > +                     || !IS_ALIGNED(nr_pages, min_align)) {
> > +             WARN(1, "Misaligned __%s_pages start: %#lx end: #%lx\n",
> > +                             reason, pfn, pfn + nr_pages - 1);
> > +             return -EINVAL;
> > +     }
> > +     return 0;
> > +}
>
>
> This caught my eye.
> Back in patch#4 "Convert kmalloc_section_memmap() to populate_section_memmap()",
> you placed a mis-usage check for !CONFIG_SPARSEMEM_VMEMMAP in
> populate_section_memmap().
>
> populate_section_memmap() gets called from sparse_add_one_section(), which means
> that we should have passed this check, otherwise we cannot go further and call
> __add_section().
>
> So, unless I am missing something it seems to me that the check from patch#4 could go?
> And I think the same applies to depopulate_section_memmap()?

Yes, good catch, I can kill those extra checks in favor of this one.

> Besides that, it looks good to me:

Thanks Oscar!

>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>
> --
> Oscar Salvador
> SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
