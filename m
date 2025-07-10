Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC0E283FE8
	for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752167913; cv=none; b=Q/C+d1KuoaCcGRZBnE1+ut4b9vGiAni+ySI58Iey69/s4CP5BdMDp15j8FKiwZO5fa3MobpqVdF3ERlZ33OF76VGRJMtDmnJf+KeQEjXUIlMzIhw7dh5gKPzgiIPY7+U5wRY7RCna0a8rEpEzwC3/SEJdiOpo8YZEwNVt7/hi0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752167913; c=relaxed/simple;
	bh=5gyg9rYJ+egrYstYAbgunAN1HeUaP9Gl1TjTxT96v8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cfrbZJMUy+aqGngOB/AlBdcPAi+fbIu5Q0MzosqH6ja3IsCfIxZ0iSJpSjpM9KcH5vzEo2LWvX9coAMFyNKAdU0uvxrC8t902h4GmfjKzlPv9JWNGK23zwiDfBSN4B7AKvpC16JMQS6cJFkNuCDqvqFpc9C1gwhovBQloF/QZvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g+HwFXFo; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+HwFXFo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752167910; x=1783703910;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5gyg9rYJ+egrYstYAbgunAN1HeUaP9Gl1TjTxT96v8U=;
  b=g+HwFXFoTdnNRpvBZ24iMlf+M0oHUcPDwnpXCbBvpsJFQSShmRlRkyLL
   WwXTGYArI97AwFU9E/7YVUO++BarGYti/ztbGHhF2cR/eNkrWTTAMbcvU
   ovF8kTHl4noJ3YAvvmN30PnNUzaEY/QxRKqmxhUP1LwVBzapw5vL5NZnA
   mgwv/Cui5ukSG7Izziex7xDK9iBFd3DTCjQ6CwYukUBkWFBSYnBl7T9It
   imPqNxGg3YfbVqEBeACPF8Ag6QU3Hkfw42vX+boz6eEruHfxjHCUbSQqj
   pnE/zeIknUXhEqB7YNwbTHEo0Wgmcp8Aee6ptQeqA2WDYLUFCPsBAxWkn
   w==;
X-CSE-ConnectionGUID: PMuTRVjkR1yQ1adOuE5/NA==
X-CSE-MsgGUID: x5sKJ3d1TZO+x+N+Dgxvmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="53678046"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="53678046"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 10:18:30 -0700
X-CSE-ConnectionGUID: lzbY+D7oQ7mK/+Z1Gp8Alg==
X-CSE-MsgGUID: eBp5sAI/Q9iYYWQsxRdpnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="156494179"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.242]) ([10.125.110.242])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 10:18:28 -0700
Message-ID: <45c254fe-fd74-46e7-bf06-5614810f7193@intel.com>
Date: Thu, 10 Jul 2025 10:18:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 18/20] cxl/pmem: Add support of cxl lsa 2.1 support in
 cxl pmem
To: Neeraj Kumar <s.neeraj@samsung.com>, dan.j.williams@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124058epcas5p2324bd3b1bf95d47f553d90fdc727e50d@epcas5p2.samsung.com>
 <592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <592959754.121750165383213.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 5:39 AM, Neeraj Kumar wrote:
> Add support of cxl lsa 2.1 using NDD_CXL_LABEL flag. It also creates cxl
> region based on region information parsed from LSA.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/pmem.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
> index ffcebb8d382f..2733d79b32d5 100644
> --- a/drivers/cxl/pmem.c
> +++ b/drivers/cxl/pmem.c
> @@ -58,6 +58,63 @@ static const struct attribute_group *cxl_dimm_attribute_groups[] = {
>  	NULL
>  };
>  
> +static int match_ep_decoder(struct device *dev, void *data)
> +{
> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
> +
> +	if (!cxld->region)
> +		return 1;
> +	else
> +		return 0;
> +}

return !cxld->region;


> +
> +static struct cxl_decoder *cxl_find_free_decoder(struct cxl_port *port)
> +{
> +	struct device *dev;
> +
> +	dev = device_find_child(&port->dev, NULL, match_ep_decoder);
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_decoder(dev);
> +}
> +
> +static int create_pmem_region(struct nvdimm *nvdimm)
> +{
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_nvdimm_bridge *cxl_nvb;
> +	struct cxl_pmem_region_params *params;
> +	struct cxl_root_decoder *cxlrd;
> +	struct cxl_decoder *cxld;
> +	struct cxl_region *cxlr;
> +

probably need a lockdep_assert_held(&cxl_region_rwsem).

> +	if (!nvdimm)
> +		return -ENOTTY;

-ENODEV?

> +
> +	if (!nvdimm_has_cxl_region(nvdimm))
> +		return 0;
> +
> +	cxl_nvd = nvdimm_provider_data(nvdimm);
> +	params = nvdimm_get_cxl_region_param(nvdimm);
> +	cxlmd = cxl_nvd->cxlmd;
> +	cxl_nvb = cxlmd->cxl_nvb;
> +	cxlrd = cxlmd->cxlrd;
> +
> +	/* FIXME: Limitation: Region creation only when interleave way == 1 */
> +	if (params->nlabel == 1) {
> +		cxld = cxl_find_free_decoder(cxlmd->endpoint);
> +		cxlr = cxl_create_pmem_region(cxlrd, cxld, params,
> +				atomic_read(&cxlrd->region_id));
> +		if (IS_ERR(cxlr))
> +			dev_dbg(&cxlmd->dev, "Region Creation failed\n");

return PTR_ERR(cxlr); ?

> +	} else {
> +		dev_dbg(&cxlmd->dev, "Region Creation is not supported with iw > 1\n");
> +	}
> +
> +	return 0;
> +}
> +
>  static int cxl_nvdimm_probe(struct device *dev)
>  {
>  	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
> @@ -74,6 +131,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return rc;
>  
>  	set_bit(NDD_LABELING, &flags);
> +	set_bit(NDD_CXL_LABEL, &flags);

Ok here's the NDD_CXL_LABEL set. I think the driver should be probing the label index block and retrieve the label version and determine how to support from there instead of hard coding a flag. 

>  	set_bit(NDD_REGISTER_SYNC, &flags);
>  	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
>  	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> @@ -86,6 +144,7 @@ static int cxl_nvdimm_probe(struct device *dev)
>  		return -ENOMEM;
>  
>  	dev_set_drvdata(dev, nvdimm);
> +	create_pmem_region(nvdimm);
>  	return devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
>  }
>  

