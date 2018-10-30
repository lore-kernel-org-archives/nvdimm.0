From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Tue, 30 Oct 2018 15:45:24 -0400
Message-ID: <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
 <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On 2018-10-29 at 20:10 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > > >  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> > > >                                         gfn_t *gfnp, kvm_pfn_t *pfnp,
> > > >                                         int *levelp)
> > > > @@ -3168,7 +3237,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
> > > >          */
> > > >         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
> > > >             level == PT_PAGE_TABLE_LEVEL &&
> > > > -           PageTransCompoundMap(pfn_to_page(pfn)) &&
> > > > +           pfn_is_pmd_mapped(vcpu->kvm, gfn, pfn) &&  
> > >
> > > I'm wondering if we're adding an explicit is_zone_device_page() check
> > > in this path to determine the page mapping size if that can be a
> > > replacement for the kvm_is_reserved_pfn() check. In other words, the
> > > goal of fixing up PageReserved() was to preclude the need for DAX-page
> > > special casing in KVM, but if we already need add some special casing
> > > for page size determination, might as well bypass the
> > > kvm_is_reserved_pfn() dependency as well.  
> >
> > kvm_is_reserved_pfn() is used in some other places, like
> > kvm_set_pfn_dirty()and kvm_set_pfn_accessed().  Maybe the way those
> > treat DAX pages matters on a case-by-case basis?
> >
> > There are other callers of kvm_is_reserved_pfn() such as
> > kvm_pfn_to_page() and gfn_to_page().  I'm not familiar (yet) with how
> > struct pages and DAX work together, and whether or not the callers of
> > those pfn_to_page() functions have expectations about the 'type' of
> > struct page they get back.
> >  
> 
> The property of DAX pages that requires special coordination is the
> fact that the device hosting the pages can be disabled at will. The
> get_dev_pagemap() api is the interface to pin a device-pfn so that you
> can safely perform a pfn_to_page() operation.
> 
> Have the pages that kvm uses in this path already been pinned by vfio?

I'm not aware of any explicit pinning, but it might be happening under
the hood.  These pages are just generic guest RAM, but they are present
in a host-side mapping.  I ran into this when looking at EPT fault
handling.  In the code I changed, a physical page was faulted in to the
task's page table, then while the kvm->mmu_lock is held, KVM makes an
EPT mapping to the same physical page.  That mmu_lock seems to prevent
any concurrent host-side unmappings; though I'm not familiar with the mm
notifier stuff.

One usage of kvm_is_reserved_pfn() in KVM code is like this:

static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
{  
        if (is_error_noslot_pfn(pfn))
                return KVM_ERR_PTR_BAD_PAGE; 
    
        if (kvm_is_reserved_pfn(pfn)) {                      
                WARN_ON(1);
                return KVM_ERR_PTR_BAD_PAGE;                         
        }

        return pfn_to_page(pfn);                                                  
}

I think there's no guarantee the kvm->mmu_lock is held in the generic
case.  Here's one case where it wasn't (from walking through the code):

handle_exception
-handle_ud
--kvm_emulate_instruction
---x86_emulate_instruction
----x86_emulate_insn
-----writeback
------segmented_cmpxchg
-------emulator_cmpxchg_emulated
--------kvm_vcpu_gfn_to_page
---------kvm_pfn_to_page

There are probably other rules related to gfn_to_page that keep the
page alive, maybe just during interrupt/vmexit context?  Whatever keeps
those pages alive for normal memory might grab that devmap reference
under the hood for DAX mappings.

Thanks,
Barret
