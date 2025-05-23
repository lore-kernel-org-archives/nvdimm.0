Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B44296FAB
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748018920; cv=none; b=aDYyRgAq4gAR9gJPCZ0aYwqGNjEhRHqGiVzg/VwCP6nyRvFIL49/YFQvRaMLjvhHEWsrErXn0MJvaxwoss6oDguX8ZW9hFIoxMGMfobjajeob1Y/ldHbh/wCqNLJhK7DkGmJL7+VGtQ9Kw+BA43/N1Apua/XVNRWkxp5tNDXDyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748018920; c=relaxed/simple;
	bh=iGuhuF506kQhvnhF3Qk/gCnGAIm1DbnxW0qgdDvwxQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NaIO0nSVYqlKsSRFx/EQhtwJgjn3PTmSsgkmup8tX3XAWfIJz7m9z9FfdCFeELiegMJvHFam7RKZxmh34K2Bc8UWzVWQ+BKkbNcGd7MdnSIz2TdJcxsJxAf9jkltPjyH4Z8wj1Dq7TtBG/Xxha5N9BR9sKEBxDi6DTCYmvorO4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ilm9b3xr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ilm9b3xr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748018918; x=1779554918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iGuhuF506kQhvnhF3Qk/gCnGAIm1DbnxW0qgdDvwxQ8=;
  b=Ilm9b3xrZhGoS44H+8Af5CZcPqn9lUc8tC004mPK7DanoKVRoEBUrrsz
   RPVv3d1b7ZEytyT/JO1omIi5NBUGWIqtYE9dCffUYxE+CO4t5KORP6i+4
   v1y8+twHi1l3CzWT/Vlf8ax6pInJ8kZa2ZQNiSsUveR3nefWp+udCq0jO
   GWnJZ4ZE0/BapEsU4PAUNjPW1l4SVCdE+4gX3j1AEWJSvNRN98b6AM8i2
   3hPEYxwH1mb/mO+SlUTyv8i+hZ91BOy0Lsla9uq1VDXlqk4x73pQ6NKQU
   BkwWY3jGFpcMCjml66yWzppYTpo5fIt96nTihxV1kw2x4tZ0AflaPVv5G
   w==;
X-CSE-ConnectionGUID: XMbXefEsTWajd0HCueT86w==
X-CSE-MsgGUID: e88THPWISnixKhORktoh9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="50005008"
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="50005008"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 09:48:38 -0700
X-CSE-ConnectionGUID: s5apd/ZTTpGX5ICSh9wrrg==
X-CSE-MsgGUID: j0XHaZ/CQPuYCi8OgGXx4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,309,1739865600"; 
   d="scan'208";a="142240499"
Received: from jdoman-mobl3.amr.corp.intel.com (HELO [10.125.109.152]) ([10.125.109.152])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 09:48:38 -0700
Message-ID: <6b045edf-ad09-4542-8eed-f85559571df5@intel.com>
Date: Fri, 23 May 2025 09:48:34 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/test: skip, don't fail, when kernel tracing is
 not enabled
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/22/25 8:15 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> cxl-events.sh and cxl-poison.sh require a kernel with CONFIG_TRACING
> enabled and currently report a FAIL when /sys/kernel/tracing is
> missing. Update these tests to report a SKIP along with a message
> stating the requirement. This allows the tests to run cleanly on
> systems without TRACING enabled and gives users the info needed to
> enable TRACING for testing.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> Noticed this behavior in Itaru's test results:
> https://lore.kernel.org/linux-cxl/FD4183E1-162E-4790-B865-E50F20249A74@linux.dev/
> 
>  test/cxl-events.sh | 1 +
>  test/cxl-poison.sh | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/test/cxl-events.sh b/test/cxl-events.sh
> index c216d6aa9148..7326eb7447ee 100644
> --- a/test/cxl-events.sh
> +++ b/test/cxl-events.sh
> @@ -13,6 +13,7 @@ num_info_expected=3
>  rc=77
>  
>  set -ex
> +[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
>  
>  trap 'err $LINENO' ERR
>  
> diff --git a/test/cxl-poison.sh b/test/cxl-poison.sh
> index 2caf092db460..6ed890bc666c 100644
> --- a/test/cxl-poison.sh
> +++ b/test/cxl-poison.sh
> @@ -7,6 +7,7 @@
>  rc=77
>  
>  set -ex
> +[ -d "/sys/kernel/tracing" ] || do_skip "test requires CONFIG_TRACING"
>  
>  trap 'err $LINENO' ERR
>  

