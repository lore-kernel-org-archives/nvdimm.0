Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD2230C366
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 23:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763595426; cv=none; b=WxRHhrqeUOpH3l/Mx2wgQm0F4RRLgBkEuQcGgMFkcMl8CdAANiWnLDfgviymwSsdxBwvdwW1qjeAHaoX5grnV/vZ0IBlc75AAjOGldDOhR2DqsHOzsF8FerVJEnvc4ajIYvI3Dc+/kzJxRQx4prOygYNfbT1qiexiRnSh03dU2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763595426; c=relaxed/simple;
	bh=TI7SSgTcN14LnFZYJVyaN1iEPCzGoHJsg0Gif7txAeo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lE9pq6VZJbIQiOoPRhQy7GfLJHFMDDx1f7RsEb20Cm+UXxyG+zbbQ8Xpbb9xlUgoMieqglpmtg61pz3tGdksfqEYja2xO1iQSAf/Y/Ntei4H4IJDOpS/ygeyIZQGuPXltMiHjaA0EJfGLd9mpl+ZzZk/Ferm3wUVfiy0DAAjAsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EINoEOfD; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EINoEOfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763595425; x=1795131425;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TI7SSgTcN14LnFZYJVyaN1iEPCzGoHJsg0Gif7txAeo=;
  b=EINoEOfDrcWcv/ELZ8FDZIyng8bkZgseieAyB5p8YdryWOPAYSCCSbNy
   SPGl6F7J4Cow+shnIUenTFgwZ5Vm3OrwW5m8rDAVULlL073bCbkEkNZTh
   QIJ+Y6RSA9TzCNjAE+TFLg1PPyLm5B3ui+6lUbscNQdAM+/kPtugsEzpp
   w1U6eefHv1F2hqbreD+h1ZeQoDpbqKHcr5Yt0OkiMtQLqZbpiyAklqnMm
   uHyAbgKXl0EzFPdT5lCaG/FJgj5UwpUi8fUE9QNzP0mqhNtlSpBrhlVTW
   gb3v2gr4Zfv97twxnUWCAGE7NYrRPsjI2hZMP06STv6aNVGKDtqc4YyzE
   g==;
X-CSE-ConnectionGUID: dFoP61MuR5+4IktT2j1D1A==
X-CSE-MsgGUID: v4H3DXIxT5absub4cYgmdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="83041604"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="83041604"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:37:04 -0800
X-CSE-ConnectionGUID: fQGygUeUQBi6Dub7KPvg4Q==
X-CSE-MsgGUID: UkAnb+HbTUKiXgfvvGV9yw==
X-ExtLoop1: 1
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:37:03 -0800
Message-ID: <13001a14-4b13-4405-afe1-c0e68dc57406@intel.com>
Date: Wed, 19 Nov 2025 16:37:01 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 16/17] cxl/pmem_region: Create pmem region using
 information parsed from LSA
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112@epcas5p3.samsung.com>
 <20251119075255.2637388-17-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-17-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> create_pmem_region() creates cxl region based on region information
> parsed from LSA. This routine required cxl root decoder and endpoint
> decoder. Therefore added cxl_find_root_decoder_by_port() and
> cxl_find_free_ep_decoder(). These routines find cxl root decoder and
> free endpoint decoder on cxl bus using cxl port

Please consider:
create_pmem_region() creates CXL region based on region information
parsed from the Label Storage Area (LSA). This routine requires cxl root
decoder and endpoint decoder. Add cxl_find_root_decoder_by_port()
and cxl_find_free_ep_decoder() to find the root decoder and a free
endpoint decoder respectively.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/core.h        |  4 ++
>  drivers/cxl/core/pmem_region.c | 97 ++++++++++++++++++++++++++++++++++
>  drivers/cxl/core/region.c      | 13 +++--
>  drivers/cxl/cxl.h              |  5 ++
>  4 files changed, 115 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index beeb9b7527b8..dd2efd3deb5e 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -35,6 +35,7 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>  #define CXL_REGION_TYPE(x) (&cxl_region_type)
>  #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
>  #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
> +int verify_free_decoder(struct device *dev);
>  int cxl_region_init(void);
>  void cxl_region_exit(void);
>  int cxl_get_poison_by_endpoint(struct cxl_port *port);
> @@ -88,6 +89,9 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
>  {
>  	return NULL;
>  }
> +static inline int verify_free_decoder(struct device *dev)
> +{

this function needs to return something

> +}
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index be4feb73aafc..06665937c180 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -291,3 +291,100 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>  	cxlr->cxl_nvb = NULL;
>  	return rc;
>  }
> +
> +static int match_root_decoder(struct device *dev, const void *data)
> +{
> +	return is_root_decoder(dev);

Is it suppose to just grab the first root decoder? If so the function should be match_first_root_decoder(). However, should the root decoder cover the region it's trying to match to? Should there be some checks to see if the region fits under the root decoder range? Also, should it not check the root decoder flags to see if it has CXL_DECODER_F_PMEM set so the CFMWS can cover PMEM?

> +}
> +
> +/**
> + * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in CXL port topology
> + *
> + * Caller of this function must call put_device() when done as a device ref
> + * is taken via device_find_child()
> + */
> +static struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port)
> +{
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +	struct device *dev;
> +
> +	if (!cxl_root)
> +		return NULL;
> +
> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_root_decoder(dev);
> +}
> +
> +static int match_free_ep_decoder(struct device *dev, const void *data)
> +{
> +	if (!is_endpoint_decoder(dev))
> +		return 0;
> +
> +	return verify_free_decoder(dev);
> +}
> +
> +/**
> + * cxl_find_endpoint_decoder_by_port() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in CXL port topology
> + *
> + * Caller of this function must call put_device() when done as a device ref
> + * is taken via device_find_child()
> + */
> +static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
> +{
> +	struct device *dev;
> +
> +	dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_decoder(dev);
> +}
> +
> +void create_pmem_region(struct nvdimm *nvdimm)
> +{
> +	struct cxl_nvdimm *cxl_nvd;
> +	struct cxl_memdev *cxlmd;
> +	struct cxl_pmem_region_params *params;
> +	struct cxl_region *cxlr;
> +
> +	if (!nvdimm_has_cxl_region(nvdimm))
> +		return;
> +
> +	lockdep_assert_held(&cxl_rwsem.region);
> +	cxl_nvd = nvdimm_provider_data(nvdimm);
> +	params = nvdimm_get_cxl_region_param(nvdimm);
> +	cxlmd = cxl_nvd->cxlmd;
> +
> +	/* TODO: Region creation support only for interleave way == 1 */
> +	if (!(params->nlabel == 1)) {
> +		dev_dbg(&cxlmd->dev,
> +				"Region Creation is not supported with iw > 1\n");
> +		return;
> +	}
> +
> +	struct cxl_root_decoder *cxlrd __free(put_cxl_root_decoder) =
> +		cxl_find_root_decoder_by_port(cxlmd->endpoint);
> +	if (!cxlrd) {
> +		dev_err(&cxlmd->dev, "CXL root decoder not found\n");
> +		return;
> +	}
> +
> +	struct cxl_decoder *cxld __free(put_cxl_decoder) =
> +		cxl_find_free_ep_decoder(cxlmd->endpoint);
> +	if (!cxlrd) {
> +		dev_err(&cxlmd->dev, "CXL endpoint decoder not found\n");
> +		return;
> +	}
> +
> +	cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
> +			atomic_read(&cxlrd->region_id),
> +			params, cxld);
> +	if (IS_ERR(cxlr))
> +		dev_warn(&cxlmd->dev, "Region Creation failed\n");
> +}
> +EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 408e139718f1..96f3cf4143b8 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -835,15 +835,12 @@ static int check_commit_order(struct device *dev, void *data)
>  	return 0;
>  }
>  
> -static int match_free_decoder(struct device *dev, const void *data)
> +int verify_free_decoder(struct device *dev)

I would call it is_free_decoder() instead. Probably ok to return bool instead of int.

DJ

>  {
>  	struct cxl_port *port = to_cxl_port(dev->parent);
>  	struct cxl_decoder *cxld;
>  	int rc;
>  
> -	if (!is_switch_decoder(dev))
> -		return 0;
> -
>  	cxld = to_cxl_decoder(dev);
>  
>  	if (cxld->id != port->commit_end + 1)
> @@ -867,6 +864,14 @@ static int match_free_decoder(struct device *dev, const void *data)
>  	return 1;
>  }
>  
> +static int match_free_decoder(struct device *dev, const void *data)
> +{
> +	if (!is_switch_decoder(dev))
> +		return 0;
> +
> +	return verify_free_decoder(dev);
> +}
> +
>  static bool spa_maps_hpa(const struct cxl_region_params *p,
>  			 const struct range *range)
>  {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 8c76c4a981bf..088841a3e238 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -792,6 +792,7 @@ struct cxl_root *find_cxl_root(struct cxl_port *port);
>  DEFINE_FREE(put_cxl_root, struct cxl_root *, if (_T) put_device(&_T->port.dev))
>  DEFINE_FREE(put_cxl_port, struct cxl_port *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
>  DEFINE_FREE(put_cxl_root_decoder, struct cxl_root_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->cxlsd.cxld.dev))
> +DEFINE_FREE(put_cxl_decoder, struct cxl_decoder *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
>  DEFINE_FREE(put_cxl_region, struct cxl_region *, if (!IS_ERR_OR_NULL(_T)) put_device(&_T->dev))
>  
>  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
> @@ -933,6 +934,7 @@ static inline int cxl_region_discovery(struct cxl_memdev *cxlmd)
>  #ifdef CONFIG_CXL_PMEM_REGION
>  bool is_cxl_pmem_region(struct device *dev);
>  struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
> +void create_pmem_region(struct nvdimm *nvdimm);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -942,6 +944,9 @@ static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
>  {
>  	return NULL;
>  }
> +static inline void create_pmem_region(struct nvdimm *nvdimm)
> +{
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);

