Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id BD6211A1E4A
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 15:05:01 -0700 (PDT)
Date: Sun, 5 Jun 2016 05:49:47 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 04/13] libnvdimm, nfit: move flush hint mapping to dimm
 driver
Message-ID: <201606050542.L1fFwClE%fengguang.wu@intel.com>
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

[auto build test WARNING on v4.7-rc1]
[also build test WARNING on next-20160603]
[cannot apply to linux-nvdimm/libnvdimm-for-next tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/deprecate-pcommit/20160605-045935
config: x86_64-randconfig-s4-06050512 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   In file included from drivers/nvdimm/core.c:13:0:
>> include/linux/libnvdimm.h:78:37: warning: 'struct device' declared inside parameter list will not be visible outside of this definition or declaration
     int (*populate_flush_hints)(struct device *dev,
                                        ^~~~~~

vim +78 include/linux/libnvdimm.h

    62		 * get_ndd() + put_ndd(), all other nd_mapping to ndd
    63		 * conversions use to_ndd() which respects enabled state of the
    64		 * nvdimm.
    65		 */
    66		struct nvdimm_drvdata *ndd;
    67	};
    68	
    69	/**
    70	 * struct nvdimm_bus_descriptor - operations and attributes for an nvdimm bus
    71	 * @attr_groups: sysfs attributes for this bus
    72	 */
    73	struct nvdimm_bus_descriptor {
    74		const struct attribute_group **attr_groups;
    75		unsigned long cmd_mask;
    76		char *provider_name;
    77		ndctl_fn ndctl;
  > 78		int (*populate_flush_hints)(struct device *dev,
    79				void __iomem *flush_wpq[]);
    80		int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
    81		int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
    82				struct nvdimm *nvdimm, unsigned int cmd);
    83	};
    84	
    85	struct nd_cmd_desc {
    86		int in_num;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
