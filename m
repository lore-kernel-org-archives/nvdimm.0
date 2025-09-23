Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06DD3043C9
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 22:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758667082; cv=none; b=b6eageT2z6qaW6fQ+TzVeS2ggbzWHKtb7hYfQfT/DNJfaP6KfLA5ochbfo3J2J/H06OV8eadhrdiwOWQOfSbQeKIJQbvoJFp78jkAJkW8u4hhPEeIZkNXJzl2ey0REjT7ISOZwKW1vGP0B2aIX1iqfsl7ySTleXVbuvWjNQ8+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758667082; c=relaxed/simple;
	bh=18MRxfqbAerdt2DV+//v66GYQWGoRSGQpES+1chutj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4N02zD5sjQmH7ETy1qnPwrmWpblPoT3YEoVzd/rCzq/n9YF/7LFW2WHb8yW5VxHvJ/pbHRAuDntx8c4nXeae17QvVu9IQR+6OSK5DwUxR5c5JwPYTaOKKZmftSkzw/YYzrDF/+siKZjWfJ+Gj/ldaJZWJ8N3JRAZp/FlGLOks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dee6mSo2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dee6mSo2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758667080; x=1790203080;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=18MRxfqbAerdt2DV+//v66GYQWGoRSGQpES+1chutj4=;
  b=dee6mSo2QLHF5tm0fBe9JcW4KME4NoJQlXaBCT9z4CM9U+954/5oMCPO
   8h7iRvk2PTJmR7g6EiS3dl/2F57DCOnGVkqPIgHkBBHeMTA5FeUlVGbjD
   tnKDioopQOY2srUAr3h4dZV5rrX3NZrxvo1NJzcMogyunBUCAXreoTUN/
   Thdrb7VlI/l8qQzWdI307fhMdwCXiSfdL22QOil5thyoJ+CixAklHDFJ/
   w2NKevZiFIgiVymCfq4VcgiXCTM6n6HXfBpHeUNUPsN6EOUw1Ea2CzF7R
   TeSkV5zR0nYC4JGHPrR0IG9jn+KLF7F4/H8pm5tTToJmHDTDkpBFX1TiR
   g==;
X-CSE-ConnectionGUID: 2FsvpDMJRTmSMjRL5Q0NpQ==
X-CSE-MsgGUID: 1cYSV9ETRuqD2mihbj6aSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72315821"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="72315821"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 15:37:59 -0700
X-CSE-ConnectionGUID: D8DZZWOHRRmLTOFJ33FWIw==
X-CSE-MsgGUID: q74YHrNiSUaVslrb1S101A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="176001422"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.108.174]) ([10.125.108.174])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 15:37:56 -0700
Message-ID: <c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>
Date: Tue, 23 Sep 2025 15:37:54 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97@epcas5p1.samsung.com>
 <20250917134116.1623730-14-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-14-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
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

Given that we are going forward with this implementation [1] from Dan and drivers like the type2 enabling are going to be using it as well, can you please consider converting this change to Dan's mechanism instead of creating a whole new one?

I think the region discovery can be done via the ops->probe() callback. Thanks.

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
> index 7a0cead24490..c325aa827992 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -3606,6 +3606,39 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled)
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
> index 4fe3df06f57a..b57597e55f7e 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -873,6 +873,7 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
> +void cxl_region_discovery(struct cxl_port *port);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -895,6 +896,9 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
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
> index cf32dc50b7a6..07bb909b7d2e 100644
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

