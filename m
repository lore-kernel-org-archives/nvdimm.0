Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A99121A00AE6
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 15:25:55 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id r127-v6so6919750oie.3
 for <linux-nvdimm@lists.01.org>; Mon, 29 Oct 2018 15:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <20181029210716.212159-1-brho@google.com>
In-Reply-To: <20181029210716.212159-1-brho@google.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Oct 2018 15:25:42 -0700
Message-ID: <CAPcyv4gJUjuSKwy7i2wuKR=Vz-AkDrxnGya5qkg7XTFxuXbtzw@mail.gmail.com>
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

On Mon, Oct 29, 2018 at 2:07 PM Barret Rhoden <brho@google.com> wrote:
>
> This change allows KVM to map DAX-backed files made of huge pages with
> huge mappings in the EPT/TDP.
>
> DAX pages are not PageTransCompound.  The existing check is trying to
> determine if the mapping for the pfn is a huge mapping or not.  For
> non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
>
> For DAX, we can check the page table itself.  Actually, we might always
> be able to walk the page table, even for PageTransCompound pages, but
> it's probably a little slower.
>
> Note that KVM already faulted in the page (or huge page) in the host's
> page table, and we hold the KVM mmu spinlock (grabbed before checking
> the mmu seq).  Based on the other comments about not worrying about a
> pmd split, we might be able to safely walk the page table without
> holding the mm sem.
>
> This patch relies on kvm_is_reserved_pfn() being false for DAX pages,
> which I've hacked up for testing this code.  That change should
> eventually happen:
>
> https://lore.kernel.org/lkml/20181022084659.GA84523@tiger-server/
>
> Another issue is that kvm_mmu_zap_collapsible_spte() also uses
> PageTransCompoundMap() to detect huge pages, but we don't have a way to
> get the HVA easily.  Can we just aggressively zap DAX pages there?
>
> Alternatively, is there a better way to track at the struct page level
> whether or not a page is huge-mapped?  Maybe the DAX huge pages mark
> themselves as TransCompound or something similar, and we don't need to
> special case DAX/ZONE_DEVICE pages.
>
> Signed-off-by: Barret Rhoden <brho@google.com>
> ---
>  arch/x86/kvm/mmu.c | 71 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 70 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index cf5f572f2305..9f3e0f83a2dd 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3152,6 +3152,75 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>         return -EFAULT;
>  }
>
> +static unsigned long pgd_mapping_size(struct mm_struct *mm, unsigned long addr)
> +{
> +       pgd_t *pgd;
> +       p4d_t *p4d;
> +       pud_t *pud;
> +       pmd_t *pmd;
> +       pte_t *pte;
> +
> +       pgd = pgd_offset(mm, addr);
> +       if (!pgd_present(*pgd))
> +               return 0;
> +
> +       p4d = p4d_offset(pgd, addr);
> +       if (!p4d_present(*p4d))
> +               return 0;
> +       if (p4d_huge(*p4d))
> +               return P4D_SIZE;
> +
> +       pud = pud_offset(p4d, addr);
> +       if (!pud_present(*pud))
> +               return 0;
> +       if (pud_huge(*pud))
> +               return PUD_SIZE;
> +
> +       pmd = pmd_offset(pud, addr);
> +       if (!pmd_present(*pmd))
> +               return 0;
> +       if (pmd_huge(*pmd))
> +               return PMD_SIZE;
> +
> +       pte = pte_offset_map(pmd, addr);
> +       if (!pte_present(*pte))
> +               return 0;
> +       return PAGE_SIZE;
> +}
> +
> +static bool pfn_is_pmd_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> +{
> +       struct page *page = pfn_to_page(pfn);
> +       unsigned long hva, map_sz;
> +
> +       if (!is_zone_device_page(page))
> +               return PageTransCompoundMap(page);
> +
> +       /*
> +        * DAX pages do not use compound pages.  The page should have already
> +        * been mapped into the host-side page table during try_async_pf(), so
> +        * we can check the page tables directly.
> +        */
> +       hva = gfn_to_hva(kvm, gfn);
> +       if (kvm_is_error_hva(hva))
> +               return false;
> +
> +       /*
> +        * Our caller grabbed the KVM mmu_lock with a successful
> +        * mmu_notifier_retry, so we're safe to walk the page table.
> +        */
> +       map_sz = pgd_mapping_size(current->mm, hva);
> +       switch (map_sz) {
> +       case PMD_SIZE:
> +               return true;
> +       case P4D_SIZE:
> +       case PUD_SIZE:
> +               printk_once(KERN_INFO "KVM THP promo found a very large page");

Why not allow PUD_SIZE? The device-dax interface supports PUD mappings.

> +               return false;
> +       }
> +       return false;
> +}

The above 2 functions are  similar to what we need to do for
determining the blast radius of a memory error, see
dev_pagemap_mapping_shift() and its usage in add_to_kill().

> +
>  static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>                                         gfn_t *gfnp, kvm_pfn_t *pfnp,
>                                         int *levelp)
> @@ -3168,7 +3237,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>          */
>         if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
>             level == PT_PAGE_TABLE_LEVEL &&
> -           PageTransCompoundMap(pfn_to_page(pfn)) &&
> +           pfn_is_pmd_mapped(vcpu->kvm, gfn, pfn) &&

I'm wondering if we're adding an explicit is_zone_device_page() check
in this path to determine the page mapping size if that can be a
replacement for the kvm_is_reserved_pfn() check. In other words, the
goal of fixing up PageReserved() was to preclude the need for DAX-page
special casing in KVM, but if we already need add some special casing
for page size determination, might as well bypass the
kvm_is_reserved_pfn() dependency as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
