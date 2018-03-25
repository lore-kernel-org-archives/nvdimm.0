Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6B602202E4A1
 for <linux-nvdimm@lists.01.org>; Sat, 24 Mar 2018 19:45:10 -0700 (PDT)
Date: Sun, 25 Mar 2018 10:51:02 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/6] libnvdimm: Add device-tree based driver
Message-ID: <201803251052.dEMfON8K%fengguang.wu@intel.com>
References: <20180323081209.31387-3-oohall@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180323081209.31387-3-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Oliver,

I love your patch! Yet something to improve:

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on v4.16-rc6 next-20180323]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Oliver-O-Halloran/libnvdimm-Add-of_node-to-region-and-bus-descriptors/20180325-082036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: ia64-allmodconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=ia64 

All errors (new ones prefixed by >>):

   ERROR: "ia64_delay_loop" [drivers/spi/spi-thunderx.ko] undefined!
>> ERROR: "of_node_to_nid" [drivers/nvdimm/of_nvdimm.ko] undefined!
   ERROR: "ia64_delay_loop" [drivers/net/phy/mdio-cavium.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
