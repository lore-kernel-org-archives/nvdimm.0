Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F45146000
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 23:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723851728; cv=none; b=tTq6FVpe65I+4h4o+sxrgXq96rCmoEg0+H4DnxJSzlDP6gDagC7QyoSZ+q0JDHH7kusK2LfHZrNSbwdieo/Fbdu1p77CJSGknFURcH8aorN1ihGMQk+2U2Mzl2lyjLs+LCM7hnAAv7AGdxY/52XOcYFUodpz8ELbmO1lqUn2O40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723851728; c=relaxed/simple;
	bh=G60JncDBVFyhl3xMoGYe1WnXKeXowI4N88FhHjdyLNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d5ccEK6PgbunD7BRgepnOEkNtUgiQAAK72mj0yrI45bFptxUmlMhyd7vo3WhQknvMGmFn9O+7cK+zMpF8S6uUmO0KPTx8k20S12mWV5CI+/nb8jrzOywp88pIiLD552Gu2bopiHpiJYCd9Y7YV3ny+XezSc+oH4zVznv1msRow4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QDAkDbQz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QDAkDbQz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723851727; x=1755387727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=G60JncDBVFyhl3xMoGYe1WnXKeXowI4N88FhHjdyLNw=;
  b=QDAkDbQzGo3soAwIcsmiYJcf+6ncIszjw4StFx08y8G+qm23XTuJ9F3F
   EJj9rxN3q8xXdwvkgZq8AdtN4wmxFLXMHjeHJmPjw1rkmQPuAIUtxztT4
   xZ1NvlE0TXceuSq3IuNwu9rMVi4kN4Gm8jbMtwxiLSUV8gnwqdrJO9U0/
   vQ3jCF0mEniAutPmKrl4gtvEu3wThgdqLD6Y5mLoR/u+XUm50JXpHLykI
   2OBroUCR9jd0SvaRVzktqMWTWayNukuKJQLkVIpc/Y9Kas+/Sz5y9cJuH
   LSo7wFRCfK3wTc9ZwtU/FUTypLm6FC9OgLc/P2DV/OlDZotOoIOwEFxDI
   A==;
X-CSE-ConnectionGUID: n7uxl1PMRUaTS5yyoHRUBA==
X-CSE-MsgGUID: Sa3N9OC+T/ynjXUobMpSbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11166"; a="13063644"
X-IronPort-AV: E=Sophos;i="6.10,153,1719903600"; 
   d="scan'208";a="13063644"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 16:42:06 -0700
X-CSE-ConnectionGUID: 6hOFfSD0QWiuQmdHcTDxtA==
X-CSE-MsgGUID: 0ps8p1hWT5Oa/0gRUBG9AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,153,1719903600"; 
   d="scan'208";a="59842503"
Received: from unknown (HELO [10.125.111.71]) ([10.125.111.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2024 16:42:04 -0700
Message-ID: <8649e30c-a43a-4096-a32f-e31bf3e71d90@intel.com>
Date: Fri, 16 Aug 2024 16:42:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/25] cxl/mem: Expose DCD partition capabilities in
 sysfs
To: ira.weiny@intel.com, Fan Ni <fan.ni@samsung.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-btrfs@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-11-7c9b96cba6d7@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240816-dcd-type2-upstream-v3-11-7c9b96cba6d7@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/16/24 7:44 AM, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> To properly configure CXL regions on Dynamic Capacity Devices (DCD),
> user space will need to know the details of the DC partitions available.
> 
> Expose dynamic capacity capabilities through sysfs.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: remove review tags]
> [Davidlohr/Fan/Jonathan: omit 'dc' attribute directory if device is not DC]
> [Jonathan: update documentation for dc visibility]
> [Jonathan: Add a comment to DC region X attributes to ensure visibility checks work]
> [iweiny: push sysfs version to 6.12]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 12 ++++
>  drivers/cxl/core/memdev.c               | 97 +++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 957717264709..6227ae0ab3fc 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -54,6 +54,18 @@ Description:
>  		identically named field in the Identify Memory Device Output
>  		Payload in the CXL-2.0 specification.
>  
> +What:		/sys/bus/cxl/devices/memX/dc/region_count
> +		/sys/bus/cxl/devices/memX/dc/regionY_size

Just make it into 2 separate entries?

DJ
> +Date:		August, 2024
> +KernelVersion:	v6.12
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) Dynamic Capacity (DC) region information.  The dc
> +		directory is only visible on devices which support Dynamic
> +		Capacity.
> +		The region_count is the number of Dynamic Capacity (DC)
> +		partitions (regions) supported on the device.
> +		regionY_size is the size of each of those partitions.
>  
>  What:		/sys/bus/cxl/devices/memX/pmem/qos_class
>  Date:		May, 2023
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 0277726afd04..7da1f0f5711a 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -101,6 +101,18 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
>  static struct device_attribute dev_attr_pmem_size =
>  	__ATTR(size, 0444, pmem_size_show, NULL);
>  
> +static ssize_t region_count_show(struct device *dev, struct device_attribute *attr,
> +				 char *buf)
> +{
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%d\n", mds->nr_dc_region);
> +}
> +
> +static struct device_attribute dev_attr_region_count =
> +	__ATTR(region_count, 0444, region_count_show, NULL);
> +
>  static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -448,6 +460,90 @@ static struct attribute *cxl_memdev_security_attributes[] = {
>  	NULL,
>  };
>  
> +static ssize_t show_size_regionN(struct cxl_memdev *cxlmd, char *buf, int pos)
> +{
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	return sysfs_emit(buf, "%#llx\n", mds->dc_region[pos].decode_len);
> +}
> +
> +#define REGION_SIZE_ATTR_RO(n)						\
> +static ssize_t region##n##_size_show(struct device *dev,		\
> +				     struct device_attribute *attr,	\
> +				     char *buf)				\
> +{									\
> +	return show_size_regionN(to_cxl_memdev(dev), buf, (n));		\
> +}									\
> +static DEVICE_ATTR_RO(region##n##_size)
> +REGION_SIZE_ATTR_RO(0);
> +REGION_SIZE_ATTR_RO(1);
> +REGION_SIZE_ATTR_RO(2);
> +REGION_SIZE_ATTR_RO(3);
> +REGION_SIZE_ATTR_RO(4);
> +REGION_SIZE_ATTR_RO(5);
> +REGION_SIZE_ATTR_RO(6);
> +REGION_SIZE_ATTR_RO(7);
> +
> +/*
> + * RegionX attributes must be listed in order and first in this array to
> + * support the visbility checks.
> + */
> +static struct attribute *cxl_memdev_dc_attributes[] = {
> +	&dev_attr_region0_size.attr,
> +	&dev_attr_region1_size.attr,
> +	&dev_attr_region2_size.attr,
> +	&dev_attr_region3_size.attr,
> +	&dev_attr_region4_size.attr,
> +	&dev_attr_region5_size.attr,
> +	&dev_attr_region6_size.attr,
> +	&dev_attr_region7_size.attr,
> +	&dev_attr_region_count.attr,
> +	NULL,
> +};
> +
> +static umode_t cxl_memdev_dc_attr_visible(struct kobject *kobj, struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	/* Not a memory device */
> +	if (!mds)
> +		return 0;
> +
> +	if (a == &dev_attr_region_count.attr)
> +		return a->mode;
> +
> +	/*
> +	 * Show only the regions supported, regionX attributes are first in the
> +	 * list
> +	 */
> +	if (n < mds->nr_dc_region)
> +		return a->mode;
> +
> +	return 0;
> +}
> +
> +static bool cxl_memdev_dc_group_visible(struct kobject *kobj)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
> +
> +	/* No DC regions */
> +	if (!mds || mds->nr_dc_region == 0)
> +		return false;
> +	return true;
> +}
> +
> +DEFINE_SYSFS_GROUP_VISIBLE(cxl_memdev_dc);
> +
> +static struct attribute_group cxl_memdev_dc_group = {
> +	.name = "dc",
> +	.attrs = cxl_memdev_dc_attributes,
> +	.is_visible = SYSFS_GROUP_VISIBLE(cxl_memdev_dc),
> +};
> +
>  static umode_t cxl_memdev_visible(struct kobject *kobj, struct attribute *a,
>  				  int n)
>  {
> @@ -528,6 +624,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
>  	&cxl_memdev_ram_attribute_group,
>  	&cxl_memdev_pmem_attribute_group,
>  	&cxl_memdev_security_attribute_group,
> +	&cxl_memdev_dc_group,
>  	NULL,
>  };
>  
> 
