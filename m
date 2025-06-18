Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96151E8342
	for <nvdimm@lists.linux.dev>; Wed, 18 Jun 2025 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287038; cv=none; b=tQWLVhkCktVknTHFHt8ag71V2W4ogOPYHIYUkamdG9KoVNXACPLhAWlIEnvLGNqVI3ZEds75Z++c9BFYs64ZZbE7iw3SJ1wGoC7SWd1uMdu5bOCrBfmgAMnCsVLnr8VWxVTFIeTcEcvXvJS0ytw/HiJdch+ieC+rEumD6bZFSkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287038; c=relaxed/simple;
	bh=Qjx65sLWnLqDr3KCsGlZUmqxL1hG+N4OJ8seOhFFjps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YtpXn8VllDPw6IYRzXsC5eDMJ1tb8gWXwJMWI0y15xngv/QDqq9HIsbPMf707G2NUb3zr+3dK6Y21DzoOLskgOdOu9YZxNyHAtO/KV/0PzKbWXHKU/wk2ZNd/SBKCGAQyhBx4QGqpkcjRyTUKh0nLhMwmawmSvlMh1dZIzYMAH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCExVbLK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCExVbLK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750287037; x=1781823037;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Qjx65sLWnLqDr3KCsGlZUmqxL1hG+N4OJ8seOhFFjps=;
  b=eCExVbLK2VoWecJ1TrFWT3kOv8mEd1cmFJcWvXAJyx2am1zpn0ycNKzZ
   Ainig/uQNHuySB4y4TqGuyHstVjTtA3R3j/HNxJfl6eWD7QuzpVhDA6LI
   5CIjhWxfpOO9NuP1Z1Dvgc+eBt2T9PxsdfIkrfblurv2b6CEv9zSNjGgO
   qcc8INF8lIOOKsvjq+eT9SOFcuVjp2EBganbfoU0iPbkyEbgHC8dUIvP0
   bNpAIkTeZDFfhoE6meUwUBX6GT5Cyp60y1xQyG/+kfaFLg3d+/JiBR+q9
   DSwmyehMqaBJopwQv+BnwFXolfi3TR7wA+eUTN8EhGqu3wH5TfW5dxM/p
   A==;
X-CSE-ConnectionGUID: zLD73USNRI6JP3SKZ467aw==
X-CSE-MsgGUID: kSoeNT/jSCCv1gRaNBP7DQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="56324829"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="56324829"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:50:36 -0700
X-CSE-ConnectionGUID: Hq3ql2S1Td+vDxtJDEPoqA==
X-CSE-MsgGUID: ChggmWiWT6GXaYe8dEGOjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="187557114"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO [10.125.108.99]) ([10.125.108.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 15:50:36 -0700
Message-ID: <a940a130-4c77-4f7c-812a-e273ddb01458@intel.com>
Date: Wed, 18 Jun 2025 15:50:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH] cxl: Add helper function to verify port is in
 memdev hierarchy
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20250618204117.4039030-1-dave.jiang@intel.com>
 <aFM1iWWREEU_dlyF@aschofie-mobl2.lan>
 <46ea54ab-4e20-47d8-985e-53cb7ebbf33f@intel.com>
 <aFNBc0JqMxWT5CMu@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aFNBc0JqMxWT5CMu@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/18/25 3:45 PM, Alison Schofield wrote:
> On Wed, Jun 18, 2025 at 02:58:13PM -0700, Dave Jiang wrote:
>>
>>
>> On 6/18/25 2:54 PM, Alison Schofield wrote:
>>> On Wed, Jun 18, 2025 at 01:41:17PM -0700, Dave Jiang wrote:
>>>> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
>>>> memdevs that are associated with a port in order to enable those
>>>> associated memdevs. When the kernel switch to delayed dport
>>>> initialization by enumerating the dports during memdev probe, the
>>>> dports are no longer valid until the memdev is probed. This means
>>>> that cxl_port_get_dport_by_memdev() will not find any memdevs under
>>>> the port.
>>>>
>>>> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
>>>> port is in the memdev hierarchy via the memdev->host_path where the sysfs
>>>> path contains all the devices in the hierarchy. This call is also backward
>>>> compatible with the old behavior.
>>>
>>> I get how this new function works w the delayed dport init that is
>>> coming soon to the CXL driver. I'm not so clear on why we leave the
>>> existing function in place when we know it will fail in some use
>>> cases. (It is a libcxl fcn afterall)
>>>
>>> Why not change the behavior of the existing function?
>>> How come this usage of cxl_port_get_dport_by_memdev() needs to change
>>> to the new helper and not the other usage in action_disable()?
>>>
>>> If the 'sometimes fails to find' function stays, how about libcxl
>>> docs explaining the limitations.
>>>
>>> Just stirring the pot to better understand ;)
>>
>> What's the process of retiring API calls? Add deprecated in the doc? Add warnings when called? 
> 
> What is wanted here? Should a v2 of the existing cxl_port_get_dport...
> be replaced with a v2 that can differentiate btw memdev not probed vs
> NULL for dport not found.
> 
> I see example of v2 APIs in ndctl/ndctl lib, so doable, but first need
> to define what is wanted.

So there are 2 locations using cxl_port_get_dport_by_memdev(). If the usage in cxl/filter.c can be replaced by the new function, then we can drop the call entirely for CXL CLI. Of course if someone else is using this function in their app, then we would be breaking their app. I wonder if we need to add documentation to explain where it would fail and emit warning of deprecation in the next release?
> 
>>
>>>
>>> --Alison
>>>
>>>
>>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>  cxl/lib/libcxl.c   | 31 +++++++++++++++++++++++++++++++
>>>>  cxl/lib/libcxl.sym |  5 +++++
>>>>  cxl/libcxl.h       |  3 +++
>>>>  cxl/port.c         |  2 +-
>>>>  4 files changed, 40 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
>>>> index 5d97023377ec..cafde1cee4e8 100644
>>>> --- a/cxl/lib/libcxl.c
>>>> +++ b/cxl/lib/libcxl.c
>>>> @@ -2024,6 +2024,37 @@ CXL_EXPORT int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev)
>>>>  	return is_enabled(path);
>>>>  }
>>>>  
>>>> +CXL_EXPORT bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
>>>> +					    struct cxl_port *port)
>>>> +{
>>>> +	const char *uport = cxl_port_get_host(port);
>>>> +	const char *start = "devices";
>>>> +	const char *pstr = "platform";
>>>> +	char *host, *pos;
>>>> +
>>>> +	host = strdup(memdev->host_path);
>>>> +	if (!host)
>>>> +		return false;
>>>> +
>>>> +	pos = strstr(host, start);
>>>> +	pos += strlen(start) + 1;
>>>> +	if (strncmp(pos, pstr, strlen(pstr)) == 0)
>>>> +		pos += strlen(pstr) + 1;
>>>> +	pos = strtok(pos, "/");
>>>> +
>>>> +	while (pos) {
>>>> +		if (strcmp(pos, uport) == 0) {
>>>> +			free(host);
>>>> +			return true;
>>>> +		}
>>>> +		pos = strtok(NULL, "/");
>>>> +	}
>>>> +
>>>> +	free(host);
>>>> +
>>>> +	return false;
>>>> +}
>>>> +
>>>>  static int cxl_port_init(struct cxl_port *port, struct cxl_port *parent_port,
>>>>  			 enum cxl_port_type type, struct cxl_ctx *ctx, int id,
>>>>  			 const char *cxlport_base)
>>>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>>>> index 3ad0cd06e25a..e01a676cdeb9 100644
>>>> --- a/cxl/lib/libcxl.sym
>>>> +++ b/cxl/lib/libcxl.sym
>>>> @@ -295,3 +295,8 @@ global:
>>>>  	cxl_fwctl_get_major;
>>>>  	cxl_fwctl_get_minor;
>>>>  } LIBECXL_8;
>>>> +
>>>> +LIBCXL_10 {
>>>> +global:
>>>> +	cxl_memdev_is_port_ancestor;
>>>> +} LIBCXL_9;
>>>> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
>>>> index 54d97d7bb501..54bc025b121d 100644
>>>> --- a/cxl/libcxl.h
>>>> +++ b/cxl/libcxl.h
>>>> @@ -179,6 +179,9 @@ bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
>>>>  struct cxl_dport *cxl_port_get_dport_by_memdev(struct cxl_port *port,
>>>>  					       struct cxl_memdev *memdev);
>>>>  
>>>> +bool cxl_memdev_is_port_ancestor(struct cxl_memdev *memdev,
>>>> +				 struct cxl_port *port);
>>>> +
>>>>  #define cxl_dport_foreach(port, dport)                                         \
>>>>  	for (dport = cxl_dport_get_first(port); dport != NULL;                 \
>>>>  	     dport = cxl_dport_get_next(dport))
>>>> diff --git a/cxl/port.c b/cxl/port.c
>>>> index 89f3916d85aa..c951c0c771e8 100644
>>>> --- a/cxl/port.c
>>>> +++ b/cxl/port.c
>>>> @@ -102,7 +102,7 @@ static int action_enable(struct cxl_port *port)
>>>>  		return rc;
>>>>  
>>>>  	cxl_memdev_foreach(ctx, memdev)
>>>> -		if (cxl_port_get_dport_by_memdev(port, memdev))
>>>> +		if (cxl_memdev_is_port_ancestor(memdev, port))
>>>>  			cxl_memdev_enable(memdev);
>>>>  	return 0;
>>>>  }
>>>>
>>>> base-commit: 74b9e411bf13e87df39a517d10143fafa7e2ea92
>>>> -- 
>>>> 2.49.0
>>>>
>>>>
>>

