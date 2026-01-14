Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6751A38A280;
	Wed, 14 Jan 2026 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768386100; cv=none; b=qtLlIH+mlq83afE+emJzgC+PD/vQnWT1FhlBq/mMdIf4Aw3oOE5kjhtR9i2Se9tdWh7ocFS78fUyZoEgAcPlGm7vJsn5/uzP4GVqPfiWPxQwmIBFfhKUownXCNzHEBXWLVR3c5YpmAyTuGAHzwIUp3/hvcXNPYCognAUVlyRUjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768386100; c=relaxed/simple;
	bh=dR3qY5H03vmCPmwiWE/Ol6xHu9f+QHLOlM/lwC6MVSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3g1PVgE2nMRmDKXfGTZaJbNeQCHDsW/buhmtP55VJvQDjkF53mcCMLuhklyPcosiNMDkbUJ9pV2553MusRiXnfYxbzgGJMq9nQxe2QxCRHgvSFkcV/SbabUapmzFxVrROwSJiR/1qCozPBm/TY3f4oQlaUCRUvFnLJXo1Amu1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBWjGqhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBWjGqhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE5C4CEF7;
	Wed, 14 Jan 2026 10:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768386099;
	bh=dR3qY5H03vmCPmwiWE/Ol6xHu9f+QHLOlM/lwC6MVSw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lBWjGqhcI2v+Rn3qGOPRNBALX+51iuz8W8YJNFc90uM3aPZshbIie02KuJWSA2oGB
	 Is0zvPkwo2J3M7UYLFRXNe4q0G58tZfXYe0L9rX7bUl7bLSqmznfN56M1Tmrk+Yetv
	 Z3lE8U/OoDJTx00QFYbUn0vMO5nDJdztPSUu2zeoX/Fsx8OMPvbk5myKZBg3ceZ/+b
	 rlrwUI+PcC5qrHrmS9NhshWtDwYWL1OZR0WvNLqxB/rCUmN/+dhYkkFazWGxSoXmFE
	 iS09g6BTh78dc9qKzDLmnHs+EATo5eHtifNt2SWKYkSyIH33Dtpg0w/TAOLXBdTxk9
	 Pj0H9dWO4SnCQ==
Message-ID: <b3d435d2-643f-4dad-9928-bc7fb5080181@kernel.org>
Date: Wed, 14 Jan 2026 11:21:34 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/memory_hotplug: add APIs for explicit online type
 control
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-4-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <20260114085201.3222597-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 09:51, Gregory Price wrote:
> Add new memory hotplug APIs that allow callers to explicitly control
> the online type when adding or managing memory:
> 
>    - Extend add_memory_driver_managed() with an online_type parameter:
>      Callers can now specify MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
>      MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave
>      memory offline, or MMOP_SYSTEM_DEFAULT to use the system default
>      policy. Update virtio_mem to pass MMOP_SYSTEM_DEFAULT to maintain
>      existing behavior.

I wonder if we rather want to add a new interface 
(add_and_online_memory_driver_managed()) where we can restrict it to 
known kernel modules that do not violate user-space onlining policies.

For dax we know that user space will define the policy.

> 
>    - online_memory_range(): online a previously-added memory range with
>      a specified online type (MMOP_ONLINE, MMOP_ONLINE_KERNEL, or
>      MMOP_ONLINE_MOVABLE). Validates that the type is valid for onlining.

Why not simply online_memory() and offline_memory() ?

> 
>    - offline_memory(): offline a memory range without removing it. This
>      is a wrapper around the internal __offline_memory() that handles
>      locking. Useful for drivers that want to offline memory blocks
>      before performing other operations.
> 

These two should be not exported to arbitrary kernel modules. Use 
EXPORT_SYMBOL_FOR_MODULES() if required, or do not export them at all.

> These APIs enable drivers like dax_kmem to implement sophisticated
> memory management policies, such as adding memory offline and deferring
> the online decision to userspace.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   drivers/dax/kmem.c             |  3 +-
>   drivers/virtio/virtio_mem.c    |  3 +-
>   include/linux/memory_hotplug.h |  4 ++-
>   mm/memory_hotplug.c            | 63 ++++++++++++++++++++++++++++++++--
>   4 files changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index c036e4d0b610..5e0cf94a9620 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -175,7 +175,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>   		 * this as RAM automatically.
>   		 */
>   		rc = add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, mhp_flags);
> +				range_len(&range), kmem_name, mhp_flags,
> +				MMOP_SYSTEM_DEFAULT);
>   
>   		if (rc) {
>   			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 1688ecd69a04..b1ec8f2b9e31 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c
> @@ -654,7 +654,8 @@ static int virtio_mem_add_memory(struct virtio_mem *vm, uint64_t addr,
>   	/* Memory might get onlined immediately. */
>   	atomic64_add(size, &vm->offline_size);
>   	rc = add_memory_driver_managed(vm->mgid, addr, size, vm->resource_name,
> -				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID);
> +				       MHP_MERGE_RESOURCE | MHP_NID_IS_MGID,
> +				       MMOP_SYSTEM_DEFAULT);
>   	if (rc) {
>   		atomic64_sub(size, &vm->offline_size);
>   		dev_warn(&vm->vdev->dev, "adding memory failed: %d\n", rc);
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index d5407264d72a..0f98bea6da65 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -265,6 +265,7 @@ static inline void pgdat_resize_init(struct pglist_data *pgdat) {}
>   extern void try_offline_node(int nid);
>   extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>   			 struct zone *zone, struct memory_group *group);
> +extern int offline_memory(u64 start, u64 size);

No new "extern" for functions.

>   extern int remove_memory(u64 start, u64 size);
>   extern void __remove_memory(u64 start, u64 size);
>   extern int offline_and_remove_memory(u64 start, u64 size);
> @@ -297,7 +298,8 @@ extern int add_memory_resource(int nid, struct resource *resource,
>   			       mhp_t mhp_flags);
>   extern int add_memory_driver_managed(int nid, u64 start, u64 size,
>   				     const char *resource_name,
> -				     mhp_t mhp_flags);
> +				     mhp_t mhp_flags, int online_type);
> +extern int online_memory_range(u64 start, u64 size, int online_type);
>   extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   				   unsigned long nr_pages,
>   				   struct vmem_altmap *altmap, int migratetype,
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index ab73c8fcc0f1..515ff9d18039 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1343,6 +1343,34 @@ static int online_memory_block(struct memory_block *mem, void *arg)
>   	return device_online(&mem->dev);
>   }
>   
> +/**
> + * online_memory_range - online memory blocks in a range
> + * @start: physical start address of memory region
> + * @size: size of memory region
> + * @online_type: MMOP_ONLINE, MMOP_ONLINE_KERNEL, or MMOP_ONLINE_MOVABLE

I wonder if we instead want something that consumes all parameters like

int online_or_offline_memory(int online_type)

Then it's easier to use and we don't really have to document the 
"online_type" that much to hand-select some values.

(I'm sure there are better nameing suggestions :) )


Should we document what happens if the memory is already online, but was 
onlined to a different zone?

> + *
> + * Online all memory blocks in the specified range with the given online type.
> + * The memory must have already been added to the system.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +int online_memory_range(u64 start, u64 size, int online_type)
> +{
> +	int rc;
> +
> +	if (online_type == MMOP_OFFLINE ||
> +	    online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
> +	lock_device_hotplug();
> +	rc = walk_memory_blocks(start, size, &online_type,
> +				online_memory_block);
> +	unlock_device_hotplug();
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(online_memory_range);
> +
>   #ifndef arch_supports_memmap_on_memory
>   static inline bool arch_supports_memmap_on_memory(unsigned long vmemmap_size)
>   {
> @@ -1656,9 +1684,16 @@ EXPORT_SYMBOL_GPL(add_memory);
>    *
>    * The resource_name (visible via /proc/iomem) has to have the format
>    * "System RAM ($DRIVER)".
> + *
> + * @online_type specifies the online behavior: MMOP_ONLINE, MMOP_ONLINE_KERNEL,
> + * MMOP_ONLINE_MOVABLE to online with that type, MMOP_OFFLINE to leave offline,
> + * or MMOP_SYSTEM_DEFAULT to use the system default policy.
> + *

I think we can simplify this documentation. Especially, one 
MMOP_SYSTEM_DEFAULT is gone.

> + * Returns 0 on success, negative error code on failure.
>    */
>   int add_memory_driver_managed(int nid, u64 start, u64 size,
> -			      const char *resource_name, mhp_t mhp_flags)
> +			      const char *resource_name, mhp_t mhp_flags,
> +			      int online_type)
>   {
>   	struct resource *res;
>   	int rc;
> @@ -1668,6 +1703,13 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>   	    resource_name[strlen(resource_name) - 1] != ')')
>   		return -EINVAL;
>   
> +	/* Convert system default to actual online type */
> +	if (online_type == MMOP_SYSTEM_DEFAULT)
> +		online_type = mhp_get_default_online_type();
> +
> +	if (online_type < 0 || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>   	lock_device_hotplug();
>   
>   	res = register_memory_resource(start, size, resource_name);
> @@ -1676,7 +1718,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>   		goto out_unlock;
>   	}
>   
> -	rc = add_memory_resource(nid, res, mhp_flags);
> +	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
>   	if (rc < 0)
>   		release_memory_resource(res);
>   
> @@ -2412,6 +2454,23 @@ static int __offline_memory(u64 start, u64 size)
>   	return rc;
>   }
>   
> +/*
> + * Try to offline a memory range. Might take a long time to finish in case
> + * memory is still in use. In case of failure, already offlined memory blocks
> + * will be re-onlined.
> + */

Proper kerneldoc? :)

> +int offline_memory(u64 start, u64 size)
> +{
> +	int rc;
> +
> +	lock_device_hotplug();
> +	rc = __offline_memory(start, size);
> +	unlock_device_hotplug();
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(offline_memory);
> +
>   /*
>    * Try to offline and remove memory. Might take a long time to finish in case
>    * memory is still in use. Primarily useful for memory devices that logically


-- 
Cheers

David
