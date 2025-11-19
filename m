Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF4E2BE646
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763583509; cv=none; b=aYDOnPLJYf/IwiOXxrGmet026EVu7gz3dYnt70vn/E0oEbaXrSvxUcQHdEoK9tAHXyFgWVxxRyaRDgB9pGmIaZqVV1+lnoHn6rKZyhpG+fn/4HbxjkBPjaizHChsDXTNzXCN709wsIWlwv7KFFpAE3s0DsFcG3f4qJnfeOPKZlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763583509; c=relaxed/simple;
	bh=gFUblME9JJZ0T9OnYbXvE/l9vZyMaVU3/cO4HkHorK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZaYRnIfdvf8NRkNst584TK69eG7WQg0FLcbf0CMtyEeGg5/Zr5/daVtImdZF4iDOH64Bo/wLfSbunLcEfjOUgkajPFl8wVzn+pilzZ7VsNucyKx3TDGDcMIyFhIdICk2cD25/HvdwvlwTI9tWf1b/LN46BCEtDS1MwNdsetHdas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcO855VR; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcO855VR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763583508; x=1795119508;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gFUblME9JJZ0T9OnYbXvE/l9vZyMaVU3/cO4HkHorK8=;
  b=PcO855VRqaAbjIJo76Fsily0z/tYZFCb0dvlnTm9PUfVP2rcHW9EpNet
   X7GpnfPgOseKAGjvjwluG6GwH97munNQrfFMZ5C9hkjGIl76uDYPKWntB
   gaH900mTdcynwoo9hnreQzj6O05OqVm+liCIAlkzfER3GqkVy4TnxVbmR
   iyvYn/Pp4SuCovqyhtyPPtG0uleMdjiJqw6Cdj0F73TzQB5Wks1hy4IJz
   M3U76a/9OGfc+uBTntVaCq/42P12mc0e0wbKH7M48iZuyD0iGOKhqY4bS
   RIcp4p/XmSJb0vXIV27ilDHPG21ZpYbrO181wFu+RbYUmUPXjHQri2eQF
   w==;
X-CSE-ConnectionGUID: juaNjUumRo6KIUZTY0mObg==
X-CSE-MsgGUID: k7eTs2XyR7y4d+PCoSe59g==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="75966700"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="75966700"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 12:18:28 -0800
X-CSE-ConnectionGUID: St8difwuSveFXGfK8AK6qQ==
X-CSE-MsgGUID: KB9gl2RZQMCDoE9XTgngJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="190946932"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.179]) ([10.125.109.179])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 12:18:27 -0800
Message-ID: <865c6cc0-f876-42cf-97cc-7b892192f3fc@intel.com>
Date: Wed, 19 Nov 2025 13:18:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 09/17] nvdimm/label: Export routine to fetch region
 information
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
 <CGME20251119075323epcas5p369dea15a390bea0b3690e2a19533f956@epcas5p3.samsung.com>
 <20251119075255.2637388-10-s.neeraj@samsung.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251119075255.2637388-10-s.neeraj@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/19/25 12:52 AM, Neeraj Kumar wrote:
> CXL region information preserved from the LSA needs to be exported for
> use by the CXL driver for CXL region re-creation.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/dimm_devs.c | 18 ++++++++++++++++++
>  include/linux/libnvdimm.h  |  2 ++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 3363a97cc5b5..1474b4e45fcc 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -280,6 +280,24 @@ void *nvdimm_provider_data(struct nvdimm *nvdimm)
>  }
>  EXPORT_SYMBOL_GPL(nvdimm_provider_data);
>  
> +bool nvdimm_has_cxl_region(struct nvdimm *nvdimm)
> +{
> +	if (!nvdimm)
> +		return false;
> +
> +	return nvdimm->is_region_label;
> +}
> +EXPORT_SYMBOL_GPL(nvdimm_has_cxl_region);
> +
> +void *nvdimm_get_cxl_region_param(struct nvdimm *nvdimm)
> +{
> +	if (!nvdimm)
> +		return NULL;
> +
> +	return &nvdimm->cxl_region_params;
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

