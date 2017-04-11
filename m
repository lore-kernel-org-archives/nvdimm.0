Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A34FF21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 15:17:58 -0700 (PDT)
Subject: Re: [PATCH v2] libnvdimm: fix clear poison locking with spinlock and
 mempool
References: <149194856068.47527.14334115580831385512.stgit@djiang5-desk3.ch.intel.com>
 <1491948751.2738.11.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <ef336d38-e443-4d31-a86d-220789b7b574@intel.com>
Date: Tue, 11 Apr 2017 15:17:57 -0700
MIME-Version: 1.0
In-Reply-To: <1491948751.2738.11.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 04/11/2017 03:13 PM, Verma, Vishal L wrote:
> On Tue, 2017-04-11 at 15:09 -0700, Dave Jiang wrote:
>> The following warning results from holding a lane spinlock,
>> preempt_disable(), or the btt map spinlock and then trying to take the
>> reconfig_mutex to walk the poison list and potentially add new
>> entries.
>>
>> BUG: sleeping function called from invalid context at
>> kernel/locking/mutex.
>> c:747
>> in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
>> [..]
>> Call Trace:
>> dump_stack+0x85/0xc8
>> ___might_sleep+0x184/0x250
>> __might_sleep+0x4a/0x90
>> __mutex_lock+0x58/0x9b0
>> ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
>> ? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
>> ? acpi_nfit_forget_poison+0x79/0x80 [nfit]
>> ? _raw_spin_unlock+0x27/0x40
>> mutex_lock_nested+0x1b/0x20
>> nvdimm_bus_lock+0x21/0x30 [libnvdimm]
>> nvdimm_forget_poison+0x25/0x50 [libnvdimm]
>> nvdimm_clear_poison+0x106/0x140 [libnvdimm]
>> nsio_rw_bytes+0x164/0x270 [libnvdimm]
>> btt_write_pg+0x1de/0x3e0 [nd_btt]
>> ? blk_queue_enter+0x30/0x290
>> btt_make_request+0x11a/0x310 [nd_btt]
>> ? blk_queue_enter+0xb7/0x290
>> ? blk_queue_enter+0x30/0x290
>> generic_make_request+0x118/0x3b0
>>
>> Two things are done to address this issue. First, we introduce a
>> spinlock to
>> protect the poison list. This allows us to not having to acquire the
>> reconfig_mutex for touching the poison list. Second, we allocate the
>> poison
>> entries using GFP_NOWAIT and avoid the sleep with GFP_KERNEL.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/nvdimm/bus.c      |   12 +++++++-----
>>  drivers/nvdimm/core.c     |   25 ++++++++-----------------
>>  drivers/nvdimm/nd-core.h  |    1 +
>>  include/linux/libnvdimm.h |    2 --
>>  4 files changed, 16 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> index 5ad2e59..fe41146 100644
>> --- a/drivers/nvdimm/bus.c
>> +++ b/drivers/nvdimm/bus.c
>> @@ -296,6 +296,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct
>> device *parent,
>>  	init_waitqueue_head(&nvdimm_bus->probe_wait);
>>  	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
>>  	mutex_init(&nvdimm_bus->reconfig_mutex);
>> +	spin_lock_init(&nvdimm_bus->poison_lock);
>>  	if (nvdimm_bus->id < 0) {
>>  		kfree(nvdimm_bus);
>>  		return NULL;
>> @@ -342,8 +343,9 @@ static int child_unregister(struct device *dev,
>> void *data)
>>  	return 0;
>>  }
>>  
>> -static void free_poison_list(struct list_head *poison_list)
>> +static void free_poison_list(struct nvdimm_bus *nvdimm_bus)
>>  {
>> +	struct list_head *poison_list = &nvdimm_bus->poison_list;
>>  	struct nd_poison *pl, *next;
> 
> This change isn't needed anymore in v2 right? (and the caller below)

Good catch!

> 
>>  
>>  	list_for_each_entry_safe(pl, next, poison_list, list) {
>> @@ -364,9 +366,9 @@ static int nd_bus_remove(struct device *dev)
>>  	nd_synchronize();
>>  	device_for_each_child(&nvdimm_bus->dev, NULL,
>> child_unregister);
>>  
>> -	nvdimm_bus_lock(&nvdimm_bus->dev);
>> -	free_poison_list(&nvdimm_bus->poison_list);
>> -	nvdimm_bus_unlock(&nvdimm_bus->dev);
>> +	spin_lock(&nvdimm_bus->poison_lock);
>> +	free_poison_list(nvdimm_bus);
>> +	spin_unlock(&nvdimm_bus->poison_lock);
>>  
>>  	nvdimm_bus_destroy_ndctl(nvdimm_bus);
>>  
>> @@ -990,7 +992,7 @@ static int __nd_ioctl(struct nvdimm_bus
>> *nvdimm_bus, struct nvdimm *nvdimm,
>>  
>>  		if (clear_err->cleared) {
>>  			/* clearing the poison list we keep track of
>> */
>> -			__nvdimm_forget_poison(nvdimm_bus, clear_err-
>>> address,
>> +			nvdimm_forget_poison(nvdimm_bus, clear_err-
>>> address,
>>  					clear_err->cleared);
>>  
>>  			/* now sync the badblocks lists */
>> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
>> index 40a3da0..9567b08 100644
>> --- a/drivers/nvdimm/core.c
>> +++ b/drivers/nvdimm/core.c
>> @@ -539,7 +539,7 @@ static int bus_add_poison(struct nvdimm_bus
>> *nvdimm_bus, u64 addr, u64 length)
>>  	struct nd_poison *pl;
>>  
>>  	if (list_empty(&nvdimm_bus->poison_list))
>> -		return add_poison(nvdimm_bus, addr, length,
>> GFP_KERNEL);
>> +		return add_poison(nvdimm_bus, addr, length,
>> GFP_NOWAIT);
>>  
>>  	/*
>>  	 * There is a chance this is a duplicate, check for those
>> first.
>> @@ -559,30 +559,29 @@ static int bus_add_poison(struct nvdimm_bus
>> *nvdimm_bus, u64 addr, u64 length)
>>  	 * as any overlapping ranges will get resolved when the list
>> is consumed
>>  	 * and converted to badblocks
>>  	 */
>> -	return add_poison(nvdimm_bus, addr, length, GFP_KERNEL);
>> +	return add_poison(nvdimm_bus, addr, length, GFP_NOWAIT);
>>  }
>>  
>>  int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr,
>> u64 length)
>>  {
>>  	int rc;
>>  
>> -	nvdimm_bus_lock(&nvdimm_bus->dev);
>> +	spin_lock(&nvdimm_bus->poison_lock);
>>  	rc = bus_add_poison(nvdimm_bus, addr, length);
>> -	nvdimm_bus_unlock(&nvdimm_bus->dev);
>> +	spin_unlock(&nvdimm_bus->poison_lock);
>>  
>>  	return rc;
>>  }
>>  EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
>>  
>> -void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
>> phys_addr_t start,
>> +void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t
>> start,
>>  		unsigned int len)
>>  {
>>  	struct list_head *poison_list = &nvdimm_bus->poison_list;
>>  	u64 clr_end = start + len - 1;
>>  	struct nd_poison *pl, *next;
>>  
>> -	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>> -
>> +	spin_lock(&nvdimm_bus->poison_lock);
>>  	WARN_ON_ONCE(list_empty(poison_list));
>>  
>>  	/*
>> @@ -629,21 +628,13 @@ void __nvdimm_forget_poison(struct nvdimm_bus
>> *nvdimm_bus, phys_addr_t start,
>>  			u64 new_len = pl_end - new_start + 1;
>>  
>>  			/* Add new entry covering the right half */
>> -			add_poison(nvdimm_bus, new_start, new_len,
>> GFP_NOIO);
>> +			add_poison(nvdimm_bus, new_start, new_len,
>> GFP_NOWAIT);
>>  			/* Adjust this entry to cover the left half
>> */
>>  			pl->length = start - pl->start;
>>  			continue;
>>  		}
>>  	}
>> -}
>> -EXPORT_SYMBOL_GPL(__nvdimm_forget_poison);
>> -
>> -void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
>> -		phys_addr_t start, unsigned int len)
>> -{
>> -	nvdimm_bus_lock(&nvdimm_bus->dev);
>> -	__nvdimm_forget_poison(nvdimm_bus, start, len);
>> -	nvdimm_bus_unlock(&nvdimm_bus->dev);
>> +	spin_unlock(&nvdimm_bus->poison_lock);
>>  }
>>  EXPORT_SYMBOL_GPL(nvdimm_forget_poison);
>>  
>> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
>> index 8623e57..4c4bd20 100644
>> --- a/drivers/nvdimm/nd-core.h
>> +++ b/drivers/nvdimm/nd-core.h
>> @@ -32,6 +32,7 @@ struct nvdimm_bus {
>>  	struct list_head poison_list;
>>  	struct list_head mapping_list;
>>  	struct mutex reconfig_mutex;
>> +	spinlock_t poison_lock;
>>  };
>>  
>>  struct nvdimm {
>> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
>> index 1c609e8..98b2076 100644
>> --- a/include/linux/libnvdimm.h
>> +++ b/include/linux/libnvdimm.h
>> @@ -122,8 +122,6 @@ static inline struct nd_blk_region_desc
>> *to_blk_region_desc(
>>  int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr,
>> u64 length);
>>  void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
>>  		phys_addr_t start, unsigned int len);
>> -void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
>> -		phys_addr_t start, unsigned int len);
>>  struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
>>  		struct nvdimm_bus_descriptor *nfit_desc);
>>  void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
