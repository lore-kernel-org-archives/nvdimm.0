Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C60F2110
	for <nvdimm@lists.linux.dev>; Mon, 21 Jul 2025 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753121528; cv=none; b=VX2+hzadSkTQsnEM/rFEHAqzqoD53CJ5Fmo4a+Bhri5ERNpdxkD7lRwnq3uZNhk3JRYmmF8uDvSfhcVzuzl9X2Gft4pixNKELPlFIvtP9bdbh8QLIkciJ+Q0/kW31cHjTl2XXgvGXm79bSv5eR9/UtbB9xp8LHE/lCaeggEcjLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753121528; c=relaxed/simple;
	bh=SbYHkV3wEWrsm2dOsKamje49GHV/jPURR2Smv/CndME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pacvAxz+Ixb+DOjALasU/iF8JlFX6MmN8qjb2QTBjWx7vtqe24bXQscr3j3ecnRFK8RaDsIzl4C58QzhRxlxFAtIRdEPhiA9tq7QbaX08yCzU8bm13eEch/TS4HKjCWTc1TjjiAPJgQlLNHgTkuRbqm+srkl7Ka6RtEuH3G4MSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OKAOQtBN; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OKAOQtBN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753121528; x=1784657528;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SbYHkV3wEWrsm2dOsKamje49GHV/jPURR2Smv/CndME=;
  b=OKAOQtBNGMlQUHee7/X04II2v2topag7jylVHoWvy5o0ENP08dcmmGie
   7Yo9gK1p81Kmth8vfPm1Iy9lOd/jahpVKHXLS/ZLwyLHJmg7h86+C9J4S
   2XbKsBc72tMFD0MgmhqJ/+W9uunrRLfVR3oIY5LxsWjyUvqxITmVA8jKO
   XxWfL5WXHWFmg6Vp869Vunez1C/UOLx+0mcebYhOUQRXZawj+Rg8ExHMx
   HilIKBX6Ct04i8lzgkGSDze9HL5OySu+cO59cwGSUEoDsiFjMtfk5Q5DM
   5+IKT+oKPq9xI9/tAgh7U198P9dTPQdLCshMs64ZKMnyHblFmjKpQBjd/
   g==;
X-CSE-ConnectionGUID: ECkUWhpYQPaAbQUbHBi3Vg==
X-CSE-MsgGUID: haWdOG8gTe+dzTUzhkibSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="59144292"
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="59144292"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 11:12:07 -0700
X-CSE-ConnectionGUID: TAPkyCKfQlqxisGUT+rU3Q==
X-CSE-MsgGUID: acUiiCLOTM2BsDc1wXNQ2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="164563026"
Received: from vverma7-mobl3.amr.corp.intel.com (HELO [10.247.118.153]) ([10.247.118.153])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 11:11:56 -0700
Message-ID: <e1301b24-9baa-4e82-9b99-443d31c917e0@intel.com>
Date: Mon, 21 Jul 2025 11:11:51 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
 vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
 alok.rathore@samsung.com, neeraj.kernel@gmail.com,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
References: <20250617123944.78345-1-s.neeraj@samsung.com>
 <CGME20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed@epcas5p2.samsung.com>
 <1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
 <3670eb1d-eaf5-4b8b-b3fe-1190724ee7d7@intel.com>
 <1931444790.41752909482841.JavaMail.epsvc@epcpadp2new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1931444790.41752909482841.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/18/25 5:30 AM, Neeraj Kumar wrote:
> On 09/07/25 05:38PM, Dave Jiang wrote:
>>
>>
>> On 6/17/25 5:39 AM, Neeraj Kumar wrote:
>>> In 84ec985944ef3, For cxl pmem region auto-assembly after endpoint port
>>> probing, cxl_nvd presence was required. And for cxl region persistency,
>>> region creation happens during nvdimm_probe which need the completion
>>> of endpoint probe.
>>>
>>> It is therefore refactored cxl pmem region auto-assembly after endpoint
>>> probing to cxl mem probing
>>
>> The region auto-assembly is moved after the endpoint device is added. However, it's not guaranteed that the endpoint probe has completed and completed successfully. You are just getting lucky timing wise that endpoint probe is completed when the new region discovery is starting.
> 
> Hi Dave,
> 
> For region auto-assembly two things are required
>  1. endpoint(s) decoder should be enumerated successfully
>  2. As per fix in 84ec985944ef3, The cxl_nvd of the memdev needs to be available during the pmem region probe
> 
> Prior to current patch, region auto-assembly was happening from cxl_endpoint_port_probe() after endpoint decoder enumeration.
> In 84ec985944ef3, sequence of devm_cxl_add_nvdimm() was moved before devm_cxl_add_endpoint() so as to meet region auto assembly dependency on cxl_nvd of the memdev.
> 
> Here, In this patch I have moved region auto-assembly after
>  1. devm_cxl_add_endpoint(): This function makes sure cxl_endpoint_port_probe() has completed successfully, as per below check in devm_cxl_add_endpoint()
>       if (!endpoint->dev.driver) {
>            dev_err(&cxlmd->dev, "%s failed probe\n", dev_name(&endpoint->dev));
>            return -ENXIO;
>       }
>       And successfull completion of cxl_endpoint_port_probe(), it must have enumerated endpoint(s) decoder successfully
>  2. devm_cxl_add_nvdimm(): As you rightly said, this allocates "cxl_nvd" nvdimm device and triggers the async probe of nvdimm driver
> 
> Actually in this patch, from async probe function (cxl_nvdimm_probe()), I am creating "struct nvdimm" using __nvdimm_create()
> This __nvdimm_create() ultimately scans LSA. If LSA finds region label into it then it saves region information into struct nvdimm
> and then using create_pmem_region(nvdimm), I am re-creating cxl region for region persistency.
> 
> As for cxl region persistency (based on LSA 2.1 scanning - this patch)
> following sequence should be required
>  1. devm_cxl_add_endpoint(): endpoint probe completion - which is getting done by devm_cxl_add_endpoint()
>  2. devm_cxl_add_nvdimm(): Here after nvdimm device creation, cxl region is being created
> 
> It is therefore re-sequencing of region-auto assembly is required to move from cxl_endpoint_port_probe() to after
> devm_cxl_add_endpoint() and devm_cxl_add_nvdimm()
> 
>> Return of devm_cxl_add_nvdimm() only adds the nvdimm device and triggers the async probe of nvdimm driver. You have to take the endpoint port lock
> 
> I think we may not require endpoint port lock as auto-assembly and region persistency code sequence is always after successful completion of endpoint probe.
> 
>> and check if the driver is attached to be certain that endpoint probe is done and successful. Therefore moving the region discovery location probably does not do what you think it does.
>> Maybe take a deeper look at the region discovery code and see how it does retry if things are not present and approach it from that angle?
>>
> 
> Please let me know if my understanding is correct or am I missing something?


No I think your assumptions are fine. I incorrectly assumed that the cxl_port driver is probed async. But in reality, only the cxl_pci driver is probed async. So devm_cxl_add_endpoint() will ensure that the port driver is attached and the rest should work as what you have setup for nvdimm. Sorry about the noise. 

DJ
 
> 
>>>
>>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>>> ---
>>>  drivers/cxl/core/port.c | 38 ++++++++++++++++++++++++++++++++++++++
>>>  drivers/cxl/cxl.h       |  1 +
>>>  drivers/cxl/mem.c       | 27 ++++++++++++++++++---------
>>>  drivers/cxl/port.c      | 38 --------------------------------------
>>>  4 files changed, 57 insertions(+), 47 deletions(-)
>>>
>>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>>> index 78a5c2c25982..bca668193c49 100644
>>> --- a/drivers/cxl/core/port.c
>>> +++ b/drivers/cxl/core/port.c
>>> @@ -1038,6 +1038,44 @@ void put_cxl_root(struct cxl_root *cxl_root)
>>>  }
>>>  EXPORT_SYMBOL_NS_GPL(put_cxl_root, "CXL");
>>>
>>> +static int discover_region(struct device *dev, void *root)
>>> +{
>>> +    struct cxl_endpoint_decoder *cxled;
>>> +    int rc;
>>> +
>>> +    if (!is_endpoint_decoder(dev))
>>> +        return 0;
>>> +
>>> +    cxled = to_cxl_endpoint_decoder(dev);
>>> +    if ((cxled->cxld.flags & CXL_DECODER_F_ENABLE) == 0)
>>> +        return 0;
>>> +
>>> +    if (cxled->state != CXL_DECODER_STATE_AUTO)
>>> +        return 0;
>>> +
>>> +    /*
>>> +     * Region enumeration is opportunistic, if this add-event fails,
>>> +     * continue to the next endpoint decoder.
>>> +     */
>>> +    rc = cxl_add_to_region(root, cxled);
>>> +    if (rc)
>>> +        dev_dbg(dev, "failed to add to region: %#llx-%#llx\n",
>>> +            cxled->cxld.hpa_range.start, cxled->cxld.hpa_range.end);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +void cxl_region_discovery(struct cxl_port *port)
>>> +{
>>> +    struct cxl_port *root;
>>> +    struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>>> +
>>> +    root = &cxl_root->port;
>>> +
>>> +    device_for_each_child(&port->dev, root, discover_region);
>>> +}
>>> +EXPORT_SYMBOL_NS_GPL(cxl_region_discovery, "CXL");
>>> +
>>
>> I have concerns about adding region related code in core/port.c while the rest of the region code is walled behind CONFIG_CXL_REGION. I think this change needs to go to core/region.c.
>>
>> DJ
>>
> 
> Sure Dave, I will move it into core/region.c in next patch-set.
> 
> Regards,
> Neeraj
> 

