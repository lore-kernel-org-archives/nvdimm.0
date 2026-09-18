Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CCF50B8D0
	for <nvdimm@lists.linux.dev>; Fri, 18 Sep 2026 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750981; cv=none; b=FrfUN0l3oIN0kL2Ve0y2m1QyvkkhZBivSe4HnS+E+ntfVcSU/Dh1UDUayHLVZJRASubWFOGgfUpHIqOZlpyLPzlC7/lskbg867NwV2Cts7OXfkyrp4UzW36chDjQg8tRjawDIGvqbHTgMiadxkfXBSOCDTH9vyeBKdcByi2vK70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750981; c=relaxed/simple;
	bh=asQGZXBqPwc40v+1IHCxrKjtk5cmKY6XVm4QKcR3Knk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPrIuDXs+v2fUsAFKcZc6jS80I5NHMrf5/IU2D8kWlqJ1OcUf+XJPlFlU+JKOaXDSW4K2ty/jNID+UTuxH3kIqux4WLgDvPtQxGGxamIs+CXPmxGCMH6BhmgGkhGnIjk6EqjvlSsE4cO01mBqnecKTgsJs0h7IOhzXneIbofy2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kN0S1/ri; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kN0S1/ri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789750980; x=1821286980;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=asQGZXBqPwc40v+1IHCxrKjtk5cmKY6XVm4QKcR3Knk=;
  b=kN0S1/riN7A41eO4kBJQ/KGHw6j+Vbrk1K4P4TyQJqKiOb6cI/4DWF0u
   gDkYA3hg5pVtweicuZr8Z1u1queKE2Nj17XSKP2LF38anCzSVxchhq6t5
   +O5pmXApOW1BMDkD+73AWe6vIZSvST7EKdbGJ7zFmO5Edjy7zlgTHHX2y
   A2IQ2MT3R2sPSFmRVK9XNaG+7nClAO8ovfU68BkoSRt/iebz/TbawuxA3
   //92ed5C0JGN4OWKoR0CBrDE+VQV1zsxWObq5ZQTNE74sOUhzNcNCtvX8
   L6wPsjR8RYVWvUNY8zYl3igwOqsGglIVXEATXA65vzj+krrYtvSYc+hQj
   Q==;
X-CSE-ConnectionGUID: os7u8ZIpTpCRj1TW+idABg==
X-CSE-MsgGUID: FNZXRfSmTvGC8c+L7NIm9A==
X-IronPort-AV: E=McAfee;i="6800,10657,11909"; a="783464"
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="783464"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 10:02:51 -0700
X-CSE-ConnectionGUID: Zw2LwmXHQ7ySKFwhJmtFDg==
X-CSE-MsgGUID: x2GKyjZCSySyeDCzgcFzlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,109,1787036400"; 
   d="scan'208";a="2701457"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.109.117]) ([10.125.109.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2026 10:02:50 -0700
Message-ID: <ab129288-17e8-440d-b544-70ada8925cf0@intel.com>
Date: Fri, 18 Sep 2026 10:02:48 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dax: Fix Device DAX range allocation validation
To: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20260915095621.3744167-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/15/26 2:56 AM, Muchun Song wrote:
> While working on the HugeTLB Vmemmap Optimization (HVO) generalization,
> Sashiko reported that memmap_init_zone_device() could be asked to
> initialize struct pages with a large-page order for a physical range
> that was not naturally aligned to that order.
> 
> Following the Device DAX call path confirmed that the condition was
> reachable. Device DAX range validation checks the range size, but not
> its start address. An unaligned range can therefore reach
> memmap_init_zone_device() after the device binds, and a subsequent write
> to a userspace mapping may trigger a kernel panic. With the help of an
> LLM, I was able to reproduce the failure.
> 
> The automatic resize path has a related problem. It can split an aligned
> size request across arbitrary free gaps, consume an unaligned fragment,
> and leave the resize partially applied when a later allocation fails.
> 
> This series validates both the start and size of every Device DAX range
> and makes automatic resize account only for usable aligned space. It
> also fixes the mapping sysfs attribute to propagate validation failures
> instead of reporting success without allocating the requested range.
> 
> Muchun Song (2):
>   dax/bus: fix Device DAX range alignment validation
>   dax/bus: fix mapping attribute error reporting
> 
>  drivers/dax/bus.c | 144 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 109 insertions(+), 35 deletions(-)
> 
> 
> base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3

This commit does not exist in Linus's tree. Can you please base the series on top of the latest 7.3-rc tag so sashiko can look over it? Thanks!

