Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D31779BD
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187830; cv=none; b=K4xNkhDIcxGM+pKqjLJmjhQ/Srf366/RkiD/ksIeSy2/TLTpLsez5He1FQRurLoL35rGRarpSIJ+tWG2o/G/MaXO1KT65+v6Si8IxCDrycN72bSVfT4bH/v8bBM3k0JGXIC8/oiUKuHQZIMiNmf9UlGS0MwMjn4X62BOvqeGoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187830; c=relaxed/simple;
	bh=mmY2LrmBWg2BKLKsjtz8f5WAQ4H/Yg1mVMFN+g63dpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WEvQRvobb2uEHwDWwAbdLJ4g8fIoCXaw85FPx8MeEXAnlRIdRb+gmck+AEDfYXrJ0b64Kr8ezXwD5i+Gt+FVystC+RA31EDBvp/MWTQh2VqIoGy0huXfa3D5OJaO07nZQarNci8n7lB/T7aqWN6pu1s2obEluNO/iJoE1fCTnLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HU8rHYBO; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HU8rHYBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187829; x=1748723829;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=mmY2LrmBWg2BKLKsjtz8f5WAQ4H/Yg1mVMFN+g63dpE=;
  b=HU8rHYBOrxVUWUW8dth2VJ4rflH19nDslHSLm8Pz98EY/Zmo2XANlrkv
   kjhVb7kr8vlLteW9I+wte5xr6F5JUGT9W8TVemb4Yoi7VdhIa6ltZqgX5
   SoCcYg7GQPwYcsw+TWjiSHJP4IBPkgxzJkN0QLS19LqYj4pvESrI2RZXb
   OzdubYpSRYdi03yq03PTDEkZ6Pzt298JUIKiQcdKSuRfYvaRstROMe1ov
   VmBntMEypjCpRCDXCgb31/zShYSjuexvRcVOQUEjjSWqucvazJoZiJeW0
   ssEshhAnepAUGjgCqLi1fWP64SjaSnO/G9LiKfULv0uNQqAhU2B4C7UPI
   Q==;
X-CSE-ConnectionGUID: sGfFhgy0S9yov836Xj85ZQ==
X-CSE-MsgGUID: 71B7b0DPT+C9KHMgA9C8FQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="11845078"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="11845078"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:08 -0700
X-CSE-ConnectionGUID: CFhBCld9QyqaO1QD8Fyl0A==
X-CSE-MsgGUID: F2UI3CqVTbCpz48yO9cNiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36361146"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.108.72]) ([10.125.108.72])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:37:08 -0700
Message-ID: <b3af86b7-b2ce-464b-92b4-70e10a283b15@intel.com>
Date: Fri, 31 May 2024 13:37:06 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
 <20240531062959.881772-2-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240531062959.881772-2-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/24 11:29 PM, Li Zhijian wrote:
> RECONFIG_OPTIONS and ZONE_OPTIONS are not implemented for create-device
> and they will be ignored by create-device. Remove them so that the usage
> message is identical to the manual.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V2: make the usage match the manual because the usage is wrong.
> ---
>  daxctl/device.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index ffabd6cf5707..781dc4007f83 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -98,8 +98,6 @@ OPT_BOOLEAN('\0', "no-movable", &param.no_movable, \
>  static const struct option create_options[] = {
>  	BASE_OPTIONS(),
>  	CREATE_OPTIONS(),
> -	RECONFIG_OPTIONS(),
> -	ZONE_OPTIONS(),
>  	OPT_END(),
>  };
>  
