Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD5B2EACEF
	for <nvdimm@lists.linux.dev>; Thu,  8 Jan 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767895011; cv=none; b=eUi9A19QcvBdxA6fxqNi/cpLDDVjDNjlxkGNS/AtA2HOXfa0KkqLp0iffyIQz0yR0ESTbnMF/AvOkg0cEa8x2FVr5ATma2q3MTdMk454u70OWBkSm7ovvKDO700NEq2tNPsnR7knD/LbDXeRMvo/GtRON7wPvtlU7oMcxR9P0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767895011; c=relaxed/simple;
	bh=LjrnWOI9SwZkoVjxSwZLCKsDOR444Ug6rAeO/a3jcEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K/t/1SVWdrIGfKndcNYQ5IIRtz0gWITb27S/EhwNeYX6A66wVndk+iTH7hNStlNYl8HaCjZyylL14KtHFpeSoDQ0Df5Qftpem81FXqPeD2BR5ir/KGVCipjCval5jsCbDpaDa4F+cim0CesL5s6E07T7jNIGV1GE/PGJeG0hEu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hpLutgTy; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpLutgTy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767895011; x=1799431011;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LjrnWOI9SwZkoVjxSwZLCKsDOR444Ug6rAeO/a3jcEg=;
  b=hpLutgTya4hVVewZiKxXjZGDVuoxuNdzRQQANvxGl3m3IXxpgNjgVQO5
   0dTRcbEBUYMSrQ/RwS4B81WXpH5Oirxfz/i68Z+6IZAnJeGxwevUKWaNq
   d9zMLMu/yzDfRSn/8weJU8Xq2ruFtvjHk2n0Oa6hfOvpmwjyCog0Tg2dT
   KXxk1TSakVuFcJRHBXhLbJBFYPb74S2S/Nbr2Wkob3CRKCHmLKog7LA8r
   gZU3b3bArcRY55/KMzUkc2lz4Lf/go1mxEpgC/uAblHNeYvIhY0BL+0sO
   lLdZtzmdIZm5b/JeVKk9x50zArfyTRRA/6ZM/sDbIFUH5+tsFOHuwrSF3
   g==;
X-CSE-ConnectionGUID: DXIvabC4Sa6o0x4UfCfBIw==
X-CSE-MsgGUID: LC64FLVKQ6e4e/F/8jvtaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80725261"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80725261"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:56:50 -0800
X-CSE-ConnectionGUID: obEqvaAWQyqZTxnZqKIC/Q==
X-CSE-MsgGUID: hdr31HHlQpK5Ox1A6rW5Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="207803074"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.109.207]) ([10.125.109.207])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 09:56:50 -0800
Message-ID: <138c0ca6-3dc8-4a9f-8b40-c74a4dc19385@intel.com>
Date: Thu, 8 Jan 2026 10:56:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/cxl-topology.sh: test switch port target
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
References: <20260108052552.395896-1-alison.schofield@intel.com>
 <e2608021-a3bc-4598-bb98-2a8a885b9f8d@intel.com>
 <aV_tgUOQOh9U6-AE@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aV_tgUOQOh9U6-AE@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/8/26 10:46 AM, Alison Schofield wrote:
> On Thu, Jan 08, 2026 at 10:02:58AM -0700, Dave Jiang wrote:
>>
>>
>> On 1/7/26 10:25 PM, Alison Schofield wrote:
>>> Add a test case to validate that all switch port decoders sharing
>>> downstream ports, dports, have target lists properly enumerated.
> 
> snip
> 
>>>
>>> This new case is quietly skipped with kernel version 6.18 where it
>>> is known broken.
> 
> snip
> 
>>> +}
>>> +# Skip the target enumeration test where known broken
>>> +check_eq_kver 6.18 || test_switch_decoder_target_enumeration
>>
>> 6.19 I believe?
> 
> I found it fails with this commit introduced in 6.18:
> 4f06d81e7c6a ("cxl: Defer dport allocation for switch ports")
> 
> So intending to skip that single kern version.
> 
> I won't put this on ndctl/pending until the kernel patch is merged
> in 6.19.
> 
> Make sense?

Yeah maybe I'm misremembering. Anyhow

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> 
>>
>> DJ
>>
>>>  
>>>  # check that switch ports disappear after all of their memdevs have been
>>>  # disabled, and return when the memdevs are enabled.
>>

