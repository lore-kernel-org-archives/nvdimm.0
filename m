Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0DD42EEC8
	for <nvdimm@lists.linux.dev>; Thu, 28 May 2026 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982968; cv=none; b=R3x3F97BCDMWW5KCjbaB3AkZoWIsg8Z8ocjTB6PEFRITIBHpD8y2TkK1CuzMWVel2bdp4JnQs5VYsbSdihiV3btHPMvrsAGcZZM61mAXm3tEw1K89rd0mZYQyHxfdryIVB3uzeun/JGCMLjeYmkCmUyPLAlyzJJvtFnYfcF4Y5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982968; c=relaxed/simple;
	bh=/QndPVdHkOkGzQ0HHMoHpUiW3WBjYxQ5419hVlzYsu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWwNJHs9Dh0owsupEsiwiht8xduoi+R9hV97a2MjkUo9eV2tpHHBbJF3+abZoUq6zAkcAycpyPm21G2H+5+mxx9pcdMmvhLGsawj0dOansWCVZPzeuK2eryORjLDd5K1Xj1u8iFePVirRFHRStpI7Mzdor+EJdyj62C6+v293uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DOrp8K2N; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DOrp8K2N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779982962; x=1811518962;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/QndPVdHkOkGzQ0HHMoHpUiW3WBjYxQ5419hVlzYsu8=;
  b=DOrp8K2NHg4JEYErqhlwB+ZvKCw04CczRDPEBFatcQGK23TbJMRcFFgP
   Pk3fL3Fwlc5B/oxZFyw/QjyTP+dRNsVWDCuI2A8j6S8w04M+XrSq9R8xR
   5LAS/XiYWYRN63coYJiuGziePyT3U+iKkOL4hC7NZlJ0jz4zbrmnpufT6
   hLcGgcLAkyvvPJvG4aaN+/ux4JXHC1fh8blyF5nlagQXknoHQsVMO5q0C
   yBODuu/ggf7qeYeybMihLC1T77LwsvVUpmB1Xp40AT6mLVrhemrHMG9HC
   IdSCbyshDX4nPOhVQPsEw9WxQ55gPpUklHUWWffoMNKmDLRkyrFDzFgCE
   w==;
X-CSE-ConnectionGUID: SY+1EO+bQFaDDUTgEPWBcg==
X-CSE-MsgGUID: mvcMFhcaQ9KJGryiLiKVkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80819955"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="80819955"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:42:42 -0700
X-CSE-ConnectionGUID: KIgMI55fSv605LuBs7WMzg==
X-CSE-MsgGUID: ptUJhRyXR22Zqa/LXs7y1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="272915902"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.111.91]) ([10.125.111.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 08:42:41 -0700
Message-ID: <f173da97-4098-4f05-98cc-a94b94dd4aab@intel.com>
Date: Thu, 28 May 2026 08:42:40 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] nvdimm/btt: Handle preemption in BTT lane acquisition
To: Alison Schofield <alison.schofield@intel.com>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Ira Weiny <iweiny@kernel.org>, Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: nvdimm@lists.linux.dev
References: <20260528021625.618462-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260528021625.618462-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/27/26 7:16 PM, Alison Schofield wrote:
> BTT lanes serialize access to per-lane metadata and workspace state
> during BTT I/O. The btt-check unit test reports data mismatches during
> BTT writes due to a race in lane acquisition that can lead to silent
> data corruption.
> 
> The existing lane model uses a spinlock together with a per-CPU
> recursion count. That recursion model stopped being valid after BTT
> lanes became preemptible: another task can run on the same CPU,
> observe a non-zero recursion count, bypass locking, and use the same
> lane concurrently.
> 
> BTT lanes are also held across arena_write_bytes() calls. That path
> reaches nsio_rw_bytes(), which flushes writes with nvdimm_flush().
> Some provider flush callbacks can sleep, making a spinlock the wrong
> primitive for the lane lifetime.
> 
> Replace the spinlock-based recursion model with a dynamically
> allocated per-lane mutex array and take the lane lock
> unconditionally.
> 
> Add might_sleep() to catch any future atomic-context caller.
> 
> Found with the ndctl unit test btt-check.sh.
> 
> Fixes: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
> Assisted-by: Claude Sonnet 4.5
> Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
> 
> A new unit test to stress this is under review here:
> https://lore.kernel.org/nvdimm/20260424233633.3762217-1-alison.schofield@intel.com/
> 
> Changes in v6:
> - Add mutex_destroy() to match dynamic allocation (Aboorva)
> - btt.rst drop the stale 'if more CPUs than lanes qualifier (Vishal)
> - Rename struct nd_percpu_lane to struct nd_lane (Vishal)
> - Drop the stale __percpu annotation on nd_region->lane (Vishal)
> - Move struct nd_lane definition to avoid a checkpatch false positive
> 
> Changes in v5:
> - Align lane mutex entries to cachelines in SMP builds (Sashiko AI)
> - Add sparse lock annotations for lane mutexes (DaveJ)
> - s/spinlock/mutexes in the driver-api doc btt.rst
> 
> Changes in v4:
> - Replace per-CPU lane storage w dynamically allocated mutex array (Sashiko AI)
> - Remove the recursion fast path and take the lane lock unconditionally
> - Update commit log
> 
> Changes in v3:
> Replace spinlock with a per-lane mutex (Arboorva)
> 
> Changes in v2:
> Use spin_(un)lock_bh() (Sashiko AI)
> Update commit log per softirq re-enty and spinlock change
> 
> 
>  Documentation/driver-api/nvdimm/btt.rst |  5 +-
>  drivers/nvdimm/nd.h                     | 11 ++---
>  drivers/nvdimm/region_devs.c            | 66 +++++++++----------------
>  3 files changed, 29 insertions(+), 53 deletions(-)
> 
> diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
> index 2d8269f834bd..d29fab95f149 100644
> --- a/Documentation/driver-api/nvdimm/btt.rst
> +++ b/Documentation/driver-api/nvdimm/btt.rst
> @@ -161,9 +161,8 @@ process::
>  	nlanes = min(nfree, num_cpus)
>  
>  A lane number is obtained at the start of any IO, and is used for indexing into
> -all the on-disk and in-memory data structures for the duration of the IO. If
> -there are more CPUs than the max number of available lanes, than lanes are
> -protected by spinlocks.
> +all the on-disk and in-memory data structures for the duration of the IO. Lanes
> +are protected by mutexes.
>  
>  
>  d. In-memory data structure: Read Tracking Table (RTT)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index b199eea3260e..197e5368c0a4 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -365,11 +365,6 @@ unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
>  	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
>  			res; res = next, next = next ? next->sibling : NULL)
>  
> -struct nd_percpu_lane {
> -	int count;
> -	spinlock_t lock;
> -};
> -
>  enum nd_label_flags {
>  	ND_LABEL_REAP,
>  };
> @@ -400,6 +395,10 @@ struct nd_mapping {
>  	struct nvdimm_drvdata *ndd;
>  };
>  
> +struct nd_lane {
> +	struct mutex lock; /* serialize lane access */
> +} ____cacheline_aligned_in_smp;
> +
>  struct nd_region {
>  	struct device dev;
>  	struct ida ns_ida;
> @@ -420,7 +419,7 @@ struct nd_region {
>  	struct kernfs_node *bb_state;
>  	struct badblocks bb;
>  	struct nd_interleave_set *nd_set;
> -	struct nd_percpu_lane __percpu *lane;
> +	struct nd_lane *lane;
>  	int (*flush)(struct nd_region *nd_region, struct bio *bio);
>  	struct nd_mapping mapping[] __counted_by(ndr_mappings);
>  };
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index e35c2e18518f..5e079d61cbaa 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -192,7 +192,9 @@ static void nd_region_release(struct device *dev)
>  
>  		put_device(&nvdimm->dev);
>  	}
> -	free_percpu(nd_region->lane);
> +	for (i = 0; i < nd_region->num_lanes; i++)
> +		mutex_destroy(&nd_region->lane[i].lock);
> +	kfree(nd_region->lane);
>  	if (!test_bit(ND_REGION_CXL, &nd_region->flags))
>  		memregion_free(nd_region->id);
>  	kfree(nd_region);
> @@ -904,52 +906,30 @@ void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
>   * nd_region_acquire_lane - allocate and lock a lane
>   * @nd_region: region id and number of lanes possible
>   *
> - * A lane correlates to a BLK-data-window and/or a log slot in the BTT.
> - * We optimize for the common case where there are 256 lanes, one
> - * per-cpu.  For larger systems we need to lock to share lanes.  For now
> - * this implementation assumes the cost of maintaining an allocator for
> - * free lanes is on the order of the lock hold time, so it implements a
> - * static lane = cpu % num_lanes mapping.
> + * A lane correlates to a log slot in the BTT. Lanes are shared across
> + * CPUs using a static lane = cpu % num_lanes mapping, with a per-lane
> + * mutex to serialize access.
>   *
> - * In the case of a BTT instance on top of a BLK namespace a lane may be
> - * acquired recursively.  We lock on the first instance.
> - *
> - * In the case of a BTT instance on top of PMEM, we only acquire a lane
> - * for the BTT metadata updates.
> + * Callers must be in sleepable context. The only in-tree caller is
> + * BTT's ->submit_bio handler (btt_read_pg / btt_write_pg).
>   */
>  unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
> +	__acquires(&nd_region->lane[lane].lock)
>  {
> -	unsigned int cpu, lane;
> +	unsigned int lane;
>  
> -	migrate_disable();
> -	cpu = smp_processor_id();
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		lane = cpu % nd_region->num_lanes;
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (ndl_count->count++ == 0)
> -			spin_lock(&ndl_lock->lock);
> -	} else
> -		lane = cpu;
> +	might_sleep();
>  
> +	lane = raw_smp_processor_id() % nd_region->num_lanes;
> +	mutex_lock(&nd_region->lane[lane].lock);
>  	return lane;
>  }
>  EXPORT_SYMBOL(nd_region_acquire_lane);
>  
>  void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
> +	__releases(&nd_region->lane[lane].lock)
>  {
> -	if (nd_region->num_lanes < nr_cpu_ids) {
> -		unsigned int cpu = smp_processor_id();
> -		struct nd_percpu_lane *ndl_lock, *ndl_count;
> -
> -		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
> -		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
> -		if (--ndl_count->count == 0)
> -			spin_unlock(&ndl_lock->lock);
> -	}
> -	migrate_enable();
> +	mutex_unlock(&nd_region->lane[lane].lock);
>  }
>  EXPORT_SYMBOL(nd_region_release_lane);
>  
> @@ -1019,17 +999,16 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  			goto err_id;
>  	}
>  
> -	nd_region->lane = alloc_percpu(struct nd_percpu_lane);
> +	nd_region->num_lanes = ndr_desc->num_lanes;
> +	if (!nd_region->num_lanes)
> +		goto err_percpu;
> +	nd_region->lane = kcalloc(nd_region->num_lanes,
> +				  sizeof(*nd_region->lane), GFP_KERNEL);
>  	if (!nd_region->lane)
>  		goto err_percpu;
>  
> -        for (i = 0; i < nr_cpu_ids; i++) {
> -		struct nd_percpu_lane *ndl;
> -
> -		ndl = per_cpu_ptr(nd_region->lane, i);
> -		spin_lock_init(&ndl->lock);
> -		ndl->count = 0;
> -	}
> +	for (i = 0; i < nd_region->num_lanes; i++)
> +		mutex_init(&nd_region->lane[i].lock);
>  
>  	for (i = 0; i < ndr_desc->num_mappings; i++) {
>  		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
> @@ -1046,7 +1025,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  	}
>  	nd_region->provider_data = ndr_desc->provider_data;
>  	nd_region->nd_set = ndr_desc->nd_set;
> -	nd_region->num_lanes = ndr_desc->num_lanes;
>  	nd_region->flags = ndr_desc->flags;
>  	nd_region->ro = ro;
>  	nd_region->numa_node = ndr_desc->numa_node;
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731

