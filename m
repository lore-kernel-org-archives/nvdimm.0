Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D532F1B6CE9;
	Thu,  9 Jul 2026 21:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783631245; cv=none; b=dqQbDLQwV8rtVNUcVPVMexrr+WGygWC3WWfQu1NG+D4mM1OIPAwEdsyh/AylgUS/QSvaH3gEAEMK03F0PRituKMzJiZZ927XTjx6k/wjNvEciE/XzLudDbRJDUKEQziRPGDi+8MSZZP4A9g+pVFsVGBJjxffvAYvYuuP6NIH8n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783631245; c=relaxed/simple;
	bh=CcbzFpuqxbP31RWAKcPyqR+DOuQ1YM3H4ZPQJpHMvx0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jhQW9Syv3SiVfLi4x4ordszkIzYCFV+1IodxazF4IuRhi7ikzJ/6qXQM1osYSzKJjJ4TJK3iglxmcVM1rNJr0DBSym3dsgaIEwoKxECldHscYbVXzRZQwx54XhOsrY796dqqFElQ8+pjxNXq549e6//k8gPKd7S9vbsOqZ0ufwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6TmvzfL; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6TmvzfL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783631243; x=1815167243;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CcbzFpuqxbP31RWAKcPyqR+DOuQ1YM3H4ZPQJpHMvx0=;
  b=W6TmvzfLAr6pKB77c9Gzsb/blBmAepoz3OymitylHQzJkO1HDSEeItPT
   e0QiygeYokJf32gXjmkC5NZzQFFOPOTx1Ki/hr6TLPqNL5ESzvusb+au3
   OViHan04zCTsUTeYlkfMWsIw1gQa8mXrDvsCZFH4t8el4YW6Wo+IVCX4a
   xXraCHE4jpPtE5W3eJoa5p+9THv36rYzUARDnIUcmlxedoPhKlpCw3BD2
   +ABuoWS7yqsNyJTaDmmaW3qkWglzfj73AXDRgFSeat9loRKO7nNSdTpgE
   92b2TiuSKooet8si5uMyFsXWAN10rwLWi66jm3I61sxq35bk4U83aeFOc
   A==;
X-CSE-ConnectionGUID: tC8lp0yzS/mEYVbE19V6Wg==
X-CSE-MsgGUID: SlkHRbaVQTGfP8Um4n48Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="71854366"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="71854366"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:07:22 -0700
X-CSE-ConnectionGUID: HCOrVRvIQYiPh/zZ0nyc9g==
X-CSE-MsgGUID: ZJq6SJJxQbec8bcZ2BSGCQ==
X-ExtLoop1: 1
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 14:07:20 -0700
Message-ID: <8ad8e025-ffea-4bc8-8797-6a280ecc229f@intel.com>
Date: Thu, 9 Jul 2026 14:07:19 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
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
 <20260630211842.2252800-8-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-8-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> There is no way for drivers leveraging dax_kmem to plumb through a
> preferred auto-online policy - the system default policy is forced.
> 
> Add 'enum mmop' field to DAX device creation path to allow drivers
> to specify an auto-online policy when using the kmem driver.
> 
> Capturing the system default would otherwise break the ABI, because
> the system default can change - but we would be statically assigning
> the value at device creation time.
> 
> To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> the current behavior, while providing a clean way to override it.
> 
> No behavioural change for existing callers (still the system default).

behavioral

> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/dax/bus.c         |  3 +++
>  drivers/dax/bus.h         |  9 +++++++++
>  drivers/dax/cxl.c         |  1 +
>  drivers/dax/dax-private.h |  4 ++++
>  drivers/dax/hmem/hmem.c   |  1 +
>  drivers/dax/kmem.c        | 11 +++++++++--
>  drivers/dax/pmem.c        |  1 +
>  7 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 492573b47f66..4a03b323b003 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
>  #include <linux/memremap.h>
> +#include <linux/memory_hotplug.h>
>  #include <linux/device.h>
>  #include <linux/mutex.h>
>  #include <linux/list.h>
> @@ -394,6 +395,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
>  			.size = 0,
>  			.id = -1,
>  			.memmap_on_memory = false,
> +			.online_type = DAX_ONLINE_DEFAULT,
>  		};
>  		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
>  
> @@ -1527,6 +1529,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
>  	ida_init(&dev_dax->ida);
>  
>  	dev_dax->memmap_on_memory = data->memmap_on_memory;
> +	dev_dax->online_type = data->online_type;
>  
>  	inode = dax_inode(dax_dev);
>  	dev->devt = inode->i_rdev;
> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
> index 5909171a4428..3bc76bc0a145 100644
> --- a/drivers/dax/bus.h
> +++ b/drivers/dax/bus.h
> @@ -3,6 +3,7 @@
>  #ifndef __DAX_BUS_H__
>  #define __DAX_BUS_H__
>  #include <linux/device.h>
> +#include <linux/memory_hotplug.h>
>  #include <linux/platform_device.h>
>  #include <linux/range.h>
>  #include <linux/workqueue.h>
> @@ -16,6 +17,13 @@ struct dax_region;
>  #define IORESOURCE_DAX_STATIC BIT(0)
>  #define IORESOURCE_DAX_KMEM BIT(1)
>  
> +/*
> + * online_type sentinel: the device was created without an explicit online
> + * policy, so the system default is resolved when the kmem driver binds,
> + * (not at device-creation time, which would freeze a stale policy).
> + */
> +#define DAX_ONLINE_DEFAULT	(-1)
> +
>  struct dax_region *alloc_dax_region(struct device *parent, int region_id,
>  		struct range *range, int target_node, unsigned int align,
>  		unsigned long flags);
> @@ -26,6 +34,7 @@ struct dev_dax_data {
>  	resource_size_t size;
>  	int id;
>  	bool memmap_on_memory;
> +	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
>  };
>  
>  struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
> diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
> index 3ab39b77843d..1a7ec6212213 100644
> --- a/drivers/dax/cxl.c
> +++ b/drivers/dax/cxl.c
> @@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
>  		.id = -1,
>  		.size = range_len(&cxlr_dax->hpa_range),
>  		.memmap_on_memory = true,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 81e4af49e39c..902e922dc4e4 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -8,6 +8,7 @@
>  #include <linux/device.h>
>  #include <linux/cdev.h>
>  #include <linux/idr.h>
> +#include <linux/memory_hotplug.h>
>  
>  /* private routines between core files */
>  struct dax_device;
> @@ -79,6 +80,8 @@ struct dev_dax_range {
>   * @dev: device core
>   * @pgmap: pgmap for memmap setup / lifetime (driver owned)
>   * @memmap_on_memory: allow kmem to put the memmap in the memory
> + * @online_type: MMOP_* online type for memory hotplug, or DAX_ONLINE_DEFAULT
> + *		 to resolve the system default policy when kmem binds
>   * @nr_range: size of @ranges
>   * @ranges: range tuples of memory used
>   */
> @@ -95,6 +98,7 @@ struct dev_dax {
>  	struct device dev;
>  	struct dev_pagemap *pgmap;
>  	bool memmap_on_memory;
> +	int online_type;	/* enum mmop, or DAX_ONLINE_DEFAULT sentinel */
>  	int nr_range;
>  	struct dev_dax_range *ranges;
>  };
> diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
> index af21f66bf872..2de3bc925172 100644
> --- a/drivers/dax/hmem/hmem.c
> +++ b/drivers/dax/hmem/hmem.c
> @@ -37,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
>  		.id = -1,
>  		.size = region_idle ? 0 : range_len(&mri->range),
>  		.memmap_on_memory = false,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 592171ec10f4..0a184c0878dd 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -72,6 +72,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  	int i, rc, mapped = 0;
>  	mhp_t mhp_flags;
>  	int numa_node;
> +	int online_type;
>  	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
>  
>  	/*
> @@ -132,6 +133,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		goto err_reg_mgid;
>  	data->mgid = rc;
>  
> +	/* Resolve system default at bind time in case it changed */
> +	online_type = dev_dax->online_type;
> +	if (online_type == DAX_ONLINE_DEFAULT)
> +		online_type = mhp_get_default_online_type();
> +
>  	for (i = 0; i < dev_dax->nr_range; i++) {
>  		struct resource *res;
>  		struct range range;
> @@ -172,8 +178,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		 * Ensure that future kexec'd kernels will not treat
>  		 * this as RAM automatically.
>  		 */
> -		rc = add_memory_driver_managed(data->mgid, range.start,
> -				range_len(&range), kmem_name, mhp_flags);
> +		rc = __add_memory_driver_managed(data->mgid, range.start,
> +				range_len(&range), kmem_name, mhp_flags,
> +				online_type);
>  
>  		if (rc) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..e7adace69195 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  		.pgmap = &pgmap,
>  		.size = range_len(&range),
>  		.memmap_on_memory = false,
> +		.online_type = DAX_ONLINE_DEFAULT,
>  	};
>  
>  	return devm_create_dev_dax(&data);

