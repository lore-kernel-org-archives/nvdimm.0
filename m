Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F095980A;
	Fri, 18 Aug 2023 05:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692335795; x=1723871795;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KSXsr4mO+68lC2eSMoW/DrLlPGBbIdc0WLzY22BGDu0=;
  b=OSAIlX1m0arSiNPTiHWTbJD7Oqb/lykBgsy+Jis8Gyfs9qCtz74IKW/v
   fh8t0+BLayiK56qk9bf5lqBCUvWgcCUrW6STw9NFikIQDhlhv2AEenZ9T
   l7qb3eYgTVF4Qm4WtBBXui8CVlAW+qE+ElJpxT2WBRc1okvvbckZ6a3yV
   JLZlGH4DMxdgBRmdK/IJIGParH3BQjaIfLhuidqCkCl81kRdlr4f8e73T
   LKqcTMbHyxsTx9GBz7bFCS9QmC2+0M6joC6W+bSJjmWkYjcuFp6rXUv8W
   LpLpFuhLukGQItwzL69y2cGIfEWN1p2LSbpZy17RhfU3IT5JcKwUaebKR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="363175085"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="363175085"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 22:16:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="734962618"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="734962618"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 17 Aug 2023 22:16:26 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qWrq6-000282-35;
	Fri, 18 Aug 2023 05:16:14 +0000
Date: Fri, 18 Aug 2023 13:15:47 +0800
From: kernel test robot <lkp@intel.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm: Change calling convention for ->huge_fault
Message-ID: <202308181315.Z4HfWZsh-lkp@intel.com>
References: <20230817200150.1230317-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817200150.1230317-1-willy@infradead.org>

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Wilcox-Oracle/mm-Change-calling-convention-for-huge_fault/20230818-040348
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230817200150.1230317-1-willy%40infradead.org
patch subject: [PATCH] mm: Change calling convention for ->huge_fault
config: arc-randconfig-r043-20230818 (https://download.01.org/0day-ci/archive/20230818/202308181315.Z4HfWZsh-lkp@intel.com/config)
compiler: arceb-elf-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230818/202308181315.Z4HfWZsh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308181315.Z4HfWZsh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/io.h:1048,
                    from arch/arc/include/asm/io.h:232,
                    from include/linux/io.h:13,
                    from include/linux/irq.h:20,
                    from include/asm-generic/hardirq.h:17,
                    from ./arch/arc/include/generated/asm/hardirq.h:1,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from include/linux/kernel_stat.h:9,
                    from mm/memory.c:42:
   mm/memory.c: In function 'create_huge_pmd':
>> include/linux/pgtable.h:8:38: error: 'PTE_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
       8 | #define PMD_ORDER       (PMD_SHIFT - PTE_SHIFT)
         |                                      ^~~~~~~~~
   mm/memory.c:4876:53: note: in expansion of macro 'PMD_ORDER'
    4876 |                 return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
         |                                                     ^~~~~~~~~
   include/linux/pgtable.h:8:38: note: each undeclared identifier is reported only once for each function it appears in
       8 | #define PMD_ORDER       (PMD_SHIFT - PTE_SHIFT)
         |                                      ^~~~~~~~~
   mm/memory.c:4876:53: note: in expansion of macro 'PMD_ORDER'
    4876 |                 return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
         |                                                     ^~~~~~~~~
   mm/memory.c: In function 'wp_huge_pmd':
>> include/linux/pgtable.h:8:38: error: 'PTE_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
       8 | #define PMD_ORDER       (PMD_SHIFT - PTE_SHIFT)
         |                                      ^~~~~~~~~
   mm/memory.c:4896:60: note: in expansion of macro 'PMD_ORDER'
    4896 |                         ret = vma->vm_ops->huge_fault(vmf, PMD_ORDER);
         |                                                            ^~~~~~~~~


vim +8 include/linux/pgtable.h

     7	
   > 8	#define PMD_ORDER	(PMD_SHIFT - PTE_SHIFT)
     9	#define PUD_ORDER	(PUD_SHIFT - PTE_SHIFT)
    10	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
