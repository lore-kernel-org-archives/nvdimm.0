Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972BE2147F3
	for <nvdimm@lists.linux.dev>; Mon,  3 Mar 2025 19:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741031952; cv=none; b=WbYlj3h4Fnf9YIonehz1UTTHUlulf4lJG/d7PTjj8gGOmXgLA9Agjb9PytVRMzqd4vSYr4RVQk16I8DEHCNBL28pouEKTXwixJjaRYtrAZx4pGIdbB361efc2lfEw6jNZnFsd4zjag+RQscXg+qkK2V7P1dPqHJ1kk8f5wRMpmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741031952; c=relaxed/simple;
	bh=onGsH//ISoP+hJio0Mbml5uOMHXkptEJIstwJExzbOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIm9pbAPloDrE+vyJ7BxDL/yn/B3DviPZAHMHjZgBs2qkY+nZ96tqH182wQH8WxcHhAISBfBOTdG4GxyHJCi0FCn1/SLDvmcLcPzk5PUfMKP+udd3ql0NTDn5TAXQqQ+RzNjqoQtdbu4ndso2jRYPdF6N4FY0S3dUGbQpXtHMvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V1qoTTyo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V1qoTTyo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741031950; x=1772567950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=onGsH//ISoP+hJio0Mbml5uOMHXkptEJIstwJExzbOg=;
  b=V1qoTTyoQyP3sq9sNTekoHfetL6BDlA8wpU9qTLWQ7Di5SaVRCFe8S43
   xBThYINm/mwf8rZFIg8X0nSGnnwiyBgCVd3hfO40VV04BxxnvtcOEPfJX
   q2GUgaWR76VFxL/HIZJbBWsDAl6y2Cgi1Y8wDSBpQgULWE0nR5gSHBaf4
   ++iZ55BQ+9bry7iqebOmB5iX4unKdonM8chOvbJvDf/F/YpRQlFXCiTvZ
   7PL7hurnNu3cHpBM7Ukh+dg6gIqV2vNPtlPiyuk+R01YduFHIdmkEJp0b
   2y0bxANbH7hfsMNChON0VP9/5X5TUsSisL/guOvKpZaDNjPxxiHLZVkBf
   Q==;
X-CSE-ConnectionGUID: oYpWjQw7RGa+Q3cCETjrIA==
X-CSE-MsgGUID: E0XLQuTfTKWz3Xnr1Th2Qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52130577"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="52130577"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 11:59:10 -0800
X-CSE-ConnectionGUID: SLP9mhmTT6+WerKhWAYO3w==
X-CSE-MsgGUID: 3Vadal1+T4KcMQGMRn7ATg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="155331919"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.109.46])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 11:59:10 -0800
Date: Mon, 3 Mar 2025 11:59:08 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
Subject: Re: [ndctl PATCH] cxl/json: remove prefix from tracefs.h #include
Message-ID: <Z8YKDI7UgcLZ31Ym@aschofie-mobl2.lan>
References: <20250209180348.1773179-1-alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250209180348.1773179-1-alison.schofield@intel.com>

On Sun, Feb 09, 2025 at 10:03:46AM -0800, alison.schofield@intel.com wrote:
> From: Michal Suchanek <msuchanek@suse.de>
> 
> Distros vary on whether tracefs.h is placed in {prefix}/libtracefs/
> or {prefix}/tracefs/. Since the library ships with pkgconfig info
> to determine the exact include path the #include statement can drop
> the tracefs/ prefix.
> 
> This was previously found and fixed elsewhere:
> a59866328ec5 ("cxl/monitor: fix include paths for tracefs and traceevent")
> but was introduced anew with cxl media-error support in ndctl v80.
> 
> Reposted here from github pull request:
> https://github.com/pmem/ndctl/pull/268/
> 
> [ alison: commit msg and log edits ]
> 
> Fixes: 9873123fce03 ("cxl/list: collect and parse media_error records")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Merged to https://github.com/pmem/ndctl/commits/pending/

snip
> 
