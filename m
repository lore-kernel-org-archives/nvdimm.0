Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB6F51A1E92
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 11:42:31 -0700 (PDT)
Date: Tue, 11 Oct 2016 08:50:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 07/17] dax: remove the last BUG_ON() from fs/dax.c
Message-ID: <20161011065001.GB6952@quack2.suse.cz>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-8-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-8-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 07-10-16 15:08:54, Ross Zwisler wrote:
> Don't take down the kernel if we get an invalid 'from' and 'length'
> argument pair.  Just warn once and return an error.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/dax.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ac28cdf..98189ac 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1194,7 +1194,8 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
>  	/* Block boundary? Nothing to do */
>  	if (!length)
>  		return 0;
> -	BUG_ON((offset + length) > PAGE_SIZE);
> +	if (WARN_ON_ONCE((offset + length) > PAGE_SIZE))
> +		return -EINVAL;
>  
>  	memset(&bh, 0, sizeof(bh));
>  	bh.b_bdev = inode->i_sb->s_bdev;
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
