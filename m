Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F62A449983;
	Thu,  9 Jul 2026 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622929; cv=none; b=g0akSuD/U1Qqrc7RoiEwArHjTJ4jEKzZbch0IhE92YT1vpOJj9EEBTOCP9Q29YGO+cMCJAy+/MdWLFED5tcD18O27YAEObCZTN4q44VRA/Grv7Th/CHPzbyN/rFTT9YhT+E4NjNgDfuYAepKOa9FkodvdkDvk0U9tzzRr1lqGSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622929; c=relaxed/simple;
	bh=eQe38nCcFVma1LFoo+FfKYEwuC+uAK1QDlLMvNStl/w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2rfI2NmyP0bUa0s1fs6ikKt8GYXpFAAHJr8EpnaE3MfD8C9jN3BM2n0Q7+8osiFbwyXQQLp4pLEkaARCMysUwuFEeZm4h5PGrxh0W5w9Lv6ZSDktnzNjYcYWXXV8vv3NIYiGBZEHiYumEyt9CQ5A89fTVtuPGy86TQza2BFi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A4V9I73E; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A4V9I73E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783622926; x=1815158926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eQe38nCcFVma1LFoo+FfKYEwuC+uAK1QDlLMvNStl/w=;
  b=A4V9I73ErKuPhUmkpqwVvKDqQzGKaKapXs+8k+IgIjPl1m2txS/eslGe
   ov5k2Zj+61uJ0No/lEUzGlkkqGIZvCe5+hTqGz21rOnevjvBsA1UiNYnR
   6vpHZAsBQ3Wg/et8KHaxcX1WvMZdhD4/YGv54AghdQ/WmF4ZfQZSJPLgb
   rRWjxlzb/jGJTOmzmGJVBiraa4WkD2oNkOqvOBDoHacfojZKVSbEQyGHD
   q1aR1rM1SEDRbQu/+1Suw/XdBBvqD2VnIh2jAujToiPnwcdrshdTnDRTK
   QotkPGxxwVsJNyZ8KIUV6HzINzee4kymIlACa7p3oAwWAnLhVfAcGc32W
   Q==;
X-CSE-ConnectionGUID: RuuJcIqJQsWrv8kzGbjdZA==
X-CSE-MsgGUID: vLAns/mSQx6+mHqk+jIRiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84510524"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84510524"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:48:39 -0700
X-CSE-ConnectionGUID: kYtsmSMOTf29rCwwFr7afQ==
X-CSE-MsgGUID: KmQqYJpaQhGKsg7QNVCUnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252932157"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:48:37 -0700
Message-ID: <da2b9492-8b92-42dd-9906-e8942a42105d@intel.com>
Date: Thu, 9 Jul 2026 11:48:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/10] mm/memory_hotplug: add
 __add_memory_driver_managed() with online_type arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-6-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Existing callers of add_memory_driver_managed cannot select the
> preferred online type (ZONE_NORMAL vs ZONE_MOVABLE), requiring it to
> hot-add memory as offline blocks, and then follow up by onlining each
> memory block individually.
> 
> Most drivers prefer the system default, but the CXL driver wants to
> plumb a preferred policy through the dax kmem driver.
> 
> Refactor APIs to add a new interface which allows the dax kmem module
> to select a preferred policy.
> 
> Overriding the configured auto-online policy is only safe for known
> in-tree modules, where we know the override reflects a different,
> user-requested policy.  We do not want arbitrary out-of-tree drivers
> silently overriding the system-wide onlining policy, so restrict the
> new interface to the kmem module using EXPORT_SYMBOL_FOR_MODULES()
> rather than a plain EXPORT_SYMBOL_GPL().  Other in-tree modules (e.g.
> cxl_core) can be added to the allowed list as the need arises.
> 
> Refactor add_memory_driver_managed, extract __add_memory_driver_managed
> - Add proper kernel-doc for add_memory_driver_managed while refactoring
> - New helper accepts an explicit online_type.
> - New helper validates online_type is between OFFLINE and ONLINE_MOVABLE
> 
> Refactor: add_memory_resource, extract __add_memory_resource
> - new helper accepts an explicit online_type
> 
> Original APIs now explicitly pass the system-default to new helpers.
> 
> No functional change for existing users.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h |  3 ++
>  mm/memory_hotplug.c            | 61 +++++++++++++++++++++++++++++-----
>  2 files changed, 56 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 4d51fcb93a37..ff3b865ea7e7 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -295,6 +295,9 @@ extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
>  extern int add_memory_resource(int nid, struct resource *resource,
>  			       mhp_t mhp_flags);
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +				const char *resource_name, mhp_t mhp_flags,
> +				enum mmop online_type);
>  extern int add_memory_driver_managed(int nid, u64 start, u64 size,
>  				     const char *resource_name,
>  				     mhp_t mhp_flags);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 494257054095..a66346def504 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1494,10 +1494,10 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   *
>   * we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG
>   */
> -int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +static int __add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags,
> +				 enum mmop online_type)
>  {
>  	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> -	enum mmop online_type = mhp_get_default_online_type();
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>  	struct memory_group *group = NULL;
>  	u64 start, size;
> @@ -1585,7 +1585,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  		merge_system_ram_resource(res);
>  
>  	/* online pages if requested */
> -	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> +	if (online_type != MMOP_OFFLINE)
>  		walk_memory_blocks(start, size, &online_type,
>  				   online_memory_block);
>  
> @@ -1603,7 +1603,13 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	return ret;
>  }
>  
> -/* requires device_hotplug_lock, see add_memory_resource() */
> +int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
> +{
> +	return __add_memory_resource(nid, res, mhp_flags,
> +				     mhp_get_default_online_type());
> +}
> +
> +/* requires device_hotplug_lock, see __add_memory_resource() */
>  int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>  {
>  	struct resource *res;
> @@ -1631,7 +1637,15 @@ int add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags)
>  }
>  EXPORT_SYMBOL_GPL(add_memory);
>  
> -/*
> +/**
> + * __add_memory_driver_managed - add driver-managed memory with explicit online_type
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + * @online_type: Auto-Online behavior (offline, online, kernel, movable)
> + *
>   * Add special, driver-managed memory to the system as system RAM. Such
>   * memory is not exposed via the raw firmware-provided memmap as system
>   * RAM, instead, it is detected and added by a driver - during cold boot,
> @@ -1639,6 +1653,7 @@ EXPORT_SYMBOL_GPL(add_memory);
>   *
>   * Reasons why this memory should not be used for the initial memmap of a
>   * kexec kernel or for placing kexec images:
> + *
>   * - The booting kernel is in charge of determining how this memory will be
>   *   used (e.g., use persistent memory as system RAM)
>   * - Coordination with a hypervisor is required before this memory
> @@ -1651,9 +1666,12 @@ EXPORT_SYMBOL_GPL(add_memory);
>   *
>   * The resource_name (visible via /proc/iomem) has to have the format
>   * "System RAM ($DRIVER)".
> + *
> + * Return: 0 on success, negative error code on failure.
>   */
> -int add_memory_driver_managed(int nid, u64 start, u64 size,
> -			      const char *resource_name, mhp_t mhp_flags)
> +int __add_memory_driver_managed(int nid, u64 start, u64 size,
> +		const char *resource_name, mhp_t mhp_flags,
> +		enum mmop online_type)
>  {
>  	struct resource *res;
>  	int rc;
> @@ -1663,6 +1681,9 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  	    resource_name[strlen(resource_name) - 1] != ')')
>  		return -EINVAL;
>  
> +	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
> +
>  	lock_device_hotplug();
>  
>  	res = register_memory_resource(start, size, resource_name);
> @@ -1671,7 +1692,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  		goto out_unlock;
>  	}
>  
> -	rc = add_memory_resource(nid, res, mhp_flags);
> +	rc = __add_memory_resource(nid, res, mhp_flags, online_type);
>  	if (rc < 0)
>  		release_memory_resource(res);
>  
> @@ -1679,6 +1700,30 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
>  	unlock_device_hotplug();
>  	return rc;
>  }
> +EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
> +
> +/**
> + * add_memory_driver_managed - add driver-managed memory
> + * @nid: NUMA node ID where the memory will be added
> + * @start: Start physical address of the memory range
> + * @size: Size of the memory range in bytes
> + * @resource_name: Resource name in format "System RAM ($DRIVER)"
> + * @mhp_flags: Memory hotplug flags
> + *
> + * Add driver-managed memory with the system default online type set by
> + * build config or kernel boot parameter.
> + *
> + * See __add_memory_driver_managed for more details.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int add_memory_driver_managed(int nid, u64 start, u64 size,
> +			      const char *resource_name, mhp_t mhp_flags)
> +{
> +	return __add_memory_driver_managed(nid, start, size, resource_name,
> +			mhp_flags,
> +			mhp_get_default_online_type());
> +}
>  EXPORT_SYMBOL_GPL(add_memory_driver_managed);
>  
>  /*

