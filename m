Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29FB126F0B
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707336322; cv=none; b=ZnW6+D0gN9O8Vxs9opkhlxyC9jrhfzrJEIuvgEB6eEsOfOSJm92SAQMm5v+34Lmz1i+0SYpAVZEIsViJQsMbi8DhIXWrt6a2AfIhPrZtSZLC+UmWFTOliabw72ZguOhQL8WcpGHojw1iWbrjl/qkFZwlfhg1kifA9U2e6KMI9L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707336322; c=relaxed/simple;
	bh=9nSlU41+XW5uGK1e/syr5OZBAjhwYZAC4yCUrfpImvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5l8L82++hqfTr2vAP+QZxDMXdQBTKwtLM9DZ5aCi2QM9i1f3XSZGsxiPYe7QMrpVkO1JVcPYON2YsVWZjuefgFazwdpIGa4ip6uEaDXOcw8Ybh/Ppa5MLa8sR+NW/IQqdBB2rCZsro4ZzmDs9ZpDc+kztH4q7FJRuBenhIJGss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W28GeADg; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W28GeADg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707336321; x=1738872321;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9nSlU41+XW5uGK1e/syr5OZBAjhwYZAC4yCUrfpImvo=;
  b=W28GeADgomeTOeguW2azUoNBIXezobipEyjMPax8702jOq0/IALgb/DD
   AjPbjzMFz5dSUixZf3lzgvtkvQr2c2YgGj55veYkwK219jMwPQXjetSmX
   +L/cFSYqvR3vZ4NLCuXaW3bgsFvMU3zKkt4eZsvtuAT60qAcRR11mDshZ
   ms5gTWXWXoh6yM66WHRHXIoaQYhm/1x66EvSp4MesCdnsd3VMQ1u73P8Q
   FEWC0JKBeD8SW8JzWC0xAnlphq3rQLX4/tbxGzEK0IyWKHih4Y61BMaso
   UPdPXkgMwGQUPtILXyWBaRK8rE90wIKM+3cqXQUNDB+1TrUqkMXAr3tRJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="983213"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="983213"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:05:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="6071713"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.105.224])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:05:19 -0800
Date: Wed, 7 Feb 2024 12:05:17 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v6 1/4] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Message-ID: <ZcPiffSmUyGWC6kB@aschofie-mobl2>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
 <20240207172055.1882900-2-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207172055.1882900-2-dave.jiang@intel.com>

On Wed, Feb 07, 2024 at 10:19:36AM -0700, Dave Jiang wrote:
> Add libcxl API to retrieve the QoS class for the root decoder. Also add
> support to display the QoS class for the root decoder through the 'cxl
> list' command. The qos_class is the QTG ID of the CFMWS window that
> represents the root decoder.
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---

-snip-

> @@ -136,6 +136,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
>  		param.regions = true;
>  		/*fallthrough*/
>  	case 0:
> +		param.qos = true;
>  		break;
>  	}

Add qos to the -vvv explainer in Documentation/cxl/cxl-list.txt 

