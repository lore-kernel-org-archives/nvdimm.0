Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 29 Jan 2016 17:45:56 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/2] block: use DAX for partition table reads
Message-ID: <20160129224556.GX2948@linux.intel.com>
References: <20160129151835.18752.9423.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@fb.com, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 29, 2016 at 07:18:46AM -0800, Dan Williams wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 29189aeace19..b1452c04f1a9 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1633,6 +1633,16 @@ struct blk_dax_ctl {
>  	pfn_t pfn;
>  };
>  
> +#ifdef CONFIG_FS_DAX
> +struct page *read_dax_sector(struct block_device *bdev, sector_t n);
> +#else
> +static inline struct page *read_dax_sector(struct block_device *bdev,
> +		sector_t n)
> +{
> +	return ERR_PTR(-ENXIO);
> +}
> +#endif
> +

Can you move this to include/linux/dax.h?  I'd like to keep it that all
functions in dax.c have a prototype in dax.h.

With that change, Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
