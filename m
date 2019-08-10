Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43FA12131D58F
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 17:09:26 -0700 (PDT)
Subject: Re: [RFC PATCH v2 09/19] mm/gup: Introduce vaddr_pin structure
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-10-ira.weiny@intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <e92723cf-97a1-9860-9482-8466ff2feaa8@nvidia.com>
Date: Fri, 9 Aug 2019 17:06:44 -0700
MIME-Version: 1.0
In-Reply-To: <20190809225833.6657-10-ira.weiny@intel.com>
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
To: ira.weiny@intel.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

On 8/9/19 3:58 PM, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Some subsystems need to pass owning file information to GUP calls to
> allow for GUP to associate the "owning file" to any files being pinned
> within the GUP call.
> 
> Introduce an object to specify this information and pass it down through
> some of the GUP call stack.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  include/linux/mm.h |  9 +++++++++
>  mm/gup.c           | 36 ++++++++++++++++++++++--------------
>  2 files changed, 31 insertions(+), 14 deletions(-)
> 

Looks good, although you may want to combine it with the next patch. 
Otherwise it feels like a "to be continued" when you're reading them.

Either way, though:

    Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 04f22722b374..befe150d17be 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -971,6 +971,15 @@ static inline bool is_zone_device_page(const struct page *page)
>  }
>  #endif
>  
> +/**
> + * @f_owner The file who "owns this GUP"
> + * @mm The mm who "owns this GUP"
> + */
> +struct vaddr_pin {
> +	struct file *f_owner;
> +	struct mm_struct *mm;
> +};
> +
>  #ifdef CONFIG_DEV_PAGEMAP_OPS
>  void __put_devmap_managed_page(struct page *page);
>  DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
> diff --git a/mm/gup.c b/mm/gup.c
> index 0b05e22ac05f..7a449500f0a6 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1005,7 +1005,8 @@ static __always_inline long __get_user_pages_locked(struct task_struct *tsk,
>  						struct page **pages,
>  						struct vm_area_struct **vmas,
>  						int *locked,
> -						unsigned int flags)
> +						unsigned int flags,
> +						struct vaddr_pin *vaddr_pin)
>  {
>  	long ret, pages_done;
>  	bool lock_dropped;
> @@ -1165,7 +1166,8 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
>  
>  	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
>  				       locked,
> -				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
> +				       gup_flags | FOLL_TOUCH | FOLL_REMOTE,
> +				       NULL);
>  }
>  EXPORT_SYMBOL(get_user_pages_remote);
>  
> @@ -1320,7 +1322,8 @@ static long __get_user_pages_locked(struct task_struct *tsk,
>  		struct mm_struct *mm, unsigned long start,
>  		unsigned long nr_pages, struct page **pages,
>  		struct vm_area_struct **vmas, int *locked,
> -		unsigned int foll_flags)
> +		unsigned int foll_flags,
> +		struct vaddr_pin *vaddr_pin)
>  {
>  	struct vm_area_struct *vma;
>  	unsigned long vm_flags;
> @@ -1504,7 +1507,7 @@ static long check_and_migrate_cma_pages(struct task_struct *tsk,
>  		 */
>  		nr_pages = __get_user_pages_locked(tsk, mm, start, nr_pages,
>  						   pages, vmas, NULL,
> -						   gup_flags);
> +						   gup_flags, NULL);
>  
>  		if ((nr_pages > 0) && migrate_allow) {
>  			drain_allow = true;
> @@ -1537,7 +1540,8 @@ static long __gup_longterm_locked(struct task_struct *tsk,
>  				  unsigned long nr_pages,
>  				  struct page **pages,
>  				  struct vm_area_struct **vmas,
> -				  unsigned int gup_flags)
> +				  unsigned int gup_flags,
> +				  struct vaddr_pin *vaddr_pin)
>  {
>  	struct vm_area_struct **vmas_tmp = vmas;
>  	unsigned long flags = 0;
> @@ -1558,7 +1562,7 @@ static long __gup_longterm_locked(struct task_struct *tsk,
>  	}
>  
>  	rc = __get_user_pages_locked(tsk, mm, start, nr_pages, pages,
> -				     vmas_tmp, NULL, gup_flags);
> +				     vmas_tmp, NULL, gup_flags, vaddr_pin);
>  
>  	if (gup_flags & FOLL_LONGTERM) {
>  		memalloc_nocma_restore(flags);
> @@ -1588,10 +1592,11 @@ static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
>  						  unsigned long nr_pages,
>  						  struct page **pages,
>  						  struct vm_area_struct **vmas,
> -						  unsigned int flags)
> +						  unsigned int flags,
> +						  struct vaddr_pin *vaddr_pin)
>  {
>  	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
> -				       NULL, flags);
> +				       NULL, flags, vaddr_pin);
>  }
>  #endif /* CONFIG_FS_DAX || CONFIG_CMA */
>  
> @@ -1607,7 +1612,8 @@ long get_user_pages(unsigned long start, unsigned long nr_pages,
>  		struct vm_area_struct **vmas)
>  {
>  	return __gup_longterm_locked(current, current->mm, start, nr_pages,
> -				     pages, vmas, gup_flags | FOLL_TOUCH);
> +				     pages, vmas, gup_flags | FOLL_TOUCH,
> +				     NULL);
>  }
>  EXPORT_SYMBOL(get_user_pages);
>  
> @@ -1647,7 +1653,7 @@ long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
>  
>  	return __get_user_pages_locked(current, current->mm, start, nr_pages,
>  				       pages, NULL, locked,
> -				       gup_flags | FOLL_TOUCH);
> +				       gup_flags | FOLL_TOUCH, NULL);
>  }
>  EXPORT_SYMBOL(get_user_pages_locked);
>  
> @@ -1684,7 +1690,7 @@ long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
>  
>  	down_read(&mm->mmap_sem);
>  	ret = __get_user_pages_locked(current, mm, start, nr_pages, pages, NULL,
> -				      &locked, gup_flags | FOLL_TOUCH);
> +				      &locked, gup_flags | FOLL_TOUCH, NULL);
>  	if (locked)
>  		up_read(&mm->mmap_sem);
>  	return ret;
> @@ -2377,7 +2383,8 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  EXPORT_SYMBOL_GPL(__get_user_pages_fast);
>  
>  static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
> -				   unsigned int gup_flags, struct page **pages)
> +				   unsigned int gup_flags, struct page **pages,
> +				   struct vaddr_pin *vaddr_pin)
>  {
>  	int ret;
>  
> @@ -2389,7 +2396,8 @@ static int __gup_longterm_unlocked(unsigned long start, int nr_pages,
>  		down_read(&current->mm->mmap_sem);
>  		ret = __gup_longterm_locked(current, current->mm,
>  					    start, nr_pages,
> -					    pages, NULL, gup_flags);
> +					    pages, NULL, gup_flags,
> +					    vaddr_pin);
>  		up_read(&current->mm->mmap_sem);
>  	} else {
>  		ret = get_user_pages_unlocked(start, nr_pages,
> @@ -2448,7 +2456,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
>  		pages += nr;
>  
>  		ret = __gup_longterm_unlocked(start, nr_pages - nr,
> -					      gup_flags, pages);
> +					      gup_flags, pages, NULL);
>  
>  		/* Have to be a bit careful with return values */
>  		if (nr > 0) {
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
