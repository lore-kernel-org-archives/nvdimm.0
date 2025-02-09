Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8B124339A
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739065593; cv=none; b=PEWj/g0BSwxeNCHgV0Mu2cSLcEvc0QCD58N66SXQ6jCOPVE00kyfzlDlZnBdc3+32OueKExdzks7j0u2QTn3pd2szc9fr0Z/yC53+2Ku3nipWSLp5VNtgfvnTkTNxG6oBGOedx6BIoAbBQ98QXXX+d92BaPXSV6hPpvSRk+bU+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739065593; c=relaxed/simple;
	bh=pn9rpmhaBQs7XWJoRFSEIOMSHsm3U2pa/vc4la0TCiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMJjt81nOu/8MuDvlsSCCRc0sfNOsezILDZqPWSmOZ7m7pE1oCFTZl2yxpS08w7SUpDF2eqh82saOG40JI288uXsGYX7BTkXOtnSi82znBYI6axszM0384wIZKKuuqmuY5AC0mRr1vNqZONnELeSNks+8dZucSe6KRxkks8Bqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lVPhLi+O; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lVPhLi+O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739065592; x=1770601592;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pn9rpmhaBQs7XWJoRFSEIOMSHsm3U2pa/vc4la0TCiY=;
  b=lVPhLi+OM7J0JH5FDW7YNPLaSqOUdEXhzRy0ccPrPHR9BX9/Ib4Le6k/
   19VoUjUBw0mIXFE9FB1D/7+1M+mA8NscDkqiGPoJw4K178M8CrD51sZbY
   4CtK2CqV/fvxbzJwiBtAjxGBkQl5g6hNRreJx+dN0DJ928L1Ts78a3UBH
   XOQ+KiwScK2RJqMk6l+m5htIRQ+Wxur79fRNKsB6u73aXNtwWg6IperTT
   LwP/fV7srwfJ3SfZHXRxHFKQt1VZkuMt7A8shovzzPJhrJ8oxqT01BcMy
   HPkR6DNSa2Rca08Xj1DRl/XK7H79gTx2hXPOQ6EbWp5UQRsaJmlqqi42m
   A==;
X-CSE-ConnectionGUID: xGoqC0mKSNm3nNVwoaQ/Bg==
X-CSE-MsgGUID: L+f4rvqdSTmHe9KNd7WQeg==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="42516974"
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="42516974"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:46:31 -0800
X-CSE-ConnectionGUID: 4MP1j8XTR4ezm+0vKkGFLg==
X-CSE-MsgGUID: EpOiMZ5CT0izH29DPsXSvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="111689501"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:46:30 -0800
Date: Sat, 8 Feb 2025 17:46:28 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Ming <ming.li@zohomail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/1] daxctl: Output more information if memblock is
 unremovable
Message-ID: <Z6gI9AI5slmNc7S2@aschofie-mobl2.lan>
References: <20241204161457.1113419-1-ming.li@zohomail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204161457.1113419-1-ming.li@zohomail.com>

On Thu, Dec 05, 2024 at 12:14:56AM +0800, Li Ming wrote:
> If CONFIG_MEMORY_HOTREMOVE is disabled by kernel, memblocks will not be
> removed, so 'dax offline-memory all' will output below error logs:
> 
>   libdaxctl: offline_one_memblock: dax0.0: Failed to offline /sys/devices/system/node/node6/memory371/state: Invalid argument
>   dax0.0: failed to offline memory: Invalid argument
>   error offlining memory: Invalid argument
>   offlined memory for 0 devices
> 
> The log does not clearly show why the command failed. So checking if the
> target memblock is removable before offlining it by querying
> '/sys/devices/system/node/nodeX/memoryY/removable', then output specific
> logs if the memblock is unremovable, output will be:
> 
>   libdaxctl: offline_one_memblock: dax0.0: memory371 is unremovable
>   dax0.0: failed to offline memory: Operation not supported
>   error offlining memory: Operation not supported
>   offlined memory for 0 devices
> 
> Besides, delay to set up string 'path' for offlining memblock operation,
> because string 'path' is stored in 'mem->mem_buf' which is a shared
> buffer, it will be used in memblock_is_removable().
> 
> Signed-off-by: Li Ming <ming.li@zohomail.com>
> ---

Hi Ming,

I was looking to merge this today but realized that I only have
a test for it in the 'affirmative'. The ndctl:dax unit tests exercise
this path, but since nfit-test module requires CONFIG_MEMORY_HOTREMOVE
I could only prove that this works one way. I put in some printfs and
saw it in action:
        libdaxctl: memblock_is_removable: Ming: memblock_is_removable()
        libdaxctl: offline_one_memblock: Ming: return from memblock_is_removable()

Let's get another reviewer eyes on this before merging.
Also, if you can add your qemu (i'm guessing) demo that would be helpful.

Also, we were having discussions about exposing more info to user, but I
think that can be a follow on. You can propose that it another patch after
this one, if you think it is worthwhile.



snip
