Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE33449991;
	Thu,  9 Jul 2026 18:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783623218; cv=none; b=PMq1dzevZarF1YsXKwhU7fxW+XpQ3jo7fjI/Z4Ph532W3f+pxheXAG9yQkhKVLnz9eSJHv78dX2GBCeYoXfY+aAW4lgYZzdHGIN8JzH8uLXVBMcVdimLd7lhilKSC2KpSeBfpqBJ368QY9vtjvieTYdA/xNvSOwXN9uDpeLXL7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783623218; c=relaxed/simple;
	bh=LWIYIVvgdWKhwMP33tl30RMSOxpaqVLRpXYaD3FEX/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XftCA0TZv+r1Y6wS4iKeNVPWINP37Qw8giWFzNgH1QnDKaE+RTvq6shsbgV3BAuN1l4e4SguIG9XEMKwouz47gNWYHpkvF9WQY6/ect/grr7GzWSsL41P0ZYXwbFECuzV29lSD/AyUZ0P6jr7lT8c81Zp74yVnthFVDYzhM1ZJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5fYQ/uU; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5fYQ/uU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783623217; x=1815159217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LWIYIVvgdWKhwMP33tl30RMSOxpaqVLRpXYaD3FEX/o=;
  b=e5fYQ/uUTq0SFh0MfWoBtA4kos8eD/HcqlbRzJlmEB1UDzFhTqsL7ShA
   xIp9WViLGZBh1XcIQczUobwTSgjR+cTb0TXlusR04BKcG138NQAiI6iCJ
   zdDLsxqJPWIH8TFMlplP4c7bBsLJdNBHKL6Zl1GD26uWvsqAxjFNaArpc
   VzSGbGROQyjUnJ7dUApeLqU+XLp0rrlobKeO8XoSS5+DMkK/W1c1SfCfK
   j66NjZt9fDIT/WF/BBVcltZpNX4TisEf8EhGdglTE4sNTUO4oJEJqAX7D
   UEtl7lT5f3mUpgys26MZ1WrjGR+6gMUFA90A74p3u1S8zKNo8VbSW/YDx
   A==;
X-CSE-ConnectionGUID: 4zBqQlusSoyyC2Ibvlw0VQ==
X-CSE-MsgGUID: /P8vFfXURJ28j/wLwZGH0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="86863315"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="86863315"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:53:36 -0700
X-CSE-ConnectionGUID: 8y4wDk/dRRm6acAzB59uyw==
X-CSE-MsgGUID: O3/+HRVRQj2m6mIsYe7DqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252933813"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:53:34 -0700
Message-ID: <48645b42-64e7-4f96-9113-b136386038f0@intel.com>
Date: Thu, 9 Jul 2026 11:53:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/30/26 2:18 PM, Gregory Price wrote:
> offline_and_remove_memory() handles a single contiguous range.
> 
> Callers that manage a device composed of several ranges (dax/kmem)
> currently have to call it in a loop, which gives up atomicity.
> 
> In addition to pushing rollback logic into the driver, the lack
> of atomicity creates a race condition between system daemons trying
> to manage the same resource:
> 
>    - Manager 1:  Offlines memory blocks.    Removes device.
>                                         ^^^^
>    - Manager 2:  Detects offline memory blocks, re-onlines them.
> 
> Add offline_and_remove_memory_ranges(), which takes an array of ranges
> and processes them as one operation under a single lock_device_hotplug():
> 
>   - Phase 1 offlines every block of every range.
>   - Phase 2 removes the ranges only if all ranges are offline.
>   - If any offline fails, the whole operation is reverted.
> 
> This gives callers all-or-nothing semantics for the offline step, so a
> failed or interrupted unplug leaves the device in a consistent state.
> 
> This also resolves the battling managers race - the second manager's
> operation simply fails when the block is destroyed / cannot be onlined.
> 
> offline_and_remove_memory() becomes a thin wrapper that passes its single
> range to the new helper, so the offline/rollback logic lives in one place.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>

With Richard's comment addressed,
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h |  8 +++
>  mm/memory_hotplug.c            | 93 ++++++++++++++++++++++++----------
>  2 files changed, 73 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index ff3b865ea7e7..db10d50f30ae 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  extern int remove_memory(u64 start, u64 size);
>  extern void __remove_memory(u64 start, u64 size);
>  extern int offline_and_remove_memory(u64 start, u64 size);
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges);
>  
>  #else
>  static inline void try_offline_node(int nid) {}
> @@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
>  }
>  
>  static inline void __remove_memory(u64 start, u64 size) {}
> +
> +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	return -EBUSY;
> +}
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504..3225364bec2f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -2429,58 +2429,95 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
>   */
>  int offline_and_remove_memory(u64 start, u64 size)
>  {
> -	const unsigned long mb_count = size / memory_block_size_bytes();
> +	struct range range = {
> +		.start = start,
> +		.end = start + size - 1,
> +	};
> +
> +	return offline_and_remove_memory_ranges(&range, 1);
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +
> +/**
> + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> + * @ranges: array of physical address ranges to offline and remove
> + * @nr_ranges: number of entries in @ranges
> + *
> + * Offline and remove several memory ranges as one operation, serialized
> + * against other hotplug operations by a single lock_device_hotplug().
> + *
> + * This offlines all ranges before removing any of them.  If offlining any
> + * range fails, the entire process is reverted and nothing is removed.
> + * This provides a fully atomic semantic for unplugging an entire device.
> + *
> + * Each range must be memory-block aligned in start and size.
> + *
> + * Return: 0 on success, negative errno otherwise.  On failure no range has
> + * been removed.
> + */
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	unsigned long mb_count = 0;
>  	uint8_t *online_types, *tmp;
> -	int rc;
> +	unsigned int i;
> +	int rc = 0;
>  
> -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +	if (!ranges || !nr_ranges)
>  		return -EINVAL;
>  
> +	for (i = 0; i < nr_ranges; i++) {
> +		const u64 start = ranges[i].start;
> +		const u64 size = range_len(&ranges[i]);
> +
> +		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +			return -EINVAL;
> +		mb_count += size / memory_block_size_bytes();
> +	}
> +
>  	/*
> -	 * We'll remember the old online type of each memory block, so we can
> -	 * try to revert whatever we did when offlining one memory block fails
> -	 * after offlining some others succeeded.
> +	 * Remember the old online type of every memory block across all ranges,
> +	 * so we can revert if offlining a later block fails.  All entries start
> +	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
>  	 */
>  	online_types = kmalloc_array(mb_count, sizeof(*online_types),
>  				     GFP_KERNEL);
>  	if (!online_types)
>  		return -ENOMEM;
> -	/*
> -	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
> -	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
> -	 * try_reonline_memory_block().
> -	 */
>  	memset(online_types, MMOP_OFFLINE, mb_count);
>  
>  	lock_device_hotplug();
>  
> +	/* Phase 1: offline every block in every range. */
>  	tmp = online_types;
> -	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
> -
> -	/*
> -	 * In case we succeeded to offline all memory, remove it.
> -	 * This cannot fail as it cannot get onlined in the meantime.
> -	 */
> -	if (!rc) {
> -		rc = try_remove_memory(start, size);
> +	for (i = 0; i < nr_ranges; i++) {
> +		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
> +					&tmp, try_offline_memory_block);
>  		if (rc)
> -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> +			break;
>  	}
>  
> -	/*
> -	 * Rollback what we did. While memory onlining might theoretically fail
> -	 * (nacked by a notifier), it barely ever happens.
> -	 */
> +	/* If any failure occurred at all, rollback any changes and bail */
>  	if (rc) {
>  		tmp = online_types;
> -		walk_memory_blocks(start, size, &tmp,
> -				   try_reonline_memory_block);
> +		for (i = 0; i < nr_ranges; i++)
> +			walk_memory_blocks(ranges[i].start,
> +					   range_len(&ranges[i]), &tmp,
> +					   try_reonline_memory_block);
> +		goto out_unlock;
>  	}
> +
> +	/* Phase 2: Remove. This should never fail holding the hotplug lock */
> +	for (i = 0; i < nr_ranges; i++)
> +		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i])));
> +
> +out_unlock:
>  	unlock_device_hotplug();
>  
>  	kfree(online_types);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */

