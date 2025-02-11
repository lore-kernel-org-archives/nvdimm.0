Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307BB1ADC68
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 03:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739244107; cv=none; b=B97eVj1cQz1ANVPSvpazw2WRQ2BfF/6afEG4coC9cmHJUSf9F0HKuCQaSibKz7CGdGegckSo6TaH8/3wbOU4Z31VYzOSdHCpFazrSfeBRBJHNaybkGgSmNls3b3fxXp3TjsIKr5irlgVEzphpT68NI2Rl/JPo/a+8H1TkA/qQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739244107; c=relaxed/simple;
	bh=QDXwC7pnVs8YwEVVN3iHbVWY53Yv4B1VVT17aAlCmzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPNjvGhy1BjzjIL7zRiKvbufD2q+3rPAlmQsaSfn+PjmXYltzy9oC/XmK0+dtPxeUhUAcrTquHDmdhNT5oY9IM2sbGuePXZd2tpToouMHUMoiBbkTtD0ozOjaYS4fefeL2wy8nkK/YtTVbcrFSK382eZ0cFNZFQC5C1CKpCtfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EKinyxxC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EKinyxxC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739244106; x=1770780106;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QDXwC7pnVs8YwEVVN3iHbVWY53Yv4B1VVT17aAlCmzI=;
  b=EKinyxxCs6yEAiJopy4dqbeEEUaID/XSzZJrahwfWKoX9IXUGOSBVd2k
   EmOFsaZcyq2p5WT26dVNIfGDN/h5/Tr/7ztOB6ram5kKy5fzaUZEpQFG0
   tTt3pHG4hEchTn5iTkTBZUSvp6JCl/du6voDKIGmFCCN26+c/LKh1zKEX
   3yqEoZTFOBvQpr/qHerQg635E3nw9uUjxKP2N6hKGiZq+vSvkGl94mUBK
   107ZowAi3Jf7qGTHg6qNEk54nyi/uPa9Yc2cZk+nZfWTpzlXBU43SYe/H
   MXzPuwvYUgi+N6NrW0yRBYFHY3SLdGzB1rbNK7ZH+FYZjgeeFIFXefrm4
   Q==;
X-CSE-ConnectionGUID: K/aIE+U9SdeavOyFzTtblQ==
X-CSE-MsgGUID: YJfC1vkSQ9GGyfp0jRzs2Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="62324263"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="62324263"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:21:45 -0800
X-CSE-ConnectionGUID: XGHIw4JMTw6C/vZN+e7vuQ==
X-CSE-MsgGUID: 0Nm7QY4AQNCSTvlaja1Hxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112140312"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.205])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:21:44 -0800
Date: Mon, 10 Feb 2025 19:21:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Sushant1 Kumar <sushant1.kumar@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v4 6/9] cxl/region: Add cxl-cli support for DCD
 regions
Message-ID: <Z6rCRgiqWXBKy35i@aschofie-mobl2.lan>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
 <20241214-dcd-region2-v4-6-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214-dcd-region2-v4-6-36550a97f8e2@intel.com>

On Sat, Dec 14, 2024 at 08:58:33PM -0600, Ira Weiny wrote:
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> sparse and defined as dynamic capacity (dc).
> 
> DCD region creation requires a specific partition, or decoder mode, to
> be supplied.  Introduce a required option for dc regions to specify the
> decoder mode.
> 
> Add support for dynamic capacity region creation.
> 
> Based on an original patch from Navneet Singh.
> 
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  Documentation/cxl/cxl-create-region.txt | 11 ++++++++--
>  cxl/json.c                              | 27 ++++++++++++++++++++++-
>  cxl/memdev.c                            |  4 +++-
>  cxl/region.c                            | 39 ++++++++++++++++++++++++++++++++-
>  4 files changed, 76 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
> index b244af60b8a63281ed63d0d6f4027ea729ad51b0..a12cc8d3f19fa582376599ecc8512640f15ce42c 100644
> --- a/Documentation/cxl/cxl-create-region.txt
> +++ b/Documentation/cxl/cxl-create-region.txt
> @@ -75,8 +75,9 @@ include::bus-option.txt[]
>  
>  -t::
>  --type=::
> -	Specify the region type - 'pmem' or 'ram'. Default to root decoder
> -	capability, and if that is ambiguous, default to 'pmem'.
> +	Specify the region type - 'pmem', 'ram', or 'dc'.  Default to root
> +	decoder capability including the first of any DC partition found.  If
> +	the decoder capability is ambiguous, default to 'pmem'.

When or why is a root decoders capability ambiguous? 

Is type 'dc' really analagous to 'pmem' or 'ram'?  As a newbie to DCD,
I'd have guessed it would say 'dyn' or 'dynamic' because dc is more
analagous to 'pc' and 'rc' and we don't use those.

-- snip to end
> 
