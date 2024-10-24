Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C067175A6
	for <nvdimm@lists.linux.dev>; Thu, 24 Oct 2024 02:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736231; cv=none; b=gRqTD+LI+igM+XAIkAJhD9AbaeDCTcEEL/QTRwKolKftrsCte6AxzCiI7hKqnbC0fulLw39GzCfCNqW07rewhLLSDMgy7odJyROylnePwvjxKHAerjNOnBKvOXe1QDKMbt9DuglDsI+r+3A8zSXolgTxrGO0k3bwzRqX1/mFGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736231; c=relaxed/simple;
	bh=xyPbevpgXpde/p7LGsQl3xTu4yb6YAK3NAKq/FGx/4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=piqksg8IvlYHsVDRJnH8WGma+dbjuMr97vHxfOPo7Ye3xTHbGMmEWiEV6H+MQMD5e7E9i5JlrYaxQew9JHkgC6ylPCXoDXc2g4AeX+aDUBjElHQOYNV3JK6LjUUEZnri+lBH3/uqYTkabOCPu6gxPG6OhrISSJ2W59q9a5CxjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QEZ6D7g9; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QEZ6D7g9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729736229; x=1761272229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xyPbevpgXpde/p7LGsQl3xTu4yb6YAK3NAKq/FGx/4Y=;
  b=QEZ6D7g9SHOF2oZ8X6F388ZBG1mKXeuOSxoX6JU0rFGckEi2aUC/cWnh
   WqjNpiSf9aC+GEKdMOahEih5DLOyeFSb04PxJaOMERXcMm1CD7WC5cg+u
   yaBYBOHOw5n9fmWOKAnEwDx6QfBMKGAUrkMb3O2msZSr+A6lxxgjYt+++
   VfIHqUykEh7W+DQ3WdydRaDCAuBUmU9GBYeq3Xx0jSJwRaUNhCigvKrIy
   7+A7bkSgNd70r+Ick/r2qdeKPtGawMmsPj/MDlB+SRQ+CSCDeZQLSDEso
   ThcQD7OmiRGgUhoJ4Nqv6nF1gPULJVp/oP+UYn7EYXvubiP9awSP4mbBH
   g==;
X-CSE-ConnectionGUID: hf+kXoPQQi2OoGQbd6WZNw==
X-CSE-MsgGUID: OYzxRDgMQDa4eB/7NcBLSQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29514753"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29514753"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2024 19:17:08 -0700
X-CSE-ConnectionGUID: zVEZZQhnRUql5GSJBHWj7w==
X-CSE-MsgGUID: ynqQeeHjRhSsFjiRX293Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,227,1725346800"; 
   d="scan'208";a="80623444"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.250])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2024 19:17:08 -0700
Date: Wed, 23 Oct 2024 19:17:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/28] cxl/region: Refactor common create region code
Message-ID: <ZxmuIrTVuWWnPDkq@aschofie-mobl2.lan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-15-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-15-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:21PM -0500, Ira Weiny wrote:
> create_pmem_region_store() and create_ram_region_store() are identical
> with the exception of the region mode.  With the addition of DC region
> mode this would end up being 3 copies of the same code.
> 
> Refactor create_pmem_region_store() and create_ram_region_store() to use
> a single common function to be used in subsequent DC code.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

--snip

