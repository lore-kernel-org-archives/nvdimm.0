From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] kvm: Use huge pages for DAX-backed files
Date: Tue, 6 Nov 2018 16:05:53 -0500
Message-ID: <20181106160553.5a8025ed@gnomeregan.cam.corp.google.com>
References: <20181029210716.212159-1-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181029210716.212159-1-brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Radim
 =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yu.c.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter
 Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On 2018-10-29 at 17:07 Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> Another issue is that kvm_mmu_zap_collapsible_spte() also uses
> PageTransCompoundMap() to detect huge pages, but we don't have a way to
> get the HVA easily.  Can we just aggressively zap DAX pages there?

Any thoughts about this?  Is there a way to determine the HVA or GFN in
this function:

static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,                        
                                         struct kvm_rmap_head *rmap_head)        
{       
        u64 *sptep;                                                              
        struct rmap_iterator iter;                                               
        int need_tlb_flush = 0;
        kvm_pfn_t pfn;
        struct kvm_mmu_page *sp;
                                                                                 
restart:        
        for_each_rmap_spte(rmap_head, &iter, sptep) {
                sp = page_header(__pa(sptep));
                pfn = spte_to_pfn(*sptep);

                /*
                 * We cannot do huge page mapping for indirect shadow pages,     
                 * which are found on the last rmap (level = 1) when not using   
                 * tdp; such shadow pages are synced with the page table in      
                 * the guest, and the guest page table is using 4K page size     
                 * mapping if the indirect sp has level = 1.                     
                 */     
                if (sp->role.direct &&                                           
                        !kvm_is_reserved_pfn(pfn) &&                             
                        PageTransCompoundMap(pfn_to_page(pfn))) {                
                        pte_list_remove(rmap_head, sptep);                       
                        need_tlb_flush = 1;                                      
                        goto restart;                                            
                }                                                                
        }
                                   
        return need_tlb_flush;                                                   
}    

If not, I was thinking of changing that loop to always remove PTEs for
DAX mappings, with the understanding that they'll get faulted back in
later.  Ideally, we'd like to check if the page is huge, but DAX can't
use the PageTransCompoundMap check.

Thanks,

Barret
