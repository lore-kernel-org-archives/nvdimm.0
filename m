Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33D7D203B8CFF
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 20:31:45 -0700 (PDT)
Date: Thu, 5 Jul 2018 11:31:08 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v5 07/11] filesystem-dax: Introduce
 dax_lock_mapping_entry()
Message-ID: <201807050930.1WGGXKLa%fengguang.wu@intel.com>
References: <153074046078.27838.5465590228767136915.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <153074046078.27838.5465590228767136915.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.18-rc3]
[cannot apply to next-20180704]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/device-dax-Convert-to-vmf_insert_mixed-and-vm_fault_t/20180705-075150
config: openrisc-or1ksim_defconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/mempolicy.h:11:0,
                    from init/main.c:56:
   include/linux/dax.h: In function 'dax_lock_mapping_entry':
   include/linux/dax.h:128:15: error: 'page' redeclared as different kind of symbol
     struct page *page = pfn_to_page(pfn);
                  ^~~~
   include/linux/dax.h:126:56: note: previous definition of 'page' was here
    static inline bool dax_lock_mapping_entry(struct page *page)
                                                           ^~~~
   In file included from arch/openrisc/include/asm/page.h:98:0,
                    from arch/openrisc/include/asm/processor.h:23,
                    from arch/openrisc/include/asm/thread_info.h:26,
                    from include/linux/thread_info.h:38,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/openrisc/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:81,
                    from include/linux/spinlock.h:51,
                    from include/linux/seqlock.h:36,
                    from include/linux/time.h:6,
                    from include/linux/stat.h:19,
                    from include/linux/module.h:10,
                    from init/main.c:16:
>> include/linux/dax.h:128:34: error: 'pfn' undeclared (first use in this function)
     struct page *page = pfn_to_page(pfn);
                                     ^
   include/asm-generic/memory_model.h:33:41: note: in definition of macro '__pfn_to_page'
    #define __pfn_to_page(pfn) (mem_map + ((pfn) - ARCH_PFN_OFFSET))
                                            ^~~
>> include/linux/dax.h:128:22: note: in expansion of macro 'pfn_to_page'
     struct page *page = pfn_to_page(pfn);
                         ^~~~~~~~~~~
   include/linux/dax.h:128:34: note: each undeclared identifier is reported only once for each function it appears in
     struct page *page = pfn_to_page(pfn);
                                     ^
   include/asm-generic/memory_model.h:33:41: note: in definition of macro '__pfn_to_page'
    #define __pfn_to_page(pfn) (mem_map + ((pfn) - ARCH_PFN_OFFSET))
                                            ^~~
>> include/linux/dax.h:128:22: note: in expansion of macro 'pfn_to_page'
     struct page *page = pfn_to_page(pfn);
                         ^~~~~~~~~~~
   In file included from include/linux/mempolicy.h:11:0,
                    from init/main.c:56:
   include/linux/dax.h: In function 'dax_lock_page':
   include/linux/dax.h:141:1: warning: no return statement in function returning non-void [-Wreturn-type]
    }
    ^

vim +/pfn +128 include/linux/dax.h

   124	
   125	
   126	static inline bool dax_lock_mapping_entry(struct page *page)
   127	{
 > 128		struct page *page = pfn_to_page(pfn);
   129	
   130		if (IS_DAX(page->mapping->host))
   131			return true;
   132		return false;
   133	}
   134	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
