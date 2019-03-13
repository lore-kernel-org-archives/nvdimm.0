Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E087211D616E
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 09:02:14 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id b4so1849694oif.6
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 09:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com>
In-Reply-To: <87k1hc8iqa.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Mar 2019 09:02:03 -0700
Message-ID: <CAPcyv4ir4irASBQrZD_a6kMkEUt=XPUCuKajF75O7wDCgeG=7Q@mail.gmail.com>
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

On Wed, Mar 6, 2019 at 1:18 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Thu, Feb 28, 2019 at 1:40 AM Oliver <oohall@gmail.com> wrote:
> >>
> >> On Thu, Feb 28, 2019 at 7:35 PM Aneesh Kumar K.V
> >> <aneesh.kumar@linux.ibm.com> wrote:
> >> >
> >> > Add a flag to indicate the ability to do huge page dax mapping. On architecture
> >> > like ppc64, the hypervisor can disable huge page support in the guest. In
> >> > such a case, we should not enable huge page dax mapping. This patch adds
> >> > a flag which the architecture code will update to indicate huge page
> >> > dax mapping support.
> >>
> >> *groan*
> >>
> >> > Architectures mostly do transparent_hugepage_flag = 0; if they can't
> >> > do hugepages. That also takes care of disabling dax hugepage mapping
> >> > with this change.
> >> >
> >> > Without this patch we get the below error with kvm on ppc64.
> >> >
> >> > [  118.849975] lpar: Failed hash pte insert with error -4
> >> >
> >> > NOTE: The patch also use
> >> >
> >> > echo never > /sys/kernel/mm/transparent_hugepage/enabled
> >> > to disable dax huge page mapping.
> >> >
> >> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> >> > ---
> >> > TODO:
> >> > * Add Fixes: tag
> >> >
> >> >  include/linux/huge_mm.h | 4 +++-
> >> >  mm/huge_memory.c        | 4 ++++
> >> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> > index 381e872bfde0..01ad5258545e 100644
> >> > --- a/include/linux/huge_mm.h
> >> > +++ b/include/linux/huge_mm.h
> >> > @@ -53,6 +53,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
> >> >                         pud_t *pud, pfn_t pfn, bool write);
> >> >  enum transparent_hugepage_flag {
> >> >         TRANSPARENT_HUGEPAGE_FLAG,
> >> > +       TRANSPARENT_HUGEPAGE_DAX_FLAG,
> >> >         TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> >> >         TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
> >> >         TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
> >> > @@ -111,7 +112,8 @@ static inline bool __transparent_hugepage_enabled(struct vm_area_struct *vma)
> >> >         if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
> >> >                 return true;
> >> >
> >> > -       if (vma_is_dax(vma))
> >> > +       if (vma_is_dax(vma) &&
> >> > +           (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_DAX_FLAG)))
> >> >                 return true;
> >>
> >> Forcing PTE sized faults should be fine for fsdax, but it'll break
> >> devdax. The devdax driver requires the fault size be >= the namespace
> >> alignment since devdax tries to guarantee hugepage mappings will be
> >> used and PMD alignment is the default. We can probably have devdax
> >> fall back to the largest size the hypervisor has made available, but
> >> it does run contrary to the design. Ah well, I suppose it's better off
> >> being degraded rather than unusable.
> >
> > Given this is an explicit setting I think device-dax should explicitly
> > fail to enable in the presence of this flag to preserve the
> > application visible behavior.
> >
> > I.e. if device-dax was enabled after this setting was made then I
> > think future faults should fail as well.
>
> Not sure I understood that. Now we are disabling the ability to map
> pages as huge pages. I am now considering that this should not be
> user configurable. Ie, this is something that platform can use to avoid
> dax forcing huge page mapping, but if the architecture can enable huge
> dax mapping, we should always default to using that.

No, that's an application visible behavior regression. The side effect
of this setting is that all huge-page configured device-dax instances
must be disabled.

> Now w.r.t to failures, can device-dax do an opportunistic huge page
> usage?

device-dax explicitly disclaims the ability to do opportunistic mappings.

> I haven't looked at the device-dax details fully yet. Do we make the
> assumption of the mapping page size as a format w.r.t device-dax? Is that
> derived from nd_pfn->align value?

Correct.

>
> Here is what I am working on:
> 1) If the platform doesn't support huge page and if the device superblock
> indicated that it was created with huge page support, we fail the device
> init.

Ok.

> 2) Now if we are creating a new namespace without huge page support in
> the platform, then we force the align details to PAGE_SIZE. In such a
> configuration when handling dax fault even with THP enabled during
> the build, we should not try to use hugepage. This I think we can
> achieve by using TRANSPARENT_HUGEPAEG_DAX_FLAG.

How is this dynamic property communicated to the guest?

>
> Also even if the user decided to not use THP, by
> echo "never" > transparent_hugepage/enabled , we should continue to map
> dax fault using huge page on platforms that can support huge pages.
>
> This still doesn't cover the details of a device-dax created with
> PAGE_SIZE align later booted with a kernel that can do hugepage dax.How
> should we handle that? That makes me think, this should be a VMA flag
> which got derived from device config? May be use VM_HUGEPAGE to indicate
> if device should use a hugepage mapping or not?

device-dax configured with PAGE_SIZE always gets PAGE_SIZE mappings.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
