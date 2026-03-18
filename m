Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C130EF90
	for <nvdimm@lists.linux.dev>; Wed, 18 Mar 2026 21:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773870589; cv=none; b=oM0RuqNZNatwinndYu9Gh039LPq9skdfifbcEWN/iS7kinnMd9u9JdyL2ZhlQYMzNdWrze1IYwV5GfoqNFMiCudI/1o0ddMa0K5pbtXxBYXz+AQbGaU9H7uZzmHqQWJpMI9kkB764DE4KES3BLj3Q/grLxHsY1dBFnmHkUz0cuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773870589; c=relaxed/simple;
	bh=tVzCTvsvnQE/tUv8tGXNNxh8lVM+FFj3fY+dhEmwdIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a6djKl88cOLUP0CKBGBbA5woBui9HLky/fCJCk2gteucR32ZPkgtqdOHJcFwNkRIj5VAHgC45xBECS4tFy7djmTBWY5OpkeHx/K2GKBFrPSmSDUIzlwkNJcexaceEnrw9GTtySUYL9o+7RnTa5fmWsd/2C0pQMz69zsHr0KQSpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=alsBtoFq; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="alsBtoFq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773870588; x=1805406588;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tVzCTvsvnQE/tUv8tGXNNxh8lVM+FFj3fY+dhEmwdIw=;
  b=alsBtoFqyReM1hzGP9GnUZeMEq6DI8JNT+ivfLlLYrszSD14pQM8pSzf
   tUj732X+jLviW+vLWrHmGWnaC37s8XS0HtSg/iB5QGg4ogZs/hSNTzy+R
   L4U7lVTTtWRbZV2EvUatJH3QdvsMevkNVrrcDPL0nT0aN/BFD9EqlRMZH
   mqvunlX7nvFHBqvK2J6jkFb1cup1QMudfPo58mY/M8ZR+MJZbmfDb/UMN
   ox1pmIJyNfkWPgsMqUzt13SvkBme6ceEjp7Q82tfF3C45S0jYI6vIHkTy
   YBmYQ1G6q0krBjpFj9qXpAIafFgbcvP/sVwFKzARHDdu5lQG+0vSJmaxq
   w==;
X-CSE-ConnectionGUID: Zz+NoSymRQKGpYg0t2kZIA==
X-CSE-MsgGUID: VPsxgp4yS4uT0tnzm8ZY3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="75122312"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="75122312"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 14:49:47 -0700
X-CSE-ConnectionGUID: cM/KCzdpSXabc9t5yC9PVA==
X-CSE-MsgGUID: rxHk5cgRSV6j8fZrZ0h/EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="222003732"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO [10.125.109.21]) ([10.125.109.21])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 14:49:45 -0700
Message-ID: <1db53cf4-7de7-4fd2-a6c7-7b2df963e0e1@intel.com>
Date: Wed, 18 Mar 2026 14:49:44 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] cxl/region: Skip decoder reset on detach for
 autodiscovered regions
To: Alejandro Lucero Palau <alucerop@amd.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
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
References: <20260210064501.157591-1-Smita.KoralahalliChannabasappa@amd.com>
 <20260210064501.157591-4-Smita.KoralahalliChannabasappa@amd.com>
 <69b1e0aacb9d0_2132100c5@dwillia2-mobl4.notmuch>
 <69b319d7e6adf_213210086@dwillia2-mobl4.notmuch>
 <df9cfac5-7e01-422f-bd29-d1b8b3c55623@amd.com>
 <69b8b9181bafd_452b100cb@dwillia2-mobl4.notmuch>
 <718c4a39-4526-45ed-86fb-1e5b57f6ca0e@amd.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <718c4a39-4526-45ed-86fb-1e5b57f6ca0e@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/18/26 12:33 AM, Alejandro Lucero Palau wrote:
> 
> On 3/17/26 02:14, Dan Williams wrote:
>> Alejandro Lucero Palau wrote:
>> [..]
>>> This is not the first time I share my frustration, and as when I did so
>>> in the past, I want to finish with a positive last sentence: I will keep
>>> trying to get type2 support and hopefully further CXL stuff, and happy
>>> to discuss the best way to do so with the CXL kernel community.
>> I did not mean to imply that the type-2 set was stuck behind a new
>> dependency. Apologies.
> 
> 
> No worries.
> 
> 
>>
>> It is next in the queue, it needs to go in next cycle with a high
>> priority.
>>
>> In my view this confirmation that Smita's proposed patch addresses PJ's
>> test failure cleared one of the last hurdles for this set for me.
> 
> 
> Did PJ tell you so? From his report that seemed a likely reason, but he did not comment further after I told him about it.
> 

PJ told me when I was talking to him WRT testing on the latest type2 series.

