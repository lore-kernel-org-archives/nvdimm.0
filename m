Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA3C321A0BAA6
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 15:37:35 -0700 (PDT)
Date: Tue, 9 May 2017 06:36:55 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] block, dax: move "select DAX" from BLOCK to FS_DAX
Message-ID: <201705090658.bE7SNvsF%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <149427742346.38205.12361226658239922137.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on linus/master]
[also build test ERROR on next-20170508]
[cannot apply to v4.11]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/block-dax-move-select-DAX-from-BLOCK-to-FS_DAX/20170509-051522
config: parisc-c3000_defconfig (attached as .config)
compiler: hppa-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=parisc 

All errors (new ones prefixed by >>):

   fs/built-in.o: In function `bdev_dax_supported':
>> (.text.bdev_dax_supported+0x4c): undefined reference to `dax_get_by_host'
   fs/built-in.o: In function `bdev_dax_supported':
>> (.text.bdev_dax_supported+0x5c): undefined reference to `dax_read_lock'
   fs/built-in.o: In function `bdev_dax_supported':
>> (.text.bdev_dax_supported+0x7c): undefined reference to `dax_direct_access'
   fs/built-in.o: In function `bdev_dax_supported':
>> (.text.bdev_dax_supported+0x88): undefined reference to `dax_read_unlock'
   fs/built-in.o: In function `bdev_dax_supported':
>> (.text.bdev_dax_supported+0x90): undefined reference to `put_dax'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
