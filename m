Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB173C4141;
	Thu, 25 Jun 2026 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782372131; cv=none; b=Q6mMSlbdk0oEbDnAXNOwbhgizwzFTQKAyq9sa8O0WYooZfR+KuL5jx1ywEnMQQ3MC3r4wRTIV1Gl6mCnuog17L/AHS2aY2IGkC/NvJd4zx6ASnO+VdTDj+sLOkvT0rEdFzNHlm6KNCVu+G96zXP8HC5JBvL1/gQrL8pNwW1kq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782372131; c=relaxed/simple;
	bh=Prneo+uvw1SpQjyT5LvyIQ5WuFu3zejpeH6BN+yYyuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPbZwdDzhQjTMsrUi9H3369DMR9JfFUYZqkaIXqTXxxJJqj4LUSq2DK4A3p7pvEA6heiG+/BfLHGoJO/0S/m0FYIsM+F6cMMRq1EvAns3/jGPxNmw8KtV2fWNfjGShiePt6pXECXqqGPOgYrWnbWcTUq47ik2tm3HXe9h2FKtqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1/Dnajf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1/Dnajf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1B1F00A3A;
	Thu, 25 Jun 2026 07:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782372129;
	bh=OFch8xfYafXAxet82DZba+2m8gYlLknO0OujKt7NZU8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y1/DnajfmCFs/nmgeNGooZrEmihPfwdDYtZEIaqyu/23g+wBwgzpb2VuENF2Ln3ZN
	 0rm7jVv0gQjOqBKrPMNHaWe8NQSkJFD/2f8lMfGBJQsd8KtaCRSmF7+Jo0q5ZZCoq6
	 0r7VZ+QZ5uPU4B0MOsMQudeo/MtrTDiE20LbucC6fvJlJblVMgQqJwTNJNQXzb4xaW
	 g9BKHnrybQm5FD7vMD5YfnItC5vJFOOAMd/fQ4CPJjLeUWzVdI88BSquX9SHdgyAt9
	 H2j6zb7Oy/qpyDAT09MlSreaTMUcKg2PNSqBqGlZJYQA5/5iwOmu+94hZiQCg/7SkV
	 UnaEu/5Jfqifg==
Message-ID: <d48feca1-0203-43ff-bd66-6243291a51ba@kernel.org>
Date: Thu, 25 Jun 2026 09:22:01 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/9] mm/memory_hotplug:
 offline_and_remove_memory_ranges()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
 ira.weiny@intel.com, apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-6-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260624145744.3532049-6-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/26 16:57, Gregory Price wrote:
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
> ---
>  include/linux/memory_hotplug.h |  7 +++
>  mm/memory_hotplug.c            | 94 ++++++++++++++++++++++++----------
>  2 files changed, 74 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index d3edeb80aadb..7f1da7c428dc 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -267,6 +267,7 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  extern int remove_memory(u64 start, u64 size);
>  extern void __remove_memory(u64 start, u64 size);
>  extern int offline_and_remove_memory(u64 start, u64 size);
> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges);
>  
>  #else
>  static inline void try_offline_node(int nid) {}
> @@ -283,6 +284,12 @@ static inline int remove_memory(u64 start, u64 size)
>  }
>  
>  static inline void __remove_memory(u64 start, u64 size) {}
> +
> +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
> +						   int nr_ranges)

Best to use "unsigned int" right from the start and use two tabs to indent.


> +{
> +	return -EBUSY;
> +}
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504..7d56e0c6ede0 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -2429,58 +2429,98 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
>   */
>  int offline_and_remove_memory(u64 start, u64 size)
>  {
> -	const unsigned long mb_count = size / memory_block_size_bytes();
> +	struct range range = { .start = start, .end = start + size - 1 };

I prefer this more readable as:

struct range range = {
	.start = start,
	.end = start + size - 1,
};

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
> +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
> +{
> +	unsigned long mb_total = 0;
>  	uint8_t *online_types, *tmp;
> -	int rc;
> +	int i, rc = 0;
>  
> -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +	if (!ranges || nr_ranges <= 0)

With "unsigned int" this will be !nr_ranges.

Wondering whether we would WARN_ON_ONCE() here.

>  		return -EINVAL;
>  
> +	for (i = 0; i < nr_ranges; i++) {
> +		u64 start = ranges[i].start;
> +		u64 size = range_len(&ranges[i]);

Both can be const.

> +
> +		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +			return -EINVAL;
> +		mb_total += size / memory_block_size_bytes();
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
> -	online_types = kmalloc_array(mb_count, sizeof(*online_types),
> +	online_types = kmalloc_array(mb_total, sizeof(*online_types),
>  				     GFP_KERNEL);

Is "mb_total" really more expressive than "mb_count"?

>  	if (!online_types)
>  		return -ENOMEM;
> -	/*
> -	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
> -	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
> -	 * try_reonline_memory_block().
> -	 */
> -	memset(online_types, MMOP_OFFLINE, mb_count);
> +	memset(online_types, MMOP_OFFLINE, mb_total);
>  
>  	lock_device_hotplug();
>  
> +	/* Phase 1: offline every block in every range. */
>  	tmp = online_types;
> -	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
> +	for (i = 0; i < nr_ranges; i++) {
> +		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
> +					&tmp, try_offline_memory_block);
> +		if (rc)
> +			break;
> +	}
>  
>  	/*
> -	 * In case we succeeded to offline all memory, remove it.
> -	 * This cannot fail as it cannot get onlined in the meantime.
> +	 * Phase 2: Remove each range. This essentially cannot fail as we hold
> +	 * the hotplug lock . WARN if that assumption is ever broken.
>  	 */
>  	if (!rc) {
> -		rc = try_remove_memory(start, size);
> -		if (rc)
> -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> +		for (i = 0; i < nr_ranges; i++) {
> +			rc = try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i]));
> +			if (WARN_ON_ONCE(rc)) {
> +				pr_err("%s: Failed to remove memory: %d",
> +				       __func__, rc);
> +				break;

Do we really want to break? I'd say, just warn and continue, and fake rc == 0.
Something is seriously messed up already, and we partially removed memory. There
is no clean rollback possible.

Similar to __remove_memory(), ignoring the error because it offlined it already.

> +			}
> +		}
>  	}

In general, looks much cleaner to me, thanks!

-- 
Cheers,

David
