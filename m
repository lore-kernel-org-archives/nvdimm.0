Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6269D27A455
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750285696; cv=none; b=TVKfD7mt6EIXYcSq+uuzo+g+NoUXcOsrrlgviTdY8OnUaKd8hYPs4n2qprvzcUhQ1khrXzSZIojjjczhBfdochKGfriyYHMXZljDA5/4gGiEyjhFzwW3FInvSuvjuMu3h4VU0PO0KFxRnVNBmCDI9POJF2z0AWkrGxXzUJN1S3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750285696; c=relaxed/simple;
	bh=BasiFyjo/Y3pPAUsocvHAlNhid+2jH2n7D7aeY+4PtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WdO7UXjfgd1ePAiHIgiQSbKoyLnFjeiqJPuUv5TUpuH53tKedy3OFt8vflfexrTHjgyijWck9GkzXD8VHDqcWoEh4ioHbOllQRTAnzPP+ZK0UJ2kUmnnu6ZbtjgC3v2hf+Pi7s71Dr8XXjxROjzUL0Jc5tzhb4b669bwp3c2BM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IHlpp1mI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IHlpp1mI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750285696; x=1781821696;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BasiFyjo/Y3pPAUsocvHAlNhid+2jH2n7D7aeY+4PtA=;
  b=IHlpp1mI+LCakV3B1znADUYO+S94GpND9RwNg+q9EmkRN8ez+1RWe2n5
   xrDbeY70KYsEXhsL7G0lyOnzAGYsC9pTNjs4JRMoonEIcaKBTiAokdbQb
   6N7mGUnBDGBrGUAx2OSiBWuQttjY3tpV5pO5RpGr+VfNT0hAgZU5zqGkJ
   pN76Zn5dtdsJgQV+y/tCAvMI7w9H5G2Rbq5YZ7WDxV076eHtNFiekCOBv
   iH23IsPKAwJkRHlBUwgvgdTheNdQz+aI1tJLehB/t0eH2dIqad6oR3wZP
   cpFYHBaTdKhxXs7RyQ1tPi00JUjzo6sxqiyLl3f9m+VMjM92TjXLbESmN
   Q==;
X-CSE-ConnectionGUID: UhnczvlpTEOVKC2Lolgnyw==
X-CSE-MsgGUID: Awvj9wyUT9G93PkIOvqmhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52675983"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="52675983"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:28:15 -0700
X-CSE-ConnectionGUID: 91K68T3KQ2e+XLkn5jMlAQ==
X-CSE-MsgGUID: wl7PSpesRJy+CrGLgX+vDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="187545681"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:28:15 -0700
Message-ID: <fcdaa714-e366-4462-aaec-e62513d49d5a@intel.com>
Date: Wed, 18 Jun 2025 15:28:13 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 3/5] test: Fix dax.sh expectations
To: Dan Williams <dan.j.williams@intel.com>, alison.schofield@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20250618222130.672621-1-dan.j.williams@intel.com>
 <20250618222130.672621-4-dan.j.williams@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250618222130.672621-4-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:21 PM, Dan Williams wrote:
> With current kernel+tracecmd combinations stdout is no longer purely trace
> records and column "21" is no longer the vmfault_t result.
> 
> Drop, if present, the diagnostic print of how many CPUs are in the trace
> and use the more universally compatible assumption that the fault result is
> the last column rather than a specific column.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  test/dax.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/test/dax.sh b/test/dax.sh
> index 3ffbc8079eba..98faaf0eb9b2 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -37,13 +37,14 @@ run_test() {
>  	rc=1
>  	while read -r p; do
>  		[[ $p ]] || continue
> +		[[ $p == cpus=* ]] && continue
>  		if [ "$count" -lt 10 ]; then
>  			if [ "$p" != "0x100" ] && [ "$p" != "NOPAGE" ]; then
>  				cleanup "$1"
>  			fi
>  		fi
>  		count=$((count + 1))
> -	done < <(trace-cmd report | awk '{ print $21 }')
> +	done < <(trace-cmd report | awk '{ print $NF }')
>  
>  	if [ $count -lt 10 ]; then
>  		cleanup "$1"

