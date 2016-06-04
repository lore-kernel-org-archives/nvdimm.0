Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 6B2B21A1E4C
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 15:33:04 -0700 (PDT)
Date: Sun, 5 Jun 2016 06:18:02 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 13/13] pmem: kill __pmem address space
Message-ID: <201606050624.7WDIopgc%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146507362269.8347.11260236515601063041.stgit@dwillia2-desk3.amr.corp.intel.com>
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
config: s390-default_defconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 5.3.1-8) 5.3.1 20160205
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All warnings (new ones prefixed by >>):

   drivers/s390/block/dcssblk.c: In function 'dcssblk_direct_access':
>> drivers/s390/block/dcssblk.c:897:9: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     *kaddr = dev_info->start + offset;
            ^

vim +897 drivers/s390/block/dcssblk.c

   881		bio_io_error(bio);
   882		return BLK_QC_T_NONE;
   883	}
   884	
   885	static long
   886	dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
   887				void **kaddr, pfn_t *pfn, long size)
   888	{
   889		struct dcssblk_dev_info *dev_info;
   890		unsigned long offset, dev_sz;
   891	
   892		dev_info = bdev->bd_disk->private_data;
   893		if (!dev_info)
   894			return -ENODEV;
   895		dev_sz = dev_info->end - dev_info->start;
   896		offset = secnum * 512;
 > 897		*kaddr = dev_info->start + offset;
   898		*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
   899	
   900		return dev_sz - offset;
   901	}
   902	
   903	static void
   904	dcssblk_check_params(void)
   905	{

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
