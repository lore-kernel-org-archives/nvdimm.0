Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF6E1AA78E;
	Mon, 25 Nov 2024 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541293; cv=none; b=gdnTDf4KetryyzwhRyoXgFJTrlME6hyZDCGaNgC0TXyZa3j4cJkR/zdO6DsKrD9iSXfhD7nt8+RlPUgdikVncOxlW7YqwVCv7J55c92JB7Xh1my/lNXMg30s/klMNVlSoZQK3K0mIwAwf71IKMZJHOPqptplEKq9LantNpYHcMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541293; c=relaxed/simple;
	bh=sESHCfmHmHaI8KY+ZzE7Zdm/gqTJOAtsxdweAV4cr24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lMk1XQgyvItJ0xsI49VMFJtKqh7yqIKZRwuPHAnTOMNtXe2Wc17zZBi6oeFljSolrisZ2xmt1A6+fJHDKxTT7sVUF3WN+YXuF589x/WidlSIWpM+2lVeXb2js/vkpGqd5u5ipQNXK+rhUpvqEWio+/tb5k0L3wZiC602LWrK020=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FYVYYmyX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FYVYYmyX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732541291; x=1764077291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sESHCfmHmHaI8KY+ZzE7Zdm/gqTJOAtsxdweAV4cr24=;
  b=FYVYYmyXzzHVWXXM7D1ICtDLK66t3p2D71xlucFA2hV8w+Byrt4PrFRO
   sO2WsD9k4deEqOtutAVh86S7r7h0N7cv9fUCmMDAxXnhWqLnj0LHWnTd9
   GDrKPPZ8ijwVAO8mNuToGJHGkgNCIPtquBo+d2A5LkTnyqMXw1Mfoh8jY
   ExZdaf4XOUICL8BYtDzZbC4rW3zuAopn9Pk1ByARgEP5OVEtWvZT+4vFK
   l1LHRHho9QdNI3w2sbBVjoq+StntlcyomyRkzIPPekG/THYjr2YDYyp9r
   yTa1C+e7AzUlIknzab5fkX8UPH3jIz3YFGvSWdjUt+cyvNEx1nzO0S6nz
   A==;
X-CSE-ConnectionGUID: NScU2TEmQ2+FjRhaaHDSBg==
X-CSE-MsgGUID: Gx0x4BDqTqmstQlzRJP97Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="55151961"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="55151961"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 05:28:10 -0800
X-CSE-ConnectionGUID: EKBxTmvNRvKCf6ayHaqmfQ==
X-CSE-MsgGUID: s4BsTlWTRJ2gm3aQ0d27lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91732760"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 25 Nov 2024 05:28:03 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFZ8C-0006Qj-2o;
	Mon, 25 Nov 2024 13:28:00 +0000
Date: Mon, 25 Nov 2024 21:27:27 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>, dan.j.williams@intel.com,
	linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>, lina@asahilina.net,
	zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
	bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca,
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au,
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v3 05/25] fs/dax: Create a common implementation to break
 DAX layouts
Message-ID: <202411252137.GpJ4mLOe-lkp@intel.com>
References: <31b18e4f813bf9e661d5d98d928c79556c8c2c57.1732239628.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31b18e4f813bf9e661d5d98d928c79556c8c2c57.1732239628.git-series.apopple@nvidia.com>

Hi Alistair,

kernel test robot noticed the following build errors:

[auto build test ERROR on 81983758430957d9a5cb3333fe324fd70cf63e7e]

url:    https://github.com/intel-lab-lkp/linux/commits/Alistair-Popple/fuse-Fix-dax-truncate-punch_hole-fault-path/20241125-094004
base:   81983758430957d9a5cb3333fe324fd70cf63e7e
patch link:    https://lore.kernel.org/r/31b18e4f813bf9e661d5d98d928c79556c8c2c57.1732239628.git-series.apopple%40nvidia.com
patch subject: [PATCH v3 05/25] fs/dax: Create a common implementation to break DAX layouts
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241125/202411252137.GpJ4mLOe-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241125/202411252137.GpJ4mLOe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411252137.GpJ4mLOe-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "dax_break_mapping" [fs/xfs/xfs.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
