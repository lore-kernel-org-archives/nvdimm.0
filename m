Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B1CD211D0C87
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 20:12:46 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id e22so3620734oiy.0
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 20:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
 <CAPcyv4ir4irASBQrZD_a6kMkEUt=XPUCuKajF75O7wDCgeG=7Q@mail.gmail.com>
 <871s3aqfup.fsf@linux.ibm.com>
 <CAPcyv4i0SahDP=_ZQV3RG_b5pMkjn-9Cjy7OpY2sm1PxLdO8jA@mail.gmail.com>
 <87bm267ywc.fsf@linux.ibm.com> <878sxa7ys5.fsf@linux.ibm.com>
 <CAPcyv4iuAPg3HWh5e8-Ud3oCrvp5AoFmjOzf4bbA+VLgR7NLFg@mail.gmail.com>
 <CAPcyv4hMzVuOYzy2tTq-my8Z1y+X6Ug-fyObpKTxVU44p5rBZw@mail.gmail.com>
 <CAOSf1CEZoLw5QqEMTKwiZ+d_qPLp_D9pJZUtnQWMXWpAXOQ2YA@mail.gmail.com>
In-Reply-To: <CAOSf1CEZoLw5QqEMTKwiZ+d_qPLp_D9pJZUtnQWMXWpAXOQ2YA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Mar 2019 20:12:34 -0700
Message-ID: <CAPcyv4hiAE9Y3Jeudr=Ys=eu2gei088xGyTCJGOoz04iUExUfw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
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
To: Oliver <oohall@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Ross Zwisler <zwisler@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 20, 2019 at 8:09 PM Oliver <oohall@gmail.com> wrote:
>
> On Thu, Mar 21, 2019 at 7:57 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > On Wed, Mar 20, 2019 at 8:34 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > On Wed, Mar 20, 2019 at 1:09 AM Aneesh Kumar K.V
> > > <aneesh.kumar@linux.ibm.com> wrote:
> > > >
> > > > Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com> writes:
> > > >
> > > > > Dan Williams <dan.j.williams@intel.com> writes:
> > > > >
> > > > >>
> > > > >>> Now what will be page size used for mapping vmemmap?
> > > > >>
> > > > >> That's up to the architecture's vmemmap_populate() implementation.
> > > > >>
> > > > >>> Architectures
> > > > >>> possibly will use PMD_SIZE mapping if supported for vmemmap. Now a
> > > > >>> device-dax with struct page in the device will have pfn reserve area aligned
> > > > >>> to PAGE_SIZE with the above example? We can't map that using
> > > > >>> PMD_SIZE page size?
> > > > >>
> > > > >> IIUC, that's a different alignment. Currently that's handled by
> > > > >> padding the reservation area up to a section (128MB on x86) boundary,
> > > > >> but I'm working on patches to allow sub-section sized ranges to be
> > > > >> mapped.
> > > > >
> > > > > I am missing something w.r.t code. The below code align that using nd_pfn->align
> > > > >
> > > > >       if (nd_pfn->mode == PFN_MODE_PMEM) {
> > > > >               unsigned long memmap_size;
> > > > >
> > > > >               /*
> > > > >                * vmemmap_populate_hugepages() allocates the memmap array in
> > > > >                * HPAGE_SIZE chunks.
> > > > >                */
> > > > >               memmap_size = ALIGN(64 * npfns, HPAGE_SIZE);
> > > > >               offset = ALIGN(start + SZ_8K + memmap_size + dax_label_reserve,
> > > > >                               nd_pfn->align) - start;
> > > > >       }
> > > > >
> > > > > IIUC that is finding the offset where to put vmemmap start. And that has
> > > > > to be aligned to the page size with which we may end up mapping vmemmap
> > > > > area right?
> > >
> > > Right, that's the physical offset of where the vmemmap ends, and the
> > > memory to be mapped begins.
> > >
> > > > > Yes we find the npfns by aligning up using PAGES_PER_SECTION. But that
> > > > > is to compute howmany pfns we should map for this pfn dev right?
> > > > >
> > > >
> > > > Also i guess those 4K assumptions there is wrong?
> > >
> > > Yes, I think to support non-4K-PAGE_SIZE systems the 'pfn' metadata
> > > needs to be revved and the PAGE_SIZE needs to be recorded in the
> > > info-block.
> >
> > How often does a system change page-size. Is it fixed or do
> > environment change it from one boot to the next? I'm thinking through
> > the behavior of what do when the recorded PAGE_SIZE in the info-block
> > does not match the current system page size. The simplest option is to
> > just fail the device and require it to be reconfigured. Is that
> > acceptable?
>
> The kernel page size is set at build time and as far as I know every
> distro configures their ppc64(le) kernel for 64K. I've used 4K kernels
> a few times in the past to debug PAGE_SIZE dependent problems, but I'd
> be surprised if anyone is using 4K in production.

Ah, ok.

> Anyway, my view is that using 4K here isn't really a problem since
> it's just the accounting unit of the pfn superblock format. The kernel
> reading form it should understand that and scale it to whatever
> accounting unit it wants to use internally. Currently we don't so that
> should probably be fixed, but that doesn't seem to cause any real
> issues. As far as I can tell the only user of npfns in
> __nvdimm_setup_pfn() whih prints the "number of pfns truncated"
> message.
>
> Am I missing something?

No, I don't think so. The only time it would break is if a system with
64K page size laid down an info-block with not enough reserved
capacity when the page-size is 4K (npfns too small). However, that
sounds like an exceptional case which is why no problems have been
reported to date.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
