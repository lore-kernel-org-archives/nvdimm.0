Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 10 Nov 2017 10:04:53 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/15] mm, dax: enable filesystems to trigger page-idle
	callbacks
Message-ID: <20171110090453.GC4895@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949216078.24061.1875240167277688258.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150949216078.24061.1875240167277688258.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> +DEFINE_MUTEX(devmap_lock);

static?

> +#if IS_ENABLED(CONFIG_FS_DAX)
> +static void generic_dax_pagefree(struct page *page, void *data)
> +{
> +}
> +
> +struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
> +{
> +	struct dax_device *dax_dev;
> +	struct dev_pagemap *pgmap;
> +
> +	if (!blk_queue_dax(bdev->bd_queue))
> +		return NULL;
> +	dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
> +	if (!dax_dev->pgmap)
> +		return dax_dev;
> +	pgmap = dax_dev->pgmap;

> +	mutex_lock(&devmap_lock);
> +	if ((pgmap->data && pgmap->data != owner) || pgmap->page_free
> +			|| pgmap->page_fault
> +			|| pgmap->type != MEMORY_DEVICE_HOST) {
> +		put_dax(dax_dev);
> +		mutex_unlock(&devmap_lock);
> +		return NULL;
> +	}
> +
> +	pgmap->type = MEMORY_DEVICE_FS_DAX;
> +	pgmap->page_free = generic_dax_pagefree;
> +	pgmap->data = owner;
> +	mutex_unlock(&devmap_lock);

All this deep magic will need some explanation.  So far I don't understand
it at all, but maybe the later patches will help..

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
