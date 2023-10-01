Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A911237D;
	Sun,  1 Oct 2023 01:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696124657; x=1727660657;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rufpvWuPso4MC3Gr1PDC2UlAGt/OUfuMBlXcYFtgG94=;
  b=AlZAmNUvPyEsdURzY+tQbKq1YY1Zhuhfs7+vVon4tuVSiUnjOwlBHTJN
   GjuM+N2ZfK6BjIT5JBE9VKLXGUgUb8xC5G2kNATNGtjw0wjQPYRAI2yX7
   HigRunJAv/eTw5RFti1tH7knRCEq1LlbPUvz8ET88MiDjaaJ4oPfo8uVH
   EaA2xrnqzvrQfSG1TpWcBMfyGK6xteCLtL2wS+VvXayWgSOWgT4LmGAQd
   PMr8EHX9arkXx0m7k6/wpW5R/DtCdFhb7vcbZEVMVMqiK19ZhiIBJP2nL
   9GQ7rOE61i9yflxKkldYM3/T9da2COip4iqqM3STyQL3eektDMmKQiwII
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="362749424"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="362749424"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2023 18:44:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="726926433"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="726926433"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2023 18:44:12 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qmlVA-0004eZ-2u;
	Sun, 01 Oct 2023 01:44:09 +0000
Date: Sun, 1 Oct 2023 09:43:41 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	akpm@linux-foundation.org, djwong@kernel.org, mcgrof@kernel.org,
	chandanbabu@kernel.org
Subject: Re: [PATCH v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
Message-ID: <202310010955.feI4HCwZ-lkp@intel.com>
References: <20230928103227.250550-1-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928103227.250550-1-ruansy.fnst@fujitsu.com>

Hi Shiyang,

kernel test robot noticed the following build errors:



url:    https://github.com/intel-lab-lkp/linux/commits/UPDATE-20230928-183310/Shiyang-Ruan/xfs-fix-the-calculation-for-end-and-length/20230629-161913
base:   the 2th patch of https://lore.kernel.org/r/20230629081651.253626-3-ruansy.fnst%40fujitsu.com
patch link:    https://lore.kernel.org/r/20230928103227.250550-1-ruansy.fnst%40fujitsu.com
patch subject: [PATCH v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231001/202310010955.feI4HCwZ-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231001/202310010955.feI4HCwZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310010955.feI4HCwZ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/xfs/xfs_notify_failure.c:127:27: error: use of undeclared identifier 'FREEZE_HOLDER_KERNEL'
           error = freeze_super(sb, FREEZE_HOLDER_KERNEL);
                                    ^
   fs/xfs/xfs_notify_failure.c:143:26: error: use of undeclared identifier 'FREEZE_HOLDER_KERNEL'
                   error = thaw_super(sb, FREEZE_HOLDER_KERNEL);
                                          ^
>> fs/xfs/xfs_notify_failure.c:153:17: error: use of undeclared identifier 'FREEZE_HOLDER_USERSPACE'
           thaw_super(sb, FREEZE_HOLDER_USERSPACE);
                          ^
   3 errors generated.


vim +/FREEZE_HOLDER_KERNEL +127 fs/xfs/xfs_notify_failure.c

   119	
   120	static int
   121	xfs_dax_notify_failure_freeze(
   122		struct xfs_mount	*mp)
   123	{
   124		struct super_block	*sb = mp->m_super;
   125		int			error;
   126	
 > 127		error = freeze_super(sb, FREEZE_HOLDER_KERNEL);
   128		if (error)
   129			xfs_emerg(mp, "already frozen by kernel, err=%d", error);
   130	
   131		return error;
   132	}
   133	
   134	static void
   135	xfs_dax_notify_failure_thaw(
   136		struct xfs_mount	*mp,
   137		bool			kernel_frozen)
   138	{
   139		struct super_block	*sb = mp->m_super;
   140		int			error;
   141	
   142		if (kernel_frozen) {
   143			error = thaw_super(sb, FREEZE_HOLDER_KERNEL);
   144			if (error)
   145				xfs_emerg(mp, "still frozen after notify failure, err=%d",
   146					error);
   147		}
   148	
   149		/*
   150		 * Also thaw userspace call anyway because the device is about to be
   151		 * removed immediately.
   152		 */
 > 153		thaw_super(sb, FREEZE_HOLDER_USERSPACE);
   154	}
   155	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
