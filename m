From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Mon, 29 Oct 2018 20:28:54 -0400
Message-ID: <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Zhang, Yu C" <yu.c.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, KVM list <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Zhang,
 Yi Z" <yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On 2018-10-29 at 15:25 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > +       /*
> > +        * Our caller grabbed the KVM mmu_lock with a successful
> > +        * mmu_notifier_retry, so we're safe to walk the page table.
> > +        */
> > +       map_sz = pgd_mapping_size(current->mm, hva);
> > +       switch (map_sz) {
> > +       case PMD_SIZE:
> > +               return true;
> > +       case P4D_SIZE:
> > +       case PUD_SIZE:
> > +               printk_once(KERN_INFO "KVM THP promo found a very large page");  
> 
> Why not allow PUD_SIZE? The device-dax interface supports PUD mappings.

The place where I use that helper seemed to care about PMDs (compared
to huge pages larger than PUDs), I think due to THP.  Though it also
checks "level == PT_PAGE_TABLE_LEVEL", so it's probably a moot point.

I can change it from pfn_is_pmd_mapped -> pfn_is_huge_mapped and allow
any huge mapping that is appropriate: so PUD or PMD for DAX, PMD for
non-DAX, IIUC.

> 
> > +               return false;
> > +       }
> > +       return false;
> > +}  
> 
> The above 2 functions are  similar to what we need to do for
> determining the blast radius of a memory error, see
> dev_pagemap_mapping_shift() and its usage in add_to_kill().

Great.  I don't know if I have access in the KVM code to the VMA to use
those functions directly, but I can extract the guts of
dev_pagemap_mapping_shift() or something and put it in mm/util.c.

> >  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> >                                         gfn_t *gfnp, kvm_pfn_t *pfnp,
> >                                         int *levelp)
> > @@ -3168,7 +3237,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> >          */
> >         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> >             level == PT_PAGE_TABLE_LEVEL &&
> > -           PageTransCompoundMap(pfn_to_page(pfn)) &&
> > +           pfn_is_pmd_mapped(vcpu->kvm, gfn, pfn) &&  
> 
> I'm wondering if we're adding an explicit is_zone_device_page() check
> in this path to determine the page mapping size if that can be a
> replacement for the kvm_is_reserved_pfn() check. In other words, the
> goal of fixing up PageReserved() was to preclude the need for DAX-page
> special casing in KVM, but if we already need add some special casing
> for page size determination, might as well bypass the
> kvm_is_reserved_pfn() dependency as well.

kvm_is_reserved_pfn() is used in some other places, like
kvm_set_pfn_dirty()and kvm_set_pfn_accessed().  Maybe the way those
treat DAX pages matters on a case-by-case basis?  

There are other callers of kvm_is_reserved_pfn() such as
kvm_pfn_to_page() and gfn_to_page().  I'm not familiar (yet) with how
struct pages and DAX work together, and whether or not the callers of
those pfn_to_page() functions have expectations about the 'type' of
struct page they get back.

It looks like another time that this popped up was kvm_is_mmio_pfn(),
though that wasn't exactly checking kvm_is_reserved_pfn(), and it
special cased based on the memory type / PAT business.

Thanks,

Barret
