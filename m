Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661D14A83;
	Sun, 27 Feb 2022 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645977460; x=1677513460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uZVNRO0qfhvL5YBVwTKw1rTCJwkow3/0UaHUBIhgeNU=;
  b=R/sTjaU4nao55nvyZ9Gpe5XuZD2kXNyWNklRfMOkgrXwLVrVy3h0Ykr/
   PHYY1sDYevagtXK6mfDVYsqRO2MR2Ba1mCouUTwplC5DRvdFChQKYxH4B
   bfbPwwDaIVEJMreWfEBS9VKAOx9Fx1GqsTUlr+ROlcMgMxeLA1rRRyEBs
   Zls94BcMYCbxOr19BZUjUMUnPJXGHhq1kmMODHQaMUV0JLsJXuCvVck78
   7icC502il0hXM+rKnMdp7Gi8hQaTSfrPDQEFun8bNhyah5Z/lA3DH7yD1
   f/XohKvUehmmZ5G/wmghGvn0mP9cV7XeAX/lNyCWqAJjps7Fwz8ZutOk6
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="236250292"
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="236250292"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 07:57:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,141,1643702400"; 
   d="scan'208";a="777852020"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2022 07:57:36 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nOLvT-0006bd-Qq; Sun, 27 Feb 2022 15:57:35 +0000
Date: Sun, 27 Feb 2022 23:57:18 +0800
From: kernel test robot <lkp@intel.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v11 8/8] fsdax: set a CoW flag when associate reflink
 mappings
Message-ID: <202202272359.2aizNPgB-lkp@intel.com>
References: <20220227120747.711169-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227120747.711169-9-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Shiyang,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on xfs-linux/for-next]
[also build test WARNING on linux/master]
[cannot apply to hnaz-mm/master linus/master v5.17-rc5 next-20220225]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
base:   https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220227/202202272359.2aizNPgB-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/a0ac78065bbb4fbb3e5477c32686eca3b9f0e1ef
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Shiyang-Ruan/fsdax-introduce-fs-query-to-support-reflink/20220227-200849
        git checkout a0ac78065bbb4fbb3e5477c32686eca3b9f0e1ef
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/dax.c:337:67: warning: parameter 'mapping' set but not used [-Wunused-but-set-parameter]
   static inline void dax_mapping_set_cow_flag(struct address_space *mapping)
                                                                     ^
   1 warning generated.


vim +/mapping +337 fs/dax.c

   328	
   329	/*
   330	 * Iterate through all mapped pfns represented by an entry, i.e. skip
   331	 * 'empty' and 'zero' entries.
   332	 */
   333	#define for_each_mapped_pfn(entry, pfn) \
   334		for (pfn = dax_to_pfn(entry); \
   335				pfn < dax_end_pfn(entry); pfn++)
   336	
 > 337	static inline void dax_mapping_set_cow_flag(struct address_space *mapping)
   338	{
   339		mapping = (struct address_space *)PAGE_MAPPING_DAX_COW;
   340	}
   341	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
