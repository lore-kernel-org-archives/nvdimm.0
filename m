Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE64499AC;
	Thu,  9 Jul 2026 21:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783633471; cv=none; b=UllVjO1dCZf/KWJXoKSwes8WEL19Cl5gUke12PwOwHZBa5Tsp1NG57Ud4kTr/9YQdTI3aRDK2R3XhkWCxovD2610/cxQJNdk2Fp+rS3vrc4vTspqsCOTAStVw0wnr7p3WivXrFze+ePva+eSyYOOQiTp74z2mi5/EVSpdR3NtcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783633471; c=relaxed/simple;
	bh=BObZMaKMQwNaBc5bWZEg12yZy5mXZHwoUpM7xb652TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HAr68kS0lkhxoWrDhWZvuHC6lVY8Hj3BvnEfwxFaFCbo/u5HuPpHY+O/cunwsw77PzrXbcT6AU+3YjjfV8kcAYA5CbmoSt/71xQdudKWAO62IsNXdNrntGF7okN59a3ceMUr2uwXI/ekXZUyc0CZeW95MYj+44mNeL23J+t2+3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kp3llzOX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kp3llzOX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783633470; x=1815169470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BObZMaKMQwNaBc5bWZEg12yZy5mXZHwoUpM7xb652TY=;
  b=Kp3llzOXkpHl3IU9un+nBwWc188i25S0lUuAMySbQq3LBPDZaS9gIQ8A
   CmnHZJCtqK4AULURyT7xFDguApRncYeyp2RQs+PM3lM9nD6e9ffGCWopY
   jVuzihroa4zSA74yiMXm+aDcUm5+kUZS0vMTzHv+lUALYaAdrPcPYVR5b
   W/nYw+HA+eDwq3UPLimWe47M7p4bg8b8u97lfPCNvTNst1DpYji8F8rmE
   jFe4rsjy0H7snfg9nfHcRgdmS6/z2DKqFvHacdQvAhP7LtofpSNVGiXAb
   x9mLU7cUFUYqRPFA9ArhwTL0RKrkHdSipTifYfbxDDP6ihkHjgLz2gsYz
   w==;
X-CSE-ConnectionGUID: SldHbFVXTvS4JtEnvSNRmA==
X-CSE-MsgGUID: DfBEyyeWSoiGY+nJOEL3+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84303721"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84303721"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:44:29 -0700
X-CSE-ConnectionGUID: cjLYVWuTR82KzalZcvN6rA==
X-CSE-MsgGUID: z39CMn7uSRGxOu1k99Rp4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="250287497"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:44:27 -0700
Message-ID: <151783f1-c0e4-4c2b-a051-1e6e9c546cae@intel.com>
Date: Thu, 9 Jul 2026 14:44:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/10] dax/kmem: extract hotplug/hotremove helper
 functions
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-9-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> Refactor kmem _probe() _remove() by extracting init, cleanup, hotplug,
> and hot-remove logic into separate helper functions:
> 
>   - dax_kmem_init_resources: inits IO_RESOURCE w/ request_mem_region
>   - dax_kmem_cleanup_resources: cleans up initialized IO_RESOURCE
>   - dax_kmem_do_hotplug: handles memory region reservation and adding
>   - dax_kmem_do_hotremove: handles memory removal and resource cleanup
> 
> This is a pure refactoring with no functional change. The helpers will
> enable future extensions to support more granular control over memory
> hotplug operations.
> 
> We need to split hotplug/hotunplug and init/cleanup in order to have the
> resources available for hot-add.  Otherwise, when probe occurs, the dax
> devices are never added to sysfs because the resources are never
> registered.
> 
> Detatching hotunplug/cleanup allows us to re-use the hotunplug code
> without destroying the underlying resources.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Minor comment below

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/kmem.c | 327 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 225 insertions(+), 102 deletions(-)
> 
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 0a184c0878dd..72dcccee41e1 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -63,14 +63,206 @@ static void kmem_put_memory_types(void)
>  	mt_put_memory_types(&kmem_memory_types);
>  }
>  
> +/**
> + * dax_kmem_do_hotplug - hotplug memory for dax kmem device
> + * @dev_dax: the dev_dax instance
> + * @data: the dax_kmem_data structure with resource tracking
> + *
> + * Hotplugs all ranges in the dev_dax region as system memory.
> + *
> + * Returns the number of successfully mapped ranges, or negative error.
> + */
> +static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
> +			       struct dax_kmem_data *data,
> +			       int online_type)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	int i, rc, onlined = 0;
> +	mhp_t mhp_flags;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +
> +		rc = dax_kmem_range(dev_dax, i, &range);
> +		if (rc)
> +			continue;
> +
> +		/*
> +		 * init_resources() is best-effort: if a reservation conflict
> +		 * occurs it keeps the range but leaves res[i]=NULL. For hotplug
> +		 * on probe systems, this means kmem will partially online.
> +		 *
> +		 * We have to keep this behavior not to break those systems.
> +		 * For those systems - atomicity only applies to valid ranges.
> +		 */
> +		if (!data->res[i])
> +			continue;
> +
> +		mhp_flags = MHP_NID_IS_MGID;
> +		if (dev_dax->memmap_on_memory)
> +			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
> +
> +		/*
> +		 * Ensure that future kexec'd kernels will not treat
> +		 * this as RAM automatically.
> +		 */
> +		rc = __add_memory_driver_managed(data->mgid, range.start,
> +				range_len(&range), kmem_name, mhp_flags,
> +				online_type);
> +
> +		if (rc) {
> +			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> +				 i, range.start, range.end);
> +			/*
> +			 * Release the reservation for the range that failed to
> +			 * add so a later hotremove does not try to remove memory
> +			 * that was never added.
> +			 */
> +			if (data->res[i]) {
> +				remove_resource(data->res[i]);
> +				kfree(data->res[i]);
> +				data->res[i] = NULL;
> +			}
> +			if (onlined)
> +				continue;
> +			return rc;
> +		}
> +		onlined++;
> +	}
> +
> +	return onlined;
> +}
> +
> +/**
> + * dax_kmem_init_resources - create memory regions for dax kmem
> + * @dev_dax: the dev_dax instance
> + * @data: the dax_kmem_data structure with resource tracking
> + *
> + * Initializes all the resources for the DAX
> + *
> + * Returns the number of successfully mapped ranges, or negative error.
> + */
> +static int dax_kmem_init_resources(struct dev_dax *dev_dax,
> +				   struct dax_kmem_data *data)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	int i, rc, mapped = 0;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct resource *res;
> +		struct range range;
> +
> +		rc = dax_kmem_range(dev_dax, i, &range);
> +		if (rc)
> +			continue;
> +
> +		/* Skip ranges already added */
> +		if (data->res[i])
> +			continue;
> +
> +		/* Region is permanently reserved if hotremove fails. */
> +		res = request_mem_region(range.start, range_len(&range),
> +					 data->res_name);
> +		if (!res) {
> +			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
> +				 i, range.start, range.end);
> +			/*
> +			 * Once some memory has been onlined we can't
> +			 * assume that it can be un-onlined safely.
> +			 */
> +			if (mapped)
> +				continue;
> +			return -EBUSY;
> +		}
> +		data->res[i] = res;
> +		/*
> +		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
> +		 * so that add_memory() can add a child resource.  Do not
> +		 * inherit flags from the parent since it may set new flags
> +		 * unknown to us that will break add_memory() below.

'later' instead of 'below'? Comment reflects previous function flow that is no longer the case.

DJ

> +		 */
> +		res->flags = IORESOURCE_SYSTEM_RAM;
> +		mapped++;
> +	}
> +	return mapped;
> +}
> +
> +#ifdef CONFIG_MEMORY_HOTREMOVE
> +/**
> + * dax_kmem_do_hotremove - hot-remove memory for dax kmem device
> + * @dev_dax: the dev_dax instance
> + * @data: the dax_kmem_data structure with resource tracking
> + *
> + * Removes all ranges in the dev_dax region.
> + *
> + * Returns the number of successfully removed ranges.
> + */
> +static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
> +				 struct dax_kmem_data *data)
> +{
> +	struct device *dev = &dev_dax->dev;
> +	int i, success = 0;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		struct range range;
> +		int rc;
> +
> +		rc = dax_kmem_range(dev_dax, i, &range);
> +		if (rc)
> +			continue;
> +
> +		/* range was never added during probe, count as removed */
> +		if (!data->res[i]) {
> +			success++;
> +			continue;
> +		}
> +
> +		rc = remove_memory(range.start, range_len(&range));
> +		if (rc == 0) {
> +			/* Release the resource for the successfully removed range */
> +			remove_resource(data->res[i]);
> +			kfree(data->res[i]);
> +			data->res[i] = NULL;
> +			success++;
> +			continue;
> +		}
> +		any_hotremove_failed = true;
> +		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
> +			i, range.start, range.end);
> +	}
> +
> +	return success;
> +}
> +#endif /* CONFIG_MEMORY_HOTREMOVE */
> +
> +/**
> + * dax_kmem_cleanup_resources - remove the dax memory resources
> + * @dev_dax: the dev_dax instance
> + * @data: the dax_kmem_data structure with resource tracking
> + *
> + * Removes all resources in the dev_dax region.
> + */
> +static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
> +				       struct dax_kmem_data *data)
> +{
> +	int i;
> +
> +	for (i = 0; i < dev_dax->nr_range; i++) {
> +		if (!data->res[i])
> +			continue;
> +		remove_resource(data->res[i]);
> +		kfree(data->res[i]);
> +		data->res[i] = NULL;
> +	}
> +}
> +
>  static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  {
>  	struct device *dev = &dev_dax->dev;
>  	unsigned long total_len = 0, orig_len = 0;
>  	struct dax_kmem_data *data;
>  	struct memory_dev_type *mtype;
> -	int i, rc, mapped = 0;
> -	mhp_t mhp_flags;
> +	int i, rc;
>  	int numa_node;
>  	int online_type;
>  	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
> @@ -133,73 +325,27 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
>  
> +	dev_set_drvdata(dev, data);
> +
> +	rc = dax_kmem_init_resources(dev_dax, data);
> +	if (rc < 0)
> +		goto err_resources;
> +
>  	/* Resolve system default at bind time in case it changed */
>  	online_type = dev_dax->online_type;
>  	if (online_type == DAX_ONLINE_DEFAULT)
>  		online_type = mhp_get_default_online_type();
>  
> -	for (i = 0; i < dev_dax->nr_range; i++) {
> -		struct resource *res;
> -		struct range range;
> -
> -		rc = dax_kmem_range(dev_dax, i, &range);
> -		if (rc)
> -			continue;
> -
> -		/* Region is permanently reserved if hotremove fails. */
> -		res = request_mem_region(range.start, range_len(&range), data->res_name);
> -		if (!res) {
> -			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
> -					i, range.start, range.end);
> -			/*
> -			 * Once some memory has been onlined we can't
> -			 * assume that it can be un-onlined safely.
> -			 */
> -			if (mapped)
> -				continue;
> -			rc = -EBUSY;
> -			goto err_request_mem;
> -		}
> -		data->res[i] = res;
> -
> -		/*
> -		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
> -		 * so that add_memory() can add a child resource.  Do not
> -		 * inherit flags from the parent since it may set new flags
> -		 * unknown to us that will break add_memory() below.
> -		 */
> -		res->flags = IORESOURCE_SYSTEM_RAM;
> -
> -		mhp_flags = MHP_NID_IS_MGID;
> -		if (dev_dax->memmap_on_memory)
> -			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
> -
> -		/*
> -		 * Ensure that future kexec'd kernels will not treat
> -		 * this as RAM automatically.
> -		 */
> -		rc = __add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, mhp_flags,
> -				online_type);
> -
> -		if (rc) {
> -			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> -					i, range.start, range.end);
> -			remove_resource(res);
> -			kfree(res);
> -			data->res[i] = NULL;
> -			if (mapped)
> -				continue;
> -			goto err_request_mem;
> -		}
> -		mapped++;
> -	}
> -
> -	dev_set_drvdata(dev, data);
> +	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
> +	if (rc < 0)
> +		goto err_hotplug;
>  
>  	return 0;
>  
> -err_request_mem:
> +err_hotplug:
> +	dax_kmem_cleanup_resources(dev_dax, data);
> +err_resources:
> +	dev_set_drvdata(dev, NULL);
>  	memory_group_unregister(data->mgid);
>  err_reg_mgid:
>  	kfree(data->res_name);
> @@ -213,7 +359,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  #ifdef CONFIG_MEMORY_HOTREMOVE
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  {
> -	int i, success = 0;
> +	int success;
>  	int node = dev_dax->target_node;
>  	struct device *dev = &dev_dax->dev;
>  	struct dax_kmem_data *data = dev_get_drvdata(dev);
> @@ -224,48 +370,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  	 * there is no way to hotremove this memory until reboot because device
>  	 * unbind will succeed even if we return failure.
>  	 */
> -	for (i = 0; i < dev_dax->nr_range; i++) {
> -		struct range range;
> -		int rc;
> -
> -		rc = dax_kmem_range(dev_dax, i, &range);
> -		if (rc)
> -			continue;
> -
> -		/* range was never added during probe */
> -		if (!data->res[i]) {
> -			success++;
> -			continue;
> -		}
> -
> -		rc = remove_memory(range.start, range_len(&range));
> -		if (rc == 0) {
> -			remove_resource(data->res[i]);
> -			kfree(data->res[i]);
> -			data->res[i] = NULL;
> -			success++;
> -			continue;
> -		}
> -		any_hotremove_failed = true;
> -		dev_err(dev,
> -			"mapping%d: %#llx-%#llx cannot be hotremoved until the next reboot\n",
> -				i, range.start, range.end);
> +	success = dax_kmem_do_hotremove(dev_dax, data);
> +	if (success < dev_dax->nr_range) {
> +		dev_err(dev, "Hotplug regions stuck online until reboot\n");
> +		return;
>  	}
>  
> -	if (success >= dev_dax->nr_range) {
> -		memory_group_unregister(data->mgid);
> -		kfree(data->res_name);
> -		kfree(data);
> -		dev_set_drvdata(dev, NULL);
> -		/*
> -		 * Clear the memtype association on successful unplug.
> -		 * If not, we have memory blocks left which can be
> -		 * offlined/onlined later. We need to keep memory_dev_type
> -		 * for that. This implies this reference will be around
> -		 * till next reboot.
> -		 */
> -		clear_node_memory_type(node, NULL);
> -	}
> +	dax_kmem_cleanup_resources(dev_dax, data);
> +	memory_group_unregister(data->mgid);
> +	kfree(data->res_name);
> +	kfree(data);
> +	dev_set_drvdata(dev, NULL);
> +	/*
> +	 * Clear the memtype association on successful unplug.
> +	 * If not, we have memory blocks left which can be
> +	 * offlined/onlined later. We need to keep memory_dev_type
> +	 * for that. This implies this reference will be around
> +	 * till next reboot.
> +	 */
> +	clear_node_memory_type(node, NULL);
>  }
>  #else
>  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)

