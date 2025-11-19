Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4D92E7BBA
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763587991; cv=none; b=OVV5bBpJzS1YhJmF7J4/Og/uLF0Z7S/8pv2sYMhw4QRt0Yl05/ImxRau87udOPfjByw0v7l/hKtprFDvpTexMRV0Qb9RDWdNLKGfHUZ4HhyBShT+rlcR3qiKkxqJLeBZQXsHlN2NY4h5QDMHoot385J7hcGEk6jXSd1Ank8UaGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763587991; c=relaxed/simple;
	bh=AMeGEQ4wG5OS9LsPeGu1hUkFekYz8uRfblRkNdhDNpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B+yKQbm/Gk3Gs6X/E8y2YCKMneLyw2HdUItZGmK8VA6eZRr1oWsXRDPin1fbfBDE35jW4no0NpdfNS3cIKeDteceSc1y4qFgUKojKlH8vGRbbMc3JLelv+s00pmBJ48xcmp/DkgapPfC9+hSSkgvem2q5WxZYng/vqQO3qbHVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLN1DcVr; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLN1DcVr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763587989; x=1795123989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AMeGEQ4wG5OS9LsPeGu1hUkFekYz8uRfblRkNdhDNpw=;
  b=DLN1DcVr5w0nElGyh1UY+nJwzl5XllR638tqOkieLCaGv4M6lWOHPDdB
   m/mrscqANcUES4QDttGa+LXzGVKn8nwpOH+QACPcCd01MDg8diZQxzIQg
   fY4rXcO4Nr8lzPgKs721YXo314eKkZ7gpB5mKkNG383YIyz9JMIMv80Pl
   ptiDhhPw9hmDetwSPrF6qxhCbYUj+v3NU6N030IHIeWZrvvSVBO8uZq1Y
   N88Az4cnBbYQMpQdbF4zuHrUf1FXgZPPGX8yGB/wL1XsUMW78XgRTIUV0
   pFnY9WNrd/5VY5pZ+82Mnr5hUSWL1qkYZXfGUSpnSeIyLZ8m3DW3oxWjR
   g==;
X-CSE-ConnectionGUID: bS616HqnTsShSWa4fzuIow==
X-CSE-MsgGUID: ZLJZ7t5wTNSOyyQA72eMaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65735378"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="65735378"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 13:33:08 -0800
X-CSE-ConnectionGUID: XcBN6IBSTBezW3ua0xW4Dw==
X-CSE-MsgGUID: kIJ/+nHBRvSPWScavTlypg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="196306259"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 13:33:08 -0800
Message-ID: <80883937-a993-4f73-b719-18ec9a06014e@intel.com>
Date: Wed, 19 Nov 2025 14:33:07 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 11/17] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075327epcas5p29991fec95ca8a26503f457a30bb2429a@epcas5p2.samsung.com>
 <20251119075255.2637388-12-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-12-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
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
> Rename __create_region() to cxl_create_region(), which will be used
> in later patch to create cxl region after fetching region information
> from LSA.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

small comment below, otherwise
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/cxl/core/core.h   |  12 ++++
>  drivers/cxl/core/region.c | 124 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 131 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 1fb66132b777..fde96507cb75 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -42,6 +42,10 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port);
>  struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
>  u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
>  		   u64 dpa);
> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
> +				     enum cxl_partition_mode mode, int id,
> +				     struct cxl_pmem_region_params *params,
> +				     struct cxl_decoder *cxld);
>  
>  #else
>  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
> @@ -71,6 +75,14 @@ static inline int cxl_region_init(void)
>  static inline void cxl_region_exit(void)
>  {
>  }
> +static inline struct cxl_region *
> +cxl_create_region(struct cxl_root_decoder *cxlrd,
> +		  enum cxl_partition_mode mode, int id,
> +		  struct cxl_pmem_region_params *params,
> +		  struct cxl_decoder *cxld)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
>  #define CXL_REGION_ATTR(x) NULL
>  #define CXL_REGION_TYPE(x) NULL
>  #define SET_CXL_REGION_ATTR(x)
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index 3c868c4de4ec..06a75f0a8e9b 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2618,6 +2618,114 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>  	return ERR_PTR(rc);
>  }
>  
> +static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
> +{
> +	int rc;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
> +		return rc;
> +
> +	if (!size)
> +		return -EINVAL;

Why not do this check before acquiring the lock?

DJ

> +
> +	return alloc_hpa(cxlr, size);
> +}
> +
> +static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
> +{
> +	int rc;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	if (!IS_ALIGNED(size, SZ_256M))
> +		return -EINVAL;
> +
> +	rc = cxl_dpa_free(cxled);
> +	if (rc)
> +		return rc;
> +
> +	return cxl_dpa_alloc(cxled, size);
> +}
> +
> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
> +			 struct cxl_pmem_region_params *params,
> +			 struct cxl_decoder *cxld,
> +			 enum cxl_decoder_type type)
> +{
> +	struct cxl_endpoint_decoder *cxled;
> +	struct cxl_region_params *p;
> +	struct cxl_port *root_port;
> +	struct device *dev;
> +	int rc;
> +
> +	struct cxl_region *cxlr __free(put_cxl_region) =
> +		cxl_region_alloc(cxlrd, id);
> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +
> +	cxlr->mode = CXL_PARTMODE_PMEM;
> +	cxlr->type = type;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	rc = alloc_region_hpa(cxlr, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = alloc_region_dpa(cxled, params->rawsize);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	/*
> +	 * TODO: Currently we have support of interleave_way == 1, where
> +	 * we can only have one region per mem device. It means mem device
> +	 * position (params->position) will always be 0. It is therefore
> +	 * attaching only one target at params->position
> +	 */
> +	if (params->position)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = __commit(cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	rc = device_add(dev);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
> +	rc = devm_add_action_or_reset(root_port->uport_dev,
> +			unregister_region, cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	dev_dbg(root_port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
> +
> +	return no_free_ptr(cxlr);
> +}
> +
>  static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
>  {
>  	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
> @@ -2635,8 +2743,10 @@ static ssize_t create_ram_region_show(struct device *dev,
>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>  }
>  
> -static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
> -					  enum cxl_partition_mode mode, int id)
> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
> +				     enum cxl_partition_mode mode, int id,
> +				     struct cxl_pmem_region_params *pmem_params,
> +				     struct cxl_decoder *cxld)
>  {
>  	int rc;
>  
> @@ -2658,6 +2768,9 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> +	if (pmem_params)
> +		return devm_cxl_pmem_add_region(cxlrd, id, pmem_params, cxld,
> +						CXL_DECODER_HOSTONLYMEM);
>  	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
>  }
>  
> @@ -2672,7 +2785,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
>  	if (rc != 1)
>  		return -EINVAL;
>  
> -	cxlr = __create_region(cxlrd, mode, id);
> +	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
>  	if (IS_ERR(cxlr))
>  		return PTR_ERR(cxlr);
>  
> @@ -3641,8 +3754,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
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

