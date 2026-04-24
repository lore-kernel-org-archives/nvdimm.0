Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA92437C92A
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 20:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064348; cv=none; b=LCOfvFrQRUjZvJO2JG22OJUHTxxSfMkvOld93loKzjiH3vuhSnLMJJsuB4CAQwozBo+JK3NWxB/XXYPRhO7DI1SXn3wFPJsFGENc/i+5PGqeWj76aQNIvxiIFc7OKmTO0ko+UdcGtL5kyXISpqsUT+bVPz7sxrmEKaT/514n4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064348; c=relaxed/simple;
	bh=2OWhYOrFe47q7O8iD9CLrvuWYRPjK8oTjprXk4pWIMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hqfuLVV5On0D3rmHyxgA4rTfNGkjs69JRxYov0Mvna0cLke/grnjSvAy7xFlHfYvvsOZXbvML+0dWEvvQcmag7vaCiWWAFNcZp/Oy7voOvfFdz8cacSZwP15vHhrDj9jYJHY/8wt3F9OozRgCUl+mpp13/7hBvw0GIdl1NsAsoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnP2/0lI; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnP2/0lI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777064347; x=1808600347;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2OWhYOrFe47q7O8iD9CLrvuWYRPjK8oTjprXk4pWIMY=;
  b=LnP2/0lI//bcuHjTDeL+NuoQ2N/1zJJav/HkIQ8jjWL+Xw0qPIUKFUeI
   0+3Ip9P5iGKjOWdnHBYS9CR+5dfjJMYCdZP0e8WADIKfL+OUDiHoC1Pv6
   T+ygupRxeP+799PZ63lFNKiMA0Vdr9cy7Di4HAmUILFWSmfHiy+DzbZFL
   yXE9oq9iDEgTYKT0XxGjVNb1SoYdV7NfvUBB300khyVJIlsw58LA6Q2Id
   +WaQqdMJNNWZHyJQXjKLyGZnY1232e0xZDjq120jDPSPv7l6xt9Ca50OO
   1PPvQ7huOvOK6SL3Uj34jdRYFVWPLGgqpVMLOBu+3vuA7ET9I/MiqRd8s
   w==;
X-CSE-ConnectionGUID: a5yO+QBdTc65RVG60lGXZA==
X-CSE-MsgGUID: 0Z5/MO4uR1qY0kv8s9odqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="89516030"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="89516030"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 13:59:07 -0700
X-CSE-ConnectionGUID: ep5XU3znRUuXqmq7AiU6vg==
X-CSE-MsgGUID: igsQCi2sQe21N2eMdmJlUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="263449768"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.86]) ([10.125.108.86])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 13:59:05 -0700
Message-ID: <07e7c120-b725-493c-b06b-b2c6f628c49d@intel.com>
Date: Fri, 24 Apr 2026 13:59:04 -0700
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
 <0e831045-3b01-4934-bf43-b3ef01ce0158@intel.com>
 <CAPTztWaXt8izKtpC=g4aOBddvSX9ViekxyPS8UnSBuqitGZuyw@mail.gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <CAPTztWaXt8izKtpC=g4aOBddvSX9ViekxyPS8UnSBuqitGZuyw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 4/24/26 1:01 PM, Frank van der Linden wrote:
> On Fri, Apr 24, 2026 at 11:23 AM Dave Jiang <dave.jiang@intel.com> wrote:
>>
>>
>>
>> On 4/24/26 10:13 AM, Frank van der Linden wrote:
>>> Dave Jiang <dave.jiang@intel.com> wrote:
>>>> This RFC series is created as a proof of concept to connect device DAX to guest
>>>> memory by riding on top of guest memfd in order to prove out that device DAX
>>>> can be used as guest memory. The series seeks to jump start a discussion on
>>>> if there are interests in creating a DAX bridge to utilize CXL memory for guest
>>>> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
>>>> and DAX users are ready to move to the new scheme. Once there's an established
>>>> consensus of interest, we can move the discussion to the best way to implement
>>>> the DAX bridge and the future of device DAX as guest.
>>>>
>>>> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
>>>> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
>>>> path. A DAX char dev is created and the fd is passed in user space with
>>>> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
>>>> unlike memfd where any size can be passed in to be allocated.
>>>>
>>>> The folks on the cc line are people that Dan Williams has mentioned that may be
>>>> of interest to this.
>>>>
>>>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
>>>
>>> One of the main ideas behind guest_memfd is that the memory is managed
>>> by the kernel only, so it knows what it has and that it can trust
>>> the memory. This RFC passes an fd in via the ioctl(), which I think
>>> breaks that model.
>>
>> Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to be passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in a DAX fd instead of a guest mem fd.
> 
> Sorry, yes, I should have said "it passes in a *non-guest_memfd file
> descriptor*" via the ioctl. I think the intent of the guest_memfd code
> is that it can only bind to a guest_memfd file descriptor (hence the
> check in kvm_gmem_bind()), otherwise its trust model would break. Of
> course, I'm not a guest_memfd expert, the maintainers can give you the
> definitive answer on this.

I basically hacked it on top of memfd IOCTLS because it was the quickest way to see if it would work. I think IF we are going to implement something, it would have its own KVM ioctls and not riding on top of guest_memfd and muddy things up. The better question is if we create such a daxfd interface, is it feasible or are there major security concerns?

DJ 

> 
>>
>>>
>>> Since there is interest for several different allocation backends
>>> (default, hugetlb, zone_device), it might be better to use a model
>>> where guest_memfd has the option for backend allocators to register
>>> themselves in the kernel. The ioctl can then select one by their
>>> id/name (could be just a string). They can be configured using
>>> e.g. sysfs (like hugetlb already is).
>>>
>>> This would also allow easy experimentation with new allocators,
>>> having an allocator with BPF control, etc.
>>
>> Agreed. Although my main intent is to see if there's interest with providing something to the usages already on the DAX path an ease of transition until something like what's proposed above shows up. But if what I proposed will be a security issue then maybe not.
> 
> Sure, yes, understood that you're looking for a transitional solution.
> 
> - Frank

