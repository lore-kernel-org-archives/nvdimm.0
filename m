Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8AFE21D18257
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 23:01:06 -0700 (PDT)
Date: Tue, 15 Aug 2017 14:02:54 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/3] libnvdimm, pfn, dax: show supported dax/pfn region
 alignments in sysfs
Message-ID: <201708151333.nLya1R9C%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150251474784.11236.9077158081550562491.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Oliver,

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v4.13-rc5 next-20170811]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/libnvdimm-export-supported-page-size-alignments/20170815-105258
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: powerpc-allmodconfig (attached as .config)
compiler: powerpc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=powerpc 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/mm.h:446:0,
                    from include/linux/memremap.h:3,
                    from drivers//nvdimm/pfn_devs.c:13:
   drivers//nvdimm/pfn_devs.c: In function 'nd_pfn_supported_alignments':
>> include/linux/huge_mm.h:83:24: error: initializer element is not constant
    #define HPAGE_PMD_SIZE ((1UL) << HPAGE_PMD_SHIFT)
                           ^
>> drivers//nvdimm/pfn_devs.c:123:3: note: in expansion of macro 'HPAGE_PMD_SIZE'
      HPAGE_PMD_SIZE,
      ^~~~~~~~~~~~~~
   include/linux/huge_mm.h:83:24: note: (near initialization for 'supported_alignments[1]')
    #define HPAGE_PMD_SIZE ((1UL) << HPAGE_PMD_SHIFT)
                           ^
>> drivers//nvdimm/pfn_devs.c:123:3: note: in expansion of macro 'HPAGE_PMD_SIZE'
      HPAGE_PMD_SIZE,
      ^~~~~~~~~~~~~~
--
   In file included from include/linux/mm.h:446:0,
                    from include/linux/memremap.h:3,
                    from drivers/nvdimm/pfn_devs.c:13:
   drivers/nvdimm/pfn_devs.c: In function 'nd_pfn_supported_alignments':
>> include/linux/huge_mm.h:83:24: error: initializer element is not constant
    #define HPAGE_PMD_SIZE ((1UL) << HPAGE_PMD_SHIFT)
                           ^
   drivers/nvdimm/pfn_devs.c:123:3: note: in expansion of macro 'HPAGE_PMD_SIZE'
      HPAGE_PMD_SIZE,
      ^~~~~~~~~~~~~~
   include/linux/huge_mm.h:83:24: note: (near initialization for 'supported_alignments[1]')
    #define HPAGE_PMD_SIZE ((1UL) << HPAGE_PMD_SHIFT)
                           ^
   drivers/nvdimm/pfn_devs.c:123:3: note: in expansion of macro 'HPAGE_PMD_SIZE'
      HPAGE_PMD_SIZE,
      ^~~~~~~~~~~~~~

vim +/HPAGE_PMD_SIZE +123 drivers//nvdimm/pfn_devs.c

  > 13	#include <linux/memremap.h>
    14	#include <linux/blkdev.h>
    15	#include <linux/device.h>
    16	#include <linux/genhd.h>
    17	#include <linux/sizes.h>
    18	#include <linux/slab.h>
    19	#include <linux/fs.h>
    20	#include <linux/mm.h>
    21	#include "nd-core.h"
    22	#include "pfn.h"
    23	#include "nd.h"
    24	
    25	static void nd_pfn_release(struct device *dev)
    26	{
    27		struct nd_region *nd_region = to_nd_region(dev->parent);
    28		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
    29	
    30		dev_dbg(dev, "%s\n", __func__);
    31		nd_detach_ndns(&nd_pfn->dev, &nd_pfn->ndns);
    32		ida_simple_remove(&nd_region->pfn_ida, nd_pfn->id);
    33		kfree(nd_pfn->uuid);
    34		kfree(nd_pfn);
    35	}
    36	
    37	static struct device_type nd_pfn_device_type = {
    38		.name = "nd_pfn",
    39		.release = nd_pfn_release,
    40	};
    41	
    42	bool is_nd_pfn(struct device *dev)
    43	{
    44		return dev ? dev->type == &nd_pfn_device_type : false;
    45	}
    46	EXPORT_SYMBOL(is_nd_pfn);
    47	
    48	struct nd_pfn *to_nd_pfn(struct device *dev)
    49	{
    50		struct nd_pfn *nd_pfn = container_of(dev, struct nd_pfn, dev);
    51	
    52		WARN_ON(!is_nd_pfn(dev));
    53		return nd_pfn;
    54	}
    55	EXPORT_SYMBOL(to_nd_pfn);
    56	
    57	static ssize_t mode_show(struct device *dev,
    58			struct device_attribute *attr, char *buf)
    59	{
    60		struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
    61	
    62		switch (nd_pfn->mode) {
    63		case PFN_MODE_RAM:
    64			return sprintf(buf, "ram\n");
    65		case PFN_MODE_PMEM:
    66			return sprintf(buf, "pmem\n");
    67		default:
    68			return sprintf(buf, "none\n");
    69		}
    70	}
    71	
    72	static ssize_t mode_store(struct device *dev,
    73			struct device_attribute *attr, const char *buf, size_t len)
    74	{
    75		struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
    76		ssize_t rc = 0;
    77	
    78		device_lock(dev);
    79		nvdimm_bus_lock(dev);
    80		if (dev->driver)
    81			rc = -EBUSY;
    82		else {
    83			size_t n = len - 1;
    84	
    85			if (strncmp(buf, "pmem\n", n) == 0
    86					|| strncmp(buf, "pmem", n) == 0) {
    87				nd_pfn->mode = PFN_MODE_PMEM;
    88			} else if (strncmp(buf, "ram\n", n) == 0
    89					|| strncmp(buf, "ram", n) == 0)
    90				nd_pfn->mode = PFN_MODE_RAM;
    91			else if (strncmp(buf, "none\n", n) == 0
    92					|| strncmp(buf, "none", n) == 0)
    93				nd_pfn->mode = PFN_MODE_NONE;
    94			else
    95				rc = -EINVAL;
    96		}
    97		dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
    98				rc, buf, buf[len - 1] == '\n' ? "" : "\n");
    99		nvdimm_bus_unlock(dev);
   100		device_unlock(dev);
   101	
   102		return rc ? rc : len;
   103	}
   104	static DEVICE_ATTR_RW(mode);
   105	
   106	static ssize_t align_show(struct device *dev,
   107			struct device_attribute *attr, char *buf)
   108	{
   109		struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
   110	
   111		return sprintf(buf, "%ld\n", nd_pfn->align);
   112	}
   113	
   114	static const unsigned long *nd_pfn_supported_alignments(void)
   115	{
   116		/*
   117		 * This needs to be a local variable because the *_SIZE macros
   118		 * aren't always constants.
   119		 */
   120		static const unsigned long supported_alignments[] = {
   121			PAGE_SIZE,
   122	#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 > 123			HPAGE_PMD_SIZE,
   124	#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
   125			HPAGE_PUD_SIZE,
   126	#endif
   127	#endif
   128			0,
   129		};
   130	
   131		return supported_alignments;
   132	}
   133	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
