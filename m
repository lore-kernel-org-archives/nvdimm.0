Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6622370A
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782515317; cv=none; b=KfG4QQN+pt+v5K0fm7XZB52gKOCnLibNI7sIQ50cMstS3VbqiERaIxMUxLqdcjCZpLN+BfzzFFevolKMTDpLldPpBuTk2tRD8tnm3pNdB79KfYmp25W2JeRm9GzWdwaqblSEfmTgsmZkOlv8h4hVDft0kxfxGjJjvb4ilPfdBOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782515317; c=relaxed/simple;
	bh=ZZl37iY6zE0n8lIGPGOa1H+VP3GRLjXhlkibh7dsdT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5S+teQbC4KrcmmDRlEHGQzD7OWqZCSdQ0/zM6htdYoTpmouFUE1Y8EAFRqkWQBhZ70aWpEfZsXiGNb7Cyi1mA7YCchRE1NukWHspcb3QmbBJLVzhCVd69K00Aa7yp8hl4Kdio+ozVJiAUukoZlySFqQC2Q/UbqkJpiJoO+z1gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUogC59t; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUogC59t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782515316; x=1814051316;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZZl37iY6zE0n8lIGPGOa1H+VP3GRLjXhlkibh7dsdT4=;
  b=aUogC59tfKA9bEykvcNLC3EWB9j3hYvlODKQk8ea9nedFNELLxB+H34A
   xco8075GcUpfzm1OUAW16tMeKaioaZivU6Xt+MhLKIKIPtAJ6ygEiEJ7U
   Gs6X0M0bJVNTa9sBdts4YTcvQ/XBV3NIeIez1F45j6AbuwGFec/Yvt+/D
   Ybda+8C7AgDcBjQM2u0z5xqx01xif9D6qwCeXsLs+g2bG2Y29t8635Dfv
   gzCUfgXuahYEW/F7WABK5+5oo2s4dfFOjgH2nyKLsol9qdx/o/4Xif8EN
   4q8m5CA6xDa1Fu1R95T6MnlF20G9RVm+JPLd5OqPljrRjc1xjcsz+0Zas
   A==;
X-CSE-ConnectionGUID: 3KCetrstRPqd1AxLIwoxwA==
X-CSE-MsgGUID: MsSI612OTcKhbGMPYFecLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="83403534"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="83403534"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 16:08:36 -0700
X-CSE-ConnectionGUID: VvGPS/b2SCKBsvit//Ni+g==
X-CSE-MsgGUID: /qLuiAbMTFmoAD5+QR99EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="255838943"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 16:08:34 -0700
Message-ID: <8f8bbe74-57a3-4059-93b6-bcc6ba6ddffd@intel.com>
Date: Fri, 26 Jun 2026 16:08:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 05/31] cxl/mem: Expose dynamic ram 1 partition in
 sysfs
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-6-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-6-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> To properly configure CXL regions user space will need to know the
> details of the dynamic ram partition.
> 
> Expose the first dynamic ram partition through sysfs.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>

Just a spelling error below

> 
> ---
> Changes:
> 1. Documentation: bump kernel version to 7.3 and date to June 2026
> 2. Pick up Dave's reviewed-by tag
> 3. Rename dynamic_ram_a to dynamic_ram_1
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
>  drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> index 16a9b3d2e2c0..435495de409c 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -89,6 +89,30 @@ Description:
>  		and there are platform specific performance related
>  		side-effects that may result. First class-id is displayed.
>  
> +What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/size
> +Date:		June, 2026
> +KernelVersion:	v7.3
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) The first Dynamic RAM partition capacity as bytes.
> +
> +
> +What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/qos_class
> +Date:		June, 2026
> +KernelVersion:	v7.3
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) For CXL host platforms that support "QoS Telemmetry"

Telemetry

DJ

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
> index 71602820f896..20417db933aa 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
>  static struct device_attribute dev_attr_pmem_size =
>  	__ATTR(size, 0444, pmem_size_show, NULL);
>  
> +static ssize_t dynamic_ram_1_size_show(struct device *dev, struct device_attribute *attr,
> +			      char *buf)
> +{
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
> +
> +	return sysfs_emit(buf, "%#llx\n", len);
> +}
> +
> +static struct device_attribute dev_attr_dynamic_ram_1_size =
> +	__ATTR(size, 0444, dynamic_ram_1_size_show, NULL);
> +
>  static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
>  			   char *buf)
>  {
> @@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
>  	NULL,
>  };
>  
> +static ssize_t dynamic_ram_1_qos_class_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +
> +	return sysfs_emit(buf, "%d\n",
> +			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)->qos_class);
> +}
> +
> +static struct device_attribute dev_attr_dynamic_ram_1_qos_class =
> +	__ATTR(qos_class, 0444, dynamic_ram_1_qos_class_show, NULL);
> +
> +static struct attribute *cxl_memdev_dynamic_ram_1_attributes[] = {
> +	&dev_attr_dynamic_ram_1_size.attr,
> +	&dev_attr_dynamic_ram_1_qos_class.attr,
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
> +static umode_t cxl_dynamic_ram_1_visible(struct kobject *kobj, struct attribute *a, int n)
> +{
> +	struct device *dev = kobj_to_dev(kobj);
> +	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
> +
> +	if (a == &dev_attr_dynamic_ram_1_qos_class.attr &&
> +	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> +		return 0;
> +
> +	if (a == &dev_attr_dynamic_ram_1_size.attr &&
> +	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)))
> +		return 0;
> +
> +	return a->mode;
> +}
> +
> +static struct attribute_group cxl_memdev_dynamic_ram_1_attribute_group = {
> +	.name = "dynamic_ram_1",
> +	.attrs = cxl_memdev_dynamic_ram_1_attributes,
> +	.is_visible = cxl_dynamic_ram_1_visible,
> +};
> +
>  static umode_t cxl_memdev_security_visible(struct kobject *kobj,
>  					   struct attribute *a, int n)
>  {
> @@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
>  	&cxl_memdev_attribute_group,
>  	&cxl_memdev_ram_attribute_group,
>  	&cxl_memdev_pmem_attribute_group,
> +	&cxl_memdev_dynamic_ram_1_attribute_group,
>  	&cxl_memdev_security_attribute_group,
>  	NULL,
>  };
> @@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
>  {
>  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
>  	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
> +	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_1_attribute_group);
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
>  

