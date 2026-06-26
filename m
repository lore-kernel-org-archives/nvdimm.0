Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5473B42D2
	for <nvdimm@lists.linux.dev>; Fri, 26 Jun 2026 22:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782513478; cv=none; b=BVdIX3a/8UuPXrFyQ7c32g96tNxb1VnlPiRHU7R0sVD/ZFdIwTEHCk4yj909cx7+IiPG5MMvN5a+6wk7kdbkquY4xsEjitMet6fRBZnG/whVUMdTq/B1JFXQ+SQ4OHyaWsPSQxqIGSRupDA2lblK4/1zwui7KXofUD9k9WpGeu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782513478; c=relaxed/simple;
	bh=xmEwf5snEsDQNhhlbyYYq5fevoxTLf72B+gFyLa8frc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0uguju8IeAergaO0W5f7ovSpzjqjBfFPO3We9z9YD6Oh4H10zQV/3tZsjnxjjr5AC6y5WwwR8l6S8Dr4wRR9aCFz+9oTrD8nXNwSo//MwjQB9tskQB6+rJkMUDv6vUOCIZ57JLycFZO8voK2kl4b7R8CdjDFgSXbIyiR8XzFGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cSVXewcI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cSVXewcI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782513476; x=1814049476;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xmEwf5snEsDQNhhlbyYYq5fevoxTLf72B+gFyLa8frc=;
  b=cSVXewcIgA1J3nKOTMBA0AMeEWdD2KVVC8DlwH0Xi4C9a1GW3I4/K9dM
   Nq6jN9+dVqdtdjVrzg/JviOa5tKKzHqHs616jMuDOQkHrn084qxvdhKdI
   pwPVZIVQDtDDRqJusrRSgEwXrmEqTdP4I6jkGLmA1wZ7Q0QrqElyWeucS
   vfxSDluRUSNrDWgPRIuxtwK/9SOY7z3XPQNk4jGGsQLgYu9CTIClqvCIm
   f6s8HGPYplCcI/NpCKReZtdgR0VJZ+NnofsY0XKqMdSoftmhAtrOoYr4H
   LuRbv01yBhcPNKDruinA3LNphGeW7L7wr+cJLJVn0rYfSmBSdROd/QJTo
   Q==;
X-CSE-ConnectionGUID: RD/HjPYZRFe7Stirk5o8NQ==
X-CSE-MsgGUID: uJ1Et4BDTduy6Wxs506xCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11829"; a="100744509"
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="100744509"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:37:55 -0700
X-CSE-ConnectionGUID: mErvU01SRHm8ht2RWWHZaQ==
X-CSE-MsgGUID: 3+pizYnRRpmNvva0w+T7Ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,227,1774335600"; 
   d="scan'208";a="255832443"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.96]) ([10.125.109.96])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2026 15:37:54 -0700
Message-ID: <0b544328-9bd1-49f1-abdb-c2c2f7796e47@intel.com>
Date: Fri, 26 Jun 2026 15:37:53 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 04/31] cxl/core: Enforce partition order/simplify
 partition calls
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Anisa Su <anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-5-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260625112638.550691-5-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/25/26 4:04 AM, Anisa Su wrote:
> From: Ira Weiny <iweiny@kernel.org>
> 
> Device partitions have an implied order which is made more complex by
> the addition of a dynamic partition
> 
> Remove the ram special case information calls in favor of generic calls
> with a check ahead of time to ensure the preservation of the implied
> partition order.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
> ---
> Changes:
> 
> 1. Use info->part[i] for verifying partitions are in expected order,
>    not cxlds->part[i]. cxlds->part[] is populated in the loop following
>    this check.
> ---
>  drivers/cxl/core/hdm.c    | 11 ++++++++++-
>  drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
>  drivers/cxl/cxlmem.h      |  9 +++------
>  drivers/cxl/mem.c         |  2 +-
>  4 files changed, 23 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 7f63b86887f4..54b6848928a9 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -457,6 +457,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
>  int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  {
>  	struct device *dev = cxlds->dev;
> +	int i;
>  
>  	guard(rwsem_write)(&cxl_rwsem.dpa);
>  
> @@ -469,9 +470,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
>  		return 0;
>  	}
>  
> +	/* Verify partitions are in expected order. */
> +	for (i = 1; i < info->nr_partitions; i++) {
> +		if (info->part[i].mode < info->part[i-1].mode) {
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
> index b29fb16725b4..afc195d8c090 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -388,14 +388,11 @@ struct cxl_security_state {
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

