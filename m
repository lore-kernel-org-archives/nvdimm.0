Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A303D5F28;
	Thu, 22 Jan 2026 22:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769121851; cv=none; b=N/EVTtmib3Jm7/f0N+4P6Uun/k1Kv0+3aW2psP/wJBoG+PDf9djScwvJ/Efx/HjdpSXdcBP+276gYIDo6yFOzcbvJa/RGv6YlNoDmyjGRjIzR/8vpwgVjD85vSmF6C2YXM/VFvtWdOdL4i0Ake4dPNnG7fYhr9E4lCrJxysZRsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769121851; c=relaxed/simple;
	bh=tgc8g7sbE+TVJMNvbrnWDkXF0NeF0UTwcMLazAtdYZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HCoiAjxpghUw8dPpQ5hzSFEyvMFBejYo+BW660qgyTxd0+q40mCmHZhjZ3bw9u0lG97qXU+DZrJ9YD4dQIxNWn9DWgPIIUYMlyYvkVAIrJdnApD43YyQyjQgKd1GbISXAxq4vnK1872ehalN6MgL33ytel5yl72ZtLYwbN8CGtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8aPqN9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8aPqN9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E002C116C6;
	Thu, 22 Jan 2026 22:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769121849;
	bh=tgc8g7sbE+TVJMNvbrnWDkXF0NeF0UTwcMLazAtdYZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=I8aPqN9gmtoB1klij8GwGiQ0xbOGZbdk2ZU++3mgy8iMUXnSlNrdQbsaIqrX40GSl
	 bqNDMqFt+HSYIEtFPC1ev5xnH6MidZj+2+bCbTMZTYKkVZ3byvd/zaZ2AkXa+4hcaZ
	 DP+pS0jOQ6CAgye/x31X8y7SRnd9UlaJfPR9BljUoVnevSaXa29OenElcHpDspumzi
	 wV8wtS5ZS+PE+jqA8gGVsCrbCjtTRZ28I6wmC4w+D4NExM6BWyhfC/N2JD04+Q8aB9
	 fdCkFOecl1p27j4gNwIwYS3TJCcYC+dpun6Sg6/JlA+PKWTRzAcS9Q1kNb/YRP+vxt
	 /sXWGg2E8iHFg==
Message-ID: <b0d4db87-1d58-4877-8a64-55a71f1960d1@kernel.org>
Date: Thu, 22 Jan 2026 23:44:02 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] dax/kmem: add memory notifier to block external state
 changes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org, Hannes Reinecke <hare@suse.de>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-9-gourry@gourry.net>
 <d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org>
 <aWfNN-hy64bGw6p2@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWfNN-hy64bGw6p2@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 18:07, Gregory Price wrote:
> On Wed, Jan 14, 2026 at 10:44:08AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/14/26 09:52, Gregory Price wrote:
>>> Add a memory notifier to prevent external operations from changing the
>>> online/offline state of memory blocks managed by dax_kmem. This ensures
>>> state changes only occur through the driver's hotplug sysfs interface,
>>> providing consistent state tracking and preventing races with auto-online
>>> policies or direct memory block sysfs manipulation.
>>>
>>> The notifier uses a transition protocol with memory barriers:
>>>     - Before initiating a state change, set target_state then in_transition
>>>     - Use a barrier to ensure target_state is visible before in_transition
>>>     - The notifier checks in_transition, then uses barrier before reading
>>>       target_state to ensure proper ordering on weakly-ordered architectures
>>>
>>> The notifier callback:
>>>     - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
>>>     - Returns NOTIFY_BAD if in_transition is false (block external ops)
>>>     - Validates the memory event matches target_state (MEM_GOING_ONLINE
>>>       for online operations, MEM_GOING_OFFLINE for offline/unplug)
>>>     - Returns NOTIFY_OK only for driver-initiated operations with matching
>>>       target_state
>>>
>>> This prevents scenarios where:
>>>     - Auto-online policies re-online memory the driver is trying to offline
>>
>> Is this still a problem when using offline_and_remove_memory() ?
>>
> 
> I suppose this commit more than the others is actually an RFC.
> 
> DAX might not want it.  Other drivers might.  Now at least I have the
> code to do that.
> 
>>>     - Users manually change memory state via /sys/devices/system/memory/
>>
>> I don't see why we would want to care about that :)
>>
> 
> Absolutely critical if we have something like a CXL DCD region that
> wants to try to protect hot-unplug.  But that is probably an argument
> for implementing this in a cxl region driver than DAX.

I asked further questions about that in reply to the other longer mail.

Don't try to make the whole CXL DCD more special than anything else we 
already have, otherwise you'll end up creating a mess for user space.

-- 
Cheers

David
