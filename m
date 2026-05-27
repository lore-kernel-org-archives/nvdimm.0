Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506293B3C0A
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779926083; cv=none; b=H4P/FPFrCjbeS+z33M9Nf0zLb8c0xCLYC7+N7E1/VWQ3f+7QjefWiyGJFJCdBvLhW6/fN8NIaaekEI9ceQVkcaW+dPf3NEOSlNRpcFuV8ukXlhH1C80iWha3ven0mhblemDQxHnATUsGJx3S8htgmVcHHEBT+Le7tSVxu85IGtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779926083; c=relaxed/simple;
	bh=vzEii6/0ejhgue9HP1CEyY9U9zw6a1wG1JkwGca0vdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NvKjNQsdxX/inqN3ylQwSgzFNKD/eMh69Qqv7IXbmW/ubkOcIVLi1TKTy1CgJsKnGiphRo1KxUIWdAFaqnNd2tudakKxI6epQQfYZWgv91oqV2T5c8eoFWdUdHu1mnx8gMlvGRjX4bbDHwu03wnUz96WaksJZaXUcMsUlvBF1Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k64qZv6D; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k64qZv6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779926081; x=1811462081;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vzEii6/0ejhgue9HP1CEyY9U9zw6a1wG1JkwGca0vdM=;
  b=k64qZv6DRv/zbO6R/k1fR76reRfoorqrlF2CcVazJI6c9F/25Vp7trU3
   IJmFalNB53PMQ2B7N7wp+ndxffKxuUSf64HNlncvIc1P9P4xmtchCbiM7
   4Y5GY+IIsDMbXLUo2MquNgT5ylBIvmdKVFt1lIOjxvVNc4PNSIgqKaZms
   dor3RlEqxLdaq756NAgK+kFDcg+eu1SzSRY8JpskqNaFypgHkWXIy70hb
   JRneYNNqJ5+pGsmiI6cfMw3xYdGXtrGIm5EPeO0vDzvGfkINhpkGpWa9v
   KLoO9sEdjKpKqo87c5ucIRSRL8Dr8eGQNdqd7o7ZyR+aiyTyp/8zCbJzb
   Q==;
X-CSE-ConnectionGUID: FwsOSe8IRpKROKod/Nsv8w==
X-CSE-MsgGUID: gmWxayIsRr6M6BvVPXFZCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="106219722"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="106219722"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:54:40 -0700
X-CSE-ConnectionGUID: H7Q5c5g2T0ysD3gakfKSmQ==
X-CSE-MsgGUID: Oj7m7OmAQ2yBoOFT6dscYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="266273524"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:54:39 -0700
Message-ID: <cc026dd7-0aa5-425a-821e-7300ecff687b@intel.com>
Date: Wed, 27 May 2026 16:54:38 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/31] cxl/mem: Expose dynamic ram A partition in
 sysfs
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <45bc277b11c1aabf495132925c0d75c78e3b5a8a.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <45bc277b11c1aabf495132925c0d75c78e3b5a8a.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> To properly configure CXL regions user space will need to know the
> details of the dynamic ram partition.
> 
> Expose the first dynamic ram partition through sysfs.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Missing Anisa sign off

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> 
> ---
> Changes:
> [anisa: Update kernel version to 7.0]
> [davidlohr: Remove "persistent" from description of
> /sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class]
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
>  drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 16a9b3d2e2c0..3d95c325f6e0 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -89,6 +89,30 @@ Description:
>  		and there are platform specific performance related
>  		side-effects that may result. First class-id is displayed.
>  
> +What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/size
> +Date:		May, 2025
> +KernelVersion:	v7.0
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) The first Dynamic RAM partition capacity as bytes.
> +
> +
> +What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class
> +Date:		May, 2025
> +KernelVersion:	v7.0
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) For CXL host platforms that support "QoS Telemmetry"
> +		this attribute conveys a comma delimited list of platform
> +		specific cookies that identifies a QoS performance class
> +		for the partition of the CXL mem device. These
> +		class-ids can be compared against a similar "qos_class"
> +		published for a root decoder. While it is not required
> +		that the endpoints map their local memory-class to a
> +		matching platform class, mismatches are not recommended
> +		and there are platform specific performance related
> +		side-effects that may result. First class-id is displayed.
> +
>  
>  What:		/sys/bus/cxl/devices/memX/serial
>  Date:		January, 2022
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 71602820f896..064cfd628577 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
>  static struct device_attribute dev_attr_pmem_size =
>  	__ATTR(size, 0444, pmem_size_show, NULL);
>  
> +static ssize_t dynamic_ram_a_size_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
> +
> +	return sysfs_emit(buf, "%#llx\n", len);
> +}
> +
> +static struct device_attribute dev_attr_dynamic_ram_a_size =
> +	__ATTR(size, 0444, dynamic_ram_a_size_show, NULL);
> +
>  static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
>  	NULL,
>  };
>  
> +static ssize_t dynamic_ram_a_qos_class_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +
> +	return sysfs_emit(buf, "%d\n",
> +			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)->qos_class);
> +}
> +
> +static struct device_attribute dev_attr_dynamic_ram_a_qos_class =
> +	__ATTR(qos_class, 0444, dynamic_ram_a_qos_class_show, NULL);
> +
> +static struct attribute *cxl_memdev_dynamic_ram_a_attributes[] = {
> +	&dev_attr_dynamic_ram_a_size.attr,
> +	&dev_attr_dynamic_ram_a_qos_class.attr,
> +	NULL,
> +};
> +
>  static ssize_t ram_qos_class_show(struct device *dev,
>  				  struct device_attribute *attr, char *buf)
>  {
> @@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
>  	.is_visible = cxl_pmem_visible,
>  };
>  
> +static umode_t cxl_dynamic_ram_a_visible(struct kobject *kobj, struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
> +
> +	if (a == &dev_attr_dynamic_ram_a_qos_class.attr &&
> +	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> +		return 0;
> +
> +	if (a == &dev_attr_dynamic_ram_a_size.attr &&
> +	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static struct attribute_group cxl_memdev_dynamic_ram_a_attribute_group = {
> +	.name = "dynamic_ram_a",
> +	.attrs = cxl_memdev_dynamic_ram_a_attributes,
> +	.is_visible = cxl_dynamic_ram_a_visible,
> +};
> +
>  static umode_t cxl_memdev_security_visible(struct kobject *kobj,
>  					   struct attribute *a, int n)
>  {
> @@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
>  	&cxl_memdev_attribute_group,
>  	&cxl_memdev_ram_attribute_group,
>  	&cxl_memdev_pmem_attribute_group,
> +	&cxl_memdev_dynamic_ram_a_attribute_group,
>  	&cxl_memdev_security_attribute_group,
>  	NULL,
>  };
> @@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
>  {
>  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
>  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
> +	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_a_attribute_group);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
>  

