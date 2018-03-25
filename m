Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B14B223E0B96
 for <linux-nvdimm@lists.01.org>; Sat, 24 Mar 2018 21:21:25 -0700 (PDT)
Date: Sun, 25 Mar 2018 12:27:52 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/6] libnvdimm: Add device-tree based driver
Message-ID: <201803251241.H0O3ZUaT%fengguang.wu@intel.com>
References: <20180323081209.31387-3-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180323081209.31387-3-oohall@gmail.com>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.16-rc6 next-20180323]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Oliver-O-Halloran/libnvdimm-Add-of_node-to-region-and-bus-descriptors/20180325-082036
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/nvdimm/of_nvdimm.c:18:30: sparse: symbol 'bus_desc' was not declared. Should it be static?
   drivers/nvdimm/of_nvdimm.c:19:19: sparse: symbol 'bus' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
