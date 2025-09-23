Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9261323408
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 16:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758645382; cv=none; b=eddn5molRpeV9KLcExxwSjEuPHyogJGhhycVvr1Le1OunquWaeNNiyEzfQHvCX56W4GfPp1E1gljAIwkAuycurPWz/WkJ10a4TLc5Y3G0aa1pzGcJfhFLLs14ALgczD289fft0d9Dir+f0bbn5co6jwXCQKMszSsjLtpR+3aYHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758645382; c=relaxed/simple;
	bh=gz1RGKhRqXBe//DTULP0B6zotX8BPcsEuh8LFHOxO+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1Wao9I8pi497SlCYKdK6RjeO99LoQH7TKvhjabcbORNAwIXshmgMSLPdvNaoJaWTgIbhBKOo9kLQNyLflsaGmbWuWV7qHmI1FUPh3c0L9QUk0e5Nx9rPtXHIod0rvaZWlFMXC8FkypfbBZZthjd9/5LO6T6J0D5Bvz08ZIgspw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XuSoinlt; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XuSoinlt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758645379; x=1790181379;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gz1RGKhRqXBe//DTULP0B6zotX8BPcsEuh8LFHOxO+I=;
  b=XuSoinltre2OT7Z0mHw1epck0uZ7S3czWxOH/KWtjLBMZEP768X5ZbJk
   yGM370qTd6n1glzLW+C36TMUKTS7dYUE/UZNzFV0vlSKf6/1D4q/+jb9v
   S7SYppj3xpnPK6k4lLmpi5qCXnnBcSUxEmHDTd61QAlRaF7inWBLGigKg
   jQvJXJ6PUaHUQFepCzsshjz+mjpTTtJT+8SP4HrUGbIIRTz5lCqNUb1tt
   tldkroBcCoO56mnSQ34KpfVfPDTunw2WGw4q1mhiLm1LWMwNeooyIFOLU
   bAii4JjLeewe1EG4uyJdAM/OZtxNLuoEA0zVhDGmr9p9JUILDdY530MHH
   A==;
X-CSE-ConnectionGUID: ie9NKlrbRcyDjz2Lq/4YdA==
X-CSE-MsgGUID: fYtWmGTGRx+D1sxL1CpKlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60871012"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60871012"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 09:36:18 -0700
X-CSE-ConnectionGUID: Vc9PA09kR56WgZn05OUZRg==
X-CSE-MsgGUID: dz+fCInzQt+x2jtLbyZLSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="207559781"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.108.174]) ([10.125.108.174])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 09:36:17 -0700
Message-ID: <611bdd96-a0ed-4a1a-868d-0a58f3cb150a@intel.com>
Date: Tue, 23 Sep 2025 09:36:16 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: nvdimm@lists.linux.dev, ira.weiny@intel.com, vishal.l.verma@intel.com,
 dan.j.williams@intel.com, s.neeraj@samsung.com
References: <20250922211330.1433044-1-dave.jiang@intel.com>
 <20250923111801.00001d62@huawei.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250923111801.00001d62@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/23/25 3:18 AM, Jonathan Cameron wrote:
> On Mon, 22 Sep 2025 14:13:30 -0700
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
>> of gotos for error handling and avoid future mistakes of missed
>> unlock on error paths.
>>
>> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
>> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Hi Dave,
> 
> Thanks for looking at this.
> 
> Fully agree with Dan about the getting rid of all gotos by end of series.

I'll do that in a different patch for that particular chunk.

> 
> A few other things inline.  Mostly places where the use of guard()
> opens up low hanging fruit that improves readability (+ shortens code).
> 
> This code has a lot of dev_dbg() and some of them are so generic I'm not
> sure they are actually useful (cover a whole set of error paths).  Perhaps
> it is worth splitting some of those up, or reducing the paths that trigger
> them as part of this refactor.
> > Jonathan
> 
> 

<snip>

> 
>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> index 0ccf4a9e523a..d2c2d71e7fe0 100644
>> --- a/drivers/nvdimm/bus.c
>> +++ b/drivers/nvdimm/bus.c
>>  static int nvdimm_bus_probe(struct device *dev)
>> @@ -1177,15 +1175,15 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>>  		goto out;
>>  	}
>>  
>> -	device_lock(dev);
>> -	nvdimm_bus_lock(dev);
>> +	guard(device)(dev);
>> +	guard(nvdimm_bus)(dev);
>>  	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
>>  	if (rc)
>> -		goto out_unlock;
>> +		goto out;
>>  
>>  	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
>>  	if (rc < 0)
>> -		goto out_unlock;
>> +		goto out;
>>  
>>  	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
>>  		struct nd_cmd_clear_error *clear_err = buf;
>> @@ -1197,9 +1195,6 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
>>  	if (copy_to_user(p, buf, buf_len))
>>  		rc = -EFAULT;
>>  
>> -out_unlock:
>> -	nvdimm_bus_unlock(dev);
>> -	device_unlock(dev);
>>  out:
> Hmm. I'm not a fan of gotos that rely on initializing a bunch of pointers to NULL
> so fewer labels are used. Will be nice to replace that as well via __free
> 
> Going to need a DEFINE_FREE for the vfree that follow these but that looks standard to me.

I ended up moving it to kvzalloc() instead. Seems reasonable and give us zeroing of the buffer as well.

DJ

