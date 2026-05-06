Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F053A8753
	for <nvdimm@lists.linux.dev>; Wed,  6 May 2026 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778099879; cv=none; b=tbx0n/vqb8nTk8VLZ/nGbUmGNzDvNk0KFyUCukKethCOqbD6g3PzdWOLoAibSzdDThMjUTAaQM43omptGDHQ2L+DoEqrzyfqu7v9zdRurOHMXF6Yiet5mD54AaOuDcwbF6mx7KIm4c1lu8iOHcGGlUArRBAuDGFQ6RwqzFDJ/pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778099879; c=relaxed/simple;
	bh=svILQTVjdE2GWKnhGPqjW9/VvuLA+zGjYRZjvstWCjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHHMjguVjZSKRUp1lK6q++HwDEBaUXQX3iZpC8A5e2L17kBKKBDa5f5AEPlP9Ws/2G5Sx+Fr9z/eKnEay4e+4ikzv0f+nip1RNcUbuysABpli7en3wKgwFR6NHgAQO4O1He5FjhugiaMcqJP5EsGcU1ZO+t0yQ24F3uI2ExFHrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PEUyYDSJ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PEUyYDSJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778099878; x=1809635878;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=svILQTVjdE2GWKnhGPqjW9/VvuLA+zGjYRZjvstWCjM=;
  b=PEUyYDSJV5BFmlv0GmGC616YP7Y5RGkVhaCWFdujmNzm7kE77MfTRKft
   vEkl+tfFEAHSkaeySQ65EclBaxmqffL8B/RoeF04LdMZnvnNG0wbzjkjQ
   QgkH1aAd/Qaa/QzoZMN9ZEvFi5BD+ufnWUy2L0RTpQmpadc9804PVOOxI
   i4wU8NQjXWALDy4QOkP0YdmJSlDY/wntRO+eYQh8b1WE2cMhdb50rXnn2
   dX7uEDQtWWTubYsuxUSefs8n+dhDyUt1CoLeEsO3Kx8gzGf0s/Ye15X3L
   +zeZfQdBqHibzLwUBEdoS3uOPiQERp7YT5o+Fcp1gIgG8MUfyyqLAYAkK
   w==;
X-CSE-ConnectionGUID: gp3gXUzUT5mHQNgp+W0dJg==
X-CSE-MsgGUID: M70iB6dQSzS7a0lPQOS68w==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="78935421"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="78935421"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:37:58 -0700
X-CSE-ConnectionGUID: JDBnrTZoRXawqUiDdTQg9Q==
X-CSE-MsgGUID: nn7Bf6pmRdivKTzbABKgGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="240580233"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.169]) ([10.125.110.169])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:37:57 -0700
Message-ID: <cf465b8a-298d-4a2a-8003-b05eb7f66ffe@intel.com>
Date: Wed, 6 May 2026 13:37:55 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
To: Ackerley Tng <ackerleytng@google.com>
Cc: fvdl@google.com, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 djbw@kernel.org, iweiny@kernel.org, pasha.tatashin@soleen.com,
 mclapinski@google.com, rppt@kernel.org, joao.m.martins@oracle.com,
 jic23@kernel.org, gourry@gourry.net, john@groves.net,
 rick.p.edgecombe@intel.com
References: <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <CAEvNRgE3ifAvgVS4bLeNp_eVp0=6b3p+myYEXSfyS+Qrw5mrtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/6/26 1:23 PM, Ackerley Tng wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
> 
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
> 
> Thanks for the PoC! I've been working on guest_memfd HugeTLB and I'm
> glad there is interest in other "backends" for guest_memfd :)
> 
>>>> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t
>>>
>>> One of the main ideas behind guest_memfd is that the memory is managed
>>> by the kernel only, so it knows what it has and that it can trust
>>> the memory. This RFC passes an fd in via the ioctl(), which I think
>>> breaks that model.
> 
> Yup! One of guest_memfd's core purposes is to be able to block host
> accesses to guest private (in the CoCo sense) memory.
> 
>>
>> Don't we issue KVM_CREATE_GUEST_MEMFD ioctl to get a fd in userspace to be passed to KVM_SET_USER_MEMORY_REGION2 ioctl later? We are just passing in a DAX fd instead of a guest mem fd.
>>
> 
> This RFC is passing a DAX fd instead of a guest_memfd when creating a
> memslot, so it's not really using guest_memfd, it's just reusing the
> functions that were first created for guest_memfd to support another
> kind of fd.
> 

Right. It was the fastest way to see if something would work. It isn't meant to be the design goal in the future.

> What's the use case you're shooting for? Why not mmap() from the DAX
> fd and then pass the userspace address to KVM when setting up a memslot?

The use case mainly is to see if the people currently using DAX via mmap() would utilize this for other usages as a bridge vs something like the private node implementation Gregory is working on that has a totally different way of doing things. So yes what you suggested could be another way to do it. Mainly I want to see if there's even any interest at all. And if so then we can talk about how we want it to be done and I'm wide open on that.

> 
> Is there a requirement to have the DAX memory usable by CoCo guests as
> well, and hence requiring guest_memfd-style protection from host
> accesses for private DAX memory?

I think if we are to implement this then I think so at some point.

DJ
> 
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
>>
>>>
>>> - Frank
> 

