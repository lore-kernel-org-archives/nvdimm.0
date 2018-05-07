Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D64D52096106C
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 08:51:02 -0700 (PDT)
Date: Mon, 7 May 2018 23:50:22 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 1/3] resource: Use list_head to link sibling resource
Message-ID: <201805072210.H1bsHs9Y%fengguang.wu@intel.com>
References: <20180507063224.24229-2-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20180507063224.24229-2-bhe@redhat.com>
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
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, keith.busch@intel.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org, fengguang.wu@intel.com, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

Hi Baoquan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.17-rc4 next-20180504]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180507-144345
config: arm-allmodconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=arm 

All errors (new ones prefixed by >>):

   arch/arm/plat-samsung/pm-check.c: In function 's3c_pm_run_res':
>> arch/arm/plat-samsung/pm-check.c:49:18: error: invalid operands to binary != (have 'struct list_head' and 'void *')
      if (ptr->child != NULL)
          ~~~~~~~~~~ ^~
>> arch/arm/plat-samsung/pm-check.c:50:19: error: incompatible type for argument 1 of 's3c_pm_run_res'
       s3c_pm_run_res(ptr->child, fn, arg);
                      ^~~
   arch/arm/plat-samsung/pm-check.c:46:13: note: expected 'struct resource *' but argument is of type 'struct list_head'
    static void s3c_pm_run_res(struct resource *ptr, run_fn_t fn, u32 *arg)
                ^~~~~~~~~~~~~~
>> arch/arm/plat-samsung/pm-check.c:60:7: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
      ptr = ptr->sibling;
          ^

vim +49 arch/arm/plat-samsung/pm-check.c

549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  45  
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  46  static void s3c_pm_run_res(struct resource *ptr, run_fn_t fn, u32 *arg)
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  47  {
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  48  	while (ptr != NULL) {
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12 @49  		if (ptr->child != NULL)
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12 @50  			s3c_pm_run_res(ptr->child, fn, arg);
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  51  
05fee7cf arch/arm/plat-samsung/pm-check.c Toshi Kani 2016-01-26  52  		if ((ptr->flags & IORESOURCE_SYSTEM_RAM)
05fee7cf arch/arm/plat-samsung/pm-check.c Toshi Kani 2016-01-26  53  				== IORESOURCE_SYSTEM_RAM) {
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  54  			S3C_PMDBG("Found system RAM at %08lx..%08lx\n",
840eeeb8 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  55  				  (unsigned long)ptr->start,
840eeeb8 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  56  				  (unsigned long)ptr->end);
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  57  			arg = (fn)(ptr, arg);
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  58  		}
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  59  
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12 @60  		ptr = ptr->sibling;
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  61  	}
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  62  }
549c7e33 arch/arm/plat-s3c/pm-check.c     Ben Dooks  2008-12-12  63  

:::::: The code at line 49 was first introduced by commit
:::::: 549c7e33aeb9bfe441ecf68639d2227bb90978e7 [ARM] S3C: Split the resume memory check code from pm.c

:::::: TO: Ben Dooks <ben-linux@fluff.org>
:::::: CC: Ben Dooks <ben-linux@fluff.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
