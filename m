Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A14D381AFE
	for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 18:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776968479; cv=none; b=YcncTL1kXckNOIPPSKHu0MwTZjuu6Y/W565grNQgZGuUlf0tr0qzUsHXjCN2YWhKgLIErmjxfCgdKlNB7tdy9zvL34444pzu1MXLce7MNfdN9ZEKvpZrcyZt36HlcfnAfCA58+Tah6NA4qQ5vOUQHWxGd3s1BR2YoNtKabG+kEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776968479; c=relaxed/simple;
	bh=He14szJinxYUJlJ3/HEcy4tOACxbAKpJlndK3F7xoVE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=h63vetWCK2fsk6QYzbJXSGaHJHk9vxU47cy+jHgd+C6QVeugQTjAQ21F2wK37lJfPLvbOJ9/ht6BIxfMkIeOSPWbHkxpXd0psrd+TEkm3Bgb3XE5QsqAXafKRVvcpfGsDLQVcbcRjrlEAhm+337WESNc5JvGXDVwdF+vBH1yeeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TS3je+v2; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TS3je+v2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776968477; x=1808504477;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=He14szJinxYUJlJ3/HEcy4tOACxbAKpJlndK3F7xoVE=;
  b=TS3je+v2D5tOUwazv1HkeXDjIIWloR4lLhIWDnztraN9cRfXpTJhBHi9
   4p7XK7RUQHtJj1b4VlXjM51n7nFP2dWa8v7yu9uQJXbiZCqwZUkYWS2Un
   96y83kio7xgsJu+rYiWb09UsQ9Ro49m4hvHK5vEoMtqGbaWg0Bw9wTio6
   EMpHe+pWo3gTx/Bn7uEPH3xSo5ZwI5ql44sVDgQ69UCpg2l7KNjN/hOw2
   AIwp2/PicOO0ZF5j1xKmTNArnQxRDWEdVx2gM3HPU+ltRRYRyUTDyunQg
   rr6sjyK/UMkP6Nzvs5BfPainbNJ7kFjUGV8sbyZ/hae24tHXYkzUW/IpN
   w==;
X-CSE-ConnectionGUID: wJ3zpUghSD+oJZrijaBMXA==
X-CSE-MsgGUID: AwYf1u3LRXm5kCAnIdwCxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="95507174"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="95507174"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 11:21:17 -0700
X-CSE-ConnectionGUID: Q3FuiwlzRjGAdaJkwM44Mg==
X-CSE-MsgGUID: rgacWumqTRijnLLJ8iQNWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="226200407"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.12]) ([10.125.108.12])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 11:21:16 -0700
Message-ID: <a1b05f3c-9c79-42f5-af29-5e719a3d0900@intel.com>
Date: Thu, 23 Apr 2026 11:21:14 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
From: Dave Jiang <dave.jiang@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
 iweiny@kernel.org, mclapinski@google.com, rppt@kernel.org,
 joao.m.martins@oracle.com, jic23@kernel.org, gourry@gourry.net,
 john@groves.net, rick.p.edgecombe@intel.com
References: <20260423170219.281618-1-dave.jiang@intel.com>
 <aepS0w2aeIh2xx0G@plex> <70f67490-8caa-4839-a2e2-75c3b0c08b15@intel.com>
Content-Language: en-US
In-Reply-To: <70f67490-8caa-4839-a2e2-75c3b0c08b15@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/23/26 11:08 AM, Dave Jiang wrote:
> 
> 
> On 4/23/26 10:27 AM, Pasha Tatashin wrote:
>> Hi Dave,
>>
> Hi Pasha,
> 
>> On 04-23 10:02, Dave Jiang wrote:
>>> This RFC series is created as a proof of concept to connect device DAX to guest
>>> memory by riding on top of guest memfd in order to prove out that device DAX
>>> can be used as guest memory. The series seeks to jump start a discussion on
>>> if there are interests in creating a DAX bridge to utilize CXL memory for guest
>>> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
>>> and DAX users are ready to move to the new scheme. Once there's an established
>>> consensus of interest, we can move the discussion to the best way to implement
>>> the DAX bridge and the future of device DAX as guest.
>>
>> I cannot speak to the CXL/DAX use case, but I can provide perspective 
>> from a persistence point of view. Currently, as a temporary workaround, 
>> we are using emulated pmem in DevDax mode for live update purposes. 
>> However, going forward, our plan is to switch to regular memory and use 
>> LUO + memfd/guestmemfd backed by regular RAM to preserve resources.

I also want to mention that while I'm motivated by CXL backing, the enabling is DAX backed by any backend.

DJ

>>
>> We are working on a patch series that we plan to send out in the coming 
>> weeks to preserve guestmemfd via LUO.
>>
>> By design, all resources that participate and need to be preserved 
>> across reboots for live update purposes must have FD handlers.
>>
>> Does your series allow DAX memory with 1G alignment (i.e. 1G pages) to 
>> back guest_memfd?  That is also an interesting use case, while HugeTLB 
>> support for guest_memfd is in progress, it still has not yet landed.
> 
> I just did a quick dirty hack to get 4k working. It may need some
> additional plumbing to enable 1G alignment. But I don't see any reason why
> that can't be done. Do you see any technical barriers? While it rides some
> of the paths to setup for gmem_fd, the faulting path is through DAX and does
> not go through the gmem. Maybe if we are actually implementing this, it may
> split out via clean dedicated DAX paths and not ride on top of gmem_fd? If
> we determine there is interest in doing this enabling, then at that time we
> can go to the next step and discuss how we want the interface to look like.
> 
> DJ
> 
>>
>>> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
>>> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
>>> path. A DAX char dev is created and the fd is passed in user space with
>>> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
>>> unlike memfd where any size can be passed in to be allocated.
>>>
>>> The folks on the cc line are people that Dan Williams has mentioned that may be
>>> of interest to this.
>>>
>>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
>>>
>>>
>>> Dave Jiang (12):
>>>   dax: rate limit dev_dax_huge_fault() output
>>>   dax: Save the kva from memremap
>>>   dax: Add fallocate support to device dax
>>>   dax: Move dax_pgoff_to_phys() to dax bus to be used by dev dax
>>>   dax: Add dax_operations and supporting functions to device dax
>>>   dax: Add helper to determine if a 'struct file' supports dax
>>>   KVM: guest_memfd: Add setup of daxfd when binding gmem
>>>   fs: allow char dev to go through fallocate
>>>   dax: Add dax_get_dev_dax() helper function
>>>   kvm: Implement dax support for KVM faulting
>>>   kvm: Add daxfd support for supported flags
>>>   selftest/kvm: Add daxfd support for gmem selftest
>>>
>>>  arch/x86/kvm/Kconfig                          |   1 +
>>>  arch/x86/kvm/mmu/mmu.c                        |  48 ++-
>>>  drivers/dax/bus.c                             | 132 ++++++-
>>>  drivers/dax/dax-private.h                     |   8 +
>>>  drivers/dax/device.c                          |  80 +++--
>>>  fs/open.c                                     |   3 +-
>>>  include/linux/dax.h                           |  15 +
>>>  include/linux/kvm_host.h                      |  39 +++
>>>  include/uapi/linux/kvm.h                      |   4 +
>>>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>>  .../testing/selftests/kvm/guest_daxfd_test.c  | 329 ++++++++++++++++++
>>>  virt/kvm/Kconfig                              |   4 +
>>>  virt/kvm/guest_memfd.c                        |  92 ++++-
>>>  virt/kvm/kvm_main.c                           |   6 +
>>>  14 files changed, 711 insertions(+), 51 deletions(-)
>>>  create mode 100644 tools/testing/selftests/kvm/guest_daxfd_test.c
>>>
>>>
>>> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
>>> -- 
>>> 2.53.0
>>>
> 
> 

