Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D401F225F31E3
 for <linux-nvdimm@lists.01.org>; Sun,  1 Apr 2018 05:17:58 -0700 (PDT)
Date: Sun, 1 Apr 2018 20:17:50 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-for-next 49/56] drivers//dax/super.c:209:44:
 error: dereferencing pointer to incomplete type
Message-ID: <201804012040.kPew2HGU%fengguang.wu@intel.com>
MIME-Version: 1.0
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
Cc: Jan Kara <jack@suse.cz>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
head:   4f2e6ecbd1cb397d65ead8aab4fd4d05fcbfeaff
commit: 45d0fd3c767f81356f880be9a8893bb12a39488a [49/56] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
config: x86_64-randconfig-g0-04011906 (attached as .config)
compiler: gcc-4.9 (Debian 4.9.4-2) 4.9.4
reproduce:
        git checkout 45d0fd3c767f81356f880be9a8893bb12a39488a
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers//dax/super.c: In function 'fs_dax_claim_bdev':
   drivers//dax/super.c:207:2: error: implicit declaration of function 'blk_queue_dax' [-Werror=implicit-function-declaration]
     if (!blk_queue_dax(bdev->bd_queue))
     ^
>> drivers//dax/super.c:209:44: error: dereferencing pointer to incomplete type
     dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
                                               ^
   cc1: some warnings being treated as errors

vim +209 drivers//dax/super.c

b42158bb Dan Williams 2018-03-29  202  
b42158bb Dan Williams 2018-03-29  203  struct dax_device *fs_dax_claim_bdev(struct block_device *bdev, void *owner)
b42158bb Dan Williams 2018-03-29  204  {
b42158bb Dan Williams 2018-03-29  205  	struct dax_device *dax_dev;
b42158bb Dan Williams 2018-03-29  206  
b42158bb Dan Williams 2018-03-29 @207  	if (!blk_queue_dax(bdev->bd_queue))
b42158bb Dan Williams 2018-03-29  208  		return NULL;
b42158bb Dan Williams 2018-03-29 @209  	dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
b42158bb Dan Williams 2018-03-29  210  	if (dax_dev->ops->fs_claim)
b42158bb Dan Williams 2018-03-29  211  		return dax_dev->ops->fs_claim(dax_dev, owner);
b42158bb Dan Williams 2018-03-29  212  	else
b42158bb Dan Williams 2018-03-29  213  		return fs_dax_claim(dax_dev, owner);
b42158bb Dan Williams 2018-03-29  214  }
b42158bb Dan Williams 2018-03-29  215  EXPORT_SYMBOL_GPL(fs_dax_claim_bdev);
b42158bb Dan Williams 2018-03-29  216  

:::::: The code at line 209 was first introduced by commit
:::::: b42158bb23c9db316c12e3b3845ef01d41013314 dax, dm: introduce ->fs_{claim,release}() dax_device infrastructure

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
