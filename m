Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3CA1E835D
	for <nvdimm@lists.linux.dev>; Tue,  7 Oct 2025 16:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759853509; cv=none; b=VHub+aoK8kcH8n40Ej3d3Fj0GnLdtduCWlYZ1Nvoa4n+uwGWz36BIbCUUxRKogX26+OOoURVOTlJJspQ66Bt6nxe/tIr+iJBS6a3eoR0aeaAD4TGrvVDm0IJJNOKqhc1MV6VsRbdbR3vr+9Rf2KOAghDstc7phNHbrK4pmvTwCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759853509; c=relaxed/simple;
	bh=XQrCKVPmICvJTPfSvs3P2h3RnGlmC9gtUYDuYH5zYTc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YVpake0a3SoZ/GN0rdzVLW8Jkc33qFl2KPz4s5AIm290Appm5MLzjjYm54nal/1hC14yqmFtYEKap03rw2kT70EtL6YRtCYblUZSmr8te1/Iv71ggJkfScpr8rc73JEaMwO4wlROP0i646prheIyN/U6HeToxh3BHwJu3+nOZ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O48tUbty; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O48tUbty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759853508; x=1791389508;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XQrCKVPmICvJTPfSvs3P2h3RnGlmC9gtUYDuYH5zYTc=;
  b=O48tUbtyMDchh/tkpH7Ee3WW/ujOE5vMNxGhuuNuxcq8DXjsK0aduIJh
   e4ybOmKY+kjeSGWi6cZ9bGYbriDkZNNOYSP5ZntSwYCyWAoEA2ddNAPOy
   75ZDPuJGaVn0e1l+k84P418dQ+a+ddeWhp8JaavhVHWsVNrAIvr06KJl2
   o+y3YExTQNaNXBgA5dzJ2f2m/lFhlahmICpMVcUz69BIp7fsnm92D7xEw
   7Q239f6o2RpPY8sf3BfOe3dsWwofOWwropwzIT8syMYgHO0ZOoAYVcK1B
   BhejDoZeG2bxWnB1fMu4Ks9wQs7zjd200oD28az0/ad7ZVX3TUK6zueep
   g==;
X-CSE-ConnectionGUID: TCHVD9klRDeycWNFPsFcaw==
X-CSE-MsgGUID: FIvOPhKOTSipzeZLxJXiLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61988444"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61988444"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 09:11:47 -0700
X-CSE-ConnectionGUID: qitWWa8VSNi+aD3MGTy17w==
X-CSE-MsgGUID: nEPt6t5GQC62dV9xV9VBmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="180002435"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.110.156]) ([10.125.110.156])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 09:11:47 -0700
Message-ID: <a7223011-5fee-43d4-8053-5fe70e3dd33f@intel.com>
Date: Tue, 7 Oct 2025 09:11:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dax/hmem: Fix lockdep warning for
 hmem_register_resource()
To: dan.j.williams@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, ira.weiny@intel.com
References: <20251007001252.2710860-1-dave.jiang@intel.com>
 <68e46a09c2a07_2980100f3@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <68e46a09c2a07_2980100f3@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/6/25 6:16 PM, dan.j.williams@intel.com wrote:
> Dave Jiang wrote:
>> The following lockdep splat was observed while kernel auto-online a CXL
>> memory region:
>>
> 
> The entire spew with timestamps does not need to be saved in the git
> history I would trim this to:
> 
> ---
>  ======================================================
>  WARNING: possible circular locking dependency detected
>  6.17.0djtest+ #53 Tainted: G        W
>  ------------------------------------------------------
>  systemd-udevd/3334 is trying to acquire lock:
>  ffffffff90346188 (hmem_resource_lock){+.+.}-{4:4}, at: hmem_register_resource+0x31/0x50
> 
>  but task is already holding lock:
>  ffffffff90338890 ((node_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x2e/0x70
> 
>  which lock already depends on the new lock.
>  [..]
>  Chain exists of:
>    hmem_resource_lock --> mem_hotplug_lock --> (node_chain).rwsem
> 
>   Possible unsafe locking scenario:
> 
>         CPU0                    CPU1
>         ----                    ----
>    rlock((node_chain).rwsem);
>                                 lock(mem_hotplug_lock);
>                                 lock((node_chain).rwsem);
>    lock(hmem_resource_lock);
> ---
> 
>> The lock ordering can cause potential deadlock. There are instances
>> where hmem_resource_lock is taken after (node_chain).rwsem, and vice
>> versa. Narrow the scope of hmem_resource_lock in hmem_register_resource()
>> to avoid the circular locking dependency. The locking is only needed when
>> hmem_active needs to be protected.
> 
> It is only strictly necessary for hmem_active, but it happened to be
> protecting theoretical concurrent callers of hmat_register_resource(). I
> do not think it can happen in practice, but it is called by both initial
> init and runtime notifier. The notifier path does:
> 
> hmat_callback() -> hmat_register_target()
> 
> That path seems impossible to add new hmem devices, but it is burning
> cycles walking through all the memory ranges associated with a target
> only to find that they are already registered. I think that can be
> cleaned up with an unlocked check of target->registered.
> 
> If that loses some theoretical race then your new
> hmem_request_resource() will pick a race winner for that target.
> 
> Otherwise, the code *looks* like it has a TOCTOU race with
> platform_initialized. So feels like some comments and cleanups to make
> that clear are needed.
> 
> Really I think hmat_callback() path should not be doing *any*
> registration work, only update work.

So are you saying that hmat_callback() should skip hmat_register_target_devices() when calling hmat_register_target()? hmat_init() calls hmat_register_targets() and hmem_init() also basically does something similar. So from that perspective, hmat_callback() shouldn't be finding something new. However if we drop the hmat_register_target() and a memory device gets hot-plugged (i.e. a new card gets inserted), do we lose something?

If we base the calling of hmat_register_target_devices() on target->registered, I don't think it removes the lockdep splat because the locking order is unchanged.

DJ

> 
>> Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  drivers/dax/hmem/device.c | 42 +++++++++++++++++++++++----------------
>>  1 file changed, 25 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/dax/hmem/device.c b/drivers/dax/hmem/device.c
>> index f9e1a76a04a9..ab5977d75d1f 100644
>> --- a/drivers/dax/hmem/device.c
>> +++ b/drivers/dax/hmem/device.c
>> @@ -33,21 +33,37 @@ int walk_hmem_resources(struct device *host, walk_hmem_fn fn)
>>  }
>>  EXPORT_SYMBOL_GPL(walk_hmem_resources);
>>  
>> -static void __hmem_register_resource(int target_nid, struct resource *res)
>> +static struct resource *hmem_request_resource(int target_nid,
>> +					      struct resource *res)
>>  {
>> -	struct platform_device *pdev;
>>  	struct resource *new;
>> -	int rc;
>>  
>> -	new = __request_region(&hmem_active, res->start, resource_size(res), "",
>> -			       0);
>> +	guard(mutex)(&hmem_resource_lock);
>> +	new = __request_region(&hmem_active, res->start,
>> +			       resource_size(res), "", 0);
>>  	if (!new) {
>>  		pr_debug("hmem range %pr already active\n", res);
>> -		return;
>> +		return ERR_PTR(-ENOMEM);
> 
> Probably does not matter since noone consumes this code, but this is
> more -EBUSY than -ENOMEM.

