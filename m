Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4898B1A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 13:48:13 -0700 (PDT)
Date: Wed, 29 Jun 2016 22:47:34 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] dax: Clear dirty entry tags on cache flush
Message-ID: <20160629204734.GE16831@quack2.suse.cz>
References: <1466523915-14644-1-git-send-email-jack@suse.cz>
 <1466523915-14644-4-git-send-email-jack@suse.cz>
 <20160628213857.GA15457@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160628213857.GA15457@linux.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 28-06-16 15:38:57, Ross Zwisler wrote:
> On Tue, Jun 21, 2016 at 05:45:15PM +0200, Jan Kara wrote:
> > Currently we never clear dirty tags in DAX mappings and thus address
> > ranges to flush accumulate. Now that we have locking of radix tree
> > entries, we have all the locking necessary to reliably clear the radix
> > tree dirty tag when flushing caches for corresponding address range.
> > Similarly to page_mkclean() we also have to write-protect pages to get a
> > page fault when the page is next written to so that we can mark the
> > entry dirty again.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I think we still have a race where we can end up with a writeable PTE but a
> clean DAX radix tree entry.  Here is the flow:
> 
> Thread 1					Thread 2
> ======== 					========
> wp_pfn_shared()
>   dax_pfn_mkwrite()
>     get_unlocked_mapping_entry()
>     radix_tree_tag_set(DIRTY)
>     put_unlocked_mapping_entry()
> 						dax_writeback_one()
> 						  lock_slot()
> 						  radix_tree_tag_clear(TOWRITE)
> 						  dax_mapping_entry_mkclean()
> 						  wb_cache_pmem()
> 						  radix_tree_tag_clear(DIRTY)
> 						  put_locked_mapping_entry()
>   wp_page_reuse()
>     maybe_mkwrite()
> 
> When this ends the radix tree entry will have been written back and the
> TOWRITE and DIRTY radix tree tags will have been cleared, but the PTE will be
> writeable due to the last maybe_mkwrite() call.  This will result in no new
> dax_pfn_mkwrite() calls happening to re-dirty the radix tree entry.

Good point, thanks for spotting this! There are several ways to fix this -
one is the callback you suggest below but I don't like that much. Another
is returning VM_FAULT_DAX_LOCKED as we do for cow faults handle that
properly in page_mkwrite() paths. Finally, we could just handle PTE changes
within the pfn_mkwrite() handler like we already do for the ->fault path
and thus keep the locking private to DAX code. I'm not yet decided what's
best. I'll think about it.

> Essentially the problem is that we don't hold any locks through all the work
> done by wp_pfn_shared() so that we can do maybe_mkwrite() safely.
> 
> Perhaps we can lock the radix tree slot in dax_pfn_mkwrite(), then have
> another callback into DAX after the wp_page_reuse() => maybe_mkwrite() to
> unlock the slot?  This would guarantee that they happen together from DAX's
> point of view.
> 
> Thread 1's flow would then be:
> 
> Thread 1
> ========
> wp_pfn_shared()
>   dax_pfn_mkwrite()
>     lock_slot()
>     radix_tree_tag_set(DIRTY)
>   wp_page_reuse()
>     maybe_mkwrite()
>     new_dax_call_to_unlock_slot()
>       put_unlocked_mapping_entry()
> 
> > ---
> >  fs/dax.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 68 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 5209f8cd0bee..c0c4eecb5f73 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/vmstat.h>
> >  #include <linux/pfn_t.h>
> >  #include <linux/sizes.h>
> > +#include <linux/mmu_notifier.h>
> >  
> >  /*
> >   * We use lowest available bit in exceptional entry for locking, other two
> > @@ -665,6 +666,59 @@ static void *dax_insert_mapping_entry(struct address_space *mapping,
> >  	return new_entry;
> >  }
> >  
> > +static inline unsigned long
> > +pgoff_address(pgoff_t pgoff, struct vm_area_struct *vma)
> > +{
> > +	unsigned long address;
> > +
> > +	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
> > +	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
> > +	return address;
> > +}
> > +
> > +/* Walk all mappings of a given index of a file and writeprotect them */
> > +static void dax_mapping_entry_mkclean(struct address_space *mapping,
> > +				      pgoff_t index, unsigned long pfn)
> > +{
> > +	struct vm_area_struct *vma;
> > +	pte_t *ptep;
> > +	pte_t pte;
> > +	spinlock_t *ptl;
> > +	bool changed;
> > +
> > +	i_mmap_lock_read(mapping);
> > +	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
> > +		unsigned long address;
> > +
> > +		cond_resched();
> 
> Do we really need to cond_resched() between every PTE clean?  Maybe it would
> be better to cond_resched() after each call to dax_writeback_one() in
> dax_writeback_mapping_range() or something so we can be sure we've done a good
> amount of work between each?

This is copied over from rmap code and I'd prefer to keep the code similar.
Note that cond_resched() does not mean we are going to reschedule. It is
pretty cheap call and we will be rescheduled only if we have used our CPU
slice...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
