Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F5622301;
	Wed, 20 May 2026 00:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779236203; cv=none; b=MWzueSAWg0rjqB1p71hJ3uQXK0K1HvaMITe+JaDEmJpGsyJzdrNTyBiozaTU8bLRxfToMMANVu3FNgqWKbQPDzdZ/x0LUrA7OYIJPm7kDbHSnNbEvojXbFJHi/ccTO0JI0fhR+hVNyuODvxwvUhLa+Seoaolak/9TvsYNHm9yYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779236203; c=relaxed/simple;
	bh=w7RBP96nRWYOGqYoERLkJUShFXLZ/M6Eppo+pwPrjLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwVHOzEiCaL0Eu8RMNY97nQ8dI4uQtTnrvQg/vFpAqntPSDwnJxtRRoBj1xv7UuGuo6rO/WOWSXJOiylGiZpqmT/ml1b64l8YuJTOA64B5HrpTBwi1YpZ6sfuG2EDGbCCUHMFBLgeyr2NSHTg9oelnG3Kb5d7tXbanqx1Gtb0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B0poVo75; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B0poVo75"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779236201; x=1810772201;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w7RBP96nRWYOGqYoERLkJUShFXLZ/M6Eppo+pwPrjLk=;
  b=B0poVo75CgooWjURwAyi/Pd73rh6farKLtQV6oKtC46rjGqEumDQt6H6
   UBSapU7dCo9qpaKdLmO7TSuksMEpnCJ1kos7kRAJvdYDybZSW0Cg2eQRV
   Om4rzFFVlZMe7D36Hi3J9uMVpfK6VOdWRRrkFlFano23N/dvH2DSjz+7Z
   3boLdMzTK/VFLRSyBkON9qCfACcEFdijMWdoaBjr7a9wGGTrKRNAi6d+y
   Zd0LyDzw8QDySr+8XGGOBCYdCGoscKA5z29rKKUtaifIPubyY3oeZ8dG4
   VuSwOIWIaM0IeijDbjI3vQmfO5tHngMrITjhaAZmFVU+CRq7Fe+TZtsOI
   g==;
X-CSE-ConnectionGUID: E0x2SNmOR6KQUDRm8e0aHw==
X-CSE-MsgGUID: wxG5s1QVR4aApSeCFez/WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="80302916"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="80302916"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 17:16:41 -0700
X-CSE-ConnectionGUID: eDwo1XdBQqa614Dyh/TYYg==
X-CSE-MsgGUID: ih7Bc0wtRLGkE/VWgfshrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="233575452"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 19 May 2026 17:16:38 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPUbT-000000002Cb-1AKT;
	Wed, 20 May 2026 00:16:10 +0000
Date: Wed, 20 May 2026 08:14:43 +0800
From: kernel test robot <lkp@intel.com>
To: Tomasz Wolski <tomasz.wolski@fujitsu.com>,
	smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com
Cc: oe-kbuild-all@lists.linux.dev, icheng@nvidia.com,
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	nvdimm@lists.linux.dev, ardb@kernel.org, benjamin.cheatham@amd.com,
	dave.jiang@intel.com, jonathan.cameron@huawei.com,
	Tomasz Wolski <tomasz.wolski@fujitsu.com>
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <202605200842.i0s39151-lkp@intel.com>
References: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>

Hi Tomasz,

kernel test robot noticed the following build errors:

[auto build test ERROR on cxl/next]
[also build test ERROR on linus/master v7.1-rc4 next-20260519]
[cannot apply to cxl/pending]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tomasz-Wolski/dax-bus-Upgrade-resource-conflict-message-to-dev_err-in-alloc_dax_region/20260519-182401
base:   https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git next
patch link:    https://lore.kernel.org/r/20260519101832.31988-1-tomasz.wolski%40fujitsu.com
patch subject: [PATCH v2] dax/bus: Upgrade resource conflict message to dev_err() in alloc_dax_region()
config: s390-randconfig-r072-20260520 (https://download.01.org/0day-ci/archive/20260520/202605200842.i0s39151-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 9.5.0
smatch: v0.5.0-9185-gbcc58b9c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200842.i0s39151-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605200842.i0s39151-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "request_resource_conflict" [drivers/dax/dax.ko] undefined!

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
