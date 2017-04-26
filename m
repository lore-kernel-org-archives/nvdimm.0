Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C02A22194D39C
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 12:59:54 -0700 (PDT)
Date: Thu, 27 Apr 2017 03:59:24 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/2] x86/ras/mce_amd_inj: Preset MCE injection struct
Message-ID: <201704270338.NrKRh2Mw%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20170424113718.hhycno5my6fbjebv@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Borislav,

[auto build test ERROR on next-20170421]
[cannot apply to tip/x86/core v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc8]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Borislav-Petkov/x86-MCE-Export-memory_error/20170424-215449
config: i386-allmodconfig (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

>> ERROR: "mce_setup" [arch/x86/ras/mce_amd_inj.ko] undefined!

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
