Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEF3C23AF;
	Thu, 22 Jan 2026 22:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122197; cv=none; b=oN+SMl86XTt5WI22YO5/yZ0l8B4kHFvOy22W3tzbCbyY++RKz7MbXUSrBkMUlyxK5nqioxIMOetz1CgQOa3NeyyQbhB9N3gnChDZIIpx1WeB2YCIjANMlTbStZQw+YdzLeov8RpWDnGVsSl/qmtNXYdHN2xUerLYwEFbAW+YFqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122197; c=relaxed/simple;
	bh=eWzfvBBJVfH3cs7Ugnr5IAe0m04aC03BbCpeh0poZTg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aIC9M8bbr3KMiz4dFzvubGxUKoIwIVgnWKOQwrd98Ml4dEpMMiWCuGxbBTeWk66UI28MhRJJXZZKmCCBJt0h0KNERR3r7becMvtfOywav6l/9f+ZeLfMnbGjWVAWbu5Cr8Z1qVhDoCS4c29rIGcZ8qFVVWjG0MVgiznqhki741o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=suv9xQxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="suv9xQxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FE3C116C6;
	Thu, 22 Jan 2026 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769122195;
	bh=eWzfvBBJVfH3cs7Ugnr5IAe0m04aC03BbCpeh0poZTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=suv9xQxJ/OmsZ2P8dFYa94e6zxbPnmiJ8c4Kih4qUGg8/Kg23CZNqKuShF8Vjn+5e
	 IajYFVdMGTxzAo+o3q519CqQcmjnjMQUPUj6gKVctafcwRnYCUpKkrrP2WCSHyXu/e
	 s0ybylPA2yN6Tl/B+pJsHt/eRo0fY/W0Cb4X+opdsYqn/6FGm42hsBuhmDgj7+/6Hn
	 I2rnalAP7r7wD3p4cuBp7np1bXBKVmNu/yakcfPmnLMbm8JZQcvr5F0CrlNDSoVZ2y
	 TsLHPowYb66DRZhr2IfUW1cfAGuJPgy1tkLnaKcN2AWbhZWOFYupXXhRiV9gWBhUro
	 8Y4Q5ZR+GQU+g==
Message-ID: <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
Date: Thu, 22 Jan 2026 23:49:48 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
 <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 19:11, Gregory Price wrote:
> On Wed, Jan 14, 2026 at 11:55:21AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/14/26 09:51, Gregory Price wrote:
>>> The dax kmem driver currently onlines memory automatically during
>>> probe using the system's default online policy but provides no way
>>> to control or query the memory state at runtime. Users cannot change
>>> the online type after probe, and there's no atomic way to offline and
>>> remove memory blocks together.
>>>
>>> Add a new 'hotplug' sysfs attribute that allows userspace to control
>>> and query the memory state. The interface supports the following states:
>>>
>>>     - "offline": memory is added but not online
>>>     - "online": memory is online as normal system RAM
>>>     - "online_movable": memory is online in ZONE_MOVABLE
>>>     - "unplug": memory is offlined and removed
>>>
>>> The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
>>> backwards compatibility - existing systems with auto-online policies
>>> will continue to work as before.
>>>
>>> The state machine enforces valid transitions:
>>>     - From offline: can transition to online, online_movable, or unplug
>>>     - From online/online_movable: can transition to offline or unplug
>>>     - Cannot switch directly between online and online_movable
>>
>> Do we have to support these transitions right from the start?
>>
>> What are the use cases for adding memory as offline and then onlining it,
>> and why do we have to support that through this interface?
>>
> 
> After a re-read of the feedback - are you suggested to basically kill the
> entire offline state of blocks entirely? (e.g. if a driver calls to
> offline a block, instead fully unplug it)

I'm merely wondering why, in the new world, you would even want the 
offline state.

So what are the use cases for that?


Sure, memory onlining can (in debug configs) fail, so you can maneuver 
yourself into a position where some memory is online and other is offline.

But "unfortunately having some memory blocks offline" is something 
different then user space explicitly asking to "keep all of it offline".

Why would user space possibly want that?

> 
> I took a look at the acpi and ppc code you suggested, and I think they
> also have "expect offline then online" as a default expectation.  I
> can't speak to those users requirements.

That's because the policy is defined by user space, and in contrast to 
CXL, hotplug of APPI is *not* triggered by user space, but by hardware / 
hypervisor.

> 
> This would definitely break things like daxctl/ndctl, but maybe that's
> preferable?  I pointed out that patch 8 does this anyway - and I'd like
> input from ndctl folks as to whether that should end in a NACK.

You mean that it would break the ndctl option to keep memory offline?

Can't ndctl just use the old (existing) interface if such an operation 
is requested, and the new one (you want to add) when we want to do 
something reasonable (actually use system ram? :) ).

-- 
Cheers

David
