Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2412C1465B4;
	Wed, 24 Dec 2025 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766599083; cv=none; b=BNHjxH2atIu6n+blwkR3eaCPhbCMgzAxMSwwWfXsshNtkwTCIRhb7STYOyvWfKSr+OVKNrcxhkgz7PZlcMNheuXXuLBsk5EyWsr4SBknBaudk1em4jSOZ1LBMH4yHaV58lTQ78Nn7CZorGfc3Lc3xmqxB/RUhgzBt7Pg+zb9wo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766599083; c=relaxed/simple;
	bh=4+xJeNnVymAr63OgA+YKBzjBejm6dJnPFS7AwzRSHCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcJgZgDQQlm+136B0DcZww1O1A1xAeXVCBzdjg1A2PK/dWVoga/cODDQm05sjORscOboHbEmftNzO9W2aN42VtB1JWDEL6lXYgj5RprXaJ9pRihniLaIGZDrLKXQfsx7H80AlHWYut6nxGs2+5omMD50N76shUGVE0NKcZT/KaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HPY6zD89; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HPY6zD89"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766599081; x=1798135081;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4+xJeNnVymAr63OgA+YKBzjBejm6dJnPFS7AwzRSHCY=;
  b=HPY6zD89U0YIuBiRp3iTRHH+UmbVEhq6T9bxVeXVDr0+pi/R92y0bT6t
   nKaGCj39PVa1TJEUSoxZVptJD7qVNTQIcu15IWUPYr9zu9i+5Few+WHaH
   KypobF0d19SQquDFIrIl2hKU9pGBK+1+WJNzV4U1p5cTPE3FWRmygnYu+
   3z4U/zxUE8nt6SyrVUM5mlkhLm7+3z32f0jOjdKw6rVLgJ6AZXrik7gDz
   a5dBmNtnWIC9wfeoOkg13BLO6A0bdP2gqA8aByJNOz5LvA0w5WutyO0T8
   sQWMJK6F0+haSWjUk5Fv22WCWyJ0Ux6K3KqaSIHLKeKYPmrCubB5TXX+x
   g==;
X-CSE-ConnectionGUID: lKyJeIpBR0Kf9axpcY2FiA==
X-CSE-MsgGUID: lQBmIhrPSgyusy/EgavdDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="79065466"
X-IronPort-AV: E=Sophos;i="6.21,174,1763452800"; 
   d="scan'208";a="79065466"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 09:58:00 -0800
X-CSE-ConnectionGUID: Csd9QY/IRL6VXbIG+NIGBQ==
X-CSE-MsgGUID: gjbVb2w/R32WKJsWKPJzZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,174,1763452800"; 
   d="scan'208";a="204978080"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 24 Dec 2025 09:57:58 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vYT7U-000000003L3-0YSE;
	Wed, 24 Dec 2025 17:57:56 +0000
Date: Thu, 25 Dec 2025 01:57:09 +0800
From: kernel test robot <lkp@intel.com>
To: Li Chen <me@linux.beauty>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	virtualization@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Li Chen <me@linux.beauty>
Subject: Re: [PATCH 3/4] nvdimm: virtio_pmem: converge broken virtqueue to
 -EIO
Message-ID: <202512250116.ewtzlD0g-lkp@intel.com>
References: <20251220083441.313737-4-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220083441.313737-4-me@linux.beauty>

Hi Li,

kernel test robot noticed the following build errors:

[auto build test ERROR on nvdimm/libnvdimm-for-next]
[also build test ERROR on linus/master v6.19-rc2]
[cannot apply to nvdimm/dax-misc]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Li-Chen/nvdimm-virtio_pmem-always-wake-ENOSPC-waiters/20251220-163909
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
patch link:    https://lore.kernel.org/r/20251220083441.313737-4-me%40linux.beauty
patch subject: [PATCH 3/4] nvdimm: virtio_pmem: converge broken virtqueue to -EIO
config: riscv-randconfig-r052-20251224 (https://download.01.org/0day-ci/archive/20251225/202512250116.ewtzlD0g-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251225/202512250116.ewtzlD0g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512250116.ewtzlD0g-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "virtio_pmem_mark_broken_and_drain" [drivers/nvdimm/virtio_pmem.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
