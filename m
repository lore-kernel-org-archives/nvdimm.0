Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863B827A916
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410022; cv=none; b=sVHaF7hnCvlbZZXfRO0G+FMmECDJtKaOPLxRZ7epMBI3YBIYmRhW0CzpRTLBwr114T5vk265rKXkpNmnnoc0uqnBVjW4HWbmVWFZkt5+ql1Jt7YRZLe8mRCKsyE8QKXQJT6DDbW4qFCthffmAbs7z4Mnc885635CfEgwCDjhQ6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410022; c=relaxed/simple;
	bh=vTR2WjDJvhe+7h1j1hjb/aW0zWgYQj2nYJiAwGoxxJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4MJtFBqmyYt9JyHniKdrQmCoNm9rnluyN+tX1T0WzJFU9YCTCqlbrK149lr6ffLvhPCdBPzUGjiGrXZL3tCPPyNmxNDLONIyduR09M70CD0kPfuD5iUyPsIGbyc0Xg3vpKKhuY5UjeLOfNz829Y8nyOzoU41XhmHaaY2AbU+9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X4M4L6VQ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4M4L6VQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768410020; x=1799946020;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vTR2WjDJvhe+7h1j1hjb/aW0zWgYQj2nYJiAwGoxxJQ=;
  b=X4M4L6VQ7e8FmPHZtqZxJX1NzkDGaP2HHJutpMzdRhTHR+j5iRpHH8o/
   h9FOJlu2i2sQt0HU7xBmzzlrNd0dL6aoXeaFxniO/R2bcaEcpHJHoJWn9
   xolsB/OcI6fYQ5pcAAh3WKegiyrlx/pXsdeVSmxSwQeuBUdgpqm4A7wWF
   OJ9CJD0OOPJTG59X70LOO7zphuZrwIDSlFzgnmEmj9pJqGWP5CQdZJOve
   UkEUoRtEQ66bcSj9NCwDRWtsvdmM+eqfZSsE5mkeYq+A7052qUDUloemk
   r4HOgF8bT5eJWNitOa31EGpQ2dcsMwK6T2TCioYUuGziZ5iB7YEV39WY1
   Q==;
X-CSE-ConnectionGUID: 5qNxo92UTQWdWZ80CsuSgg==
X-CSE-MsgGUID: yFGJ819ORkaNtlGZfTrZGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="73565605"
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="73565605"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 09:00:20 -0800
X-CSE-ConnectionGUID: PgOX7idHTDWwc7ZojVrV9g==
X-CSE-MsgGUID: VgOf81JcSxW9vnd9u7YQew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,225,1763452800"; 
   d="scan'208";a="205000287"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.111.5]) ([10.125.111.5])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 09:00:19 -0800
Message-ID: <c47b0eda-b3fe-442d-be11-f9fa02400915@intel.com>
Date: Wed, 14 Jan 2026 10:00:18 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 15/17] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
 <CGME20260109124531epcas5p118e7306860bcd57a0106948375df5c9c@epcas5p1.samsung.com>
 <20260109124437.4025893-16-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260109124437.4025893-16-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 5:44 AM, Neeraj Kumar wrote:
> Using these attributes region label is added/deleted into LSA. These
> attributes are called from userspace (ndctl) after region creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

You'll need to update the KernelVersion to v7.0.

> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 22 +++++++
>  drivers/cxl/core/pmem_region.c          | 88 +++++++++++++++++++++++++
>  drivers/cxl/cxl.h                       |  7 ++
>  3 files changed, 117 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index c80a1b5a03db..011a5e8d354f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -624,3 +624,25 @@ Description:
>  		The count is persistent across power loss and wraps back to 0
>  		upon overflow. If this file is not present, the device does not
>  		have the necessary support for dirty tracking.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
> +Date:		Jan, 2026
> +KernelVersion:	v6.19
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RW) Write a boolean 'true' string value to this attribute to
> +		update cxl region information into LSA as region label. It is
> +		used to update cxl region information saved during cxl region
> +		creation into LSA. This attribute must be written last during
> +		cxl region creation. Reading this attribute indicates whether
> +		the region label is active or not.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_delete
> +Date:		Jan, 2026
> +KernelVersion:	v6.19
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(WO) When a boolean 'true' is written to this attribute then
> +		pmem_region driver deletes cxl region label from LSA.
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index dcaab59108fd..53d3d81e9676 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -29,8 +29,96 @@ static void cxl_pmem_region_release(struct device *dev)
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
> +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
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
> +	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
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
> +	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
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
> +	&cxl_pmem_region_group,
>  	NULL
>  };
>  
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

