Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 470A51A1ED2
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 14:58:33 -0700 (PDT)
Date: Tue, 29 Mar 2016 15:57:32 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 08/10] dax: New fault locking
Message-ID: <20160329215732.GA21264@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-9-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-9-git-send-email-jack@suse.cz>
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

On Mon, Mar 21, 2016 at 02:22:53PM +0100, Jan Kara wrote:
> Currently DAX page fault locking is racy.
> 
> CPU0 (write fault)		CPU1 (read fault)
> 
> __dax_fault()			__dax_fault()
>   get_block(inode, block, &bh, 0) -> not mapped
> 				  get_block(inode, block, &bh, 0)
> 				    -> not mapped
>   if (!buffer_mapped(&bh))
>     if (vmf->flags & FAULT_FLAG_WRITE)
>       get_block(inode, block, &bh, 1) -> allocates blocks
>   if (page) -> no
> 				  if (!buffer_mapped(&bh))
> 				    if (vmf->flags & FAULT_FLAG_WRITE) {
> 				    } else {
> 				      dax_load_hole();
> 				    }
>   dax_insert_mapping()
> 
> And we are in a situation where we fail in dax_radix_entry() with -EIO.
> 
> Another problem with the current DAX page fault locking is that there is
> no race-free way to clear dirty tag in the radix tree. We can always
> end up with clean radix tree and dirty data in CPU cache.
> 
> We fix the first problem by introducing locking of exceptional radix
> tree entries in DAX mappings acting very similarly to page lock and thus
> synchronizing properly faults against the same mapping index. The same
> lock can later be used to avoid races when clearing radix tree dirty
> tag.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I've got lots of little comments, but from my point of view this seems like
it is looking pretty good.  I agree with the choice to put this in dax.c as
opposed to radix-tree.c or something - this seems very DAX specific for now.

> ---
>  fs/dax.c            | 500 ++++++++++++++++++++++++++++++++++++++--------------
>  include/linux/dax.h |   1 +
>  mm/truncate.c       |  62 ++++---
>  3 files changed, 396 insertions(+), 167 deletions(-)
<>
> +static inline int slot_locked(void **v)
> +{
> +	unsigned long l = *(unsigned long *)v;
> +	return l & DAX_ENTRY_LOCK;
> +}
> +
> +static inline void *lock_slot(void **v)
> +{
> +	unsigned long *l = (unsigned long *)v;
> +	return (void*)(*l |= DAX_ENTRY_LOCK);
> +}
> +
> +static inline void *unlock_slot(void **v)
> +{
> +	unsigned long *l = (unsigned long *)v;
> +	return (void*)(*l &= ~(unsigned long)DAX_ENTRY_LOCK);
> +}

For the above three helpers I think we could do with better parameter and
variable naming so it's clearer what's going on.  s/v/slot/ and s/l/entry/ ?

Also, for many of these new functions we need to be holding
mapping->tree_lock - can we quickly document that with comments?

> +/*
> + * Lookup entry in radix tree, wait for it to become unlocked if it is
> + * exceptional entry and return.
> + *
> + * The function must be called with mapping->tree_lock held.
> + */
> +static void *lookup_unlocked_mapping_entry(struct address_space *mapping,
> +					   pgoff_t index, void ***slotp)
> +{
> +	void *ret, **slot;
> +	struct wait_exceptional_entry_queue wait;

This should probably be named 'ewait' to be consistent with
wake_exceptional_entry_func(), and so we have a different and consistent
naming between our struct wait_exceptional_entry_queue and wait_queue_t
variables.

> +	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
> +
> +	init_wait(&wait.wait);
> +	wait.wait.func = wake_exceptional_entry_func;
> +	wait.key.root = &mapping->page_tree;
> +	wait.key.index = index;
> +
> +	for (;;) {
> +		ret = __radix_tree_lookup(&mapping->page_tree, index, NULL,
> +					  &slot);
> +		if (!ret || !radix_tree_exceptional_entry(ret) ||
> +		    !slot_locked(slot)) {
> +			if (slotp)
> +				*slotp = slot;
> +			return ret;
> +		}
> +		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);

Should we make this TASK_INTERRUPTIBLE so we don't end up with an unkillable
zombie?

> +		spin_unlock_irq(&mapping->tree_lock);
> +		schedule();
> +		finish_wait(wq, &wait.wait);
> +		spin_lock_irq(&mapping->tree_lock);
> +	}
> +}
> +
> +/*
> + * Find radix tree entry at given index. If it points to a page, return with
> + * the page locked. If it points to the exceptional entry, return with the
> + * radix tree entry locked. If the radix tree doesn't contain given index,
> + * create empty exceptional entry for the index and return with it locked.
> + *
> + * Note: Unlike filemap_fault() we don't honor FAULT_FLAG_RETRY flags. For
> + * persistent memory the benefit is doubtful. We can add that later if we can
> + * show it helps.
> + */
> +static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index)
> +{
> +	void *ret, **slot;
> +
> +restart:
> +	spin_lock_irq(&mapping->tree_lock);
> +	ret = lookup_unlocked_mapping_entry(mapping, index, &slot);
> +	/* No entry for given index? Make sure radix tree is big enough. */
> +	if (!ret) {
> +		int err;
> +
> +		spin_unlock_irq(&mapping->tree_lock);
> +		err = radix_tree_preload(
> +				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);

What is the benefit to preloading the radix tree?  It looks like we have to
drop the mapping->tree_lock, deal with an error, regrab the lock and then deal
with a possible collision with an entry that was inserted while we didn't hold
the lock.

Can we just try and insert it, then if it fails with -ENOMEM we just do our
normal error path, dropping the tree_lock and returning the error?

> +		if (err)
> +			return ERR_PTR(err);
> +		ret = (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY | DAX_ENTRY_LOCK);
> +		spin_lock_irq(&mapping->tree_lock);
> +		err = radix_tree_insert(&mapping->page_tree, index, ret);
> +		radix_tree_preload_end();
> +		if (err) {
> +			spin_unlock_irq(&mapping->tree_lock);
> +			/* Someone already created the entry? */
> +			if (err == -EEXIST)
> +				goto restart;
> +			return ERR_PTR(err);
> +		}
> +		/* Good, we have inserted empty locked entry into the tree. */
> +		mapping->nrexceptional++;
> +		spin_unlock_irq(&mapping->tree_lock);
> +		return ret;
> +	}
> +	/* Normal page in radix tree? */
> +	if (!radix_tree_exceptional_entry(ret)) {
> +		struct page *page = ret;
> +
> +		page_cache_get(page);
> +		spin_unlock_irq(&mapping->tree_lock);
> +		lock_page(page);
> +		/* Page got truncated? Retry... */
> +		if (unlikely(page->mapping != mapping)) {
> +			unlock_page(page);
> +			page_cache_release(page);
> +			goto restart;
> +		}
> +		return page;
> +	}
> +	ret = lock_slot(slot);
> +	spin_unlock_irq(&mapping->tree_lock);
> +	return ret;
> +}
> +
> +static void unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
> +{
> +	void *ret, **slot;
> +	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
> +
> +	spin_lock_irq(&mapping->tree_lock);
> +	ret = __radix_tree_lookup(&mapping->page_tree, index, NULL, &slot);
> +	if (WARN_ON_ONCE(!ret || !radix_tree_exceptional_entry(ret))) {
> +		spin_unlock_irq(&mapping->tree_lock);
> +		return;
> +	}
> +	if (WARN_ON_ONCE(!slot_locked(slot))) {
> +		spin_unlock_irq(&mapping->tree_lock);
> +		return;
> +	}

It may be worth combining these two WARN_ON_ONCE() error cases for brevity,
since they are both insanity conditions.

> +	unlock_slot(slot);
> +	spin_unlock_irq(&mapping->tree_lock);
> +	if (waitqueue_active(wq)) {
> +		struct exceptional_entry_key key;
> +
> +		key.root = &mapping->page_tree;
> +		key.index = index;
> +		__wake_up(wq, TASK_NORMAL, 1, &key);
> +	}

The above if() block is repeated 3 times in the next few functions with small
variations (the third argument to __wake_up()).  Perhaps it should be pulled
out into a helper?

> +static void *dax_mapping_entry(struct address_space *mapping, pgoff_t index,
> +			       void *entry, sector_t sector, bool dirty,
> +			       gfp_t gfp_mask)

This argument list is getting pretty long, and our one caller gets lots of
these guys out of the VMF.  Perhaps we could just pass in the VMF and extract
the bits ourselves?

>  {
>  	struct radix_tree_root *page_tree = &mapping->page_tree;
> -	pgoff_t pmd_index = DAX_PMD_INDEX(index);
> -	int type, error = 0;
> -	void *entry;
> +	int error = 0;
> +	bool hole_fill = false;
> +	void *ret;

Just a nit, but I find the use of 'ret' a bit confusing, since it's not a
return value that we got from anywhere, it's an entry that we set up, insert
and then return to our caller.  We use 'error' to capture return values from
calls this function makes.  Maybe this would be clearer as "new_entry" or
something?

> -	WARN_ON_ONCE(pmd_entry && !dirty);
>  	if (dirty)
>  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
>  
> -	spin_lock_irq(&mapping->tree_lock);
> -
> -	entry = radix_tree_lookup(page_tree, pmd_index);
> -	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
> -		index = pmd_index;
> -		goto dirty;
> +	/* Replacing hole page with block mapping? */
> +	if (!radix_tree_exceptional_entry(entry)) {
> +		hole_fill = true;
> +		error = radix_tree_preload(gfp_mask);
> +		if (error)
> +			return ERR_PTR(error);
>  	}
>  
> -	entry = radix_tree_lookup(page_tree, index);
> -	if (entry) {
> -		type = RADIX_DAX_TYPE(entry);
> -		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
> -					type != RADIX_DAX_PMD)) {
> -			error = -EIO;
> +	spin_lock_irq(&mapping->tree_lock);
> +	ret = (void *)((unsigned long)RADIX_DAX_ENTRY(sector, false) |
> +		       DAX_ENTRY_LOCK);
> +	if (hole_fill) {
> +		__delete_from_page_cache(entry, NULL);
> +		error = radix_tree_insert(page_tree, index, ret);
> +		if (error) {
> +			ret = ERR_PTR(error);
>  			goto unlock;
>  		}
> +		mapping->nrexceptional++;
> +	} else {
> +		void **slot;
> +		void *ret2;
>  
> -		if (!pmd_entry || type == RADIX_DAX_PMD)
> -			goto dirty;
> -
> -		/*
> -		 * We only insert dirty PMD entries into the radix tree.  This
> -		 * means we don't need to worry about removing a dirty PTE
> -		 * entry and inserting a clean PMD entry, thus reducing the
> -		 * range we would flush with a follow-up fsync/msync call.
> -		 */
> -		radix_tree_delete(&mapping->page_tree, index);
> -		mapping->nrexceptional--;
> -	}
> -
> -	if (sector == NO_SECTOR) {
> -		/*
> -		 * This can happen during correct operation if our pfn_mkwrite
> -		 * fault raced against a hole punch operation.  If this
> -		 * happens the pte that was hole punched will have been
> -		 * unmapped and the radix tree entry will have been removed by
> -		 * the time we are called, but the call will still happen.  We
> -		 * will return all the way up to wp_pfn_shared(), where the
> -		 * pte_same() check will fail, eventually causing page fault
> -		 * to be retried by the CPU.
> -		 */
> -		goto unlock;
> +		ret2 = __radix_tree_lookup(page_tree, index, NULL, &slot);

You don't need ret2.  You can just compare 'entry' with '*slot' - see
dax_writeback_one() for an example.

> +		WARN_ON_ONCE(ret2 != entry);
> +		radix_tree_replace_slot(slot, ret);
>  	}
> -
> -	error = radix_tree_insert(page_tree, index,
> -			RADIX_DAX_ENTRY(sector, pmd_entry));
> -	if (error)
> -		goto unlock;
> -
> -	mapping->nrexceptional++;
> - dirty:
>  	if (dirty)
>  		radix_tree_tag_set(page_tree, index, PAGECACHE_TAG_DIRTY);
>   unlock:
>  	spin_unlock_irq(&mapping->tree_lock);
> -	return error;
> +	if (hole_fill)
> +		radix_tree_preload_end();
> +	return ret;
>  }
>  
>  static int dax_writeback_one(struct block_device *bdev,
> @@ -542,17 +782,18 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  
> -static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
> +static int dax_insert_mapping(struct address_space *mapping,
> +			struct buffer_head *bh, void *entry,
>  			struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	unsigned long vaddr = (unsigned long)vmf->virtual_address;
> -	struct address_space *mapping = inode->i_mapping;
>  	struct block_device *bdev = bh->b_bdev;
>  	struct blk_dax_ctl dax = {
> -		.sector = to_sector(bh, inode),
> +		.sector = to_sector(bh, mapping->host),
>  		.size = bh->b_size,
>  	};
>  	int error;
> +	void *ret;
>  
>  	i_mmap_lock_read(mapping);
>  
> @@ -562,16 +803,26 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>  	}
>  	dax_unmap_atomic(bdev, &dax);
>  
> -	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
> -			vmf->flags & FAULT_FLAG_WRITE);
> -	if (error)
> +	ret = dax_mapping_entry(mapping, vmf->pgoff, entry, dax.sector,
> +			        vmf->flags & FAULT_FLAG_WRITE,
> +			        vmf->gfp_mask & ~__GFP_HIGHMEM);

The spacing before the parameters to dax_mapping_entry() is messed up & makes
checkpatch grumpy:

ERROR: code indent should use tabs where possible
#488: FILE: fs/dax.c:812:
+^I^I^I        vmf->flags & FAULT_FLAG_WRITE,$

ERROR: code indent should use tabs where possible
#489: FILE: fs/dax.c:813:
+^I^I^I        vmf->gfp_mask & ~__GFP_HIGHMEM);$

There are a few other checkpatch warnings as well that should probably be
addressed.

> +	if (IS_ERR(ret)) {
> +		error = PTR_ERR(ret);
>  		goto out;
> +	}
> +	/* Have we replaced hole page? Unmap and free it. */
> +	if (!radix_tree_exceptional_entry(entry)) {
> +		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
> +				    PAGE_CACHE_SIZE, 0);
> +		unlock_page(entry);
> +		page_cache_release(entry);
> +	}
> +	entry = ret;
>  
>  	error = vm_insert_mixed(vma, vaddr, dax.pfn);
> -
>   out:
>  	i_mmap_unlock_read(mapping);
> -
> +	put_locked_mapping_entry(mapping, vmf->pgoff, entry);

Hmm....this entry was locked by our parent (__dax_fault()), and is released by
our parent in error cases that go through 'unlock_entry:'.  For symmetry it's
probably better to move this call up to our parent as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
