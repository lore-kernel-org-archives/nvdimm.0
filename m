Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 362441A1E47
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 14:42:48 -0700 (PDT)
Date: Sun, 5 Jun 2016 05:40:35 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 04/13] libnvdimm, nfit: move flush hint mapping to dimm
 driver
Message-ID: <201606050520.S3JkY68h%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
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

[auto build test ERROR on v4.7-rc1]
[also build test ERROR on next-20160603]
[cannot apply to linux-nvdimm/libnvdimm-for-next tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/deprecate-pcommit/20160605-045935
config: i386-randconfig-s1-201623 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/nvdimm/region_devs.c: In function 'nvdimm_flush':
>> drivers/nvdimm/region_devs.c:826:4: error: implicit declaration of function 'writeq' [-Werror=implicit-function-declaration]
       writeq(1, ndd->flush_wpq[0]);
       ^~~~~~
   cc1: some warnings being treated as errors

vim +/writeq +826 drivers/nvdimm/region_devs.c

   820			/*
   821			 * Note, nvdimm_drvdata guaranteed to be live since we
   822			 * arrange for all associated regions to be disabled
   823			 * before the dimm is disabled.
   824			 */
   825			if (ndd->flush_wpq[0])
 > 826				writeq(1, ndd->flush_wpq[0]);
   827		}
   828		wmb();
   829	}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
