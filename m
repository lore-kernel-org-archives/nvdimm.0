Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6252C21D9;
	Mon, 13 Apr 2026 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776091788; cv=none; b=MSlFQ2GYitdv0YejCF3W7eGDKtAGZLvLcXyph4+nhq6mjtM51VFHcpYZLKcMbNzdDFKUjRBSxiOl/ENAKCSwTECvvtlLvyEmAbyNOKc2SFNU70+fhYKUJMQWt8gi5xKCTu+6idNUJLpcbwjqe282Ku00/Shoh1EGS4qE+FLFk7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776091788; c=relaxed/simple;
	bh=mjWzHkibbJ+YGpg8iepNJ9fmO8lj/6ddY53/GhjosH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmAH5NOwTcKPrAc3l5rdiDmUXDbilsanFthTrUBvDwAxPfYdXfsbVkQ+b3FRO0agROgDhwADA6abvUTSCyax2GHxLETNLRgpglrIePgg5c3eRXwhLk46VrcFOjCSvrjvMgk+cyfuTx+3/oFD8sLdW/YbCeV1Q+X2R84cC43oXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXyiDmP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXyiDmP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9A3C2BCAF;
	Mon, 13 Apr 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776091788;
	bh=mjWzHkibbJ+YGpg8iepNJ9fmO8lj/6ddY53/GhjosH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HXyiDmP61caBFR6ZEDJhLV2kLFTrpfWmsebGSZkB4Sz+GvDVozGmf+j4Ma4qLWtHx
	 vblYih3TDYo1K5L/hjqRnJSE/NNvB7I+g8EGy0zEZwP9FErtsWbxwx3MUUBbhwxjXR
	 RiMs+KxEGJ72hftseV0cvzfNjc6QuH1kP9ywyULy3USoTE0IBt5Lkh/vHTRshbQBYO
	 x0qd8ryPHY/QPw1CSAY7abXHysgOhE+zArf5GJu5t6o+6CYS8QeZudssfGWk8HRjTd
	 NIgY1AhwDj7UyixFtsOC3h42MI8HKENmsWkIAwjZwEtCLjiNUUm87amLTdD59FHP6S
	 8PQtsyQyU1o7Q==
Message-ID: <4c08c0a8-9415-4f30-bfa9-db39318fa7d3@kernel.org>
Date: Mon, 13 Apr 2026 16:49:40 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/21/26 16:03, Gregory Price wrote:
> The dax kmem driver currently onlines memory during probe using the
> system default policy, with no way to control or query the region state
> at runtime - other than by inspecting the state of individual blocks.
> 
> Offlining and removing an entire region requires operating on individual
> memory blocks, creating race conditions where external entities can
> interfere between the offline and remove steps.
> 
> The problem was discussed specifically in the LPC2025 device memory
> sessions - https://lpc.events/event/19/contributions/2016/ - where
> it was discussed how the non-atomic interface for dax hotplug is causing
> issues in some distributions which have competing userland controllers
> that interfere with each other.
> 
> This series adds a sysfs "hotplug" attribute for atomic whole-device
> hotplug control, along with the mm and dax plumbing to support it.
> 
> The first five patches prepare the mm and dax layers:
> 
>   1. Consolidate memory-tier type deduplication into mt_get_memory_type(),
>      removing redundant per-driver infrastructure.
>   2. Add a memory_block_align_range() helper for hotplug range alignment.
>   3-5. Thread an explicit online_type through the memory hotplug and dax
>      paths, allowing drivers to specify a preferred auto-online policy
>      (ZONE_NORMAL vs ZONE_MOVABLE) instead of being forced to the
>      system default.
> 
> The last three patches build the dax/kmem feature:
> 
>   6. Plumb online_type through the dax device creation path.
>   7. Extract hotplug/hotremove into helper functions to separate resource
>      lifecycle from memory onlining.
>   8. Add the "hotplug" sysfs attribute supporting three states:
>      - "unplug": memory blocks removed
>      - "online": online as normal system RAM
>      - "online_movable": online in ZONE_MOVABLE
> 
> Transitions are atomic across all ranges in the device.  Backward
> compatibility is preserved: probe still auto-onlines when the configured
> policy matches the system default.
> 
> Specific notes for maintainers:
> 
> I downgraded a BUG() to a WARN() when unbind is called while the dax
> device is not un an UNPLUGGED state.  This is because the old pattern of
> toggling individual memory blocks is still used by userland tools, and
> will disconnect the `hotplug` value from the actual state of the overall
> memory region.
> 
> Unless we move to deprecate per-block controls, we should just WARN()
> instead of BUG() as an indicator that userland tools need to be updated
> to use the new pattern (the old pattern is subject to race conditions).
> 
> The first two commits are semi-unrelated cleanups that conflict with the
> changes made in the refactoring commits. (memory-tier dedup and align_range
> helper). These are intended to be used for future cxl region extensions,
> but if you prefer them to be dropped or submitted separately let me
> know.
> 
> This is technically v3, but the patch line has diverged considerably and
> I've reworked the cover letter, apologies for prior obtuseness
> Link: https://lore.kernel.org/all/20260114235022.3437787-1-gourry@gourry.net/


Hi Gregory,

against which branch / base commit is this series?

-- 
Cheers,

David
