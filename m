Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155977188458.2443951.9573565800736334460.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190618014223.GD18161@richard>
In-Reply-To: <20190618014223.GD18161@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Jun 2019 20:40:36 -0700
Message-ID: <CAPcyv4gXzNgghUq337foa3ywB0R4g1e1atnXX-=KJCjCacv0TA@mail.gmail.com>
Subject: Re: [PATCH v9 03/12] mm/hotplug: Prepare shrink_{zone, pgdat}_span
 for sub-section removal
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 6:42 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> On Wed, Jun 05, 2019 at 02:58:04PM -0700, Dan Williams wrote:
> >Sub-section hotplug support reduces the unit of operation of hotplug
> >from section-sized-units (PAGES_PER_SECTION) to sub-section-sized units
> >(PAGES_PER_SUBSECTION). Teach shrink_{zone,pgdat}_span() to consider
> >PAGES_PER_SUBSECTION boundaries as the points where pfn_valid(), not
> >valid_section(), can toggle.
> >
> >Cc: Michal Hocko <mhocko@suse.com>
> >Cc: Vlastimil Babka <vbabka@suse.cz>
> >Cc: Logan Gunthorpe <logang@deltatee.com>
> >Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> >Reviewed-by: Oscar Salvador <osalvador@suse.de>
> >Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >---
> > mm/memory_hotplug.c |   29 ++++++++---------------------
> > 1 file changed, 8 insertions(+), 21 deletions(-)
> >
> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> >index 7b963c2d3a0d..647859a1d119 100644
> >--- a/mm/memory_hotplug.c
> >+++ b/mm/memory_hotplug.c
> >@@ -318,12 +318,8 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
> >                                    unsigned long start_pfn,
> >                                    unsigned long end_pfn)
> > {
> >-      struct mem_section *ms;
> >-
> >-      for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SECTION) {
> >-              ms = __pfn_to_section(start_pfn);
> >-
> >-              if (unlikely(!valid_section(ms)))
> >+      for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
> >+              if (unlikely(!pfn_valid(start_pfn)))
> >                       continue;
>
> Hmm, we change the granularity of valid section from SECTION to SUBSECTION.
> But we didn't change the granularity of node id and zone information.
>
> For example, we found the node id of a pfn mismatch, we can skip the whole
> section instead of a subsection.
>
> Maybe this is not a big deal.

I don't see a problem.
