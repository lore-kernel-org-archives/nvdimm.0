Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9D6C21244A78
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 06:00:33 -0700 (PDT)
Date: Fri, 3 May 2019 15:00:29 +0200
From: Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v6 02/12] mm/sparsemem: Introduce common definitions for
 the size and mask of a section
Message-ID: <20190503130023.GA22564@linux>
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552634586.2015392.2662168839054356692.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+CK2bCkqLc82G2MW+rYrKTi4KafC+tLCASkaT8zRfVJCCe8HQ@mail.gmail.com>
 <CAPcyv4g+KNu=upejy7Xm=jWR0cdhygPAdSRbkfFGpJeHFGc4+w@mail.gmail.com>
 <bd76cb2f-7cdc-f11b-11ec-285862db66f3@arm.com>
 <CA+CK2bBS5Csz0O9sDVwt_NjtrBtLaMfkycjhaOmR7mXoKJ5XEg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+CK2bBS5Csz0O9sDVwt_NjtrBtLaMfkycjhaOmR7mXoKJ5XEg@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 03, 2019 at 08:57:09AM -0400, Pavel Tatashin wrote:
> On Fri, May 3, 2019 at 6:35 AM Robin Murphy <robin.murphy@arm.com> wrote:
> >
> > On 03/05/2019 01:41, Dan Williams wrote:
> > > On Thu, May 2, 2019 at 7:53 AM Pavel Tatashin <pasha.tatashin@soleen.=
com> wrote:
> > >>
> > >> On Wed, Apr 17, 2019 at 2:52 PM Dan Williams <dan.j.williams@intel.c=
om> wrote:
> > >>>
> > >>> Up-level the local section size and mask from kernel/memremap.c to
> > >>> global definitions.  These will be used by the new sub-section hotp=
lug
> > >>> support.
> > >>>
> > >>> Cc: Michal Hocko <mhocko@suse.com>
> > >>> Cc: Vlastimil Babka <vbabka@suse.cz>
> > >>> Cc: J=E9r=F4me Glisse <jglisse@redhat.com>
> > >>> Cc: Logan Gunthorpe <logang@deltatee.com>
> > >>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > >>
> > >> Should be dropped from this series as it has been replaced by a very
> > >> similar patch in the mainline:
> > >>
> > >> 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
> > >>   mm/memremap: Rename and consolidate SECTION_SIZE
> > >
> > > I saw that patch fly by and acked it, but I have not seen it picked up
> > > anywhere. I grabbed latest -linus and -next, but don't see that
> > > commit.
> > >
> > > $ git show 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
> > > fatal: bad object 7c697d7fb5cb14ef60e2b687333ba3efb74f73da
> >
> > Yeah, I don't recognise that ID either, nor have I had any notifications
> > that Andrew's picked up anything of mine yet :/
> =

> Sorry for the confusion. I thought I checked in a master branch, but
> turns out I checked in a branch where I applied arm hotremove patches
> and Robin's patch as well. These two patches are essentially the same,
> so which one goes first the other should be dropped.
> =

> Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>

Hey Pavel,

just a friendly note :-) :

you are reviewing v6, I think you might want to review v7 [1] instead ;-)?

[1] https://patchwork.kernel.org/cover/10926035/
 =


-- =

Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
