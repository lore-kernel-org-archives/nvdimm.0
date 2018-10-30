Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06F8C2194D3B9
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 20:11:04 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id p23so9720416otf.11
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 20:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
In-Reply-To: <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Oct 2018 20:10:52 -0700
Message-ID: <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
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
To: Barret Rhoden <brho@google.com>
Cc: X86 ML <x86@kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 29, 2018 at 5:29 PM Barret Rhoden <brho@google.com> wrote:
>
> On 2018-10-29 at 15:25 Dan Williams <dan.j.williams@intel.com> wrote:
> > > +       /*
> > > +        * Our caller grabbed the KVM mmu_lock with a successful
> > > +        * mmu_notifier_retry, so we're safe to walk the page table.
> > > +        */
> > > +       map_sz = pgd_mapping_size(current->mm, hva);
> > > +       switch (map_sz) {
> > > +       case PMD_SIZE:
> > > +               return true;
> > > +       case P4D_SIZE:
> > > +       case PUD_SIZE:
> > > +               printk_once(KERN_INFO "KVM THP promo found a very large page");
> >
> > Why not allow PUD_SIZE? The device-dax interface supports PUD mappings.
>
> The place where I use that helper seemed to care about PMDs (compared
> to huge pages larger than PUDs), I think due to THP.  Though it also
> checks "level == PT_PAGE_TABLE_LEVEL", so it's probably a moot point.
>
> I can change it from pfn_is_pmd_mapped -> pfn_is_huge_mapped and allow
> any huge mapping that is appropriate: so PUD or PMD for DAX, PMD for
> non-DAX, IIUC.

Yes, THP stops at PMDs, but DAX and hugetlbfs support PUD level mappings.

> > > +               return false;
> > > +       }
> > > +       return false;
> > > +}
> >
> > The above 2 functions are  similar to what we need to do for
> > determining the blast radius of a memory error, see
> > dev_pagemap_mapping_shift() and its usage in add_to_kill().
>
> Great.  I don't know if I have access in the KVM code to the VMA to use
> those functions directly, but I can extract the guts of
> dev_pagemap_mapping_shift() or something and put it in mm/util.c.

Sounds good.

> > >  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> > >                                         gfn_t *gfnp, kvm_pfn_t *pfnp,
> > >                                         int *levelp)
> > > @@ -3168,7 +3237,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> > >          */
> > >         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> > >             level == PT_PAGE_TABLE_LEVEL &&
> > > -           PageTransCompoundMap(pfn_to_page(pfn)) &&
> > > +           pfn_is_pmd_mapped(vcpu->kvm, gfn, pfn) &&
> >
> > I'm wondering if we're adding an explicit is_zone_device_page() check
> > in this path to determine the page mapping size if that can be a
> > replacement for the kvm_is_reserved_pfn() check. In other words, the
> > goal of fixing up PageReserved() was to preclude the need for DAX-page
> > special casing in KVM, but if we already need add some special casing
> > for page size determination, might as well bypass the
> > kvm_is_reserved_pfn() dependency as well.
>
> kvm_is_reserved_pfn() is used in some other places, like
> kvm_set_pfn_dirty()and kvm_set_pfn_accessed().  Maybe the way those
> treat DAX pages matters on a case-by-case basis?
>
> There are other callers of kvm_is_reserved_pfn() such as
> kvm_pfn_to_page() and gfn_to_page().  I'm not familiar (yet) with how
> struct pages and DAX work together, and whether or not the callers of
> those pfn_to_page() functions have expectations about the 'type' of
> struct page they get back.
>

The property of DAX pages that requires special coordination is the
fact that the device hosting the pages can be disabled at will. The
get_dev_pagemap() api is the interface to pin a device-pfn so that you
can safely perform a pfn_to_page() operation.

Have the pages that kvm uses in this path already been pinned by vfio?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
