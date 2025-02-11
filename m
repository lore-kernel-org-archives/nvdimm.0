Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95B9257D
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 03:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739244799; cv=none; b=XDNtCprD3W487Sl+4ZUWd6wf+42GwB236vAUJtFTQSTigPtmN5I58dtRDedBeBHLGzLDseh7ldfX7LawuF8NoY+kMitW2Yuik8KQVaWznyAG9LtJ5n8lQLUkv1fBQsoSOk7yAwCyzcvZ+51sZv44+royVNRJuoEBs88+yGgfXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739244799; c=relaxed/simple;
	bh=06bYRBvtj1DhZShg+UT0mVT5jxdmMqNm/UawwqHBVDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYbgRjbaIN0DQVC33ybWQf0NVoFwO23c81bwHZN+T1sZkXGb1+fShlzP9W1bwuWPYIj6Z8jEnvNySnivAiyyTn0ZoUSR4i23RnDh1e126oyX20JRIQMIYZRGkqCqGTqqpAbBgPRwgPlh/J3NTf9TiI/n/Nkjiv697v8+qWu8PXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZjOOL+1d; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZjOOL+1d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739244797; x=1770780797;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=06bYRBvtj1DhZShg+UT0mVT5jxdmMqNm/UawwqHBVDY=;
  b=ZjOOL+1dz5P6ltfkj1gEHVzwt3i8Qy09DceuRvG6CNvNWB0hQVjTu4hr
   /VE0xtVET08vhplChYFreswZOVLS+5Q4JuVSNrQzsd0DWzvV9xDBGsRIg
   sgkXl3Yoj1v9ckGYE74n17qf4C++xFF1jOfJPAeqhffwECP4XUxmqkbBY
   tUPVPob0dOmGQCDwsBfv6Iqq2n2Rv2rsdH3M7qQCveKq5WOOUIg/02DtF
   wuVwT1ncuP3YjR9LKUCKH6bpM1yFiaNPvsvgpKtaby8kshKAUlxMR1LZp
   f3yufSb5xG0gWuTcSPX2IKBWAn1MvogPtjbtRjlL6leGQpll3diTKQEMe
   Q==;
X-CSE-ConnectionGUID: SWz3u7YfT/+wjv5n6ha01Q==
X-CSE-MsgGUID: 8QHvsDpIQyeNq0K4LmpnWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="42688800"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="42688800"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:33:16 -0800
X-CSE-ConnectionGUID: M+05sKZ7Qrm7GT7Y/pW4GA==
X-CSE-MsgGUID: Egnr77oQSBueG2dIt45BNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="117299745"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.205])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:33:15 -0800
Date: Mon, 10 Feb 2025 19:33:14 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Sushant1 Kumar <sushant1.kumar@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v4 9/9] cxl/test: Add Dynamic Capacity tests
Message-ID: <Z6rE-r-1w2KsmnN1@aschofie-mobl2.lan>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
 <20241214-dcd-region2-v4-9-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214-dcd-region2-v4-9-36550a97f8e2@intel.com>

On Sat, Dec 14, 2024 at 08:58:36PM -0600, Ira Weiny wrote:
> cxl_test provides a good way to ensure quick smoke and regression
> testing.  The complexity of DCD and the new sparse DAX regions required
> to use them benefits greatly with a series of smoke tests.
> 
> The only part of the kernel stack which must be bypassed is the actual
> irq of DCD events.  However, the event processing itself can be tested
> via cxl_test calling directly into the event processing.
> 
> In this way the rest of the stack; management of sparse regions, the
> extent device lifetimes, and the dax device operations can be tested.
> 
> Add Dynamic Capacity Device tests for kernels which have DCD support.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Ira, This looks awesome but I'm going to wait for all the things updated
to try it out. Shellcheck has some complaints for you to consider before
the next rev.

--snip to end
