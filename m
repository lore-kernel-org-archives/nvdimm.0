Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EC11211BD619
 for <linux-nvdimm@lists.01.org>; Fri,  1 Mar 2019 05:49:57 -0800 (PST)
Date: Fri, 1 Mar 2019 14:49:54 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Flush partial PMDs correctly
Message-ID: <20190301134954.GA31094@quack2.suse.cz>
References: <20190301042448.6868-1-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190301042448.6868-1-willy@infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Piotr Balcer <piotr.balcer@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 28-02-19 20:24:48, Matthew Wilcox wrote:
> The radix tree would rewind the index in an iterator to the lowest index
> of a multi-slot entry.  The XArray iterators instead leave the index
> unchanged, but I overlooked that when converting DAX from the radix tree
> to the XArray.  Adjust the index that we use for flushing to the start
> of the PMD range.
> 
> Fixes: c1901cd33cf4 "page cache: Convert find_get_entries_tag to XArray"
> Reported-by: Piotr Balcer <piotr.balcer@intel.com>
> Tested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> ---

Thanks for the patch! One comment below:

> @@ -894,17 +893,18 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
>  	xas_unlock_irq(xas);
>  
>  	/*
> -	 * Even if dax_writeback_mapping_range() was given a wbc->range_start
> -	 * in the middle of a PMD, the 'index' we are given will be aligned to
> -	 * the start index of the PMD, as will the pfn we pull from 'entry'.
> +	 * If dax_writeback_mapping_range() was given a wbc->range_start
> +	 * in the middle of a PMD, the 'index' we are given needs to be
> +	 * aligned to the start index of the PMD.
>  	 * This allows us to flush for PMD_SIZE and not have to worry about
>  	 * partial PMD writebacks.
>  	 */
>  	pfn = dax_to_pfn(entry);
> -	size = PAGE_SIZE << dax_entry_order(entry);
> +	count = 1UL << dax_entry_order(entry);
> +	index = xas->xa_index &~ (count - 1);

Hum, why do you compute 'index' here when you actually never use it? The
whole patch looks fishy since it is effectively a noop AFAICT...


								Honza

>  
>  	dax_entry_mkclean(mapping, xas->xa_index, pfn);
> -	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), size);
> +	dax_flush(dax_dev, page_address(pfn_to_page(pfn)), count * PAGE_SIZE);
>  	/*
>  	 * After we have flushed the cache, we can clear the dirty tag. There
>  	 * cannot be new dirty data in the pfn after the flush has completed as
> @@ -917,8 +917,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
>  	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
>  	dax_wake_entry(xas, entry, false);
>  
> -	trace_dax_writeback_one(mapping->host, xas->xa_index,
> -			size >> PAGE_SHIFT);
> +	trace_dax_writeback_one(mapping->host, xas->xa_index, count);
>  	return ret;
>  
>   put_unlocked:
> -- 
> 2.20.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
