From: Barret Rhoden <brho@google.com>
Subject: Re: [PATCH v3 0/3] kvm: Use huge pages for DAX-backed files
Date: Thu, 4 Apr 2019 16:28:51 -0400
Message-ID: <ac4e061c-429d-2306-2f7b-b7f8e6fc362b@google.com>
References: <20190404202345.133553-1-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404202345.133553-1-brho@google.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yu.c.zhang@intel.com
List-Id: linux-nvdimm@lists.01.org


-yi.z.zhang@intel.com (Bad email address / failure)

Sorry about that.

On 4/4/19 4:23 PM, Barret Rhoden wrote:
> This patch series depends on DAX pages not being PageReserved.  Once
> that is in place, these changes will let KVM use huge pages with
> DAX-backed files.
> 
>  From previous discussions[1], it sounds like DAX might not need to keep
> the PageReserved bit, but that it hadn't been sorted out yet.
> 
> Without the PageReserved change, KVM and DAX still work with these
> patches, simply without huge pages - which is the current situation.
> 
> If you want to test the huge-page functionality as if DAX pages weren't
> PageReserved for KVM, this hack does the trick:
> 
> ------------------
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c44985375e7f..ee539eec1fb8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -153,6 +153,10 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
>   
>   bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>   {
> +       // XXX hack
> +       if (is_zone_device_page(pfn_to_page(pfn)))
> +               return false;
> +
>          if (pfn_valid(pfn))
>                  return PageReserved(pfn_to_page(pfn));
>   
> ------------------
> 
> Perhaps if we are going to leave DAX pages marked PageReserved, then I
> can make that hack into a proper commit and have KVM alone treat DAX
> pages as if they are not reserved.
> 
> v2 -> v3:
> v2: https://lore.kernel.org/lkml/20181114215155.259978-1-brho@google.com/
> - Updated Acks/Reviewed-by
> - Rebased onto linux-next
> 
> v1 -> v2:
> https://lore.kernel.org/lkml/20181109203921.178363-1-brho@google.com/
> - Updated Acks/Reviewed-by
> - Minor touchups
> - Added patch to remove redundant PageReserved() check
> - Rebased onto linux-next
> 
> RFC/discussion thread:
> https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/
> 
> [1] https://lore.kernel.org/lkml/ee8cc068-903c-d87e-f418-ade46786249e@redhat.com/
> 
> Barret Rhoden (3):
>    mm: make dev_pagemap_mapping_shift() externally visible
>    kvm: Use huge pages for DAX-backed files
>    kvm: remove redundant PageReserved() check
> 
>   arch/x86/kvm/mmu.c  | 33 +++++++++++++++++++++++++++++++--
>   include/linux/mm.h  |  3 +++
>   mm/memory-failure.c | 38 +++-----------------------------------
>   mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
>   virt/kvm/kvm_main.c |  8 ++------
>   5 files changed, 73 insertions(+), 43 deletions(-)
> 
