Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B1A265CDD
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 23:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782515894; cv=none; b=PPXeQbj4E5jevehXYw8zgbtn0211hS35tfJsfvR9X3n0yHCNDkVjtiDYQs08KbGiuY7670P0i/miTQX07Ks2PtrhGuEI6CCZtGpxzCrJPR8DBO3IstuToDtgQ2zI9I67DfAeofP5aVkSOoEUsccntDutlCJs9qIC+MP2sAzhF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782515894; c=relaxed/simple;
	bh=dk/WSQ6VtwWPEp5bJnDz/pLlfdmK0w6bgQU+0TpFy/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrtYrekB69jfXOce3RwRcX+0A3GU7iaQrr/YHh2ZtRyBc/2Rn7cFxfHfJvdI/bD90uFnrN6VObtxPjdjLnK3tZUgfWy0RNAPkGCdiLnD0vQF6lKvYPqjQFUDWBSd1NjQny6t+7Ujw8JugPSrfyswM/oNnoqjzqexcrQvYYyONhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hqefmjRn; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqefmjRn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782515890; x=1814051890;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dk/WSQ6VtwWPEp5bJnDz/pLlfdmK0w6bgQU+0TpFy/0=;
  b=hqefmjRnnplncdAZFCRROKLAGsavnUEG0VGlwyqjOHeYfhBlri1IxFOK
   oL0GGklb/S0oozcZ9kKXkdS87v0A28as6REFOHB2hPaYFXJZNdeC4rIsc
   1bc04vmZrsrgJMOu7tUKQ1hLq0t7SWl/LQBiSs7P92ka7LQ4tEoNqZDGf
   c94rIxUBACGURgsf+n4NPm/saZo+KD1kwlGg3+WTGOOlQ2TQpgWFWwyVK
   aolK6wiAMBAxyyielgJWSljz9iLjMbgy+Bbjb/k6Bo39FYRLDEbCBphtJ
   41HitljWRs7bSkMu4oerASkPyHecOEmS9G4bmMCssQO7ImnHYQkk0TM7z
   w==;
X-CSE-ConnectionGUID: QslSw13BQsaaOLTNVZW9Pg==
X-CSE-MsgGUID: qo3RJK5TRCmeVAHZUBJoyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="87154768"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="87154768"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 16:18:09 -0700
X-CSE-ConnectionGUID: qIZtyQoFTliwR4g9Zdn9CQ==
X-CSE-MsgGUID: 5We7YOtVR9CpU9bDPs1rjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="255841399"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 16:18:09 -0700
Message-ID: <86781645-d366-4649-b006-1a049dc9fcab@intel.com>
Date: Fri, 26 Jun 2026 16:18:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/31] cxl/region: Add DC DAX region support
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-8-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-8-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> DC DAX regions must allow memory to be added or removed dynamically.
> In addition to the quantity of memory available the,

stray comma

DJ

> location of the memory within a DC partition is dynamic, based on the
> extents offered by a device.  CXL DAX regions must accommodate the
> dynamic movement of this memory in the management of DAX regions and devices.
> 
> Introduce the concept of a dynamic DAX region. Introduce
> create_dynamic_ram_1_region() sysfs entry to create such regions.
> Special case DC-capable regions to create a 0 sized seed DAX device
> to maintain compatibility which requires a default DAX device to hold a
> region reference.
> 
> Indicate 0 byte available capacity until such time that capacity is
> added.
> 
> Dynamic regions complicate the range mapping of dax devices.  There is no
> known use case for range mapping on dynamic regions.  Avoid the
> complication by preventing range mapping of dax devices on dynamic
> regions.
> 
> Interleaving is deferred for now.  Add checks.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> ---
> Changes:
> 1. Documentation: bump kver to 7.3 and date to June 2026
> 2. port.c: use helper function to_cxl_memdev_state() in cxled_to_mds()
> 3. region.c: cxled_to_mds() can return NULL with ^ above change.
>    Handle properly in store_targetN()
> 4. port.c: check if the root decoder supports ram regions before
>    exposing create_dynamic_ram_1_region attribute in
>    cxl_root_decoder_visible()
> 5. Rename dynamic_ram_a to dynamic_ram_1
> 6. Add dynamic_ram_1 to mode_show()
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++-------
>  drivers/cxl/core/core.h                 |  9 ++++++
>  drivers/cxl/core/port.c                 |  5 +++
>  drivers/cxl/core/region.c               | 43 +++++++++++++++++++++++--
>  drivers/cxl/core/region_dax.c           |  6 ++++
>  drivers/dax/bus.c                       | 10 ++++++
>  drivers/dax/bus.h                       |  1 +
>  drivers/dax/cxl.c                       | 17 ++++++++--
>  8 files changed, 98 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 499741cbb899..00b98bbe0ff3 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -434,20 +434,20 @@ Description:
>  		interleave_granularity).
>  
>  
> -What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram}_region
> -Date:		May, 2022, January, 2023
> -KernelVersion:	v6.0 (pmem), v6.3 (ram)
> +What:		/sys/bus/cxl/devices/decoderX.Y/create_{pmem,ram,dynamic_ram_1}_region
> +Date:		May, 2022, January, 2023, June 2026
> +KernelVersion:	v6.0 (pmem), v6.3 (ram), v7.3 (dynamic_ram_1)
>  Contact:	linux-cxl@vger.kernel.org
>  Description:
>  		(RW) Write a string in the form 'regionZ' to start the process
> -		of defining a new persistent, or volatile memory region
> -		(interleave-set) within the decode range bounded by root decoder
> -		'decoderX.Y'. The value written must match the current value
> -		returned from reading this attribute. An atomic compare exchange
> -		operation is done on write to assign the requested id to a
> -		region and allocate the region-id for the next creation attempt.
> -		EBUSY is returned if the region name written does not match the
> -		current cached value.
> +		of defining a new persistent, volatile, or dynamic RAM memory
> +		region (interleave-set) within the decode range bounded by root
> +		decoder 'decoderX.Y'. The value written must match the current
> +		value returned from reading this attribute.  An atomic compare
> +		exchange operation is done on write to assign the requested id
> +		to a region and allocate the region-id for the next creation
> +		attempt.  EBUSY is returned if the region name written does not
> +		match the current cached value.
>  
>  
>  What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 82ca3a476708..9ed141fa1334 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -6,6 +6,7 @@
>  
>  #include <cxl/mailbox.h>
>  #include <linux/rwsem.h>
> +#include <cxlmem.h>
>  
>  extern const struct device_type cxl_nvdimm_bridge_type;
>  extern const struct device_type cxl_nvdimm_type;
> @@ -18,6 +19,13 @@ enum cxl_detach_mode {
>  	DETACH_INVALIDATE,
>  };
>  
> +static inline struct cxl_memdev_state *
> +cxled_to_mds(struct cxl_endpoint_decoder *cxled)
> +{
> +	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +	return to_cxl_memdev_state(cxlmd->cxlds);
> +}
> +
>  #ifdef CONFIG_CXL_REGION
>  
>  struct cxl_region_context {
> @@ -29,6 +37,7 @@ struct cxl_region_context {
>  
>  extern struct device_attribute dev_attr_create_pmem_region;
>  extern struct device_attribute dev_attr_create_ram_region;
> +extern struct device_attribute dev_attr_create_dynamic_ram_1_region;
>  extern struct device_attribute dev_attr_delete_region;
>  extern struct device_attribute dev_attr_region;
>  extern const struct device_type cxl_pmem_region_type;
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 57d0fc72023f..279279f544d8 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -337,6 +337,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
>  	&dev_attr_qos_class.attr,
>  	SET_CXL_REGION_ATTR(create_pmem_region)
>  	SET_CXL_REGION_ATTR(create_ram_region)
> +	SET_CXL_REGION_ATTR(create_dynamic_ram_1_region)
>  	SET_CXL_REGION_ATTR(delete_region)
>  	NULL,
>  };
> @@ -366,6 +367,10 @@ static umode_t cxl_root_decoder_visible(struct kobject *kobj, struct attribute *
>  	if (a == CXL_REGION_ATTR(create_ram_region) && !can_create_ram(cxlrd))
>  		return 0;
>  
> +	if (a == CXL_REGION_ATTR(create_dynamic_ram_1_region) &&
> +	    !can_create_ram(cxlrd))
> +		return 0;
> +
>  	if (a == CXL_REGION_ATTR(delete_region) &&
>  	    !(can_create_pmem(cxlrd) || can_create_ram(cxlrd)))
>  		return 0;
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index e50dc716d4e8..ba03ec5e27c3 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -493,6 +493,11 @@ static int set_interleave_ways(struct cxl_region *cxlr, int val)
>  	int save, rc;
>  	u8 iw;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1 && val != 1) {
> +		dev_err(&cxlr->dev, "Interleaving and DCD not supported\n");
> +		return -EINVAL;
> +	}
> +
>  	rc = ways_to_eiw(val, &iw);
>  	if (rc)
>  		return rc;
> @@ -642,6 +647,8 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
>  		desc = "ram";
>  	else if (cxlr->mode == CXL_PARTMODE_PMEM)
>  		desc = "pmem";
> +	else if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1)
> +		desc = "dynamic_ram_1";
>  	else
>  		desc = "";
>  
> @@ -2389,6 +2396,8 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  	if (sysfs_streq(buf, "\n"))
>  		rc = detach_target(cxlr, pos);
>  	else {
> +		struct cxl_endpoint_decoder *cxled;
> +		struct cxl_memdev_state *mds;
>  		struct device *dev;
>  
>  		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
> @@ -2400,8 +2409,21 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>  			goto out;
>  		}
>  
> -		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
> -				   TASK_INTERRUPTIBLE);
> +		cxled = to_cxl_endpoint_decoder(dev);
> +		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1) {
> +			mds = cxled_to_mds(cxled);
> +			if (!mds) {
> +				dev_dbg(dev, "No memdev state\n");
> +				rc = -ENODEV;
> +				goto out;
> +			}
> +			if (!cxl_dcd_supported(mds)) {
> +				dev_dbg(dev, "DCD unsupported\n");
> +				rc = -EINVAL;
> +				goto out;
> +			}
> +		}
> +		rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
>  out:
>  		put_device(dev);
>  	}
> @@ -2750,6 +2772,7 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  	switch (mode) {
>  	case CXL_PARTMODE_RAM:
>  	case CXL_PARTMODE_PMEM:
> +	case CXL_PARTMODE_DYNAMIC_RAM_1:
>  		break;
>  	default:
>  		dev_err(&cxlrd->cxlsd.cxld.dev, "unsupported mode %d\n", mode);
> @@ -2802,6 +2825,21 @@ static ssize_t create_ram_region_store(struct device *dev,
>  }
>  DEVICE_ATTR_RW(create_ram_region);
>  
> +static ssize_t create_dynamic_ram_1_region_show(struct device *dev,
> +						struct device_attribute *attr,
> +						char *buf)
> +{
> +	return __create_region_show(to_cxl_root_decoder(dev), buf);
> +}
> +
> +static ssize_t create_dynamic_ram_1_region_store(struct device *dev,
> +						 struct device_attribute *attr,
> +						 const char *buf, size_t len)
> +{
> +	return create_region_store(dev, buf, len, CXL_PARTMODE_DYNAMIC_RAM_1);
> +}
> +DEVICE_ATTR_RW(create_dynamic_ram_1_region);
> +
>  static ssize_t region_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -4083,6 +4121,7 @@ static int cxl_region_probe(struct device *dev)
>  
>  		return devm_cxl_add_pmem_region(cxlr);
>  	case CXL_PARTMODE_RAM:
> +	case CXL_PARTMODE_DYNAMIC_RAM_1:
>  		rc = devm_cxl_region_edac_register(cxlr);
>  		if (rc)
>  			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
> diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
> index de04f78f6ad8..3865961c4301 100644
> --- a/drivers/cxl/core/region_dax.c
> +++ b/drivers/cxl/core/region_dax.c
> @@ -84,6 +84,12 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
>  	struct device *dev;
>  	int rc;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
> +	    cxlr->params.interleave_ways != 1) {
> +		dev_err(&cxlr->dev, "Interleaving DC not supported\n");
> +		return -EINVAL;
> +	}
> +
>  	struct cxl_dax_region *cxlr_dax __free(put_cxl_dax_region) =
>  		cxl_dax_region_alloc(cxlr);
>  	if (IS_ERR(cxlr_dax))
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index ccfe65004888..7356aaaffe57 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -177,6 +177,11 @@ static bool is_static(struct dax_region *dax_region)
>  	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
>  }
>  
> +static bool is_dynamic(struct dax_region *dax_region)
> +{
> +	return (dax_region->res.flags & IORESOURCE_DAX_DCD) != 0;
> +}
> +
>  bool static_dev_dax(struct dev_dax *dev_dax)
>  {
>  	return is_static(dev_dax->region);
> @@ -300,6 +305,9 @@ static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
>  
>  	lockdep_assert_held(&dax_region_rwsem);
>  
> +	if (is_dynamic(dax_region))
> +		return 0;
> +
>  	for_each_dax_region_resource(dax_region, res)
>  		size -= resource_size(res);
>  	return size;
> @@ -1385,6 +1393,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
>  		return 0;
>  	if (a == &dev_attr_mapping.attr && is_static(dax_region))
>  		return 0;
> +	if (a == &dev_attr_mapping.attr && is_dynamic(dax_region))
> +		return 0;
>  	if ((a == &dev_attr_align.attr ||
>  	     a == &dev_attr_size.attr) && is_static(dax_region))
>  		return 0444;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 5909171a4428..6e739bfab932 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -15,6 +15,7 @@ struct dax_region;
>  /* dax bus specific ioresource flags */
>  #define IORESOURCE_DAX_STATIC BIT(0)
>  #define IORESOURCE_DAX_KMEM BIT(1)
> +#define IORESOURCE_DAX_DCD BIT(2)
>  
>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct range *range, int target_node, unsigned int align,
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 3ab39b77843d..cedd974c2d0c 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -13,19 +13,32 @@ static int cxl_dax_region_probe(struct device *dev)
>  	struct cxl_region *cxlr = cxlr_dax->cxlr;
>  	struct dax_region *dax_region;
>  	struct dev_dax_data data;
> +	resource_size_t dev_size;
> +	unsigned long flags;
>  
>  	if (nid == NUMA_NO_NODE)
>  		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1)
> +		flags = IORESOURCE_DAX_DCD;
> +	else
> +		flags = IORESOURCE_DAX_KMEM;
> +
>  	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
> -				      PMD_SIZE, IORESOURCE_DAX_KMEM);
> +				      PMD_SIZE, flags);
>  	if (!dax_region)
>  		return -ENOMEM;
>  
> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_1)
> +		/* Add empty seed dax device */
> +		dev_size = 0;
> +	else
> +		dev_size = range_len(&cxlr_dax->hpa_range);
> +
>  	data = (struct dev_dax_data) {
>  		.dax_region = dax_region,
>  		.id = -1,
> -		.size = range_len(&cxlr_dax->hpa_range),
> +		.size = dev_size,
>  		.memmap_on_memory = true,
>  	};
>  

