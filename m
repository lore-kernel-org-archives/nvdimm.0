Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EE323B0
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 20:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746863; cv=none; b=Mb90R8YhEKjK+ldkpzXVQAqP7vg9TTR2K2yh5EkkX5lGfzcpn0r72MWmqCkgmcnfL1f5cysqHI6O+Wvz58Yp8RE7ctiKzMoNDZZItq3a9x+iuY9i3ALhBQIX2rlh+NrwLaoRV2DBDZxab4EAsGkI407gF7X1zQqbVQJC2TtH3h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746863; c=relaxed/simple;
	bh=bJYJBqlXTzP4LxCJJVAzGlHEXx8Sbc86kRJMUYL7MwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TXnN3w9ZX+if6aTZAhM/eQca3Mt11gdhQ2pBYVAn5XNV9ICiApUW2vNp3lIYMtEsxuUoyQ/SvENukCcO5vjPj5p1rTmIUaTEykmmDjXXVSPGIcqoFg0h430McNPaEKese2rRY0TKjALzjOORQkNaeJGHu5FeW3Hre2+ynRPbs10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKO4WeHg; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKO4WeHg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758746862; x=1790282862;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bJYJBqlXTzP4LxCJJVAzGlHEXx8Sbc86kRJMUYL7MwI=;
  b=MKO4WeHgo3dkppnmGQS3OVUANT73HxAWrve9orzZG0c4H/aiIH+yLOL/
   XiiFOXbD982GQXiaD65sDSoavVJFQ/gIDagWjVeusSDB2qaCL2D7yE878
   P43aphcjALrPmcFUlE9NycXt1ODMF1ZlH3gsGUvH3e79XDnsUwP7DNN9U
   WUzFfsl6syNrgsjIJ8pdVMUM1qxQaWo2zKMe8HxzQh6oJVlER/8hmrNzR
   oYJsKAUR96QWhw9TuT3uTZn+DYHIDjwfDBT9oz08qjGqTleQn6DZbG8oY
   GmOkUeyekD/+Km0RDI785YQE91uRhStUC7lfsu38lKwkrwu2PzO7NgTwh
   Q==;
X-CSE-ConnectionGUID: h77vkIwiQVWFuD62xhP1kg==
X-CSE-MsgGUID: 3GxT4AnYSAOPrJW7/wjbiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64863858"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64863858"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:47:24 -0700
X-CSE-ConnectionGUID: RDn9y3GTQrepCIm/Tkhnng==
X-CSE-MsgGUID: yTuw40yBTt+6y3vSC8rEaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="182287343"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.218]) ([10.125.108.218])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:47:22 -0700
Message-ID: <28d78d2b-c17d-4910-9f28-67af1fbb10ee@intel.com>
Date: Wed, 24 Sep 2025 13:47:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 20/20] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720@epcas5p1.samsung.com>
 <20250917134116.1623730-21-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-21-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Add support of CXL LSA 2.1 using NDD_REGION_LABELING flag. It creates
> cxl region based on region information parsed from LSA.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/pmem_region.c | 53 ++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h              |  4 +++
>  drivers/cxl/pmem.c             |  2 ++
>  3 files changed, 59 insertions(+)
> 
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index 665b603c907b..3ef9c7d15041 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -290,3 +290,56 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  	return rc;
>  }
>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
> +
> +static int match_free_ep_decoder(struct device *dev, const void *data)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);

I think this is needed if the function is match_free_ep_decoder().

if (!is_endpoint_decoder(dev))
	return 0;

> +
> +	return !cxld->region;
> +}

May want to borrow some code from match_free_decoder() in core/region.c. I think the decoder commit order matters?

> +
> +static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
> +{
> +	struct device *dev;
> +
> +	dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
> +	if (!dev)
> +		return NULL;
> +
> +	/* Release device ref taken via device_find_child() */
> +	put_device(dev);

Should have the caller put the device.

> +	return to_cxl_decoder(dev);
> +}
> +
> +void create_pmem_region(struct nvdimm *nvdimm)
> +{
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_pmem_region_params *params;
> +	struct cxl_root_decoder *cxlrd;
> +	struct cxl_decoder *cxld;
> +	struct cxl_region *cxlr;
> +
> +	if (!nvdimm_has_cxl_region(nvdimm))
> +		return;
> +
> +	lockdep_assert_held(&cxl_rwsem.region);
> +	cxl_nvd = nvdimm_provider_data(nvdimm);
> +	params = nvdimm_get_cxl_region_param(nvdimm);
> +	cxlmd = cxl_nvd->cxlmd;
> +	cxlrd = cxlmd->cxlrd;
> +
> +	 /* TODO: Region creation support only for interleave way == 1 */
> +	if (!(params->nlabel == 1))
> +		dev_info(&cxlmd->dev,
> +			 "Region Creation is not supported with iw > 1\n");

Why not just exit here. Then the else is not necessary.

Also maybe deb_dbg().

> +	else {
> +		cxld = cxl_find_free_ep_decoder(cxlmd->endpoint);
> +		cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
> +					 atomic_read(&cxlrd->region_id),
> +					 params, cxld);
> +		if (IS_ERR(cxlr))
> +			dev_info(&cxlmd->dev, "Region Creation failed\n");

dev_warn()

> +	}
> +}
> +EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index f01f8c942fdf..0a87ea79742a 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -910,6 +910,7 @@ cxl_create_region(struct cxl_root_decoder *cxlrd,
>  bool is_cxl_pmem_region(struct device *dev);
>  struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
> +void create_pmem_region(struct nvdimm *nvdimm);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -923,6 +924,9 @@ static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  {
>  	return 0;
>  }
> +static inline void create_pmem_region(struct nvdimm *nvdimm)
> +{
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index 38a5bcdc68ce..0cdef01dbc68 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -135,6 +135,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return rc;
>  
>  	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_REGION_LABELING, &flags);
>  	set_bit(NDD_REGISTER_SYNC, &flags);
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> @@ -155,6 +156,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return -ENOMEM;
>  
>  	dev_set_drvdata(dev, nvdimm);
> +	create_pmem_region(nvdimm);
>  	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>  }
>  

