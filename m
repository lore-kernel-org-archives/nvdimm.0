Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 28 Nov 2018 12:46:25 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] dax: Check page->mapping isn't NULL
Message-ID: <20181128114625.GA15604@quack2.suse.cz>
References: <20181127211634.4995-1-willy@infradead.org>
 <20181127211634.4995-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181127211634.4995-2-willy@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 27-11-18 13:16:33, Matthew Wilcox wrote:
> If we race with inode destroy, it's possible for page->mapping to be
> NULL before we even enter this routine, as well as after having slept
> waiting for the dax entry to become unlocked.
> 
> Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> Cc: stable@vger.kernel.org
> Reported-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>

Thanks for writing this fix. The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 9bcce89ea18e..e69fc231833b 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -365,7 +365,7 @@ bool dax_lock_mapping_entry(struct page *page)
>  		struct address_space *mapping = READ_ONCE(page->mapping);
>  
>  		locked = false;
> -		if (!dax_mapping(mapping))
> +		if (!mapping || !dax_mapping(mapping))
>  			break;
>  
>  		/*
> -- 
> 2.19.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
