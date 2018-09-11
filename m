Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BD4D21125476
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 00:55:59 -0700 (PDT)
Date: Tue, 11 Sep 2018 15:54:29 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <201809111526.rtKfFYhJ%fengguang.wu@intel.com>
References: <20180910234354.4068.65260.stgit@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <20180910234354.4068.65260.stgit@localhost.localdomain>
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
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, kbuild-all@01.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Alexander,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.19-rc3]
[cannot apply to next-20180910]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Alexander-Duyck/Address-issues-slowing-persistent-memory-initialization/20180911-144536
config: openrisc-or1ksim_defconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All errors (new ones prefixed by >>):

   mm/page_alloc.c: In function 'memmap_init_zone':
>> mm/page_alloc.c:5566:21: error: 'ZONE_DEVICE' undeclared (first use in this function)
     } else if (zone == ZONE_DEVICE) {
                        ^~~~~~~~~~~
   mm/page_alloc.c:5566:21: note: each undeclared identifier is reported only once for each function it appears in

vim +/ZONE_DEVICE +5566 mm/page_alloc.c

  5551	
  5552		if (highest_memmap_pfn < end_pfn - 1)
  5553			highest_memmap_pfn = end_pfn - 1;
  5554	
  5555		/*
  5556		 * Honor reservation requested by the driver for this ZONE_DEVICE
  5557		 * memory. We limit the total number of pages to initialize to just
  5558		 * those that might contain the memory mapping. We will defer the
  5559		 * ZONE_DEVICE page initialization until after we have released
  5560		 * the hotplug lock.
  5561		 */
  5562		if (altmap && start_pfn == altmap->base_pfn) {
  5563			start_pfn += altmap->reserve;
  5564			end_pfn = altmap->base_pfn +
  5565				  vmem_altmap_offset(altmap);
> 5566		} else if (zone == ZONE_DEVICE) {
  5567			end_pfn = start_pfn;
  5568		}
  5569	
  5570		for (pfn = start_pfn; pfn < end_pfn; pfn++) {
  5571			/*
  5572			 * There can be holes in boot-time mem_map[]s handed to this
  5573			 * function.  They do not exist on hotplugged memory.
  5574			 */
  5575			if (context != MEMMAP_EARLY)
  5576				goto not_early;
  5577	
  5578			if (!early_pfn_valid(pfn))
  5579				continue;
  5580			if (!early_pfn_in_nid(pfn, nid))
  5581				continue;
  5582			if (!update_defer_init(pgdat, pfn, end_pfn, &nr_initialised))
  5583				break;
  5584	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
