Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EB130F54A
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758659002; cv=none; b=oG1cBb10iJoWTMfF9/jOwlbDv8YtzUe8StuDNKVcT+1xmRcIGbXSYIDxhS73suBgfk2Wpqs1m+H5oCqnPwiBi8eDUq8zyHe9SE0Gb9iYvvbeksMX902MdDvxHKP3nmcxYUCpwZyig4k456CvFdoKq/4F3WV+l0YtUp0OyEhsN4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758659002; c=relaxed/simple;
	bh=+cwFEtuDaXb/DaQ6ejtcHJQygdA5jvR5zMxQFdoqSFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l343C6mX1uOOW8ITDZywNcdxmbBsnASy3OVaUv2j3gSDhea2raTDIuQbFGhiTffW7TP/FNXtb01iQdDqNaNlbi+YWbTWxjUG0Jx/MAYMFpOa8Y+WuZK3TMeea5XA8c1iHkOtgNdeCmcyVC6WaJdmpFdA6RaG6zBWY/478nC2e64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HsPmAthl; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HsPmAthl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758659001; x=1790195001;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+cwFEtuDaXb/DaQ6ejtcHJQygdA5jvR5zMxQFdoqSFk=;
  b=HsPmAthlWfsigzEXYtP9nHy436LEhS9Eyb+ixCMsYpVbDc6t9Pz0WxoO
   LHxztIZOfIxZWcq75EmtQ4/otb7ekV7BIa6RcxH35WH29BBzdtL7oHOWQ
   Pt69bNy7qocfWeN82quuq+D+IVT1/ArN5ot5/uVhvtf09u1gzVTptAiM5
   sWLEwddNG65OvRM/29AIJiPLjUMowTEEPVtqX4c3RGXowB2gysRN1QhgG
   EKLwh7Q49hlpv+2kmjNEIJhUhJQoGyXWas30Ccxm9IclnnXZWeFlEiFIw
   4e+G1EK8fKqN1q5/+aZRb5ldGEtnXr1mjJo6O3OCKb6xzAReixjQzLmok
   A==;
X-CSE-ConnectionGUID: XWFnYxR+T7CaPXD+Q8gDgQ==
X-CSE-MsgGUID: C6F/QKyET6qnXDGvca/80w==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="71194079"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="71194079"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 13:23:20 -0700
X-CSE-ConnectionGUID: bhr+XJUFT/KBngXpreS9eQ==
X-CSE-MsgGUID: kuRAh+4HR1W49QaMFRrEig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="177642711"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.108.174]) ([10.125.108.174])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 13:23:17 -0700
Message-ID: <a1fa16f1-c75f-4f7d-b297-a32ba4c7d109@intel.com>
Date: Tue, 23 Sep 2025 13:23:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 12/20] nvdimm/region_label: Export routine to fetch
 region information
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134153epcas5p1e1f7a7a19fb41d12b9397c3e6265f823@epcas5p1.samsung.com>
 <20250917134116.1623730-13-s.neeraj@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250917134116.1623730-13-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/17/25 6:41 AM, Neeraj Kumar wrote:
> CXL region information preserved from the LSA needs to be exported for
> use by the CXL driver for CXL region re-creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
>  include/linux/libnvdimm.h  |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 918c3db93195..619c8ce56dce 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_provider_data);
>  
> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
> +{
> +	if (nvdimm)
> +		return nvdimm->is_region_label;
> +
> +	return false;

Just a nit. Would prefer return error early and return the success case last.

> +}
> +EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
> +
> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
> +{
> +	if (nvdimm)
> +		return &nvdimm->cxl_region_params;
> +
> +	return NULL;

same comment

> +}
> +EXPORT_SYMBOL_GPL(nvdimm_get_cxl_region_param);
> +
>  static ssize_t commands_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index 07ea2e3f821a..3ffd50ab6ac4 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -330,6 +330,8 @@ int nvdimm_in_overwrite(struct nvdimm *nvdimm);
>  bool is_nvdimm_sync(struct nd_region *nd_region);
>  int nd_region_label_update(struct nd_region *nd_region);
>  int nd_region_label_delete(struct nd_region *nd_region);
> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm);
> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm);
>  
>  static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
>  		unsigned int buf_len, int *cmd_rc)

