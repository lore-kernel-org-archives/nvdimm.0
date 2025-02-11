Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281B26BD95
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 02:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242042; cv=none; b=A2Vp+s2vKQtRXOBjJnHgfZCrwFA8dPFc69h2x8nS0INGUt48H/cdhfHnaB/FjSE2zi21poBeuwPFDLNTtXEfDxOH3svlZCJcdNJ5DR3koST/4uO7ykcPk3Ip13Q2ifeNO/k3oGDAPToz+PZNHPcu9RBtadhtIkP5pr1B3hmR7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242042; c=relaxed/simple;
	bh=njA+vY+Vv2TA503qIqdQAyNBcM6OrgNCoBcwV27IbFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StXWoLUYFZ9W2LOxZji3MpOe+6/vHrjjL+YAQW+2SsiR65q/pNHjpEeBgvanzMm5keroPLsQb25CuVxMgjW04RCPQ2wMsPuAlqHQ76mvd0NUjsjyZEQcxw2mXynayWx+pm3By/fgMytsTI/Z43Bea+GJnDbnKrHRGIAm5+AzoEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cLkGwjGV; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cLkGwjGV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242041; x=1770778041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=njA+vY+Vv2TA503qIqdQAyNBcM6OrgNCoBcwV27IbFo=;
  b=cLkGwjGVYck+vl3mc+Uv/f2+WDQ/1zqKVOJaa3IWfKe06MH+ce3rLWl4
   +0MDWsvfHfj3CqDmNnmSgoDmVmxhREpG7ZDQyV6dO+z6PTuM3gjOz+5K3
   2Qi4ePc1XAmNhbrGFjBVW2aEEwjYM6gJkHhB9BiQAqMqRFqFJqZ96znl5
   qY2rmOA0gD7K86lh6ow9wi72utaaf7JPP16i1bXiXMHdUwi2kLTJOtkO6
   E6aqGESGXVKGsY2OYfFnZmfgQxXGecPz84ufwfJ2AS3p3G9+NhCyfDQrg
   PZzoldCXgfCUGkfbjzAHJwbDkisrmdsno7niRdEYFC5cwt3akZHsGdyze
   g==;
X-CSE-ConnectionGUID: DFWpxXiNThes6S3FP1lb6g==
X-CSE-MsgGUID: gW6tjZWhSyuoM3gqsIGMvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="50077675"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="50077675"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:47:20 -0800
X-CSE-ConnectionGUID: s1xVeTdbQs60AGm8Y7CjsQ==
X-CSE-MsgGUID: dB96ADT1QdOtVaYBob2U/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="117576145"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.205])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:47:19 -0800
Date: Mon, 10 Feb 2025 18:47:18 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Sushant1 Kumar <sushant1.kumar@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v4 0/9] ndctl: Dynamic Capacity additions for
 cxl-cli
Message-ID: <Z6q6Nht8FKJYlnSR@aschofie-mobl2.lan>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>

On Sat, Dec 14, 2024 at 08:58:27PM -0600, Ira Weiny wrote:
> Further testing showed some bugs in the 'jq' command use in cxl-test.
> Fix those bugs and adjust test to work around false positive lockdep
> splats.
> 
> This series can be found here:
> 
> 	https://github.com/weiny2/ndctl/tree/dcd-region2-2024-12-10
> 
> CXL Dynamic Capacity Device (DCD) support is close to landing in the
> upstream kernel.  cxl-cli requires modifications to interact with those
> devices.  This includes creating and operating on DCD regions.
> cxl-testing allows for quick regression testing as well as helping to
> design the cxl-cli interfaces.
> 
> Add preliminary patches with some fixes.  Update libcxl, cxl-cli and
> cxl-test with DCD support.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> Changes in v4:
> - iweiny: Fix dax device checks in cxl-test
> - iweiny: Update some documentation
> - Link to v3: https://patch.msgid.link/20241115-dcd-region2-v3-0-585d480ccdab@intel.com
> 
> ---

Hi Ira,

Thanks for the separating out the libcxl and other updates.
I got a bit hung up on MODEs and then you made me aware that
MODEs were simplifying so I backed off trying to put together
a kernel build and run this. I eyeballed it, compiled, and
poked at a few things. See the individual patches.


> Ira Weiny (9):
>       ndctl/cxl-events: Don't fail test until event counts are reported
>       ndctl/cxl/region: Report max size for region creation
Above 2 applied to ndctl/pending. Sorry about bad email. I do think
I got the v4 of these.

>       libcxl: Separate region mode from decoder mode
>       cxl/region: Use new region mode in cxl-cli
>       libcxl: Add Dynamic Capacity region support
>       cxl/region: Add cxl-cli support for DCD regions
>       libcxl: Add extent functionality to DC regions
>       cxl/region: Add extent output to region query
>       cxl/test: Add Dynamic Capacity tests
