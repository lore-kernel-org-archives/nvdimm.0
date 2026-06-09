Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36B43F1650;
	Tue,  9 Jun 2026 10:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781000776; cv=none; b=g+VkYlQIlt6hh/Hb00y6haLaWGK4WOysZLy/oV1vr7FfCDMI2+A/Ao+WzRpKzi0nOVSOS4V35CP/YhUvd3q+A4aglFhJUtcvkO3mvgee3vL6ShlJsQF/x2yEBXqRndDv3uL1HoOCySeueFF/f6lMX2LDXKztALznVKAQzi4BkZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781000776; c=relaxed/simple;
	bh=jiYvLN8svyHuJqKwo71fxIiMTXTLF3Yc0BJM0glY6Sg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C6Uwo77W+2QNZtSu1fLVjvnpzGYKDTHP6Yq+B8E1/Pm6C8LWeKIAdjH2MrhA/sVxW7N3GDfg9iYwznjFukRAyad4AhADj+LugSxPmmJNDkgLpKQi6MR3PgwDoLyGgsKD8XwJk3e0+SQayDJ5t32tzAesQwDx2Ef4/+LdVBwNUKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3jk3COn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3jk3COn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308C21F0089E;
	Tue,  9 Jun 2026 10:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000774;
	bh=Z5PT1RzmSV79eYY4zL3bKgn3v9w+YXzq+ASHx5ToH88=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J3jk3COnoJEBzr6R0/A18Y8cFME/QVHZhvy1WGyNQRfxkmDA84cHMG5UrUhfOmsAu
	 +vL6dlwOBJ5Rd17X6zDeYucKliep/9USLhr8DsgOpK5LIf/B7bUMlhzITIXvYvS4SA
	 JGT4TNAVSB4Nt8v4hVjCSR8dYA4IekBB5qyAWvSruEOzO5oSgrUREVUXhJSCWXFpU2
	 V803g9md/aZOzE3DFmJ0IRqsMckdhnGIdYKEv/VLiEKJuuFM4QMiBJPWz3I7G8WfsB
	 EtC1Eeclwdlj3N0CWsbNMG0MEXcuJQh7C9MuOOqkYCm85cEgoFt9sMlb7Y+S16+nvs
	 wd0A0dSfucg/A==
Message-ID: <1cb0514b-c753-411e-8ff8-80fa29837441@kernel.org>
Date: Tue, 9 Jun 2026 12:26:07 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com, Hannes Reinecke <hare@suse.de>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-9-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260605211911.2160954-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/26 23:19, Gregory Price wrote:
> The dax kmem driver currently onlines memory automatically during
> probe using the system's default online policy but provides no way
> to control or query the entire region state at runtime.
> 
> Additionally, there is no atomic mechanism to offline and remove
> the entire set of memory blocks together.  Instead, this is presently
> done in two steps: (offline all, remove all).  This creates a race
> condition where external entities can operate directly on the blocks
> and cause hot-unplug to fail.
> 
> Add a new 'hotplug' sysfs attribute that allows userspace to control
> and query the entire memory region state.  The writable states mirror
> the per-block /sys/devices/system/memory/memoryX/state ABI:
>   - "unplugged": memory blocks are not present
>   - "online": memory is online, zone chosen by the kernel
>   - "online_kernel": memory is online in ZONE_NORMAL
>   - "online_movable": memory is online in ZONE_MOVABLE
> 
> The "unplugged" state is new and only applies to kmem/hotplug.
> 
> Valid transitions:
>   - unplugged                               -> online[_kernel|_movable]
>   - online | online_kernel | online_movable -> unplugged
>   - offline                                 -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe: existing tools expect them to be present once the kmem driver
> binds.  When the configured policy (mhp_get_default_online_type())
> selects an online state the blocks are onlined into that policy's zone;
> when the policy is offline the blocks are created but left offline and
> the device reports the state "offline".
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy. Onlining such
> a device through this attribute requires unplugging it first.
> 
> The "offline" state may be deprecated later if the memory block ABI
> changes and userland migrates to using the region-wide hotplug.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation
> via offline_and_remove_memory_ranges().  Either all ranges are removed
> and the device becomes "unplugged", or offlining is rolled back and the
> device is left fully online, so the reported 'hotplug' state always
> matches reality.
> 
> Unbind Note:
>   We used to call remove_memory() during unbind, which would fire a
>   BUG() if any of the memory blocks were online at that time.  We lift
>   this into a WARN in the cleanup routine and don't attempt hotremove
>   if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.  Memory that is
>   merely offline (the legacy "offline" state) is removed on unbind as
>   before; only online memory is left pinned.
> 
>   The resources are still leaked but this prevents deadlock on unbind
>   if a memory region happens to be impossible to hotremove.
> 
> Inconsistency Note:
> 
>   Since memory blocks can still be modified individually, the hotplug
>   attribute can become out of sync with the state of the system if
>   userland software mixes and matches the use of memory_block ABI and
>   kmem/hotplug ABI.  It's suggests to use one or the other.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

[...]

>  
> +static int dax_kmem_parse_state(const char *buf)
> +{
> +	if (sysfs_streq(buf, "unplugged"))
> +		return DAX_KMEM_UNPLUGGED;
> +	if (sysfs_streq(buf, "online"))
> +		return MMOP_ONLINE;
> +	if (sysfs_streq(buf, "online_kernel"))
> +		return MMOP_ONLINE_KERNEL;
> +	if (sysfs_streq(buf, "online_movable"))
> +		return MMOP_ONLINE_MOVABLE;
> +	return -EINVAL;

Should we try making use of mhp_online_type_from_str()/online_type_to_str()
[possibly a nicer exported function for the latter] to avoid duplicating this ...

> +}
> +
> +static ssize_t hotplug_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct dax_kmem_data *data = dev_get_drvdata(dev);
> +	const char *state_str;
> +
> +	if (!data)
> +		return -ENXIO;
> +
> +	switch (data->state) {
> +	case DAX_KMEM_UNPLUGGED:
> +		state_str = "unplugged";
> +		break;
> +	case MMOP_OFFLINE:
> +		state_str = "offline";
> +		break;
> +	case MMOP_ONLINE:
> +		state_str = "online";
> +		break;
> +	case MMOP_ONLINE_KERNEL:
> +		state_str = "online_kernel";
> +		break;
> +	case MMOP_ONLINE_MOVABLE:
> +		state_str = "online_movable";
> +		break;

...

and this?


[sorry if we already discussed this]

-- 
Cheers,

David
