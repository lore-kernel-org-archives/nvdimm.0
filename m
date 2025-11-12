Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AD42F5339
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762962057; cv=none; b=hX3hJLG7S7yiCjep0en1F0AQcpcyHQ9+oftC3+vEDXis43VZd2Qen4SWqf5eBPvX0IwgRhVfUIU8/pvJxDTMw16Q5ekAmfF0PmGzvtmNHm9McgsCfv0vWf3Kca8ZDatP0PvttLN+GTExtLMQh7i7YNE+xHoUC2VYtUNxLkJHle8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762962057; c=relaxed/simple;
	bh=mgVSVdhADCrs716f2wRkUVcYclGpyj5xUt6IfsjsOfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VwQlmAIuUAcxj+bhQPE75sOnkJAFqwLDh3On+YFZgUwS3IYPCgVaR99URNcqM7ls4eiAKwtl8HTuUxl2FoIjVfwaj3KErRAA9ooIx+7gKLiglwOcJF+PF1vjNGvL7ln/WKdvsI7CKmYKJJlZe2zV8ug8l4Ssv97jej87DwF7gco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqTxO5Uj; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqTxO5Uj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762962055; x=1794498055;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mgVSVdhADCrs716f2wRkUVcYclGpyj5xUt6IfsjsOfw=;
  b=SqTxO5UjaN8lRjwAPeN/AwMP66uppU8W+fYW1jxw7OXDXKWFKAYtaMre
   uictG8/SmFbxgpMhTpzdf0Ve7/BZEQ5zpjxaFfRXogT+hQQmhL5LVwrVN
   Lf7tN5udvlv9SoJQDKO3nUIcHCvhxA0o8VUOgz1KXAr9jE8yL7BNJJsKZ
   9RDQNERmE0S1xqNMczcxX7AVO1Am0Mk+ivvYrSdgAoAzWC+2nG/+EEneW
   4U7c8M8eEGGuXIF/HZVvhJiVzuTvCijVubvIIM4TkQdg7/uMCDIBDvYhg
   +RNycuCdNK9J+IKmFqfg/PxiBk/wgwfjVn3RD52famtdyE99butgPnG2/
   w==;
X-CSE-ConnectionGUID: Zj2AO+mZT0qsXLRYpM/EaQ==
X-CSE-MsgGUID: LzdsH/4oTpSwsieSio23Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="65179235"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="65179235"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 07:40:55 -0800
X-CSE-ConnectionGUID: mh8h65ZtQfqzcljXJcLQmQ==
X-CSE-MsgGUID: 1AVnEe/ZRi6GPGPf8erGeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189516715"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.108.30]) ([10.125.108.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 07:40:54 -0800
Message-ID: <2aca7703-fae6-46bb-bef1-ee29e822b4c8@intel.com>
Date: Wed, 12 Nov 2025 08:40:53 -0700
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
 <6e893bd1-467a-4e9a-91ca-536afa6e4767@intel.com>
 <1296674576.21762749302024.JavaMail.epsvc@epcpadp1new>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <1296674576.21762749302024.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/7/25 5:49 AM, Neeraj Kumar wrote:
> On 06/10/25 09:06AM, Dave Jiang wrote:
>>
>>
>> On 9/29/25 6:57 AM, Neeraj Kumar wrote:
>>> On 24/09/25 11:53AM, Dave Jiang wrote:
>>>>
>>>>
>>>> On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>>>>> Created a separate file core/pmem_region.c along with CONFIG_PMEM_REGION
>>>>> Moved pmem_region related code from core/region.c to core/pmem_region.c
>>>>> For region label update, need to create device attribute, which calls
>>>>> nvdimm exported function thus making pmem_region dependent on libnvdimm.
>>>>> Because of this dependency of pmem region on libnvdimm, segregated pmem
>>>>> region related code from core/region.c
>>>>
>>>> We can minimize the churn in this patch by introduce the new core/pmem_region.c and related bits in the beginning instead of introduce new functions and then move them over from region.c.
>>>
>>> Hi Dave,
>>>
>>> As per LSA 2.1, during region creation we need to intract with nvdimmm
>>> driver to write region label into LSA.
>>> This dependency of libnvdimm is only for PMEM region, therefore I have
>>> created a seperate file core/pmem_region.c and copied pmem related functions
>>> present in core/region.c into core/pmem_region.c.
>>> Because of this movemement of code we have churn introduced in this patch.
>>> Can you please suggest optimized way to handle dependency on libnvdimm
>>> with minimum code changes.
>>
>> Hmm....maybe relegate the introduction of core/pmem_region.c new file and only the moving of the existing bits into the new file to a patch. And then your patch will be rid of the delete/add bits of the old code? Would that work?
>>
>> DJ
> 
> Hi Dave,
> 
> As per LSA 2.1, during region creation we need to intract with nvdimmm
> driver to write region label into LSA.
> 
> This dependency of libnvdimm is only for PMEM region, therefore I have
> created a seperate file core/pmem_region.c and copied pmem related functions
> present in core/region.c into core/pmem_region.c
> 
> I have moved following 7 pmem related functions from core/region.c to core/pmem_region.c
>  - cxl_pmem_region_release()
>  - cxl_pmem_region_alloc()
>  - cxlr_release_nvdimm()
>  - cxlr_pmem_unregister()
>  - devm_cxl_add_pmem_region()
>  - is_cxl_pmem_region()
>  - to_cxl_pmem_region()
> 
> I have created region_label_update_show/store() and region_label_delete_store() which
> internally calls following libnvdimm exported function
>  - region_label_update_show/store()
>  - region_label_delete_store()
> 
> I have added above attributes as following
>    {{{
>     static struct attribute *cxl_pmem_region_attrs[] = {
>             &dev_attr_region_label_update.attr,
>             &dev_attr_region_label_delete.attr,
>             NULL
>     };
>     static struct attribute_group cxl_pmem_region_group = {
>             .attrs = cxl_pmem_region_attrs,
>     };
>     static const struct attribute_group *cxl_pmem_region_attribute_groups[] = {
>             &cxl_base_attribute_group,
>             &cxl_pmem_region_group,      ------> New addition in this patch
>             NULL
>     };
>     const struct device_type cxl_pmem_region_type = {
>             .name = "cxl_pmem_region",
>             .release = cxl_pmem_region_release,
>             .groups = cxl_pmem_region_attribute_groups,
>     };
> 
>     static int cxl_pmem_region_alloc(struct cxl_region *cxlr)
>     {
>             <snip>
>             dev = &cxlr_pmem->dev;
>             dev->parent = &cxlr->dev;
>             dev->bus = &cxl_bus_type;
>             dev->type = &cxl_pmem_region_type;
>         <snip>
>     }
>    }}}
> 
> So I mean to say all above mentioned functions are inter-connected and dependent on libnvdimm
> Keeping any of them in core/region.c to avoid churn, throws following linking error
>    {{{
>     ERROR: modpost: "nd_region_label_delete" [drivers/cxl/core/cxl_core.ko] undefined!
>     ERROR: modpost: "nd_region_label_update" [drivers/cxl/core/cxl_core.ko] undefined!
>     make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
>    }}}
> 
> Keeping these functions in core/region.c (CONFIG_REGION)) and manually enabling CONFIG_LIBNVDIMM=y
> will make it pass.
> 
> Even if we can put these functions in core/region.c and forcefully make
> libnvdimm (CONFIG_LIBNVDIMM) dependent using Kconfig. But I find it little improper as
> this new dependency is not for all type of cxl devices (vmem and pmem) but only for cxl pmem
> device region.
> 
> Therefore I have seperated it out in core/pmem_region.c under Kconfig control
> making libnvdimm forcefully enable if CONFIG_CXL_PMEM_REGION == y
> 
> So, I believe this prep patch is required for this LSA 2.1 support.

I think you misunderstood what I said. What I was trying to say is if possible to move all the diff changes of moving the existing code to a different place to a different patch. That way this patch is not full of those diff changes and make it easier to review.

DJ


> 
> 
> Regards,
> Neeraj
> 

