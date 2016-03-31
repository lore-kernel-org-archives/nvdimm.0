Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FCA11A1F75
 for <linux-nvdimm@lists.01.org>; Mon,  4 Apr 2016 01:34:13 -0700 (PDT)
Date: Thu, 31 Mar 2016 18:27:30 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 08/10] dax: New fault locking
Message-ID: <20160331162730.GB10434@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-9-git-send-email-jack@suse.cz>
 <20160329215732.GA21264@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329215732.GA21264@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Thanks for review Ross! I have implemented your comments unless I state
here otherwise.

On Tue 29-03-16 15:57:32, Ross Zwisler wrote:
> On Mon, Mar 21, 2016 at 02:22:53PM +0100, Jan Kara wrote:
> > +	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
> > +
> > +	init_wait(&wait.wait);
> > +	wait.wait.func = wake_exceptional_entry_func;
> > +	wait.key.root = &mapping->page_tree;
> > +	wait.key.index = index;
> > +
> > +	for (;;) {
> > +		ret = __radix_tree_lookup(&mapping->page_tree, index, NULL,
> > +					  &slot);
> > +		if (!ret || !radix_tree_exceptional_entry(ret) ||
> > +		    !slot_locked(slot)) {
> > +			if (slotp)
> > +				*slotp = slot;
> > +			return ret;
> > +		}
> > +		prepare_to_wait_exclusive(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
> 
> Should we make this TASK_INTERRUPTIBLE so we don't end up with an unkillable
> zombie?

Well, and do you want to deal with signal handling all the way up? The wait
should be pretty short given the nature of pmem so I didn't see a big point
in bothering with signal handling...

> > +		spin_unlock_irq(&mapping->tree_lock);
> > +		schedule();
> > +		finish_wait(wq, &wait.wait);
> > +		spin_lock_irq(&mapping->tree_lock);
> > +	}
> > +}
> > +
> > +/*
> > + * Find radix tree entry at given index. If it points to a page, return with
> > + * the page locked. If it points to the exceptional entry, return with the
> > + * radix tree entry locked. If the radix tree doesn't contain given index,
> > + * create empty exceptional entry for the index and return with it locked.
> > + *
> > + * Note: Unlike filemap_fault() we don't honor FAULT_FLAG_RETRY flags. For
> > + * persistent memory the benefit is doubtful. We can add that later if we can
> > + * show it helps.
> > + */
> > +static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index)
> > +{
> > +	void *ret, **slot;
> > +
> > +restart:
> > +	spin_lock_irq(&mapping->tree_lock);
> > +	ret = lookup_unlocked_mapping_entry(mapping, index, &slot);
> > +	/* No entry for given index? Make sure radix tree is big enough. */
> > +	if (!ret) {
> > +		int err;
> > +
> > +		spin_unlock_irq(&mapping->tree_lock);
> > +		err = radix_tree_preload(
> > +				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
> 
> What is the benefit to preloading the radix tree?  It looks like we have
> to drop the mapping->tree_lock, deal with an error, regrab the lock and
> then deal with a possible collision with an entry that was inserted while
> we didn't hold the lock.
> 
> Can we just try and insert it, then if it fails with -ENOMEM we just do
> our normal error path, dropping the tree_lock and returning the error?

If we don't preload, the allocations will happen with GFP_ATOMIC. That
should be avoided if possible since atomic allocations are pretty
restricted. So basically all the pagecache first allocates nodes we may
need before acquiring locks and then uses these nodes later and I have
mirrored that behavior. Note that we take the hit for dropping the lock
only if we really need to allocate new radix tree node so about once per 64
new entries. So it is not too bad.

> > -	WARN_ON_ONCE(pmd_entry && !dirty);
> >  	if (dirty)
> >  		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >  
> > -	spin_lock_irq(&mapping->tree_lock);
> > -
> > -	entry = radix_tree_lookup(page_tree, pmd_index);
> > -	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD) {
> > -		index = pmd_index;
> > -		goto dirty;
> > +	/* Replacing hole page with block mapping? */
> > +	if (!radix_tree_exceptional_entry(entry)) {
> > +		hole_fill = true;
> > +		error = radix_tree_preload(gfp_mask);
> > +		if (error)
> > +			return ERR_PTR(error);
> >  	}
> >  
> > -	entry = radix_tree_lookup(page_tree, index);
> > -	if (entry) {
> > -		type = RADIX_DAX_TYPE(entry);
> > -		if (WARN_ON_ONCE(type != RADIX_DAX_PTE &&
> > -					type != RADIX_DAX_PMD)) {
> > -			error = -EIO;
> > +	spin_lock_irq(&mapping->tree_lock);
> > +	ret = (void *)((unsigned long)RADIX_DAX_ENTRY(sector, false) |
> > +		       DAX_ENTRY_LOCK);
> > +	if (hole_fill) {
> > +		__delete_from_page_cache(entry, NULL);
> > +		error = radix_tree_insert(page_tree, index, ret);
> > +		if (error) {
> > +			ret = ERR_PTR(error);
> >  			goto unlock;
> >  		}
> > +		mapping->nrexceptional++;
> > +	} else {
> > +		void **slot;
> > +		void *ret2;
> >  
> > -		if (!pmd_entry || type == RADIX_DAX_PMD)
> > -			goto dirty;
> > -
> > -		/*
> > -		 * We only insert dirty PMD entries into the radix tree.  This
> > -		 * means we don't need to worry about removing a dirty PTE
> > -		 * entry and inserting a clean PMD entry, thus reducing the
> > -		 * range we would flush with a follow-up fsync/msync call.
> > -		 */
> > -		radix_tree_delete(&mapping->page_tree, index);
> > -		mapping->nrexceptional--;
> > -	}
> > -
> > -	if (sector == NO_SECTOR) {
> > -		/*
> > -		 * This can happen during correct operation if our pfn_mkwrite
> > -		 * fault raced against a hole punch operation.  If this
> > -		 * happens the pte that was hole punched will have been
> > -		 * unmapped and the radix tree entry will have been removed by
> > -		 * the time we are called, but the call will still happen.  We
> > -		 * will return all the way up to wp_pfn_shared(), where the
> > -		 * pte_same() check will fail, eventually causing page fault
> > -		 * to be retried by the CPU.
> > -		 */
> > -		goto unlock;
> > +		ret2 = __radix_tree_lookup(page_tree, index, NULL, &slot);
> 
> You don't need ret2.  You can just compare 'entry' with '*slot' - see
> dax_writeback_one() for an example.

Hum, but if we want to do this cleanly (and get all the lockdep
verification), we should use

radix_tree_deref_slot_protected(slot, &mapping->tree_lock)

instead of *slot. And at that point my fingers hurt so much that I just
create a new variable for caching the result ;). BTW, this has prompted me
to also fix lock_slot, unlock_slot, slot_locked to use proper RCU
primitives for modifying slot contents.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
