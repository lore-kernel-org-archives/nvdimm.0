Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E035220B28
	for <nvdimm@lists.linux.dev>; Fri, 26 Jan 2024 18:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292867; cv=none; b=eR744z6SGd/8lOwvR9FCAACIHbMYQ60FMnhc3m/gn0594/4rvvCvvQEZ/HnCWIbtTIuyIgEaEtMCxbtC7awCUnSGFmFzhxB3MbcLh+6W8671WYTS5vyUdfpy6QABHEdSfXR6z0gEu38E+7bmbEMfSJTf9OPmlu0GJHedwYtUNos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292867; c=relaxed/simple;
	bh=cMu2hdAvwOGamIxJRtoVK/TWT8xFZBUU+UGskH/1Dmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrKDBppAlZpeFrGHUe+Il6avRr3bh3kvLUIooB5iYk5rsyTRItnd1CwjzX1Uem2Pb8Mpp1ramhUR8fvVf1H4+qlftNn0aYmuJK7xny6tZVeXu8oDO5b6gpvTNONgQRi58HShZLejCVQbCyLpkyLaH4MFjZzVjDWMiUhsl0JL89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bgmbz9fT; arc=none smtp.client-ip=192.55.52.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bgmbz9fT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706292865; x=1737828865;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cMu2hdAvwOGamIxJRtoVK/TWT8xFZBUU+UGskH/1Dmg=;
  b=Bgmbz9fT3nFEd7Lp7WyObAhFq14d1O6ERHspy3AWgktOgT2PnW0Iy5hG
   5A8GsjitpfGIpLvVNw2LUu97m5SgPRuaoQHFO+JAGOOTJZMSpXWcq8d9T
   PJdzjtxsBGxQ3/sYCLgT9tjAjuSsbJ0LXjn8Wec3ycNutee1144Dq+RLh
   SK7W6kM3wnG1x1PKP6xaDSfwBmkDWASFvGUm2Y/JIuXPDUQmMUvUU9Kna
   VwapIAa73vVvRCvxBthIgAzKNFFcN8+xsZmxYxNYF0VkUo5+0N29FntG+
   M2M9rkoK+XEidBI31TBt7LLcxwYgs24qNtqCdJfVTyHbWXudQfXKpca6z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="433691123"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="433691123"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 10:14:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="28892802"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.37.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 10:14:24 -0800
Date: Fri, 26 Jan 2024 10:14:23 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v3 3/3] ndctl: cxl: add QoS class check for CXL
 region creation
Message-ID: <ZbP2f31s09WRzWb1@aschofie-mobl2>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <170612969410.2745924.538640158518770317.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170612969410.2745924.538640158518770317.stgit@djiang5-mobl3>

On Wed, Jan 24, 2024 at 01:54:54PM -0700, Dave Jiang wrote:
> The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
> represents the CFMWS. A qos_class attribute is exported via sysfs for the root
> decoder.
> 
> One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
> device for a CXL memory device. The input for the _DSM is the read and write
> latency and bandwidth for the path between the device and the CPU. The
> numbers are constructed by the kernel driver for the _DSM input. When a
> device is probed, QoS class tokens  are retrieved. This is useful for a
> hot-plugged CXL memory device that does not have regions created.
> 
> Add a check for config check during region creation. Emit a warning if the

Maybe "Add a QoS check during region creation."

> QoS class token from the root decoder is different than the mem device QoS
> class token. User parameter options are provided to fail instead of just
> warning.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v3:
> - Rebase to pending branch
> ---
>  Documentation/cxl/cxl-create-region.txt |    9 ++++
>  cxl/region.c                            |   67 +++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index f11a412bddfe..9ab2e0fee152 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -105,6 +105,15 @@ include::bus-option.txt[]
>  	supplied, the first cross-host bridge (if available), decoder that
>  	supports the largest interleave will be chosen.
>  
> +-e::
> +--strict::
> +	Enforce strict execution where any potential error will force failure.
> +	For example, if QTG ID mismatches will cause failure.

The definition of this 'Enforce ...' sounds very broad like it's
going to be used for more that this QTG ID check. Is it?  Maybe I
missed some earlier reviews and that is intentional.

I was expecting it to say something like: Enforce strict QTG ID matching.
Fail to create region on any mismatch.


> +
> +-q::
> +--no-enforce-qtg::
> +	Parameter to bypass QTG ID mismatch failure. Will only emit warning.
> +
>  include::human-option.txt[]
>  
>  include::debug-option.txt[]


snip

> 
