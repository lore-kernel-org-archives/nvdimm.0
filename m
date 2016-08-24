From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: silently skip readahead for DAX inodes
Date: Wed, 24 Aug 2016 13:42:12 -0700
Message-ID: <20160824134212.e9b50aa36523fbfcbcfe2f55@linux-foundation.org>
References: <20160824203712.4580-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160824203712.4580-1-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.com>, linux-mm@kvack.org, linux-nvdimm@ml01.01.org, Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Wed, 24 Aug 2016 14:37:12 -0600 Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> For DAX inodes we need to be careful to never have page cache pages in the
> mapping->page_tree.  This radix tree should be composed only of DAX
> exceptional entries and zero pages.
> 
> ltp's readahead02 test was triggering a warning because we were trying to
> insert a DAX exceptional entry but found that a page cache page had already
> been inserted into the tree.  This page was being inserted into the radix
> tree in response to a readahead(2) call.
> 
> Readahead doesn't make sense for DAX inodes, but we don't want it to report
> a failure either.  Instead, we just return success and don't do any work.
> 
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/dax.h>
>  #include <linux/gfp.h>
>  #include <linux/export.h>
>  #include <linux/blkdev.h>
> @@ -544,6 +545,9 @@ do_readahead(struct address_space *mapping, struct file *filp,
>  	if (!mapping || !mapping->a_ops)
>  		return -EINVAL;
>  
> +	if (dax_mapping(mapping))
> +		return 0;
> +

Please don't force readers to go spend minutes putzing around in the
git tree trying to understand your code.
/* these things considered useful! */

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
