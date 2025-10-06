Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A1E2D062E
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 16:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759767227; cv=none; b=OA0ImKrPxZqYeTxYUk+CcWOcVpbus0JStkpLM48R0VNPQLbKTgkHfxuP5ZOyFfEajtgTttpFLXrYpFzgPwAYARpfyxthkUPmXWfFrNfyCJ4epBYmnFX/cUq4o8mGnJEiCi7fTDXtuJCuRyoBVN0G//RJkvmCDdjrbY/DSKaqP0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759767227; c=relaxed/simple;
	bh=tfu2TRdArAqNNnaXATXklqcBw7fADoLtctfv35pmzSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDN4pnu4QP37nFUfmodSX/nGjK5VuDXIZvSGxecLNJRnZVAnmaRvcq5tbpMN9/j60qURF1YsqGmWfPYercvqz9WN6VpzlKhzbCgHVC7hdyduV835J4M2/xQqAUhCaO1FwYXhmoe/xXkGca3I8CSeGBql/pl9/jqVJ5ypy3gNVXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GsSbTKm2; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GsSbTKm2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759767226; x=1791303226;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tfu2TRdArAqNNnaXATXklqcBw7fADoLtctfv35pmzSY=;
  b=GsSbTKm2feNHUzbjQ1b5SWVswi1/tsG+Il19R4Q6SkpF45QXV0eTqcG8
   Ct2BySDiYwbvfspGHaQAbfnvJpZVN2kcJzWwot0rKJ1wVqnwdfPTxYnVy
   RhXQ/vqYpBowGoulHbQA1Xcd7F9OY2rmyDEkH/yQc+UNZl28nGEtyNvbD
   8sJKYTeZZsEyh+ZkxSR+O6gQumOBtpH/b2WruWJMnvZoSEye9wrakE1mt
   UboqftMtHyW7fj7JF53OWFd3k31hfIk8TfImgVQuBAWevAwYlt0AfmFth
   JFnIJ7yDDdUshaQMXjGu3jU5fT6zEpuF+s6BLAeihrTK0LVVYkrE+GsY7
   w==;
X-CSE-ConnectionGUID: hjpkgNlyTtiaP25pTJxk5A==
X-CSE-MsgGUID: QzTUA847R4WYdJOkLo3ZCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="72196499"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="72196499"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:13:45 -0700
X-CSE-ConnectionGUID: asQcShZxSsS4leEL7+ui2Q==
X-CSE-MsgGUID: RyEmm41BSO6mRRkB5BJt5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="180710614"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.110]) ([10.125.110.110])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:13:44 -0700
Message-ID: <dc9adde2-2c07-4249-b788-63f50c8e429e@intel.com>
Date: Mon, 6 Oct 2025 09:13:43 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 20/20] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720@epcas5p1.samsung.com>
 <20250917134116.1623730-21-s.neeraj@samsung.com>
 <28d78d2b-c17d-4910-9f28-67af1fbb10ee@intel.com>
 <1256440269.161759726504643.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <1256440269.161759726504643.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/29/25 7:02 AM, Neeraj Kumar wrote:
> On 24/09/25 01:47PM, Dave Jiang wrote:
>>
>>> +++ b/drivers/cxl/core/pmem_region.c
>>> @@ -290,3 +290,56 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>>>      return rc;
>>>  }
>>>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
>>> +
>>> +static int match_free_ep_decoder(struct device *dev, const void *data)
>>> +{
>>> +    struct cxl_decoder *cxld = to_cxl_decoder(dev);
>>
>> I think this is needed if the function is match_free_ep_decoder().
>>
>> if (!is_endpoint_decoder(dev))
>>     return 0;
>>
> 
> Yes this check is required, I will add this.
> 
>>> +
>>> +    return !cxld->region;
>>> +}
>>
>> May want to borrow some code from match_free_decoder() in core/region.c. I think the decoder commit order matters?
>>
> 
> Yes Dave, Looking at [1], seems commit order matters. Sure I will look
> at match_free_decoder() in core/region.c
> [1] https://lore.kernel.org/all/172964783668.81806.14962699553881333486.stgit@dwillia2-xfh.jf.intel.com/
> 
> 
>>> +
>>> +static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
>>> +{
>>> +    struct device *dev;
>>> +
>>> +    dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
>>> +    if (!dev)
>>> +        return NULL;
>>> +
>>> +    /* Release device ref taken via device_find_child() */
>>> +    put_device(dev);
>>
>> Should have the caller put the device.
> 
> Its like taking device ref temporarly and releasing it then and there
> after finding proper root decoder. I believe, releasing device ref
> from caller would make it look little out of context.

As mentioned in my response to 15/20, the caller should be releasing the device reference since the caller is using the endpoint decoder. I would also add a comment to the new functions acquiring the decoders that the caller is expected to put_device() on the decoder dev when done.

DJ

> 
> 
> Regards,
> Neeraj
> 

