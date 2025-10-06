Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6962E23ABA1
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759766981; cv=none; b=n2KOP8ExKADOdvCopq9luI9b5yEu1FvCu7IkQm7wv2igG3qCA8fJ6SYnkPZR4uh65PnYnbCBBt05OYB+RSf/TLPhoFdbKWkm4T93kqlMVj5GAvfCIypMNEgxBaqm1zFtkJmBeAKyTXU/6Gsc0PgxxqKr1E16I6MtTWUnEurENgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759766981; c=relaxed/simple;
	bh=givZed0PpwJdCIhCZbPswU9FycNDWl/nLqzjLr1upuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e5+14wXHJx2VAHV0jmgJgKuAGlqMkp1Jda/D54z428mNK0y5NOfpmx21U1HiJiR9bdnv1kIjDSr1xnQHsR3iE1VlY3cle2xV2jwUuEYgkLQ2e3xf5Ky2J5Q6MG7GvNleMZMaD7zMVTs8H9qW96YN82KwC+JXYwN8OGO2lnTvbmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2CClYHS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2CClYHS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759766980; x=1791302980;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=givZed0PpwJdCIhCZbPswU9FycNDWl/nLqzjLr1upuo=;
  b=C2CClYHSNrgwZb9+D2jDiXcukYqz1d7icbNfj1SpraXDHfU0EjomdOOM
   6eF6oWdOfk0QEpNzTKmDuzQ8Enjxo74uHNmiLAoEMJCY7pBcCu9LUjG+k
   EvUQcsixxB+Y+DlEKi03sVORCrTF6DFLN/cJtc13z9dLRL9q3Uubvv6UX
   6KoS05lljFFDdA3p8hmEARiYqG2SD8INiiKccB6HkNOXlLOU8BXpEnT26
   Ptlj0yy0kdZ3koF3y1T5z6VhJv2wztaJW/lHl14evbnYsHcsfpHbEOTBP
   +5dwWJlFzKknCZJ6G9jjIU/KS7WCaNruGcImISrxTx3a9IRXHUOKWRck0
   A==;
X-CSE-ConnectionGUID: qzShjdY/TBa2/vu695/xKg==
X-CSE-MsgGUID: nUjqJvMJSGu9uTbJDTwF8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="61976301"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="61976301"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:09:39 -0700
X-CSE-ConnectionGUID: k2UWq0gIS1iA14uL6ykWcg==
X-CSE-MsgGUID: nCPFZlBiRKe2pdF33nDutw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="184195947"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.110]) ([10.125.110.110])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:09:37 -0700
Message-ID: <1ba93727-e673-48c8-b3b4-2aba96304053@intel.com>
Date: Mon, 6 Oct 2025 09:09:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 18/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134209epcas5p1b7f861dbd8299ec874ae44cbf63ce87c@epcas5p1.samsung.com>
 <20250917134116.1623730-19-s.neeraj@samsung.com>
 <147c4f1a-b8f6-4a99-8469-382b897f326d@intel.com>
 <1279309678.121759726504330.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1279309678.121759726504330.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/29/25 6:57 AM, Neeraj Kumar wrote:
> On 24/09/25 11:53AM, Dave Jiang wrote:
>>
>>
>> On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>>> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
>>> Moved pmem_region related code from core/region.c to core/pmem_region.c
>>> For region label update, need to create device attribute, which calls
>>> nvdimm exported function thus making pmem_region dependent on libnvdimm.
>>> Because of this dependency of pmem region on libnvdimm, segregated pmem
>>> region related code from core/region.c
>>
>> We can minimize the churn in this patch by introduce the new core/pmem_region.c and related bits in the beginning instead of introduce new functions and then move them over from region.c.
> 
> Hi Dave,
> 
> As per LSA 2.1, during region creation we need to intract with nvdimmm
> driver to write region label into LSA.
> This dependency of libnvdimm is only for PMEM region, therefore I have
> created a seperate file core/pmem_region.c and copied pmem related functions
> present in core/region.c into core/pmem_region.c.
> Because of this movemement of code we have churn introduced in this patch.
> Can you please suggest optimized way to handle dependency on libnvdimm
> with minimum code changes.
> 
>>
>>> diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
>>> index 48b7314afdb8..532eaa1bbdd6 100644
>>> --- a/drivers/cxl/Kconfig
>>> +++ b/drivers/cxl/Kconfig
>>> @@ -211,6 +211,20 @@ config CXL_REGION
>>>
>>>        If unsure say 'y'
>>>
>>> +config CXL_PMEM_REGION
>>> +    bool "CXL: Pmem Region Support"
>>> +    default CXL_BUS
>>> +    depends on CXL_REGION
>>
>>> +    depends on PHYS_ADDR_T_64BIT
>>> +    depends on BLK_DEV
>> These 2 deps are odd. What are the actual dependencies?
>>
> 
> We need to add these 2 deps to fix v2 0Day issue [1]
> I have taken reference from bdf97013ced5f [2]
> Seems, I also have to add depends on ARCH_HAS_PMEM_API. I will update it
> in V3.
> 
> [1] https://lore.kernel.org/linux-cxl/202507311017.7ApKmtQc-lkp@intel.com/
> [2] https://elixir.bootlin.com/linux/v6.13.7/source/drivers/acpi/nfit/Kconfig#L4
> 
>>
>>> +    select LIBNVDIMM
>>> +    help
>>> +      Enable the CXL core to enumerate and provision CXL pmem regions.
>>> +      A CXL pmem region need to update region label into LSA. For LSA
>>> +      updation/deletion libnvdimm is required.
>>
>> s/updation/update/
>>
> 
> Sure, Will fix it
> 
>>> +
>>> +      If unsure say 'y'
>>> +
>>>  config CXL_REGION_INVALIDATION_TEST
>>>      bool "CXL: Region Cache Management Bypass (TEST)"
>>>      depends on CXL_REGION
> 
> <snip>
> 
>>> --- a/drivers/cxl/core/port.c
>>> +++ b/drivers/cxl/core/port.c
>>> @@ -53,7 +53,7 @@ static int cxl_device_id(const struct device *dev)
>>>          return CXL_DEVICE_NVDIMM_BRIDGE;
>>>      if (dev->type == &cxl_nvdimm_type)
>>>          return CXL_DEVICE_NVDIMM;
>>> -    if (dev->type == CXL_PMEM_REGION_TYPE())
>>> +    if (dev->type == CXL_PMEM_REGION_TYPE)
>>
>> Stray edit? I don't think anything changed in the declaration.
>>
> 
> Sure, Will fix it
> 
>>>          return CXL_DEVICE_PMEM_REGION;
>>>      if (dev->type == CXL_DAX_REGION_TYPE())
>>>          return CXL_DEVICE_DAX_REGION;
> 
> <snip>
> 
>>> @@ -2382,7 +2380,7 @@ bool is_cxl_region(struct device *dev)
>>>  }
>>>  EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
>>>
>>> -static struct cxl_region *to_cxl_region(struct device *dev)
>>> +struct cxl_region *to_cxl_region(struct device *dev)
>>>  {
>>>      if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
>>>                "not a cxl_region device\n"))
>>> @@ -2390,6 +2388,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
>>>
>>>      return container_of(dev, struct cxl_region, dev);
>>>  }
>>> +EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL");
>>
>> Maybe just move this into the header file instead.
>>
>> DJ
> 
> Actually to_cxl_region() is internal to cxl/core and especially to core/region.c
> So, Its better to compeletly remove EXPORT_SYMBOL_NS_GPL(to_cxl_region, "CXL")
> 
> Even EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL") is internal to cxl/core/region.c
> Should I also remove it?
> 
> Even we can remove declaration of is_cxl_region() and to_cxl_region()
> from drivers/cxl/cxl.h as these functions are internal to cxl/core/region.c

Yes we should probably clean that up if it's not being used externally. I don't think it should break cxl_test, but you should compile verify after you make the changes.

make M=tools/testing/cxl

> 
> 
> Regards,
> Neeraj
> 
> 

