Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6B32857F0
	for <nvdimm@lists.linux.dev>; Fri, 19 Sep 2025 23:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758323444; cv=none; b=Rhgrg3PxVcIXqu3XPgWx5R0yJxvc+eFAI3bUpR9qCWWDJBcOTO9YsnYPrsiPUuPGOz/2HC2JISIrSxsM1bKL3/NeZmGbPvSvxfx4lwhuyEpnsrdgG18g98ySy9l5uPsoTU9R/lqkh04OqAhw3emnKZBoJplaSlCSyIU64UYljEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758323444; c=relaxed/simple;
	bh=QwrDeSssU3xjd1R5pyvj2jC0q4WMlzrV2GqmzoBys5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bo8LFYn5ySTRUyUSGC/5H0FHaBMlxajWEVofOZC1pTWvcEET5YG9Tj80FO+RN5VGpYmG/u+IpE7opab0sQWq3NOJXxl4HckInUNGoZ4GcEM07y61JdIs3sGZQgGTtZvkFEeTDDzhSWkPxGmH8a0SHv+dT9BEazGM7RCc7Mk4res=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvY/gl8s; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvY/gl8s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758323443; x=1789859443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QwrDeSssU3xjd1R5pyvj2jC0q4WMlzrV2GqmzoBys5A=;
  b=gvY/gl8sWkpSFba0JdlZtet1HKjnLwAm7jTnjDkfla1TUCgqVI09ojug
   9BKiJKmyM+RVixrYpGFbMRSYxqFmrnBHfztnuraNWzQyAxuSgMm/shott
   kYBnMRM/GflUkXa46BLzEK122/DTSuo9sh2H6WLllVbXNoTEi17d7+J3z
   DwxMTep9OEQpxSW8YFIKwAvWB6te1nKg0PPHd+h9MGFX0lFnZYQWH8wpc
   Ol7uZTyUH9V2BzAVOECtBsU+EnAILG1GLp55A5j7v29oAJrgnfbS89gfp
   LLKs7ZxSCErhwMR44dYA0EMN/sQEeywIYhhefyYRlv1SKA96XblpeywCW
   Q==;
X-CSE-ConnectionGUID: TiORvyrDRiifh0MMnGECrA==
X-CSE-MsgGUID: xFyQpV7BT9yJusiRu6UjvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60619569"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60619569"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:10:42 -0700
X-CSE-ConnectionGUID: uzPYOIjhT3e9o5K/M3peJA==
X-CSE-MsgGUID: Wp2sEuumTmmLFoAtuRGA8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,279,1751266800"; 
   d="scan'208";a="176334302"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.58]) ([10.125.108.58])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 16:10:41 -0700
Message-ID: <8c6bb8fc-7801-45d3-8563-054b12295df0@intel.com>
Date: Fri, 19 Sep 2025 16:10:40 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 01/20] nvdimm/label: Introduce NDD_REGION_LABELING flag
 to set region label
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134130epcas5p417d7c26bc564d64d1bcea6e04d55704d@epcas5p4.samsung.com>
 <20250917134116.1623730-2-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-2-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:40 AM, Neeraj Kumar wrote:
> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
> introduced in CXL 2.0 Spec, which contain region label along with
> namespace label.
> 
> NDD_LABELING flag is used for namespace. Introduced NDD_REGION_LABELING
> flag for region label. Based on these flags nvdimm driver performs
> operation on namespace label or region label.
> 
> NDD_REGION_LABELING will be utilized by cxl driver to enable LSA 2.1
> region label support
> 
> Accordingly updated label index version
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

With the change noted below,
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/dimm.c      |  1 +
>  drivers/nvdimm/dimm_devs.c |  7 +++++++
>  drivers/nvdimm/label.c     | 21 +++++++++++++++++----
>  drivers/nvdimm/nd.h        |  1 +
>  include/linux/libnvdimm.h  |  3 +++
>  5 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..bda22cb94e5b 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc < 0)
>  		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
>  
> +	ndd->cxl = nvdimm_check_region_label_format(ndd->dev);
>  
>  	/*
>  	 * EACCES failures reading the namespace label-area-properties
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..918c3db93195 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -18,6 +18,13 @@
>  
>  static DEFINE_IDA(dimm_ida);
>  
> +bool nvdimm_check_region_label_format(struct device *dev)

Should be called nvdimm_region_label_supported() since a bool return is expected instead of resolving the checking in the function.

DJ

> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +	return test_bit(NDD_REGION_LABELING, &nvdimm->flags);
> +}
> +
>  /*
>   * Retrieve bus and dimm handle and return if this bus supports
>   * get_config_data commands
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 04f4a049599a..0a9b6c5cb2c3 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -688,11 +688,24 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);
> -	nsindex->major = __cpu_to_le16(1);
> -	if (sizeof_namespace_label(ndd) < 256)
> +
> +	/* Set LSA Label Index Version */
> +	if (ndd->cxl) {
> +		/* CXL r3.2: Table 9-9 Label Index Block Layout */
> +		nsindex->major = __cpu_to_le16(2);
>  		nsindex->minor = __cpu_to_le16(1);
> -	else
> -		nsindex->minor = __cpu_to_le16(2);
> +	} else {
> +		nsindex->major = __cpu_to_le16(1);
> +		/*
> +		 * NVDIMM Namespace Specification
> +		 * Table 2: Namespace Label Index Block Fields
> +		 */
> +		if (sizeof_namespace_label(ndd) < 256)
> +			nsindex->minor = __cpu_to_le16(1);
> +		else /* UEFI 2.7: Label Index Block Definitions */
> +			nsindex->minor = __cpu_to_le16(2);
> +	}
> +
>  	nsindex->checksum = __cpu_to_le64(0);
>  	if (flags & ND_NSINDEX_INIT) {
>  		unsigned long *free = (unsigned long *) nsindex->free;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index cc5c8f3f81e8..158809c2be9e 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
>  void nvdimm_set_locked(struct device *dev);
>  void nvdimm_clear_locked(struct device *dev);
>  int nvdimm_security_setup_events(struct device *dev);
> +bool nvdimm_check_region_label_format(struct device *dev);
>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>  int nvdimm_security_unlock(struct device *dev);
>  #else
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 28f086c4a187..5696715c33bb 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -44,6 +44,9 @@ enum {
>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>  	NDD_REGISTER_SYNC = 8,
>  
> +	/* dimm supports region labels (LSA Format 2.1) */
> +	NDD_REGION_LABELING = 9,
> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,

