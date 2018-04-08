Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5CD222620E8D
 for <linux-nvdimm@lists.01.org>; Sun,  8 Apr 2018 02:09:48 -0700 (PDT)
Date: Sun, 8 Apr 2018 17:09:44 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v2 1/3] resource: Use list_head to link sibling resource
Message-ID: <20180408090944.GF19345@localhost.localdomain>
References: <20180408024724.16812-2-bhe@redhat.com>
 <201804081223.lLuGQOqa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201804081223.lLuGQOqa%fengguang.wu@intel.com>
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
To: kbuild test robot <lkp@intel.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/08/18 at 01:55pm, kbuild test robot wrote:
> Hi Baoquan,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.16 next-20180406]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180408-110108
> config: sparc-defconfig (attached as .config)
> compiler: sparc-linux-gcc (GCC) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=sparc 
> 
> All errors (new ones prefixed by >>):
> 
>    arch/sparc/kernel/ioport.c: In function 'sparc_io_proc_show':
> >> arch/sparc/kernel/ioport.c:672:9: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
>      for (r = root->child; r != NULL; r = r->sibling) {
>             ^
>    arch/sparc/kernel/ioport.c:672:37: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
>      for (r = root->child; r != NULL; r = r->sibling) {
>                                         ^

Thanks, will change and repost.

> 
> vim +672 arch/sparc/kernel/ioport.c
> 
> ^1da177e4 Linus Torvalds     2005-04-16  666  
> e7a088f93 Alexey Dobriyan    2009-09-01  667  static int sparc_io_proc_show(struct seq_file *m, void *v)
> ^1da177e4 Linus Torvalds     2005-04-16  668  {
> e7a088f93 Alexey Dobriyan    2009-09-01  669  	struct resource *root = m->private, *r;
> ^1da177e4 Linus Torvalds     2005-04-16  670  	const char *nm;
> ^1da177e4 Linus Torvalds     2005-04-16  671  
> e7a088f93 Alexey Dobriyan    2009-09-01 @672  	for (r = root->child; r != NULL; r = r->sibling) {
> c31f76518 Sam Ravnborg       2014-04-21  673  		if ((nm = r->name) == NULL) nm = "???";
> e7a088f93 Alexey Dobriyan    2009-09-01  674  		seq_printf(m, "%016llx-%016llx: %s\n",
> 685143ac1 Greg Kroah-Hartman 2006-06-12  675  				(unsigned long long)r->start,
> 685143ac1 Greg Kroah-Hartman 2006-06-12  676  				(unsigned long long)r->end, nm);
> ^1da177e4 Linus Torvalds     2005-04-16  677  	}
> ^1da177e4 Linus Torvalds     2005-04-16  678  
> e7a088f93 Alexey Dobriyan    2009-09-01  679  	return 0;
> ^1da177e4 Linus Torvalds     2005-04-16  680  }
> ^1da177e4 Linus Torvalds     2005-04-16  681  
> 
> :::::: The code at line 672 was first introduced by commit
> :::::: e7a088f935180b90cfe6ab0aaae8a556f46885fe sparc: convert /proc/io_map, /proc/dvma_map to seq_file
> 
> :::::: TO: Alexey Dobriyan <adobriyan@gmail.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
