Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFB3D21D2DCF6
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 18:40:44 -0700 (PDT)
Date: Wed, 2 Aug 2017 09:40:26 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] dm: enable opt-out of device-mapper dax support
Message-ID: <201708020927.f9cVCYCl%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: snitzer@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.13-rc3 next-20170801]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dm-enable-opt-out-of-device-mapper-dax-support/20170802-063827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: sparc64-defconfig (attached as .config)
compiler: sparc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=sparc64 

All errors (new ones prefixed by >>):

>> ERROR: "dax_write_cache" [drivers/md/dm-mod.ko] undefined!
>> ERROR: "dax_write_cache_enabled" [drivers/md/dm-mod.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
