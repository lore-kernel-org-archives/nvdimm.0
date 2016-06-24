Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 35D201A1DF9
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 13:00:19 -0700 (PDT)
Date: Sat, 25 Jun 2016 03:58:43 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] dm stripe: add DAX support
Message-ID: <201606250312.OzHHesq4%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1466792610-30369-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: snitzer@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test WARNING on dm/for-next]
[also build test WARNING on v4.7-rc4 next-20160624]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/dm-stripe-add-DAX-support/20160625-022600
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: m68k-sun3_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

All warnings (new ones prefixed by >>):

   drivers/md/dm-stripe.c:452:2: error: unknown field 'direct_access' specified in initializer
     .direct_access = stripe_direct_access,
     ^
   drivers/md/dm-stripe.c:452:2: warning: missing braces around initializer [-Wmissing-braces]
   drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list') [-Wmissing-braces]
>> drivers/md/dm-stripe.c:452:2: warning: initialization from incompatible pointer type
   drivers/md/dm-stripe.c:452:2: warning: (near initialization for 'stripe_target.list.next')

vim +452 drivers/md/dm-stripe.c

   436	
   437		blk_limits_io_min(limits, chunk_size);
   438		blk_limits_io_opt(limits, chunk_size * sc->stripes);
   439	}
   440	
   441	static struct target_type stripe_target = {
   442		.name   = "striped",
   443		.version = {1, 5, 1},
   444		.module = THIS_MODULE,
   445		.ctr    = stripe_ctr,
   446		.dtr    = stripe_dtr,
   447		.map    = stripe_map,
   448		.end_io = stripe_end_io,
   449		.status = stripe_status,
   450		.iterate_devices = stripe_iterate_devices,
   451		.io_hints = stripe_io_hints,
 > 452		.direct_access = stripe_direct_access,
   453	};
   454	
   455	int __init dm_stripe_init(void)
   456	{
   457		int r;
   458	
   459		r = dm_register_target(&stripe_target);
   460		if (r < 0)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
