Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E89F221954092
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 04:10:48 -0700 (PDT)
Date: Tue, 25 Apr 2017 13:10:43 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] dax: fix data corruption due to stale mmap reads
Message-ID: <20170425111043.GH2793@quack2.suse.cz>
References: <20170420191446.GA21694@linux.intel.com>
 <20170421034437.4359-1-ross.zwisler@linux.intel.com>
 <20170421034437.4359-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170421034437.4359-2-ross.zwisler@linux.intel.com>
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
Cc: Latchesar Ionkov <lucho@ionkov.net>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, linux-cifs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Eric Van Hensbergen <ericvh@gmail.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, v9fs-developer@lists.sourceforge.net, Jens Axboe <axboe@kernel.dk>, linux-nfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Alexey Kuznetsov <kuznet@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, Ron Minnich <rminnich@sandia.gov>, Andrew Morton <akpm@linux-foundation.org>, Anna Schumaker <anna.schumaker@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 20-04-17 21:44:37, Ross Zwisler wrote:
> Users of DAX can suffer data corruption from stale mmap reads via the
> following sequence:
> 
> - open an mmap over a 2MiB hole
> 
> - read from a 2MiB hole, faulting in a 2MiB zero page
> 
> - write to the hole with write(3p).  The write succeeds but we incorrectly
>   leave the 2MiB zero page mapping intact.
> 
> - via the mmap, read the data that was just written.  Since the zero page
>   mapping is still intact we read back zeroes instead of the new data.
> 
> We fix this by unconditionally calling invalidate_inode_pages2_range() in
> dax_iomap_actor() for new block allocations, and by enhancing
> __dax_invalidate_mapping_entry() so that it properly unmaps the DAX entry
> being removed from the radix tree.
> 
> This is based on an initial patch from Jan Kara.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
> Reported-by: Jan Kara <jack@suse.cz>
> Cc: <stable@vger.kernel.org>    [4.10+]
> ---
>  fs/dax.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 166504c..3f445d5 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -468,23 +468,35 @@ static int __dax_invalidate_mapping_entry(struct address_space *mapping,
>  					  pgoff_t index, bool trunc)
>  {
>  	int ret = 0;
> -	void *entry;
> +	void *entry, **slot;
>  	struct radix_tree_root *page_tree = &mapping->page_tree;
>  
>  	spin_lock_irq(&mapping->tree_lock);
> -	entry = get_unlocked_mapping_entry(mapping, index, NULL);
> +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
>  	if (!entry || !radix_tree_exceptional_entry(entry))
>  		goto out;
>  	if (!trunc &&
>  	    (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
>  	     radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE)))
>  		goto out;
> +
> +	/*
> +	 * Make sure 'entry' remains valid while we drop mapping->tree_lock to
> +	 * do the unmap_mapping_range() call.
> +	 */
> +	entry = lock_slot(mapping, slot);

This also stops page faults from mapping the entry again. Maybe worth
mentioning here as well.

> +	spin_unlock_irq(&mapping->tree_lock);
> +
> +	unmap_mapping_range(mapping, (loff_t)index << PAGE_SHIFT,
> +			(loff_t)PAGE_SIZE << dax_radix_order(entry), 0);

Ouch, unmapping entry-by-entry may get quite expensive if you are unmapping
large ranges - each unmap means an rmap walk... Since this is a data
corruption class of bug, let's fix it this way for now but I think we'll
need to improve this later.

E.g. what if we called unmap_mapping_range() for the whole invalidated
range after removing the radix tree entries?

Hum, but now thinking more about it I have hard time figuring out why write
vs fault cannot actually still race:

CPU1 - write(2)				CPU2 - read fault

					dax_iomap_pte_fault()
					  ->iomap_begin() - sees hole
dax_iomap_rw()
  iomap_apply()
    ->iomap_begin - allocates blocks
    dax_iomap_actor()
      invalidate_inode_pages2_range()
        - there's nothing to invalidate
					  grab_mapping_entry()
					  - we add zero page in the radix
					    tree & map it to page tables

Similarly read vs write fault may end up racing in a wrong way and try to
replace already existing exceptional entry with a hole page?

								Honza
> +
> +	spin_lock_irq(&mapping->tree_lock);
>  	radix_tree_delete(page_tree, index);
>  	mapping->nrexceptional--;
>  	ret = 1;
>  out:
> -	put_unlocked_mapping_entry(mapping, index, entry);
>  	spin_unlock_irq(&mapping->tree_lock);
> +	dax_wake_mapping_entry_waiter(mapping, index, entry, true);
>  	return ret;
>  }
>  /*
> @@ -999,11 +1011,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		return -EIO;
>  
>  	/*
> -	 * Write can allocate block for an area which has a hole page mapped
> -	 * into page tables. We have to tear down these mappings so that data
> -	 * written by write(2) is visible in mmap.
> +	 * Write can allocate block for an area which has a hole page or zero
> +	 * PMD entry in the radix tree.  We have to tear down these mappings so
> +	 * that data written by write(2) is visible in mmap.
>  	 */
> -	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {
> +	if (iomap->flags & IOMAP_F_NEW) {
>  		invalidate_inode_pages2_range(inode->i_mapping,
>  					      pos >> PAGE_SHIFT,
>  					      (end - 1) >> PAGE_SHIFT);
> -- 
> 2.9.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
