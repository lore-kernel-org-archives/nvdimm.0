Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 477D41A1EF8
 for <linux-nvdimm@lists.01.org>; Tue, 22 Mar 2016 02:12:30 -0700 (PDT)
Date: Tue, 22 Mar 2016 10:12:32 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/10] radix-tree: make 'indirect' bit available to
 exception entries.
Message-ID: <20160322091232.GD4459@quack.suse.cz>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-3-git-send-email-jack@suse.cz>
 <20160321173458.GO23727@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160321173458.GO23727@linux.intel.com>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, "Wilcox, Matthew R  <matthew.r.wilcox@intel.com>, Jan Kara <jack@suse.cz>, NeilBrown" <neilb@suse.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 21-03-16 13:34:58, Matthew Wilcox wrote:
> I have a patch currently in my tree which has the same effect, but looks
> a little neater:
> 
> diff --git a/lib/radix-tree.c b/lib/radix-tree.c
> index b77c31c..06dfed5 100644
> --- a/lib/radix-tree.c
> +++ b/lib/radix-tree.c
> @@ -70,6 +70,8 @@ struct radix_tree_preload {
>  };
>  static DEFINE_PER_CPU(struct radix_tree_preload, radix_tree_preloads) = { 0, };
>  
> +#define RADIX_TREE_RETRY       ((void *)1)
> +
>  static inline void *ptr_to_indirect(void *ptr)
>  {
>         return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
> @@ -934,7 +936,7 @@ restart:
>                 }
>  
>                 slot = rcu_dereference_raw(node->slots[offset]);
> -               if (slot == NULL)
> +               if ((slot == NULL) || (slot == RADIX_TREE_RETRY))
>                         goto restart;
>                 offset = follow_sibling(node, &slot, offset);
>                 if (!radix_tree_is_indirect_ptr(slot))
> @@ -1443,8 +1455,7 @@ static inline void radix_tree_shrink(struct radix_tree_root *root)
>                  * to force callers to retry.
>                  */
>                 if (!radix_tree_is_indirect_ptr(slot))
> -                       *((unsigned long *)&to_free->slots[0]) |=
> -                                               RADIX_TREE_INDIRECT_PTR;
> +                       to_free->slots[0] = RADIX_TREE_RETRY;
>  
>                 radix_tree_node_free(to_free);
>         }
> 
> What do you think to doing it this way?
> 
> It might be slightly neater to replace the first hunk with this:
> 
> #define RADIX_TREE_RETRY       ((void *)RADIX_TREE_INDIRECT_PTR)
> 
> I also considered putting that define in radix-tree.h instead of
> radix-tree.c, but on the whole I don't think it'll be useful outside
> radix-tree.h.

So after spending over and hour reading radix tree code back and forth (and
also digging into historical versions where stuff is easier to understand) I
think I can finally fully appreciate subtlety of the retry logic ;). And
actually now I think that Neil's variant is buggy because in his case
radix_tree_lookup() could return NULL if it raced with radix_tree_shrink()
for index 0, although there is valid entry at index 0.

Your variant actually doesn't make things much better. See e.g.
mm/filemap.c: find_get_entry()

	pagep = radix_tree_lookup_slot(&mapping->page_tree, offset);
	// pagep points to node that is under RCU freeing
	if (pagep) {
		page = radix_tree_deref_slot(pagep);
		if (unlikely(!page))	// False since
					// RADIX_TREE_INDIRECT_PTR is set
		if (radix_tree_exception(page))	// False - no exeptional bit
		if (!page_cache_get_speculative(page)) // oops...

What we need to do is either to make all radix_tree_deref_slot() callers
check return value immediately with something like radix_tree_deref_retry()
(but that is still prone to hard to debug bugs when someone forgets to call
radix_tree_deref_retry() in some place) or we just give up the idea of
using INDIRECT bit in exceptional entries.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
