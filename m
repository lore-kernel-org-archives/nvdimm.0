Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id BFF1D1A1F78
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 15:19:29 -0700 (PDT)
Date: Tue, 29 Mar 2016 16:18:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 09/10] dax: Use radix tree entry lock to protect cow faults
Message-ID: <20160329221827.GC21264@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-10-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-10-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, Wilcox,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:54PM +0100, Jan Kara wrote:
> When doing cow faults, we cannot directly fill in PTE as we do for other
> faults as we rely on generic code to do proper accounting of the cowed page.
> We also have no page to lock to protect against races with truncate as
> other faults have and we need the protection to extend until the moment
> generic code inserts cowed page into PTE thus at that point we have no
> protection of fs-specific i_mmap_sem. So far we relied on using
> i_mmap_lock for the protection however that is completely special to cow
> faults. To make fault locking more uniform use DAX entry lock instead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  fs/dax.c            | 12 +++++-------
>  include/linux/dax.h |  1 +
>  include/linux/mm.h  |  7 +++++++
>  mm/memory.c         | 38 ++++++++++++++++++--------------------
>  4 files changed, 31 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4fcac59b6dcb..2fcf4e8a17c5 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -469,7 +469,7 @@ restart:
>  	return ret;
>  }
>  
> -static void unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
> +void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
>  {
>  	void *ret, **slot;
>  	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
> @@ -502,7 +502,7 @@ static void put_locked_mapping_entry(struct address_space *mapping,
>  		unlock_page(entry);
>  		page_cache_release(entry);
>  	} else {
> -		unlock_mapping_entry(mapping, index);
> +		dax_unlock_mapping_entry(mapping, index);
>  	}
>  }
>  
> @@ -887,12 +887,10 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  			goto unlock_entry;
>  		if (!radix_tree_exceptional_entry(entry)) {
>  			vmf->page = entry;
> -		} else {
> -			unlock_mapping_entry(mapping, vmf->pgoff);
> -			i_mmap_lock_read(mapping);
> -			vmf->page = NULL;
> +			return VM_FAULT_LOCKED;
>  		}
> -		return VM_FAULT_LOCKED;
> +		vmf->entry = entry;
> +		return VM_FAULT_DAX_LOCKED;
>  	}
>  
>  	if (!buffer_mapped(&bh)) {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index da2416d916e6..29a83a767ea3 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -60,4 +60,5 @@ static inline bool dax_mapping(struct address_space *mapping)
>  struct writeback_control;
>  int dax_writeback_mapping_range(struct address_space *mapping,
>  		struct block_device *bdev, struct writeback_control *wbc);
> +void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index);
>  #endif
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 450fc977ed02..1c64039dc505 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -299,6 +299,12 @@ struct vm_fault {
>  					 * is set (which is also implied by
>  					 * VM_FAULT_ERROR).
>  					 */
> +	void *entry;			/* ->fault handler can alternatively
> +					 * return locked DAX entry. In that
> +					 * case handler should return
> +					 * VM_FAULT_DAX_LOCKED and fill in
> +					 * entry here.
> +					 */
>  	/* for ->map_pages() only */
>  	pgoff_t max_pgoff;		/* map pages for offset from pgoff till
>  					 * max_pgoff inclusive */
> @@ -1084,6 +1090,7 @@ static inline void clear_page_pfmemalloc(struct page *page)
>  #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
>  #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
>  #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
> +#define VM_FAULT_DAX_LOCKED 0x1000	/* ->fault has locked DAX entry */
>  
>  #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 81dca0083fcd..7a704d3cd3b5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -63,6 +63,7 @@
>  #include <linux/dma-debug.h>
>  #include <linux/debugfs.h>
>  #include <linux/userfaultfd_k.h>
> +#include <linux/dax.h>
>  
>  #include <asm/io.h>
>  #include <asm/mmu_context.h>
> @@ -2783,7 +2784,8 @@ oom:
>   */
>  static int __do_fault(struct vm_area_struct *vma, unsigned long address,
>  			pgoff_t pgoff, unsigned int flags,
> -			struct page *cow_page, struct page **page)
> +			struct page *cow_page, struct page **page,
> +			void **entry)
>  {
>  	struct vm_fault vmf;
>  	int ret;
> @@ -2798,8 +2800,10 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
>  	ret = vma->vm_ops->fault(vma, &vmf);
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
>  		return ret;
> -	if (!vmf.page)
> -		goto out;
> +	if (ret & VM_FAULT_DAX_LOCKED) {
> +		*entry = vmf.entry;
> +		return ret;
> +	}
>  
>  	if (unlikely(PageHWPoison(vmf.page))) {
>  		if (ret & VM_FAULT_LOCKED)
> @@ -2813,7 +2817,6 @@ static int __do_fault(struct vm_area_struct *vma, unsigned long address,
>  	else
>  		VM_BUG_ON_PAGE(!PageLocked(vmf.page), vmf.page);
>  
> - out:
>  	*page = vmf.page;
>  	return ret;
>  }
> @@ -2985,7 +2988,7 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		pte_unmap_unlock(pte, ptl);
>  	}
>  
> -	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
> +	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page, NULL);
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
>  		return ret;
>  
> @@ -3008,6 +3011,7 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		pgoff_t pgoff, unsigned int flags, pte_t orig_pte)
>  {
>  	struct page *fault_page, *new_page;
> +	void *fault_entry;
>  	struct mem_cgroup *memcg;
>  	spinlock_t *ptl;
>  	pte_t *pte;
> @@ -3025,26 +3029,24 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  		return VM_FAULT_OOM;
>  	}
>  
> -	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page);
> +	ret = __do_fault(vma, address, pgoff, flags, new_page, &fault_page,
> +			 &fault_entry);
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
>  		goto uncharge_out;
>  
> -	if (fault_page)
> +	if (!(ret & VM_FAULT_DAX_LOCKED))
>  		copy_user_highpage(new_page, fault_page, address, vma);
>  	__SetPageUptodate(new_page);
>  
>  	pte = pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (unlikely(!pte_same(*pte, orig_pte))) {
>  		pte_unmap_unlock(pte, ptl);
> -		if (fault_page) {
> +		if (!(ret & VM_FAULT_DAX_LOCKED)) {
>  			unlock_page(fault_page);
>  			page_cache_release(fault_page);
>  		} else {
> -			/*
> -			 * The fault handler has no page to lock, so it holds
> -			 * i_mmap_lock for read to protect against truncate.
> -			 */
> -			i_mmap_unlock_read(vma->vm_file->f_mapping);
> +			dax_unlock_mapping_entry(vma->vm_file->f_mapping,
> +						 pgoff);
>  		}
>  		goto uncharge_out;
>  	}
> @@ -3052,15 +3054,11 @@ static int do_cow_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	mem_cgroup_commit_charge(new_page, memcg, false, false);
>  	lru_cache_add_active_or_unevictable(new_page, vma);
>  	pte_unmap_unlock(pte, ptl);
> -	if (fault_page) {
> +	if (!(ret & VM_FAULT_DAX_LOCKED)) {
>  		unlock_page(fault_page);
>  		page_cache_release(fault_page);
>  	} else {
> -		/*
> -		 * The fault handler has no page to lock, so it holds
> -		 * i_mmap_lock for read to protect against truncate.
> -		 */
> -		i_mmap_unlock_read(vma->vm_file->f_mapping);
> +		dax_unlock_mapping_entry(vma->vm_file->f_mapping, pgoff);
>  	}
>  	return ret;
>  uncharge_out:
> @@ -3080,7 +3078,7 @@ static int do_shared_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	int dirtied = 0;
>  	int ret, tmp;
>  
> -	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page);
> +	ret = __do_fault(vma, address, pgoff, flags, NULL, &fault_page, NULL);
>  	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE | VM_FAULT_RETRY)))
>  		return ret;
>  
> -- 
> 2.6.2
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
