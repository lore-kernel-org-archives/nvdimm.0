Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0056.hostedemail.com
 [216.40.44.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C204481C1C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jan 2017 10:02:26 -0800 (PST)
Message-ID: <1484244141.3065.20.camel@perches.com>
Subject: Re: [PATCH v5] DAX: enable iostat for read/write
From: Joe Perches <joe@perches.com>
Date: Thu, 12 Jan 2017 10:02:21 -0800
In-Reply-To: <20170112183848.23159-1-toshi.kani@hpe.com>
References: <20170112183848.23159-1-toshi.kani@hpe.com>
Mime-Version: 1.0
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
To: Toshi Kani <toshi.kani@hpe.com>, akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-01-12 at 11:38 -0700, Toshi Kani wrote:
> DAX IO path does not support iostat, but its metadata IO path does.
> Therefore, iostat shows metadata IO statistics only, which has been
> confusing to users.
[]
> diff --git a/fs/dax.c b/fs/dax.c
[]
> @@ -1058,12 +1058,24 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  {
>  	struct address_space *mapping = iocb->ki_filp->f_mapping;
>  	struct inode *inode = mapping->host;
> +	struct gendisk *disk = inode->i_sb->s_bdev->bd_disk;
>  	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
>  	unsigned flags = 0;
> +	unsigned long start = 0;
> +	int do_acct = blk_queue_io_stat(disk->queue);
>  
>  	if (iov_iter_rw(iter) == WRITE)
>  		flags |= IOMAP_WRITE;
>  
> +	if (do_acct) {
> +		sector_t sec = iov_iter_count(iter) >> 9;
> +
> +		start = jiffies;
> +		generic_start_io_acct(iov_iter_rw(iter),
> +				      min_t(unsigned long, 1, sec),

I believe I mislead you with a thinko.

Your original code was
	(!sec) ? 1 : sec
and I suggested incorrectly using min_t

It should of course be max_t.  Sorry.

Also, as sec is now sector_t (u64), perhaps this
unsigned long cast is incorrect.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
