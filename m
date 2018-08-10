Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18A7B21962301
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 12:52:56 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
Date: Fri, 10 Aug 2018 14:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <20180710191031.17919-2-ross.zwisler@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: sandeen@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 7/10/18 2:10 PM, Ross Zwisler wrote:
> Inodes using DAX should only ever have exceptional entries in their page
> caches.  Make this clear by warning if the iteration in
> dax_layout_busy_page() ever sees a non-exceptional entry, and by adding a
> comment for the pagevec_release() call which only deals with struct page
> pointers.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Hi Ted, hadn't seem feedback from you on this by the time it gathered reviews,
is this something you plan to merge for realz?  (I see it's on your dev
branch now, just not sure of its permanence at this point.)

Thanks,
-Eric

> ---
>  fs/dax.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 641192808bb6..897b51e41d8f 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -566,7 +566,8 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>  			if (index >= end)
>  				break;
>  
> -			if (!radix_tree_exceptional_entry(pvec_ent))
> +			if (WARN_ON_ONCE(
> +			     !radix_tree_exceptional_entry(pvec_ent)))
>  				continue;
>  
>  			xa_lock_irq(&mapping->i_pages);
> @@ -578,6 +579,13 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>  			if (page)
>  				break;
>  		}
> +
> +		/*
> +		 * We don't expect normal struct page entries to exist in our
> +		 * tree, but we keep these pagevec calls so that this code is
> +		 * consistent with the common pattern for handling pagevecs
> +		 * throughout the kernel.
> +		 */
>  		pagevec_remove_exceptionals(&pvec);
>  		pagevec_release(&pvec);
>  		index++;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
