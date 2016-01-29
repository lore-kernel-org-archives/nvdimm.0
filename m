Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: use DAX for partition table reads
References: <20160129151835.18752.9423.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@fb.com>
Message-ID: <56ABA561.9070606@fb.com>
Date: Fri, 29 Jan 2016 10:46:09 -0700
MIME-Version: 1.0
In-Reply-To: <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-block@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 01/29/2016 08:18 AM, Dan Williams wrote:
> +unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
> +{
>   	struct page *page;
>
> -	page = read_mapping_page(mapping, (pgoff_t)(n >> (PAGE_CACHE_SHIFT-9)),
> -				 NULL);
> +	/* don't populate page cache for dax capable devices */
> +	if (IS_DAX(bdev->bd_inode))
> +		page = read_dax_sector(bdev, n);
> +	else
> +		page = read_pagecache_sector(bdev, n);
> +

Fall back to non-dax, if dax fails?

> +struct page *read_dax_sector(struct block_device *bdev, sector_t n)
> +{
> +	struct page *page = __page_cache_alloc(GFP_KERNEL | __GFP_COLD);

Why isn't that just alloc_pages()?

-- 
Jens Axboe

