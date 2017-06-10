Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95EE12196230D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 20:53:55 -0700 (PDT)
Date: Sat, 10 Jun 2017 11:54:37 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-fixes 10/12]
 drivers/acpi/nfit/core.c:1958:52: error: 'ARCH_MEMREMAP_PMEM' undeclared
Message-ID: <201706101115.Vd9qXEBd%fengguang.wu@intel.com>
MIME-Version: 1.0
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
Cc: kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-fixes
head:   1fc421163dc84697fa48bdd397580b3ffeca512c
commit: b27db65a069bc14e8739e05278e2b95ee2523e47 [10/12] pmem: remove global pmem api
config: i386-randconfig-x071-06041529 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        git checkout b27db65a069bc14e8739e05278e2b95ee2523e47
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/acpi/nfit/core.c: In function 'acpi_nfit_blk_region_enable':
>> drivers/acpi/nfit/core.c:1958:52: error: 'ARCH_MEMREMAP_PMEM' undeclared (first use in this function)
                            nfit_mem->spa_bdw->length, ARCH_MEMREMAP_PMEM);
                                                       ^~~~~~~~~~~~~~~~~~
   drivers/acpi/nfit/core.c:1958:52: note: each undeclared identifier is reported only once for each function it appears in

vim +/ARCH_MEMREMAP_PMEM +1958 drivers/acpi/nfit/core.c

047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1952  	nfit_blk->nd_region = to_nd_region(dev);
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1953  
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1954  	/* map block aperture memory */
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1955  	nfit_blk->bdw_offset = nfit_mem->bdw->offset;
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1956  	mmio = &nfit_blk->mmio[BDW];
29b9aa0a drivers/acpi/nfit.c Dan Williams 2016-06-06  1957  	mmio->addr.base = devm_nvdimm_memremap(dev, nfit_mem->spa_bdw->address,
29b9aa0a drivers/acpi/nfit.c Dan Williams 2016-06-06 @1958                          nfit_mem->spa_bdw->length, ARCH_MEMREMAP_PMEM);
67a3e8fe drivers/acpi/nfit.c Ross Zwisler 2015-08-27  1959  	if (!mmio->addr.base) {
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1960  		dev_dbg(dev, "%s: %s failed to map bdw\n", __func__,
047fc8a1 drivers/acpi/nfit.c Ross Zwisler 2015-06-25  1961  				nvdimm_name(nvdimm));

:::::: The code at line 1958 was first introduced by commit
:::::: 29b9aa0aa3837c93ecd804dd3ada39b8cc75607d libnvdimm: introduce devm_nvdimm_memremap(), convert nfit_spa_map() users

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
