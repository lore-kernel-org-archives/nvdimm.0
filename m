Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E0232897A
	for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 20:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745547; cv=none; b=fnrMEzf+2eoFgqILl3WGMgK2XFcAZ5m5GmBDX6h054/MOMiTf3KYbFQgvksgdguWLqKXJv1BfrD5uFLaLyLysB23FWhJL6t5ENagHbgNyiLCe6Y8wyzIQKaEbwlsmSTI630ngVoZ5PcPlUAIhznGtfQpHuAXT5RcpxsSHszKnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745547; c=relaxed/simple;
	bh=zw3x76AQ/vgPk9kgFqedMjqFTF9PAcJEulNJ//NEyQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t77SqEe60THnvSPiiEL3TnTVmMXFxssFJj1MSMALojrmadjwUXMQTPWbLk1feq9ZtOd2a8RSC6Fs1UL43a8467JazVdCDVGLYuH+XmYYlQoIYyh7+zOy3SVP0F9xRtH+z7pCjXO1gOWQgyYVmek3+rfwhf9OJ0mj5UTSIh1MdNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IZpHMA5R; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IZpHMA5R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758745545; x=1790281545;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zw3x76AQ/vgPk9kgFqedMjqFTF9PAcJEulNJ//NEyQg=;
  b=IZpHMA5RStF0YaLLlvJNHE0ITwpeinzAVfKoNkAs3mx6SewMI5GX6DK0
   zfEhyANaG3yeUDMDdLHdL+x37Kb3TviiDvWXil88z3wbeaQ4YNn9thRHs
   HrPv/ilnUX1DHscs5dnp47QW13gs5Lzgr4DxgtpXhPDe+xstejoh+TlRa
   u3mMHi6Yq5ywUWZ+bm6tjb6pVMKvlSYaKgG/lLY4y5txW6PTtSOB7usL7
   AafSCI6L8CmQNrjxgtjosyxZWWRdej/Xb2NZkEALS9oyCBKvqI9ke+9IW
   oWirYyp0FaTWfFaZLd1+kv5/4H1BPa6v6bLIGGu3u4Mr1t/9VLu7GLXEt
   Q==;
X-CSE-ConnectionGUID: CI4NUEi1T7eMIKVKToi5MA==
X-CSE-MsgGUID: H5eWNC9MQ1iI9n+VSqAbMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11563"; a="78492767"
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="78492767"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:25:44 -0700
X-CSE-ConnectionGUID: g+4KIF0eRtSTxWYdplrqyg==
X-CSE-MsgGUID: aEyEW8p+SYmnW2q92zLTsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,291,1751266800"; 
   d="scan'208";a="181512197"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.218]) ([10.125.108.218])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 13:25:43 -0700
Message-ID: <6734182c-579e-439c-906c-f3c053025ef0@intel.com>
Date: Wed, 24 Sep 2025 13:25:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 19/20] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134211epcas5p17cf5e4052df126a67b27be971be82fe1@epcas5p1.samsung.com>
 <20250917134116.1623730-20-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-20-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> Using these attributes region label is added/deleted into LSA. These
> attributes are called from userspace (ndctl) after region creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 22 ++++++
>  drivers/cxl/core/pmem_region.c          | 91 ++++++++++++++++++++++++-
>  drivers/cxl/cxl.h                       |  1 +
>  3 files changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 6b4e8c7a963d..d6080fcf843a 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -615,3 +615,25 @@ Description:
>  		The count is persistent across power loss and wraps back to 0
>  		upon overflow. If this file is not present, the device does not
>  		have the necessary support for dirty tracking.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_update
> +Date:		Sept, 2025
> +KernelVersion:	v6.17
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RW) Write a boolean 'true' string value to this attribute to
> +		update cxl region information into LSA as region label. It
> +		uses nvdimm nd_region_label_update() to update cxl region
> +		information saved during cxl region creation into LSA. This
> +		attribute must be called at last during cxl region creation.
> +
> +
> +What:		/sys/bus/cxl/devices/regionZ/pmem_regionZ/region_label_delete
> +Date:		Sept, 2025
> +KernelVersion:	v6.17
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(WO) When a boolean 'true' is written to this attribute then
> +		pmem_region driver deletes cxl region label from LSA using
> +		nvdimm nd_region_label_delete()
> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
> index 55b80d587403..665b603c907b 100644
> --- a/drivers/cxl/core/pmem_region.c
> +++ b/drivers/cxl/core/pmem_region.c
> @@ -45,9 +45,98 @@ static void cxl_pmem_region_release(struct device *dev)
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
> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
> +		rc = nd_region_label_update(cxlr->cxlr_pmem->nd_region);
> +		if (!rc)
> +			cxlr->params.region_label_state = 1;
> +	}
> +
> +	if (rc)
> +		return rc;

Feels like this segment should look like

if (!cxlr || !cxlr->cxlr_pmem || ! cxlr->cxlr_pmem->nd_region)
	return 0;

rc = nd_region_label_update(..);
if (rc)
	return rc;

cxlr->params.region_label_state = 1;

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
> +	return sysfs_emit(buf, "%d\n", p->region_label_state);
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
> +	if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
> +		rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
> +		if (rc)
> +			return rc;
> +		cxlr->params.region_label_state = 0;
> +	}

Similar to above. You can exit early and not have to indent.

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
> index 0d576b359de6..f01f8c942fdf 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -484,6 +484,7 @@ enum cxl_config_state {
>   */
>  struct cxl_region_params {
>  	enum cxl_config_state state;
> +	int region_label_state;

Maybe a enum?

>  	uuid_t uuid;
>  	int interleave_ways;
>  	int interleave_granularity;

