Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 50BDF211CF375
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 02:05:59 -0700 (PDT)
Date: Mon, 11 Mar 2019 10:05:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Flush partial PMDs correctly
Message-ID: <20190311090557.GB11553@quack2.suse.cz>
References: <20190301191241.27842-1-willy@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190301191241.27842-1-willy@infradead.org>
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

On Fri 01-03-19 11:12:41, Matthew Wilcox wrote:
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
...
> @@ -917,8 +917,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
>  	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
>  	dax_wake_entry(xas, entry, false);
>  
> -	trace_dax_writeback_one(mapping->host, xas->xa_index,
> -			size >> PAGE_SHIFT);
> +	trace_dax_writeback_one(mapping->host, xas->xa_index, count);

I think here should be 'index' as well, shouldn't it? Otherwise the tracing
data will be somewhat misleading... Besides this the patch looks good to me
now so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
