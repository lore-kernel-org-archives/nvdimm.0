Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA323C1F
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739064411; cv=none; b=MmRabACVsIjPeCtouSoPxLyObSy56d9o3EFomtqbAL+NINmGUnrrKtnj1gOtOmI8vKNMtjCDD/Z6jUjqW3hmC6bGsyudURMFW23jasfvFZj1blub/hU2WkE5SMPXC/7jmJcUPicsQv2rqCLDlDdu1Oyhq3OW9uy5r630s0U4CMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739064411; c=relaxed/simple;
	bh=SQQ2qz1S6d2d6R7VZjNR11TbkRi0vFJho3iRaoRMFDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vru5IXeq9Zolz7K6cWfy42vvFcJjCpTxmjNITp1P/x4jUglVwbEDt+OJ5lVNw6wWzyp3y5vLAoQbL0XrZcPidx5mhr9oh8K2Yc/6+IGbIfSOpYG6CR1EbI4k17gce4OT0TucxI//xMjcJXEO0Znvg/ClrXeY+F9s1wP4Svap/14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QtwHsJAs; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QtwHsJAs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739064410; x=1770600410;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SQQ2qz1S6d2d6R7VZjNR11TbkRi0vFJho3iRaoRMFDg=;
  b=QtwHsJAs+WQ7eNuvJthXhkuyhiNHXkqS+CoHmqM0eApelC4T80/8PwJ7
   c9DpOxbo52ytDywGsGIEEJWpP6OYPqbdk5SNW00NfBFG9oRiiDkZTKI5h
   qu+q/WRNYIQRlVBJWLUp3hLuLi78lSIfEc0Q5U/PNKQ3gSS5ENTH6rPTv
   XKnLc9EDj6RLQbI7MRQpES+b/6l2i9B810jpZoHhQ24KlLcXkGive7eO0
   6nQ8Q05BsER6zJcIDhwcs1GsD4UufKXKSQEYzzua41KWP6Oe6QLM4jz0T
   FMzy87jcqaHFxZnoNQxRV1tW49jKH44sDv+5yT8DyCbeMrkV3V9sKi7Ve
   g==;
X-CSE-ConnectionGUID: bP1CtSk2RWiVhcJK93vT4Q==
X-CSE-MsgGUID: XxqoJgdsS1Gy74JKjLhKEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="39695901"
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="39695901"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:26:50 -0800
X-CSE-ConnectionGUID: WkoG0k3qS+qpYeJkGx1A9w==
X-CSE-MsgGUID: GKuqJvR6SBa4QMQki25OYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111692498"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:26:49 -0800
Date: Sat, 8 Feb 2025 17:26:46 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 2/6] ndctl/cxl/region: Report max size for
 region creation
Message-ID: <Z6gEVs3CxhlVvM4x@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-2-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:46PM -0600, Ira Weiny wrote:
> When creating a region if the size exceeds the max an error is printed.
> However, the max available space is not reported which makes it harder
> to determine what is wrong.
> 
> Add the max size available to the output error.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Thanks! Applied to https://github.com/pmem/ndctl/commits/pending/

snip

