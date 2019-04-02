Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB76D211D6729
 for <linux-nvdimm@lists.01.org>; Tue,  2 Apr 2019 08:24:07 -0700 (PDT)
Date: Tue, 2 Apr 2019 17:24:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
Message-ID: <20190402152405.GC25668@quack2.suse.cz>
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-mm@kvack.org, Chandan Rajendra <chandan@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-04-19 17:21:25, Aneesh Kumar K.V wrote:
> With some architectures like ppc64, set_pmd_at() cannot cope with
> a situation where there is already some (different) valid entry present.
> 
> Use pmdp_set_access_flags() instead to modify the pfn which is built to
> deal with modifying existing PMD entries.
> 
> This is similar to
> commit cae85cb8add3 ("mm/memory.c: fix modifying of page protection by insert_pfn()")
> 
> We also do similar update w.r.t insert_pfn_pud eventhough ppc64 don't support
> pud pfn entries now.
> 
> Without this patch we also see the below message in kernel log
> "BUG: non-zero pgtables_bytes on freeing mm:"
> 
> CC: stable@vger.kernel.org
> Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes from v1:
> * Fix the pgtable leak 
> 
>  mm/huge_memory.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 404acdcd0455..165ea46bf149 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -755,6 +755,21 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	spinlock_t *ptl;
>  
>  	ptl = pmd_lock(mm, pmd);
> +	if (!pmd_none(*pmd)) {
> +		if (write) {
> +			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
> +				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
> +				goto out_unlock;
> +			}
> +			entry = pmd_mkyoung(*pmd);
> +			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
> +			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
> +				update_mmu_cache_pmd(vma, addr, pmd);
> +		}
> +
> +		goto out_unlock;
> +	}
> +
>  	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>  	if (pfn_t_devmap(pfn))
>  		entry = pmd_mkdevmap(entry);
> @@ -766,11 +781,16 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	if (pgtable) {
>  		pgtable_trans_huge_deposit(mm, pmd, pgtable);
>  		mm_inc_nr_ptes(mm);
> +		pgtable = NULL;
>  	}
>  
>  	set_pmd_at(mm, addr, pmd, entry);
>  	update_mmu_cache_pmd(vma, addr, pmd);
> +
> +out_unlock:
>  	spin_unlock(ptl);
> +	if (pgtable)
> +		pte_free(mm, pgtable);
>  }
>  
>  vm_fault_t vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> @@ -821,6 +841,20 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  	spinlock_t *ptl;
>  
>  	ptl = pud_lock(mm, pud);
> +	if (!pud_none(*pud)) {
> +		if (write) {
> +			if (pud_pfn(*pud) != pfn_t_to_pfn(pfn)) {
> +				WARN_ON_ONCE(!is_huge_zero_pud(*pud));
> +				goto out_unlock;
> +			}
> +			entry = pud_mkyoung(*pud);
> +			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
> +			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
> +				update_mmu_cache_pud(vma, addr, pud);
> +		}
> +		goto out_unlock;
> +	}
> +
>  	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
>  	if (pfn_t_devmap(pfn))
>  		entry = pud_mkdevmap(entry);
> @@ -830,6 +864,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
>  	}
>  	set_pud_at(mm, addr, pud, entry);
>  	update_mmu_cache_pud(vma, addr, pud);
> +
> +out_unlock:
>  	spin_unlock(ptl);
>  }
>  
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
