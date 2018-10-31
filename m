Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85C0B2116745C
 for <linux-nvdimm@lists.01.org>; Wed, 31 Oct 2018 01:50:00 -0700 (PDT)
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
References: <20181029210716.212159-1-brho@google.com>
 <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
 <20181029202854.7c924fd3@gnomeregan.cam.corp.google.com>
 <CAPcyv4gQztHrJ3--rhU4ZpaZyyqdqE0=gx50CRArHKiXwfYC+A@mail.gmail.com>
 <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <71d52e0f-ec40-d423-4dd4-e3aeb3730166@redhat.com>
Date: Wed, 31 Oct 2018 09:49:52 +0100
MIME-Version: 1.0
In-Reply-To: <20181030154524.181b8236@gnomeregan.cam.corp.google.com>
Content-Language: en-US
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
To: Barret Rhoden <brho@google.com>, Dan Williams <dan.j.williams@intel.com>
Cc: X86 ML <x86@kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 30/10/2018 20:45, Barret Rhoden wrote:
> On 2018-10-29 at 20:10 Dan Williams <dan.j.williams@intel.com> wrote:
>> The property of DAX pages that requires special coordination is the
>> fact that the device hosting the pages can be disabled at will. The
>> get_dev_pagemap() api is the interface to pin a device-pfn so that you
>> can safely perform a pfn_to_page() operation.
>>
>> Have the pages that kvm uses in this path already been pinned by vfio?

No, VFIO is not involved here.

The pages that KVM uses are never pinned.  Soon after we grab them and
we build KVM's page table, we do put_page in mmu_set_spte (via
kvm_release_pfn_clean).  From that point on the MMU notifier will take
care of invalidating SPT before the page disappears from the mm's page
table.

> One usage of kvm_is_reserved_pfn() in KVM code is like this:
> 
> static struct page *kvm_pfn_to_page(kvm_pfn_t pfn)
> {  
>         if (is_error_noslot_pfn(pfn))
>                 return KVM_ERR_PTR_BAD_PAGE; 
>     
>         if (kvm_is_reserved_pfn(pfn)) {                      
>                 WARN_ON(1);
>                 return KVM_ERR_PTR_BAD_PAGE;                         
>         }
> 
>         return pfn_to_page(pfn);                                                  
> }
> 
> I think there's no guarantee the kvm->mmu_lock is held in the generic
> case.

Indeed, it's not.

> There are probably other rules related to gfn_to_page that keep the
> page alive, maybe just during interrupt/vmexit context?  Whatever keeps
> those pages alive for normal memory might grab that devmap reference
> under the hood for DAX mappings.

Nothing keeps the page alive except for the MMU notifier (which of
course cannot run in atomic context, since its callers take the mmap_sem).

Paolo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
