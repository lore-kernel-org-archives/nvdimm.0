Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D67DA8C
	for <nvdimm@lists.linux.dev>; Fri, 23 May 2025 06:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747980028; cv=none; b=PsAZ52HuFFUjmjY/N1Qc/HcXQUVY/OIFp44K37CJcgHjntNsCSTI01eM9pkZD67LB7cuyHacc76mCWksEQkutl9PtHKGIM1fzk/7cK+prM3eV8Yl/H3K8EbJN8PqHAXw6JDyIYa0FBFtfithp3fUtMb4KUy0wVln3+Xl9moZRFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747980028; c=relaxed/simple;
	bh=O5q9Sg68tfPeHqMn3mC/eaNSosBn6I+CRfSPGfxGJhs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ZvGrOdAgeJRNvnngPfKk/4TNfGwLnxQWav5NH3ZyI40SWEx9r3s83x0p2JPGRezSs3R3ohV0Y1mL0JYRjpNfehDbXljSbhNIMwIzvltJJwoIqRWknI6N0KH86Dz9JBx+pqpevCSqRRXrP9ubLH2B1QfyA6WhgjhPa/RPpERby/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XVZmbmFT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XVZmbmFT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747980027; x=1779516027;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=O5q9Sg68tfPeHqMn3mC/eaNSosBn6I+CRfSPGfxGJhs=;
  b=XVZmbmFTfc5MaguddSlVrySriGrDIAcvdFXxVx5Jp4ancTbub/GbjxV3
   DeAWZNwJ6OZ4Qa98RBekUyz74ubzwUbU/kIUxgbj2j731pIynq3yOSGCD
   LP5p+96a12NX8o6AAoAiFdh6+POWgH28CCdfGc+W1tIfJi9nWMG1i+aLG
   LHVpjGtywBl9SkgI4qO0k4wHv/cuy68Am3gBbu7YFV3mBjn0/B953K8eD
   YqvSoxtu8nuS2+DeCi7ARfWKEgOf95P2MjfV3IfE7fIPi051Fos4LX5+A
   K+zAxEUY8CUIR7P8z6CArRTYCB1087fAho2SpnwBE4MatvhCt7+GPMhJU
   A==;
X-CSE-ConnectionGUID: CwNm86/GQfqH2qokOq2KQw==
X-CSE-MsgGUID: 0L8CugmdSj+EXdsjeOScGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="67441353"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="67441353"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:00:27 -0700
X-CSE-ConnectionGUID: WSDZx+J2RT6NwkW4yJxQhQ==
X-CSE-MsgGUID: KZnp0lF9S7atk2jTurRIvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="141398279"
Received: from lamonsox-mobl1.amr.corp.intel.com (HELO [10.125.63.139]) ([10.125.63.139])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 23:00:24 -0700
Message-ID: <d4ac98ba-bfea-40b3-a7b2-99e1bac5bb41@linux.intel.com>
Date: Thu, 22 May 2025 23:00:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marc Herbert <marc.herbert@linux.intel.com>
Subject: Re: [ndctl PATCH] cxl/test: skip, don't fail, when kernel tracing is
 not enabled
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Language: en-GB
In-Reply-To: <20250523031518.1781309-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-22 20:15, alison.schofield@intel.com wrote:
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

Reviewed-by: Marc Herbert <marc.herbert@linux.intel.com>


