Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 60E6A1A1DF7
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 13:29:09 -0700 (PDT)
Date: Wed, 29 Jun 2016 04:27:01 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/2] dm snap: add fake origin_direct_access
Message-ID: <201606290450.w91c6wVU%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1467142636-21094-3-git-send-email-toshi.kani@hpe.com>
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
Cc: snitzer@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test WARNING on dm/for-next]
[also build test WARNING on v4.7-rc5 next-20160628]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/Support-DAX-for-device-mapper-dm-linear-devices/20160629-034110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: x86_64-lkp (attached as .config)
compiler: gcc-4.9 (Debian 4.9.3-14) 4.9.3
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   drivers/md/dm-snap.c:2370:2: error: unknown field 'direct_access' specified in initializer
     .direct_access = origin_direct_access,
     ^
>> drivers/md/dm-snap.c:2370:2: warning: initialization from incompatible pointer type
   drivers/md/dm-snap.c:2370:2: warning: (near initialization for 'origin_target.io_hints')

vim +2370 drivers/md/dm-snap.c

  2354		struct dm_origin *o = ti->private;
  2355	
  2356		return fn(ti, o->dev, 0, ti->len, data);
  2357	}
  2358	
  2359	static struct target_type origin_target = {
  2360		.name    = "snapshot-origin",
  2361		.version = {1, 9, 0},
  2362		.module  = THIS_MODULE,
  2363		.ctr     = origin_ctr,
  2364		.dtr     = origin_dtr,
  2365		.map     = origin_map,
  2366		.resume  = origin_resume,
  2367		.postsuspend = origin_postsuspend,
  2368		.status  = origin_status,
  2369		.iterate_devices = origin_iterate_devices,
> 2370		.direct_access = origin_direct_access,
  2371	};
  2372	
  2373	static struct target_type snapshot_target = {
  2374		.name    = "snapshot",
  2375		.version = {1, 15, 0},
  2376		.module  = THIS_MODULE,
  2377		.ctr     = snapshot_ctr,
  2378		.dtr     = snapshot_dtr,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
