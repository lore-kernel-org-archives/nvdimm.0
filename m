Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 23 Feb 2016 16:37:48 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/6] dax: Use vmf->gfp_mask
Message-ID: <20160223233748.GA32265@linux.intel.com>
References: <1454242795-18038-1-git-send-email-matthew.r.wilcox@intel.com>
 <1454242795-18038-2-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454242795-18038-2-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 31, 2016 at 11:19:50PM +1100, Matthew Wilcox wrote:
> We were assuming that it was OK to do a GFP_KERNEL allocation in page
> fault context.  That appears to be largely true, but filesystems are
> permitted to override that in their setting of mapping->gfp_flags, which
> the VM then massages into vmf->gfp_flags.  No practical difference for
> now, but there may come a day when we would have surprised a filesystem.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

Sure, this seems right.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 2f9bb89..11be8c7 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -292,7 +292,7 @@ static int dax_load_hole(struct address_space *mapping, struct page *page,
>  	struct inode *inode = mapping->host;
>  	if (!page)
>  		page = find_or_create_page(mapping, vmf->pgoff,
> -						GFP_KERNEL | __GFP_ZERO);
> +						vmf->gfp_mask | __GFP_ZERO);
>  	if (!page)
>  		return VM_FAULT_OOM;
>  	/* Recheck i_size under page lock to avoid truncate race */
> -- 
> 2.7.0.rc3
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
