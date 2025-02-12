Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5422139DD
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739376690; cv=none; b=nBfbWllNr32apsP/AlzBU4KRLBW5lAVIffPAuPH6TqCsmSlej/XhnyV2b+ThT+NKvyiap3lW8c65DnxaqtQ88qOWpTKEsofKuB8sVHGi5iFWRwpEJAbzCVfk3O+ROihg7MfXdIelA8egDutNTpJ9+fPv3I08+GxdZhmvyaa5gNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739376690; c=relaxed/simple;
	bh=f/pn24PzY8l0VWKwAxlI0+73uRQjNXaVt+5rEYWDaG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWB2toAV2RPERdSdAzyC9szVJLuSQuuvyWvRiRS2JQRYWifkT6rZ9mWRTa73LUu8jKExkwDg4cAveaL34emnnw0WYp8B+c85FsCtzYsVIF4r6Cr4wNzVMPpuMT0mnRxEvV/5nXaaRMeGCZqrH/ZOe69iZTWULsnqQ/MeNpijj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DN8CvMak; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DN8CvMak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739376689; x=1770912689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f/pn24PzY8l0VWKwAxlI0+73uRQjNXaVt+5rEYWDaG8=;
  b=DN8CvMakgy9Eb+Ziqw8YTQJWZhg5ch2rT92U+nCBTyRvyi4XjC2pu8WM
   W1CSfpZv4X2pkiKUPnJiz1X4QLmdBiz26fgv9Zeu5SZLHR7Lr6djzysRa
   lZHVcn0t6t8RDANwGpXX6fo+cuYz1ochjt/y5zITmjW8gUhZufECC1OSS
   mvRXoOrsW/X/KA+7w/mKngP26y+KgmDM8nk1T9OdnmStpWr4Y3fqfrHoC
   95UhiU2ZHUli+G1vSzo14fe4GkUXLU/kagZSp/qyzd0zgKi5s2xgib4gD
   DeqmOu3Saffj/Xe90ScfEDwjlQMHlOtR0KTi2I5eFhRAjlTzXQKP7gCAu
   w==;
X-CSE-ConnectionGUID: zZyuSaqZRMiIFjmkTwqGtA==
X-CSE-MsgGUID: lIv3LaVaT+ChTlByVwVeJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="40075379"
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="40075379"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:11:29 -0800
X-CSE-ConnectionGUID: 6mhSbArgTNiuQzQ0ueDWUg==
X-CSE-MsgGUID: o5WAe5NQTJG6FHmcepLH8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="112827411"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.128]) ([10.125.108.128])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:11:28 -0800
Message-ID: <b85a9137-64be-4586-a365-e0028305291a@intel.com>
Date: Wed, 12 Feb 2025 09:11:27 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/json: remove prefix from tracefs.h #include
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
References: <20250209180348.1773179-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250209180348.1773179-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/9/25 11:03 AM, alison.schofield@intel.com wrote:
> From: Michal Suchanek <msuchanek@suse.de>
> 
> Distros vary on whether tracefs.h is placed in {prefix}/libtracefs/
> or {prefix}/tracefs/. Since the library ships with pkgconfig info
> to determine the exact include path the #include statement can drop
> the tracefs/ prefix.
> 
> This was previously found and fixed elsewhere:
> a59866328ec5 ("cxl/monitor: fix include paths for tracefs and traceevent")
> but was introduced anew with cxl media-error support in ndctl v80.
> 
> Reposted here from github pull request:
> https://github.com/pmem/ndctl/pull/268/
> 
> [ alison: commit msg and log edits ]
> 
> Fixes: 9873123fce03 ("cxl/list: collect and parse media_error records")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  cxl/json.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 5066d3bed13f..e65bd803b706 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -9,7 +9,7 @@
>  #include <json-c/json.h>
>  #include <json-c/printbuf.h>
>  #include <ccan/short_types/short_types.h>
> -#include <tracefs/tracefs.h>
> +#include <tracefs.h>
>  
>  #include "filter.h"
>  #include "json.h"
> 
> base-commit: 04815e5f8b87e02a4fb5a61aeebaa5cad25a15c3

