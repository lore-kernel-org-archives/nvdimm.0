Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D646D21B02822
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 16:39:34 -0800 (PST)
Date: Thu, 21 Feb 2019 19:39:31 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: question about page tables in DAX/FS/PMEM case
Message-ID: <20190222003931.GB10607@redhat.com>
References: <20190220230622.GI19341@ubuette> <20190221204141.GB5201@redhat.com>
 <20190221225827.GA2764@ubuette>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190221225827.GA2764@ubuette>
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
To: Larry Bassel <larry.bassel@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 21, 2019 at 02:58:27PM -0800, Larry Bassel wrote:
> [adding linux-mm]
> =

> On 21 Feb 19 15:41, Jerome Glisse wrote:
> > On Wed, Feb 20, 2019 at 03:06:22PM -0800, Larry Bassel wrote:
> > > I'm working on sharing page tables in the DAX/XFS/PMEM/PMD case.
> > > =

> > > If multiple processes would use the identical page of PMDs correspond=
ing
> > > to a 1 GiB address range of DAX/XFS/PMEM/PMDs, presumably one can ins=
tead
> > > of populating a new PUD, just atomically increment a refcount and poi=
nt
> > > to the same PUD in the next level above.
> =

> Thanks for your feedback. Some comments/clarification below.
> =

> > =

> > I think page table sharing was discuss several time in the past and
> > the complexity involve versus the benefit were not clear. For 1GB
> > of virtual address you need:
> >     #pte pages =3D 1G/(512 * 2^12)       =3D 512 pte pages
> >     #pmd pages =3D 1G/(512 * 512 * 2^12) =3D 1   pmd pages
> > =

> > So if we were to share the pmd directory page we would be saving a
> > total of 513 pages for every page table or ~2MB. This goes up with
> > the number of process that map the same range ie if 10 process map
> > the same range and share the same pmd than you are saving 9 * 2MB
> > 18MB of memory. This seems relatively modest saving.
> =

> The file blocksize =3D page size in what I am working on would
> be 2 MiB (sharing puds/pages of pmds), I'm not trying to
> support sharing pmds/pages of ptes. And yes, the savings in this
> case is actually even less than in your example (but see my example below=
).
> =

> > =

> > AFAIK there is no hardware benefit from sharing the page table
> > directory within different page table. So the only benefit is the
> > amount of memory we save.
> =

> Yes, in our use case (high end Oracle database using DAX/XFS/PMEM/PMD)
> the main benefit would be memory savings:
> =

> A future system might have 6 TiB of PMEM on it and
> there might be 10000 processes each mapping all of this 6 TiB.
> Here the savings would be approximately
> (6 TiB / 2 MiB) * 8 bytes (page table size) * 10000 =3D 240 GiB
> (and these page tables themselves would be in non-PMEM (ordinary RAM)).

Damm you have a lot of process, must mean many cores, i want one of those :)

[...]

> > > If the process later munmaps this file or exits but there are still
> > > other users of the shared page of PMDs, I would need to
> > > detect that this has happened and act accordingly (#3 above)
> > > =

> > > Where will these page table entries be torn down?
> > > In the same code where any other page table is torn down?
> > > If this is the case, what would the cleanest way of telling that these
> > > page tables (PMDs, etc.) correspond to a DAX/FS/PMEM mapping
> > > (look at the physical address pointed to?) so that
> > > I could do the right thing here.
> > > =

> > > I understand that I may have missed something obvious here.
> > > =

> > =

> > They are many issues here are the one i can think of:
> >     - finding a pmd/pud to share, you need to walk the reverse mapping
> >       of the range you are mapping and to find if any process or other
> >       virtual address already as a pud or pmd you can reuse. This can
> >       take more time than allocating page directory pages.
> >     - if one process munmap some portion of a share pud you need to
> >       break the sharing this means that munmap (or mremap) would need
> >       to handle this page table directory sharing case first
> >     - many code path in the kernel might need update to understand this
> >       share page table thing (mprotect, userfaultfd, ...)
> >     - the locking rules is bound to be painfull
> >     - this might not work on all architecture as some architecture do
> >       associate information with page table directory and that can not
> >       always be share (it would need to be enabled arch by arch)
> =

> Yes, some architectures don't support DAX at all (note again that
> I'm not trying to share non-DAX page table here).

DAX is irrelevant here, DAX is a property of the underlying filesystem
and for the most part the core mm is blissfully unaware of it. So all
of the above apply.

> > =

> > The nice thing:
> >     - unmapping for migration, when you unmap a share pud/pmd you can
> >       decrement mapcount by share pud/pmd count this could speedup
> >       migration
> =

> A followup question: the kernel does sharing of page tables for hugetlbfs
> (also 2 MiB pages), why aren't the above issues relevant there as well
> (or are they but we support it anyhow)?

hugetlbfs is a thing on its own like no other in the kernel and i don't
think we want to repeat it. It has special case all over the mm so all
the case that can go wrong are handled by the hugetlbfs code instead of
core mm function.

I would not follow that as an example i don't think there is much love
for what hugetlbfs turned into.

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
