Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0B731ED7A
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763593807; cv=none; b=Q42OWYhWjELLXzBfUQ0gCYIIT4nSxISTiujrEZdkLjY/tn4Ud61ckyLs31xQzmLsJmIaR8CWenP2yK/PLEM2SeLDw3HZVpGwSrmQsJm9WMuA2EA4BdnfszoTuP5pmWaFfvcdL1XPV2crpOjqLgNQiUiITvNgYnTKNTU+nVHW8u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763593807; c=relaxed/simple;
	bh=kgMALFHk+IRSBzZvhDfLO/vKbguY/PUkLVucfV3S/HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SqZ1c+GYWGY7PUV4/b0wKZRXXTOJzaPGeZ/b50cmZQnDiiPHCGky15cNm9Q4E/3seiXJTxipiGlBOtDESJKYBk5oy7Pc0MP25bN4KUeKYfwmVAXMapcHOXs1J++svlUfl911IGybGabpyp0QxN/y8ta4eq4I1aDk6n97NpNBKs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y3ycykFv; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y3ycykFv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763593806; x=1795129806;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kgMALFHk+IRSBzZvhDfLO/vKbguY/PUkLVucfV3S/HU=;
  b=Y3ycykFviJ9Q7JzrHQJ94P5Y+qePuybZZpfRInaHIo/bQe1gzShkolot
   4HGd4jU0MwiIthXgJWal0DwsN992k9Xk00+7c89JcvMIfm2rltJVjhzX8
   mVc/8aLNNtXKxjT2de6dkgnniAyJSQcCKN35vTv9yCx0Xa81i56j0kIru
   1KjLXqwpcBnNNolzphiCOuNLWW9wjvKcP1RpULlQrXdSKPWBamTaDYuQD
   7EQZ16CPA4L7xaQZDbzO/ESM5n5wET6ENbyNOuTD2023mykQwRzxl4CNi
   w41ZBPrpyT7206sG/v2uhP1dhyR/dySXmts7PYUUJS8hF7kMpJIy96Z4R
   g==;
X-CSE-ConnectionGUID: /FuNlBukRBqrSKdsnqcaZg==
X-CSE-MsgGUID: /iI2bO5QTZCEjuy59mQ84A==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="68257088"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="68257088"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:10:05 -0800
X-CSE-ConnectionGUID: KpdR/nONSzOuRkjJ6k0+7w==
X-CSE-MsgGUID: smT+Qu26QuiKvoJt+32NHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="195499350"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 15:10:05 -0800
Message-ID: <ba6d7e3e-493c-43f4-9ae6-373dbe7f4f0f@intel.com>
Date: Wed, 19 Nov 2025 16:10:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 15/17] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075337epcas5p2cb576137ca33d6304add4e1ba0b2bdc1@epcas5p2.samsung.com>
 <20251119075255.2637388-16-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-16-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> Using these attributes region label is added/deleted into LSA. These
> attributes are called from userspace (ndctl) after region creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++
>  drivers/cxl/core/pmem_region.c          | 93 ++++++++++++++++++++++++-
>  drivers/cxl/cxl.h                       |  7 ++
>  3 files changed, 121 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index c80a1b5a03db..76d79c03dde4 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -624,3 +624,25 @@ Description:
>  		The count is persistent across power loss and wraps back to 0
>  		upon overflow. If this file is not present, the device does not
>  		have the necessary support for dirty tracking.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
> +Date:		Nov, 2025
> +KernelVersion:	v6.19
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RW) Write a boolean 'true' string value to this attribute to
> +		update cxl region information into LSA as region label. It
> +		uses nvdimm nd_region_label_update() to update cxl region
> +		information saved during cxl region creation into LSA. This
> +		attribute must be called at last during cxl region creation.

Please consider:
attribute must be written last during cxl region creation.

No need to mention kernel specifics like function names. Just give general description of what the attribute does. Same for the next attribute below.

Also, does this attribute needs to be readable? The documentation above does not explain the read attribute if so.

DJ

> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_delete
> +Date:		Nov, 2025
> +KernelVersion:	v6.19
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(WO) When a boolean 'true' is written to this attribute then
> +		pmem_region driver deletes cxl region label from LSA using
> +		nvdimm nd_region_label_delete()
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index b45e60f04ff4..be4feb73aafc 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -30,9 +30,100 @@ static void cxl_pmem_region_release(struct device *dev)
>  	kfree(cxlr_pmem);
>  }
>  
> +static ssize_t region_label_update_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t len)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	ssize_t rc;
> +	bool update;
> +
> +	rc = kstrtobool(buf, &update);
> +	if (rc)
> +		return rc;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
> +	if (rc)
> +		return rc;
> +
> +	/* Region not yet committed */
> +	if (update && cxlr && cxlr->params.state != CXL_CONFIG_COMMIT) {
> +		dev_dbg(dev, "region not committed, can't update into LSA\n");
> +		return -ENXIO;
> +	}
> +
> +	if (!cxlr || !cxlr->cxlr_pmem || !cxlr->cxlr_pmem->nd_region)
> +		return 0;
> +
> +	rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
> +	if (rc)
> +		return rc;
> +
> +	cxlr->params.state_region_label = CXL_REGION_LABEL_ACTIVE;
> +
> +	return len;
> +}
> +
> +static ssize_t region_label_update_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	struct cxl_region_params *p = &cxlr->params;
> +	ssize_t rc;
> +
> +	ACQUIRE(rwsem_read_intr, rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem);
> +	if (rc)
> +		return rc;
> +
> +	return sysfs_emit(buf, "%d\n", p->state_region_label);
> +}
> +static DEVICE_ATTR_RW(region_label_update);
> +
> +static ssize_t region_label_delete_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t len)
> +{
> +	struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
> +	struct cxl_region *cxlr = cxlr_pmem->cxlr;
> +	ssize_t rc;
> +
> +	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
> +	rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
> +	if (rc)
> +		return rc;
> +
> +	if (!cxlr && !cxlr->cxlr_pmem && !cxlr->cxlr_pmem->nd_region)
> +		return 0;
> +
> +	rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
> +	if (rc)
> +		return rc;
> +
> +	cxlr->params.state_region_label = CXL_REGION_LABEL_INACTIVE;
> +
> +	return len;
> +}
> +static DEVICE_ATTR_WO(region_label_delete);
> +
> +static struct attribute *cxl_pmem_region_attrs[] = {
> +	&dev_attr_region_label_update.attr,
> +	&dev_attr_region_label_delete.attr,
> +	NULL
> +};
> +
> +static struct attribute_group cxl_pmem_region_group = {
> +	.attrs = cxl_pmem_region_attrs,
> +};
> +
>  static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
>  	&cxl_base_attribute_group,
> -	NULL,
> +	&cxl_pmem_region_group,
> +	NULL
>  };
>  
>  const struct device_type cxl_pmem_region_type = {
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 6ac3b40cb5ff..8c76c4a981bf 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -473,9 +473,15 @@ enum cxl_config_state {
>  	CXL_CONFIG_COMMIT,
>  };
>  
> +enum region_label_state {
> +	CXL_REGION_LABEL_INACTIVE,
> +	CXL_REGION_LABEL_ACTIVE,
> +};
> +
>  /**
>   * struct cxl_region_params - region settings
>   * @state: allow the driver to lockdown further parameter changes
> + * @state: region label state
>   * @uuid: unique id for persistent regions
>   * @interleave_ways: number of endpoints in the region
>   * @interleave_granularity: capacity each endpoint contributes to a stripe
> @@ -488,6 +494,7 @@ enum cxl_config_state {
>   */
>  struct cxl_region_params {
>  	enum cxl_config_state state;
> +	enum region_label_state state_region_label;
>  	uuid_t uuid;
>  	int interleave_ways;
>  	int interleave_granularity;

