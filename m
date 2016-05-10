Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E18AE1A1F50
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 05:27:20 -0700 (PDT)
Date: Tue, 10 May 2016 14:27:15 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 16/18] dax: New fault locking
Message-ID: <20160510122715.GK11897@quack2.suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-17-git-send-email-jack@suse.cz>
 <20160506041350.GA29628@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20160506041350.GA29628@linux.intel.com>
Content-Disposition: inline
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 05-05-16 22:13:50, Ross Zwisler wrote:
> On Mon, Apr 18, 2016 at 11:35:39PM +0200, Jan Kara wrote:
> >  /*
> > + * DAX radix tree locking
> > + */
> > +struct exceptional_entry_key {
> > +	struct radix_tree_root *root;
> > +	unsigned long index;
> > +};
> 
> I believe that we basically just need the struct exceptional_entry_key to
> uniquely identify an entry, correct?  I agree that we get this with the pair
> [struct radix_tree_root, index], but we also get it with
> [struct address_space, index], and we might want to use the latter here since
> that's the pair that is used to look up the wait queue in
> dax_entry_waitqueue().  Functionally I don't think it matters (correct me if
> I'm wrong), but it makes for a nicer symmetry.

OK, makes sense. Changed.

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
> > +	ret = get_unlocked_mapping_entry(mapping, index, &slot);
> > +	/* No entry for given index? Make sure radix tree is big enough. */
> > +	if (!ret) {
> > +		int err;
> > +
> > +		spin_unlock_irq(&mapping->tree_lock);
> > +		err = radix_tree_preload(
> > +				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
> 
> In the conversation about v2 of this series you said:
> 
> > Note that we take the hit for dropping the lock only if we really need to
> > allocate new radix tree node so about once per 64 new entries. So it is not
> > too bad.
> 
> I think this is incorrect.  We get here whenever we get a NULL return from
> __radix_tree_lookup().  I believe that this happens if we don't have a node,
> in which case we need an allocation, but I think it also happens in the case
> where we do have a node and we just have a NULL slot in that node.
> 
> For the behavior you're looking for (only preload if you need to do an
> allocation), you probably need to check the 'slot' we get back from
> get_unlocked_mapping_entry(), yea?

You are correct. However currently __radix_tree_lookup() doesn't return a
slot pointer if entry was not found so it is not easy to fix. So I'd leave
the code as is for now and we can later optimize the case where we don't
need to grow the radix tree...

> 
> > +/*
> > + * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
> > + * entry to get unlocked before deleting it.
> > + */
> > +int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index)
> > +{
> > +	void *entry;
> > +
> > +	spin_lock_irq(&mapping->tree_lock);
> > +	entry = get_unlocked_mapping_entry(mapping, index, NULL);
> > +	/*
> > +	 * Caller should make sure radix tree modifications don't race and
> > +	 * we have seen exceptional entry here before.
> > +	 */
> > +	if (WARN_ON_ONCE(!entry || !radix_tree_exceptional_entry(entry))) {
> 
> dax_delete_mapping_entry() is only called from clear_exceptional_entry().
> With this new code we've changed the behavior of that call path a little.
> 
> In the various places where clear_exceptional_entry() is called, the code
> batches up a bunch of entries in a pvec via pagevec_lookup_entries().  We
> don't hold the mapping->tree_lock between the time this lookup happens and the
> time that the entry is passed to clear_exceptional_entry(). This is why the
> old code did a verification that the entry passed in matched what was still
> currently present in the radix tree.  This was done in the DAX case via
> radix_tree_delete_item(), and it was open coded in clear_exceptional_entry()
> for the page cache case.  In both cases if the entry didn't match what was
> currently in the tree, we bailed without doing anything.
> 
> This new code doesn't verify against the 'entry' passed to
> clear_exceptional_entry(), but instead makes sure it is an exceptional entry
> before removing, and if not it does a WARN_ON_ONCE().
> 
> This changes things because:
> 
> a) If the exceptional entry changed, say from a plain lock entry to an actual
> DAX entry, we wouldn't notice, and we would just clear the latter out.  My
> guess is that this is fine, I just wanted to call it out.
> 
> b) If we have a non-exceptional entry here now, say because our lock entry has
> been swapped out for a zero page, we will WARN_ON_ONCE() and return without a
> removal.  I think we may want to silence the WARN_ON_ONCE(), as I believe this
> could happen during normal operation and we don't want to scare anyone. :)

So your concerns are exactly why I have added a comment to
dax_delete_mapping_entry() that:

	/*
	 * Caller should make sure radix tree modifications don't race and
	 * we have seen exceptional entry here before.
	 */

The thing is dax_delete_mapping_entry() is called only from truncate /
punch hole path. Those should hold i_mmap_sem for writing and thus there
should be no modifications of the radix tree. If anything changes, between
what truncate_inode_pages() (or similar functions) finds and what
dax_delete_mapping_entry() sees, we have a locking bug and I want to know
about it :). Any suggestion how I should expand the comment so that this is
clearer?

> > +/*
> >   * The user has performed a load from a hole in the file.  Allocating
> >   * a new page in the file would cause excessive storage usage for
> >   * workloads with sparse files.  We allocate a page cache page instead.
> > @@ -307,15 +584,24 @@ EXPORT_SYMBOL_GPL(dax_do_io);
> >   * otherwise it will simply fall out of the page cache under memory
> >   * pressure without ever having been dirtied.
> >   */
> > -static int dax_load_hole(struct address_space *mapping, struct page *page,
> > -							struct vm_fault *vmf)
> > +static int dax_load_hole(struct address_space *mapping, void *entry,
> > +			 struct vm_fault *vmf)
> >  {
> > -	if (!page)
> > -		page = find_or_create_page(mapping, vmf->pgoff,
> > -						GFP_KERNEL | __GFP_ZERO);
> > -	if (!page)
> > -		return VM_FAULT_OOM;
> > +	struct page *page;
> > +
> > +	/* Hole page already exists? Return it...  */
> > +	if (!radix_tree_exceptional_entry(entry)) {
> > +		vmf->page = entry;
> > +		return VM_FAULT_LOCKED;
> > +	}
> >  
> > +	/* This will replace locked radix tree entry with a hole page */
> > +	page = find_or_create_page(mapping, vmf->pgoff,
> > +				   vmf->gfp_mask | __GFP_ZERO);
> 
> This replacement happens via page_cache_tree_insert(), correct?  In this case,
> who wakes up anyone waiting on the old lock entry that we just killed?  In the
> non-hole case we would traverse through put_locked_mapping_entry(), but I
> don't see that in the hole case.

Ha, good catch. We miss the wakeup. Fixed.

Attached is the diff resulting from your review of this patch. I still have
to hunt down that strange interaction with workingset code you've reported...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
