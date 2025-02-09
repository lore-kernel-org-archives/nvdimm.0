Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5CCEEC3
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739064316; cv=none; b=TVMrEKWatIWDFRMYBVTjlCKBXfzmaAStMhEvDsID7pivwat+VYaTbsmN5b6HXG09+kXzUcK19GSMGxBp4lVjBaAqCi+0R06QY6MmSvmcLq0/daI9sm5V4YsT/F0C92FaOS4p5ABjDVffYw7UwpT7umVN5+f8SQtUfybSy1JrzQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739064316; c=relaxed/simple;
	bh=8HvZjh/OZne0Rd9Pem7SJyNnKzy/3sBkmbrItwM4omU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WUrH0J6wmAl8Nn96+meeVLTP5jS+ISAzVUfBygm5Tr4qZmNflgE5ww+FrDVLrVrbQSahGm1QFB+c1HEfD+ylCZ1QjtzCfr8s6MrzwrD6rt29U1MOwceWZV6PMT0Mzn53dPs9EMYccvblvFtDXDYd0Bh2c+7zW/qb6Yi7G3feJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NAChfK99; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NAChfK99"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739064315; x=1770600315;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8HvZjh/OZne0Rd9Pem7SJyNnKzy/3sBkmbrItwM4omU=;
  b=NAChfK99TIhwnIZH5fJ7ehSJWzIkUOxigR4OwWHjJgmgOSCcfWvdEvsL
   mzgkB6fZK/FWMWX+wsGUwEm4pI+i1ZQtSpB9vL5C0TcGt2cP3gyF84R/j
   c8RNCqCOFbMeNvmoX9y4RsnpcO3ZiED8n5zg057j2G1kifUdxOsdJNQIB
   aHVrQQlQLrh22buJwjHrUdD6xrC3gwuM8FNFu2Zu6+IpiVaJouj0XpQwO
   lWOv/uw390mBVy0G/RXqbBGblkwsnTi1isR1Y+gcK5BwfaIWWsWE9MRPG
   xvBZAjIxIWI+i8QHOQvIdW7K+75Uv/Q3gNWUX/KtI8DeTRR5H+y/EUstc
   A==;
X-CSE-ConnectionGUID: RPEdN5knRv230+AlUECPJw==
X-CSE-MsgGUID: rTk/si7DSJKEygYUo2BTlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="42516357"
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="42516357"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:25:14 -0800
X-CSE-ConnectionGUID: Hc2TVKBsRfCK5nGK73LWHg==
X-CSE-MsgGUID: 09Fcdi1TQiu6BWMba+yHFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="116907798"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:25:14 -0800
Date: Sat, 8 Feb 2025 17:25:12 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 1/6] ndctl/cxl-events: Don't fail test until
 event counts are reported
Message-ID: <Z6gD-Lq1rWLveZWN@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-1-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-1-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:45PM -0600, Ira Weiny wrote:
> In testing DCD event modifications a failed cxl-event test lacked
> details on the event counts.  This was because the greps were failing
> the test rather than the check against the counts.
> 
> Suppress the grep failure and rely on event count checks for pass/fail
> of the test.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---

Thanks!  Applied to https://github.com/pmem/ndctl/commits/pending/
with [ alison: rm unnecessary reference to DCD in commit log ]

snip

