Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386673F0762
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 18:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054995; cv=none; b=UJMZN0WlUFwSnHsj9IRLgqXZzeb5xkb33yU/9xKXxvi1xipFyn6tjxqHSRPtdBnXHJ+Jtm7WRLALBlu3vJhuOsJziHX/1PN2ylWdeX/Bid34nAQ8iYGLUE8YRR5SxreUI+/m2o2/rFJ5fFexqN6sXUltZrk4/ffvmPNrqiRkfnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054995; c=relaxed/simple;
	bh=UwCJ5Tg7ifJEBrCnwkokq+tXp1ah21KIrX83SIBMeBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b08poI8SY3MJYjZvsiKt//IrfsYOHjTLQ8YhvveRn7KuCff6d/W8wmsj/6ru099gKOLaGSK5a1tEowj/TiwKArwZl1w7CTVlKIzFpfvtcKxfNWDVkPUs6tYG70p8c335JORyFo/Rkrl0Ow6g1L77miOyf6SwUduHycAudgKGMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixIXDm11; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixIXDm11"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777054992; x=1808590992;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UwCJ5Tg7ifJEBrCnwkokq+tXp1ah21KIrX83SIBMeBs=;
  b=ixIXDm113CcHFNtF4UJaZuplGFkue26EGpv50OxdPTz8cEZnezdgH1OY
   8SNsEGzJm+vEnpcmNPTng45I2qTVYzcYJcJQZYsBbR0f7P9BXCsSG6cDE
   z/XjCxpYaoxm/5eYK50KQpjWDVrH5jtMthsBYMp2lVjzsTMizcxX+dS6M
   d3HXhyIx/Jp9/Y2Y1+hBeJTulzM+WHCICMWuqoXfON1ePSVZ2tMDhV97n
   cNTZIAdbBM53YXVTh5Y6np7gJ5yXwK0+6fghyCJXZ1s3sfixzPAF0UpUu
   6znNcjSdVpb9RpFbQmSmP9Wzc8ruGCUbfurHvrd1wF91+rrwtbYkPOy79
   g==;
X-CSE-ConnectionGUID: k3jUCox+Tmmz9VQYRfaqDw==
X-CSE-MsgGUID: l7XsHCFvScmMseXVkGFOxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="88348891"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="88348891"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 11:23:11 -0700
X-CSE-ConnectionGUID: o6XkQ5tRT2W4FPrK7Djt6g==
X-CSE-MsgGUID: pAKL+QjNRZO/jy47FoS9Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="232027289"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.86]) ([10.125.108.86])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 11:23:10 -0700
Message-ID: <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
Date: Fri, 24 Apr 2026 11:23:09 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Frank van der Linden <fvdl@google.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
 iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com,
 rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org,
 gourry@gourry.net, john@groves.net, rick.p.edgecombe@intel.com
References: <20260423170219.281618-1-dave.jiang@intel.com>
 <20260424172912.548636-1-fvdl@google.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260424172912.548636-1-fvdl@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/24/26 10:13 AM, Frank van der Linden wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
>> This RFC series is created as a proof of concept to connect device DAX to guest
>> memory by riding on top of guest memfd in order to prove out that device DAX
>> can be used as guest memory. The series seeks to jump start a discussion on
>> if there are interests in creating a DAX bridge to utilize CXL memory for guest
>> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
>> and DAX users are ready to move to the new scheme. Once there's an established
>> consensus of interest, we can move the discussion to the best way to implement
>> the DAX bridge and the future of device DAX as guest.
>>
>> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
>> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
>> path. A DAX char dev is created and the fd is passed in user space with
>> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
>> unlike memfd where any size can be passed in to be allocated.
>>
>> The folks on the cc line are people that Dan Williams has mentioned that may be
>> of interest to this.
>>
>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
> 
> One of the main ideas behind guest_memfd is that the memory is managed
> by the kernel only, so it knows what it has and that it can trust
> the memory. This RFC passes an fd in via the ioctl(), which I think
> breaks that model.

Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to be passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in a DAX fd instead of a guest mem fd.

> 
> Since there is interest for several different allocation backends
> (default, hugetlb, zone_device), it might be better to use a model
> where guest_memfd has the option for backend allocators to register
> themselves in the kernel. The ioctl can then select one by their
> id/name (could be just a string). They can be configured using
> e.g. sysfs (like hugetlb already is).
> 
> This would also allow easy experimentation with new allocators,
> having an allocator with BPF control, etc.

Agreed. Although my main intent is to see if there's interest with providing something to the usages already on the DAX path an ease of transition until something like what's proposed above shows up. But if what I proposed will be a security issue then maybe not. 

> 
> - Frank

