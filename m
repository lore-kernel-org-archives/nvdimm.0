Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1C652096891F
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 10:01:07 -0700 (PDT)
Date: Thu, 5 Jul 2018 01:00:30 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 2/4] resource: Use list_head to link sibling resource
Message-ID: <201807042312.io0Igseh%fengguang.wu@intel.com>
References: <20180704041038.8190-3-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20180704041038.8190-3-bhe@redhat.com>
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
Cc: nicolas.pitre@linaro.org, brijesh.singh@amd.com, thomas.lendacky@amd.com, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, baiyaowei@cmss.chinamobile.com, frowand.list@gmail.com, tglx@linutronix.de, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, linux-nvdimm@lists.01.org, patrik.r.jakobsson@gmail.com, andy.shevchenko@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, bp@suse.de, dyoung@redhat.com, ebiederm@xmission.com, devicetree@vger.kernel.org, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, josh@joshtriplett.org, jglisse@redhat.com, robh+dt@kernel.org, seanpaul@chromium.org, bhelgaas@google.com, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

Hi Baoquan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.18-rc3 next-20180704]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180704-121402
config: ia64-allnoconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 8.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=8.1.0 make.cross ARCH=ia64 

All errors (new ones prefixed by >>):

   arch/ia64/sn/kernel/io_init.c: In function 'sn_io_slot_fixup':
>> arch/ia64/sn/kernel/io_init.c:195:19: error: invalid operands to binary && (have 'int' and 'struct list_head')
      if (res->parent && res->parent->child)
          ~~~~~~~~~~~ ^~ ~~~~~~~~~~~~~~~~~~

vim +195 arch/ia64/sn/kernel/io_init.c

^1da177e Linus Torvalds  2005-04-16  142  
3ec829b6 John Keller     2005-11-29  143  /*
6f09a925 John Keller     2007-01-30  144   * sn_io_slot_fixup() -   We are not running with an ACPI capable PROM,
8ea6091f John Keller     2006-10-04  145   *			  and need to convert the pci_dev->resource
8ea6091f John Keller     2006-10-04  146   *			  'start' and 'end' addresses to mapped addresses,
8ea6091f John Keller     2006-10-04  147   *			  and setup the pci_controller->window array entries.
^1da177e Linus Torvalds  2005-04-16  148   */
8ea6091f John Keller     2006-10-04  149  void
6f09a925 John Keller     2007-01-30  150  sn_io_slot_fixup(struct pci_dev *dev)
^1da177e Linus Torvalds  2005-04-16  151  {
^1da177e Linus Torvalds  2005-04-16  152  	int idx;
ab97b8cc Bjorn Helgaas   2016-03-02  153  	struct resource *res;
18c25526 Matt Fleming    2016-05-04  154  	unsigned long size;
6f09a925 John Keller     2007-01-30  155  	struct pcidev_info *pcidev_info;
6f09a925 John Keller     2007-01-30  156  	struct sn_irq_info *sn_irq_info;
6f09a925 John Keller     2007-01-30  157  	int status;
6f09a925 John Keller     2007-01-30  158  
6f09a925 John Keller     2007-01-30  159  	pcidev_info = kzalloc(sizeof(struct pcidev_info), GFP_KERNEL);
6f09a925 John Keller     2007-01-30  160  	if (!pcidev_info)
d4ed8084 Harvey Harrison 2008-03-04  161  		panic("%s: Unable to alloc memory for pcidev_info", __func__);
6f09a925 John Keller     2007-01-30  162  
6f09a925 John Keller     2007-01-30  163  	sn_irq_info = kzalloc(sizeof(struct sn_irq_info), GFP_KERNEL);
6f09a925 John Keller     2007-01-30  164  	if (!sn_irq_info)
d4ed8084 Harvey Harrison 2008-03-04  165  		panic("%s: Unable to alloc memory for sn_irq_info", __func__);
6f09a925 John Keller     2007-01-30  166  
6f09a925 John Keller     2007-01-30  167  	/* Call to retrieve pci device information needed by kernel. */
6f09a925 John Keller     2007-01-30  168  	status = sal_get_pcidev_info((u64) pci_domain_nr(dev),
6f09a925 John Keller     2007-01-30  169  		(u64) dev->bus->number,
6f09a925 John Keller     2007-01-30  170  		dev->devfn,
6f09a925 John Keller     2007-01-30  171  		(u64) __pa(pcidev_info),
6f09a925 John Keller     2007-01-30  172  		(u64) __pa(sn_irq_info));
6f09a925 John Keller     2007-01-30  173  
80a03e29 Stoyan Gaydarov 2009-03-10  174  	BUG_ON(status); /* Cannot get platform pci device information */
6f09a925 John Keller     2007-01-30  175  
3ec829b6 John Keller     2005-11-29  176  
^1da177e Linus Torvalds  2005-04-16  177  	/* Copy over PIO Mapped Addresses */
^1da177e Linus Torvalds  2005-04-16  178  	for (idx = 0; idx <= PCI_ROM_RESOURCE; idx++) {
ab97b8cc Bjorn Helgaas   2016-03-02  179  		if (!pcidev_info->pdi_pio_mapped_addr[idx])
^1da177e Linus Torvalds  2005-04-16  180  			continue;
^1da177e Linus Torvalds  2005-04-16  181  
ab97b8cc Bjorn Helgaas   2016-03-02  182  		res = &dev->resource[idx];
ab97b8cc Bjorn Helgaas   2016-03-02  183  
ab97b8cc Bjorn Helgaas   2016-03-02  184  		size = res->end - res->start;
ab97b8cc Bjorn Helgaas   2016-03-02  185  		if (size == 0)
3ec829b6 John Keller     2005-11-29  186  			continue;
ab97b8cc Bjorn Helgaas   2016-03-02  187  
240504ad Bjorn Helgaas   2016-03-02  188  		res->start = pcidev_info->pdi_pio_mapped_addr[idx];
18c25526 Matt Fleming    2016-05-04  189  		res->end = res->start + size;
64715725 Bernhard Walle  2007-03-18  190  
64715725 Bernhard Walle  2007-03-18  191  		/*
64715725 Bernhard Walle  2007-03-18  192  		 * if it's already in the device structure, remove it before
64715725 Bernhard Walle  2007-03-18  193  		 * inserting
64715725 Bernhard Walle  2007-03-18  194  		 */
ab97b8cc Bjorn Helgaas   2016-03-02 @195  		if (res->parent && res->parent->child)
ab97b8cc Bjorn Helgaas   2016-03-02  196  			release_resource(res);
64715725 Bernhard Walle  2007-03-18  197  
ab97b8cc Bjorn Helgaas   2016-03-02  198  		if (res->flags & IORESOURCE_IO)
ab97b8cc Bjorn Helgaas   2016-03-02  199  			insert_resource(&ioport_resource, res);
^1da177e Linus Torvalds  2005-04-16  200  		else
ab97b8cc Bjorn Helgaas   2016-03-02  201  			insert_resource(&iomem_resource, res);
d7ad2254 John Keller     2007-07-09  202  		/*
240504ad Bjorn Helgaas   2016-03-02  203  		 * If ROM, mark as shadowed in PROM.
d7ad2254 John Keller     2007-07-09  204  		 */
d7ad2254 John Keller     2007-07-09  205  		if (idx == PCI_ROM_RESOURCE) {
240504ad Bjorn Helgaas   2016-03-02  206  			pci_disable_rom(dev);
240504ad Bjorn Helgaas   2016-03-02  207  			res->flags = IORESOURCE_MEM | IORESOURCE_ROM_SHADOW |
240504ad Bjorn Helgaas   2016-03-02  208  				     IORESOURCE_PCI_FIXED;
d7ad2254 John Keller     2007-07-09  209  		}
^1da177e Linus Torvalds  2005-04-16  210  	}
6f09a925 John Keller     2007-01-30  211  
6f09a925 John Keller     2007-01-30  212  	sn_pci_fixup_slot(dev, pcidev_info, sn_irq_info);
^1da177e Linus Torvalds  2005-04-16  213  }
6f09a925 John Keller     2007-01-30  214  EXPORT_SYMBOL(sn_io_slot_fixup);
6f09a925 John Keller     2007-01-30  215  

:::::: The code at line 195 was first introduced by commit
:::::: ab97b8cc560eabfd8139dd97924a09e46a3c9632 ia64/PCI: Use temporary struct resource * to avoid repetition

:::::: TO: Bjorn Helgaas <bhelgaas@google.com>
:::::: CC: Bjorn Helgaas <bhelgaas@google.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
