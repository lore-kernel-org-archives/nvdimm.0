Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 888AB21B02822
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 17:41:08 -0700 (PDT)
Date: Tue, 11 Sep 2018 08:40:15 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] libnvdimm, region_devs: reset related seeds when
 fail to create namespace
Message-ID: <201809110838.E3lo4lfn%fengguang.wu@intel.com>
References: <1536560508-24564-4-git-send-email-oceanhehy@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1536560508-24564-4-git-send-email-oceanhehy@gmail.com>
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
To: Ocean He <oceanhehy@gmail.com>
Cc: linux-nvdimm@lists.01.org, Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Ocean,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.19-rc3 next-20180910]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ocean-He/libnvdimm-reset-seeds-for-next-namespace-creation/20180911-005505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/nvdimm/region_devs.c:84:29: sparse: expression using sizeof(void)
   drivers/nvdimm/region_devs.c:84:29: sparse: expression using sizeof(void)
   drivers/nvdimm/region_devs.c:405:37: sparse: expression using sizeof(void)
   drivers/nvdimm/region_devs.c:405:37: sparse: expression using sizeof(void)
>> drivers/nvdimm/region_devs.c:710:6: sparse: symbol 'nd_region_detach_and_reset' was not declared. Should it be static?
   drivers/nvdimm/region_devs.c:1127:31: sparse: expression using sizeof(void)
   drivers/nvdimm/region_devs.c:985:9: sparse: context imbalance in 'nd_region_acquire_lane' - wrong count at exit
   drivers/nvdimm/region_devs.c:998:36: sparse: context imbalance in 'nd_region_release_lane' - unexpected unlock

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
