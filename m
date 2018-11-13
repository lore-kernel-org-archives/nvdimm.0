Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] kvm: Use huge pages for DAX-backed files
References: <20181109203921.178363-1-brho@google.com>
 <20181109203921.178363-3-brho@google.com>
 <043a592d-6592-3053-15a0-68cc54a26deb@redhat.com>
 <286665658.33247363.1542103353780.JavaMail.zimbra@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <74665f91-9803-88d0-7730-bbb9c7b84da1@redhat.com>
Date: Tue, 13 Nov 2018 13:41:20 +0100
MIME-Version: 1.0
In-Reply-To: <286665658.33247363.1542103353780.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Pankaj Gupta <pagupta@redhat.com>, Barret Rhoden <brho@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>, David Hildenbrand <david@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, yu c zhang <yu.c.zhang@intel.com>, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 13/11/2018 11:02, Pankaj Gupta wrote:
> 
>>
>> On 09.11.18 21:39, Barret Rhoden wrote:
>>> This change allows KVM to map DAX-backed files made of huge pages with
>>> huge mappings in the EPT/TDP.
>>>
>>> DAX pages are not PageTransCompound.  The existing check is trying to
>>> determine if the mapping for the pfn is a huge mapping or not.  For
>>> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
>>> For DAX, we can check the page table itself.
>>>
>>> Note that KVM already faulted in the page (or huge page) in the host's
>>> page table, and we hold the KVM mmu spinlock (grabbed before checking
>>> the mmu seq).
>>
>> I wonder if the KVM mmu spinlock is enough for walking (not KVM
>> exclusive) host page tables. Can you elaborate?
> 
> As this patch is dependent on PageReserved patch(which is in progress), just 
> wondering if we are able to test the code path for hugepage with DAX.

The MMU spinlock is taken in kvm_mmu_notifier_invalidate_range_end, so
it should be enough.

Paolo

> 
> Thanks,
> Pankaj 
>  
>>
>>>
>>> Signed-off-by: Barret Rhoden <brho@google.com>
>>> ---
>>>  arch/x86/kvm/mmu.c | 34 ++++++++++++++++++++++++++++++++--
>>>  1 file changed, 32 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>>> index cf5f572f2305..2df8c459dc6a 100644
>>> --- a/arch/x86/kvm/mmu.c
>>> +++ b/arch/x86/kvm/mmu.c
>>> @@ -3152,6 +3152,36 @@ static int kvm_handle_bad_page(struct kvm_vcpu
>>> *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>>>  	return -EFAULT;
>>>  }
>>>  
>>> +static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>>> +{
>>> +	struct page *page = pfn_to_page(pfn);
>>> +	unsigned long hva, map_shift;
>>> +
>>> +	if (!is_zone_device_page(page))
>>> +		return PageTransCompoundMap(page);
>>> +
>>> +	/*
>>> +	 * DAX pages do not use compound pages.  The page should have already
>>> +	 * been mapped into the host-side page table during try_async_pf(), so
>>> +	 * we can check the page tables directly.
>>> +	 */
>>> +	hva = gfn_to_hva(kvm, gfn);
>>> +	if (kvm_is_error_hva(hva))
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * Our caller grabbed the KVM mmu_lock with a successful
>>> +	 * mmu_notifier_retry, so we're safe to walk the page table.
>>> +	 */
>>> +	map_shift = dev_pagemap_mapping_shift(hva, current->mm);
>>
>> You could get rid of that local variable map_shift.
>>
>>> +	switch (map_shift) {
>>> +	case PMD_SHIFT:
>>> +	case PUD_SIZE:
>>> +		return true;
>>> +	}
>>> +	return false;
>>> +}
>>> +
>>>  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>>>  					gfn_t *gfnp, kvm_pfn_t *pfnp,
>>>  					int *levelp)
>>> @@ -3168,7 +3198,7 @@ static void transparent_hugepage_adjust(struct
>>> kvm_vcpu *vcpu,
>>>  	 */
>>>  	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
>>>  	    level == PT_PAGE_TABLE_LEVEL &&
>>> -	    PageTransCompoundMap(pfn_to_page(pfn)) &&
>>> +	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
>>>  	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
>>>  		unsigned long mask;
>>>  		/*
>>> @@ -5678,7 +5708,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm
>>> *kvm,
>>>  		 */
>>>  		if (sp->role.direct &&
>>>  			!kvm_is_reserved_pfn(pfn) &&
>>> -			PageTransCompoundMap(pfn_to_page(pfn))) {
>>> +			pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
>>>  			pte_list_remove(rmap_head, sptep);
>>>  			need_tlb_flush = 1;
>>>  			goto restart;
>>>
>>
>> This looks surprisingly simple to me :)
>>
>> --
>>
>> Thanks,
>>
>> David / dhildenb
>>
