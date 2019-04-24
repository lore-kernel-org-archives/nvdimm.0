Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552636696.2015392.12612320706815016081.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3dda9d08-a572-65b9-2f2f-da978a008deb@redhat.com>
In-Reply-To: <3dda9d08-a572-65b9-2f2f-da978a008deb@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Apr 2019 11:07:52 -0700
Message-ID: <CAPcyv4imzm5reh7d-p4Xyt=Sdoi5WDFC6t9FgLaZVexbWfGG5Q@mail.gmail.com>
Subject: Re: [PATCH v6 06/12] mm/hotplug: Add mem-hotplug restrictions for remove_memory()
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Logan Gunthorpe <logang@deltatee.com>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 23, 2019 at 2:21 PM David Hildenbrand <david@redhat.com> wrote:
>
> On 17.04.19 20:39, Dan Williams wrote:
> > Teach the arch_remove_memory() path to consult the same 'struct
> > mhp_restrictions' context as was specified at arch_add_memory() time.
> >
> > No functional change, this is a preparation step for teaching
> > __remove_pages() about how and when to allow sub-section hot-remove, and
> > a cleanup for an unnecessary "is_dev_zone()" special case.
>
> I am not yet sure if this is the right thing to do. When adding memory,
> we obviously have to specify the "how". When removing memory, we usually
> should be able to look such stuff up.

True, the implementation can just use find_memory_block(), and no need
to plumb this flag.

>
>
> >  void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> > -                 unsigned long nr_pages, struct vmem_altmap *altmap)
> > +             unsigned long nr_pages, struct mhp_restrictions *restrictions)
> >  {
> >       unsigned long i;
> > -     unsigned long map_offset = 0;
> >       int sections_to_remove;
> > +     unsigned long map_offset = 0;
> > +     struct vmem_altmap *altmap = restrictions->altmap;
> >
> > -     /* In the ZONE_DEVICE case device driver owns the memory region */
> > -     if (is_dev_zone(zone)) {
> > -             if (altmap)
> > -                     map_offset = vmem_altmap_offset(altmap);
> > -     }
> > +     if (altmap)
> > +             map_offset = vmem_altmap_offset(altmap);
> >
>
> Why weren't we able to use this exact same hunk before? (after my
> resource deletion cleanup of course)
>
> IOW, do we really need struct mhp_restrictions here?

We don't need it. It was only the memblock info why I added the
"restrictions" argument.

> After I factor out memory device handling into the caller of
> arch_remove_memory(), also the next patch ("mm/sparsemem: Prepare for
> sub-section ranges") should no longer need it. Or am I missing something?

That patch is still needed for the places where it adds the @nr_pages
argument, but the mhp_restrictions related bits can be dropped. The
subsection_check() helper needs to be refactored a bit to not rely on
mhp_restrictions.
