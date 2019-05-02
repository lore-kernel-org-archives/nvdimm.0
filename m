Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5798421237ACC
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 07:14:24 -0700 (PDT)
Subject: Re: [v4 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
References: <20190501191846.12634-1-pasha.tatashin@soleen.com>
 <20190501191846.12634-3-pasha.tatashin@soleen.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <9e15bf41-8e74-3a76-c7b9-9712b2d5290b@redhat.com>
Date: Thu, 2 May 2019 16:14:14 +0200
MIME-Version: 1.0
In-Reply-To: <20190501191846.12634-3-pasha.tatashin@soleen.com>
Content-Language: en-US
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On 01.05.19 21:18, Pavel Tatashin wrote:
> It is now allowed to use persistent memory like a regular RAM, but
> currently there is no way to remove this memory until machine is
> rebooted.
> 
> This work expands the functionality to also allows hotremoving
> previously hotplugged persistent memory, and recover the device for use
> for other purposes.
> 
> To hotremove persistent memory, the management software must first
> offline all memory blocks of dax region, and than unbind it from
> device-dax/kmem driver. So, operations should look like this:
> 
> echo offline > echo offline > /sys/devices/system/memory/memoryN/state
> ...
> echo dax0.0 > /sys/bus/dax/drivers/kmem/unbind
> 
> Note: if unbind is done without offlining memory beforehand, it won't be
> possible to do dax0.0 hotremove, and dax's memory is going to be part of
> System RAM until reboot.
> 
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
> ---
>  drivers/dax/dax-private.h |  2 +
>  drivers/dax/kmem.c        | 99 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 97 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index a45612148ca0..999aaf3a29b3 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -53,6 +53,7 @@ struct dax_region {
>   * @pgmap - pgmap for memmap setup / lifetime (driver owned)
>   * @ref: pgmap reference count (driver owned)
>   * @cmp: @ref final put completion (driver owned)
> + * @dax_mem_res: physical address range of hotadded DAX memory
>   */
>  struct dev_dax {
>  	struct dax_region *region;
> @@ -62,6 +63,7 @@ struct dev_dax {
>  	struct dev_pagemap pgmap;
>  	struct percpu_ref ref;
>  	struct completion cmp;
> +	struct resource *dax_kmem_res;
>  };
>  
>  static inline struct dev_dax *to_dev_dax(struct device *dev)
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 4c0131857133..72b868066026 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -71,21 +71,112 @@ int dev_dax_kmem_probe(struct device *dev)
>  		kfree(new_res);
>  		return rc;
>  	}
> +	dev_dax->dax_kmem_res = new_res;
>  
>  	return 0;
>  }
>  
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +static int
> +check_devdax_mem_offlined_cb(struct memory_block *mem, void *arg)
> +{
> +	/* Memory block device */
> +	struct device *mem_dev = &mem->dev;
> +	bool is_offline;
> +
> +	device_lock(mem_dev);
> +	is_offline = mem_dev->offline;
> +	device_unlock(mem_dev);
> +
> +	/*
> +	 * Check that device-dax's memory_blocks are offline. If a memory_block
> +	 * is not offline a warning is printed and an error is returned.
> +	 */
> +	if (!is_offline) {
> +		/* Dax device device */
> +		struct device *dev = (struct device *)arg;
> +		struct dev_dax *dev_dax = to_dev_dax(dev);
> +		struct resource *res = &dev_dax->region->res;
> +		unsigned long spfn = section_nr_to_pfn(mem->start_section_nr);
> +		unsigned long epfn = section_nr_to_pfn(mem->end_section_nr) +
> +						       PAGES_PER_SECTION - 1;
> +		phys_addr_t spa = spfn << PAGE_SHIFT;
> +		phys_addr_t epa = epfn << PAGE_SHIFT;
> +
> +		dev_err(dev,
> +			"DAX region %pR cannot be hotremoved until the next reboot. Memory block [%pa-%pa] is not offline.\n",
> +			res, &spa, &epa);
> +
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dev_dax_kmem_remove(struct device *dev)
> +{
> +	struct dev_dax *dev_dax = to_dev_dax(dev);
> +	struct resource *res = dev_dax->dax_kmem_res;
> +	resource_size_t kmem_start;
> +	resource_size_t kmem_size;
> +	unsigned long start_pfn;
> +	unsigned long end_pfn;
> +	int rc;
> +
> +	kmem_start = res->start;
> +	kmem_size = resource_size(res);
> +	start_pfn = kmem_start >> PAGE_SHIFT;
> +	end_pfn = start_pfn + (kmem_size >> PAGE_SHIFT) - 1;
> +
> +	/*
> +	 * Keep hotplug lock while checking memory state, and also required
> +	 * during __remove_memory() call. Admin can't change memory state via
> +	 * sysfs while this lock is kept.
> +	 */
> +	lock_device_hotplug();
> +
> +	/*
> +	 * Walk and check that every singe memory_block of dax region is
> +	 * offline. Hotremove can succeed only when every memory_block is
> +	 * offlined beforehand.
> +	 */
> +	rc = walk_memory_range(start_pfn, end_pfn, dev,
> +			       check_devdax_mem_offlined_cb);
> +
> +	/*
> +	 * If admin has not offlined memory beforehand, we cannot hotremove dax.
> +	 * Unfortunately, because unbind will still succeed there is no way for
> +	 * user to hotremove dax after this.
> +	 */
> +	if (rc) {
> +		unlock_device_hotplug();
> +		return rc;
> +	}
> +
> +	/* Hotremove memory, cannot fail because memory is already offlined */
> +	__remove_memory(dev_dax->target_node, kmem_start, kmem_size);
> +	unlock_device_hotplug();
> +
> +	/* Release and free dax resources */
> +	release_resource(res);
> +	kfree(res);
> +	dev_dax->dax_kmem_res = NULL;
> +
> +	return 0;
> +}
> +#else
>  static int dev_dax_kmem_remove(struct device *dev)
>  {
>  	/*
> -	 * Purposely leak the request_mem_region() for the device-dax
> -	 * range and return '0' to ->remove() attempts. The removal of
> -	 * the device from the driver always succeeds, but the region
> -	 * is permanently pinned as reserved by the unreleased
> +	 * Without hotremove purposely leak the request_mem_region() for the
> +	 * device-dax range and return '0' to ->remove() attempts. The removal
> +	 * of the device from the driver always succeeds, but the region is
> +	 * permanently pinned as reserved by the unreleased
>  	 * request_mem_region().
>  	 */
>  	return 0;
>  }
> +#endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  static struct dax_device_driver device_dax_kmem_driver = {
>  	.drv = {
> 

Memory unplug bits

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
