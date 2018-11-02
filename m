From: Barret Rhoden <brho@google.com>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Fri, 2 Nov 2018 16:32:54 -0400
Message-ID: <20181102163254.04be68b5@gnomeregan.cam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
        <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
        <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
        <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
        <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
        <71d52e0f-ec40-d423-4dd4-e3aeb3730166@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <71d52e0f-ec40-d423-4dd4-e3aeb3730166@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, zwisler@kernel.org, Vishal L Verma <vishal.l.verma@intel.com>, rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-Id: linux-nvdimm@lists.01.org

On 2018-10-31 at 09:49 Paolo Bonzini <pbonzini@redhat.com> wrote:
> > On 2018-10-29 at 20:10 Dan Williams <dan.j.williams@intel.com> wrote:  
> >> The property of DAX pages that requires special coordination is the
> >> fact that the device hosting the pages can be disabled at will. The
> >> get_dev_pagemap() api is the interface to pin a device-pfn so that you
> >> can safely perform a pfn_to_page() operation.
> >>
> >> Have the pages that kvm uses in this path already been pinned by vfio?  
> 
> No, VFIO is not involved here.
> 
> The pages that KVM uses are never pinned.  Soon after we grab them and
> we build KVM's page table, we do put_page in mmu_set_spte (via
> kvm_release_pfn_clean).  From that point on the MMU notifier will take
> care of invalidating SPT before the page disappears from the mm's page
> table.

I looked into this a little, and I think it's safe in terms of DAX's
get_dev_pagemap() refcounts to have kvm_is_reserved_pfn() treat
DAX pages as not reserved.  kvm_is_reserved_pfn() is used before a
pfn_to_page() call, so the concern was that the pages didn't have a DAX
refcount.

Many of the times that KVM looks at the PFN, it's holding the KVM
mmu_lock, which keeps the pages in the host-side VMA. (IIUC).
Functions like kvm_set_pfn_dirty() fall into this category.

The other times, such as the vmexit path I mentioned before, go through
a gfn_to_pfn call.  Under the hood, those call one of the
get_user_pages() functions during hva_to_pfn, and those do the
right thing w.r.t. get_dev_pagemap().

One of the other things I noticed was some places in KVM make a
distinction between kvm_is_reserved_pfn and PageReserved:

void kvm_set_pfn_dirty(kvm_pfn_t pfn)
{
        if (!kvm_is_reserved_pfn(pfn)) {
                struct page *page = pfn_to_page(pfn);

                if (!PageReserved(page))
                        SetPageDirty(page);
        }
}

I think we want to SetPageDirty for DAX, so making PageReserved be true
for DAX seems like the way to go, or we'll need more KVM-specific
changes.  Apologies is this was discussed in the previous thread on this
topic and is redundant.

Thanks,

Barret
