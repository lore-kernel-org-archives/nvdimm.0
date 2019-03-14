Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CD3D211CD639
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 21:02:24 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r19so3909745otn.1
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 21:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
 <CAPcyv4ir4irASBQrZD_a6kMkEUt=XPUCuKajF75O7wDCgeG=7Q@mail.gmail.com>
 <871s3aqfup.fsf@linux.ibm.com>
In-Reply-To: <871s3aqfup.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Mar 2019 21:02:11 -0700
Message-ID: <CAPcyv4i0SahDP=_ZQV3RG_b5pMkjn-9Cjy7OpY2sm1PxLdO8jA@mail.gmail.com>
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Michael Ellerman <mpe@ellerman.id.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 13, 2019 at 8:45 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
[..]
> >> Now w.r.t to failures, can device-dax do an opportunistic huge page
> >> usage?
> >
> > device-dax explicitly disclaims the ability to do opportunistic mappings.
> >
> >> I haven't looked at the device-dax details fully yet. Do we make the
> >> assumption of the mapping page size as a format w.r.t device-dax? Is that
> >> derived from nd_pfn->align value?
> >
> > Correct.
> >
> >>
> >> Here is what I am working on:
> >> 1) If the platform doesn't support huge page and if the device superblock
> >> indicated that it was created with huge page support, we fail the device
> >> init.
> >
> > Ok.
> >
> >> 2) Now if we are creating a new namespace without huge page support in
> >> the platform, then we force the align details to PAGE_SIZE. In such a
> >> configuration when handling dax fault even with THP enabled during
> >> the build, we should not try to use hugepage. This I think we can
> >> achieve by using TRANSPARENT_HUGEPAEG_DAX_FLAG.
> >
> > How is this dynamic property communicated to the guest?
>
> via device tree on powerpc. We have a device tree node indicating
> supported page sizes.

Ah, ok, yeah let's plumb that straight to the device-dax driver and
leave out the interaction / interpretation of the thp-enabled flags.

>
> >
> >>
> >> Also even if the user decided to not use THP, by
> >> echo "never" > transparent_hugepage/enabled , we should continue to map
> >> dax fault using huge page on platforms that can support huge pages.
> >>
> >> This still doesn't cover the details of a device-dax created with
> >> PAGE_SIZE align later booted with a kernel that can do hugepage dax.How
> >> should we handle that? That makes me think, this should be a VMA flag
> >> which got derived from device config? May be use VM_HUGEPAGE to indicate
> >> if device should use a hugepage mapping or not?
> >
> > device-dax configured with PAGE_SIZE always gets PAGE_SIZE mappings.
>
> Now what will be page size used for mapping vmemmap?

That's up to the architecture's vmemmap_populate() implementation.

> Architectures
> possibly will use PMD_SIZE mapping if supported for vmemmap. Now a
> device-dax with struct page in the device will have pfn reserve area aligned
> to PAGE_SIZE with the above example? We can't map that using
> PMD_SIZE page size?

IIUC, that's a different alignment. Currently that's handled by
padding the reservation area up to a section (128MB on x86) boundary,
but I'm working on patches to allow sub-section sized ranges to be
mapped.

Now, that said, I expect there may be bugs lurking in the
implementation if PAGE_SIZE changes from one boot to the next simply
because I've never tested that.

I think this also indicates that the section padding logic can't be
removed until all arch vmemmap_populate() implementations understand
the sub-section case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
