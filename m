Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 22 Jan 2016 16:11:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 4/5] dax: fix PMD handling for fsync/msync
Message-ID: <20160122151141.GM16898@quack.suse.cz>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
 <1453398364-22537-5-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453398364-22537-5-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 21-01-16 10:46:03, Ross Zwisler wrote:
> Fix the way that DAX PMD radix tree entries are handled.  With this patch
> we now check to see if a PMD entry exists in the radix tree on write, even
> if we are just trying to insert a PTE.  If it exists, we dirty that instead
> of inserting our own PTE entry.
> 
> Fix a bug in the PMD path in dax_writeback_mapping_range() where we were
> previously passing a loff_t into radix_tree_lookup instead of a pgoff_t.

Ah, good catch!

> Account for the fact that multiple fsync/msync operations may be happening
> at the same time and don't flush entries that are beyond end_index.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Just one nit below. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

> ---
>  fs/dax.c | 39 +++++++++++++++++++++++++++------------
>  1 file changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 55ae394..afacc30 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
...
> @@ -460,31 +468,33 @@ int dax_writeback_mapping_range(struct address_space *mapping, loff_t start,
>  {
>  	struct inode *inode = mapping->host;
>  	struct block_device *bdev = inode->i_sb->s_bdev;
> +	pgoff_t start_index, end_index, pmd_index;
>  	pgoff_t indices[PAGEVEC_SIZE];
> -	pgoff_t start_page, end_page;
>  	struct pagevec pvec;
> -	void *entry;
> +	bool done = false;
>  	int i, ret = 0;
> +	void *entry;
>  
>  	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
>  		return -EIO;
>  
> +	start_index = start >> PAGE_CACHE_SHIFT;
> +	end_index = end >> PAGE_CACHE_SHIFT;
> +	pmd_index = DAX_PMD_INDEX(start_index);
> +
>  	rcu_read_lock();
> -	entry = radix_tree_lookup(&mapping->page_tree, start & PMD_MASK);
> +	entry = radix_tree_lookup(&mapping->page_tree, pmd_index);
>  	rcu_read_unlock();
>  
>  	/* see if the start of our range is covered by a PMD entry */
> -	if (entry && RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> -		start &= PMD_MASK;
> -
> -	start_page = start >> PAGE_CACHE_SHIFT;
> -	end_page = end >> PAGE_CACHE_SHIFT;
> +	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)

Don't you miss a check that entry != NULL? I agree that RADIX_DAX_TYPE(NULL)
is != from RADIX_DAX_PMD so it works as desired but it looks a bit
dangerous.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
