Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 57B15210C1B79
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 14:39:01 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCHv4 1/2] libnvdimm: Use max contiguous area for namespace
 size
Date: Tue, 24 Jul 2018 21:38:59 +0000
Message-ID: <1532468337.8557.22.camel@intel.com>
References: <20180724210758.14098-1-keith.busch@intel.com>
In-Reply-To: <20180724210758.14098-1-keith.busch@intel.com>
Content-Language: en-US
Content-ID: <8405E8877322404CBFED518FFDB3F98E@intel.com>
MIME-Version: 1.0
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
To: "Busch, Keith" <keith.busch@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "gustavo@embeddedor.com" <gustavo@embeddedor.com>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-07-24 at 15:07 -0600, Keith Busch wrote:
> This patch will find the max contiguous area to determine the largest
> pmem namespace size that can be created. If the requested size exceeds
> the largest available, ENOSPC error will be returned.
> 
> This fixes the allocation underrun error and wrong error return code
> that have otherwise been observed as the following kernel warning:
> 
>   WARNING: CPU: <CPU> PID: <PID> at drivers/nvdimm/namespace_devs.c:913 size_store
> 
> Fixes: a1f3e4d6a0c3 ("libnvdimm, region: update nd_region_available_dpa() for multi-pmem support")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
> v3 -> v4:
> 
>   Actually constrain the reserved pmem to the region under consideration
>   rather than the mapping's dimm. This is done by directly calling
>   __reserve_free_pmem with the region's device instead of walking the
>   parent devices children. Thanks to Vishal Verma for reporting how
>   to trigger the incorrect reportings.
> 
>   Fixed a possible NULL deref, from Gustavo A. R. Silva.

Looks good to me. Feel free to add:
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
>  drivers/nvdimm/dimm_devs.c      | 31 +++++++++++++++++++++++++++++++
>  drivers/nvdimm/namespace_devs.c |  6 +++---
>  drivers/nvdimm/nd-core.h        |  8 ++++++++
>  drivers/nvdimm/region_devs.c    | 24 ++++++++++++++++++++++++
>  4 files changed, 66 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 8d348b22ba45..863cabc35215 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -536,6 +536,37 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
>  	return info.available;
>  }
>  
> +/**
> + * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
> + *			   contiguous unallocated dpa range.
> + * @nd_region: constrain available space check to this reference region
> + * @nd_mapping: container of dpa-resource-root + labels
> + */
> +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
> +					   struct nd_mapping *nd_mapping)
> +{
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +	struct nvdimm_bus *nvdimm_bus;
> +	resource_size_t max = 0;
> +	struct resource *res;
> +
> +	/* if a dimm is disabled the available capacity is zero */
> +	if (!ndd)
> +		return 0;
> +
> +	nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
> +	if (__reserve_free_pmem(&nd_region->dev, nd_mapping->nvdimm))
> +		return 0;
> +	for_each_dpa_resource(ndd, res) {
> +		if (strcmp(res->name, "pmem-reserve") != 0)
> +			continue;
> +		if (resource_size(res) > max)
> +			max = resource_size(res);
> +	}
> +	release_free_pmem(nvdimm_bus, nd_mapping);
> +	return max;
> +}
> +
>  /**
>   * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
>   * @nd_mapping: container of dpa-resource-root + labels
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index cb322f2bc605..4a4266250c28 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -799,7 +799,7 @@ static int merge_dpa(struct nd_region *nd_region,
>  	return 0;
>  }
>  
> -static int __reserve_free_pmem(struct device *dev, void *data)
> +int __reserve_free_pmem(struct device *dev, void *data)
>  {
>  	struct nvdimm *nvdimm = data;
>  	struct nd_region *nd_region;
> @@ -836,7 +836,7 @@ static int __reserve_free_pmem(struct device *dev, void *data)
>  	return 0;
>  }
>  
> -static void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
> +void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
>  		struct nd_mapping *nd_mapping)
>  {
>  	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> @@ -1032,7 +1032,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
>  
>  		allocated += nvdimm_allocated_dpa(ndd, &label_id);
>  	}
> -	available = nd_region_available_dpa(nd_region);
> +	available = nd_region_allocatable_dpa(nd_region);
>  
>  	if (val > available + allocated)
>  		return -ENOSPC;
> diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
> index 79274ead54fb..ac68072fb8cd 100644
> --- a/drivers/nvdimm/nd-core.h
> +++ b/drivers/nvdimm/nd-core.h
> @@ -100,6 +100,14 @@ struct nd_region;
>  struct nvdimm_drvdata;
>  struct nd_mapping;
>  void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
> +
> +int __reserve_free_pmem(struct device *dev, void *data);
> +void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
> +		       struct nd_mapping *nd_mapping);
> +
> +resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
> +					   struct nd_mapping *nd_mapping);
> +resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region);
>  resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
>  		struct nd_mapping *nd_mapping, resource_size_t *overlap);
>  resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index ec3543b83330..c30d5af02cc2 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -389,6 +389,30 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
>  	return available;
>  }
>  
> +resource_size_t nd_region_allocatable_dpa(struct nd_region *nd_region)
> +{
> +	resource_size_t available = 0;
> +	int i;
> +
> +	if (is_memory(&nd_region->dev))
> +		available = PHYS_ADDR_MAX;
> +
> +	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
> +	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
> +
> +		if (is_memory(&nd_region->dev))
> +			available = min(available,
> +					nd_pmem_max_contiguous_dpa(nd_region,
> +								   nd_mapping));
> +		else if (is_nd_blk(&nd_region->dev))
> +			available += nd_blk_available_dpa(nd_region);
> +	}
> +	if (is_memory(&nd_region->dev))
> +		return available * nd_region->ndr_mappings;
> +	return available;
> +}
> +
>  static ssize_t available_size_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
