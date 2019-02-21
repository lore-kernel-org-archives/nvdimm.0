Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94C4E208AE2C5
 for <linux-nvdimm@lists.01.org>; Thu, 21 Feb 2019 14:58:43 -0800 (PST)
Date: Thu, 21 Feb 2019 14:58:27 -0800
From: Larry Bassel <larry.bassel@oracle.com>
Subject: Re: question about page tables in DAX/FS/PMEM case
Message-ID: <20190221225827.GA2764@ubuette>
References: <20190220230622.GI19341@ubuette> <20190221204141.GB5201@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190221204141.GB5201@redhat.com>
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
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

[adding linux-mm]

On 21 Feb 19 15:41, Jerome Glisse wrote:
> On Wed, Feb 20, 2019 at 03:06:22PM -0800, Larry Bassel wrote:
> > I'm working on sharing page tables in the DAX/XFS/PMEM/PMD case.
> > =

> > If multiple processes would use the identical page of PMDs corresponding
> > to a 1 GiB address range of DAX/XFS/PMEM/PMDs, presumably one can inste=
ad
> > of populating a new PUD, just atomically increment a refcount and point
> > to the same PUD in the next level above.

Thanks for your feedback. Some comments/clarification below.

> =

> I think page table sharing was discuss several time in the past and
> the complexity involve versus the benefit were not clear. For 1GB
> of virtual address you need:
>     #pte pages =3D 1G/(512 * 2^12)       =3D 512 pte pages
>     #pmd pages =3D 1G/(512 * 512 * 2^12) =3D 1   pmd pages
> =

> So if we were to share the pmd directory page we would be saving a
> total of 513 pages for every page table or ~2MB. This goes up with
> the number of process that map the same range ie if 10 process map
> the same range and share the same pmd than you are saving 9 * 2MB
> 18MB of memory. This seems relatively modest saving.

The file blocksize =3D page size in what I am working on would
be 2 MiB (sharing puds/pages of pmds), I'm not trying to
support sharing pmds/pages of ptes. And yes, the savings in this
case is actually even less than in your example (but see my example below).

> =

> AFAIK there is no hardware benefit from sharing the page table
> directory within different page table. So the only benefit is the
> amount of memory we save.

Yes, in our use case (high end Oracle database using DAX/XFS/PMEM/PMD)
the main benefit would be memory savings:

A future system might have 6 TiB of PMEM on it and
there might be 10000 processes each mapping all of this 6 TiB.
Here the savings would be approximately
(6 TiB / 2 MiB) * 8 bytes (page table size) * 10000 =3D 240 GiB
(and these page tables themselves would be in non-PMEM (ordinary RAM)).

> =

> See below for comments on complexity to achieve this.
> =

[trim]
> > =

> > If I have a mmap of a DAX/FS/PMEM file and I take
> > a page (either pte or PMD sized) fault on access to this file,
> > the page table(s) are set up in dax_iomap_fault() in fs/dax.c (correct?=
).
> =

> Not exactly the page table are allocated long before dax_iomap_fault()
> get calls. They are allocated by the handle_mm_fault() and its childs
> functions.

Yes, I misstated this, the fault is handled there which may well
alter the PUD (in my case), but the original page tables are set up earlier.

> =

> > =

> > If the process later munmaps this file or exits but there are still
> > other users of the shared page of PMDs, I would need to
> > detect that this has happened and act accordingly (#3 above)
> > =

> > Where will these page table entries be torn down?
> > In the same code where any other page table is torn down?
> > If this is the case, what would the cleanest way of telling that these
> > page tables (PMDs, etc.) correspond to a DAX/FS/PMEM mapping
> > (look at the physical address pointed to?) so that
> > I could do the right thing here.
> > =

> > I understand that I may have missed something obvious here.
> > =

> =

> They are many issues here are the one i can think of:
>     - finding a pmd/pud to share, you need to walk the reverse mapping
>       of the range you are mapping and to find if any process or other
>       virtual address already as a pud or pmd you can reuse. This can
>       take more time than allocating page directory pages.
>     - if one process munmap some portion of a share pud you need to
>       break the sharing this means that munmap (or mremap) would need
>       to handle this page table directory sharing case first
>     - many code path in the kernel might need update to understand this
>       share page table thing (mprotect, userfaultfd, ...)
>     - the locking rules is bound to be painfull
>     - this might not work on all architecture as some architecture do
>       associate information with page table directory and that can not
>       always be share (it would need to be enabled arch by arch)

Yes, some architectures don't support DAX at all (note again that
I'm not trying to share non-DAX page table here).

> =

> The nice thing:
>     - unmapping for migration, when you unmap a share pud/pmd you can
>       decrement mapcount by share pud/pmd count this could speedup
>       migration

A followup question: the kernel does sharing of page tables for hugetlbfs
(also 2 MiB pages), why aren't the above issues relevant there as well
(or are they but we support it anyhow)?

> =

> This is what i could think of on the top of my head but there might be
> other thing. I believe the question is really a benefit versus cost and
> to me at least the complexity cost outweight the benefit one for now.
> Kirill Shutemov proposed rework on how we do page table and this kind of
> rework might tip the balance the other way. So my suggestion would be to
> look into how the page table management can be change in a beneficial
> way that could also achieve the page table sharing.
> =

> Cheers,
> J=E9r=F4me

Thanks.

Larry
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
