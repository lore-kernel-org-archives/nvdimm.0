Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E721B9C7
	for <nvdimm@lists.linux.dev>; Fri, 11 Apr 2025 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405600; cv=none; b=KN9NJNPu/42igME8DZWkJHlBzmRJfpIrg+bWKn7Ho8eMjtOsfwvVej6EmhxCeI4pMhZ+GovWQMuprGpkyDC/C2gsDFgZQIQGPi2hPuPoCQwk6M36iptwWZwObR7yQcnKxCtCvTIAeZE7Qy3SdjTkxoJKpEZ2BVKSX9NM8aR6c5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405600; c=relaxed/simple;
	bh=9ZJTJ8Cv8DFbVrO9Ci5Gd2uxLW95HZ4+FQE5SG9I0JM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=em/Vfubc+7YWUQjYo/7l9ab5Floj/KmZaL7p9UF1juAzrS8uZvlvFNYEdGjo8mNrBPkw4/pncEP21rrk+QI7nC6a0R8qvGa+n4k0DdbABSGPMAy/htikhODmNbw9dlAAIqzNfxReRJNfUL5vnvTWF5arTJCdS/eLC9xpoVwS+Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AeBiOu7R; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AeBiOu7R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744405599; x=1775941599;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ZJTJ8Cv8DFbVrO9Ci5Gd2uxLW95HZ4+FQE5SG9I0JM=;
  b=AeBiOu7ROZ9PB6zgPuytX+MFYXYEdM7OLfOEmK1hixWeRprFkA6nEC7k
   sximZ45ksVRonPaj5uYkq3uwqa9rtzc4cmo3VtrSHdpFvgm42enEhahOo
   f9sQG892XWzQWfpJ1/UU2evBSDSSsmW1ddw2srSPZsRMTiK3HpXGy3zVn
   V7CjwqszRzZ5pxUFTTSyWq/tauxZENLJzZb5r9ZaiCoqaUn+VKhN6Moo/
   hsAdwwvmUi2+N4IP711Ndsm+rRrut88gfINRDQMHRvTJppmGQsXQ/ppcb
   jVH6YkM4uIMQEnTWhwDBefFlFQuj+dBERfnL9GZkIcV/K64zAa0M7m1aY
   w==;
X-CSE-ConnectionGUID: 0ucu+boVTau4ZiwgFRQEdw==
X-CSE-MsgGUID: FfAaraHCTlK/9o9RiuCTuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11401"; a="63509815"
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="63509815"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 14:06:38 -0700
X-CSE-ConnectionGUID: Os/x+n54RsC6GP/5XQJT+w==
X-CSE-MsgGUID: hZN+SMl4RN6ppPRiKUsyEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,206,1739865600"; 
   d="scan'208";a="129062349"
Received: from inaky-mobl1.amr.corp.intel.com (HELO [10.125.108.170]) ([10.125.108.170])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2025 14:06:38 -0700
Message-ID: <1f055398-4fd9-4c65-8536-ac3da41476e0@intel.com>
Date: Fri, 11 Apr 2025 14:06:36 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v5 2/3] cxl: Enumerate major/minor of FWCTL char
 device
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20250411184831.2367464-1-dave.jiang@intel.com>
 <20250411184831.2367464-3-dave.jiang@intel.com>
 <Z_mBOJVF75TEKqRU@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <Z_mBOJVF75TEKqRU@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/11/25 1:53 PM, Alison Schofield wrote:
> On Fri, Apr 11, 2025 at 11:47:36AM -0700, Dave Jiang wrote:
> 
> big snip...
> 
>> +	char path[CXL_PATH_MAX];
> 
> A bit of minutiae, not directly related to your patch-
> 
> I see:
> ndctl keys code, (ndctl/key.s,load-keys) simply use the PATH_MAX which
> I believe comes from limits.h
> 
> The rest of ndctl is doing the calloc'ing, like you originally had it.
> (~/git/ndctl$ git grep char | grep alloc)

I get why the current code does the strlen(PATH) + N. It's just adding a little more to the existing discovered path since it is looking at specific sysfs paths. So in these cases, PATH_MAX may not be necessary.

DJ

> 
> Is it not safe, or is it wasterful, to make all use PATH_MAX?
> Would it be safe-er to make all use a NDCTL_PATH_MAX?
> 
> This may be worth tidying up but not clear which way to go.
> 
> snip
> 

