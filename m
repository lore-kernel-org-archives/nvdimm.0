Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C496563A1
	for <nvdimm@lists.linux.dev>; Wed, 17 Jan 2024 05:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705469057; cv=none; b=PrVmoJ4cI3hr6hhjykSiM3hc4sirbQxI/9ypjca05uh7Odg4xBiELjoQ+yHpW0EP9Sc+gNGpxBkCzyuhM3V318YEhaVIB6uIPSO9A50MZ6Tok6lxzfguFvTvHoSkfa3r/fEeB0kcvXYtW8pAmD+D8W/tZb4L5dZdcMG0ffqJXyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705469057; c=relaxed/simple;
	bh=XwqUDW5MjXH61h0Z5vCBX14iahDvqvRc4Sxn/Xng3OM=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To; b=NlQm7PQiNpRMsDjWTQ5VIcq6mouGyepJTt5Om9gkMYqdyTW9KqRm4jI44t1fpJssnjYUbp+6cAR3zMklDu3hIcdrPsxBTJduqMKXp+lrX3EUk7N/nwla2nfll+BzDGhYEe6f4LhvHghgDbsAJMhKfQC667+d9QY/cWOAmGxJjjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VBInM1tL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VBInM1tL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705469055; x=1737005055;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XwqUDW5MjXH61h0Z5vCBX14iahDvqvRc4Sxn/Xng3OM=;
  b=VBInM1tLaQJE9+v40r9M6ZEe8CyEJgjlmhqYlKNP5kgIE1cbykJUwZGQ
   htFL/b+6TDnmO3QydReL+SIMj5KDkO9jkWKRUIoGl/2CunFkMTMU7xzrg
   /9aDfDd3ZxvOqUkXfMyY8KM61EqlpffsdmP35dUEUFlqxy8nbEnkz6RAC
   LPYVN/jnG8g6hGAlbO2vP24kXulKIjHBNi031mZna0TLPhCq8b97bfYi6
   U8j9BDJ+vll81M4EgOtfvc1xI+cA9dA7+dFRMmbP0TTp9y9+Vb89nt6ti
   3oSRA0urxiQUc2GM6ZA/g+v46RaAdh/JRWT12m8WnoIGu6JKaf5Wz0MuU
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="18666114"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="18666114"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 21:24:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="26371725"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.51.13])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 21:24:14 -0800
Date: Tue, 16 Jan 2024 21:24:12 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] tools/testing/nvdimm: Disable "missing prototypes /
 declarations" warnings
Message-ID: <ZadkfMw2hnZlRMdg@aschofie-mobl2>
References: <170543984331.460832.1780246477583036191.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170543984331.460832.1780246477583036191.stgit@dwillia2-xfh.jf.intel.com>

On Tue, Jan 16, 2024 at 01:17:23PM -0800, Dan Williams wrote:
> Prevent warnings of the form:
> 
> tools/testing/nvdimm/config_check.c:4:6: error: no previous prototype
> for ‘check’ [-Werror=missing-prototypes]
> 
> ...by locally disabling some warnings.
> 
> It turns out that:
> 
> Commit 0fcb70851fbf ("Makefile.extrawarn: turn on missing-prototypes globally")
> 
> ...in addition to expanding in-tree coverage, also impacts out-of-tree
> module builds like those in tools/testing/nvdimm/.
> 
> Filter out the warning options on unit test code that does not effect
> mainline builds.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> ---
>  tools/testing/nvdimm/Kbuild |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
> index 8153251ea389..91a3627f301a 100644
> --- a/tools/testing/nvdimm/Kbuild
> +++ b/tools/testing/nvdimm/Kbuild
> @@ -82,4 +82,6 @@ libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
>  libnvdimm-y += libnvdimm_test.o
>  libnvdimm-y += config_check.o
>  
> +KBUILD_CFLAGS := $(filter-out -Wmissing-prototypes -Wmissing-declarations, $(KBUILD_CFLAGS))
> +
>  obj-m += test/
> 
> 
