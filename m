Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2186772625
	for <nvdimm@lists.linux.dev>; Wed, 20 Aug 2025 00:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649871; cv=none; b=sUY/yZVRltJSDDGtMubKKX2ot0r9Ou61Tm9/OjuQkWtd2Alup2+lQQi3bXQEc4916+RO32H8ypGDeB/6wPtromkw376N8er3rbvfrlDGQVcSW1/cQp1Gs5EJyhmLgj8kmajZ7qHwMrhOta5Yet58i1/StYC0F1VdbqV05j/v+ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649871; c=relaxed/simple;
	bh=orKiwU+NW3c2Yfxd9xwUkBFgqvDuDKlS4t1PSjWD4G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4yJgkJ4aIoKhXGWu6FWPvIEvXfJb1qUEzyGwxoTyAaV5zbiArhRQJhPwpYPIp4BR/eCn8hJI1wZqNX9hc0c/5mxkxEA9sYEPIl1I/gmq1WukiMDAlD+/gvWh25+YIwQiXnw/z1Vn+FLgV6nFFZonkx15DmfEdMWpF3+4U2uJkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WcJLfcaO; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WcJLfcaO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755649870; x=1787185870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=orKiwU+NW3c2Yfxd9xwUkBFgqvDuDKlS4t1PSjWD4G8=;
  b=WcJLfcaOZnjOQrNllTQWk4FE/uW2np0YFu19q8rkGU5kDIYNz5kbrrfO
   wJ87HH7/5QgValXSTzkx57Kby6NOkHljkzdp1QEAlWs502T5LPsYS9s32
   OAVeXuO2raFGTFWmOgQ9cAlFt6+QjeyZBzmzlI7MlIkx5D9f0z9S/DKDT
   /4dUYamd4KoSXe3CH1tbIaurlWzq/yJXnIQZvjRf4vhx6/xlae653ISaK
   5I/Mg42qJykpBS106la/XsQfUTVB1zoyUk6Oe101mSRnpNSuKPf80bbrq
   5s2qEAMx6/Zv1md0nsMYESlHhMjy3Rf+V8lrY5CO2IzaKLYgT/UouaEf/
   A==;
X-CSE-ConnectionGUID: 3Jlyg7ezQDiljkXFZtKFvg==
X-CSE-MsgGUID: FV4ih//4S7+GlUvveuH1rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57975328"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57975328"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 17:31:09 -0700
X-CSE-ConnectionGUID: LGekBot5Sk++xRkh4qoVcQ==
X-CSE-MsgGUID: rl8RMa59T0GUxu7QGdBrGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="173224396"
Received: from unknown (HELO [10.247.119.200]) ([10.247.119.200])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 17:31:04 -0700
Message-ID: <54012143-0925-4e76-a1e9-0092e10b8c84@intel.com>
Date: Tue, 19 Aug 2025 17:30:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20250730121209.303202-1-s.neeraj@samsung.com>
 <CGME20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0@epcas5p3.samsung.com>
 <20250730121209.303202-15-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250730121209.303202-15-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/30/25 5:12 AM, Neeraj Kumar wrote:
> devm_cxl_pmem_add_region() is used to create cxl region based on region
> information scanned from LSA.
> 
> devm_cxl_add_region() is used to just allocate cxlr and its fields are
> filled later by userspace tool using device attributes (*_store()).
> 
> Inspiration for devm_cxl_pmem_add_region() is taken from these device
> attributes (_store*) calls. It allocates cxlr and fills information
> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
> region creation porbes
> 
> Renamed __create_region() to cxl_create_region() and make it an exported
> routine. This will be used in later patch to create cxl region after
> fetching region information from LSA.
> 
> Also created some helper routines and refactored dpa_size_store(),
> commit_store() to avoid duplicate code usage in devm_cxl_pmem_add_region()

"Some helper routines are created to...."

I would drop the "Also"


> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/core.h   |   1 +
>  drivers/cxl/core/port.c   |  29 ++++++----
>  drivers/cxl/core/region.c | 118 +++++++++++++++++++++++++++++++++-----
>  drivers/cxl/cxl.h         |  12 ++++
>  4 files changed, 134 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 2669f251d677..80c83e0117c6 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -94,6 +94,7 @@ int cxl_dpa_free(struct cxl_endpoint_decoder *cxled);
>  resource_size_t cxl_dpa_size(struct cxl_endpoint_decoder *cxled);
>  resource_size_t cxl_dpa_resource_start(struct cxl_endpoint_decoder *cxled);
>  bool cxl_resource_contains_addr(const struct resource *res, const resource_size_t addr);
> +ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size);
>  
>  enum cxl_rcrb {
>  	CXL_RCRB_DOWNSTREAM,
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 29197376b18e..ba743e31f721 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -243,16 +243,9 @@ static ssize_t dpa_size_show(struct device *dev, struct device_attribute *attr,
>  	return sysfs_emit(buf, "%pa\n", &size);
>  }
>  
> -static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
> -			      const char *buf, size_t len)
> +ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size)

Maybe it should be called cxl_realloc_dpa()? More comments later on...
 
>  {
> -	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
> -	unsigned long long size;
> -	ssize_t rc;
> -
> -	rc = kstrtoull(buf, 0, &size);
> -	if (rc)
> -		return rc;
> +	int rc;
>  
>  	if (!IS_ALIGNED(size, SZ_256M))
>  		return -EINVAL;
> @@ -262,9 +255,23 @@ static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
>  		return rc;
>  
>  	if (size == 0)
> -		return len;
> +		return 0;
> +
> +	return cxl_dpa_alloc(cxled, size);
> +}
> +
> +static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
> +			      const char *buf, size_t len)
> +{
> +	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
> +	unsigned long long size;
> +	ssize_t rc;
> +
> +	rc = kstrtoull(buf, 0, &size);
> +	if (rc)
> +		return rc;
>  
> -	rc = cxl_dpa_alloc(cxled, size);
> +	rc = resize_or_free_dpa(cxled, size);
>  	if (rc)
>  		return rc;
>  
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index eef501f3384c..8578e046aa78 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -703,6 +703,23 @@ static int free_hpa(struct cxl_region *cxlr)
>  	return 0;
>  }
>  
> +static ssize_t resize_or_free_region_hpa(struct cxl_region *cxlr, u64 size)
> +{
> +	int rc;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
> +	if (rc)
> +		return rc;
> +
> +	if (size)
> +		rc = alloc_hpa(cxlr, size);
> +	else
> +		rc = free_hpa(cxlr);
> +
> +	return rc;
> +}

I think it's better to have 2 helper functions rather a single ambiguous one here. alloc_region_hpa() and free_region_hpa(). More on why later.

> +
>  static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>  			  const char *buf, size_t len)
>  {
> @@ -714,15 +731,7 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>  	if (rc)
>  		return rc;
>  
> -	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> -	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
> -		return rc;
> -
> -	if (val)
> -		rc = alloc_hpa(cxlr, val);
> -	else
> -		rc = free_hpa(cxlr);
> -
> +	rc = resize_or_free_region_hpa(cxlr, val);
>  	if (rc)
>  		return rc;
>  
> @@ -2569,6 +2578,76 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>  	return ERR_PTR(rc);
>  }
>  
> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
> +			 int id,
> +			 enum cxl_partition_mode mode,
> +			 enum cxl_decoder_type type,
> +			 struct cxl_pmem_region_params *params,
> +			 struct cxl_decoder *cxld)
> +{
> +	struct cxl_port *root_port;
> +	struct cxl_region *cxlr;
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_region_params *p;
> +	struct device *dev;
> +	int rc;
> +
> +	cxlr = cxl_region_alloc(cxlrd, id);
I think you can use __free() here to drop all the gotos.

struct cxl_region *cxlr __free(put_cxl_region) = cxl_region_alloc(cxlrd, id);

Just make sure to 'return no_free_ptr(cxlr)' at the successful end.


> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +	cxlr->mode = mode;
> +	cxlr->type = type;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		goto err;
> +
> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	if (resize_or_free_region_hpa(cxlr, params->rawsize))
> +		goto err;

Given this is _add_region(), it really should only be calling alloc_region_hpa() and not have to deal with free. Maybe a check before this and make sure params->rawsize is not 0 is needed.

> +
> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
> +	if (resize_or_free_dpa(cxled, 0))
Given that resize_or_free_dpa() always frees, is this call necessary here? 

> +		goto err;
> +
> +	if (cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM))
> +		goto err;
> +
> +	if (resize_or_free_dpa(cxled, params->rawsize))

Seems like it can be called once here instead and it'll just free and then re-allocate whatever size in params->rawsize.

> +		goto err;
> +
> +	/* Attaching only one target due to interleave_way == 1 */
Is it missing a check of interleave_ways here? Also maybe additional comments on why support iw==1 only?

> +	if (attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE))
> +		goto err;
> +
> +	if (__commit(cxlr))
> +		goto err;
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto err;
> +
> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
> +	rc = devm_add_action_or_reset(root_port->uport_dev,
> +			unregister_region, cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	dev_dbg(root_port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
> +	return cxlr;
> +
> +err:
> +	put_device(dev);
> +	return ERR_PTR(rc);
> +}
> +
>  static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
>  {
>  	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
> @@ -2586,8 +2665,10 @@ static ssize_t create_ram_region_show(struct device *dev,
>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>  }
>  
> -static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
> -					  enum cxl_partition_mode mode, int id)
> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
> +				     enum cxl_partition_mode mode, int id,
> +				     struct cxl_pmem_region_params *params,

Maybe name it pmem_params to avoid confusion with cxl region params.

> +				     struct cxl_decoder *cxld)
>  {
>  	int rc;
>  
> @@ -2609,8 +2690,14 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> -	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
> +	if (params)
> +		return devm_cxl_pmem_add_region(cxlrd, id, mode,
> +				CXL_DECODER_HOSTONLYMEM, params, cxld);
> +	else

'else' not needed here. Just directly return.

> +		return devm_cxl_add_region(cxlrd, id, mode,
> +				CXL_DECODER_HOSTONLYMEM);
>  }
> +EXPORT_SYMBOL_NS_GPL(cxl_create_region, "CXL");
>  
>  static ssize_t create_region_store(struct device *dev, const char *buf,
>  				   size_t len, enum cxl_partition_mode mode)
> @@ -2623,7 +2710,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
>  	if (rc != 1)
>  		return -EINVAL;
>  
> -	cxlr = __create_region(cxlrd, mode, id);
> +	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
>  	if (IS_ERR(cxlr))
>  		return PTR_ERR(cxlr);
>  
> @@ -3414,8 +3501,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
>  	struct cxl_region *cxlr;
>  
>  	do {
> -		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
> -				       atomic_read(&cxlrd->region_id));
> +		cxlr = cxl_create_region(cxlrd, cxlds->part[part].mode,
> +					 atomic_read(&cxlrd->region_id),
> +					 NULL, NULL);
>  	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
>  
>  	if (IS_ERR(cxlr)) {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 6edcec95e9ba..129db2e49aa7 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -865,6 +865,10 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
>  void cxl_region_discovery(struct cxl_port *port);
> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
> +				     enum cxl_partition_mode mode, int id,
> +				     struct cxl_pmem_region_params *params,
> +				     struct cxl_decoder *cxld);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -890,6 +894,14 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  static inline void cxl_region_discovery(struct cxl_port *port)
>  {
>  }
> +static inline struct cxl_region *
> +cxl_create_region(struct cxl_root_decoder *cxlrd,
> +		  enum cxl_partition_mode mode, int id,
> +		  struct cxl_pmem_region_params *params,
> +		  struct cxl_decoder *cxld)
> +{
> +	return NULL;

return ERR_PTR(-EOPNOTSUPP);

> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);

