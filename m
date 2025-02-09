Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5397E819
	for <nvdimm@lists.linux.dev>; Sun,  9 Feb 2025 01:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739064212; cv=none; b=o+clVUp1/cQKuD6FBNTEFmNRohxPn641IQBJcApdMyx5WUUWEgD/3mdHaCvJFH++JrrQTC44ji4EC91kSUYuJzRROtkNTLxc2mEcYfmQSVoRXXy8fIyz0pLgbx4+/XsGGpAit8ctTtZNkAc8B1Uvfj3EtEJVFjlO19C0m49PbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739064212; c=relaxed/simple;
	bh=rEmXBEjiYmLoDizogR5e21aMkNXyTbXLysJN1B96MWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpjkxFGLie+4KQsy4nQrv5uN0kvt3U0qSdyYvboTIdDRVBJxDex2alnmXTHEkLCmCcjdCYHDwKVVlzre2j0Fo7pApHs1QSsk3YwvmYMi0byCHR4hkr3L5tLoahRqR9TTycBwT0SSXJf+sEGRJ0IpfrFVqABcl4qB8N67IUKdxlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XzZgG9dV; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XzZgG9dV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739064211; x=1770600211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rEmXBEjiYmLoDizogR5e21aMkNXyTbXLysJN1B96MWg=;
  b=XzZgG9dVfgOZOLEBFvq2QsnHEHo8W7kG3pLBXen9QDv1i5tYLIIjoOd8
   wAx1aR04lm1rBoQsZMF0nAZ+Yv+GUwgnDYAL6KN7tfp5Pn4rAUA2fdnFc
   Nh4XEChlioWMc7Sen6OgvRn72l99mJN8PKuS02j2dCwWnS+/F2VTVkhtX
   vhfyqC8Kija1tFAjvmGddFXckcJxaqbeiTuXYhG7dJeukyv7A9g60IyrO
   LVSefAGDxA3lnAxoQJ+96emG2e19mKooofloW+9VZRQWzaOrEGo7f7gPx
   TOXtO4x8yJkvMzWLSqg41CEpUNoI5DzKs4AUovLaHxU/b2pc+f2EUqW4M
   A==;
X-CSE-ConnectionGUID: TKOgqJFUQ7+cvKtq/qjNpg==
X-CSE-MsgGUID: tWUzfKT2TPy7QuL7Qb/4Ug==
X-IronPort-AV: E=McAfee;i="6700,10204,11339"; a="50312565"
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="50312565"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:23:31 -0800
X-CSE-ConnectionGUID: v2Ot9oAfROCqwxs+EmNasg==
X-CSE-MsgGUID: Wsy0e8DPQCWbVxfTwinMrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,271,1732608000"; 
   d="scan'208";a="142725478"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.139])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2025 17:23:30 -0800
Date: Sat, 8 Feb 2025 17:23:28 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Li Zhijian <lizhijian@fujitsu.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] test/security.sh: add missing jq requirement check
Message-ID: <Z6gDkJoNMv0kEguv@aschofie-mobl2.lan>
References: <20241014064951.1221095-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014064951.1221095-1-lizhijian@fujitsu.com>

On Mon, Oct 14, 2024 at 02:49:51PM +0800, Li Zhijian wrote:
> Add jd requirement check explicitly like others so that the test can
> be skipped when no jd is installed.
> 
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> ---

Thanks! Applied to https://github.com/pmem/ndctl/commits/pending/

snip

