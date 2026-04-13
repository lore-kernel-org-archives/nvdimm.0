Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53E3D3305;
	Mon, 13 Apr 2026 15:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776095229; cv=none; b=WkSfkCN1ITnw8KCi4bDaq6OCViDggQK8xXqoDLL3/d0D8l/NQqlHVCLmDdcIF3/+Oe51vaU8COn3ElJDyzt7PjBUY+vzhEvkU75k0jVJ79I0C+9cVsZpczoDvi8Wkfm8eH2ldNZ/lIAzINXk8VCdkFuyuN8UdA6eXQluBaSjvMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776095229; c=relaxed/simple;
	bh=3GI/MCP1kRVutqcg9+UyZVZDvXObMmYiIvH2qlP/Pas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mbvm+kqs61nbqCNd5Qnuh5HrAsAsJ6r7JvMwmiq2D8fHnI/jZ2qJo6/1krIUlkVm+jQWnJYqUmEkrMXPS3JLuWLkEVm28pJJj6qqYJo34IAKJ/RpI2WlNzKXxggaFkX8SYlMa/efeQUmdwktsusypSGE+46Pgh0G4szKgtCPhIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMRDjhWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMRDjhWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D55C2BCAF;
	Mon, 13 Apr 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776095229;
	bh=3GI/MCP1kRVutqcg9+UyZVZDvXObMmYiIvH2qlP/Pas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MMRDjhWlMKJPMs2+iTlIf8F74H8+UudDBdSsUdEdSrw1JT4c7Wd337cKZhW4zK88t
	 JnewE19+O9IMHhXiE9vbYldk2/3shX6DJuw3OHYQk/PiNRGLcg10jN3Mfp6JAr0HrY
	 T6joA+2bDTdU7slp8i9CiUB/mvAEqS1SJWMcuUBb4U0MIWYktk9MgdAal5j/Vsy5mt
	 1azXCs5SXrS+D8H5AvwZ7IQ0ALa4vHdE7Dw0rzc7zE44Xqrj405tqJt2ODO3sP2vMm
	 YGOdL3TTfG+3iEqNxj7YgDoPXV1NGi0yT/JkgZ8nwoEfMliQ+9bGLdu93OQpfurveh
	 DHd6XCxZCatcQ==
Message-ID: <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
Date: Mon, 13 Apr 2026 17:47:01 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 osalvador@suse.de, dan.j.williams@intel.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/26 21:26, Gregory Price wrote:
> On Sat, Mar 21, 2026 at 10:40:21AM -0700, Andrew Morton wrote:
>> On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:
>>
>>> The dax kmem driver currently onlines memory during probe using the
>>> system default policy, with no way to control or query the region state
>>> at runtime - other than by inspecting the state of individual blocks.
>>>
>>> Offlining and removing an entire region requires operating on individual
>>> memory blocks, creating race conditions where external entities can
>>> interfere between the offline and remove steps.
>>>
>>> The problem was discussed specifically in the LPC2025 device memory
>>> sessions - https://lpc.events/event/19/contributions/2016/ - where
>>> it was discussed how the non-atomic interface for dax hotplug is causing
>>> issues in some distributions which have competing userland controllers
>>> that interfere with each other.
>>>
>>> This series adds a sysfs "hotplug" attribute for atomic whole-device
>>> hotplug control, along with the mm and dax plumbing to support it.
>>
>> AI review (which hasn't completed at this time) has a lot to say:
>> 	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net
> 
> Looking at the results - i mucked up a UAF during the rebase that i
> didn't catch during testing.  Will clean that up.
> 
> I also just realized I left an extern in one of the patches that I
> thought I had removed.
> 
> So I owe a respin on this in more ways than one.
> 
> But on the AI review comment for non-trivial stuff
> ---
> 
> Much of the remaining commentary is about either the pre-existing code
> race conditions, or design questions in the space of that race
> condition.
> 
> Specifically: userland can still try to twiddle the memoryN/state bits
> while the dax device loops over non-contiguous regions.

dax_kmem_do_hotremove() loops over offline_and_remove_memory(). And once
something was removed, it can no longer get onlined, obviously. So that
should be good.

dax_kmem_do_hotplug() loops over __add_memory_driver_managed() and
onlines the memory directly using the specified policy.

User space can only interact with that after memory was already onlined.

So, really only user space can try offlining the memory after requested
onlining succeeded.

I don't think any udev rules do that? The usually only request to
online, which should be fine.

So if a user does that manually, good for him. We just have to make sure
that stuff keeps working as expected.

Or am I missing a case?

> 
> I dropped this commit:
> https://lore.kernel.org/all/20260114235022.3437787-6-gourry@gourry.net/
> 
> From the series, because the feedback here:
> https://lore.kernel.org/linux-mm/d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org/
> 
> suggested that offline_and_remove_memory() would resolve the race
> condition problem - but the patch proposed actually solved two issues:
> 
> 1) Inconsistent hotplug state issue (user is still using the old
>    per-block offlining pattern)
> 
> 2) The old offline pattern calling BUG() instead of WARN() when trying
>    to unbind while things are still online.
> 
> But this goes to the issue of:  If the race condition in userland has
> been around for many years, is it to be considered a feature we should
> not break - or on what time scale should we consider breaking it?

I think the only thing we care about is that even if udev rules
interact, that things just keeps working as expected.

That should be the case (see above) unless I am missing something?


I'll note that offline_and_remove_memory() can take a long time/forever
to succeed. User space can abort it by sending a critical signal.

For example, if you do

$ echo "unplugged" > magic_device_file

And it hangs, user space can kill the "echo" command, sending a fatal
signal and making offline_and_remove_memory() fail.

The question is, if you want to do your best to revert the other offline
operations and try re-adding/onlining what you already offlined.

offline_and_remove_memory() handles that much nicer internally, as it
tries to revert offlining, and only removes once everything was offlined.

I think I raised it previously, but you could add a
offline_and_remove_memory_ranges() that consumes multiple ranges, and
would do this for you under a single lock_device_hotplug().

-- 
Cheers,

David
