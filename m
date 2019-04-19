Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A524211E2EF4
 for <linux-nvdimm@lists.01.org>; Fri, 19 Apr 2019 16:13:52 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s24so5364254otk.13
 for <linux-nvdimm@lists.01.org>; Fri, 19 Apr 2019 16:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
 <001f15a6-26bb-cbab-587f-d897b2dc9094@nvidia.com>
In-Reply-To: <001f15a6-26bb-cbab-587f-d897b2dc9094@nvidia.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 19 Apr 2019 16:13:40 -0700
Message-ID: <CAPcyv4iCg8v2+-qG-p9bruM+CZs3dG-P=q+f5KdKEy3jn4S5OQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] mm/hotplug: Prepare shrink_{zone, pgdat}_span
 for sub-section removal
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
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 19, 2019 at 4:09 PM Ralph Campbell <rcampbell@nvidia.com> wrote:
[..]
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index 8b7415736d21..d5874f9d4043 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -327,10 +327,10 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
> >   {
> >       struct mem_section *ms;
> >
> > -     for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SECTION) {
> > +     for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUB_SECTION) {
> >               ms = __pfn_to_section(start_pfn);
> >
> > -             if (unlikely(!valid_section(ms)))
> > +             if (unlikely(!pfn_valid(start_pfn)))
> >                       continue;
>
> Note that "struct mem_section *ms;" is now set but not used.
> You can remove the definition and initialization of "ms".

Good eye, yes, will clean up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
