Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBC82512D0
	for <nvdimm@lists.linux.dev>; Thu,  3 Apr 2025 18:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743705648; cv=none; b=N4DOGEh5SefJ4mm6WZNB7dXSYIm26nk3ecTABgS8yZ4fKMf7n7ElW9cwSHUn9ouqJWCDshwboTvYSj4nooG7/qU10hT9AMAmmC70Kd2ekmxq3gkc2quyYK8mr2x1L9tCYDmHI9GLFdTYVvmtqeJaTqJVakmw8DlF3v8Giv77uII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743705648; c=relaxed/simple;
	bh=+67JXDQx5zChjcnw+v0CCW6m/RXyD81jjti8pA7/2Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVAK8P7jRUmAUW5ntzwug5q1qu0BTteM63iH7KPOG0+yJYOA4WbbfesmqZ+C6aSTvRiNDjsm2GAshwKedEQ7VYfyWtQ56yLU+VsQf6XGWuccq3WGkU+EtNkFIMlr1y2PavJhTTk31tzQlVbvErTipk11ScVSSlB19Z2jIhZaj98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n7/OCZ+3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n7/OCZ+3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743705646; x=1775241646;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+67JXDQx5zChjcnw+v0CCW6m/RXyD81jjti8pA7/2Gs=;
  b=n7/OCZ+3yKCK6waCruEP395w1ePTkgG7q0hdNGv19RERyKFxBdt8JOh9
   lNwdmwYfkQC+/gZNy/8tBANiAiIZlAVABW5eIwNfTLmTYqs+x9wePnqV0
   VDawaqq5TFlXyq1mNTYgzZ8Lfet18B6gpbQWW6jk9txnIu0KwIH9yxL+r
   Pfv9a2UEfhtm7aTBZ8YSYQB43AQzPhhfkZ0JR2pf3uE6739ZYWKaBlvli
   p4effnKF1lVF3vv+hIJ8kabjQ0nNhlUx7SN2cbb/8qWeZmrQDCFuLR6ku
   I1HxMpWw6gb8ahT8xwRezMXYLw2D5eQFhGAUvhPajAuFWSoSG7HNVShwM
   w==;
X-CSE-ConnectionGUID: fvozizfqReajIEiuW+vfOQ==
X-CSE-MsgGUID: bfVe/uEZRkquIYbmRet6Jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="56499562"
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="56499562"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 11:40:46 -0700
X-CSE-ConnectionGUID: TVhG7cbDTtWeBxtqRj9yjw==
X-CSE-MsgGUID: grr0MWSBT7SIPiKQr34ZDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="131215334"
Received: from smile.fi.intel.com ([10.237.72.58])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 11:40:38 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1u0PUQ-00000008tz0-2eZc;
	Thu, 03 Apr 2025 21:40:34 +0300
Date: Thu, 3 Apr 2025 21:40:34 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Terry Bowman <terry.bowman@amd.com>
Cc: dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, rafael@kernel.org, len.brown@intel.com, pavel@ucw.cz,
	ming.li@zohomail.com, nathan.fontenot@amd.com,
	Smita.KoralahalliChannabasappa@amd.com,
	huang.ying.caritas@gmail.com, yaoxt.fnst@fujitsu.com,
	peterz@infradead.org, gregkh@linuxfoundation.org,
	quic_jjohnson@quicinc.com, ilpo.jarvinen@linux.intel.com,
	bhelgaas@google.com, mika.westerberg@linux.intel.com,
	akpm@linux-foundation.org, gourry@gourry.net,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-pm@vger.kernel.org, rrichter@amd.com,
	benjamin.cheatham@amd.com, PradeepVineshReddy.Kodamati@amd.com,
	lizhijian@fujitsu.com
Subject: Re: [PATCH v3 1/4] kernel/resource: Provide mem region release for
 SOFT RESERVES
Message-ID: <Z-7WImoc5Dg3Xtyq@smile.fi.intel.com>
References: <20250403183315.286710-1-terry.bowman@amd.com>
 <20250403183315.286710-2-terry.bowman@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403183315.286710-2-terry.bowman@amd.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Apr 03, 2025 at 01:33:12PM -0500, Terry Bowman wrote:
> From: Nathan Fontenot <nathan.fontenot@amd.com>
> 
> Add a release_Sam_region_adjustable() interface to allow for
> removing SOFT RESERVE memory resources. This extracts out the code
> to remove a mem region into a common __release_mem_region_adjustable()
> routine, this routine takes additional parameters of an IORES
> descriptor type to add checks for IORES_DESC_* and a flag to check
> for IORESOURCE_BUSY to control it's behavior.
> 
> The existing release_mem_region_adjustable() is a front end to the
> common code and a new release_srmem_region_adjustable() is added to
> release SOFT RESERVE resources.

...

> +void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
> +{
> +	return __release_mem_region_adjustable(start, size,

You have still room on the previous line for the parameters.

> +					       true, IORES_DESC_NONE);

Return on void?! Interesting... What do you want to do here?

> +}
> +EXPORT_SYMBOL(release_mem_region_adjustable);
> +#endif
> +
> +#ifdef CONFIG_CXL_REGION
> +void release_srmem_region_adjustable(resource_size_t start,
> +				     resource_size_t size)

This can be put on a single line.

> +{
> +	return __release_mem_region_adjustable(start, size,
> +					       false, IORES_DESC_SOFT_RESERVED);

Same comments as per above function.

> +}
> +EXPORT_SYMBOL(release_srmem_region_adjustable);
> +#endif

-- 
With Best Regards,
Andy Shevchenko


