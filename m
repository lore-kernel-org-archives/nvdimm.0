Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD967E788
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 21:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191789; cv=none; b=XA+rDuK5nFhxezn5c5ADsW294t5mA/sy6t+WIEz0nh4XiZi4oEZPwA2TzzOHKnfEZGBS9h5iRpEMou3HImIza6jdjvtxqkqDpTXZ4caP89Vrh4dx+X1/5aiG9pqxPmj19v/ITJaYi3oBnJxNM7/02Es6VSpEGsuk+jsTMyPrJ2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191789; c=relaxed/simple;
	bh=WqscfjGXLnyl7xveDeQPMUUqJSVXKe6TN/Iv47P7FbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HThLpIux23MHH7vp281n2r8W7p/aXe686OCkTHrtzwLujr1ea8I02CjVRLe4B7TZUyZKvcTLrdwzjSHHMz+ZaW03+GWR9I6udcy0TO7YesT4A/5LGBXXYwkWj0vC7lfuc27bqOqxIvlrzmoE/RUXF5sUcflMXQUDN8PzNIrCpG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcPn+NID; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcPn+NID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717191788; x=1748727788;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WqscfjGXLnyl7xveDeQPMUUqJSVXKe6TN/Iv47P7FbE=;
  b=kcPn+NIDL0LEjCh2bpf2xUQ4gCNs3rxFbzjZRtDYq0mHpKxtOsUbgw2c
   oEjxfsPnMYiKSWWWoljg42ypqp6GEXIjQqxJdstM5I8MYu3Xntt57qBei
   jtpVoHQY5pl5SgCwuwpm3zymqTsevDqg2IYKIkJMpeGDXUEioYK3a605a
   RfBMHpmUFdCjx+RSxwu7ewervtymNIJfh9HM3tBKiTUqQYXdohQJj7afQ
   Iccrnc9BdVImLRTicfTMl3MmPS/24sX2gaQEU6WXWgNgQvv6OnKSdT5ya
   kLNjtTJ8HzhjmEpboVGGm1U9V71/kreZKylN07qVSu97Zj12MNiFdNHSj
   A==;
X-CSE-ConnectionGUID: Ze1Piq4iS3Sybf5Ykb3m/g==
X-CSE-MsgGUID: 7r9yvmhlQXa6BllVvO2RzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="25156403"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="25156403"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 14:43:06 -0700
X-CSE-ConnectionGUID: Uc0xFj2RTWK4oHUeXcSRWA==
X-CSE-MsgGUID: 4Yq3EwD1STu4dvCeFqScBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="67131570"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.21.184])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 14:43:06 -0700
Date: Fri, 31 May 2024 14:43:05 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v2 2/2] daxctl: Remove unimplemented create-device
 options
Message-ID: <ZlpEaV9F6fXKv2Vm@aschofie-mobl2>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
 <20240531062959.881772-2-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531062959.881772-2-lizhijian@fujitsu.com>

On Fri, May 31, 2024 at 02:29:59PM +0800, Li Zhijian wrote:
> RECONFIG_OPTIONS and ZONE_OPTIONS are not implemented for create-device
> and they will be ignored by create-device. Remove them so that the usage
> message is identical to the manual.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

The net effect of this is a correction to the usage message.
I think that can fit in the commit msg with something like this:

daxctl: Remove unused options in create-device usage message

I'm not familiar with this style of patch 2 being a reply to patch 1.
Is there a reason this is not presented as a patchset?

Thanks,
Alison


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
> -- 
> 2.29.2
> 
> 
