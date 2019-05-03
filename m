Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552634586.2015392.2662168839054356692.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+CK2bCkqLc82G2MW+rYrKTi4KafC+tLCASkaT8zRfVJCCe8HQ@mail.gmail.com>
 <CAPcyv4g+KNu=upejy7Xm=jWR0cdhygPAdSRbkfFGpJeHFGc4+w@mail.gmail.com> <bd76cb2f-7cdc-f11b-11ec-285862db66f3@arm.com>
In-Reply-To: <bd76cb2f-7cdc-f11b-11ec-285862db66f3@arm.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 3 May 2019 08:57:09 -0400
Message-ID: <CA+CK2bBS5Csz0O9sDVwt_NjtrBtLaMfkycjhaOmR7mXoKJ5XEg@mail.gmail.com>
Subject: Re: [PATCH v6 02/12] mm/sparsemem: Introduce common definitions for
 the size and mask of a section
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: owner-linux-mm@kvack.org
To: Robin Murphy <robin.murphy@arm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, linux-mm <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, LKML <linux-kernel@vger.kernel.org>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 3, 2019 at 6:35 AM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 03/05/2019 01:41, Dan Williams wrote:
> > On Thu, May 2, 2019 at 7:53 AM Pavel Tatashin <pasha.tatashin@soleen.co=
m> wrote:
> >>
> >> On Wed, Apr 17, 2019 at 2:52 PM Dan Williams <dan.j.williams@intel.com=
> wrote:
> >>>
> >>> Up-level the local section size and mask from kernel/memremap.c to
> >>> global definitions.  These will be used by the new sub-section hotplu=
g
> >>> support.
> >>>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Vlastimil Babka <vbabka@suse.cz>
> >>> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >>> Cc: Logan Gunthorpe <logang@deltatee.com>
> >>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >>
> >> Should be dropped from this series as it has been replaced by a very
> >> similar patch in the mainline:
> >>
> >> 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
> >>   mm/memremap: Rename and consolidate SECTION_SIZE
> >
> > I saw that patch fly by and acked it, but I have not seen it picked up
> > anywhere. I grabbed latest -linus and -next, but don't see that
> > commit.
> >
> > $ git show 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
> > fatal: bad object 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
>
> Yeah, I don't recognise that ID either, nor have I had any notifications
> that Andrew's picked up anything of mine yet :/

Sorry for the confusion. I thought I checked in a master branch, but
turns out I checked in a branch where I applied arm hotremove patches
and Robin's patch as well. These two patches are essentially the same,
so which one goes first the other should be dropped.

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>

Thank you,
Pasha

>
> Robin.
