Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092353780.979959.9713046515562743194.stgit@dwillia2-desk3.amr.corp.intel.com>
 <70f3559b-2832-67eb-0715-ed9f856f6ed9@redhat.com>
In-Reply-To: <70f3559b-2832-67eb-0715-ed9f856f6ed9@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Jun 2019 09:19:43 -0700
Message-ID: <CAPcyv4jzELzrf-p6ujUwdXN2FRe0WCNhpTziP2-z4-8uBSSp7A@mail.gmail.com>
Subject: Re: [PATCH v10 08/13] mm/sparsemem: Prepare for sub-section ranges
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Oscar Salvador <osalvador@suse.de>, Pavel Tatashin <pasha.tatashin@soleen.com>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 20, 2019 at 3:31 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 19.06.19 07:52, Dan Williams wrote:
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
> >  mm/sparse.c                    |   16 ++----
> >  3 files changed, 81 insertions(+), 54 deletions(-)
[..]
> > @@ -528,31 +556,31 @@ static void __remove_section(struct zone *zone, struct mem_section *ms,
> >   * sure that pages are marked reserved and zones are adjust properly by
> >   * calling offline_pages().
> >   */
> > -void __remove_pages(struct zone *zone, unsigned long phys_start_pfn,
> > +void __remove_pages(struct zone *zone, unsigned long pfn,
> >                   unsigned long nr_pages, struct vmem_altmap *altmap)
> >  {
> > -     unsigned long i;
> >       unsigned long map_offset = 0;
> > -     int sections_to_remove;
> > +     int i, start_sec, end_sec;
>
> As mentioned in v9, use "unsigned long" for start_sec and end_sec please.

Honestly I saw you and Andrew going back and forth about "unsigned
long i" that I thought this would be handled by a follow on patchset
when that debate settled.
