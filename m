Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
 <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
 <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
 <71d52e0f-ec40-d423-4dd4-e3aeb3730166@redhat.com>
 <20181102163254.04be68b5@gnomeregan.cam.corp.google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <876d5a71-8dda-4728-5329-4e169777ba4a@redhat.com>
Date: Tue, 6 Nov 2018 11:19:18 +0100
MIME-Version: 1.0
In-Reply-To: <20181102163254.04be68b5@gnomeregan.cam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Barret Rhoden <brho@google.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, zwisler@kernel.org, Vishal L Verma <vishal.l.verma@intel.com>, rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 02/11/2018 21:32, Barret Rhoden wrote:
> One of the other things I noticed was some places in KVM make a
> distinction between kvm_is_reserved_pfn and PageReserved:
> 
> void kvm_set_pfn_dirty(kvm_pfn_t pfn)
> {
>         if (!kvm_is_reserved_pfn(pfn)) {
>                 struct page *page = pfn_to_page(pfn);
> 
>                 if (!PageReserved(page))
>                         SetPageDirty(page);
>         }
> }
> 
> I think we want to SetPageDirty for DAX, so making PageReserved be true
> for DAX seems like the way to go, or we'll need more KVM-specific
> changes.  Apologies is this was discussed in the previous thread on this
> topic and is redundant.

Isn't it the opposite?  We want SetPageDirty, so PageReserved must _not_
be true.

Paolo
