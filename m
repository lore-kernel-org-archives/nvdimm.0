Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A5C19CCF5
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758740015; cv=none; b=JUBbCSO8LOAdKi/UpM8GB+agwhtJkyLYXXfSw5pNKqdJ2gREQgIn47JZR7uuMP4euuhJCt6Rvl+Hchoj2p/Cu+yO5EKx45rGdanJC/YCgXwMBkg7hnGN7sjyNygrI83muZ5mkV/oVyZVZLusUJeXfVCJXRbkRd7S9uIMLCYtju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758740015; c=relaxed/simple;
	bh=8Zrk7RQOOZzUbY3wVJZ/SA8VGfMHzCkrWOyqQHCft0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I4gb32k9HBuIDkmOSJZQ2qjYxYFJ+F+b+Jef+Jyt/hTXd+EgdOEEAJIODQrXUHjrjWMr9KHrXYoFTd9kLC4JAfnFqn/2Ln+RWX8Q1ekzOx5Z2/n0Fj3UM835Tn8c7sbQgWZCDGsmTKz1XGZby0lHvYdvnWzUj0Iy9neb2om6YDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TkIEbuKl; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TkIEbuKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758740013; x=1790276013;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8Zrk7RQOOZzUbY3wVJZ/SA8VGfMHzCkrWOyqQHCft0w=;
  b=TkIEbuKlB0Rmn0f4PKDwhBjV6We6g1Fo+qiv/twSo2uQ8OjYzXuGj3B7
   AoXvjFc372dq3hXsWazA5hhh2qyb9aisHcS0xRUXHY8y7RhxLql8Gj8nc
   ybsaF02b0whSds4+8fglttwFlSazRSlp/hVhyB9yLCZsWKRrY5AKwaCfy
   te56Kz8z1uDVFo/wlj7AtsX6/1oJBc0xlYfYOJr4H/EpLngrBvIJgcVLq
   1k5yDZXmtD+4hNehxDFVDaA4WfJ+rdKbl0dMRRQMdsp4NUCj/AZDdl4yV
   A9jdM7mJYnuECA8NIH2M04cGDbUQfLmZVLM5Umqq/bBso9OfGoJ2BhiV9
   w==;
X-CSE-ConnectionGUID: Ke8AdufPRtedIi2Gp/7BVw==
X-CSE-MsgGUID: GD4DphvrSWCGP6qjSixdsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64855006"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64855006"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 11:53:32 -0700
X-CSE-ConnectionGUID: hqnSO19fQPmu3NrKLbxs9g==
X-CSE-MsgGUID: h4I0O/3ESmeLvS7eF2EcZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="177541344"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.218]) ([10.125.108.218])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 11:53:31 -0700
Message-ID: <147c4f1a-b8f6-4a99-8469-382b897f326d@intel.com>
Date: Wed, 24 Sep 2025 11:53:29 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 18/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c@epcas5p1.samsung.com>
 <20250917134116.1623730-19-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-19-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
> Moved pmem_region related code from core/region.c to core/pmem_region.c
> For region label update, need to create device attribute, which calls
> nvdimm exported function thus making pmem_region dependent on libnvdimm.
> Because of this dependency of pmem region on libnvdimm, segregated pmem
> region related code from core/region.c

We can minimize the churn in this patch by introduce the new core/pmem_region.c and related bits in the beginning instead of introduce new functions and then move them over from region.c.


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/Kconfig            |  14 +++
>  drivers/cxl/core/Makefile      |   1 +
>  drivers/cxl/core/core.h        |   8 +-
>  drivers/cxl/core/pmem_region.c | 203 +++++++++++++++++++++++++++++++++
>  drivers/cxl/core/port.c        |   2 +-
>  drivers/cxl/core/region.c      | 191 +------------------------------
>  drivers/cxl/cxl.h              |  30 +++--
>  tools/testing/cxl/Kbuild       |   1 +
>  8 files changed, 250 insertions(+), 200 deletions(-)
>  create mode 100644 drivers/cxl/core/pmem_region.c
> 
> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
> index 48b7314afdb8..532eaa1bbdd6 100644
> --- a/drivers/cxl/Kconfig
> +++ b/drivers/cxl/Kconfig
> @@ -211,6 +211,20 @@ config CXL_REGION
>  
>  	  If unsure say 'y'
>  
> +config CXL_PMEM_REGION
> +	bool "CXL: Pmem Region Support"
> +	default CXL_BUS
> +	depends on CXL_REGION

> +	depends on PHYS_ADDR_T_64BIT
> +	depends on BLK_DEV
These 2 deps are odd. What are the actual dependencies?


> +	select LIBNVDIMM
> +	help
> +	  Enable the CXL core to enumerate and provision CXL pmem regions.
> +	  A CXL pmem region need to update region label into LSA. For LSA
> +	  updation/deletion libnvdimm is required.

s/updation/update/

> +
> +	  If unsure say 'y'
> +
>  config CXL_REGION_INVALIDATION_TEST
>  	bool "CXL: Region Cache Management Bypass (TEST)"
>  	depends on CXL_REGION
> diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> index 5ad8fef210b5..399157beb917 100644
> --- a/drivers/cxl/core/Makefile
> +++ b/drivers/cxl/core/Makefile
> @@ -17,6 +17,7 @@ cxl_core-y += cdat.o
>  cxl_core-y += ras.o
>  cxl_core-$(CONFIG_TRACING) += trace.o
>  cxl_core-$(CONFIG_CXL_REGION) += region.o
> +cxl_core-$(CONFIG_CXL_PMEM_REGION) += pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 5707cd60a8eb..536636a752dc 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -34,7 +34,6 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>  #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
>  #define CXL_REGION_TYPE(x) (&cxl_region_type)
>  #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
> -#define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
>  #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
> @@ -74,10 +73,15 @@ static inline void cxl_region_exit(void)
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> -#define CXL_PMEM_REGION_TYPE(x) NULL
>  #define CXL_DAX_REGION_TYPE(x) NULL
>  #endif
>  
> +#ifdef CONFIG_CXL_PMEM_REGION
> +#define CXL_PMEM_REGION_TYPE (&cxl_pmem_region_type)
> +#else
> +#define CXL_PMEM_REGION_TYPE NULL
> +#endif
> +
>  struct cxl_send_command;
>  struct cxl_mem_query_commands;
>  int cxl_query_cmd(struct cxl_mailbox *cxl_mbox,
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..55b80d587403
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,203 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2020 Intel Corporation. */
> +#include <linux/device.h>
> +#include <linux/memregion.h>
> +#include <cxlmem.h>
> +#include <cxl.h>
> +#include "core.h"
> +
> +/**
> + * DOC: cxl pmem region
> + *
> + * The core CXL PMEM region infrastructure supports persistent memory
> + * region creation using LIBNVDIMM subsystem. It has dependency on
> + * LIBNVDIMM, pmem region need updation of cxl region information into
> + * LSA. LIBNVDIMM dependency is only for pmem region, it is therefore
> + * need this separate file.
> + */
> +
> +bool is_cxl_pmem_region(struct device *dev)
> +{
> +	return dev->type == &cxl_pmem_region_type;
> +}
> +EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
> +
> +struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> +{
> +	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
> +			  "not a cxl_pmem_region device\n"))
> +		return NULL;
> +	return container_of(dev, struct cxl_pmem_region, dev);
> +}
> +EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
> +
> +static void cxl_pmem_region_release(struct device *dev)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	int i;
> +
> +	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> +		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
> +
> +		put_device(&cxlmd->dev);
> +	}
> +
> +	kfree(cxlr_pmem);
> +}
> +
> +static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
> +	&cxl_base_attribute_group,
> +	NULL,
> +};
> +
> +const struct device_type cxl_pmem_region_type = {
> +	.name = "cxl_pmem_region",
> +	.release = cxl_pmem_region_release,
> +	.groups = cxl_pmem_region_attribute_groups,
> +};
> +
> +static struct lock_class_key cxl_pmem_region_key;
> +
> +static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct device *dev;
> +	int i;
> +
> +	guard(rwsem_read)(&cxl_rwsem.region);
> +	if (p->state != CXL_CONFIG_COMMIT)
> +		return -ENXIO;
> +
> +	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
> +		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets),
> +			GFP_KERNEL);
> +	if (!cxlr_pmem)
> +		return -ENOMEM;
> +
> +	cxlr_pmem->hpa_range.start = p->res->start;
> +	cxlr_pmem->hpa_range.end = p->res->end;
> +
> +	/* Snapshot the region configuration underneath the cxl_region_rwsem */
> +	cxlr_pmem->nr_mappings = p->nr_targets;
> +	for (i = 0; i < p->nr_targets; i++) {
> +		struct cxl_endpoint_decoder *cxled = p->targets[i];
> +		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> +		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> +
> +		/*
> +		 * Regions never span CXL root devices, so by definition the
> +		 * bridge for one device is the same for all.
> +		 */
> +		if (i == 0) {
> +			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
> +			if (!cxl_nvb)
> +				return -ENODEV;
> +			cxlr->cxl_nvb = cxl_nvb;
> +		}
> +		m->cxlmd = cxlmd;
> +		get_device(&cxlmd->dev);
> +		m->start = cxled->dpa_res->start;
> +		m->size = resource_size(cxled->dpa_res);
> +		m->position = i;
> +	}
> +
> +	dev = &cxlr_pmem->dev;
> +	device_initialize(dev);
> +	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
> +	device_set_pm_not_required(dev);
> +	dev->parent = &cxlr->dev;
> +	dev->bus = &cxl_bus_type;
> +	dev->type = &cxl_pmem_region_type;
> +	cxlr_pmem->cxlr = cxlr;
> +	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
> +
> +	return 0;
> +}
> +
> +static void cxlr_pmem_unregister(void *_cxlr_pmem)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> +
> +	/*
> +	 * Either the bridge is in ->remove() context under the device_lock(),
> +	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
> +	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
> +	 * lock).
> +	 */
> +	device_lock_assert(&cxl_nvb->dev);
> +	cxlr->cxlr_pmem = NULL;
> +	cxlr_pmem->cxlr = NULL;
> +	device_unregister(&cxlr_pmem->dev);
> +}
> +
> +static void cxlr_release_nvdimm(void *_cxlr)
> +{
> +	struct cxl_region *cxlr = _cxlr;
> +	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> +
> +	scoped_guard(device, &cxl_nvb->dev) {
> +		if (cxlr->cxlr_pmem)
> +			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
> +					    cxlr->cxlr_pmem);
> +	}
> +	cxlr->cxl_nvb = NULL;
> +	put_device(&cxl_nvb->dev);
> +}
> +
> +/**
> + * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
> + * @cxlr: parent CXL region for this pmem region bridge device
> + *
> + * Return: 0 on success negative error code on failure.
> + */
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
> +	struct cxl_pmem_region *cxlr_pmem;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct device *dev;
> +	int rc;
> +
> +	rc = cxl_pmem_region_alloc(cxlr);
> +	if (rc)
> +		return rc;
> +	cxlr_pmem = cxlr->cxlr_pmem;
> +	cxl_nvb = cxlr->cxl_nvb;
> +
> +	dev = &cxlr_pmem->dev;
> +	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
> +	if (rc)
> +		goto err;
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto err;
> +
> +	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
> +		dev_name(dev));
> +
> +	scoped_guard(device, &cxl_nvb->dev) {
> +		if (cxl_nvb->dev.driver)
> +			rc = devm_add_action_or_reset(&cxl_nvb->dev,
> +						      cxlr_pmem_unregister,
> +						      cxlr_pmem);
> +		else
> +			rc = -ENXIO;
> +	}
> +
> +	if (rc)
> +		goto err_bridge;
> +
> +	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> +	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
> +
> +err:
> +	put_device(dev);
> +err_bridge:
> +	put_device(&cxl_nvb->dev);
> +	cxlr->cxl_nvb = NULL;
> +	return rc;
> +}
> +EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 647d9ce32b64..717de1d3f70e 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -53,7 +53,7 @@ static int cxl_device_id(const struct device *dev)
>  		return CXL_DEVICE_NVDIMM_BRIDGE;
>  	if (dev->type == &cxl_nvdimm_type)
>  		return CXL_DEVICE_NVDIMM;
> -	if (dev->type == CXL_PMEM_REGION_TYPE())
> +	if (dev->type == CXL_PMEM_REGION_TYPE)

Stray edit? I don't think anything changed in the declaration.

>  		return CXL_DEVICE_PMEM_REGION;
>  	if (dev->type == CXL_DAX_REGION_TYPE())
>  		return CXL_DEVICE_DAX_REGION;
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index d5c227ce7b09..d2ef7fcc19fe 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -38,8 +38,6 @@
>   */
>  static nodemask_t nodemask_region_seen = NODE_MASK_NONE;
>  
> -static struct cxl_region *to_cxl_region(struct device *dev);
> -
>  #define __ACCESS_ATTR_RO(_level, _name) {				\
>  	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
>  	.show	= _name##_access##_level##_show,			\
> @@ -2382,7 +2380,7 @@ bool is_cxl_region(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
>  
> -static struct cxl_region *to_cxl_region(struct device *dev)
> +struct cxl_region *to_cxl_region(struct device *dev)
>  {
>  	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
>  			  "not a cxl_region device\n"))
> @@ -2390,6 +2388,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
>  
>  	return container_of(dev, struct cxl_region, dev);
>  }
> +EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL");

Maybe just move this into the header file instead.

DJ

>  
>  static void unregister_region(void *_cxlr)
>  {
> @@ -2814,46 +2813,6 @@ static ssize_t delete_region_store(struct device *dev,
>  }
>  DEVICE_ATTR_WO(delete_region);
>  
> -static void cxl_pmem_region_release(struct device *dev)
> -{
> -	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> -	int i;
> -
> -	for (i = 0; i < cxlr_pmem->nr_mappings; i++) {
> -		struct cxl_memdev *cxlmd = cxlr_pmem->mapping[i].cxlmd;
> -
> -		put_device(&cxlmd->dev);
> -	}
> -
> -	kfree(cxlr_pmem);
> -}
> -
> -static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
> -	&cxl_base_attribute_group,
> -	NULL,
> -};
> -
> -const struct device_type cxl_pmem_region_type = {
> -	.name = "cxl_pmem_region",
> -	.release = cxl_pmem_region_release,
> -	.groups = cxl_pmem_region_attribute_groups,
> -};
> -
> -bool is_cxl_pmem_region(struct device *dev)
> -{
> -	return dev->type == &cxl_pmem_region_type;
> -}
> -EXPORT_SYMBOL_NS_GPL(is_cxl_pmem_region, "CXL");
> -
> -struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> -{
> -	if (dev_WARN_ONCE(dev, !is_cxl_pmem_region(dev),
> -			  "not a cxl_pmem_region device\n"))
> -		return NULL;
> -	return container_of(dev, struct cxl_pmem_region, dev);
> -}
> -EXPORT_SYMBOL_NS_GPL(to_cxl_pmem_region, "CXL");
> -
>  struct cxl_poison_context {
>  	struct cxl_port *port;
>  	int part;
> @@ -3213,64 +3172,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
>  	return -ENXIO;
>  }
>  
> -static struct lock_class_key cxl_pmem_region_key;
> -
> -static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
> -{
> -	struct cxl_region_params *p = &cxlr->params;
> -	struct cxl_nvdimm_bridge *cxl_nvb;
> -	struct device *dev;
> -	int i;
> -
> -	guard(rwsem_read)(&cxl_rwsem.region);
> -	if (p->state != CXL_CONFIG_COMMIT)
> -		return -ENXIO;
> -
> -	struct cxl_pmem_region *cxlr_pmem __free(kfree) =
> -		kzalloc(struct_size(cxlr_pmem, mapping, p->nr_targets), GFP_KERNEL);
> -	if (!cxlr_pmem)
> -		return -ENOMEM;
> -
> -	cxlr_pmem->hpa_range.start = p->res->start;
> -	cxlr_pmem->hpa_range.end = p->res->end;
> -
> -	/* Snapshot the region configuration underneath the cxl_rwsem.region */
> -	cxlr_pmem->nr_mappings = p->nr_targets;
> -	for (i = 0; i < p->nr_targets; i++) {
> -		struct cxl_endpoint_decoder *cxled = p->targets[i];
> -		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
> -		struct cxl_pmem_region_mapping *m = &cxlr_pmem->mapping[i];
> -
> -		/*
> -		 * Regions never span CXL root devices, so by definition the
> -		 * bridge for one device is the same for all.
> -		 */
> -		if (i == 0) {
> -			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd->endpoint);
> -			if (!cxl_nvb)
> -				return -ENODEV;
> -			cxlr->cxl_nvb = cxl_nvb;
> -		}
> -		m->cxlmd = cxlmd;
> -		get_device(&cxlmd->dev);
> -		m->start = cxled->dpa_res->start;
> -		m->size = resource_size(cxled->dpa_res);
> -		m->position = i;
> -	}
> -
> -	dev = &cxlr_pmem->dev;
> -	device_initialize(dev);
> -	lockdep_set_class(&dev->mutex, &cxl_pmem_region_key);
> -	device_set_pm_not_required(dev);
> -	dev->parent = &cxlr->dev;
> -	dev->bus = &cxl_bus_type;
> -	dev->type = &cxl_pmem_region_type;
> -	cxlr_pmem->cxlr = cxlr;
> -	cxlr->cxlr_pmem = no_free_ptr(cxlr_pmem);
> -
> -	return 0;
> -}
> -
>  static void cxl_dax_region_release(struct device *dev)
>  {
>  	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
> @@ -3334,92 +3235,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
>  	return cxlr_dax;
>  }
>  
> -static void cxlr_pmem_unregister(void *_cxlr_pmem)
> -{
> -	struct cxl_pmem_region *cxlr_pmem = _cxlr_pmem;
> -	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> -	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> -
> -	/*
> -	 * Either the bridge is in ->remove() context under the device_lock(),
> -	 * or cxlr_release_nvdimm() is cancelling the bridge's release action
> -	 * for @cxlr_pmem and doing it itself (while manually holding the bridge
> -	 * lock).
> -	 */
> -	device_lock_assert(&cxl_nvb->dev);
> -	cxlr->cxlr_pmem = NULL;
> -	cxlr_pmem->cxlr = NULL;
> -	device_unregister(&cxlr_pmem->dev);
> -}
> -
> -static void cxlr_release_nvdimm(void *_cxlr)
> -{
> -	struct cxl_region *cxlr = _cxlr;
> -	struct cxl_nvdimm_bridge *cxl_nvb = cxlr->cxl_nvb;
> -
> -	scoped_guard(device, &cxl_nvb->dev) {
> -		if (cxlr->cxlr_pmem)
> -			devm_release_action(&cxl_nvb->dev, cxlr_pmem_unregister,
> -					    cxlr->cxlr_pmem);
> -	}
> -	cxlr->cxl_nvb = NULL;
> -	put_device(&cxl_nvb->dev);
> -}
> -
> -/**
> - * devm_cxl_add_pmem_region() - add a cxl_region-to-nd_region bridge
> - * @cxlr: parent CXL region for this pmem region bridge device
> - *
> - * Return: 0 on success negative error code on failure.
> - */
> -static int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> -{
> -	struct cxl_pmem_region *cxlr_pmem;
> -	struct cxl_nvdimm_bridge *cxl_nvb;
> -	struct device *dev;
> -	int rc;
> -
> -	rc = cxl_pmem_region_alloc(cxlr);
> -	if (rc)
> -		return rc;
> -	cxlr_pmem = cxlr->cxlr_pmem;
> -	cxl_nvb = cxlr->cxl_nvb;
> -
> -	dev = &cxlr_pmem->dev;
> -	rc = dev_set_name(dev, "pmem_region%d", cxlr->id);
> -	if (rc)
> -		goto err;
> -
> -	rc = device_add(dev);
> -	if (rc)
> -		goto err;
> -
> -	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
> -		dev_name(dev));
> -
> -	scoped_guard(device, &cxl_nvb->dev) {
> -		if (cxl_nvb->dev.driver)
> -			rc = devm_add_action_or_reset(&cxl_nvb->dev,
> -						      cxlr_pmem_unregister,
> -						      cxlr_pmem);
> -		else
> -			rc = -ENXIO;
> -	}
> -
> -	if (rc)
> -		goto err_bridge;
> -
> -	/* @cxlr carries a reference on @cxl_nvb until cxlr_release_nvdimm */
> -	return devm_add_action_or_reset(&cxlr->dev, cxlr_release_nvdimm, cxlr);
> -
> -err:
> -	put_device(dev);
> -err_bridge:
> -	put_device(&cxl_nvb->dev);
> -	cxlr->cxl_nvb = NULL;
> -	return rc;
> -}
> -
>  static void cxlr_dax_unregister(void *_cxlr_dax)
>  {
>  	struct cxl_dax_region *cxlr_dax = _cxlr_dax;
> @@ -3985,6 +3800,8 @@ static int cxl_region_probe(struct device *dev)
>  			dev_dbg(&cxlr->dev, "CXL EDAC registration for region_id=%d failed\n",
>  				cxlr->id);
>  
> +		if (!IS_ENABLED(CONFIG_CXL_PMEM_REGION))
> +			return -EINVAL;
>  		return devm_cxl_add_pmem_region(cxlr);
>  	case CXL_PARTMODE_RAM:
>  		rc = devm_cxl_region_edac_register(cxlr);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 1eb1aca7c69f..0d576b359de6 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -825,6 +825,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
>  			struct cxl_endpoint_dvsec_info *info);
>  
>  bool is_cxl_region(struct device *dev);
> +struct cxl_region *to_cxl_region(struct device *dev);
>  
>  extern const struct bus_type cxl_bus_type;
>  
> @@ -869,8 +870,6 @@ struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>  struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
> -bool is_cxl_pmem_region(struct device *dev);
> -struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> @@ -880,14 +879,6 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>  				     struct cxl_pmem_region_params *params,
>  				     struct cxl_decoder *cxld);
>  #else
> -static inline bool is_cxl_pmem_region(struct device *dev)
> -{
> -	return false;
> -}
> -static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> -{
> -	return NULL;
> -}
>  static inline int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
>  {
>  	return 0;
> @@ -914,6 +905,25 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
>  }
>  #endif
>  
> +#ifdef CONFIG_CXL_PMEM_REGION
> +bool is_cxl_pmem_region(struct device *dev);
> +struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
> +#else
> +static inline bool is_cxl_pmem_region(struct device *dev)
> +{
> +	return false;
> +}
> +static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
> +{
> +	return NULL;
> +}
> +static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
> +	return 0;
> +}
> +#endif
> +
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
>  void cxl_switch_parse_cdat(struct cxl_port *port);
>  
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index d07f14cb7aa4..cf58ada337b7 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -64,6 +64,7 @@ cxl_core-y += $(CXL_CORE_SRC)/cdat.o
>  cxl_core-y += $(CXL_CORE_SRC)/ras.o
>  cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
>  cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
> +cxl_core-$(CONFIG_CXL_PMEM_REGION) += $(CXL_CORE_SRC)/pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o

