Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5323C31A567
	for <nvdimm@lists.linux.dev>; Thu, 23 Apr 2026 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776967740; cv=none; b=QN9Mncix+BOlLJ5DUFFzJUhDzmXrvfXtMhisjYStXgAOa1gAn9INxb1O30AAXhg4y1R56LnOx1PFzTpN4HgeDpMgSj3Vu7OqG9i2yWFLAhzeCy52Q598aIjuJSSkT3NS7AS3TL8V7O0KszByklVVNht9/hjhgitgNz5uDMyS0hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776967740; c=relaxed/simple;
	bh=tMlD7GFCqV23OGUXtTU3Wj3w1voetiJ7GXOSRmutPhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7DeMcZX9LFekAmZWVg9L4tvWg3lGhXgKSw15eR4LaPU3fZajiHSg85aIJVD4t4IDSQojKkfq82Sgbj97HxUeE+TPPn2lb5BYFCB/zh1GWtCPPGRB2Km+Qe1KVA6j5y4DdFZTaiAW66R/yssSnbgTp6s64zmNfuVfZ2t9/PzP08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y6JgYkdy; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y6JgYkdy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776967738; x=1808503738;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tMlD7GFCqV23OGUXtTU3Wj3w1voetiJ7GXOSRmutPhM=;
  b=Y6JgYkdybSo+UObnAC/454m9+nn/n1wNx+Qno0BxF5O7DeFMtqCQQP1a
   KI/LY4RX5W4JXa2uKlmgzR9mEBJPtFmIR77m8UBZoZnP0t/J8bENzcNPG
   2GZGfzEYtWxiu6QICRfs7YA2WVhSjAlHQ1jCjhT57CTWYgJJFoDnTCZym
   91uRmR+BzGpz3ORQYDX5kNQTSpjT1GGwoPLoz7k0D8AIlH0xJ7AX56IBb
   vxoXGOlUWPafe+9D50Bz9eQgHOZtbzsbFY1YVyTnA3dbCVoV9G+yqklMk
   7a+zoHfniaEox8GGI5TUarBOHJawBRRe4Im3V9Av5R+JfFPZ0oOWSPBkH
   w==;
X-CSE-ConnectionGUID: yvRkigYsQoi9g+NFZkh4Hw==
X-CSE-MsgGUID: ARgBugk+QNWtclScEnN08g==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="89328131"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="89328131"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 11:08:57 -0700
X-CSE-ConnectionGUID: XIHXnZmBQjmmVN9v0/l2sw==
X-CSE-MsgGUID: STkR6yE3T+6u60dM/Wr+tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="233034979"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.12]) ([10.125.108.12])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 11:08:56 -0700
Message-ID: <70f67490-8caa-4839-a2e2-75c3b0c08b15@intel.com>
Date: Thu, 23 Apr 2026 11:08:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org,
 iweiny@kernel.org, mclapinski@google.com, rppt@kernel.org,
 joao.m.martins@oracle.com, jic23@kernel.org, gourry@gourry.net,
 john@groves.net, rick.p.edgecombe@intel.com
References: <20260423170219.281618-1-dave.jiang@intel.com>
 <aepS0w2aeIh2xx0G@plex>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aepS0w2aeIh2xx0G@plex>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/23/26 10:27 AM, Pasha Tatashin wrote:
> Hi Dave,
> 
Hi Pasha,

> On 04-23 10:02, Dave Jiang wrote:
>> This RFC series is created as a proof of concept to connect device DAX to guest
>> memory by riding on top of guest memfd in order to prove out that device DAX
>> can be used as guest memory. The series seeks to jump start a discussion on
>> if there are interests in creating a DAX bridge to utilize CXL memory for guest
>> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
>> and DAX users are ready to move to the new scheme. Once there's an established
>> consensus of interest, we can move the discussion to the best way to implement
>> the DAX bridge and the future of device DAX as guest.
> 
> I cannot speak to the CXL/DAX use case, but I can provide perspective 
> from a persistence point of view. Currently, as a temporary workaround, 
> we are using emulated pmem in DevDax mode for live update purposes. 
> However, going forward, our plan is to switch to regular memory and use 
> LUO + memfd/guestmemfd backed by regular RAM to preserve resources.
> 
> We are working on a patch series that we plan to send out in the coming 
> weeks to preserve guestmemfd via LUO.
> 
> By design, all resources that participate and need to be preserved 
> across reboots for live update purposes must have FD handlers.
> 
> Does your series allow DAX memory with 1G alignment (i.e. 1G pages) to 
> back guest_memfd?  That is also an interesting use case, while HugeTLB 
> support for guest_memfd is in progress, it still has not yet landed.

I just did a quick dirty hack to get 4k working. It may need some
additional plumbing to enable 1G alignment. But I don't see any reason why
that can't be done. Do you see any technical barriers? While it rides some
of the paths to setup for gmem_fd, the faulting path is through DAX and does
not go through the gmem. Maybe if we are actually implementing this, it may
split out via clean dedicated DAX paths and not ride on top of gmem_fd? If
we determine there is interest in doing this enabling, then at that time we
can go to the next step and discuss how we want the interface to look like.

DJ

> 
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
>>
>>
>> Dave Jiang (12):
>>   dax: rate limit dev_dax_huge_fault() output
>>   dax: Save the kva from memremap
>>   dax: Add fallocate support to device dax
>>   dax: Move dax_pgoff_to_phys() to dax bus to be used by dev dax
>>   dax: Add dax_operations and supporting functions to device dax
>>   dax: Add helper to determine if a 'struct file' supports dax
>>   KVM: guest_memfd: Add setup of daxfd when binding gmem
>>   fs: allow char dev to go through fallocate
>>   dax: Add dax_get_dev_dax() helper function
>>   kvm: Implement dax support for KVM faulting
>>   kvm: Add daxfd support for supported flags
>>   selftest/kvm: Add daxfd support for gmem selftest
>>
>>  arch/x86/kvm/Kconfig                          |   1 +
>>  arch/x86/kvm/mmu/mmu.c                        |  48 ++-
>>  drivers/dax/bus.c                             | 132 ++++++-
>>  drivers/dax/dax-private.h                     |   8 +
>>  drivers/dax/device.c                          |  80 +++--
>>  fs/open.c                                     |   3 +-
>>  include/linux/dax.h                           |  15 +
>>  include/linux/kvm_host.h                      |  39 +++
>>  include/uapi/linux/kvm.h                      |   4 +
>>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>>  .../testing/selftests/kvm/guest_daxfd_test.c  | 329 ++++++++++++++++++
>>  virt/kvm/Kconfig                              |   4 +
>>  virt/kvm/guest_memfd.c                        |  92 ++++-
>>  virt/kvm/kvm_main.c                           |   6 +
>>  14 files changed, 711 insertions(+), 51 deletions(-)
>>  create mode 100644 tools/testing/selftests/kvm/guest_daxfd_test.c
>>
>>
>> base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
>> -- 
>> 2.53.0
>>

