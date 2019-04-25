Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23E5B2194EB7F
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 12:01:35 -0700 (PDT)
Subject: Re: [v3 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
References: <20190425175440.9354-1-pasha.tatashin@soleen.com>
 <20190425175440.9354-3-pasha.tatashin@soleen.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <77c286e3-8708-6e64-94a1-fb44b6bbff3f@intel.com>
Date: Thu, 25 Apr 2019 12:01:33 -0700
MIME-Version: 1.0
In-Reply-To: <20190425175440.9354-3-pasha.tatashin@soleen.com>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com, david@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Pavel,

Thanks for doing this!  I knew we'd have to get to it eventually, but
sounds like you needed it sooner rather than later.

...
>  static inline struct dev_dax *to_dev_dax(struct device *dev)
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 4c0131857133..6f1640462df9 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -71,21 +71,107 @@ int dev_dax_kmem_probe(struct device *dev)
>  		kfree(new_res);
>  		return rc;
>  	}
> +	dev_dax->dax_kmem_res = new_res;
>  
>  	return 0;
>  }
>  
> +#ifdef CONFIG_MEMORY_HOTREMOVE

Instead of this #ifdef, is there any downside to doing

	if (!IS_ENABLED(CONFIG_MEMORY_HOTREMOVE)) {
		/*
		 * Without hotremove, purposely leak ...
		 */
		return 0;
	}
		

> +/*
> + * Check that device-dax's memory_blocks are offline. If a memory_block is not
> + * offline a warning is printed and an error is returned. dax hotremove can
> + * succeed only when every memory_block is offlined beforehand.
> + */

I'd much rather see comments inline with the code than all piled at the
top of a function like this.

One thing that would be helpful, though, is a reminder about needing the
device hotplug lock.

> +static int
> +check_memblock_offlined_cb(struct memory_block *mem, void *arg)
> +{
> +	struct device *mem_dev = &mem->dev;
> +	bool is_offline;
> +
> +	device_lock(mem_dev);
> +	is_offline = mem_dev->offline;
> +	device_unlock(mem_dev);
> +
> +	if (!is_offline) {
> +		struct device *dev = (struct device *)arg;

The two devices confused me for a bit here.  Seems worth a comment to
remind the reader what this device _is_ versus 'mem_dev'.

> +		unsigned long spfn = section_nr_to_pfn(mem->start_section_nr);
> +		unsigned long epfn = section_nr_to_pfn(mem->end_section_nr);
> +		phys_addr_t spa = spfn << PAGE_SHIFT;
> +		phys_addr_t epa = epfn << PAGE_SHIFT;
> +
> +		dev_warn(dev, "memory block [%pa-%pa] is not offline\n",
> +			 &spa, &epa);

I thought we had a magic resource printk %something.  Could we just
print one of the device resources here to save all the section/pfn/paddr
calculations?

Also, should we consider a slightly scarier message?  This path has a
permanent, user-visible effect (we can never try to unbind again).

> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}

Even though they're static, I'd prefer that we not create two versions
of check_memblock_offlined_cb() in the kernel.  Can we give this a
better, non-conflicting name?

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
> +	/*
> +	 * dax kmem resource does not exist, means memory was never hotplugged.
> +	 * So, nothing to do here.
> +	 */
> +	if (!res)
> +		return 0;

How could that happen?  I can't think of any obvious scenarios.

> +	kmem_start = res->start;
> +	kmem_size = resource_size(res);
> +	start_pfn = kmem_start >> PAGE_SHIFT;
> +	end_pfn = start_pfn + (kmem_size >> PAGE_SHIFT) - 1;
> +
> +	/*
> +	 * Walk and check that every singe memory_block of dax region is
> +	 * offline
> +	 */
> +	lock_device_hotplug();
> +	rc = walk_memory_range(start_pfn, end_pfn, dev,
> +			       check_memblock_offlined_cb);

Does lock_device_hotplug() also lock memory online/offline?  Otherwise,
isn't this offline check racy?  If not, can you please spell that out in
a comment?

Also, could you compare this a bit to the walk_memory_range() use in
__remove_memory()?  Why do we need two walks looking for offline blocks?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
