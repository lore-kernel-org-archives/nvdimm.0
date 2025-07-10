Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866F8F54
	for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 00:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752107904; cv=none; b=RALocZP/cY1K5te2YdAgjenO40ZCdC657/kIe5dksxQyOMPLLmRbysQhfK3JojIG0u7V/lCIp9P+FPYRWkC2nzLAp6QAd1sJRu/cVK1D1jGouv26C9ze/Maj+NFCAwyxQBfX5Tii88soq6Pn62Fn8xT79e8XnYyZgeUgEAw7yPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752107904; c=relaxed/simple;
	bh=6woKX6GhDyCDrcd4Q3lO5KNPuG8p69WsE56+c3oHo+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WDnNPa7FOz8FucZM5HxNw+s9+GJz6b1RyAZfnctbKZTw/cxow5qyU+UjUBY3dLX9MFo4aoZirb32VgG7rULKBDoNzfbnx4YpBdvAy3i62HkG89GnucWwZ2nfoFI3jzVMXp4bh/7SMgjUwdbDnqZii200/yXK+LPZ3kKXhXxY7Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kp8zH5xj; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kp8zH5xj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752107902; x=1783643902;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6woKX6GhDyCDrcd4Q3lO5KNPuG8p69WsE56+c3oHo+E=;
  b=kp8zH5xjN8slLOEFsVJwYVhHVeCiRKnyaUlIZLP4OC+LY8dGXupJE4h2
   /5Vb421fHgfSKE5jdaiHbVlhshpf2QBfCd2Wj2gMcWgm24D2lnp+/OSL9
   arAZNNKIklEOHjMZz93RKqoMuUt9t5qnXJAP1NAR5qN/0T4EIJfzf53Rx
   BY8IxK7qIJr3LhootD03zsxozUFQadzEUvSTN20z9WeK9D/WtSJV4hS1z
   LIIrzomaHLNe3PLihkMB6dWTKiHT4tNFKBbPGyCLkc6JnWCEiyV02jAdw
   7CwAHqeJZoEYPgjGdfHACDo67zroqHAAuJAj49vyKFvPZaU+Kkm4h2zQq
   Q==;
X-CSE-ConnectionGUID: kdpeB+j9RHagHcAqSSf2Xw==
X-CSE-MsgGUID: 4S4iP5JlRhqYowKi8JtPnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="76924826"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="76924826"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 17:38:22 -0700
X-CSE-ConnectionGUID: kwr7oHZkRziSWHn733Onrg==
X-CSE-MsgGUID: ZKcA0Ld+QYK9Sijihu95Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186895158"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.110.203]) ([10.125.110.203])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 17:38:19 -0700
Message-ID: <3670eb1d-eaf5-4b8b-b3fe-1190724ee7d7@intel.com>
Date: Wed, 9 Jul 2025 17:38:18 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>, dan.j.williams@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed@epcas5p2.samsung.com>
 <1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 5:39 AM, Neeraj Kumar wrote:
> In 84ec985944ef3, For cxl pmem region auto-assembly after endpoint port
> probing, cxl_nvd presence was required. And for cxl region persistency,
> region creation happens during nvdimm_probe which need the completion
> of endpoint probe.
> 
> It is therefore refactored cxl pmem region auto-assembly after endpoint
> probing to cxl mem probing

The region auto-assembly is moved after the endpoint device is added. However, it's not guaranteed that the endpoint probe has completed and completed successfully. You are just getting lucky timing wise that endpoint probe is completed when the new region discovery is starting. Return of devm_cxl_add_nvdimm() only adds the nvdimm device and triggers the async probe of nvdimm driver. You have to take the endpoint port lock and check if the driver is attached to be certain that endpoint probe is done and successful. Therefore moving the region discovery location probably does not do what you think it does. Maybe take a deeper look at the region discovery code and see how it does retry if things are not present and approach it from that angle? 
 
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c | 38 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  1 +
>  drivers/cxl/mem.c       | 27 ++++++++++++++++++---------
>  drivers/cxl/port.c      | 38 --------------------------------------
>  4 files changed, 57 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 78a5c2c25982..bca668193c49 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1038,6 +1038,44 @@ void put_cxl_root(struct cxl_root *cxl_root)
>  }
>  EXPORT_SYMBOL_NS_GPL(put_cxl_root, "CXL");
>  
> +static int discover_region(struct device *dev, void *root)
> +{
> +	struct cxl_endpoint_decoder *cxled;
> +	int rc;
> +
> +	if (!is_endpoint_decoder(dev))
> +		return 0;
> +
> +	cxled = to_cxl_endpoint_decoder(dev);
> +	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
> +		return 0;
> +
> +	if (cxled->state != CXL_DECODER_STATE_AUTO)
> +		return 0;
> +
> +	/*
> +	 * Region enumeration is opportunistic, if this add-event fails,
> +	 * continue to the next endpoint decoder.
> +	 */
> +	rc = cxl_add_to_region(root, cxled);
> +	if (rc)
> +		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
> +			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
> +
> +	return 0;
> +}
> +
> +void cxl_region_discovery(struct cxl_port *port)
> +{
> +	struct cxl_port *root;
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +
> +	root = &cxl_root->port;
> +
> +	device_for_each_child(&port->dev, root, discover_region);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
> +

I have concerns about adding region related code in core/port.c while the rest of the region code is walled behind CONFIG_CXL_REGION. I think this change needs to go to core/region.c.

DJ

>  static struct cxl_dport *find_dport(struct cxl_port *port, int id)
>  {
>  	struct cxl_dport *dport;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index dcf2a127efc7..9423ea3509ad 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -869,6 +869,7 @@ bool is_cxl_nvdimm(struct device *dev);
>  bool is_cxl_nvdimm_bridge(struct device *dev);
>  int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
> +void cxl_region_discovery(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
>  bool is_cxl_pmem_region(struct device *dev);
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 2f03a4d5606e..aaea4eb178ef 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -152,15 +152,6 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> -	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> -		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
> -		if (rc) {
> -			if (rc == -ENODEV)
> -				dev_info(dev, "PMEM disabled by platform\n");
> -			return rc;
> -		}
> -	}
> -
>  	if (dport->rch)
>  		endpoint_parent = parent_port->uport_dev;
>  	else
> @@ -180,6 +171,24 @@ static int cxl_mem_probe(struct device *dev)
>  			return rc;
>  	}
>  
> +	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> +		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
> +		if (rc) {
> +			if (rc == -ENODEV)
> +				dev_info(dev, "PMEM disabled by platform\n");
> +			return rc;
> +		}
> +	}
> +
> +	/*
> +	 * Now that all endpoint decoders are successfully enumerated, try to
> +	 * assemble region autodiscovery from committed decoders.
> +	 * Earlier it was part of cxl_endpoint_port_probe, So moved it here
> +	 * as cxl_nvd of the memdev needs to be available during the pmem
> +	 * region auto-assembling
> +	 */
> +	cxl_region_discovery(cxlmd->endpoint);
> +
>  	/*
>  	 * The kernel may be operating out of CXL memory on this device,
>  	 * there is no spec defined way to determine whether this device
> diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> index d2bfd1ff5492..361544760a4c 100644
> --- a/drivers/cxl/port.c
> +++ b/drivers/cxl/port.c
> @@ -30,33 +30,6 @@ static void schedule_detach(void *cxlmd)
>  	schedule_cxl_memdev_detach(cxlmd);
>  }
>  
> -static int discover_region(struct device *dev, void *root)
> -{
> -	struct cxl_endpoint_decoder *cxled;
> -	int rc;
> -
> -	if (!is_endpoint_decoder(dev))
> -		return 0;
> -
> -	cxled = to_cxl_endpoint_decoder(dev);
> -	if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
> -		return 0;
> -
> -	if (cxled->state != CXL_DECODER_STATE_AUTO)
> -		return 0;
> -
> -	/*
> -	 * Region enumeration is opportunistic, if this add-event fails,
> -	 * continue to the next endpoint decoder.
> -	 */
> -	rc = cxl_add_to_region(root, cxled);
> -	if (rc)
> -		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
> -			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
> -
> -	return 0;
> -}
> -
>  static int cxl_switch_port_probe(struct cxl_port *port)
>  {
>  	struct cxl_hdm *cxlhdm;
> @@ -95,7 +68,6 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(port->uport_dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  	struct cxl_hdm *cxlhdm;
> -	struct cxl_port *root;
>  	int rc;
>  
>  	rc = cxl_dvsec_rr_decode(cxlds, &info);
> @@ -125,20 +97,10 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
>  	rc = devm_cxl_enumerate_decoders(cxlhdm, &info);
>  	if (rc)
>  		return rc;
> -
>  	/*
>  	 * This can't fail in practice as CXL root exit unregisters all
>  	 * descendant ports and that in turn synchronizes with cxl_port_probe()
>  	 */
> -	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> -
> -	root = &cxl_root->port;
> -
> -	/*
> -	 * Now that all endpoint decoders are successfully enumerated, try to
> -	 * assemble regions from committed decoders
> -	 */
> -	device_for_each_child(&port->dev, root, discover_region);
>  
>  	return 0;
>  }

