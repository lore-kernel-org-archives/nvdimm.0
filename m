Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4A615820C4
 for <linux-nvdimm@lists.01.org>; Wed, 21 Dec 2016 00:48:28 -0800 (PST)
Date: Wed, 21 Dec 2016 09:48:24 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: wrprotect pmd_t in dax_mapping_entry_mkclean
Message-ID: <20161221084824.GA4756@quack2.suse.cz>
References: <1482272586-21177-1-git-send-email-ross.zwisler@linux.intel.com>
 <1482272586-21177-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1482272586-21177-3-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 20-12-16 15:23:06, Ross Zwisler wrote:
> Currently dax_mapping_entry_mkclean() fails to clean and write protect the
> pmd_t of a DAX PMD entry during an *sync operation.  This can result in
> data loss in the following sequence:
> 
> 1) mmap write to DAX PMD, dirtying PMD radix tree entry and making the
>    pmd_t dirty and writeable
> 2) fsync, flushing out PMD data and cleaning the radix tree entry. We
>    currently fail to mark the pmd_t as clean and write protected.
> 3) more mmap writes to the PMD.  These don't cause any page faults since
>    the pmd_t is dirty and writeable.  The radix tree entry remains clean.
> 4) fsync, which fails to flush the dirty PMD data because the radix tree
>    entry was clean.
> 5) crash - dirty data that should have been fsync'd as part of 4) could
>    still have been in the processor cache, and is lost.
> 
> Fix this by marking the pmd_t clean and write protected in
> dax_mapping_entry_mkclean(), which is called as part of the fsync
> operation 2).  This will cause the writes in step 3) above to generate page
> faults where we'll re-dirty the PMD radix tree entry, resulting in flushes
> in the fsync that happens in step 4).
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Jan Kara <jack@suse.cz>
> Fixes: 4b4bb46d00b3 ("dax: clear dirty entry tags on cache flush")

Yeah, good catch. The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/dax.c           | 51 ++++++++++++++++++++++++++++++++++++---------------
>  include/linux/mm.h |  2 --
>  mm/memory.c        |  4 ++--
>  3 files changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5c74f60..ddcddfe 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -691,8 +691,8 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
>  				      pgoff_t index, unsigned long pfn)
>  {
>  	struct vm_area_struct *vma;
> -	pte_t *ptep;
> -	pte_t pte;
> +	pte_t pte, *ptep = NULL;
> +	pmd_t *pmdp = NULL;
>  	spinlock_t *ptl;
>  	bool changed;
>  
> @@ -707,21 +707,42 @@ static void dax_mapping_entry_mkclean(struct address_space *mapping,
>  
>  		address = pgoff_address(index, vma);
>  		changed = false;
> -		if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
> +		if (follow_pte_pmd(vma->vm_mm, address, &ptep, &pmdp, &ptl))
>  			continue;
> -		if (pfn != pte_pfn(*ptep))
> -			goto unlock;
> -		if (!pte_dirty(*ptep) && !pte_write(*ptep))
> -			goto unlock;
>  
> -		flush_cache_page(vma, address, pfn);
> -		pte = ptep_clear_flush(vma, address, ptep);
> -		pte = pte_wrprotect(pte);
> -		pte = pte_mkclean(pte);
> -		set_pte_at(vma->vm_mm, address, ptep, pte);
> -		changed = true;
> -unlock:
> -		pte_unmap_unlock(ptep, ptl);
> +		if (pmdp) {
> +#ifdef CONFIG_FS_DAX_PMD
> +			pmd_t pmd;
> +
> +			if (pfn != pmd_pfn(*pmdp))
> +				goto unlock_pmd;
> +			if (!pmd_dirty(*pmdp) && !pmd_write(*pmdp))
> +				goto unlock_pmd;
> +
> +			flush_cache_page(vma, address, pfn);
> +			pmd = pmdp_huge_clear_flush(vma, address, pmdp);
> +			pmd = pmd_wrprotect(pmd);
> +			pmd = pmd_mkclean(pmd);
> +			set_pmd_at(vma->vm_mm, address, pmdp, pmd);
> +			changed = true;
> +unlock_pmd:
> +			spin_unlock(ptl);
> +#endif
> +		} else {
> +			if (pfn != pte_pfn(*ptep))
> +				goto unlock_pte;
> +			if (!pte_dirty(*ptep) && !pte_write(*ptep))
> +				goto unlock_pte;
> +
> +			flush_cache_page(vma, address, pfn);
> +			pte = ptep_clear_flush(vma, address, ptep);
> +			pte = pte_wrprotect(pte);
> +			pte = pte_mkclean(pte);
> +			set_pte_at(vma->vm_mm, address, ptep, pte);
> +			changed = true;
> +unlock_pte:
> +			pte_unmap_unlock(ptep, ptl);
> +		}
>  
>  		if (changed)
>  			mmu_notifier_invalidate_page(vma->vm_mm, address);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ff0e1c1..f4de7fa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1210,8 +1210,6 @@ int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
>  			struct vm_area_struct *vma);
>  void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows);
> -int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
> -	       spinlock_t **ptlp);
>  int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
>  			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
>  int follow_pfn(struct vm_area_struct *vma, unsigned long address,
> diff --git a/mm/memory.c b/mm/memory.c
> index 29edd91..ddcf979 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3826,8 +3826,8 @@ static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
>  	return -EINVAL;
>  }
>  
> -int follow_pte(struct mm_struct *mm, unsigned long address, pte_t **ptepp,
> -	       spinlock_t **ptlp)
> +static inline int follow_pte(struct mm_struct *mm, unsigned long address,
> +			     pte_t **ptepp, spinlock_t **ptlp)
>  {
>  	int res;
>  
> -- 
> 2.7.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
