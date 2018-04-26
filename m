Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EEB01202E5F07
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 20:24:29 -0700 (PDT)
Date: Thu, 26 Apr 2018 11:23:50 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link sibling resource
Message-ID: <201804261137.HPgv5SSG%fengguang.wu@intel.com>
References: <20180419001848.3041-2-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20180419001848.3041-2-bhe@redhat.com>
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
To: Baoquan He <bhe@redhat.com>
Cc: nicolas.pitre@linaro.org, Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, devicetree@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, josh@joshtriplett.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, robh+dt@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Baoquan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17-rc2 next-20180424]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180419-223752
config: xtensa-common_defconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All errors (new ones prefixed by >>):

   In file included from arch/xtensa/lib/pci-auto.c:22:0:
   arch/xtensa/include/asm/pci-bridge.h: In function 'pcibios_init_resource':
>> arch/xtensa/include/asm/pci-bridge.h:74:15: error: incompatible types when assigning to type 'struct list_head' from type 'void *'
     res->sibling = NULL;
                  ^
   arch/xtensa/include/asm/pci-bridge.h:75:13: error: incompatible types when assigning to type 'struct list_head' from type 'void *'
     res->child = NULL;
                ^

vim +74 arch/xtensa/include/asm/pci-bridge.h

9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  65  
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  66  static inline void pcibios_init_resource(struct resource *res,
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  67  		unsigned long start, unsigned long end, int flags, char *name)
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  68  {
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  69  	res->start = start;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  70  	res->end = end;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  71  	res->flags = flags;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  72  	res->name = name;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  73  	res->parent = NULL;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23 @74  	res->sibling = NULL;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  75  	res->child = NULL;
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  76  }
9a8fd558 include/asm-xtensa/pci-bridge.h Chris Zankel 2005-06-23  77  

:::::: The code at line 74 was first introduced by commit
:::::: 9a8fd5589902153a134111ed7a40f9cca1f83254 [PATCH] xtensa: Architecture support for Tensilica Xtensa Part 6

:::::: TO: Chris Zankel <czankel@tensilica.com>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
