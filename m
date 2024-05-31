Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A846B82866
	for <nvdimm@lists.linux.dev>; Fri, 31 May 2024 20:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717187809; cv=none; b=hmCNuKZWRrLM/uuQOQY1B/6kYiN+GAHgPVt31BxFbvmgGWNtDwFWBHji0hv51D5md+hjGsMf+2DqzJ0gNP9bYupvu89lUsqvUvKzOQ+mOijjKZ95pdPAhPeO+HHja5JUWHxdhrjqI3IwnxVkrXVPfRtnE5KdTpZ/NpaOT/KnL0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717187809; c=relaxed/simple;
	bh=Dp/yUqGprWLRQy5zwsbHi9B9sr5XnoFw3W+So7ywG2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPv3h4/LdI1nVvPLiwO4hDGQWXDYddelzaS/GeRbRKl4XSC9Zw6hm+WZzyJezSumlj4iw+8eqQYpE7PcSXcIQrKVP5FxAnJMlQnG4Vl5jTaCuKn1gd50FFHUOJQDr3xNXOHwnBVqHtTpr/RWlRcjrl1+LWVzYU2VFNy8ZiFEGLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHC599ry; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHC599ry"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717187807; x=1748723807;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dp/yUqGprWLRQy5zwsbHi9B9sr5XnoFw3W+So7ywG2s=;
  b=EHC599ryQhIrVTqqP1aTR7gg7LmYCs1q3QEIoJl3hV/iry2aXXCJSI3V
   KwrjSYHXBn5lAoFnkWn4r5XHSp+W7G2D8AEO11b/QbLGI72jWGYeT7jPt
   BJgXafeU+H9AL5+MP9KosU8FcKQdQxOg35rFAcVRAOVfSqMCDFxzurCZH
   Vwwss1XbE0QSonOG9XV3kh083TWZxkuE8L9xEvwWoFcKmDYzNW4avQCnH
   SyzTb+F3uoqQLOdFp7OGzfyDM2FPvMbBQwRj626aO4IddOPk2U+7cO8hy
   fSjAet41YsJGmIv+OexiSYmnLtkaeVBqp/fCgbsDyQK7+Cz1OGEa4Dfwa
   g==;
X-CSE-ConnectionGUID: 4zMp2JuSR4qNemQMsY4D7w==
X-CSE-MsgGUID: XDw/aJphQ0uCXIgUJpl2OQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11089"; a="11845076"
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="11845076"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:36:46 -0700
X-CSE-ConnectionGUID: 7zdUsBwARpyHe6bBjKiKNA==
X-CSE-MsgGUID: Q/veI/iZS4yqhlRx2gHlSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,205,1712646000"; 
   d="scan'208";a="36361082"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [10.125.108.72]) ([10.125.108.72])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 13:36:46 -0700
Message-ID: <8f18afe5-a676-4c63-83ec-b3aa0f2fad1a@intel.com>
Date: Fri, 31 May 2024 13:36:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH v2 1/2] daxctl: Fix create-device parameters parsing
To: Li Zhijian <lizhijian@fujitsu.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: Fan Ni <fan.ni@samsung.com>
References: <20240531062959.881772-1-lizhijian@fujitsu.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240531062959.881772-1-lizhijian@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/30/24 11:29 PM, Li Zhijian wrote:
> Previously, the extra parameters will be ignored quietly, which is a bit
> weird and confusing.
> $ daxctl create-device region0
> [
>   {
>     "chardev":"dax0.1",
>     "size":268435456,
>     "target_node":1,
>     "align":2097152,
>     "mode":"devdax"
>   }
> ]
> created 1 device
> 
> where above user would want to specify '-r region0'.
> 
> Check extra parameters starting from index 0 to ensure no extra parameters
> are specified for create-device.
> 
> Cc: Fan Ni <fan.ni@samsung.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
> V2:
> Remove the external link[0] in case it get disappeared in the future.
> [0] https://github.com/moking/moking.github.io/wiki/cxl%E2%80%90test%E2%80%90tool:-A-tool-to-ease-CXL-test-with-QEMU-setup%E2%80%90%E2%80%90Using-DCD-test-as-an-example#convert-dcd-memory-to-system-ram
> ---
>  daxctl/device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c
> index 839134301409..ffabd6cf5707 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -363,7 +363,8 @@ static const char *parse_device_options(int argc, const char **argv,
>  		NULL
>  	};
>  	unsigned long long units = 1;
> -	int i, rc = 0;
> +	int rc = 0;
> +	int i = action == ACTION_CREATE ? 0 : 1;
>  	char *device = NULL;
>  
>  	argc = parse_options(argc, argv, options, u, 0);
> @@ -402,7 +403,7 @@ static const char *parse_device_options(int argc, const char **argv,
>  			action_string);
>  		rc = -EINVAL;
>  	}
> -	for (i = 1; i < argc; i++) {
> +	for (; i < argc; i++) {
>  		fprintf(stderr, "unknown extra parameter \"%s\"\n", argv[i]);
>  		rc = -EINVAL;
>  	}
