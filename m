Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D33D19D8B2
	for <nvdimm@lists.linux.dev>; Thu, 22 May 2025 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747938314; cv=none; b=IYrbFfd+mCikUzeVqTwMP7qnFXNqbRl+WkCzJjbfRzUJHjTYEo3xdSmm5TN4CosqerjRpYNF8MDDxegj7BbVME0CTEqYXBHJJEfdlWE3dnl489/uozpJmSb0uCQRYFzjvNns/3JLztrcStsctFbHNcsJIuEmL9smsJ+Omq0ZO/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747938314; c=relaxed/simple;
	bh=rnA8oPaPDHlXTlrVKfck5H8G0jvm8UDQaDcYs/j0MT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lAGS5jurXHK8EAbJXx/q/C0SbNUrlM+nJmshLt5myls8RQamqbZi+hOJRMQ/U+EKcdVhjyyYvB7hU+Yxe10HTmAENoqDePvMsP1/1GwQ165r5pFDYte1i8sO3cTvnukllntLPTViSJDGiOdTYnP+z1DMwnp2LoP5M5939tqLr+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mkhq69ZB; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mkhq69ZB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747938314; x=1779474314;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rnA8oPaPDHlXTlrVKfck5H8G0jvm8UDQaDcYs/j0MT0=;
  b=mkhq69ZBAk7TYnxrkIIDzvjTBmM4KBinqWFCtwpO0ajcj2SkYf+U7adb
   UIpf8TbCQ2Q6I4qHR+R/1BdyEmlLxlDnR7y5UqDNjrSiOgwyGFrKLbzqm
   78DOqEf9UM+S2LueV3HjYs2gHxBBYtOW+ObUQegVAaKfV1ZfgRBsJIIxc
   Lo+eitYBc0rLZoL9z1qmwoetQmG4HWKzeJzBq66NrQQV/GZpWD4YTKkWk
   FLIpt8t9dG0rO38uIxyGDJ6ud9ffeJPLclWkFrNcizL5tUt4SnvAyjR0s
   nPvN9AlquZ3NS1f2ZvyykA0EeXfQ3JUnt7E0NkKgZjhwnDRjQm3O0alnp
   w==;
X-CSE-ConnectionGUID: Pj/owsHZRruZ4XkQeFGAxA==
X-CSE-MsgGUID: z5CTtCn1Tn2Mdk3wJlULoQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="61029727"
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="61029727"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 11:25:13 -0700
X-CSE-ConnectionGUID: PV4a7V0bTQu5zaZfh8fvXw==
X-CSE-MsgGUID: 2Ht4z9M9TC+fwOXjV57hAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,306,1739865600"; 
   d="scan'208";a="171604941"
Received: from adavare-mobl.amr.corp.intel.com (HELO [10.125.186.118]) ([10.125.186.118])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 11:25:13 -0700
Message-ID: <acfac209-430b-486a-b468-3b98575b8b12@linux.intel.com>
Date: Thu, 22 May 2025 11:25:04 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v6 4/4] cxl/test: Add test for cxl features device
Content-Language: en-GB
To: Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
References: <20250509164006.687873-1-dave.jiang@intel.com>
 <20250509164006.687873-5-dave.jiang@intel.com>
 <aCYxY8tmvJ14sWB-@aschofie-mobl2.lan>
 <1375994d-d3ba-479d-8910-8e564967bace@intel.com>
 <ee7865a2-d57a-4b94-820f-7a3be90377b9@linux.intel.com>
 <fc21a089-efa0-41b4-bc3e-70f6e7423719@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <fc21a089-efa0-41b4-bc3e-70f6e7423719@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



>>>>>  
>>>>> +uuid_dep = dependency('uuid', required: false)
>>>>> +if get_option('fwctl').enabled() and uuid_dep.found()
>>>>> +  fwctl = executable('fwctl', 'fwctl.c',
>>>>> +    dependencies : libcxl_deps,
>>>>> +    include_directories : root_inc,
>>>>> +  )
>>>>> +  cxl_features = find_program('cxl-features.sh')
>>>>> +  tests += [
>>>>> +    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
>>>>> +  ]
>>>>> +endif
>>>>
>>>> Is the fwctl feature enabled fuss still needed now that the UAPI headers
>>>> are vendored locally?  Seems the test will quickly SKIP if fwctl dev not
>>>> found. I kind of like the idea of seeing a 'SKIP' and knowing the test
>>>> didn't run than seeing nothing at all in the test output.
>>>
>>> This gives the option to disable fwctl if needed. Also there is a libuuid dependency since we use uuid lib calls. 
>>
>> Is it possible to go anywhere without uuid?
>>
>> [snip]
>>
>> It looks like a hard requirement to me.
>>
>> UUIDs are rarely ever "optional". It could be required only
>> by some optional tool but that does not seem to be the case here
> 
> Apparently it's not an requirement for kernel build. As my feature user header caused issues due to lack of libuuid package.

I think I wasn't clear, let me be more explicit: I think you should drop
all the code with "uuid_dep" above. It would not just simplify the code
(uuid_dep.found() is always true), but it would also get rid of
some (unfounded) reader's anxiety about an (im)possible system
configuration where fwctl is not tested without even printing a "SKIP".

It never hurts to express dependencies, but I think it's also bad to
look like you can opt out when you cannot.
