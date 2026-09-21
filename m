Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95644FD29C
	for <nvdimm@lists.linux.dev>; Mon, 21 Sep 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017118; cv=none; b=XE5+nSueq/m8XTsFyVVQGBz5TkiNv6/Ey3BnMJekvla+I53iEYE1yLXGcxKA9uob6hZlrMYbJn0J9RaiaDB4GMNGDyOuCvJlYbttk/mN8xN1+9YsLzRN3NKn777xl9P9bA/aTSQD/gZNlmh5EKtBkQxsjJ1tHpKsqdG+o1UhWFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017118; c=relaxed/simple;
	bh=ikqg6fvJPObgvXDP5h1Edz9whuIo9BoiKYzwPVVxIAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jj01NEsMMFpU5+nLKUjd9/iP1Zy1Goh79ZppimX/VziK0yQTkFYnfXq2sAdsVNsGTOvF9rNpVKxWC3b1GKMZ6GP3jQMfv98YlJBrsSNNnY2AritcWaH1djrJrADFrg4296wjqDgwrkSyiZmj9Jrlv11KhKpveXT0eOeqcLuFoqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcKbadH0; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcKbadH0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790017118; x=1821553118;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ikqg6fvJPObgvXDP5h1Edz9whuIo9BoiKYzwPVVxIAM=;
  b=NcKbadH0FKFTFyYfdb91cc3RLqTwEh52sD0jkXD7h4v0TYhGb2OTHedt
   7jnfIOjT4qtqQxl+LY+oSelWnX6iNksWzQDYyf/UOEmD2ThADJRp2iqn5
   yGTKyqGG4zgMv/H5VX3+MSHAXFiHBXnQ2qztgK51ZCbutUeLMVNh+f2dR
   PI5UVGzzKOBdql3TWR2nPNG7MtdQgNsxVQoxgZMmlt9LPP29LW6D/5nwh
   UjztOF91DhtC4zmeg9LQO+GJIXbOL2KVcqXEspSj41aFgrsakM+LWbtqz
   1W6k6pEleW2cTEnTy6/SGkYkwxuVZA4+Dks8FftEFCJb8I+9mHDrVBZSf
   Q==;
X-CSE-ConnectionGUID: 93MgBj+mRgK+FTZvQBod1A==
X-CSE-MsgGUID: mptLR9cXQwyqFJeBLQ8zgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108058907"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="108058907"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:58:37 -0700
X-CSE-ConnectionGUID: W7jz/Ex1TUuDXvj9cIIxOQ==
X-CSE-MsgGUID: +nnLNNXOSFSQhluTvwzfyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="280861104"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.109.234]) ([10.125.109.234])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:58:34 -0700
Message-ID: <2a2df8f0-ec31-4350-b1ef-3bdd2a76948e@intel.com>
Date: Mon, 21 Sep 2026 11:58:32 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dax: Fix Device DAX range allocation validation
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Joao Martins <joao.m.martins@oracle.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260915095621.3744167-1-songmuchun@bytedance.com>
 <ab129288-17e8-440d-b544-70ada8925cf0@intel.com>
 <0F332745-D70F-4C51-A597-50C1CAE53CCB@linux.dev>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <0F332745-D70F-4C51-A597-50C1CAE53CCB@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/18/26 10:03 PM, Muchun Song wrote:
> 
> 
>> On Sep 19, 2026, at 01:02, Dave Jiang <dave.jiang@intel.com> wrote:
>>
>>
>>
>> On 9/15/26 2:56 AM, Muchun Song wrote:
>>> While working on the HugeTLB Vmemmap Optimization (HVO) generalization,
>>> Sashiko reported that memmap_init_zone_device() could be asked to
>>> initialize struct pages with a large-page order for a physical range
>>> that was not naturally aligned to that order.
>>>
>>> Following the Device DAX call path confirmed that the condition was
>>> reachable. Device DAX range validation checks the range size, but not
>>> its start address. An unaligned range can therefore reach
>>> memmap_init_zone_device() after the device binds, and a subsequent write
>>> to a userspace mapping may trigger a kernel panic. With the help of an
>>> LLM, I was able to reproduce the failure.
>>>
>>> The automatic resize path has a related problem. It can split an aligned
>>> size request across arbitrary free gaps, consume an unaligned fragment,
>>> and leave the resize partially applied when a later allocation fails.
>>>
>>> This series validates both the start and size of every Device DAX range
>>> and makes automatic resize account only for usable aligned space. It
>>> also fixes the mapping sysfs attribute to propagate validation failures
>>> instead of reporting success without allocating the requested range.
>>>
>>> Muchun Song (2):
>>>  dax/bus: fix Device DAX range alignment validation
>>>  dax/bus: fix mapping attribute error reporting
>>>
>>> drivers/dax/bus.c | 144 +++++++++++++++++++++++++++++++++++-----------
>>> 1 file changed, 109 insertions(+), 35 deletions(-)
>>>
>>>
>>> base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
>>
>> This commit does not exist in Linus's tree. Can you please base the series on top of the latest 7.3-rc tag so sashiko can look over it? Thanks!
> 
> Hi,
> 
> The series is based on linux-next 20260914, and drivers/dax/bus.c is identical
> between that branch and the latest 7.3-rc. Sashiko has also already reviewed it
> here: [1].
> 
> Therefore, I didn't quite catch your point. Are you expecting Sashiko to conduct
> another round of review based on the 7.3-rc code? (Are you concerned about issues
> introduced by the additional commits in linux-next compared to 7.3-rc?)

Ok that's fine. But next time please use a tag that's valid from Linus tree and not linux-next. While there's a sashiko link, I'd like to see the sashiko response on the mailing list for easier review. I'm not sure if it's due to the base commit or something else for it to not show up. Sometimes sashiko responds with no regression found and sometimes it just does not respond. I'm not sure why the varied behavior.

DJ
 

> 
> [1] https://sashiko.dev/#/patchset/20260915095621.3744167-1-songmuchun%40bytedance.com
> 
> Thanks,
> Muchun
> 
> 

