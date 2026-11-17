Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932625;
	b=ju8AvAuHF6cswsPUBElQSleSpSGMjM9bPPR6eq03htljCbtP8HHbVTB3DMwR/I6bCiKg
	 uMtnqd9ToRfI6G0fTsHDsVN6SsiZ5C9rK2D0m2b1EVAo3Gj4PrCNtXO9YW97cZP7QtUOk
	 h12MLEa17+8e25Ae8Dmyv429W33tJvA1imytOfZd4YTvcCw/ZcBeJD7Sy5tltVEXU5QJz
	 yT30LiCGdVluuW8LOSeaKJ9McOSibI7X700xv9i8K9UfJgv0WMl80gkXUUT1xmhwlYHcG
	 +Ep8qQcQoBJrTTBufp7EhV6TjDEYfzSb5/gIUVJ+r+rEC2uzsNI/VrIkpeEl16JCs5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932625;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:From:Content-Language:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Cg/PCTMOzBzkoURpiUkp4VmcxZowTYjNTya2EamO6RM=;
	b=we7qf8M5ir0N7AFKnx6PLrtse8/m7K6Tia677V0xhFuAkE55caQU/BLMxqwgSJm7THwG
	 a38AfYenxTBRXZe6RzvXlrbnJbnnuNKDHBx5+OXoU7gIgKaDlkuTu9UghGkywj/zl1Btd
	 E7+mw5Z1t/x+2JhKmLrnYJcIStcV1JmR8YJIrHCVJgW8XXuquUkIGaU9GKvKxoqCE/C1t
	 Wf6nJbGl6+cTeIb3nyUZj1MtfoYvZhq9M9ROvVHvSYhvKaCA4QCdnILqu2GyTpVDpwlrT
	 jbqse4dTo0wF865TMkzAM++eKUDk2Ig1EXq03tO+nTwKfJvON11Ne+LIQl4nGt2mSDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OKChianC;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35519606A32A
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 16:23:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35519606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OKChianC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794932624; x=1826468624;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=LGcp9EyDPdWKiDu/TJz2h/L2dNDJ9lWOdJLmD5/abkU=;
  b=OKChianCzNbBBf6kj4Wj4sEIDjjPMApm+F5fyNK5V//BuqhS1oH+LN5+
   qfxOUiikm75u4GRO9EJBHqc/84ly17xYCbzXljuysIiSXtmBDXuyAO5KE
   +jHuE639QYr8SteYd8oTLsdNuBjx8K+t8+/ZjhGFJKvv0yf37khI7zquf
   esUKLSL39vwYdhIWwzIXOFoHZGnR7CAFnGlKAEzUIw8vla85jXE44EHAT
   XdzaZalIb7Bg1jR+FB3ltL9uzkusHVq3KlFT/jVcAAjTeEAMgY/Ntn+5e
   WSvdDklliznJEorRkUY45LXSH72HiHwW0zrotFTbup+gwmcW6RGVoDYWJ
   g==;
X-CSE-ConnectionGUID: W2drOuaHTfKVs6kOGw//FA==
X-CSE-MsgGUID: g2bmYSmORGWoXCDyGmguBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3611492"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3611492"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:23:43 -0800
X-CSE-ConnectionGUID: LcN/8uGbS8apg540HDCeQg==
X-CSE-MsgGUID: xJv72SPOQrCHRUJegp4Axw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10196423"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.197]) ([10.125.108.197])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:23:43 -0800
Message-ID: <d8fe9a15-ad35-4f61-aa6f-da2dc2bf7866@intel.com>
Date: Tue, 17 Nov 2026 09:23:41 -0700
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
Subject: Re: [ndctl PATCH v3 1/3] cxl/region: round default region size within
 root decoder extent
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <cover.1791863817.git.alison.schofield@intel.com>
 <ac53ec453608b6cc2c42648c9441c50ac94cd4b8.1791863817.git.alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <ac53ec453608b6cc2c42648c9441c50ac94cd4b8.1791863817.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/12/26 9:14 PM, Alison Schofield wrote:
> The kernel requires a region size to be a multiple of SZ_256M * ways. The
> cxl-cli command, cxl create-region, accepts an explicit size with -s, or
> derives the size using ALIGN_DOWN(). The derived size is not always valid.
> 
> The calculation can fail in two ways:
> 
> 1) When the region interleave ways has a factor of three, SZ_256M * ways is
> not a power of two, so ALIGN_DOWN() is not valid for the calculation. The
> result depends on the root decoder extent and can appear correct by chance.
> For example, a 6-way region with a 3G extent produces the expected 3G size,
> while a 12-way region with the same extent is trimmed to 1G.
> 
> 2) At 16 ways, SZ_256M * ways overflows the int used for the multiplication
> and evaluates to zero, so the trim returns zero.
> 
> Compute the product in u64 to avoid the overflow and round down by division
> so that the derived size is a multiple of SZ_256M * ways. Return -ENOSPC
> when the root decoder window is smaller than SZ_256M * ways.
> 
> This was found while adding 12-way region test coverage.
> 
> Fixes: 2904504721a6 ("cxl/region: Trim region size by max available extent")
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  cxl/region.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 85d4d9bb54f2..9d727216b9b8 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -682,8 +682,18 @@ static int create_region(struct cxl_ctx *ctx, int *count,
>  		return -ENOSPC;
>  	}
>  
> -	if (size > max_extent)
> -		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
> +	if (size > max_extent) {
> +		u64 min_size = (u64)SZ_256M * p->ways;
> +
> +		size = (max_extent / min_size) * min_size;
> +		if (!size) {
> +			log_err(&rl,
> +				"%s: max available space (%#lx) is less than the minimum %d-way region size (%#lx)\n",
> +				cxl_decoder_get_devname(p->root_decoder),
> +				max_extent, p->ways, min_size);
> +			return -ENOSPC;
> +		}
> +	}
>  
>  	if (p->mode == CXL_DECODER_MODE_PMEM) {
>  		region = cxl_decoder_create_pmem_region(p->root_decoder);

