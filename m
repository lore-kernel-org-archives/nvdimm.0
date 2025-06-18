Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8383085DC
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285955; cv=none; b=GlQMA/V/WdSeKaNHYK7/igaTtbVMB3I6PNtgxJ6PlmEkrY3Z7ZdQHN6RjtZnEtzyL7XTCAkhiPFr/0nVtMCWQORIwPHatoahtt08JqvmodgwPPfGWoXd4k3fcxRMxEuWC798PeqDg+nyXsdRd91NKHH/M+w1Gcc5fK1xCPjSEGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285955; c=relaxed/simple;
	bh=2a4oskfwM/FVMIMW5M6z3dLZF8v+M/XWetjFJMiXV6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3JFflk5SKSMJfO37vUjiMDD2YR2IM6O/nhIW9+OlHkZqG+gffivI0xhTmPAe+QuQRIeBT90Ddexd7w+QUH5ntQN3jdGcJTpaxg/bAkaH13oWTAG1nx6OZHVkQoQsEtoYOMUbXFucTUhggd42+jzULGraIpwEdxnyvIKxty7yeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lZjyG6G0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZjyG6G0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285955; x=1781821955;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2a4oskfwM/FVMIMW5M6z3dLZF8v+M/XWetjFJMiXV6Q=;
  b=lZjyG6G001TRKjan1bx+z/+av1Uq/eP17v2bqcO9Bqendn2nSYV19IGj
   A0rqNp++75Gh46ss27jsNap3K05raAQayeExDW/wL4O2JhENoCt5LoKfg
   7tBOgiqGn/GepnufhOWlgLeDsJ3ymLCiaQpwAw/84im1OalXt5CWbhPVO
   o8X6wLbQjnpglAVYWaMsUfrqyNWSzjttfpjEcdzkC9XoWQt29g0CrsfGr
   EUaG5ARFGgqgv7kGnYJ+mx5ElxImTnBKKD5F/SRBmkQha1/jggUBNTpNJ
   ftVJ747jYFI17CQo1enk9j4IS4EVzXhPPecDhrFBl5qvX2hD5Q/JzkLaN
   Q==;
X-CSE-ConnectionGUID: JK6HTf6xQTqrTVg0mYooTQ==
X-CSE-MsgGUID: 2xMaHDApS1GnlZSXPyGaWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="40136615"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="40136615"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:32:34 -0700
X-CSE-ConnectionGUID: E77mcQ9EQQyy5NSPnM6tSw==
X-CSE-MsgGUID: 9FV4yzteS5Kcj5zByTnkIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150951837"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:32:33 -0700
Message-ID: <dff3204a-e4ef-434d-b8f1-b8f08cac2a4b@intel.com>
Date: Wed, 18 Jun 2025 15:32:31 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 5/5] test: Fixup fwctl dependency
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-6-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250618222130.672621-6-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:21 PM, Dan Williams wrote:
> Ensure the 'fwctl' test binary is always built for test runs.
> 
> Fixes: e461c7e2da63 ("test/cxl-features.sh: add test for CXL features device")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

thanks for the fix

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/meson.build | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/test/meson.build b/test/meson.build
> index 91eb6c2b1363..775542c1b787 100644
> --- a/test/meson.build
> +++ b/test/meson.build
> @@ -275,6 +275,7 @@ foreach t : tests
>        dax_errors,
>        daxdev_errors,
>        dax_dev,
> +      fwctl,
>        mmap,
>      ],
>      suite: t[2],

