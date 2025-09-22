Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A5A3AC39
	for <nvdimm@lists.linux.dev>; Mon, 22 Sep 2025 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582010; cv=none; b=a1xd7Hgom+Z0W7MMQ4QIhbZ5ta28IUpF/OClIeOND2Qqq/0eQdWtXo5oc4SjKUXXFszg2SxySJbKV2oMnbNi5dpUKCIYYPi7k8boVi+FAYAH0DuICMS4R0DwO6x2wzgVycGY4AaX8g0VSrYPqtZrEfHKotTTgJ8pOd5GwId4zYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582010; c=relaxed/simple;
	bh=dbGfFg9GMpDAIJDzt+T8uLTXsGS2htrbwARB6OTXNPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mfNWO2WzgU4XI/Vi7EBuk9ni3TO6Y7sC26fi46hjcU1YBgmqPXiRCSctCJlLk9tsZzdUyHUH/9+YqGeOs4e7voE8hnXe/8+dXf7f0aWiXHiNnASJ3206UJhnqewiRehoV3onB9Tf/GYYWEVGtP0i6IyYzIPIYxjRhMXEbCy8pgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a4j9HG8w; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a4j9HG8w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758582007; x=1790118007;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dbGfFg9GMpDAIJDzt+T8uLTXsGS2htrbwARB6OTXNPo=;
  b=a4j9HG8wzbZBFKWhnANLwK+Bkz3B3TZElCL/cfumtI7G6UG20Pro0CV5
   YVJcvNo1u0dYvU0e/72DK86CeUNT3Dt47UtPtSyIFD1ds3Jwrd5sPbKfh
   EYc9pCX1M5V/7DG1aqsDVW2Cfu95HT/FVG7a2fntYlDrvK3rGLgL77TFD
   JHsKBy4aRas6K+k2WxbqoI4wjnahSwvDkwm+KySTOLOnxEdfAM17mCeOe
   USvOYxIuQ0CRqNcs1MqFQ8obWGWLcCbmXVNSw8YgVP4IxBjFEkuSKdA6M
   1eht0KnIYb9igZ8aI09blMVtm0K2w/V6Hqk7hlimxrwiFn069ykPKsIGq
   g==;
X-CSE-ConnectionGUID: y1uzS9hTQ8OTlYDm/DvZbg==
X-CSE-MsgGUID: DkgxGAJtS7CUz+jdm3VAMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64659079"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64659079"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:00:07 -0700
X-CSE-ConnectionGUID: vPOBfqQXQQaFsvE71FuwCw==
X-CSE-MsgGUID: 56k1ys99RQm4RideX+B+Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176202601"
Received: from dwoodwor-mobl2.amr.corp.intel.com (HELO [10.125.108.132]) ([10.125.108.132])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 16:00:05 -0700
Message-ID: <1b1ee40a-401b-4839-9c63-77ecefb94315@intel.com>
Date: Mon, 22 Sep 2025 16:00:04 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] nvdimm: Introduce guard() for nvdimm_bus_lock
To: dan.j.williams@intel.com, nvdimm@lists.linux.dev
Cc: ira.weiny@intel.com, vishal.l.verma@intel.com,
 jonathan.cameron@huawei.com, s.neeraj@samsung.com
References: <20250922211330.1433044-1-dave.jiang@intel.com>
 <68d1d2bdc0181_1c79100ae@dwillia2-mobl4.notmuch>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <68d1d2bdc0181_1c79100ae@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/25 3:50 PM, dan.j.williams@intel.com wrote:
> Dave Jiang wrote:
>> Converting nvdimm_bus_lock/unlock to guard() to clean up usage
>> of gotos for error handling and avoid future mistakes of missed
>> unlock on error paths.
>>
>> Link: https://lore.kernel.org/linux-cxl/20250917163623.00004a3c@huawei.com/
>> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> Ira, up to you if you want to take this cleanup.
>> ---
> [..]
>> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
>> index 0ccf4a9e523a..d2c2d71e7fe0 100644
>> --- a/drivers/nvdimm/bus.c
>> +++ b/drivers/nvdimm/bus.c
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
> [..]
>> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
>> index 91d9163ee303..2018458a3dba 100644
>> --- a/drivers/nvdimm/dimm.c
>> +++ b/drivers/nvdimm/dimm.c
>> @@ -95,13 +95,13 @@ static int nvdimm_probe(struct device *dev)
>>  
>>  	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
>>  
>> -	nvdimm_bus_lock(dev);
>> -	if (ndd->ns_current >= 0) {
>> -		rc = nd_label_reserve_dpa(ndd);
>> -		if (rc == 0)
>> -			nvdimm_set_labeling(dev);
>> +	scoped_guard(nvdimm_bus, dev) {
>> +		if (ndd->ns_current >= 0) {
>> +			rc = nd_label_reserve_dpa(ndd);
>> +			if (rc == 0)
>> +				nvdimm_set_labeling(dev);
>> +		}
>>  	}
>> -	nvdimm_bus_unlock(dev);
>>  
>>  	if (rc)
>>  		goto err;
> [.. trim the hunks that successfully eliminated goto ..]
> 
> My litmus test for scoped-based-cleanup conversions is whether *all* of
> the gotos are removed in a converted function. So either fully convert
> all error unwind in a function to scope-based, or none of it. Do not
> leave people to reason about potentially jumping through scopes with
> goto.

This needs a bit more changes. I was undecided if I should include those changes in this patch or if they push out of scope. But it sounds like I should include them. 

