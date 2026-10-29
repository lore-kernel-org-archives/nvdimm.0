Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316262;
	b=A+wbelGMMRUlA1eTC6cK8QekwRwJjseFW/CBNDAho4EbOKhonmioQ9HXsfC1ALTUpV4N
	 NxjfmpQ+3Konhogfu0KFr8NcH86hOM3vx5823cWW9uv71A5mm7BhbVzbzLHgaudUvPjOy
	 7GdDYKIzQWZCGetLmR9Z3L1V8Xi4aMDJcDD3iMEzB/g8oh4TaVRPvc7QgnlStEa6MTxiW
	 rWe11hhjYYFljNNjP46rQZjzFnTWKmZPGNTi5kusqINn+U/lp4MdeqdAsGSzbCLLsF/Xm
	 RrNKxtkRvfbawqp/KutztPX7IA60JSBtlLSY6hO13t8WGjYqU/wzWkJhFIVRX31l4zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316262;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8f9ZBdMVQW4mmfFauS+BVUyxFj/jQypVe9FJyIeo+Tw=;
	b=XvTLObJJilEtywid/RkqtPuPuewAe5ixFhzuG8CVQrtkeTMNTFpnR4NpSqMpLXr5L1b8
	 Xnc4Cfm+V6fkXrz56LoEZBSaKGJwsmB2uJBDm1Fq127YxAxXuqevYc1utdhz3K2qPKFdX
	 dMcwK4ShT4XGK+EFAvL5FGYqOAXbcrL4m53zszLLJvP7nQxzgSpXGydpn1CSp1apm9WeX
	 Bhg2Vxo2T2vK6N7eklUcn4QBB5B9fyOGqBpdnf1K5eqhCv47jBpsym0YdFzMngWxKHIV9
	 Kf+wa+YEYZFQFJX6xk+UJtDNsHr4B71uick2F4nHgASL3pZpgASU2tzdqo2DGyXLOpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Z3PkviFb;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D3F606A31C
	for <nvdimm@lists.linux.dev>; Thu, 29 Oct 2026 23:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69D3F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Z3PkviFb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793316260; x=1824852260;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YSL7E0vKjiXmr3Ikc4rkIPbJE68pnktLhZ6bpfmPsZA=;
  b=Z3PkviFbCxYvYz/VTMDVtGTl4KpXskiR8VNE4CmQTuBVR0QxcoytKfJL
   FMcjNYyE/T9V7lvgyqLj5n6qg3RrpjDgtIR2Rhqa93VBxbThHchf0uNJL
   pVD8pXQsJ+ukpapUq0ovH0rUOfh+8DpN8ZPc5X/+Ei42NMUouG1gaVmsE
   3vxK8xTprFt8LsWtfM6W16rGH28N7fxL/TupHyckjPRh0XZOcja/U3nry
   VzpT0wBLN/oxR0HWHoSa5KKHtQPqDFdGnH8mq5+1MMFX2q7xqim8PAeBX
   5wx7pPrI8HHAIowT9cu6jnaquBGR3J3JbfZgYCrXF4CyrjrI+aIpG86D5
   Q==;
X-CSE-ConnectionGUID: jSz5lqwgSpiQ+64Xt2iYtg==
X-CSE-MsgGUID: +0a9/sdNRJWXpK9QKE/onA==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2106308"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2106308"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:24:19 -0700
X-CSE-ConnectionGUID: 1xwoRYdUTyGLZ+RYNr39oQ==
X-CSE-MsgGUID: FzbuH4OnQ6u+RXNYURCdbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5159518"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.28]) ([10.125.109.28])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 16:24:19 -0700
Message-ID: <8a66bf6c-e0d8-4282-a279-4e2e6884a5f7@intel.com>
Date: Thu, 29 Oct 2026 16:24:18 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] libdaxctl: check the zone of onlined memory blocks
To: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev,
 alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org
References: <179322248318.3398847.13424413341337264007@gourry.net>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <179322248318.3398847.13424413341337264007@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/26 2:21 PM, Gregory Price (Meta) wrote:
> daxctl_memory_online_with_zone() is meant to scan the device's blocks
> after onlining them and fail with -EBUSY if any block is not in the
> requested zone: an agent such as an auto-online policy or a udev rule
> may have onlined some blocks first, into a zone daxctl did not ask for.
> online_one_memblock() relies on that scan, it ignores a failed write
> for a block that someone else onlined ("There will be a full scan for
> zone correctness later").
> 
> But daxctl_memory_op() returns the number of blocks it onlined, and the
> function returns early on any non-zero value, so the scan only ever
> runs when no block was onlined at all.  Whenever daxctl does online
> memory, a zone mismatch goes unreported.
> 
> Example: 
>   memory_hotplug.online_policy=auto-movable
>   reconfigure-device --no-movable -m system-ram
> 
>   => reports success with the memory in ZONE_MOVABLE.
> 
> Return early only on errors, and return the number of onlined blocks
> after the scan.
> 
> Fixes: 0542201b5902 ("daxctl: detect races when onlining memory blocks")
> Signed-off-by: "Gregory Price (Meta)" <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
> ---
>  daxctl/lib/libdaxctl.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
> index 01b1915..f4b2fda 100644
> --- a/daxctl/lib/libdaxctl.c
> +++ b/daxctl/lib/libdaxctl.c
> @@ -1691,7 +1691,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  	struct daxctl_dev *dev = daxctl_memory_get_dev(mem);
>  	const char *devname = daxctl_dev_get_devname(dev);
>  	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
> -	int rc;
> +	int rc, count;
>  
>  	switch (zone) {
>  	case MEM_ZONE_MOVABLE:
> @@ -1704,8 +1704,9 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  		err(ctx, "%s: BUG: invalid zone for onlining\n", devname);
>  		rc = -EINVAL;
>  	}
> -	if (rc)
> +	if (rc < 0)
>  		return rc;
> +	count = rc;
>  
>  	/*
>  	 * Detect any potential races when blocks were being brought online by
> @@ -1724,7 +1725,7 @@ static int daxctl_memory_online_with_zone(struct daxctl_memory *mem,
>  		return -EBUSY;
>  	}
>  
> -	return rc;
> +	return count;
>  }
>  
>  DAXCTL_EXPORT int daxctl_memory_online(struct daxctl_memory *mem)

