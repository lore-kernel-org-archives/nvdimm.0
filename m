Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D0D321A00AE6
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 13:16:38 -0800 (PST)
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
References: <20181029210716.212159-1-brho@google.com>
 <20181106160553.5a8025ed@gnomeregan.cam.corp.google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <13b9a5a5-6773-131e-8014-f1b1bc975794@redhat.com>
Date: Tue, 6 Nov 2018 22:16:30 +0100
MIME-Version: 1.0
In-Reply-To: <20181106160553.5a8025ed@gnomeregan.cam.corp.google.com>
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
To: Barret Rhoden <brho@google.com>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc: kvm@vger.kernel.org, yu.c.zhang@intel.com, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 06/11/2018 22:05, Barret Rhoden wrote:
> On 2018-10-29 at 17:07 Barret Rhoden <brho@google.com> wrote:
>> Another issue is that kvm_mmu_zap_collapsible_spte() also uses
>> PageTransCompoundMap() to detect huge pages, but we don't have a way to
>> get the HVA easily.  Can we just aggressively zap DAX pages there?
> 
> Any thoughts about this?  Is there a way to determine the HVA or GFN in
> this function:

Yes, iter.gfn is the gfn inside the loop and iter.level is the level
(1=PTE, 2=PDE, ...).  iter.level of course is unusable here, similar to
*levelp in transparent_hugepage_adjust, but you can use iter.gfn and
gfn_to_hva.

Paolo

> static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,                        
>                                          struct kvm_rmap_head *rmap_head)        
> {       
>         u64 *sptep;                                                              
>         struct rmap_iterator iter;                                               
>         int need_tlb_flush = 0;
>         kvm_pfn_t pfn;
>         struct kvm_mmu_page *sp;
>                                                                                  
> restart:        
>         for_each_rmap_spte(rmap_head, &iter, sptep) {
>                 sp = page_header(__pa(sptep));
>                 pfn = spte_to_pfn(*sptep);
> 
>                 /*
>                  * We cannot do huge page mapping for indirect shadow pages,     
>                  * which are found on the last rmap (level = 1) when not using   
>                  * tdp; such shadow pages are synced with the page table in      
>                  * the guest, and the guest page table is using 4K page size     
>                  * mapping if the indirect sp has level = 1.                     
>                  */     
>                 if (sp->role.direct &&                                           
>                         !kvm_is_reserved_pfn(pfn) &&                             
>                         PageTransCompoundMap(pfn_to_page(pfn))) {                
>                         pte_list_remove(rmap_head, sptep);                       
>                         need_tlb_flush = 1;                                      
>                         goto restart;                                            
>                 }                                                                
>         }
>                                    
>         return need_tlb_flush;                                                   
> }    
> 
> If not, I was thinking of changing that loop to always remove PTEs for
> DAX mappings, with the understanding that they'll get faulted back in
> later.  Ideally, we'd like to check if the page is huge, but DAX can't
> use the PageTransCompoundMap check.
> 
> Thanks,
> 
> Barret
> 
> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
