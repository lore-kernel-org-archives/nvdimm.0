Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 8B17B1A1E48
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 14:43:40 -0700 (PDT)
Date: Sun, 5 Jun 2016 05:29:37 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 04/13] libnvdimm, nfit: move flush hint mapping to dimm
 driver
Message-ID: <201606050545.nJMattus%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test ERROR on v4.7-rc1]
[also build test ERROR on next-20160603]
[cannot apply to linux-nvdimm/libnvdimm-for-next tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/deprecate-pcommit/20160605-045935
config: x86_64-randconfig-x018-201623 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   In file included from drivers/acpi/nfit.c:14:0:
   include/linux/libnvdimm.h:78:37: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*populate_flush_hints)(struct device *dev,
                                        ^~~~~~
   drivers/acpi/nfit.c: In function 'acpi_nfit_desc_init':
>> drivers/acpi/nfit.c:2528:32: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
     nd_desc->populate_flush_hints = acpi_nfit_populate_flush_hints;
                                   ^
   cc1: some warnings being treated as errors

vim +2528 drivers/acpi/nfit.c

  2522		dev_set_drvdata(dev, acpi_desc);
  2523		acpi_desc->dev = dev;
  2524		acpi_desc->blk_do_io = acpi_nfit_blk_region_do_io;
  2525		nd_desc = &acpi_desc->nd_desc;
  2526		nd_desc->provider_name = "ACPI.NFIT";
  2527		nd_desc->ndctl = acpi_nfit_ctl;
> 2528		nd_desc->populate_flush_hints = acpi_nfit_populate_flush_hints;
  2529		nd_desc->flush_probe = acpi_nfit_flush_probe;
  2530		nd_desc->clear_to_send = acpi_nfit_clear_to_send;
  2531		nd_desc->attr_groups = acpi_nfit_attribute_groups;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
