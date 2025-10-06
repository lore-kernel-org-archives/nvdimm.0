Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C3034BA37
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 16:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759766571; cv=none; b=coGLmWG4yoANuf4S2A3LmJps8Sz1QXuI/zqYBB28yrtc82YHV+QoUWBYn4h0qUFBEEqK71ALVarawZd3ad/vWp5fC3BVKZtQ35TkzJGF5H5JgNu40MSRJIjXDqjYEF3Z47N0MRdmUcgIZIE7mIcqK6aqx423r7cofzHrm1Y7YsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759766571; c=relaxed/simple;
	bh=ap/MH3N7hqYGFTkBJ9RD/CX2ovQ2nfWxR6HMrzY58BA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiPHpqxTeJ8bGOzEpxRd4rkBy/UvVpDqH1X3+SDWKQ4kELQiX6aJLb5vxDckKuDjeVs4BUFlpujD3sOM4/xHM+XlfMJZeigabxWWPbHEmKxGYgtWmsgxyKr+kDTnnwGo0g27hFyFaEFOnl7uwMTmqqcgCaZPQra6caTXM8/GIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bgDNE/1h; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bgDNE/1h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759766570; x=1791302570;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ap/MH3N7hqYGFTkBJ9RD/CX2ovQ2nfWxR6HMrzY58BA=;
  b=bgDNE/1hTjMXAfnHYbPq9XwoRqJRY0xdMFB+WBtWZSr793jZDPOwsrFr
   gqqm/FcxIe2/t1g3/2X1pHNuWM9yQMUtwNKAPaxPyTD06gUE3Q34YotWD
   f/qHmAC8wMfSTtvFxpunw2yz90SSNhhFcsakr6NKoZjX9b1U2ceNLEf2Z
   qWN8gOe0FpTMWLBk+xpLcmym2GP6FwHccp2FrGiRQkMBRyBASMAjHuiMY
   8PhZiED+JdntkkruDj0QoJ9/HtN0zfVOydjWilvRkqYdn7Jb2LoXsh9Ke
   w1U+4FzwChogrriFnUYUeahaHjpZnEDgGCAjHICZYWqEQMBVQEVRGT8yX
   A==;
X-CSE-ConnectionGUID: J7a6itniTPmahYlxN532nQ==
X-CSE-MsgGUID: 51ulRHcbQCOiFCgMWQRI2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="62040172"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="62040172"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:02:49 -0700
X-CSE-ConnectionGUID: dXD2RJ93Tt6pyX+xAJ2NDw==
X-CSE-MsgGUID: hSuR6kTMRn+AGELD/f8cHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="179516188"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.110.110]) ([10.125.110.110])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 09:02:48 -0700
Message-ID: <327e32f1-fba8-4b5a-b7a2-9fc875017521@intel.com>
Date: Mon, 6 Oct 2025 09:02:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 15/20] cxl: Add a routine to find cxl root decoder on
 cxl bus using cxl port
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134202epcas5p23f718742c74c5b519ecbbc1e04840c03@epcas5p2.samsung.com>
 <20250917134116.1623730-16-s.neeraj@samsung.com>
 <43772918-1911-46a5-8165-bf612056a8e6@intel.com>
 <700072760.81759726504033.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <700072760.81759726504033.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 9/29/25 6:40 AM, Neeraj Kumar wrote:
> On 24/09/25 11:11AM, Dave Jiang wrote:
>>
>>> +struct cxl_root_decoder *cxl_find_root_decoder_by_port(struct cxl_port *port)
>>> +{
>>> +    struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>>> +    struct device *dev;
>>> +
>>> +    if (!cxl_root)
>>> +        return NULL;
>>> +
>>> +    dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
>>> +    if (!dev)
>>> +        return NULL;
>>> +
>>> +    /* Release device ref taken via device_find_child() */
>>> +    put_device(dev);
>>
>> Should the caller release the device reference instead?
>>
>> DJ
> 
> Actually caller of this function wants to find root decoder information from cxl_port.
> So in order to find root decoder we have used device_find_child() which internally
> takes device ref. Therefore, just after finding the appropriate dev, I am releasing
> device ref.
> Its like taking device ref temporarly and releasing it then and there after finding
> proper root decoder.
> I believe, Releasing device ref from caller would make it look little out of context.

With the caller acquiring the root decoder, it should hold a reference until it is done with it. See usages of cxl_find_root_decoder(). i.e. core/region.c:cxl_add_to_region(). cxl_find_root_decoder_by_port() should do something similar. 

DJ
 
> 
> 
> Regards,
> Neeraj
> 

