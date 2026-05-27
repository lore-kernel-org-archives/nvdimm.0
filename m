Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62C8315D33
	for <nvdimm@lists.linux.dev>; Wed, 27 May 2026 23:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779925066; cv=none; b=sl7Cshz65Bzx5x7fKqczls0Ad34doMwPABGtLyU9HTRyDAg6AK8DcH9sgt0b5m7kIJhYr0Iy2Z1tGqWY+AFCLwNuAnpOY23cbjhVM07i4AhFSHlf0jSIsNp0Oc60BRJcwfxMDGPQouOkFa+oA8MsG9+W0yXGMaFI7SPCbYcXw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779925066; c=relaxed/simple;
	bh=CYKKgfyqGe6IHQF2DB0YD3zdQY5dSToM4irDMqD2W1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7dehRsZwFxs0yachKvL8Y8HXfY/wUMQyiCtsE7iqDFVhRwK5aSIeOofeHDNI0wiUKCIlLlRJx+TvZwjQuR+WEdKDji9PBK/bGnfGucHe1ithpw1bq1aoxHBEgYhTPiSIALbAlCW9MqAGyQSNAcIAswXcHukwUZlZ2+YzCtJFew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPGqy6ui; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPGqy6ui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779925065; x=1811461065;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CYKKgfyqGe6IHQF2DB0YD3zdQY5dSToM4irDMqD2W1M=;
  b=HPGqy6ui1H//2qroDdcQLoWMAz92l/Xm0yxB7y1qIkl3GRgWOpb5Y9dE
   0SQI/XeSMw9tLTnla3lsthvfNyx5BjRCvQVtHUvNOcnyes1U14yDBuQt9
   vv3MsD25fn4GJwXDymVy/dHeKNiI5rVuWf5JGzAVbONjG46NXERJVfMrX
   YWfM61gEu4cHs9VE6Xg0on7HPBq2u03D/HMSxNcpGrBI4tEAuSUYRbmtP
   w1VaTlpjd0o8R42JAPcAj9+gLMes+2vKNQekZ0Mo2zUGzjfrBD30mCgiq
   Ym6mHoBDThnfX3SqeT51rqr1M2AQ6sIqvuLFbB3a4wZdBWP2d7DwuqM9d
   g==;
X-CSE-ConnectionGUID: 5NImPDdKR2KzxdHWplshHQ==
X-CSE-MsgGUID: hrtb+1OnTwCCTauZvJs5Vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="106218854"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="106218854"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:37:44 -0700
X-CSE-ConnectionGUID: j4Vbaxf2QQ+y1gZ0R+EGDg==
X-CSE-MsgGUID: oshnxb9KRCS1mgsbeiaqXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="266270531"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.111.23]) ([10.125.111.23])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 16:37:12 -0700
Message-ID: <c1f55b99-31d2-4c5f-9f22-05f363e31e5b@intel.com>
Date: Wed, 27 May 2026 16:37:11 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/31] cxl/core: Enforce partition order/simplify
 partition calls
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <22ae445b8a99d26299520e2429c5bf4e64b0d9e6.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <22ae445b8a99d26299520e2429c5bf4e64b0d9e6.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:42 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Device partitions have an implied order which is made more complex by
> the addition of a dynamic partition.
> 
> Remove the ram special case information calls in favor of generic calls
> with a check ahead of time to ensure the preservation of the implied
> partition order.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes::
> [anisa: rebase]
> [davidlohr: core/hdm.c: return -EINVAL instead of 0 in cxl_dpa_setup
> if partitions are out of order]
> ---
>  drivers/cxl/core/hdm.c    | 11 ++++++++++-
>  drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
>  drivers/cxl/cxlmem.h      |  9 +++------
>  drivers/cxl/mem.c         |  2 +-
>  4 files changed, 23 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 28974adaab75..7a5812971f8f 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -464,6 +464,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int i;
>  
>  	guard(rwsem_write)(&cxl_rwsem.dpa);
>  
> @@ -476,9 +477,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		return 0;
>  	}
>  
> +	/* Verify partitions are in expected order. */
> +	for (i = 1; i < info->nr_partitions; i++) {
> +		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {

I think we need to check info->part[i].mode and not cxlds here. cxlds mode is assigned later in this function.

DJ


> +			dev_err(dev, "Partition order mismatch\n");
> +			return -EINVAL;
> +		}
> +	}
> +
>  	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
>  
> -	for (int i = 0; i < info->nr_partitions; i++) {
> +	for (i = 0; i < info->nr_partitions; i++) {
>  		const struct cxl_dpa_part_info *part = &info->part[i];
>  		int rc;
>  
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index 80e65690eb77..71602820f896 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -75,20 +75,12 @@ static ssize_t label_storage_size_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(label_storage_size);
>  
> -static resource_size_t cxl_ram_size(struct cxl_dev_state *cxlds)
> -{
> -	/* Static RAM is only expected at partition 0. */
> -	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
> -		return 0;
> -	return resource_size(&cxlds->part[0].res);
> -}
> -
>  static ssize_t ram_size_show(struct device *dev, struct device_attribute *attr,
>  			     char *buf)
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> -	unsigned long long len = cxl_ram_size(cxlds);
> +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_RAM);
>  
>  	return sysfs_emit(buf, "%#llx\n", len);
>  }
> @@ -101,7 +93,7 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
> -	unsigned long long len = cxl_pmem_size(cxlds);
> +	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_PMEM);
>  
>  	return sysfs_emit(buf, "%#llx\n", len);
>  }
> @@ -424,10 +416,11 @@ static struct attribute *cxl_memdev_attributes[] = {
>  	NULL,
>  };
>  
> -static struct cxl_dpa_perf *to_pmem_perf(struct cxl_dev_state *cxlds)
> +static struct cxl_dpa_perf *part_perf(struct cxl_dev_state *cxlds,
> +				      enum cxl_partition_mode mode)
>  {
>  	for (int i = 0; i < cxlds->nr_partitions; i++)
> -		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
> +		if (cxlds->part[i].mode == mode)
>  			return &cxlds->part[i].perf;
>  	return NULL;
>  }
> @@ -438,7 +431,7 @@ static ssize_t pmem_qos_class_show(struct device *dev,
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  
> -	return sysfs_emit(buf, "%d\n", to_pmem_perf(cxlds)->qos_class);
> +	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_PMEM)->qos_class);
>  }
>  
>  static struct device_attribute dev_attr_pmem_qos_class =
> @@ -450,20 +443,13 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
>  	NULL,
>  };
>  
> -static struct cxl_dpa_perf *to_ram_perf(struct cxl_dev_state *cxlds)
> -{
> -	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
> -		return NULL;
> -	return &cxlds->part[0].perf;
> -}
> -
>  static ssize_t ram_qos_class_show(struct device *dev,
>  				  struct device_attribute *attr, char *buf)
>  {
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
>  	struct cxl_dev_state *cxlds = cxlmd->cxlds;
>  
> -	return sysfs_emit(buf, "%d\n", to_ram_perf(cxlds)->qos_class);
> +	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_RAM)->qos_class);
>  }
>  
>  static struct device_attribute dev_attr_ram_qos_class =
> @@ -499,7 +485,7 @@ static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
>  	struct device *dev = kobj_to_dev(kobj);
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> -	struct cxl_dpa_perf *perf = to_ram_perf(cxlmd->cxlds);
> +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_RAM);
>  
>  	if (a == &dev_attr_ram_qos_class.attr &&
>  	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> @@ -518,7 +504,7 @@ static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n
>  {
>  	struct device *dev = kobj_to_dev(kobj);
>  	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> -	struct cxl_dpa_perf *perf = to_pmem_perf(cxlmd->cxlds);
> +	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_PMEM);
>  
>  	if (a == &dev_attr_pmem_qos_class.attr &&
>  	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index cee936fb3d03..10175ca3b7ee 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -383,14 +383,11 @@ struct cxl_security_state {
>  
>  #define CXL_MAX_DC_PARTITIONS 8
>  
> -static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
> +static inline resource_size_t cxl_part_size(struct cxl_dev_state *cxlds,
> +					    enum cxl_partition_mode mode)
>  {
> -	/*
> -	 * Static PMEM may be at partition index 0 when there is no static RAM
> -	 * capacity.
> -	 */
>  	for (int i = 0; i < cxlds->nr_partitions; i++)
> -		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
> +		if (cxlds->part[i].mode == mode)
>  			return resource_size(&cxlds->part[i].res);
>  	return 0;
>  }
> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index fcffe24dcb42..f19e08279ec7 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c
> @@ -114,7 +114,7 @@ static int cxl_mem_probe(struct device *dev)
>  		return -ENXIO;
>  	}
>  
> -	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> +	if (cxl_part_size(cxlds, CXL_PARTMODE_PMEM) && IS_ENABLED(CONFIG_CXL_PMEM)) {
>  		rc = devm_cxl_add_nvdimm(dev, parent_port, cxlmd);
>  		if (rc) {
>  			if (rc == -ENODEV)

