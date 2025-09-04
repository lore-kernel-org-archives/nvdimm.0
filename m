Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9F92D481D
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055790; cv=none; b=HPGfu61DLEyPnU3BuBF2N1bOQU+EXSNOEmvJ6IJ/vZa05ONp4uOZPVx6kROa6O0SDpwzarc7SlHO0BriqPF34WiE7aO41fV2+4DuDw/9BZ+FbJre6MQHHSWcapY2vPhepyeAeRRVmdWk+Js3RCtPf84cZG0QS8lgl+hTd8meZwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055790; c=relaxed/simple;
	bh=M6nuY/WcaCI3oh3Gzs0vDb936kps5Vh/NStz3zKwobU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=V6w/LbmuoIicnuHcN4GExnuNvd37uIxMucI7VMJzIhdxLLK1yqs8j2z/wU/2SPZPEuOPc1nPi8nafh2HmSX2BP0E5BlxmRRpK3R9HqEh6aFOMEhkVObDr30nEj83mFREl/6VMh5tboeVc5hZorEdCJsZF2ij9UyKuZGkWiKJaqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B/4N1nWd; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B/4N1nWd"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250905070305epoutp021add59a7a550613218056e3fa644b482~iUO1cjvsC0184801848epoutp024
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250905070305epoutp021add59a7a550613218056e3fa644b482~iUO1cjvsC0184801848epoutp024
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055785;
	bh=S49l/pXCpRHJzfcOGW9tRWJJWT7z47WyvFxIk0G8/Fk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B/4N1nWdUjTJfefD0jEqq/v3vaOKxPVIA0t4v76soz9XBIxu63BCKVfDMJRRg7UkK
	 Q7VI8txEafh53F+8Gl39C3wBew/M2dBGe5C6HKKiV08pmwWrp4woQK9vBBDE6EEGVG
	 +qKI6M30vbKEJy6ccGnR/8zMO4P7jLxm/xwaDVQ8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070304epcas5p370c98a3235bd4c0a577df78cff53c418~iUO1BApl-3104231042epcas5p3G;
	Fri,  5 Sep 2025 07:03:04 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cJ6kJ3htvz3hhTB; Fri,  5 Sep
	2025 07:03:04 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904145526epcas5p25642ef881f7c608a1d093e3e78d3f660~iHB_S_1sd0980409804epcas5p2u;
	Thu,  4 Sep 2025 14:55:26 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250904145525epsmtip16361a1be448841943f3927c9bc64768a~iHB9J03pi2016120161epsmtip1Z;
	Thu,  4 Sep 2025 14:55:25 +0000 (GMT)
Date: Thu, 4 Sep 2025 20:25:20 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 14/20] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Message-ID: <148912029.181757055784505.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <54012143-0925-4e76-a1e9-0092e10b8c84@intel.com>
X-CMS-MailID: 20250904145526epcas5p25642ef881f7c608a1d093e3e78d3f660
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea8fe_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121241epcas5p3e5708a89d764d1de9322fd759f921de0@epcas5p3.samsung.com>
	<20250730121209.303202-15-s.neeraj@samsung.com>
	<54012143-0925-4e76-a1e9-0092e10b8c84@intel.com>

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea8fe_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 05:30PM, Dave Jiang wrote:
>
>
>On 7/30/25 5:12 AM, Neeraj Kumar wrote:
>> devm_cxl_pmem_add_region() is used to create cxl region based on region
>> information scanned from LSA.
>>
>> devm_cxl_add_region() is used to just allocate cxlr and its fields are
>> filled later by userspace tool using device attributes (*_store()).
>>
>> Inspiration for devm_cxl_pmem_add_region() is taken from these device
>> attributes (_store*) calls. It allocates cxlr and fills information
>> parsed from LSA and calls device_add(&cxlr->dev) to initiate further
>> region creation porbes
>>
>> Renamed __create_region() to cxl_create_region() and make it an exported
>> routine. This will be used in later patch to create cxl region after
>> fetching region information from LSA.
>>
>> Also created some helper routines and refactored dpa_size_store(),
>> commit_store() to avoid duplicate code usage in devm_cxl_pmem_add_region()
>
>"Some helper routines are created to...."
>
>I would drop the "Also"

Sure Dave, I will drop it in next patch-set

>
>
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/core.h   |   1 +
>>  drivers/cxl/core/port.c   |  29 ++++++----
>>  drivers/cxl/core/region.c | 118 +++++++++++++++++++++++++++++++++-----
>>  drivers/cxl/cxl.h         |  12 ++++
>>  4 files changed, 134 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
>> index 2669f251d677..80c83e0117c6 100644
>> --- a/drivers/cxl/core/core.h
>> +++ b/drivers/cxl/core/core.h
>> @@ -94,6 +94,7 @@ int cxl_dpa_free(struct cxl_endpoint_decoder *cxled);
>>  resource_size_t cxl_dpa_size(struct cxl_endpoint_decoder *cxled);
>>  resource_size_t cxl_dpa_resource_start(struct cxl_endpoint_decoder *cxled);
>>  bool cxl_resource_contains_addr(const struct resource *res, const resource_size_t addr);
>> +ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size);
>>
>>  enum cxl_rcrb {
>>  	CXL_RCRB_DOWNSTREAM,
>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>> index 29197376b18e..ba743e31f721 100644
>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -243,16 +243,9 @@ static ssize_t dpa_size_show(struct device *dev, struct device_attribute *attr,
>>  	return sysfs_emit(buf, "%pa\n", &size);
>>  }
>>
>> -static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
>> -			      const char *buf, size_t len)
>> +ssize_t resize_or_free_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
>
>Maybe it should be called cxl_realloc_dpa()? More comments later on...

Sure Dave, I will rename it to cxl_realloc_dpa().

>
>>  {
>> -	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
>> -	unsigned long long size;
>> -	ssize_t rc;
>> -
>> -	rc = kstrtoull(buf, 0, &size);
>> -	if (rc)
>> -		return rc;
>> +	int rc;
>>
>>  	if (!IS_ALIGNED(size, SZ_256M))
>>  		return -EINVAL;
>> @@ -262,9 +255,23 @@ static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
>>  		return rc;
>>
>>  	if (size == 0)
>> -		return len;
>> +		return 0;
>> +
>> +	return cxl_dpa_alloc(cxled, size);
>> +}
>> +
>> +static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
>> +			      const char *buf, size_t len)
>> +{
>> +	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
>> +	unsigned long long size;
>> +	ssize_t rc;
>> +
>> +	rc = kstrtoull(buf, 0, &size);
>> +	if (rc)
>> +		return rc;
>>
>> -	rc = cxl_dpa_alloc(cxled, size);
>> +	rc = resize_or_free_dpa(cxled, size);
>>  	if (rc)
>>  		return rc;
>>
>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>> index eef501f3384c..8578e046aa78 100644
>> --- a/drivers/cxl/core/region.c
>> +++ b/drivers/cxl/core/region.c
>> @@ -703,6 +703,23 @@ static int free_hpa(struct cxl_region *cxlr)
>>  	return 0;
>>  }
>>
>> +static ssize_t resize_or_free_region_hpa(struct cxl_region *cxlr, u64 size)
>> +{
>> +	int rc;
>> +
>> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
>> +	if (rc)
>> +		return rc;
>> +
>> +	if (size)
>> +		rc = alloc_hpa(cxlr, size);
>> +	else
>> +		rc = free_hpa(cxlr);
>> +
>> +	return rc;
>> +}
>
>I think it's better to have 2 helper functions rather a single ambiguous one here. alloc_region_hpa() and free_region_hpa(). More on why later.

Sure, I will handle it accordingly.

>
>> +
>>  static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>>  			  const char *buf, size_t len)
>>  {
>> @@ -714,15 +731,7 @@ static ssize_t size_store(struct device *dev, struct device_attribute *attr,
>>  	if (rc)
>>  		return rc;
>>
>> -	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
>> -	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
>> -		return rc;
>> -
>> -	if (val)
>> -		rc = alloc_hpa(cxlr, val);
>> -	else
>> -		rc = free_hpa(cxlr);
>> -
>> +	rc = resize_or_free_region_hpa(cxlr, val);
>>  	if (rc)
>>  		return rc;
>>
>> @@ -2569,6 +2578,76 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
>>  	return ERR_PTR(rc);
>>  }
>>
>> +static struct cxl_region *
>> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
>> +			 int id,
>> +			 enum cxl_partition_mode mode,
>> +			 enum cxl_decoder_type type,
>> +			 struct cxl_pmem_region_params *params,
>> +			 struct cxl_decoder *cxld)
>> +{
>> +	struct cxl_port *root_port;
>> +	struct cxl_region *cxlr;
>> +	struct cxl_endpoint_decoder *cxled;
>> +	struct cxl_region_params *p;
>> +	struct device *dev;
>> +	int rc;
>> +
>> +	cxlr = cxl_region_alloc(cxlrd, id);
>I think you can use __free() here to drop all the gotos.
>
>struct cxl_region *cxlr __free(put_cxl_region) = cxl_region_alloc(cxlrd, id);
>
>Just make sure to 'return no_free_ptr(cxlr)' at the successful end.

Sure Dave, Thanks for your suggestion. I will handle it accordingly in
next patch-set.

>
>
>> +	if (IS_ERR(cxlr))
>> +		return cxlr;
>> +	cxlr->mode = mode;
>> +	cxlr->type = type;
>> +
>> +	dev = &cxlr->dev;
>> +	rc = dev_set_name(dev, "region%d", id);
>> +	if (rc)
>> +		goto err;
>> +
>> +	p = &cxlr->params;
>> +	p->uuid = params->uuid;
>> +	p->interleave_ways = params->nlabel;
>> +	p->interleave_granularity = params->ig;
>> +
>> +	if (resize_or_free_region_hpa(cxlr, params->rawsize))
>> +		goto err;
>
>Given this is _add_region(), it really should only be calling alloc_region_hpa() and not have to deal with free. Maybe a check before this and make sure params->rawsize is not 0 is needed.

Sure, Let me re-look at it.

>
>> +
>> +	cxled = to_cxl_endpoint_decoder(&cxld->dev);
>> +	if (resize_or_free_dpa(cxled, 0))
>Given that resize_or_free_dpa() always frees, is this call necessary here?

Yes, Its required here as in first call to resize_or_free_dpa(), we are
just freeing dpa and returning as its size is 0. But anyway, Let me
double check it here.

>
>> +		goto err;
>> +
>> +	if (cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM))
>> +		goto err;
>> +
>> +	if (resize_or_free_dpa(cxled, params->rawsize))
>
>Seems like it can be called once here instead and it'll just free and then re-allocate whatever size in params->rawsize.

Sure, I will re-look at it

>
>> +		goto err;
>> +
>> +	/* Attaching only one target due to interleave_way == 1 */
>Is it missing a check of interleave_ways here? Also maybe additional comments on why support iw==1 only?

Sure, I will look at this and update the comments properly.

>
>> +	if (attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE))
>> +		goto err;
>> +
>> +	if (__commit(cxlr))
>> +		goto err;
>> +
>> +	rc = device_add(dev);
>> +	if (rc)
>> +		goto err;
>> +
>> +	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
>> +	rc = devm_add_action_or_reset(root_port->uport_dev,
>> +			unregister_region, cxlr);
>> +	if (rc)
>> +		return ERR_PTR(rc);
>> +
>> +	dev_dbg(root_port->uport_dev, "%s: created %s\n",
>> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
>> +	return cxlr;
>> +
>> +err:
>> +	put_device(dev);
>> +	return ERR_PTR(rc);
>> +}
>> +
>>  static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
>>  {
>>  	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
>> @@ -2586,8 +2665,10 @@ static ssize_t create_ram_region_show(struct device *dev,
>>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>>  }
>>
>> -static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>> -					  enum cxl_partition_mode mode, int id)
>> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>> +				     enum cxl_partition_mode mode, int id,
>> +				     struct cxl_pmem_region_params *params,
>
>Maybe name it pmem_params to avoid confusion with cxl region params.
>
>> +				     struct cxl_decoder *cxld)
>>  {
>>  	int rc;
>>
>> @@ -2609,8 +2690,14 @@ static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>>  		return ERR_PTR(-EBUSY);
>>  	}
>>
>> -	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
>> +	if (params)
>> +		return devm_cxl_pmem_add_region(cxlrd, id, mode,
>> +				CXL_DECODER_HOSTONLYMEM, params, cxld);
>> +	else
>
>'else' not needed here. Just directly return.

Thanks Dave, I will fix it in next patch-set.

>
>> +		return devm_cxl_add_region(cxlrd, id, mode,
>> +				CXL_DECODER_HOSTONLYMEM);
>>  }
>> +EXPORT_SYMBOL_NS_GPL(cxl_create_region, "CXL");
>>
>>  static ssize_t create_region_store(struct device *dev, const char *buf,
>>  				   size_t len, enum cxl_partition_mode mode)
>> @@ -2623,7 +2710,7 @@ static ssize_t create_region_store(struct device *dev, const char *buf,
>>  	if (rc != 1)
>>  		return -EINVAL;
>>
>> -	cxlr = __create_region(cxlrd, mode, id);
>> +	cxlr = cxl_create_region(cxlrd, mode, id, NULL, NULL);
>>  	if (IS_ERR(cxlr))
>>  		return PTR_ERR(cxlr);
>>
>> @@ -3414,8 +3501,9 @@ static struct cxl_region *construct_region(struct cxl_root_decoder *cxlrd,
>>  	struct cxl_region *cxlr;
>>
>>  	do {
>> -		cxlr = __create_region(cxlrd, cxlds->part[part].mode,
>> -				       atomic_read(&cxlrd->region_id));
>> +		cxlr = cxl_create_region(cxlrd, cxlds->part[part].mode,
>> +					 atomic_read(&cxlrd->region_id),
>> +					 NULL, NULL);
>>  	} while (IS_ERR(cxlr) && PTR_ERR(cxlr) == -EBUSY);
>>
>>  	if (IS_ERR(cxlr)) {
>> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
>> index 6edcec95e9ba..129db2e49aa7 100644
>> --- a/drivers/cxl/cxl.h
>> +++ b/drivers/cxl/cxl.h
>> @@ -865,6 +865,10 @@ int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
>>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
>>  u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
>>  void cxl_region_discovery(struct cxl_port *port);
>> +struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
>> +				     enum cxl_partition_mode mode, int id,
>> +				     struct cxl_pmem_region_params *params,
>> +				     struct cxl_decoder *cxld);
>>  #else
>>  static inline bool is_cxl_pmem_region(struct device *dev)
>>  {
>> @@ -890,6 +894,14 @@ static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
>>  static inline void cxl_region_discovery(struct cxl_port *port)
>>  {
>>  }
>> +static inline struct cxl_region *
>> +cxl_create_region(struct cxl_root_decoder *cxlrd,
>> +		  enum cxl_partition_mode mode, int id,
>> +		  struct cxl_pmem_region_params *params,
>> +		  struct cxl_decoder *cxld)
>> +{
>> +	return NULL;
>
>return ERR_PTR(-EOPNOTSUPP);

Sure Dave, I will fix it


Regards,
Neeraj

------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea8fe_
Content-Type: text/plain; charset="utf-8"


------kMDsK0IEhKoUUkzyxABlnve5J-Otg2bCPR2yRM97vA1oUAWq=_ea8fe_--

