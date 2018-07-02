Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60C43209605BF
 for <linux-nvdimm@lists.01.org>; Mon,  2 Jul 2018 00:57:30 -0700 (PDT)
Date: Mon, 2 Jul 2018 09:57:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] fs/ext2/inode: Optimize the condition for iomap_begin
Message-ID: <20180702075727.3s7yymczrmm4xiox@quack2.suse.cz>
References: <20180701061848.7036-1-yehs2007@zoho.com>
 <20180701061848.7036-3-yehs2007@zoho.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180701061848.7036-3-yehs2007@zoho.com>
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
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: linux-nvdimm@lists.01.org, chengnt@lenovo.com, linux-kernel@vger.kernel.org, willy@infradead.org, jack@suse.com, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun 01-07-18 14:18:48, Huaisheng Ye wrote:
> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> If ext2_get_blocks returns negative result, ext2_iomap_begin
> will return for error case.
> Adjust the judging condition of ret value will be useful for
> code simplification.
> 
> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>

I'm sorry but how exactly is this simpler?

								Honza

> ---
>  fs/ext2/inode.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index ca211bd..9b1004d 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -819,15 +819,15 @@ static int ext2_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>  	iomap->offset = (loff_t)first_block << blkbits;
>  	iomap->dax_dev = sbi->s_daxdev;
>  
> -	if (ret == 0) {
> -		iomap->type = IOMAP_HOLE;
> -		iomap->addr = IOMAP_NULL_ADDR;
> -		iomap->length = 1 << blkbits;
> -	} else {
> +	if (ret) {
>  		iomap->type = IOMAP_MAPPED;
>  		iomap->addr = (u64)bno << blkbits;
>  		iomap->length = (u64)ret << blkbits;
>  		iomap->flags |= IOMAP_F_MERGED;
> +	} else {
> +		iomap->type = IOMAP_HOLE;
> +		iomap->addr = IOMAP_NULL_ADDR;
> +		iomap->length = 1 << blkbits;
>  	}
>  
>  	if (new)
> -- 
> 1.8.3.1
> 
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
