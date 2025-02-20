Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1151EA7D0
	for <nvdimm@lists.linux.dev>; Thu, 20 Feb 2025 20:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740083871; cv=none; b=PQPMTzPUrfFmNhtO1UCcVPVf5aYp9Lzp35gRjWdsdtRp6JvCeOAqNejqlgCNjaozt2eLPaT1cHv7BTp38o/1noG19mh49BZ5wsCa6Q9LGETR1kbAn31TZ+ffm/OD25oGbZZYT4y92Oed1E+sPrr29Gq9Bhyu5h8TIz6AofUK94g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740083871; c=relaxed/simple;
	bh=W7jrMa2gf8FB8Fk6qyuO5AujkakbCuz0WvgyR8jZLto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k4dpsZeYZQjPmm3z+eWUT56xwzJWUeiMHaGEOhCNVtvTxpnN6OVAPs9rRQ2YG4/xzX8V0PFszcVkT8JygqVjQeq8NLYB8BAZZJjt3sZgbPmddG6ZCeJVm2OOgp/BAm7JXVnEhBe7w5HgPvblWmryWUKjs4npgozHEo09tiiUBKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2qBODrk; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2qBODrk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740083868; x=1771619868;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W7jrMa2gf8FB8Fk6qyuO5AujkakbCuz0WvgyR8jZLto=;
  b=C2qBODrkziiTYd4oAPCBUt3e+LD/N06JJbsUTDdL6MU0nq/h3cEwwN0u
   2h8zJTPx3w5YliERe4T7xCKGc4vXRUBqVVJAhTUrKH4UXbLL924i+/1gQ
   bMzCptEz3r5hispMr7cG1G0+zEHecUBHLXDORHRoGoihtraTWa9WtIbo5
   9haM9Eu6OIL7wmBi0FcU6O23pTs9bg5/waLGpw9zd7ZlMcPy4k+QbGG7Y
   9KX4x8vgZDYrjC/SGrmqxVJZVsndRbLZ/ksFQ5gCfG+MdG57G99OVv6a/
   +QL5/3yhPDCz8Sgiwp4v8XVCEGx9+1dNyLAqz2YefduyjS6PHX3rgv3Pn
   g==;
X-CSE-ConnectionGUID: vHPReCoSTUmFXSCc7styMg==
X-CSE-MsgGUID: SpPd+s19S+qul0JXwK9iDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="51506401"
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="51506401"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 12:37:48 -0800
X-CSE-ConnectionGUID: 8Q6TvtNzQUmDVpFLupZxDQ==
X-CSE-MsgGUID: /g/ZEPGNSs2z2uL7zdOUHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,302,1732608000"; 
   d="scan'208";a="120268866"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.117])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 12:37:47 -0800
Date: Thu, 20 Feb 2025 12:37:45 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: linux@treblig.org
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] nvdimm deadcoding
Message-ID: <Z7eSmfcdNeYr1rWa@aschofie-mobl2.lan>
References: <20250220004538.84585-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220004538.84585-1-linux@treblig.org>

On Thu, Feb 20, 2025 at 12:45:36AM +0000, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Hi,
>   A couple of nvdimm dead coding patches; they just
> remove entirely unused functions.

I see you've been sending patches for dead code removal
for several months. What tool are you using for discovery?

Thanks,
Alison


> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> 
> 
> Dr. David Alan Gilbert (2):
>   libnvdimm: Remove unused nd_region_conflict
>   libnvdimm: Remove unused nd_attach_ndns
> 
>  drivers/nvdimm/claim.c       | 11 ----------
>  drivers/nvdimm/nd-core.h     |  4 ----
>  drivers/nvdimm/region_devs.c | 41 ------------------------------------
>  3 files changed, 56 deletions(-)
> 
> -- 
> 2.48.1
> 
> 
