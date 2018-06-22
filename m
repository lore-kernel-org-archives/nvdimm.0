Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1478F210D83F7
 for <linux-nvdimm@lists.01.org>; Fri, 22 Jun 2018 01:10:26 -0700 (PDT)
Date: Fri, 22 Jun 2018 10:10:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] dax: dax_layout_busy_page() warn on !exceptional
Message-ID: <20180622081023.cjky5sqbp64r4ibu@quack2.suse.cz>
References: <20180620221503.25237-1-ross.zwisler@linux.intel.com>
 <20180620221503.25237-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180620221503.25237-2-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 20-06-18 16:15:02, Ross Zwisler wrote:
> Inodes using DAX should only ever have exceptional entries in their page
> caches.  Make this clear by warning if the iteration in
> dax_layout_busy_page() ever sees a non-exceptional entry, and by adding a
> comment for the pagevec_release() call which only deals with struct page
> pointers.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/dax.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 641192808bb6..4a5e31f8a2d4 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -566,7 +566,7 @@ struct page *dax_layout_busy_page(struct address_space *mapping)
>  			if (index >= end)
>  				break;
>  
> -			if (!radix_tree_exceptional_entry(pvec_ent))
> +			if (WARN_ON_ONCE(!radix_tree_exceptional_entry(pvec_ent)))

Please wrap this line. Otherwise the patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
