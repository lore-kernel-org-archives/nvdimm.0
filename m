Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD0572634
	for <nvdimm@lists.linux.dev>; Wed, 20 Aug 2025 16:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755708079; cv=none; b=LVo3TXts1/klMHSxAUqbeCaIt4GFrdDsfwXvTHgmpxOPNMpayrjXE0kvCoRiDVy9oqA1l4arjWlBulYUegfOPiIggb/1kCpIgjy4AF92coNASkIqtZU+3WhURsL+p/D4vjpEFnJovOzAplm5/VOScU0TurwyXpjaccu7N67vizg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755708079; c=relaxed/simple;
	bh=JfLH27fhb0J7+H3Mq4Hh41L22bQCERGm4XSi44L7slU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfx6e7NbLRilV75RLqcs4lssyNf0E4rkydd7ogGKzsfcyBUwcSjgsNJke1NbdVx81Zo9I95z9h/BW1Zib5M1LzGnlqrvnnsKNEsRu3pXSJiZQlrADeucnPw+aD7Z1CC7BwsOh+eRB6A+snlzz8Nan+HjfLwjyKOYHE8Kh0NuJnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QfRnUX81; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QfRnUX81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755708078; x=1787244078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JfLH27fhb0J7+H3Mq4Hh41L22bQCERGm4XSi44L7slU=;
  b=QfRnUX81V9432B5FMkmrDsMXxPBTXlwaaMRoF6rWqEBvYXKN+4WLV5RS
   JRR2jTyzCowxQe9ikvIZmOv+WbnYbmEOhSguRXCLHSpbjHeCZTcQmoEyP
   dQxbjamLW1HEbPjX32F4s54IrD3opWC9qvmEHGDr5XqeSdajPmhkhkCZb
   C6INPsqdL4ZAYDz//xi1feMugbdx6ebPciS69WNy88A0m7Pwl5e7YPMZt
   NH4S/P4sRE0YT/HuZcxUPFnca0vpKJ3S1qc58YgWzKd0C7dvyNjHJcp7a
   JNEeCWCMM9uBo2vexxVHjgUqKgT2zSo4TVkXSYgmU2+fbRnaah4K7TtF/
   w==;
X-CSE-ConnectionGUID: fzSssLiKRpWt2Mj15j0E0A==
X-CSE-MsgGUID: B4yqyop/SRKM2o1g7mXGqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="75432730"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="75432730"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:41:18 -0700
X-CSE-ConnectionGUID: Rd7XMDQWS52xzZO6igV5zQ==
X-CSE-MsgGUID: 5OSf6dKUST+fNJrSaYnvyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="172435842"
Received: from bvivekan-mobl2.gar.corp.intel.com (HELO [10.247.119.205]) ([10.247.119.205])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 09:41:12 -0700
Message-ID: <c22affa9-1dad-4a66-8db8-8e268806e0a1@intel.com>
Date: Wed, 20 Aug 2025 09:41:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121239epcas5p37956b2999f61e17e8dbfbde7972cef35@epcas5p3.samsung.com>
 <20250730121209.303202-14-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250730121209.303202-14-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/25 5:12 AM, Neeraj Kumar wrote:
> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
> used to get called at last in cxl_endpoint_port_probe(), which requires
> cxl_nvd presence.
> 
> For cxl region persistency, region creation happens during nvdimm_probe
> which need the completion of endpoint probe.
> 
> In order to accommodate both cxl pmem region auto-assembly and cxl region
> persistency, refactored following
> 
> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>    will be called only after successful completion of endpoint probe.
> 
> 2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
>    cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
>    completion of endpoint probe and cxl_nvd presence before its call.

So there are a few issues with doing this. If cxl_endpoint_port_probe() fails, you won't know that while running in cxl_mem_probe(). So you may need to do something similar to here [1] in order to make the probe synchronous with the add endpoint and make sure that the port driver attached successfully. Specifically see changes to devm_cxl_add_memdev().

Also, in endpoint port probe you are holding the device lock and therefore is protected from port removals (endpoint and parents) while you are trying to scan for regions. That is not the case on the memdev probe side if you aren't holding that port lock.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6

DJ

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/region.c | 33 +++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h         |  4 ++++
>  drivers/cxl/mem.c         | 24 +++++++++++++++---------
>  drivers/cxl/port.c        | 39 +--------------------------------------
>  4 files changed, 53 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index e9bf42d91689..eef501f3384c 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3497,6 +3497,39 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_add_to_region, "CXL");
>  
> +static int discover_region(struct device *dev, void *unused)
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
> +	rc = cxl_add_to_region(cxled);
> +	if (rc)
> +		dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
> +			cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
> +
> +	return 0;
> +}
> +
> +void cxl_region_discovery(struct cxl_port *port)
> +{
> +	device_for_each_child(&port->dev, NULL, discover_region);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
> +
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa)
>  {
>  	struct cxl_region_ref *iter;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index b7111e3568d0..6edcec95e9ba 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -864,6 +864,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> +void cxl_region_discovery(struct cxl_port *port);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -886,6 +887,9 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  {
>  	return 0;
>  }
> +static inline void cxl_region_discovery(struct cxl_port *port)
> +{
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 6e6777b7bafb..54501616ff09 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -152,15 +152,6 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> -	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
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
> @@ -184,6 +175,21 @@ static int cxl_mem_probe(struct device *dev)
>  	if (rc)
>  		dev_dbg(dev, "CXL memdev EDAC registration failed rc=%d\n", rc);
>  
> +	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
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
> +	 */
> +	cxl_region_discovery(cxlmd->endpoint);
> +
>  	/*
>  	 * The kernel may be operating out of CXL memory on this device,
>  	 * there is no spec defined way to determine whether this device
> diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> index fe4b593331da..090ae3577f32 100644
> --- a/drivers/cxl/port.c
> +++ b/drivers/cxl/port.c
> @@ -30,33 +30,6 @@ static void schedule_detach(void *cxlmd)
>  	schedule_cxl_memdev_detach(cxlmd);
>  }
>  
> -static int discover_region(struct device *dev, void *unused)
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
> -	rc = cxl_add_to_region(cxled);
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
> @@ -121,17 +94,7 @@ static int cxl_endpoint_port_probe(struct cxl_port *port)
>  	if (rc)
>  		return rc;
>  
> -	rc = devm_cxl_enumerate_decoders(cxlhdm, &info);
> -	if (rc)
> -		return rc;
> -
> -	/*
> -	 * Now that all endpoint decoders are successfully enumerated, try to
> -	 * assemble regions from committed decoders
> -	 */
> -	device_for_each_child(&port->dev, NULL, discover_region);
> -
> -	return 0;
> +	return devm_cxl_enumerate_decoders(cxlhdm, &info);
>  }
>  
>  static int cxl_port_probe(struct device *dev)

