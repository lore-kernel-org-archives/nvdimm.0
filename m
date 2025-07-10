Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1667A276049
	for <nvdimm@lists.linux.dev>; Thu, 10 Jul 2025 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163161; cv=none; b=UQLgvFe3jCKSzuNLcLky3QDf/6iZnFlZ05TejyzvMI1wq1CPQPS+OCIPf85k6DhAM1ZLuDF/3GnOTQIGAeGHWMxl2ODyB+x8ykMY4tjxz0AQACMzaKgkhudMEiAiDs1Zm2xMsGJISj5qRw7g+3IBVJlIaDPcCMYpUJ61NwGvH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163161; c=relaxed/simple;
	bh=bwVzv/j/qkUeRBNJ68ryYxQQl4TurY9s7hpGOGVG1gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTppePpDrIoovdU9JmBqFx9xAyxJkj3DUVJmsCSsI32/JVMyG3sdUdlqS4AWHGXQelCvQrrXwPaSa7eF6WjSAIgV5BRgsb7J6VaXkRvvdGA4S7nE5r79AuTvk1YIEpNn3BICiI+aet+K6YFivuMocVA1GgUoX1jTCLffQ4la2D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNhNyc5d; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNhNyc5d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752163160; x=1783699160;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bwVzv/j/qkUeRBNJ68ryYxQQl4TurY9s7hpGOGVG1gY=;
  b=JNhNyc5dt0Xwfpa6X1EVph6zFufDlDnmLZog703HsloRTzWjsVYQv3Gi
   G5OW68Z5+35AIrxnfpV6VIADoNl9wvEUAPTFA8LmITG0DmvPV2h0RpmHT
   OtXNvS5/1oxKIifMjrvaB5rPF1+8gEfzFN96M0oCbj2qpJK2TcLZfBHd9
   Ajyz/EJp8awtr+k1lNnB30xoeYP9vT6+fz1CKhu72qAuPpEB8gYLTaCb9
   Vo/4faVUoS538lEsxQP3kN41jPyl4KCKnUIqvvKVx5QOxEF09b7Tdy8oj
   JeoMY1ALQXx6lUn5Dcfng8BBQ2kdKD8K+NWZ8U9OFXkmJx/k39xKj2rEp
   w==;
X-CSE-ConnectionGUID: tJeiXE1rSIqyxTL9LTcDgg==
X-CSE-MsgGUID: tENvF7UlQWy0z97vw2He4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54604005"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="54604005"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 08:59:18 -0700
X-CSE-ConnectionGUID: B4RwQo3HTJ2wkEFvA92x2Q==
X-CSE-MsgGUID: cwLLBVawRfWpriuHpHWrLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="156692416"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.110.242]) ([10.125.110.242])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 08:59:17 -0700
Message-ID: <fdc06026-c681-4dae-9202-ad89293931a5@intel.com>
Date: Thu, 10 Jul 2025 08:59:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 14/20] cxl/region: Add cxl pmem region creation
 routine for region persistency
To: Neeraj Kumar <s.neeraj@samsung.com>, dan.j.williams@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124046epcas5p16a45d2afe3b41ca08994a5cca09bfb68@epcas5p1.samsung.com>
 <1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1691538257.61750165382463.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/17/25 5:39 AM, Neeraj Kumar wrote:
> Added exported cxl_create_pmem_region routine to create cxl pmem region
> from LSA parsed cxl region information.
> Inspirition for the function is taken from ndctl device attribute
> (_store) call. It allocates cxlr and fills information parsed from LSA
> and calls device_add(&cxlr->dev) to initiates further region creation
> porbes
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c   |   6 ++
>  drivers/cxl/core/region.c | 208 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h         |  11 ++
>  3 files changed, 225 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index bca668193c49..2452f7c15b2d 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -2150,6 +2150,12 @@ void cxl_bus_drain(void)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_bus_drain, "CXL");
>  
> +void cxl_wq_flush(void)
> +{
> +	flush_workqueue(cxl_bus_wq);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_wq_flush, "CXL");
> +
>  bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
>  {
>  	return queue_work(cxl_bus_wq, &cxlmd->detach_work);
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index b98b1ccffd1c..8990e3c3474d 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2522,6 +2522,214 @@ static ssize_t create_ram_region_show(struct device *dev,
>  	return __create_region_show(to_cxl_root_decoder(dev), buf);
>  }
>  
> +static ssize_t update_region_size(struct cxl_region *cxlr, u64 val)

Maybe call it resize_or_free_region_hpa()?

Also rename 'val' to 'size'

> +{
> +	int rc;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +
> +	if (val)
> +		rc = alloc_hpa(cxlr, val);
> +	else
> +		rc = free_hpa(cxlr);
> +	up_write(&cxl_region_rwsem);
> +
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}

Share common code with core/region.c:size_store(). Please use helper function and not duplicate code.

> +
> +static ssize_t update_region_dpa_size(struct cxl_region *cxlr,

resize_or_free_dpa()

> +		struct cxl_decoder *cxld,
> +		unsigned long long size)

u64 size

> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	if (!IS_ALIGNED(size, SZ_256M))
> +		return -EINVAL;
> +
> +	rc = cxl_dpa_free(cxled);
> +	if (rc)
> +		return rc;
> +
> +	if (size == 0)
> +		return 0;
> +
> +	rc = cxl_dpa_alloc(cxled, size);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}

Share common code with core/port.c:dpa_size_store(). Please use helper function and not duplicate code.

> +
> +static ssize_t update_region_dpa_mode(struct cxl_region *cxlr,
> +		struct cxl_decoder *cxld)
> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	rc = cxl_dpa_set_mode(cxled, CXL_DECODER_PMEM);

Don't think CXL_DECODER_PMEM exists any longer. It's CXL_PARTMODE_PMEM. Just beware there have been some changes while you are rebasing to the latest upstream code.

> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static size_t attach_region_target(struct cxl_region *cxlr,
> +		struct cxl_decoder *cxld, int pos)
> +{
> +	int rc;
> +	struct cxl_endpoint_decoder *cxled =
> +		to_cxl_endpoint_decoder(&cxld->dev);
> +
> +	rc = attach_target(cxlr, cxled, pos, TASK_INTERRUPTIBLE);
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static ssize_t commit_region(struct cxl_region *cxlr)
> +{
> +	struct cxl_region_params *p = &cxlr->params;
> +	ssize_t rc;
> +
> +	rc = down_write_killable(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +
> +	/* Already in the requested state? */
> +	if (p->state >= CXL_CONFIG_COMMIT)
> +		goto out;
> +
> +	/* Not ready to commit? */
> +	if (p->state < CXL_CONFIG_ACTIVE) {
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Invalidate caches before region setup to drop any speculative
> +	 * consumption of this address space
> +	 */
> +	rc = cxl_region_invalidate_memregion(cxlr);
> +	if (rc)
> +		goto out;
> +
> +	rc = cxl_region_decode_commit(cxlr);
> +	if (rc == 0)
> +		p->state = CXL_CONFIG_COMMIT;
> +out:
> +	up_write(&cxl_region_rwsem);
> +	if (rc)
> +		return rc;
> +	return 0;
> +}

Sharing common code with core/region.c:commit_store()?

> +
> +static struct cxl_region *
> +devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id,
> +		enum cxl_decoder_mode mode, enum cxl_decoder_type type)
> +{
> +	struct cxl_port *port;
> +	struct cxl_region *cxlr;
> +	struct cxl_region_params *p;
> +	struct device *dev;
> +	int rc;
> +
> +	if (!cxlrd)
> +		return ERR_PTR(-EINVAL);
> +
> +	port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
> +
> +	cxlr = cxl_region_alloc(cxlrd, id);
> +	if (IS_ERR(cxlr))
> +		return cxlr;
> +	cxlr->mode = mode;
> +	cxlr->type = type;
> +
> +	dev = &cxlr->dev;
> +	rc = dev_set_name(dev, "region%d", id);
> +	if (rc)
> +		goto err;
> +> +	p = &cxlr->params;
> +	p->uuid = params->uuid;
> +	p->interleave_ways = params->nlabel;
> +	p->interleave_granularity = params->ig;
> +
> +	/* Update region size */
Not sure what value this comment adds
> +	if (update_region_size(cxlr, params->rawsize))
> +		goto err;
> +
> +	/* Flush cxl wq */
Can you explain here why a flush is needed?
> +	cxl_wq_flush();
> +
> +	/* Clear DPA Size */
comment provides no value
> +	if (update_region_dpa_size(cxlr, cxld, 0))
> +		goto err;
> +
> +	/* Update DPA mode */
same as above
> +	if (update_region_dpa_mode(cxlr, cxld))
> +		goto err;
> +
> +	/* Update DPA Size */
same as above
> +	if (update_region_dpa_size(cxlr, cxld, params->rawsize))
> +		goto err;
> +
> +	/* Attach region targets */
same as above
> +	if (attach_region_target(cxlr, cxld, params->position))
> +		goto err;
> +
> +	/* Commit Region */
same as above
> +	if (commit_region(cxlr))
> +		goto err;

Can you please provide some verbose explanation as to what all these extra steps are doing for pmem versus devm_cxl_add_region() for dram?

> +
> +	rc = device_add(dev);
> +	if (rc)
> +		goto err;
> +
> +	rc = devm_add_action_or_reset(port->uport_dev, unregister_region, cxlr);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	dev_dbg(port->uport_dev, "%s: created %s\n",
> +		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(dev));
> +	return cxlr;
> +
> +err:
> +	put_device(dev);
> +	return ERR_PTR(rc);
> +}
> +
> +struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id)
> +{
> +	int rc;
> +
> +	rc = memregion_alloc(GFP_KERNEL);
> +	if (rc < 0)
> +		return ERR_PTR(rc);
> +
> +	if (atomic_cmpxchg(&cxlrd->region_id, id, rc) != id) {
> +		memregion_free(rc);
> +		return ERR_PTR(-EBUSY);
> +	}
> +
> +	return devm_cxl_pmem_add_region(cxlrd, cxld, params, id,
> +			CXL_DECODER_PMEM, CXL_DECODER_HOSTONLYMEM);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_create_pmem_region, "CXL");

Can __create_region() be modified to determine whether to create dram region or pmem?

DJ
> +
>  static struct cxl_region *__create_region(struct cxl_root_decoder *cxlrd,
>  					  enum cxl_decoder_mode mode, int id)
>  {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 9423ea3509ad..30c80e04cb27 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -759,6 +759,7 @@ DEFINE_FREE(put_cxl_port, struct cxl_port *, if (!IS_ERR_OR_NULL(_T)) put_device
>  int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd);
>  void cxl_bus_rescan(void);
>  void cxl_bus_drain(void);
> +void cxl_wq_flush(void);
>  struct cxl_port *cxl_pci_find_port(struct pci_dev *pdev,
>  				   struct cxl_dport **dport);
>  struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
> @@ -877,6 +878,9 @@ struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
>  int cxl_add_to_region(struct cxl_port *root,
>  		      struct cxl_endpoint_decoder *cxled);
>  struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
> +struct cxl_region *cxl_create_pmem_region(struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id);
>  #else
>  static inline bool is_cxl_pmem_region(struct device *dev)
>  {
> @@ -895,6 +899,13 @@ static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
>  {
>  	return NULL;
>  }
> +static inline struct cxl_region *cxl_create_pmem_region(
> +		struct cxl_root_decoder *cxlrd,
> +		struct cxl_decoder *cxld,
> +		struct cxl_pmem_region_params *params, int id)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  void cxl_endpoint_parse_cdat(struct cxl_port *port);

