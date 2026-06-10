Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD1332EBB
	for <nvdimm@lists.linux.dev>; Wed, 10 Jun 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110553; cv=none; b=TPhva1r2q/jPlyE6UH6urst3sU8JqsYdW1cYP/b216ZChX2OTq3HQ2gJZSdz0XK2K69YA98tFFfXsytOFyJI2hTzmRxyBWNFjnQ2iGzT7wb3FE7ivgkGshIjitEUgwjqsK0QCcfnKmXjutI37NVXuluYBPoJTbbHE4dn4Pa+wAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110553; c=relaxed/simple;
	bh=s5ITXrYBZuuIMrxSZGI2VrUQx3GqktyTS1YvO5WU/38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P73gydirwoJQuItyWx9tLg8LFUsHXhqdBx305IBVZDDdSrJWUB/NmBQq/1eqVeTO0YfdS2bC5Wlm3bCG/LNpSbRD2hvDeWBNP15vhyZP4pxX2PjAN4RuxzT+s8M8yN22ISM0SuFHxBKdD4ZH5l9eti4AQzCLf8VYnMTzw7oe69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XUWTrPML; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XUWTrPML"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781110553; x=1812646553;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s5ITXrYBZuuIMrxSZGI2VrUQx3GqktyTS1YvO5WU/38=;
  b=XUWTrPMLDkIwvJM9nt0pd+rOXTneEQjFEnmhPAhX5dxr6xl5YE8mxZ2Q
   hm5bM26qWCXQoGOjMJ7ntUEqBHzTK+dFPiSuUE3impYYnZ/Mb+edq2+5V
   0FbuP4e/EnVSQ/2//XnqoEyHTZjkj2u5qbr2H9OO4i1L7fsYB++8/rHnU
   iEQRrVb3nhFkJwB/LwJCzCfczrM6ygyaYg37nuSgziH8S5CdliiHFyPYE
   FadiT5jAjLUE7kw8/x3+bAyW6Q1Ksg4VpVf5Ah0rHsj1pp72V6+xRG1gf
   k1grbwE4kqa/oGVRf+3NC62wgN8eDuEyunN6dkSo0yucQq77tbs8sxRQK
   Q==;
X-CSE-ConnectionGUID: 3wZSMA/cTVeCchwu0dJoWA==
X-CSE-MsgGUID: sQoZtdgfQoe2tHdUpmoQqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="92476983"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="92476983"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:55:52 -0700
X-CSE-ConnectionGUID: HzAnaYx6SzaULncc5T8h9w==
X-CSE-MsgGUID: RunScNijSwOkypS6Cecmtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="243765877"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.25]) ([10.125.110.25])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:55:50 -0700
Message-ID: <8656e29c-79ff-4b96-87ba-7919ad32a6a2@intel.com>
Date: Wed, 10 Jun 2026 09:55:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
To: Richard Cheng <icheng@nvidia.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
 Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
 <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
 <aijefVjI2x6hgxH8@MWDK4CY14F>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <aijefVjI2x6hgxH8@MWDK4CY14F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/9/26 8:51 PM, Richard Cheng wrote:
> On Mon, Jun 08, 2026 at 04:19:47PM +0800, Dave Jiang wrote:
>>
>>
>> On 5/23/26 2:50 AM, Anisa Su wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>

<-- snip -->

>>> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
>>> index ed4429f..258bdd3 100644
>>> --- a/cxl/lib/libcxl.sym
>>> +++ b/cxl/lib/libcxl.sym
>>> @@ -294,6 +294,10 @@ global:
>>>  	cxl_memdev_get_fwctl;
>>>  	cxl_fwctl_get_major;
>>>  	cxl_fwctl_get_minor;
>>> +	cxl_memdev_get_dynamic_ram_a_size;
>>> +	cxl_memdev_get_dynamic_ram_a_qos_class;
>>> +	cxl_decoder_is_dynamic_ram_a_capable;
>>> +	cxl_decoder_create_dynamic_ram_a_region;
>>>  } LIBECXL_8;
>>>  
>>>  LIBCXL_10 {
> 
> Shouldn't new exported symbols go in a fresh top-level node ?
> Something like LIBCXL_12 ? please note that Patch 4 has the same
> issue.
> 
> Please let me know if I'm wrong or misunderstand anything.
You are correct. These need to be moved to a new block for a new release. 
