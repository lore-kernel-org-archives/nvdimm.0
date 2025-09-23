Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DB30CB20
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 23:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758671410; cv=none; b=RcNpY3FWzuVDreQmKHWFyafm9slqyxJ+fRtBid3LFDpfpFR9TMDivczHyB5Qjv6EC6VZJ7KtveNQvPEM570RieMXlfe6sTEqEkBtBCeBbr9t+NB2oSUxYTYfa3BjTCS6i69f2+buKbILLy9+fvJVtpM2eha8WEBrDxQFLqWP4NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758671410; c=relaxed/simple;
	bh=3TReChC6UqLrVCEazqygpmt1P3+KoM5T+eVB2X8OL7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=buBFjnzzKYbOJPlDZ382X5i5IcH+zxaDcFkW+yvoepaS9MpzJqsjp8zT4X5OMBmQkSn42IxOkbCbxaan6hadKUNHkh1VpmgHSxdrKxiql7jctYvLWBh4i73mFtjTbMAg/6tXuHLvjvjXU/IFnvrLXPO17z5A76Z5TeMhdFyXQVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gfgzvtfk; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gfgzvtfk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758671409; x=1790207409;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3TReChC6UqLrVCEazqygpmt1P3+KoM5T+eVB2X8OL7w=;
  b=gfgzvtfkvoCdrafDsoi9ORLSjutE4BE0zUEtJNdZKzQ2xQAGQraaay3a
   BfPo1d78yYvelvGFGOBl7aHyR1KCyJtBzpZFedMRj3EH10xwaE+jLjao2
   u7qQvUC2o9l7+x/s4hxhuc9KwoZ3ZJ3fqUswu0metDRM3VE2ai19SP4Yz
   jbeWYixpoSDB3Z/6DIe6xvoZpzAinjHPKC7IJyYsDQNyWZQ3TXZv4mMEG
   LMjbzOHo6Dhap6Bkk7hpAnTGUny8gdJArenzFFVzU+OxaxV9cRjs5/U3H
   ILakecom9zjSJhgaNMA4Z8BJ/XIN4vrzew90S1pSNgE2kTanRtYlE8FfB
   g==;
X-CSE-ConnectionGUID: MU5gys3aSgiMLkiDSq/Yng==
X-CSE-MsgGUID: 7dNXXyWDQsK6fCG3cHB3Fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60902277"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60902277"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 16:50:08 -0700
X-CSE-ConnectionGUID: WvnsVAy3QFa4AXMElD/HXg==
X-CSE-MsgGUID: gJZiUyBbR/+/AaBpg9FGwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="177280665"
Received: from kcaccard-desk.amr.corp.intel.com (HELO [10.125.108.197]) ([10.125.108.197])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 16:50:06 -0700
Message-ID: <e45d7687-fb93-4d2e-8cb4-e84c5a7ce782@intel.com>
Date: Tue, 23 Sep 2025 16:50:05 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134159epcas5p37716c48d36c07aaffe70dafca2fa207b@epcas5p3.samsung.com>
 <20250917134116.1623730-15-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-15-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
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
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/region.c | 127 ++++++++++++++++++++++++++++++++++++--
>  drivers/cxl/cxl.h         |  12 ++++
>  2 files changed, 134 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index c325aa827992..d5c227ce7b09 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2573,6 +2573,116 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>  	return ERR_PTR(rc);
>  }
>  
> +static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
> +{
> +	int rc;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
> +	if (rc)
> +		return rc;

Just a nit. Please conform to existing style in the subsystem for this new usage.

  +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
  +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem))))
  +		return rc;

> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	return alloc_hpa(cxlr, size);
> +}

I think you can create another helper free_region_hpa() and call them in size_store() function to remove the duplicate code.
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
> +			 enum cxl_partition_mode mode,

Wouldn't this not needed since it would be CXL_PARTMODE_PMEM always? I also wonder if we need to rename devm_cxl_add_region() to devm_cxl_add_ram_region() to be explicit.

> +			 enum cxl_decoder_type type,
> +			 struct cxl_pmem_region_params *params,
> +			 struct cxl_decoder *cxld)
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
> +	cxlr->mode = mode;
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
> +		return ERR_PTR(-EINVAL);

EOPNOTSUPP?

Speaking of which, are there plans to support interleave in the near future?

DJ

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
> @@ -2590,8 +2700,10 @@ static ssize_t create_ram_region_show(struct device *dev,
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
> @@ -2613,8 +2725,12 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> +	if (pmem_params)
> +		return devm_cxl_pmem_add_region(cxlrd, id, mode,
> +				CXL_DECODER_HOSTONLYMEM, pmem_params, cxld);
>  	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
>  }
> +EXPORT_SYMBOL_NS_GPL(cxl_create_region, "CXL");
>  
>  static ssize_t create_region_store(struct device *dev, const char *buf,
>  				   size_t len, enum cxl_partition_mode mode)
> @@ -2627,7 +2743,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
>  	if (rc != 1)
>  		return -EINVAL;
>  
> -	cxlr = __create_region(cxlrd, mode, id);
> +	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
>  	if (IS_ERR(cxlr))
>  		return PTR_ERR(cxlr);
>  
> @@ -3523,8 +3639,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
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
> index b57597e55f7e..3abadc3dc82e 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -874,6 +874,10 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
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
> @@ -899,6 +903,14 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>  static inline void cxl_region_discovery(struct cxl_port *port)
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
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);

