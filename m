Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A5FEADC
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 21:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769205518; cv=none; b=iP0IqBgc3LIPTQQlWCub2q9RY8su9OnqvhExEXQqA6DhhvfskryGNky0q2jUDwjqAwET4KUhvidIPoDCWyKRZj2U49vAAWAtFZC976jheyW1pckKOdsWAAuZIFVfEC0M+mjT7ToGRomenAW3vlUU+Ju50dVPHgGxb9ud+IqDUUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769205518; c=relaxed/simple;
	bh=s+u4l9jgvCQsaB7wNxpg562iq5WlHBRtw+Cvbyn4kKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAH4IcJtu81qoc5oj100eor99is4sNP2hxSx4hj2d/y+qyWMCl81oofQ4JGK3ywa4Ri9E3A7eYIJhn+XY5B7cVolbWwwsdHvLTAKVT26e66sCaDJ//8+rj5QzxK9+1H0mO2GFEeO7Ou7KhO26r4CQJsdChuwkQKASjpvGWNgsSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ginA7Hwr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ginA7Hwr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769205517; x=1800741517;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s+u4l9jgvCQsaB7wNxpg562iq5WlHBRtw+Cvbyn4kKc=;
  b=ginA7HwrTMSsVbaXJ3bVaaa4OGULE8CO8AVKwiraRrTwEO3mPowOKmdD
   uumfY1dc9nQv4To21zbG4qGWIs9vp1MbwTjxvTx/phuGZeFEVtVIbgHVB
   LXKSyVb2U7EDRenn101p1IQMEPByuWl5VzVbER/oGisXJqX+15Q6SP+fO
   /8uKUoZxf/gGS7FRfQ8gccqKlte9SstJK8APTqnXzbzgLyDXb+yN8SiLY
   MF+0dqM6zA8R5QtBt4skfsibLSgN5LPExcdzcXG4Lm1HMA5Z4FWDDDtfp
   u2Gq8rYdFTYSXEt+ZtChMYwwJ7Q8ycvntnl/1uPRbMqzJQh6lNwwfVWwF
   w==;
X-CSE-ConnectionGUID: FPh/hVHrRSCIi52B1mLA1Q==
X-CSE-MsgGUID: IXgCL1ZZRLmTFwpkC4Nxdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="73050045"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="73050045"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 13:58:37 -0800
X-CSE-ConnectionGUID: uF4jqUrfQ4Stw3fSvpu8Gw==
X-CSE-MsgGUID: WAMlR/KWQCmNnHDa5MqcIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="207474318"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.108.225]) ([10.125.108.225])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 13:58:34 -0800
Message-ID: <52970d7e-287e-4234-9bd0-5c258b576872@intel.com>
Date: Fri, 23 Jan 2026 14:58:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Yazen Ghannam <yazen.ghannam@amd.com>, Davidlohr Bueso <dave@stgolabs.net>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Len Brown <len.brown@intel.com>,
 Pavel Machek <pavel@kernel.org>, Li Ming <ming.li@zohomail.com>,
 Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Yao Xingtao <yaoxt.fnst@fujitsu.com>, Peter Zijlstra <peterz@infradead.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Fontenot <nathan.fontenot@amd.com>,
 Terry Bowman <terry.bowman@amd.com>, Robert Richter <rrichter@amd.com>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Zhijian Li <lizhijian@fujitsu.com>, Borislav Petkov <bp@alien8.de>,
 Tomasz Wolski <tomasz.wolski@fujitsu.com>
References: <20260122045543.218194-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260122045543.218194-4-Smita.KoralahalliChannabasappa@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260122045543.218194-4-Smita.KoralahalliChannabasappa@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/21/26 9:55 PM, Smita Koralahalli wrote:
> __cxl_decoder_detach() currently resets decoder programming whenever a
> region is detached if cxl_config_state is beyond CXL_CONFIG_ACTIVE. For
> autodiscovered regions, this can incorrectly tear down decoder state
> that may be relied upon by other consumers or by subsequent ownership
> decisions.
> 
> Skip cxl_region_decode_reset() during detach when CXL_REGION_F_AUTO is
> set.
> 
> Signed-off-by: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>  drivers/cxl/core/region.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index ae899f68551f..45ee598daf95 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -2178,7 +2178,9 @@ __cxl_decoder_detach(struct cxl_region *cxlr,
>  		cxled->part = -1;
>  
>  	if (p->state > CXL_CONFIG_ACTIVE) {
> -		cxl_region_decode_reset(cxlr, p->interleave_ways);
> +		if (!test_bit(CXL_REGION_F_AUTO, &cxlr->flags))
> +			cxl_region_decode_reset(cxlr, p->interleave_ways);
> +
>  		p->state = CXL_CONFIG_ACTIVE;
>  	}
>  

