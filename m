Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 22 Jan 2016 16:01:29 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/5] dax: improve documentation for fsync/msync
Message-ID: <20160122150129.GL16898@quack.suse.cz>
References: <1453398364-22537-1-git-send-email-ross.zwisler@linux.intel.com>
 <1453398364-22537-4-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453398364-22537-4-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 21-01-16 10:46:02, Ross Zwisler wrote:
> Several of the subtleties and assumptions of the DAX fsync/msync
> implementation are not immediately obvious, so document them with comments.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reported-by: Jan Kara <jack@suse.cz>

Thanks, the comments really help! Just two nits below, otherwise feel free
to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> ---
>  fs/dax.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index d589113..55ae394 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -350,6 +350,13 @@ static int dax_radix_entry(struct address_space *mapping, pgoff_t index,
>  
>  		if (!pmd_entry || type == RADIX_DAX_PMD)
>  			goto dirty;
> +
> +		/*
> +		 * We only insert dirty PMD entries into the radix tree.  This
> +		 * means we don't need to worry about removing a dirty PTE
> +		 * entry and inserting a clean PMD entry, thus reducing the
> +		 * range we would flush with a follow-up fsync/msync call.
> +		 */

May be acompany this with:

		WARN_ON(pmd_entry && !dirty);

somewhere in dax_radix_entry()?

>  		radix_tree_delete(&mapping->page_tree, index);
>  		mapping->nrexceptional--;
>  	}
> @@ -912,6 +919,21 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
>  		}
>  		dax_unmap_atomic(bdev, &dax);
>  
> +		/*
> +		 * For PTE faults we insert a radix tree entry for reads, and
> +		 * leave it clean.  Then on the first write we dirty the radix
> +		 * tree entry via the dax_pnf_mkwrite() path.  This sequence
					  ^^^ pfn

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
