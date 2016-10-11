Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EEFBE1A1E98
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 11:42:31 -0700 (PDT)
Date: Tue, 11 Oct 2016 10:31:52 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 15/17] dax: add struct iomap based DAX PMD support
Message-ID: <20161011083152.GG6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-16-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-16-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 07-10-16 15:09:02, Ross Zwisler wrote:
> diff --git a/fs/dax.c b/fs/dax.c
> index ac3cd05..e51d51f 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -281,7 +281,7 @@ static wait_queue_head_t *dax_entry_waitqueue(struct address_space *mapping,
>  	 * queue to the start of that PMD.  This ensures that all offsets in
>  	 * the range covered by the PMD map to the same bit lock.
>  	 */
> -	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> +	if ((unsigned long)entry & RADIX_DAX_PMD)
>  		index &= ~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1);

I agree with Christoph - helper for masking type bits would make this
nicer.

...
> -static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index)
> +static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
> +		unsigned long size_flag)
>  {
> +	bool pmd_downgrade = false; /* splitting 2MiB entry into 4k entries? */
>  	void *entry, **slot;
>  
>  restart:
>  	spin_lock_irq(&mapping->tree_lock);
>  	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> +
> +	if (entry) {
> +		if (size_flag & RADIX_DAX_PMD) {
> +			if (!radix_tree_exceptional_entry(entry) ||
> +			    !((unsigned long)entry & RADIX_DAX_PMD)) {
> +				entry = ERR_PTR(-EEXIST);
> +				goto out_unlock;

You need to call put_unlocked_mapping_entry() if you use
get_unlocked_mapping_entry() and then decide not to lock it. The reason is
that the waitqueues we use are exclusive (we wake up only a single waiter
waiting for the lock) and so there can be some waiters for the entry lock
although we have not locked the entry ourselves.

> +			}
> +		} else { /* trying to grab a PTE entry */
> +			if (radix_tree_exceptional_entry(entry) &&
> +			    ((unsigned long)entry & RADIX_DAX_PMD) &&
> +			    ((unsigned long)entry &
> +			     (RADIX_DAX_HZP|RADIX_DAX_EMPTY))) {
> +				pmd_downgrade = true;
> +			}
> +		}
> +	}
> +
>  	/* No entry for given index? Make sure radix tree is big enough. */
> -	if (!entry) {
> +	if (!entry || pmd_downgrade) {
>  		int err;
>  
> +		if (pmd_downgrade) {
> +			/*
> +			 * Make sure 'entry' remains valid while we drop
> +			 * mapping->tree_lock.
> +			 */
> +			entry = lock_slot(mapping, slot);
> +		}
> +
>  		spin_unlock_irq(&mapping->tree_lock);
>  		err = radix_tree_preload(
>  				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
>  		if (err)
>  			return ERR_PTR(err);

You need to unlock the locked entry before you return here...

> -		entry = (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
> -			       RADIX_DAX_ENTRY_LOCK);
> +
> +		/*
> +		 * Besides huge zero pages the only other thing that gets
> +		 * downgraded are empty entries which don't need to be
> +		 * unmapped.
> +		 */
> +		if (pmd_downgrade && ((unsigned long)entry & RADIX_DAX_HZP))
> +			unmap_mapping_range(mapping,
> +				(index << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
> +
>  		spin_lock_irq(&mapping->tree_lock);
> -		err = radix_tree_insert(&mapping->page_tree, index, entry);
> +
> +		if (pmd_downgrade) {
> +			radix_tree_delete(&mapping->page_tree, index);
> +			mapping->nrexceptional--;
> +			dax_wake_mapping_entry_waiter(mapping, index, entry,
> +					false);

You need to set 'wake_all' argument here to true. Otherwise there could be
waiters waiting for non-existent entry forever...

> +		}
> +
> +		entry = dax_radix_entry(0, size_flag | RADIX_DAX_EMPTY);
> +
> +		err = __radix_tree_insert(&mapping->page_tree, index,
> +				dax_radix_order(entry), entry);
>  		radix_tree_preload_end();
>  		if (err) {
>  			spin_unlock_irq(&mapping->tree_lock);
> -			/* Someone already created the entry? */
> -			if (err == -EEXIST)
> +			/*
> +			 * Someone already created the entry?  This is a
> +			 * normal failure when inserting PMDs in a range
> +			 * that already contains PTEs.  In that case we want
> +			 * to return -EEXIST immediately.
> +			 */
> +			if (err == -EEXIST && !(size_flag & RADIX_DAX_PMD))
>  				goto restart;

Add a comment here that we can get here only if there was no radix tree
entry at 'index' and thus there can be no waiters to wake.

>  			return ERR_PTR(err);
>  		}
> @@ -441,6 +509,7 @@ restart:
>  		return page;
>  	}
>  	entry = lock_slot(mapping, slot);
> + out_unlock:
>  	spin_unlock_irq(&mapping->tree_lock);
>  	return entry;
>  }
> @@ -581,11 +650,17 @@ static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size
>  	return 0;
>  }
>  
> -#define DAX_PMD_INDEX(page_index) (page_index & (PMD_MASK >> PAGE_SHIFT))
> -
> +/*
> + * By this point grab_mapping_entry() has ensured that we have a locked entry
> + * of the appropriate size so we don't have to worry about downgrading PMDs to
> + * PTEs.  If we happen to be trying to insert a PTE and there is a PMD
> + * already in the tree, we will skip the insertion and just dirty the PMD as
> + * appropriate.
> + */
>  static void *dax_insert_mapping_entry(struct address_space *mapping,
>  				      struct vm_fault *vmf,
> -				      void *entry, sector_t sector)
> +				      void *entry, sector_t sector,
> +				      unsigned long flags)
>  {
>  	struct radix_tree_root *page_tree = &mapping->page_tree;
>  	int error = 0;
> @@ -608,22 +683,28 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
>  		error = radix_tree_preload(vmf->gfp_mask & ~__GFP_HIGHMEM);
>  		if (error)
>  			return ERR_PTR(error);
> +	} else if (((unsigned long)entry & RADIX_DAX_HZP) &&
> +			!(flags & RADIX_DAX_HZP)) {
> +		/* replacing huge zero page with PMD block mapping */
> +		unmap_mapping_range(mapping,
> +			(vmf->pgoff << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
>  	}
>  
>  	spin_lock_irq(&mapping->tree_lock);
> -	new_entry = (void *)((unsigned long)RADIX_DAX_ENTRY(sector, false) |
> -		       RADIX_DAX_ENTRY_LOCK);
> +	new_entry = dax_radix_entry(sector, flags);
> +

You've lost the RADIX_DAX_ENTRY_LOCK flag here?

>  	if (hole_fill) {
>  		__delete_from_page_cache(entry, NULL);
>  		/* Drop pagecache reference */
>  		put_page(entry);
> -		error = radix_tree_insert(page_tree, index, new_entry);
> +		error = __radix_tree_insert(page_tree, index,
> +				dax_radix_order(new_entry), new_entry);
>  		if (error) {
>  			new_entry = ERR_PTR(error);
>  			goto unlock;
>  		}
>  		mapping->nrexceptional++;
> -	} else {
> +	} else if ((unsigned long)entry & (RADIX_DAX_HZP|RADIX_DAX_EMPTY)) {
>  		void **slot;
>  		void *ret;

Uh, why this condition need to change? Is it some protection so that we
don't replace a mapped PMD entry with PTE one?

<snip>

> @@ -1261,4 +1338,186 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	return VM_FAULT_NOPAGE | major;
>  }
>  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> +
> +#ifdef CONFIG_FS_DAX_PMD
> +/*
> + * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
> + * more often than one might expect in the below functions.
> + */
> +#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)

Just out of curiosity: Why the british spelling of 'colour'?

> +
> +static int dax_pmd_insert_mapping(struct vm_area_struct *vma, pmd_t *pmd,
> +		struct vm_fault *vmf, unsigned long address,
> +		struct iomap *iomap, loff_t pos, bool write, void **entryp)
> +{
> +	struct address_space *mapping = vma->vm_file->f_mapping;
> +	struct block_device *bdev = iomap->bdev;
> +	struct blk_dax_ctl dax = {
> +		.sector = dax_iomap_sector(iomap, pos),
> +		.size = PMD_SIZE,
> +	};
> +	long length = dax_map_atomic(bdev, &dax);
> +	void *ret;
> +
> +	if (length < 0) /* dax_map_atomic() failed */
> +		return VM_FAULT_FALLBACK;
> +	if (length < PMD_SIZE)
> +		goto unmap_fallback;
> +	if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)
> +		goto unmap_fallback;
> +	if (!pfn_t_devmap(dax.pfn))
> +		goto unmap_fallback;
> +
> +	dax_unmap_atomic(bdev, &dax);
> +
> +	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, dax.sector,
> +			RADIX_DAX_PMD);
> +	if (IS_ERR(ret))
> +		return VM_FAULT_FALLBACK;
> +	*entryp = ret;
> +
> +	return vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
> +
> + unmap_fallback:
> +	dax_unmap_atomic(bdev, &dax);
> +	return VM_FAULT_FALLBACK;
> +}
> +
> +static int dax_pmd_load_hole(struct vm_area_struct *vma, pmd_t *pmd,
> +		struct vm_fault *vmf, unsigned long address,
> +		struct iomap *iomap, void **entryp)
> +{
> +	struct address_space *mapping = vma->vm_file->f_mapping;
> +	unsigned long pmd_addr = address & PMD_MASK;
> +	struct page *zero_page;
> +	spinlock_t *ptl;
> +	pmd_t pmd_entry;
> +	void *ret;
> +
> +	zero_page = get_huge_zero_page();
> +
> +	if (unlikely(!zero_page))
> +		return VM_FAULT_FALLBACK;
> +
> +	ret = dax_insert_mapping_entry(mapping, vmf, *entryp, 0,
> +			RADIX_DAX_PMD | RADIX_DAX_HZP);
> +	if (IS_ERR(ret))
> +		return VM_FAULT_FALLBACK;
> +	*entryp = ret;
> +
> +	ptl = pmd_lock(vma->vm_mm, pmd);
> +	if (!pmd_none(*pmd)) {
> +		spin_unlock(ptl);
> +		return VM_FAULT_FALLBACK;
> +	}
> +
> +	pmd_entry = mk_pmd(zero_page, vma->vm_page_prot);
> +	pmd_entry = pmd_mkhuge(pmd_entry);
> +	set_pmd_at(vma->vm_mm, pmd_addr, pmd, pmd_entry);
> +	spin_unlock(ptl);
> +	return VM_FAULT_NOPAGE;
> +}
> +
> +int dax_iomap_pmd_fault(struct vm_area_struct *vma, unsigned long address,
> +		pmd_t *pmd, unsigned int flags, struct iomap_ops *ops)
> +{
> +	struct address_space *mapping = vma->vm_file->f_mapping;
> +	unsigned long pmd_addr = address & PMD_MASK;
> +	bool write = flags & FAULT_FLAG_WRITE;
> +	unsigned int iomap_flags = write ? IOMAP_WRITE : 0;
> +	struct inode *inode = mapping->host;
> +	int result = VM_FAULT_FALLBACK;
> +	struct iomap iomap = { 0 };

Why the 0 here? Just empty braces are enough to initialize the structure to
zeros.

> +	pgoff_t size, pgoff;
> +	struct vm_fault vmf;
> +	void *entry;
> +	loff_t pos;
> +	int error;
> +
> +	/* Fall back to PTEs if we're going to COW */
> +	if (write && !(vma->vm_flags & VM_SHARED)) {
> +		split_huge_pmd(vma, pmd, address);
> +		goto fallback;
> +	}
> +
> +	/* If the PMD would extend outside the VMA */
> +	if (pmd_addr < vma->vm_start)
> +		goto fallback;
> +	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
> +		goto fallback;
> +
> +	/*
> +	 * Check whether offset isn't beyond end of file now. Caller is
> +	 * supposed to hold locks serializing us with truncate / punch hole so
> +	 * this is a reliable test.
> +	 */
> +	pgoff = linear_page_index(vma, pmd_addr);
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;

Nitpick - 'size' does not express that this is in pages and rounded up.
Maybe we could have:

	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;

and then use strict inequalities below?


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
