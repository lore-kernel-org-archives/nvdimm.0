Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D243FCD
	for <nvdimm@lists.linux.dev>; Wed, 22 Sep 2021 21:40:50 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="309264272"
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="309264272"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 14:40:49 -0700
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="550430044"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 14:40:49 -0700
Date: Wed, 22 Sep 2021 14:40:49 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to
 pmem
Message-ID: <20210922214049.GC3053272@iweiny-DESK2.sc.intel.com>
References: <20210922183331.2455043-1-hch@lst.de>
 <20210922183331.2455043-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922183331.2455043-3-hch@lst.de>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Wed, Sep 22, 2021 at 08:33:30PM +0200, Christoph Hellwig wrote:
> dax_attribute_group is only used by the pmem driver, and can avoid the
> completely pointless lookup by the disk name if moved there.  This
> leaves just a single caller of dax_get_by_host, so move dax_get_by_host
> into the same ifdef block as that caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/dax/super.c   | 100 ++++++++----------------------------------
>  drivers/nvdimm/pmem.c |  43 ++++++++++++++++++
>  include/linux/dax.h   |   2 -
>  3 files changed, 61 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index fc89e91beea7c..b882cf8106ea3 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -63,6 +63,24 @@ static int dax_host_hash(const char *host)
>  	return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
>  }
>  
> +#ifdef CONFIG_BLOCK
> +#include <linux/blkdev.h>
> +
> +int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> +		pgoff_t *pgoff)
> +{
> +	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
> +	phys_addr_t phys_off = (start_sect + sector) * 512;
> +
> +	if (pgoff)
> +		*pgoff = PHYS_PFN(phys_off);
> +	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> +		return -EINVAL;
> +	return 0;
> +}
> +EXPORT_SYMBOL(bdev_dax_pgoff);
> +
> +#if IS_ENABLED(CONFIG_FS_DAX)
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @host: alternate name for the device registered by a dax driver
> @@ -94,24 +112,6 @@ static struct dax_device *dax_get_by_host(const char *host)
>  	return found;
>  }
>  
> -#ifdef CONFIG_BLOCK
> -#include <linux/blkdev.h>
> -
> -int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> -		pgoff_t *pgoff)
> -{
> -	sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
> -	phys_addr_t phys_off = (start_sect + sector) * 512;
> -
> -	if (pgoff)
> -		*pgoff = PHYS_PFN(phys_off);
> -	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> -		return -EINVAL;
> -	return 0;
> -}
> -EXPORT_SYMBOL(bdev_dax_pgoff);
> -
> -#if IS_ENABLED(CONFIG_FS_DAX)
>  struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>  {
>  	if (!blk_queue_dax(bdev->bd_disk->queue))
> @@ -231,70 +231,6 @@ enum dax_device_flags {
>  	DAXDEV_SYNC,
>  };
>  
> -static ssize_t write_cache_show(struct device *dev,
> -		struct device_attribute *attr, char *buf)
> -{
> -	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
> -	ssize_t rc;
> -
> -	WARN_ON_ONCE(!dax_dev);
> -	if (!dax_dev)
> -		return -ENXIO;
> -
> -	rc = sprintf(buf, "%d\n", !!dax_write_cache_enabled(dax_dev));
> -	put_dax(dax_dev);
> -	return rc;
> -}
> -
> -static ssize_t write_cache_store(struct device *dev,
> -		struct device_attribute *attr, const char *buf, size_t len)
> -{
> -	bool write_cache;
> -	int rc = strtobool(buf, &write_cache);
> -	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
> -
> -	WARN_ON_ONCE(!dax_dev);
> -	if (!dax_dev)
> -		return -ENXIO;
> -
> -	if (rc)
> -		len = rc;
> -	else
> -		dax_write_cache(dax_dev, write_cache);
> -
> -	put_dax(dax_dev);
> -	return len;
> -}
> -static DEVICE_ATTR_RW(write_cache);
> -
> -static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
> -{
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> -	struct dax_device *dax_dev = dax_get_by_host(dev_name(dev));
> -
> -	WARN_ON_ONCE(!dax_dev);
> -	if (!dax_dev)
> -		return 0;
> -
> -#ifndef CONFIG_ARCH_HAS_PMEM_API
> -	if (a == &dev_attr_write_cache.attr)
> -		return 0;
> -#endif
> -	return a->mode;
> -}
> -
> -static struct attribute *dax_attributes[] = {
> -	&dev_attr_write_cache.attr,
> -	NULL,
> -};
> -
> -struct attribute_group dax_attribute_group = {
> -	.name = "dax",
> -	.attrs = dax_attributes,
> -	.is_visible = dax_visible,
> -};
> -EXPORT_SYMBOL_GPL(dax_attribute_group);
> -
>  /**
>   * dax_direct_access() - translate a device pgoff to an absolute pfn
>   * @dax_dev: a dax_device instance representing the logical memory range
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ef4950f808326..bbeb3f46db157 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -328,6 +328,49 @@ static const struct dax_operations pmem_dax_ops = {
>  	.zero_page_range = pmem_dax_zero_page_range,
>  };
>  
> +static ssize_t write_cache_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
> +
> +	return sprintf(buf, "%d\n", !!dax_write_cache_enabled(pmem->dax_dev));
> +}
> +
> +static ssize_t write_cache_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t len)
> +{
> +	struct pmem_device *pmem = dev_to_disk(dev)->private_data;
> +	bool write_cache;
> +	int rc;
> +
> +	rc = strtobool(buf, &write_cache);
> +	if (rc)
> +		return rc;
> +	dax_write_cache(pmem->dax_dev, write_cache);
> +	return len;
> +}
> +static DEVICE_ATTR_RW(write_cache);
> +
> +static umode_t dax_visible(struct kobject *kobj, struct attribute *a, int n)
> +{
> +#ifndef CONFIG_ARCH_HAS_PMEM_API
> +	if (a == &dev_attr_write_cache.attr)
> +		return 0;
> +#endif
> +	return a->mode;
> +}
> +
> +static struct attribute *dax_attributes[] = {
> +	&dev_attr_write_cache.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group dax_attribute_group = {
> +	.name		= "dax",
> +	.attrs		= dax_attributes,
> +	.is_visible	= dax_visible,
> +};
> +
>  static const struct attribute_group *pmem_attribute_groups[] = {
>  	&dax_attribute_group,
>  	NULL,
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 2619d94c308d4..8623caa673889 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -38,8 +38,6 @@ struct dax_operations {
>  	int (*zero_page_range)(struct dax_device *, pgoff_t, size_t);
>  };
>  
> -extern struct attribute_group dax_attribute_group;
> -
>  #if IS_ENABLED(CONFIG_DAX)
>  struct dax_device *alloc_dax(void *private, const char *host,
>  		const struct dax_operations *ops, unsigned long flags);
> -- 
> 2.30.2
> 
> 
