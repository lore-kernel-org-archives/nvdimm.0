Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5E352096182D
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 18:03:28 -0700 (PDT)
Date: Tue, 10 Jul 2018 08:59:28 +0800
From: Ye Xiaolong <xiaolong.ye@intel.com>
Subject: Re: [kbuild-all] [PATCH v6 2/4] resource: Use list_head to link
 sibling resource
Message-ID: <20180710005927.GG10005@yexl-desktop>
References: <20180704041038.8190-3-bhe@redhat.com>
 <201807042347.hfDcKxmG%fengguang.wu@intel.com>
 <20180708025946.GI3047@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180708025946.GI3047@MiWiFi-R3L-srv>
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
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, kbuild test robot <lkp@intel.com>, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, andy.shevchenko@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, kbuild-all@01.org, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, devel@linuxdriverproject.org, akpm@linux-foundation.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

Hi,

On 07/08, Baoquan He wrote:
>Hi,
>
>On 07/05/18 at 01:00am, kbuild test robot wrote:
>> Hi Baoquan,
>> 
>> I love your patch! Yet something to improve:
>> 
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on v4.18-rc3 next-20180704]
>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
>Thanks for telling. 
>
>I cloned 0day-ci/linut to my local pc.
>https://github.com/0day-ci/linux.git
>
>However, I didn't find below branch. And tried to open it in web
>broswer, also failed.
>

Sorry for the inconvenience, 0day bot didn't push the branch to github successfully,
Just push it manually, you can have a try again.

Thanks,
Xiaolong


>
>> url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180704-121402
>> config: mips-rb532_defconfig (attached as .config)
>> compiler: mipsel-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
>> reproduce:
>>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         GCC_VERSION=7.2.0 make.cross ARCH=mips 
>
>I did find a old one which is for the old version 5 post.
>
>[bhe@linux]$ git remote -v
>0day-ci	https://github.com/0day-ci/linux.git (fetch)
>0day-ci	https://github.com/0day-ci/linux.git (push)
>[bhe@dhcp-128-28 linux]$ git branch -a| grep Baoquan| grep resource
>  remotes/0day-ci/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180612-113600
>
>Could you help have a look at this?
>
>Thanks
>Baoquan
>
>> 
>> All error/warnings (new ones prefixed by >>):
>> 
>> >> arch/mips/pci/pci-rc32434.c:57:11: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
>>      .child = &rc32434_res_pci_mem2
>>               ^
>>    arch/mips/pci/pci-rc32434.c:57:11: note: (near initialization for 'rc32434_res_pci_mem1.child.next')
>> >> arch/mips/pci/pci-rc32434.c:51:47: warning: missing braces around initializer [-Wmissing-braces]
>>     static struct resource rc32434_res_pci_mem1 = {
>>                                                   ^
>>    arch/mips/pci/pci-rc32434.c:60:47: warning: missing braces around initializer [-Wmissing-braces]
>>     static struct resource rc32434_res_pci_mem2 = {
>>                                                   ^
>>    cc1: some warnings being treated as errors
>> 
>> vim +57 arch/mips/pci/pci-rc32434.c
>> 
>> 73b4390f Ralf Baechle 2008-07-16  50  
>> 73b4390f Ralf Baechle 2008-07-16 @51  static struct resource rc32434_res_pci_mem1 = {
>> 73b4390f Ralf Baechle 2008-07-16  52  	.name = "PCI MEM1",
>> 73b4390f Ralf Baechle 2008-07-16  53  	.start = 0x50000000,
>> 73b4390f Ralf Baechle 2008-07-16  54  	.end = 0x5FFFFFFF,
>> 73b4390f Ralf Baechle 2008-07-16  55  	.flags = IORESOURCE_MEM,
>> 73b4390f Ralf Baechle 2008-07-16  56  	.sibling = NULL,
>> 73b4390f Ralf Baechle 2008-07-16 @57  	.child = &rc32434_res_pci_mem2
>> 73b4390f Ralf Baechle 2008-07-16  58  };
>> 73b4390f Ralf Baechle 2008-07-16  59  
>> 
>> :::::: The code at line 57 was first introduced by commit
>> :::::: 73b4390fb23456964201abda79f1210fe337d01a [MIPS] Routerboard 532: Support for base system
>> 
>> :::::: TO: Ralf Baechle <ralf@linux-mips.org>
>> :::::: CC: Ralf Baechle <ralf@linux-mips.org>
>> 
>> ---
>> 0-DAY kernel test infrastructure                Open Source Technology Center
>> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
>
>_______________________________________________
>kbuild-all mailing list
>kbuild-all@lists.01.org
>https://lists.01.org/mailman/listinfo/kbuild-all
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
