Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id AA7E21A1E26
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 22:31:21 -0700 (PDT)
Date: Sun, 10 Jul 2016 13:30:02 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/17] libnvdimm: introduce devm_nvdimm_memremap(),
 convert nfit_spa_map() users
Message-ID: <201607101312.WRFiJKWz%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146812108537.32932.4793673688677479548.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v4.7-rc6 next-20160708]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/replace-pcommit-with-ADR-or-directed-flushing/20160710-113558
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: um-allmodconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=um 

All error/warnings (new ones prefixed by >>):

   drivers/nvdimm/core.c: In function 'alloc_nvdimm_map':
>> drivers/nvdimm/core.c:108:23: error: implicit declaration of function 'ioremap' [-Werror=implicit-function-declaration]
      nvdimm_map->iomem = ioremap(offset, size);
                          ^~~~~~~
>> drivers/nvdimm/core.c:108:21: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      nvdimm_map->iomem = ioremap(offset, size);
                        ^
   drivers/nvdimm/core.c: In function 'nvdimm_map_release':
>> drivers/nvdimm/core.c:139:3: error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
      iounmap(nvdimm_map->iomem);
      ^~~~~~~
   cc1: some warnings being treated as errors

vim +/ioremap +108 drivers/nvdimm/core.c

   102		if (!request_mem_region(offset, size, dev_name(&nvdimm_bus->dev)))
   103			goto err_request_region;
   104	
   105		if (flags)
   106			nvdimm_map->mem = memremap(offset, size, flags);
   107		else
 > 108			nvdimm_map->iomem = ioremap(offset, size);
   109	
   110		if (!nvdimm_map->mem)
   111			goto err_map;
   112	
   113		dev_WARN_ONCE(dev, !is_nvdimm_bus_locked(dev), "%s: bus unlocked!",
   114				__func__);
   115		list_add(&nvdimm_map->list, &nvdimm_bus->mapping_list);
   116	
   117		return nvdimm_map;
   118	
   119	 err_map:
   120		release_mem_region(offset, size);
   121	 err_request_region:
   122		kfree(nvdimm_map);
   123		return NULL;
   124	}
   125	
   126	static void nvdimm_map_release(struct kref *kref)
   127	{
   128		struct nvdimm_bus *nvdimm_bus;
   129		struct nvdimm_map *nvdimm_map;
   130	
   131		nvdimm_map = container_of(kref, struct nvdimm_map, kref);
   132		nvdimm_bus = nvdimm_map->nvdimm_bus;
   133	
   134		dev_dbg(&nvdimm_bus->dev, "%s: %pa\n", __func__, &nvdimm_map->offset);
   135		list_del(&nvdimm_map->list);
   136		if (nvdimm_map->flags)
   137			memunmap(nvdimm_map->mem);
   138		else
 > 139			iounmap(nvdimm_map->iomem);
   140		release_mem_region(nvdimm_map->offset, nvdimm_map->size);
   141		kfree(nvdimm_map);
   142	}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
