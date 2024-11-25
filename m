Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DC218C345;
	Mon, 25 Nov 2024 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732549951; cv=none; b=JC328Ax/esNOo0r1Wxlb7NS+Im4d6sgSJrVvumJ/EHgItUAEgdG7PO5kSyZV9lp7V0+q1rAY+89Ep9vrR9OF7itoUrOHFdk7pHH49NQNSk4lzmy9/e5oj1y8iXrky1zHGZxWr29ivRF/HxpCieQYqM9Vw+p2YPKZ3ugG2n/WZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732549951; c=relaxed/simple;
	bh=44XADmBY7482aBrna1Gf1jtuO1UMXA5lIwwU6HOjwtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahYIyEHtd1PGCoRlE9dFErEtl4b7DjJgQz6Aj/ixU95DdX3QFJl7PKDvP2qTPivh7a8YwSPwsFxA6fZaSiI+Rom7Gd0yo4HEoAx9M9uTEMcR+atoU1slTUPtR2p+oUbrRUXkgJords01s7Ekvx9MHY/R2GtB7kaxnSI/xXO66uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2d/PjUM; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2d/PjUM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732549950; x=1764085950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=44XADmBY7482aBrna1Gf1jtuO1UMXA5lIwwU6HOjwtg=;
  b=I2d/PjUMica6c6Sfs1vztxpWK9GibK3L4RqGusuQBkeDCrRGtOxt1z3F
   pNRMJN/AYI/lMVMgCih3GI5tiqkLXP4/8JR07uL00mPScwPm8mcGc6JVY
   JnaIWMOF7hHyIywagHqNF2DMvuRQp1FPecfUsNncWsOKmHkWhSxynpyc1
   sBLmTNi+PTs+63BPf39BZZcEjkGgI8mcI9gbwVB4KbmwdjzV8C4dUQUpy
   NNviqZ4ns3HWHr+Ng7bc4v4SaZpvJfgNIAXOpkNjRypKzjj/6VdqCF1Ru
   ikxYqQsHJhffWZSjlCoTuY0h+4/rDZHRBwnsQsNwzbpzh5nUFHaLm5An7
   Q==;
X-CSE-ConnectionGUID: mnlHPRxdS1uNo3FjktlTrQ==
X-CSE-MsgGUID: ujDoUJRyTwKFUlHfizybAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="36446801"
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="36446801"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 07:52:14 -0800
X-CSE-ConnectionGUID: 23u/Xv/eTCemOL/ogk5O2w==
X-CSE-MsgGUID: F2vfipoVSsmBDXbO0I+SIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,183,1728975600"; 
   d="scan'208";a="128823369"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 25 Nov 2024 07:52:07 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFbNc-0006ZF-1m;
	Mon, 25 Nov 2024 15:52:04 +0000
Date: Mon, 25 Nov 2024 23:51:56 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>, dan.j.williams@intel.com,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Alistair Popple <apopple@nvidia.com>,
	lina@asahilina.net, zhang.lyra@gmail.com,
	gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v3 11/25] mm: Allow compound zone device pages
Message-ID: <202411252342.LUEKRmrY-lkp@intel.com>
References: <f1a93b8a38e14e2ab279ece310175334e973b970.1732239628.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1a93b8a38e14e2ab279ece310175334e973b970.1732239628.git-series.apopple@nvidia.com>

Hi Alistair,

kernel test robot noticed the following build errors:

[auto build test ERROR on 81983758430957d9a5cb3333fe324fd70cf63e7e]

url:    https://github.com/intel-lab-lkp/linux/commits/Alistair-Popple/fuse-Fix-dax-truncate-punch_hole-fault-path/20241125-094004
base:   81983758430957d9a5cb3333fe324fd70cf63e7e
patch link:    https://lore.kernel.org/r/f1a93b8a38e14e2ab279ece310175334e973b970.1732239628.git-series.apopple%40nvidia.com
patch subject: [PATCH v3 11/25] mm: Allow compound zone device pages
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20241125/202411252342.LUEKRmrY-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241125/202411252342.LUEKRmrY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411252342.LUEKRmrY-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm.h:32,
                    from arch/sh/kernel/asm-offsets.c:14:
   include/linux/memremap.h: In function 'is_device_private_page':
>> include/linux/memremap.h:164:17: error: implicit declaration of function 'page_pgmap' [-Wimplicit-function-declaration]
     164 |                 page_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
         |                 ^~~~~~~~~~
>> include/linux/memremap.h:164:33: error: invalid type argument of '->' (have 'int')
     164 |                 page_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
         |                                 ^~
   include/linux/memremap.h: In function 'is_pci_p2pdma_page':
   include/linux/memremap.h:176:33: error: invalid type argument of '->' (have 'int')
     176 |                 page_pgmap(page)->type == MEMORY_DEVICE_PCI_P2PDMA;
         |                                 ^~
   include/linux/memremap.h: In function 'is_device_coherent_page':
   include/linux/memremap.h:182:33: error: invalid type argument of '->' (have 'int')
     182 |                 page_pgmap(page)->type == MEMORY_DEVICE_COHERENT;
         |                                 ^~
   make[3]: *** [scripts/Makefile.build:102: arch/sh/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1203: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:224: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:224: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/page_pgmap +164 include/linux/memremap.h

   159	
   160	static inline bool is_device_private_page(const struct page *page)
   161	{
   162		return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
   163			is_zone_device_page(page) &&
 > 164			page_pgmap(page)->type == MEMORY_DEVICE_PRIVATE;
   165	}
   166	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
