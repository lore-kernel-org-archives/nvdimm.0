Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <55095A05.2020703@gmail.com>
Date: Wed, 18 Mar 2015 12:57:09 +0200
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] pmem: Let each device manage private memory region
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com> <1426540380-24503-7-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1426540380-24503-7-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <boaz@plexistor.com>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On 03/16/2015 11:13 PM, Ross Zwisler wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> This patch removes any global memory information. And lets
> each pmem-device manage it's own memory region.
> 
> pmem_alloc() Now receives phys_addr and disk_size and will
> map that region, also pmem_free will do the unmaping.
> 
> This is so we can support multiple discontinuous memory regions
> in the next patch
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

Yes I wrote this! No! please remove my Signed-off-by

This is completely the wrong API, and completely the
wrong convoluted, crap code from the beginning.

Even after my half backed, done as a review enhancer
for the better code, that needs to come later.

Sad
Boaz

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: axboe@kernel.dk
> Cc: hch@infradead.org
> Cc: riel@redhat.com
> ---
>  drivers/block/pmem.c | 122 +++++++++++++++++++++++++++++++--------------------
>  1 file changed, 75 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index 8f39ef4..1bd9ab0 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -30,19 +30,12 @@
>  #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
>  #define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
>  
> -/*
> - * driver-wide physical address and total_size - one single, contiguous memory
> - * region that we divide up in to same-sized devices
> - */
> -phys_addr_t	phys_addr;
> -void		*virt_addr;
> -size_t		total_size;
> -
>  struct pmem_device {
>  	struct request_queue	*pmem_queue;
>  	struct gendisk		*pmem_disk;
>  	struct list_head	pmem_list;
>  
> +	/* One contiguous memory region per device */
>  	phys_addr_t		phys_addr;
>  	void			*virt_addr;
>  	size_t			size;
> @@ -237,33 +230,80 @@ MODULE_PARM_DESC(pmem_count, "Number of pmem devices to evenly split allocated s
>  static LIST_HEAD(pmem_devices);
>  static int pmem_major;
>  
> -/* FIXME: move phys_addr, virt_addr, size calls up to caller */
> -static struct pmem_device *pmem_alloc(int i)
> +/* pmem->phys_addr and pmem->size need to be set.
> + * Will then set virt_addr if successful.
> + */
> +int pmem_mapmem(struct pmem_device *pmem)
> +{
> +	struct resource *res_mem;
> +	int err;
> +
> +	res_mem = request_mem_region_exclusive(pmem->phys_addr, pmem->size,
> +					       "pmem");
> +	if (!res_mem) {
> +		pr_warn("pmem: request_mem_region_exclusive phys=0x%llx size=0x%zx failed\n",
> +			   pmem->phys_addr, pmem->size);
> +		return -EINVAL;
> +	}
> +
> +	pmem->virt_addr = ioremap_cache(pmem->phys_addr, pmem->size);
> +	if (unlikely(!pmem->virt_addr)) {
> +		err = -ENXIO;
> +		goto out_release;
> +	}
> +	return 0;
> +
> +out_release:
> +	release_mem_region(pmem->phys_addr, pmem->size);
> +	return err;
> +}
> +
> +void pmem_unmapmem(struct pmem_device *pmem)
> +{
> +	if (unlikely(!pmem->virt_addr))
> +		return;
> +
> +	iounmap(pmem->virt_addr);
> +	release_mem_region(pmem->phys_addr, pmem->size);
> +	pmem->virt_addr = NULL;
> +}
> +
> +static struct pmem_device *pmem_alloc(phys_addr_t phys_addr, size_t disk_size,
> +				      int i)
>  {
>  	struct pmem_device *pmem;
>  	struct gendisk *disk;
> -	size_t disk_size = total_size / pmem_count;
> -	size_t disk_sectors = disk_size / 512;
> +	int err;
>  
>  	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
> -	if (!pmem)
> +	if (unlikely(!pmem)) {
> +		err = -ENOMEM;
>  		goto out;
> +	}
>  
> -	pmem->phys_addr = phys_addr + i * disk_size;
> -	pmem->virt_addr = virt_addr + i * disk_size;
> +	pmem->phys_addr = phys_addr;
>  	pmem->size = disk_size;
>  
> -	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
> -	if (!pmem->pmem_queue)
> +	err = pmem_mapmem(pmem);
> +	if (unlikely(err))
>  		goto out_free_dev;
>  
> +	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
> +	if (unlikely(!pmem->pmem_queue)) {
> +		err = -ENOMEM;
> +		goto out_unmap;
> +	}
> +
>  	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
>  	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
>  	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
>  
> -	disk = pmem->pmem_disk = alloc_disk(0);
> -	if (!disk)
> +	disk = alloc_disk(0);
> +	if (unlikely(!disk)) {
> +		err = -ENOMEM;
>  		goto out_free_queue;
> +	}
> +
>  	disk->major		= pmem_major;
>  	disk->first_minor	= 0;
>  	disk->fops		= &pmem_fops;
> @@ -271,22 +311,26 @@ static struct pmem_device *pmem_alloc(int i)
>  	disk->queue		= pmem->pmem_queue;
>  	disk->flags		= GENHD_FL_EXT_DEVT;
>  	sprintf(disk->disk_name, "pmem%d", i);
> -	set_capacity(disk, disk_sectors);
> +	set_capacity(disk, disk_size >> SECTOR_SHIFT);
> +	pmem->pmem_disk = disk;
>  
>  	return pmem;
>  
>  out_free_queue:
>  	blk_cleanup_queue(pmem->pmem_queue);
> +out_unmap:
> +	pmem_unmapmem(pmem);
>  out_free_dev:
>  	kfree(pmem);
>  out:
> -	return NULL;
> +	return ERR_PTR(err);
>  }
>  
>  static void pmem_free(struct pmem_device *pmem)
>  {
>  	put_disk(pmem->pmem_disk);
>  	blk_cleanup_queue(pmem->pmem_queue);
> +	pmem_unmapmem(pmem);
>  	kfree(pmem);
>  }
>  
> @@ -300,36 +344,28 @@ static void pmem_del_one(struct pmem_device *pmem)
>  static int __init pmem_init(void)
>  {
>  	int result, i;
> -	struct resource *res_mem;
>  	struct pmem_device *pmem, *next;
> +	phys_addr_t phys_addr;
> +	size_t total_size, disk_size;
>  
>  	phys_addr  = (phys_addr_t) pmem_start_gb * 1024 * 1024 * 1024;
>  	total_size = (size_t)	   pmem_size_gb  * 1024 * 1024 * 1024;
> -
> -	res_mem = request_mem_region_exclusive(phys_addr, total_size, "pmem");
> -	if (!res_mem)
> -		return -ENOMEM;
> -
> -	virt_addr = ioremap_cache(phys_addr, total_size);
> -	if (!virt_addr) {
> -		result = -ENOMEM;
> -		goto out_release;
> -	}
> +	disk_size = total_size / pmem_count;
>  
>  	result = register_blkdev(0, "pmem");
> -	if (result < 0) {
> -		result = -EIO;
> -		goto out_unmap;
> -	} else
> +	if (result < 0)
> +		return -EIO;
> +	else
>  		pmem_major = result;
>  
>  	for (i = 0; i < pmem_count; i++) {
> -		pmem = pmem_alloc(i);
> -		if (!pmem) {
> -			result = -ENOMEM;
> +		pmem = pmem_alloc(phys_addr, disk_size, i);
> +		if (IS_ERR(pmem)) {
> +			result = PTR_ERR(pmem);
>  			goto out_free;
>  		}
>  		list_add_tail(&pmem->pmem_list, &pmem_devices);
> +		phys_addr += disk_size;
>  	}
>  
>  	list_for_each_entry(pmem, &pmem_devices, pmem_list)
> @@ -345,11 +381,6 @@ out_free:
>  	}
>  	unregister_blkdev(pmem_major, "pmem");
>  
> -out_unmap:
> -	iounmap(virt_addr);
> -
> -out_release:
> -	release_mem_region(phys_addr, total_size);
>  	return result;
>  }
>  
> @@ -361,9 +392,6 @@ static void __exit pmem_exit(void)
>  		pmem_del_one(pmem);
>  
>  	unregister_blkdev(pmem_major, "pmem");
> -	iounmap(virt_addr);
> -	release_mem_region(phys_addr, total_size);
> -
>  	pr_info("pmem: module unloaded\n");
>  }
>  
> 

