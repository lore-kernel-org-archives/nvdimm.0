Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CFA2EA480
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 22:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763590114; cv=none; b=qQKfrlzDYRx8l1SS7Bp4aOZu4tYw6SJHzjmA+OJXupSVS1XNygMydEEBIQhIjAbPGisGspUoU2Xd5DZnpI7lfEse+lIQIDvbj7TwZPVpm61ZrP3nXtRnWSoWQ4+IqDKQU/qlNTwEgH1fDihwQ27zLbtbVm+Ce1Um2gR7Hs1orFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763590114; c=relaxed/simple;
	bh=oKm2dL2n4HVDmTeYnqpm9/W5/LVEzVQyCxjLW2KpWew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L+6WCq9rhX3MwdCpeo+NpdogOfXiOwsFnIijtRThZqVjdKYo8nwTAZcqHsrI96qbjeDeZdqtSYcn2BUCY2OfU37ZTnpZkHvmd4PvpWhvAel7DS+BRer+JS2wX4nugBCmIbuLY60TsU4Nub14/COaIBCVNYZRU59v2Piqpf99m1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n0GO3JDo; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n0GO3JDo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763590113; x=1795126113;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oKm2dL2n4HVDmTeYnqpm9/W5/LVEzVQyCxjLW2KpWew=;
  b=n0GO3JDoSSxLt/UJT3hPG3y1k8kxfyl+eh8fG1bdZqoYxzn8YdkIQ3mU
   scdj0Mrj/SBs4dyQVLdCwNxDUiX5BVREjjc4dnCZcPHug68HbbNuoAPWT
   C8/8KnJWK8XTIo4AxSZTm754iyFb1RpSStApNGL+eXU3vfAyc7WJYkm7/
   QRA9YKcThgN6iOp3l9DVdWnwdNaD+oN6rFoEUNKSrZ6Fxa6RjeAIAnKVV
   xSDWuiaFR4/KwDsyTmcVpzQXaek2/CYYXfClcnDLShX97ZvpIqbzebNek
   eVK252ZyLdZtSsvuwOL+VdP78bIF7pcKUsguyGN0iM3zCCkZthenqgAye
   w==;
X-CSE-ConnectionGUID: VttUNwAYTf28KHUobGgP1Q==
X-CSE-MsgGUID: rOLLpOrkRIWhSzUnpcEp3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65685617"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="65685617"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:08:32 -0800
X-CSE-ConnectionGUID: a4s9E0v/Sq6DdveL2ixEcg==
X-CSE-MsgGUID: sYcJLHW4Rsufv1o3jYUIOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="196311862"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 14:08:32 -0800
Message-ID: <ef956937-980a-49c6-8615-e678f432a844@intel.com>
Date: Wed, 19 Nov 2025 15:08:30 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 13/17] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075332epcas5p2d173f0373aa1ccdfcd4d75c68d5d09fd@epcas5p2.samsung.com>
 <20251119075255.2637388-14-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-14-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> For region label update, need to create device attribute, which calls
> nvdimm exported routine thus making pmem_region dependent on libnvdimm.
> Because of this dependency of pmem region on libnvdimm, segregate pmem
> region related code from core/region.c to core/pmem_region.c
> 
> This patch has no functionality change. Its just code movement from
> core/region.c to core/pmem_region.c
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/core/Makefile      |   2 +-
>  drivers/cxl/core/core.h        |  10 ++
>  drivers/cxl/core/pmem_region.c | 202 +++++++++++++++++++++++++++++++++
>  drivers/cxl/core/region.c      | 188 +-----------------------------
>  tools/testing/cxl/Kbuild       |   2 +-
>  5 files changed, 215 insertions(+), 189 deletions(-)
>  create mode 100644 drivers/cxl/core/pmem_region.c
> 
> diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
> index 5ad8fef210b5..fe0fcab6d730 100644
> --- a/drivers/cxl/core/Makefile
> +++ b/drivers/cxl/core/Makefile
> @@ -16,7 +16,7 @@ cxl_core-y += pmu.o
>  cxl_core-y += cdat.o
>  cxl_core-y += ras.o
>  cxl_core-$(CONFIG_TRACING) += trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += region.o
> +cxl_core-$(CONFIG_CXL_REGION) += region.o pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += edac.o
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index fde96507cb75..5ebbc3d3dde5 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -46,6 +46,8 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>  				     enum cxl_partition_mode mode, int id,
>  				     struct cxl_pmem_region_params *params,
>  				     struct cxl_decoder *cxld);
> +struct cxl_region *to_cxl_region(struct device *dev);
> +int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
>  
>  #else
>  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
> @@ -83,6 +85,14 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
> +static inline struct cxl_region *to_cxl_region(struct device *dev)
> +{
> +	return NULL;
> +}
> +static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
> +{
> +	return 0;
> +}
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> new file mode 100644
> index 000000000000..b45e60f04ff4
> --- /dev/null
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -0,0 +1,202 @@
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
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 06a75f0a8e9b..9798120b208e 100644
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
> @@ -2426,7 +2424,7 @@ bool is_cxl_region(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
>  
> -static struct cxl_region *to_cxl_region(struct device *dev)
> +struct cxl_region *to_cxl_region(struct device *dev)
>  {
>  	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
>  			  "not a cxl_region device\n"))
> @@ -2856,46 +2854,6 @@ static ssize_t delete_region_store(struct device *dev,
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
> @@ -3327,64 +3285,6 @@ static int region_offset_to_dpa_result(struct cxl_region *cxlr, u64 offset,
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
> @@ -3448,92 +3348,6 @@ static struct cxl_dax_region *cxl_dax_region_alloc(struct cxl_region *cxlr)
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
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 0e151d0572d1..ad2496b38fdd 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -59,7 +59,7 @@ cxl_core-y += $(CXL_CORE_SRC)/pmu.o
>  cxl_core-y += $(CXL_CORE_SRC)/cdat.o
>  cxl_core-y += $(CXL_CORE_SRC)/ras.o
>  cxl_core-$(CONFIG_TRACING) += $(CXL_CORE_SRC)/trace.o
> -cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o
> +cxl_core-$(CONFIG_CXL_REGION) += $(CXL_CORE_SRC)/region.o $(CXL_CORE_SRC)/pmem_region.o
>  cxl_core-$(CONFIG_CXL_MCE) += $(CXL_CORE_SRC)/mce.o
>  cxl_core-$(CONFIG_CXL_FEATURES) += $(CXL_CORE_SRC)/features.o
>  cxl_core-$(CONFIG_CXL_EDAC_MEM_FEATURES) += $(CXL_CORE_SRC)/edac.o

