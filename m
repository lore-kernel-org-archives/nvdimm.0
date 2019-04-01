Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 1 Apr 2019 10:14:41 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: Fix modifying of page protection by insert_pfn_pmd()
Message-ID: <20190401081441.GD4826@quack2.suse.cz>
References: <20190330054121.27831-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330054121.27831-1-aneesh.kumar@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: dan.j.williams@intel.com, akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat 30-03-19 11:11:21, Aneesh Kumar K.V wrote:
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
> CC: stable@vger.kernel.org
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Thanks for fixing this! The patch looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/huge_memory.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 404acdcd0455..f7dca413c4b2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -755,6 +755,20 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
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
> +		goto out_unlock;
> +	}
> +
>  	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>  	if (pfn_t_devmap(pfn))
>  		entry = pmd_mkdevmap(entry);
> @@ -770,6 +784,7 @@ static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
>  
>  	set_pmd_at(mm, addr, pmd, entry);
>  	update_mmu_cache_pmd(vma, addr, pmd);
> +out_unlock:
>  	spin_unlock(ptl);
>  }
>  
> @@ -821,6 +836,20 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
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
> @@ -830,6 +859,8 @@ static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
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
