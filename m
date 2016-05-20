Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9EB2D1A1E1C
 for <linux-nvdimm@lists.01.org>; Fri, 20 May 2016 04:34:01 -0700 (PDT)
Date: Fri, 20 May 2016 19:32:28 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] remove unused blkdev_dax_capable() function
Message-ID: <201605201900.FlOCWSKP%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <3280835.MNk2ItMooy@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, jack@suse.cz, linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test ERROR on next-20160517]
[cannot apply to v4.6-rc7 v4.6-rc6 v4.6-rc5 v4.6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arnd-Bergmann/remove-unused-blkdev_dax_capable-function/20160518-155729
config: m68k-allyesconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=m68k 

All errors (new ones prefixed by >>):

   fs/block_dev.c: In function '__blkdev_get':
>> fs/block_dev.c:1242:5: error: implicit declaration of function 'blkdev_dax_capable' [-Werror=implicit-function-declaration]
        if (!blkdev_dax_capable(bdev))
        ^
   cc1: some warnings being treated as errors

vim +/blkdev_dax_capable +1242 fs/block_dev.c

d3374825 NeilBrown    2009-01-09  1236  					goto restart;
d3374825 NeilBrown    2009-01-09  1237  				}
1196f8b8 Tejun Heo    2011-04-21  1238  			}
7e69723f Tejun Heo    2011-05-23  1239  
5a023cdb Dan Williams 2015-11-30  1240  			if (!ret) {
7e69723f Tejun Heo    2011-05-23  1241  				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
5a023cdb Dan Williams 2015-11-30 @1242  				if (!blkdev_dax_capable(bdev))
5a023cdb Dan Williams 2015-11-30  1243  					bdev->bd_inode->i_flags &= ~S_DAX;
5a023cdb Dan Williams 2015-11-30  1244  			}
7e69723f Tejun Heo    2011-05-23  1245  

:::::: The code at line 1242 was first introduced by commit
:::::: 5a023cdba50c5f5f2bc351783b3131699deb3937 block: enable dax for raw block devices

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
