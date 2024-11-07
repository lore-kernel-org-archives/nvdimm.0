Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945F1213156
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 18:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731005556; cv=none; b=OoMMV0tJFuiiqTsvP6ZJ0i05J9KIJpNKZ5POFk9HgVOzz+j1Vqex8r91T00t9737FUAN3LRF9alsyiD2XJruNxN3Fv3I/gdkdcr2sBRmBvcG1gpwRbxTxmzfV2xXo4VhLftUA00VLImtsfffxWUf6hfP5udkrCwI8l4np/eMr4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731005556; c=relaxed/simple;
	bh=7rQlvvsUTs7Zd/z+vpOtOLXQmwtncMG6FNvdjNqbEdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bxefhivmHF6CN1SDhjgtX4fniXKJt7ad61nZKJd7/bCAMlVDxrlYNjU2xX6YW7ki1ZNDYP0+kiPrMNSKcgUFdUXX9ZvtjO4KBFZKfPWbAzh2C4mS6PSCWvvVOofMsoXMF4T8tluDa73BRZp9No4ff1NdrOZBJ4IqM+oGC9yV3t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G5M2UlJS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G5M2UlJS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731005554; x=1762541554;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7rQlvvsUTs7Zd/z+vpOtOLXQmwtncMG6FNvdjNqbEdY=;
  b=G5M2UlJSjTeBh0yt7l3w/Sor/yncLSFisOdK49Pv/+q+ncJTyO3OTVmZ
   10efQn+H5vYhg9uHye5fv/Sl3G78hEQ3yXQ519Am3Nq5/C4HMOUtcszFs
   oVQOIfn5WlxhAZAkNE0O14uCWqRNOddFU2nzVxxZ0REkqbP1ytNaqf/kT
   DpISbN13VVynfqYVchRS2rpcrga/Tn7owJcz9XO9IQjy/EAA1nqsL6ErJ
   O5u9qbda8/YHKXAvI2NaftxHIWcUl91rJTQHghgokRQ/AQlj22TqEl53O
   fY0/L8jLKKnJ5zk5IL/+AwUxK75xvKZ4AXklC65+ZerMa9utF2b09D842
   A==;
X-CSE-ConnectionGUID: BxvkLAx6S/GSDPC6JfRGNg==
X-CSE-MsgGUID: PHrlJUbhQnOnY1KurmVEbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="42270192"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="42270192"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:52:34 -0800
X-CSE-ConnectionGUID: Otg6W/xyRUWhCWAFSmjaKQ==
X-CSE-MsgGUID: 7byrBEXrRK+at/rVCxleRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="122712994"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.171])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:52:34 -0800
Date: Thu, 7 Nov 2024 10:52:31 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: ira.weiny@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <Zy0Mb13kB5fOiqio@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:48PM -0600, Ira Weiny wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> spare and defined as dynamic capacity (dc).
> 
> Add support for DCD devices.  Query for DCD capabilities.  Add the
> ability to add DC partitions to a CXL DC region.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
 
Since you are submitting as a Co-developer, according to this:

https://docs.kernel.org/process/submitting-patches.html

it should look like this: 

Co-developed-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

I recognize the Co-authored-by Tag as commonly used w github,
while ndctl follows the kernel customs 




