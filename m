Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A737B3FE
	for <nvdimm@lists.linux.dev>; Fri,  2 Oct 2026 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790964446; cv=none; b=F2lXMUfKTNpSwrGf+1WdSncJJB3pZW20azyV0YY/dOl9nA5c25WNCMNEp450CxTcIFDdrFG4qH50lBFtxu9O8CiDmwKoh64hp+7SRKvR93/9jPnKx8PC4fJsUrItA7NMHism8sqKjrLtZIgWJcS2rmhr1gN6MsMUvwfWuaPBULE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790964446; c=relaxed/simple;
	bh=XFig6Nzk/qay+yzXKRTTHOWA4sYlWhCCmfJYk7q06r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tn2l7HozighjbtcusF4TL97CmugQhybW9BpdDw1a3Wd++N3qcf90F1Y7MBDRvn5VyRpva1CJquEo5XjG04YlC9kJwTqLZ4Ne8/QeYmRi8+pwSph+as281D3jK/pacSpHIDY70K2RnoW7HHWCZRVYtNSNQqY+zh8f9NDCWd3SGnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VWArI16b; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VWArI16b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790964443; x=1822500443;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XFig6Nzk/qay+yzXKRTTHOWA4sYlWhCCmfJYk7q06r8=;
  b=VWArI16b7Oo9LlXqkJCDxEswl/OTMHQoTUOrMctrqKjEhmIPId5UlRoU
   U8K3fFHJMIaOoZxnJyZRZQaykbYLxI/6j7HMWFL4VcXMW6BiS2npr0Zjb
   dDtQ9kPlyuEU3++S1L2aflPRruGkTw2f7jUC+B8cSCH4ClsjaAz34WISG
   6TTgvEOVIajzxZBoD5B+m5oMwDwHsHz165g/Zes+eYBP1gbk1BGF1n6rG
   +B1ZPFt4ujfezXWFnnqTpVyYAZ8P4uDxURd1jHSReTWS3jNBTeED2aPzj
   cCbcJnkBt8UDNAhaBj4gTwptyd0M8fxZnz0jF+TBQmEszoKM3udN3Mott
   w==;
X-CSE-ConnectionGUID: PkUvTUDnQXKdUqxPeVC7cw==
X-CSE-MsgGUID: ccrKIQw3TNKWS45IYPuXyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11923"; a="90591910"
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="90591910"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 11:07:17 -0700
X-CSE-ConnectionGUID: U8Kpr0tRSUuQcz9T1aisDQ==
X-CSE-MsgGUID: NTgZ+SUoRsOJt2pKpLXQAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,136,1787036400"; 
   d="scan'208";a="284363493"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.108.45]) ([10.125.108.45])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2026 11:07:16 -0700
Message-ID: <82cdbae9-0009-4286-9ca0-5f83100bf07d@intel.com>
Date: Fri, 2 Oct 2026 11:07:15 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libnvdimm: Handle negative return from
 nvdimm_clear_poison() in nsio_rw_bytes()
To: Serhat Kumral <serhatkumral1@gmail.com>, djbw@kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com, iweiny@kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, error27@gmail.com
References: <20261002165641.14479-1-serhatkumral1@gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261002165641.14479-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/2/26 9:56 AM, Serhat Kumral wrote:
> When nvdimm_clear_poison() fails, it returns a negative error code.
> However, 'cleared' is a signed long while 'size' is size_t.
> The comparison 'cleared < size' promotes 'cleared' to an unsigned long.
> So the error condition can be bypassed and the function can
> incorrectly return success if the subsequent flush succeeds.
> 
> Explicitly check for negative error codes before comparing with 'size'.
> 
> Fixes: 868f036fee4b ("libnvdimm: fix mishandled nvdimm_clear_poison() return value")
> Assisted-by: LLM
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/all/90d3d353-28e9-4f6d-b141-a9b7157d5514@moroto.mountain/
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Makes sense
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/claim.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 309cd2cddb0e..2725dceaf938 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -263,7 +263,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
>  			might_sleep();
>  			cleared = nvdimm_clear_poison(&ndns->dev,
>  					nsio->res.start + offset, size);
> -			if (cleared < size)
> +			if (cleared < 0 || cleared < size)
>  				rc = -EIO;
>  			if (cleared > 0 && cleared / 512) {
>  				cleared /= 512;

