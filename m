Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81CF4C79
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739063958; cv=none; b=O1Vm3fTjxgEngqEHuczIuVCvCcRkcBeAnWiW/IVJkUlAfDdeuLK/GD/tGxThIr+HpHN2h5RpeqzNUBagm0eSasUku3NusqoHSOd4TVlm19aNWqMulFbWG5Zjxdv0f9EEJNHNfvXaG16jIIxA1a9Rvo25n2kTcrdjH5KxRr72SjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739063958; c=relaxed/simple;
	bh=I0EsgOfEPlaylV9n7/7Ly44IoZFRNuSFtnkSu3etI74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UbIIC/re5o/O/pOWDf4Ef+SKS2ew2BKlSs5QEPIMmzbXAZmEVdIgnUCMYX9SimYw1+R6FefgGm5vCxtmmzy1BWYsJk5si02LHhTW8XDEvfOYVogQmRBhWqWvKZQRDNG2T2wB4FuBTHg2BxX023Kf+HzHF6vHQ0C6nKv0xuyamd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fF9AjIqf; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fF9AjIqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739063957; x=1770599957;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I0EsgOfEPlaylV9n7/7Ly44IoZFRNuSFtnkSu3etI74=;
  b=fF9AjIqftsgS/Q5wPUvClUCqAdBbI2xGeBlK2nca/ATeA+U40aL44mXf
   1QFDmmxDo6uGH9IClrwI6CCfxBOpf6r/LcHH+ccgbbSofxKGI1KOtU5Ir
   LMuA2wda08eolg0UVRWssUU9/7qXktx2tySa1VS1o9jmB4brzYKtVY437
   dVITB+LXol3XEqJnheQfI1IVEzifKTES0HVDapAgHZZB6kDHssSVszvLi
   D5vgNNJ1B/90zXmGOiT9VtY07oJxCioQKDIfslJHK8/XqYXLBdXOnxSwg
   bWrtNVtAcIQs2ORNy9NuUvpdtHQlmRzDC+tk/4+sJ2BT+O0dVf6mGaJRE
   w==;
X-CSE-ConnectionGUID: 9T+aarCqQB6U+Y4PJcHTIA==
X-CSE-MsgGUID: KCcz3HHITAGtYUpsvQKxCA==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="39365651"
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="39365651"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:19:17 -0800
X-CSE-ConnectionGUID: HeU4YzjCRVGnlGnEqYZQEA==
X-CSE-MsgGUID: x06xNeLaTROrPKrQi7pjtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149055271"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:19:16 -0800
Date: Sat, 8 Feb 2025 17:19:14 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 1/2] test/monitor.sh convert float to integer
 before increment
Message-ID: <Z6gCkjfeYnCntdJy@aschofie-mobl2.lan>
References: <20241018013020.2523845-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018013020.2523845-1-lizhijian@fujitsu.com>

On Fri, Oct 18, 2024 at 09:30:19AM +0800, Li Zhijian wrote:
> The test log reported:
> test/monitor.sh: line 149: 40.0: syntax error: invalid arithmetic operator (error token is ".0")
> 
> It does stop the test prematurely. We never run the temperature
> inject test case of test_filter_dimmevent() because of the inability
> to increment the float.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>

Thanks! Applied to https://github.com/pmem/ndctl/tree/pending

-- snip

