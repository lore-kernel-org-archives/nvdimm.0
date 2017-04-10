Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20B84219392F4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 06:41:15 -0700 (PDT)
Date: Mon, 10 Apr 2017 15:41:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: fix radix tree insertion race
Message-ID: <20170410134111.GF3224@quack2.suse.cz>
References: <20170406212944.2866-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170406212944.2866-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 06-04-17 15:29:44, Ross Zwisler wrote:
> While running generic/340 in my test setup I hit the following race. It can
> happen with kernels that support FS DAX PMDs, so v4.10 thru v4.11-rc5.
> 
> Thread 1				Thread 2
> --------				--------
> dax_iomap_pmd_fault()
>   grab_mapping_entry()
>     spin_lock_irq()
>     get_unlocked_mapping_entry()
>     'entry' is NULL, can't call lock_slot()
>     spin_unlock_irq()
>     radix_tree_preload()
> 					dax_iomap_pmd_fault()
> 					  grab_mapping_entry()
> 					    spin_lock_irq()
> 					    get_unlocked_mapping_entry()
> 					    ...
> 					    lock_slot()
> 					    spin_unlock_irq()
> 					  dax_pmd_insert_mapping()
> 					    <inserts a PMD mapping>
>     spin_lock_irq()
>     __radix_tree_insert() fails with -EEXIST
>     <fall back to 4k fault, and die horribly
>      when inserting a 4k entry where a PMD exists>
> 
> The issue is that we have to drop mapping->tree_lock while calling
> radix_tree_preload(), but since we didn't have a radix tree entry to lock
> (unlike in the pmd_downgrade case) we have no protection against Thread 2
> coming along and inserting a PMD at the same index.  For 4k entries we
> handled this with a special-case response to -EEXIST coming from the
> __radix_tree_insert(), but this doesn't save us for PMDs because the
> -EEXIST case can also mean that we collided with a 4k entry in the radix
> tree at a different index, but one that is covered by our PMD range.
> 
> So, correctly handle both the 4k and 2M collision cases by explicitly
> re-checking the radix tree for an entry at our index once we reacquire
> mapping->tree_lock.
> 
> This patch has made it through a clean xfstests run with the current
> v4.11-rc5 based linux/master, and it also ran generic/340 500 times in a
> loop.  It used to fail within the first 10 iterations.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [4.10+]

The patch looks good to me (and I can see Andrew already sent it to Linus),
I'm just worndering where did things actually go wrong? I'd expect we would
return VM_FAULT_FALLBACK from dax_iomap_pmd_fault() and then do PTE fault
for the address which should just work out fine...

								Honza

> ---
>  fs/dax.c | 35 ++++++++++++++++++++++-------------
>  1 file changed, 22 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index de622d4..85abd74 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -373,6 +373,22 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
>  		}
>  		spin_lock_irq(&mapping->tree_lock);
>  
> +		if (!entry) {
> +			/*
> +			 * We needed to drop the page_tree lock while calling
> +			 * radix_tree_preload() and we didn't have an entry to
> +			 * lock.  See if another thread inserted an entry at
> +			 * our index during this time.
> +			 */
> +			entry = __radix_tree_lookup(&mapping->page_tree, index,
> +					NULL, &slot);
> +			if (entry) {
> +				radix_tree_preload_end();
> +				spin_unlock_irq(&mapping->tree_lock);
> +				goto restart;
> +			}
> +		}
> +
>  		if (pmd_downgrade) {
>  			radix_tree_delete(&mapping->page_tree, index);
>  			mapping->nrexceptional--;
> @@ -388,19 +404,12 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
>  		if (err) {
>  			spin_unlock_irq(&mapping->tree_lock);
>  			/*
> -			 * Someone already created the entry?  This is a
> -			 * normal failure when inserting PMDs in a range
> -			 * that already contains PTEs.  In that case we want
> -			 * to return -EEXIST immediately.
> -			 */
> -			if (err == -EEXIST && !(size_flag & RADIX_DAX_PMD))
> -				goto restart;
> -			/*
> -			 * Our insertion of a DAX PMD entry failed, most
> -			 * likely because it collided with a PTE sized entry
> -			 * at a different index in the PMD range.  We haven't
> -			 * inserted anything into the radix tree and have no
> -			 * waiters to wake.
> +			 * Our insertion of a DAX entry failed, most likely
> +			 * because we were inserting a PMD entry and it
> +			 * collided with a PTE sized entry at a different
> +			 * index in the PMD range.  We haven't inserted
> +			 * anything into the radix tree and have no waiters to
> +			 * wake.
>  			 */
>  			return ERR_PTR(err);
>  		}
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
