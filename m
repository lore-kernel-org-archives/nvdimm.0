Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E271921E0817D
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 16:37:08 -0700 (PDT)
Date: Sat, 31 Mar 2018 07:36:54 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/4] acpi: add find error record in BERT function
Message-ID: <201803310742.jTzcHxid%fengguang.wu@intel.com>
References: <152236302712.35558.17322719540329044966.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
In-Reply-To: <152236302712.35558.17322719540329044966.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: tony.luck@intel.com, linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org, kbuild-all@01.org, Ying Huang <ying.huang@intel.com>, lenb@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

I love your patch! Yet something to improve:

[auto build test ERROR on pm/linux-next]
[also build test ERROR on v4.16-rc7 next-20180329]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/Adding-support-to-parse-BERT-for-libnvdimm/20180331-065821
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: i386-tinyconfig (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   arch/x86/kernel/setup.o: In function `bert_find_mem_error_record':
>> setup.c:(.text+0x3): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/i8259.o: In function `bert_find_mem_error_record':
   i8259.c:(.text+0x2c2): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/irqinit.o: In function `bert_find_mem_error_record':
   irqinit.c:(.text+0x0): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/bootflag.o: In function `bert_find_mem_error_record':
   bootflag.c:(.text+0x0): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/e820.o: In function `bert_find_mem_error_record':
   e820.c:(.text+0xb1): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/pci-dma.o: In function `bert_find_mem_error_record':
   pci-dma.c:(.text+0x0): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   arch/x86/kernel/rtc.o: In function `bert_find_mem_error_record':
   rtc.c:(.text+0x41): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   kernel/sysctl.o: In function `bert_find_mem_error_record':
   sysctl.c:(.text+0x0): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   drivers/base/platform.o: In function `bert_find_mem_error_record':
   platform.c:(.text+0x1e8): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   drivers/base/cpu.o: In function `bert_find_mem_error_record':
   cpu.c:(.text+0x1a1): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   drivers/base/property.o: In function `bert_find_mem_error_record':
   property.c:(.text+0x2aa): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   drivers/base/cacheinfo.o: In function `bert_find_mem_error_record':
   cacheinfo.c:(.text+0x2e5): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here
   drivers/base/dma-mapping.o: In function `bert_find_mem_error_record':
   dma-mapping.c:(.text+0x104): multiple definition of `bert_find_mem_error_record'
   init/main.o:main.c:(.text+0x19): first defined here

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
