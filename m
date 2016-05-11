Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1EE61A1F53
 for <linux-nvdimm@lists.01.org>; Wed, 11 May 2016 01:05:44 -0700 (PDT)
Date: Wed, 11 May 2016 10:05:37 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 6/6] block: Update blkdev_dax_capable() for consistency
Message-ID: <20160511080537.GA14744@quack2.suse.cz>
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
 <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462897437-16626-7-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: hch@infradead.org, jack@suse.cz, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Tue 10-05-16 10:23:57, Toshi Kani wrote:
> blkdev_dax_capable() is similar to bdev_dax_supported(), but needs
> to remain as a separate interface for checking dax capability of
> a raw block device.
> 
> Rename and relocate blkdev_dax_capable() to keep them maintained
> consistently, and call bdev_direct_access() for the dax capability
> check.
...
> +bool bdev_dax_capable(struct block_device *bdev)
> +{
> +	struct gendisk *disk = bdev->bd_disk;
> +	struct blk_dax_ctl dax = {
> +		.size = PAGE_SIZE,
> +	};
> +
> +	if (!IS_ENABLED(CONFIG_FS_DAX))
> +		return false;

Frankly, I prefer the #ifdef CONFIG_FS_DAX and just compile the code out
when DAX is not enabled (like it was with blkdev_dax_capable()). That way we
don't grow the kernel for people who don't care about DAX.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
