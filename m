Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id C9F831A1E3D
 for <linux-nvdimm@lists.01.org>; Mon, 29 Feb 2016 19:16:59 -0800 (PST)
Date: Tue, 1 Mar 2016 11:16:08 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] libnvdimm, pmem: fix 'pfn' support for
 section-misaligned namespaces
Message-ID: <201603011110.fmlYKtFn%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20160301025626.12812.4840.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kbuild-all@01.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test WARNING on v4.5-rc6]
[also build test WARNING on next-20160229]
[cannot apply to linux-nvdimm/libnvdimm-for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/devm_memremap_pages-vs-section-misaligned-pmem/20160301-105936
config: i386-randconfig-x007-201609 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All warnings (new ones prefixed by >>):

   drivers/nvdimm/pmem.c: In function 'init_altmap_reserve':
>> drivers/nvdimm/pmem.c:375:16: warning: unused variable 'base_pfn' [-Wunused-variable]
     unsigned long base_pfn = __phys_to_pfn(base);
                   ^

vim +/base_pfn +375 drivers/nvdimm/pmem.c

   359	/*
   360	 * We hotplug memory at section granularity, pad the reserved area from
   361	 * the previous section base to the namespace base address.
   362	 */
   363	static unsigned long init_altmap_base(resource_size_t base)
   364	{
   365		unsigned long base_pfn = __phys_to_pfn(base);
   366	
   367	#ifdef CONFIG_SPARSEMEM
   368		base_pfn = SECTION_ALIGN_DOWN(base_pfn);
   369	#endif
   370		return base_pfn;
   371	}
   372	
   373	static unsigned long init_altmap_reserve(resource_size_t base)
   374	{
 > 375		unsigned long base_pfn = __phys_to_pfn(base);
   376		unsigned long reserve = __phys_to_pfn(SZ_8K);
   377	
   378	#ifdef CONFIG_SPARSEMEM
   379		reserve += base_pfn - SECTION_ALIGN_DOWN(base_pfn);
   380	#endif
   381		return reserve;
   382	}
   383	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
