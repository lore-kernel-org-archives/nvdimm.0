Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from hqemgate15.nvidia.com (hqemgate15.nvidia.com [216.228.121.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2C59212D2775
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 17:12:36 -0700 (PDT)
Subject: Re: [RFC PATCH v2 15/19] mm/gup: Introduce vaddr_pin_pages()
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-16-ira.weiny@intel.com>
From: John Hubbard <jhubbard@nvidia.com>
Message-ID: <6ed26a08-4371-9dc1-09eb-7b8a4689d93b@nvidia.com>
Date: Fri, 9 Aug 2019 17:09:54 -0700
MIME-Version: 1.0
In-Reply-To: <20190809225833.6657-16-ira.weiny@intel.com>
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
> The addition of FOLL_LONGTERM has taken on additional meaning for CMA
> pages.
> 
> In addition subsystems such as RDMA require new information to be passed
> to the GUP interface to track file owning information.  As such a simple
> FOLL_LONGTERM flag is no longer sufficient for these users to pin pages.
> 
> Introduce a new GUP like call which takes the newly introduced vaddr_pin
> information.  Failure to pass the vaddr_pin object back to a vaddr_put*
> call will result in a failure if pins were created on files during the
> pin operation.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes from list:
> 	Change to vaddr_put_pages_dirty_lock
> 	Change to vaddr_unpin_pages_dirty_lock
> 
>  include/linux/mm.h |  5 ++++
>  mm/gup.c           | 59 ++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 657c947bda49..90c5802866df 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1603,6 +1603,11 @@ int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
>  int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
>  			struct task_struct *task, bool bypass_rlim);
>  
> +long vaddr_pin_pages(unsigned long addr, unsigned long nr_pages,
> +		     unsigned int gup_flags, struct page **pages,
> +		     struct vaddr_pin *vaddr_pin);
> +void vaddr_unpin_pages_dirty_lock(struct page **pages, unsigned long nr_pages,
> +				  struct vaddr_pin *vaddr_pin, bool make_dirty);

Hi Ira,

OK, the API seems fine to me, anyway. :)

A bit more below...

>  bool mapping_inode_has_layout(struct vaddr_pin *vaddr_pin, struct page *page);
>  
>  /* Container for pinned pfns / pages */
> diff --git a/mm/gup.c b/mm/gup.c
> index eeaa0ddd08a6..6d23f70d7847 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2536,3 +2536,62 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(get_user_pages_fast);
> +
> +/**
> + * vaddr_pin_pages pin pages by virtual address and return the pages to the
> + * user.
> + *
> + * @addr, start address

What's with the commas? I thought kernel-doc wants colons, like this, right?

@addr: start address


> + * @nr_pages, number of pages to pin
> + * @gup_flags, flags to use for the pin
> + * @pages, array of pages returned
> + * @vaddr_pin, initalized meta information this pin is to be associated
> + * with.
> + *
> + * NOTE regarding vaddr_pin:
> + *
> + * Some callers can share pins via file descriptors to other processes.
> + * Callers such as this should use the f_owner field of vaddr_pin to indicate
> + * the file the fd points to.  All other callers should use the mm this pin is
> + * being made against.  Usually "current->mm".
> + *
> + * Expects mmap_sem to be read locked.
> + */
> +long vaddr_pin_pages(unsigned long addr, unsigned long nr_pages,
> +		     unsigned int gup_flags, struct page **pages,
> +		     struct vaddr_pin *vaddr_pin)
> +{
> +	long ret;
> +
> +	gup_flags |= FOLL_LONGTERM;


Is now the right time to introduce and use FOLL_PIN? If not, then I can always
add it on top of this later, as part of gup-tracking patches. But you did point
out that FOLL_LONGTERM is taking on additional meaning, and so maybe it's better
to split that meaning up right from the start.


> +
> +	if (!vaddr_pin || (!vaddr_pin->mm && !vaddr_pin->f_owner))
> +		return -EINVAL;
> +
> +	ret = __gup_longterm_locked(current,
> +				    vaddr_pin->mm,
> +				    addr, nr_pages,
> +				    pages, NULL, gup_flags,
> +				    vaddr_pin);
> +	return ret;
> +}
> +EXPORT_SYMBOL(vaddr_pin_pages);
> +
> +/**
> + * vaddr_unpin_pages_dirty_lock - counterpart to vaddr_pin_pages
> + *
> + * @pages, array of pages returned
> + * @nr_pages, number of pages in pages
> + * @vaddr_pin, same information passed to vaddr_pin_pages
> + * @make_dirty: whether to mark the pages dirty
> + *
> + * The semantics are similar to put_user_pages_dirty_lock but a vaddr_pin used
> + * in vaddr_pin_pages should be passed back into this call for propper

Typo:
                                                                  proper

> + * tracking.
> + */
> +void vaddr_unpin_pages_dirty_lock(struct page **pages, unsigned long nr_pages,
> +				  struct vaddr_pin *vaddr_pin, bool make_dirty)
> +{
> +	__put_user_pages_dirty_lock(vaddr_pin, pages, nr_pages, make_dirty);
> +}
> +EXPORT_SYMBOL(vaddr_unpin_pages_dirty_lock);
> 

OK, whew, I'm glad to see the updated _dirty_lock() API used here. :)

thanks,
-- 
John Hubbard
NVIDIA
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
