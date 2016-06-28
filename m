Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id BBC8B1A1DF7
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 13:35:36 -0700 (PDT)
Date: Wed, 29 Jun 2016 04:33:22 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] dm: update table type check for dax
Message-ID: <201606290444.S7wFsdHl%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1467142636-21094-2-git-send-email-toshi.kani@hpe.com>
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

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.7-rc5 next-20160628]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Toshi-Kani/Support-DAX-for-device-mapper-dm-linear-devices/20160629-034110
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: x86_64-randconfig-s1-06290340 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/md/dm-ioctl.c: In function 'is_valid_type':
>> drivers/md/dm-ioctl.c:1273:42: error: 'DM_TYPE_DAX_BIO_BASED' undeclared (first use in this function)
         (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
                                             ^~~~~~~~~~~~~~~~~~~~~
   drivers/md/dm-ioctl.c:1273:42: note: each undeclared identifier is reported only once for each function it appears in

vim +/DM_TYPE_DAX_BIO_BASED +1273 drivers/md/dm-ioctl.c

  1267		return dm_table_complete(table);
  1268	}
  1269	
  1270	static bool is_valid_type(unsigned cur, unsigned new)
  1271	{
  1272		if (cur == new ||
> 1273		    (cur == DM_TYPE_BIO_BASED && new == DM_TYPE_DAX_BIO_BASED))
  1274			return true;
  1275	
  1276		return false;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
