Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1768821244A1D
 for <linux-nvdimm@lists.01.org>; Fri,  3 May 2019 03:06:27 -0700 (PDT)
Subject: Re: [v5 2/3] mm/hotplug: make remove_memory() interface useable
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <20190502184337.20538-3-pasha.tatashin@soleen.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <cfd599a7-ed05-fa5a-93a0-397fb9de72e4@redhat.com>
Date: Fri, 3 May 2019 12:06:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190502184337.20538-3-pasha.tatashin@soleen.com>
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

On 02.05.19 20:43, Pavel Tatashin wrote:
> As of right now remove_memory() interface is inherently broken. It tries
> to remove memory but panics if some memory is not offline. The problem
> is that it is impossible to ensure that all memory blocks are offline as
> this function also takes lock_device_hotplug that is required to
> change memory state via sysfs.
> 

The existing interface can actually work today by registering a hotplug
notifier and rejecting any onlining attempts. But I agree that this way,
the interface becomes more usable.

> So, between calling this function and offlining all memory blocks there
> is always a window when lock_device_hotplug is released, and therefore,
> there is always a chance for a panic during this window.
> 
> Make this interface to return an error if memory removal fails. This way
> it is safe to call this function without panicking machine, and also
> makes it symmetric to add_memory() which already returns an error.
> 
> Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>> ---
>  include/linux/memory_hotplug.h |  8 +++--
>  mm/memory_hotplug.c            | 61 ++++++++++++++++++++++------------
>  2 files changed, 46 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 8ade08c50d26..5438a2d92560 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -304,7 +304,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
>  extern bool is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
>  extern void try_offline_node(int nid);
>  extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
> -extern void remove_memory(int nid, u64 start, u64 size);
> +extern int remove_memory(int nid, u64 start, u64 size);
>  extern void __remove_memory(int nid, u64 start, u64 size);
>  
>  #else
> @@ -321,7 +321,11 @@ static inline int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
>  	return -EINVAL;
>  }
>  
> -static inline void remove_memory(int nid, u64 start, u64 size) {}
> +static inline bool remove_memory(int nid, u64 start, u64 size)
> +{
> +	return -EBUSY;
> +}
> +
>  static inline void __remove_memory(int nid, u64 start, u64 size) {}
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8c454e82d4f6..a826aededa1a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1778,9 +1778,10 @@ static int check_memblock_offlined_cb(struct memory_block *mem, void *arg)
>  		endpa = PFN_PHYS(section_nr_to_pfn(mem->end_section_nr + 1))-1;
>  		pr_warn("removing memory fails, because memory [%pa-%pa] is onlined\n",
>  			&beginpa, &endpa);
> -	}
>  
> -	return ret;
> +		return -EBUSY;
> +	}
> +	return 0;
>  }
>  
>  static int check_cpu_on_node(pg_data_t *pgdat)
> @@ -1843,19 +1844,9 @@ void try_offline_node(int nid)
>  }
>  EXPORT_SYMBOL(try_offline_node);
>  
> -/**
> - * remove_memory
> - * @nid: the node ID
> - * @start: physical address of the region to remove
> - * @size: size of the region to remove
> - *
> - * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> - * and online/offline operations before this call, as required by
> - * try_offline_node().
> - */
> -void __ref __remove_memory(int nid, u64 start, u64 size)
> +static int __ref try_remove_memory(int nid, u64 start, u64 size)
>  {
> -	int ret;
> +	int rc = 0;
>  
>  	BUG_ON(check_hotplug_memory_range(start, size));
>  
> @@ -1863,13 +1854,13 @@ void __ref __remove_memory(int nid, u64 start, u64 size)
>  
>  	/*
>  	 * All memory blocks must be offlined before removing memory.  Check
> -	 * whether all memory blocks in question are offline and trigger a BUG()
> +	 * whether all memory blocks in question are offline and return error
>  	 * if this is not the case.
>  	 */
> -	ret = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> -				check_memblock_offlined_cb);
> -	if (ret)
> -		BUG();
> +	rc = walk_memory_range(PFN_DOWN(start), PFN_UP(start + size - 1), NULL,
> +			       check_memblock_offlined_cb);
> +	if (rc)
> +		goto done;
>  
>  	/* remove memmap entry */
>  	firmware_map_remove(start, start + size, "System RAM");
> @@ -1879,14 +1870,42 @@ void __ref __remove_memory(int nid, u64 start, u64 size)
>  
>  	try_offline_node(nid);
>  
> +done:
>  	mem_hotplug_done();
> +	return rc;
>  }
>  
> -void remove_memory(int nid, u64 start, u64 size)
> +/**
> + * remove_memory
> + * @nid: the node ID
> + * @start: physical address of the region to remove
> + * @size: size of the region to remove
> + *
> + * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> + * and online/offline operations before this call, as required by
> + * try_offline_node().
> + */
> +void __remove_memory(int nid, u64 start, u64 size)
>  {
> +
> +	/*
> +	 * trigger BUG() is some memory is not offlined prior to calling this
> +	 * function
> +	 */
> +	if (try_remove_memory(nid, start, size))
> +		BUG();
> +}
> +
> +/* Remove memory if every memory block is offline, otherwise return false */

Comment is wrong "return false"

> +int remove_memory(int nid, u64 start, u64 size)
> +{
> +	int rc;
> +
>  	lock_device_hotplug();
> -	__remove_memory(nid, start, size);
> +	rc  = try_remove_memory(nid, start, size);
>  	unlock_device_hotplug();
> +
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(remove_memory);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
> 


Looks sane to me

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
