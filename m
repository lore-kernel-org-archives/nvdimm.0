Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67B41868
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 06:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686897431; x=1718433431;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=lhxN1g1baqKTY5d9KGHAVK+vUiIK8HZoj801iDtHTbg=;
  b=VK81I4zrdNwl0Blo+GXcXGMMWWqr5U+ZwVXTM2gr5V+Oha1CElvF8IY4
   dCTaeMT0FRehAW5FwhtDpxa04zIh+TbJc5dfQcRgjfksThBU7ovYDGyhj
   1OzDK18iCpk+ZIx7JOC7xMW1b1ovNhoK/pBZvuCSoz+WggQ1mdJOJ9Ej3
   D+Mz1vDNboYSpYMcItUSguny2UT7xjEcpm2dYd91F7yo2M5u29nLV7lOK
   +epeBEVUQhpyU8w1B66RKXtrYK/fvzK0wyu+2AXJxiu6pGJ4NnCTyQxbh
   0me1X3TAVs+n0Z/7IeIYNTyZQeSDO3CeeW2sv+gHTtQUjeXZ2P8OVbRCX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387807160"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="387807160"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:37:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="742548150"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="742548150"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 23:37:06 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,  Len Brown <lenb@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Oscar Salvador <osalvador@suse.de>,  Dan Williams
 <dan.j.williams@intel.com>,  Dave Jiang <dave.jiang@intel.com>,
  <linux-acpi@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <linux-mm@kvack.org>,  <nvdimm@lists.linux.dev>,
  <linux-cxl@vger.kernel.org>,  Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 1/3] mm/memory_hotplug: Allow an override for the
 memmap_on_memory param
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
	<20230613-vv-kmem_memmap-v1-1-f6de9c6af2c6@intel.com>
Date: Fri, 16 Jun 2023 14:35:32 +0800
In-Reply-To: <20230613-vv-kmem_memmap-v1-1-f6de9c6af2c6@intel.com> (Vishal
	Verma's message of "Thu, 15 Jun 2023 16:00:23 -0600")
Message-ID: <874jn7gbij.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Hi, Vishal,

Thanks for your patch!

Vishal Verma <vishal.l.verma@intel.com> writes:

> For memory hotplug to consider MHP_MEMMAP_ON_MEMORY behavior, the
> 'memmap_on_memory' module parameter was a hard requirement.
>
> In preparation for the dax/kmem driver to use memmap_on_memory
> semantics, arrange for the module parameter check to be bypassed via the
> appropriate mhp_flag.
>
> Recall that the kmem driver could contribute huge amounts of hotplugged
> memory originating from special purposes devices such as CXL memory
> expanders. In some cases memmap_on_memory may be the /only/ way this new
> memory can be hotplugged. Hence it makes sense for kmem to have a way to
> force memmap_on_memory without depending on a module param, if all the
> other conditions for it are met.
>
> The only other user of this interface is acpi/acpi_memoryhotplug.c,
> which only enables the mhp_flag if an initial
> mhp_supports_memmap_on_memory() test passes. Maintain the existing
> behavior and semantics for this by performing the initial check from
> acpi without the MHP_MEMMAP_ON_MEMORY flag, so its decision falls back
> to the module parameter.
>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  include/linux/memory_hotplug.h |  2 +-
>  drivers/acpi/acpi_memhotplug.c |  2 +-
>  mm/memory_hotplug.c            | 24 ++++++++++++++++--------
>  3 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 9fcbf5706595..c9ddcd3cad70 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -358,7 +358,7 @@ extern struct zone *zone_for_pfn_range(int online_type, int nid,
>  extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>  				      struct mhp_params *params);
>  void arch_remove_linear_mapping(u64 start, u64 size);
> -extern bool mhp_supports_memmap_on_memory(unsigned long size);
> +extern bool mhp_supports_memmap_on_memory(unsigned long size, mhp_t mhp_flags);
>  #endif /* CONFIG_MEMORY_HOTPLUG */
>  
>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 24f662d8bd39..119d3bb49753 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -211,7 +211,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>  		if (!info->length)
>  			continue;
>  
> -		if (mhp_supports_memmap_on_memory(info->length))
> +		if (mhp_supports_memmap_on_memory(info->length, 0))
>  			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
>  		result = __add_memory(mgid, info->start_addr, info->length,
>  				      mhp_flags);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 8e0fa209d533..bb3845830922 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1283,15 +1283,21 @@ static int online_memory_block(struct memory_block *mem, void *arg)
>  	return device_online(&mem->dev);
>  }
>  
> -bool mhp_supports_memmap_on_memory(unsigned long size)
> +bool mhp_supports_memmap_on_memory(unsigned long size, mhp_t mhp_flags)
>  {
>  	unsigned long nr_vmemmap_pages = size / PAGE_SIZE;
>  	unsigned long vmemmap_size = nr_vmemmap_pages * sizeof(struct page);
>  	unsigned long remaining_size = size - vmemmap_size;
>  
>  	/*
> -	 * Besides having arch support and the feature enabled at runtime, we
> -	 * need a few more assumptions to hold true:
> +	 * The MHP_MEMMAP_ON_MEMORY flag indicates a caller that wants to force
> +	 * memmap_on_memory (if other conditions are met), regardless of the
> +	 * module parameter. drivers/dax/kmem.c is an example, where large
> +	 * amounts of hotplug memory may come from, and the only option to
> +	 * successfully online all of it is to place the memmap on this memory.
> +	 *
> +	 * Besides having arch support and the feature enabled at runtime or
> +	 * via the mhp_flag, we need a few more assumptions to hold true:
>  	 *
>  	 * a) We span a single memory block: memory onlining/offlinin;g happens
>  	 *    in memory block granularity. We don't want the vmemmap of online
> @@ -1315,10 +1321,12 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
>  	 *       altmap as an alternative source of memory, and we do not exactly
>  	 *       populate a single PMD.
>  	 */
> -	return mhp_memmap_on_memory() &&
> -	       size == memory_block_size_bytes() &&
> -	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
> -	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
> +
> +	if ((mhp_flags & MHP_MEMMAP_ON_MEMORY) || mhp_memmap_on_memory())
> +		return size == memory_block_size_bytes() &&
> +		       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
> +		       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
> +	return false;
>  }
>  
>  /*
> @@ -1375,7 +1383,7 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	 * Self hosted memmap array
>  	 */
>  	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
> -		if (!mhp_supports_memmap_on_memory(size)) {
> +		if (!mhp_supports_memmap_on_memory(size, mhp_flags)) {
>  			ret = -EINVAL;
>  			goto error;
>  		}

It appears that we need to deal with the hot-remove path too.
try_remove_memory() will call mhp_memmap_on_memory() and only work with
MHP_MEMMAP_ON_MEMORY properly if it returns true.

Best Regards,
Huang, Ying
