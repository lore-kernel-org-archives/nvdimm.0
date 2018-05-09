Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69A862096AECD
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 05:46:13 -0700 (PDT)
Date: Wed, 9 May 2018 14:46:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/5] radix tree: fix multi-order iteration race
Message-ID: <20180509124611.6hoa743z4qrx6bgc@quack2.suse.cz>
References: <20180503192430.7582-1-ross.zwisler@linux.intel.com>
 <20180503192430.7582-6-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180503192430.7582-6-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 03-05-18 13:24:30, Ross Zwisler wrote:
> Fix a race in the multi-order iteration code which causes the kernel to hit
> a GP fault.  This was first seen with a production v4.15 based kernel
> (4.15.6-300.fc27.x86_64) utilizing a DAX workload which used order 9 PMD
> DAX entries.
> 
> The race has to do with how we tear down multi-order sibling entries when
> we are removing an item from the tree.  Remember for example that an order
> 2 entry looks like this:
> 
> struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]
> 
> where 'entry' is in some slot in the struct radix_tree_node, and the three
> slots following 'entry' contain sibling pointers which point back to
> 'entry.'
> 
> When we delete 'entry' from the tree, we call :
>   radix_tree_delete()
>     radix_tree_delete_item()
>       __radix_tree_delete()
>         replace_slot()
> 
> replace_slot() first removes the siblings in order from the first to the
> last, then at then replaces 'entry' with NULL.  This means that for a brief
> period of time we end up with one or more of the siblings removed, so:
> 
> struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]
> 
> This causes an issue if you have a reader iterating over the slots in the
> tree via radix_tree_for_each_slot() while only under
> rcu_read_lock()/rcu_read_unlock() protection.  This is a common case in
> mm/filemap.c.
> 
> The issue is that when __radix_tree_next_slot() => skip_siblings() tries to
> skip over the sibling entries in the slots, it currently does so with an
> exact match on the slot directly preceding our current slot.  Normally this
> works:
>                                     V preceding slot
> struct radix_tree_node.slots[] = [entry][sibling][sibling][sibling]
>                                             ^ current slot
> 
> This lets you find the first sibling, and you skip them all in order.
> 
> But in the case where one of the siblings is NULL, that slot is skipped and
> then our sibling detection is interrupted:
> 
>                                            V preceding slot
> struct radix_tree_node.slots[] = [entry][NULL][sibling][sibling]
>                                                   ^ current slot
> 
> This means that the sibling pointers aren't recognized since they point all
> the way back to 'entry', so we think that they are normal internal radix
> tree pointers.  This causes us to think we need to walk down to a struct
> radix_tree_node starting at the address of 'entry'.
> 
> In a real running kernel this will crash the thread with a GP fault when
> you try and dereference the slots in your broken node starting at 'entry'.
> 
> We fix this race by fixing the way that skip_siblings() detects sibling
> nodes.  Instead of testing against the preceding slot we instead look for
> siblings via is_sibling_entry() which compares against the position of the
> struct radix_tree_node.slots[] array.  This ensures that sibling entries
> are properly identified, even if they are no longer contiguous with the
> 'entry' they point to.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: CR, Sapthagirish <sapthagirish.cr@intel.com>
> Fixes: commit 148deab223b2 ("radix-tree: improve multiorder iterators")
> Cc: <stable@vger.kernel.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  lib/radix-tree.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index da9e10c827df..43e0cbedc3a0 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -1612,11 +1612,9 @@ static void set_iter_tags(struct radix_tree_iter *iter,
>  static void __rcu **skip_siblings(struct radix_tree_node **nodep,
>  			void __rcu **slot, struct radix_tree_iter *iter)
>  {
> -	void *sib = node_to_entry(slot - 1);
> -
>  	while (iter->index < iter->next_index) {
>  		*nodep = rcu_dereference_raw(*slot);
> -		if (*nodep && *nodep != sib)
> +		if (*nodep && !is_sibling_entry(iter->node, *nodep))
>  			return slot;
>  		slot++;
>  		iter->index = __radix_tree_iter_add(iter, 1);
> @@ -1631,7 +1629,7 @@ void __rcu **__radix_tree_next_slot(void __rcu **slot,
>  				struct radix_tree_iter *iter, unsigned flags)
>  {
>  	unsigned tag = flags & RADIX_TREE_ITER_TAG_MASK;
> -	struct radix_tree_node *node = rcu_dereference_raw(*slot);
> +	struct radix_tree_node *node;
>  
>  	slot = skip_siblings(&node, slot, iter);
>  
> -- 
> 2.14.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
