Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DF23EFFCC
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780414952; cv=none; b=jkzpwu/m0qLh3vwInw3cwcs72f9qql3pvSZTdkkWavsKZmjJ581Wt5SeUm5AIVsxUt0qoDrLvo0V4y/DilX7JNbpkSDpUFOyFt0SPvvEzQ2UVHLeIPmrWwYi+i9eUKWdlMPNSJ+94eZYHQ/YGGu0mo9SYZoigjdB70tQlD9CRgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780414952; c=relaxed/simple;
	bh=3vw6WldVcC3t0KlASCJAiPE04OBikYIn6v0PhOEtTqU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A9BC7rpPIz7oC2EMc6BGDQRH76otMGOgGfFxukxALo3wy+nf/4RUpyXn+zTKKj9oCfdcWnsmLFy7FP3bhSR16AItKcIpZn6N0ZRnAn6FqGluFjNd27128wN6SlgIR97HLnSKesLeRpzRtBL/iJDQxRM4U3xUxAO1fIDUTWwBBuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QGfXLYcn; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QGfXLYcn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780414950; x=1811950950;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3vw6WldVcC3t0KlASCJAiPE04OBikYIn6v0PhOEtTqU=;
  b=QGfXLYcnsPWQDldz1eN/X+TCX0TGVbce/hCbFnioM2chFm4lG8/Ku+/r
   PnG4ZNo8ATNDrcuWGaX1bitOHAJAJsI42M9eGWOAMH1O8SqR3tDSlrei7
   ji+2p4SJVQo7muf6o6h/9loUMCwccJELuQGkyw3NFcYyLcMzTyV1Xqfxv
   PZ4AyajoL2EkpeO7eEkkjtSVW0jbCteVljeuR/G84QXNQElsUarUT8lmV
   UXAY9foWwNdNPeyk6ybFQXV3uoUZsCIs4kE9Vjd97Omg78A8DCJJ6m9R6
   v84Sj1bAyYKQzyilGdOQeYu4ShMLnzNJdfOQSPfCqYmiV2IPeIvNQMaXh
   w==;
X-CSE-ConnectionGUID: 4T8lUXcpSU+yiUMe7RIL3A==
X-CSE-MsgGUID: fqrAQlzdT7yVIk+TahVWIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81175640"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="81175640"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 08:42:29 -0700
X-CSE-ConnectionGUID: u7epIAsgRvmFKRuDfJGT3A==
X-CSE-MsgGUID: 0jQ7uDHfQgi8b8mvnFkEpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="239499157"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.108.56]) ([10.125.108.56])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 08:42:27 -0700
Message-ID: <aeb0ac8a-346b-4bc5-a836-76682e692fcf@intel.com>
Date: Tue, 2 Jun 2026 08:42:25 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/31] cxl/region: Add DC DAX region support
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <9f0e0b3deeb1825ad113d7aebe7056dcf2bbc5f9.1779528761.git.anisa.su@samsung.com>
 <f55e49bb-5032-448f-9550-69282b38b1c0@intel.com>
 <ah6g4il0GtXKoclr@AnisaLaptop.localdomain>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <ah6g4il0GtXKoclr@AnisaLaptop.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/2/26 2:22 AM, Anisa Su wrote:
> On Wed, May 27, 2026 at 05:16:44PM -0700, Dave Jiang wrote:
>>
>>
>> On 5/23/26 2:43 AM, Anisa Su wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>

< --snip -->

>>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>>> index a7f71f36531f..2d33001dac26 100644
>>> --- a/drivers/cxl/core/port.c
>>> +++ b/drivers/cxl/core/port.c
>>> @@ -337,6 +337,7 @@ static struct attribute *cxl_decoder_root_attrs[] = {
>>>  	&dev_attr_qos_class.attr,
>>>  	SET_CXL_REGION_ATTR(create_pmem_region)
>>>  	SET_CXL_REGION_ATTR(create_ram_region)
>>> +	SET_CXL_REGION_ATTR(create_dynamic_ram_a_region)
>>
>> With this add, may need to add checks in cxl_root_decoder_visible() for dynamic_ram for create and also delete. 
>>
> So for this check, since there's no CXL_DECODER_F_ bit defined for DCD, I considered
> traversing through all endpoints and seeing if they have a DYNAMIC_RAM_A
> partition, but that traversal already happens in the store_targetN() path,
> which also includes the mode mismatch check.
> 
> Specifically, in cxl_region_attach:
> 
> if (cxlds->part[cxled->part].mode != cxlr->mode) {
> 	dev_dbg(&cxlr->dev, "%s region mode: %d mismatch\n",
> 		dev_name(&cxled->cxld.dev), cxlr->mode);
> 	return -EINVAL;
> }
> 
> Is it sufficient here to prohibit creating a dynamic ram region if the root
> decoder does not support ram?
> 
> if (a == CXL_REGION_ATTR(create_dynamic_ram_a_region) && !can_create_ram(cxlrd))
> 	return 0;
> 

I think so.

>>>  	SET_CXL_REGION_ATTR(delete_region)
>>>  	NULL,
>>>  };
>>> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
>>> index edc267c6cf77..7561bf3d8af8 100644
>>> --- a/drivers/cxl/core/region.c
>>> +++ b/drivers/cxl/core/region.c
>>> @@ -493,6 +493,11 @@ static int set_interleave_ways(struct cxl_region *cxlr, int val)
>>>  	int save, rc;
>>>  	u8 iw;
>>>  
>>> +	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A && val != 1) {
>>> +		dev_err(&cxlr->dev, "Interleaving and DCD not supported\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>>  	rc = ways_to_eiw(val, &iw);
>>>  	if (rc)
>>>  		return rc;
>>> @@ -2389,6 +2394,7 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>>>  	if (sysfs_streq(buf, "\n"))
>>>  		rc = detach_target(cxlr, pos);
>>>  	else {
>>> +		struct cxl_endpoint_decoder *cxled;
>>>  		struct device *dev;
>>>  
>>>  		dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
>>> @@ -2400,8 +2406,14 @@ static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int pos,
>>>  			goto out;
>>>  		}
>>>  
>>> -		rc = attach_target(cxlr, to_cxl_endpoint_decoder(dev), pos,
>>> -				   TASK_INTERRUPTIBLE);
>>> +		cxled = to_cxl_endpoint_decoder(dev);
>>> +		if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
>>> +		    !cxl_dcd_supported(cxled_to_mds(cxled))) {
>>
>> cxled_to_mds() can return NULL with the earlier change suggested. Need to handle that
>>
> Fixed
>> DJ
>>
> Thanks,
> Anisa
> 
> Also, for potential future support for multiple DC partitions not to be awkward, I
> think it would make sense to rename dynamic_ram_a to dynamic_ram_1. Any
> objections?

No objections from me. Seems reasonable.
