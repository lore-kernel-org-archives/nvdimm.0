Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72DD02096106E
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 04:42:50 -0700 (PDT)
Date: Mon, 7 May 2018 19:42:14 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 1/3] resource: Use list_head to link sibling resource
Message-ID: <201805071803.2MKgOLTP%fengguang.wu@intel.com>
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
config: powerpc-defconfig (attached as .config)
compiler: powerpc64-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=powerpc 

All errors (new ones prefixed by >>):

   arch/powerpc/kernel/pci-common.c: In function 'pci_process_bridge_OF_ranges':
>> arch/powerpc/kernel/pci-common.c:764:44: error: incompatible types when assigning to type 'struct list_head' from type 'void *'
       res->parent = res->child = res->sibling = NULL;
                                               ^
   arch/powerpc/kernel/pci-common.c: In function 'reparent_resources':
>> arch/powerpc/kernel/pci-common.c:1100:10: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
     for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
             ^
   arch/powerpc/kernel/pci-common.c:1100:50: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
     for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
                                                     ^
>> arch/powerpc/kernel/pci-common.c:1113:13: error: incompatible types when assigning to type 'struct list_head' from type 'struct resource *'
     res->child = *firstpp;
                ^
   arch/powerpc/kernel/pci-common.c:1114:15: error: incompatible types when assigning to type 'struct list_head' from type 'struct resource *'
     res->sibling = *pp;
                  ^
>> arch/powerpc/kernel/pci-common.c:1117:9: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
     for (p = res->child; p != NULL; p = p->sibling) {
            ^
   arch/powerpc/kernel/pci-common.c:1117:36: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
     for (p = res->child; p != NULL; p = p->sibling) {
                                       ^
   cc1: all warnings being treated as errors

vim +764 arch/powerpc/kernel/pci-common.c

13dccb9e Benjamin Herrenschmidt 2007-12-11  642  
13dccb9e Benjamin Herrenschmidt 2007-12-11  643  /**
13dccb9e Benjamin Herrenschmidt 2007-12-11  644   * pci_process_bridge_OF_ranges - Parse PCI bridge resources from device tree
13dccb9e Benjamin Herrenschmidt 2007-12-11  645   * @hose: newly allocated pci_controller to be setup
13dccb9e Benjamin Herrenschmidt 2007-12-11  646   * @dev: device node of the host bridge
13dccb9e Benjamin Herrenschmidt 2007-12-11  647   * @primary: set if primary bus (32 bits only, soon to be deprecated)
13dccb9e Benjamin Herrenschmidt 2007-12-11  648   *
13dccb9e Benjamin Herrenschmidt 2007-12-11  649   * This function will parse the "ranges" property of a PCI host bridge device
13dccb9e Benjamin Herrenschmidt 2007-12-11  650   * node and setup the resource mapping of a pci controller based on its
13dccb9e Benjamin Herrenschmidt 2007-12-11  651   * content.
13dccb9e Benjamin Herrenschmidt 2007-12-11  652   *
13dccb9e Benjamin Herrenschmidt 2007-12-11  653   * Life would be boring if it wasn't for a few issues that we have to deal
13dccb9e Benjamin Herrenschmidt 2007-12-11  654   * with here:
13dccb9e Benjamin Herrenschmidt 2007-12-11  655   *
13dccb9e Benjamin Herrenschmidt 2007-12-11  656   *   - We can only cope with one IO space range and up to 3 Memory space
13dccb9e Benjamin Herrenschmidt 2007-12-11  657   *     ranges. However, some machines (thanks Apple !) tend to split their
13dccb9e Benjamin Herrenschmidt 2007-12-11  658   *     space into lots of small contiguous ranges. So we have to coalesce.
13dccb9e Benjamin Herrenschmidt 2007-12-11  659   *
13dccb9e Benjamin Herrenschmidt 2007-12-11  660   *   - Some busses have IO space not starting at 0, which causes trouble with
13dccb9e Benjamin Herrenschmidt 2007-12-11  661   *     the way we do our IO resource renumbering. The code somewhat deals with
13dccb9e Benjamin Herrenschmidt 2007-12-11  662   *     it for 64 bits but I would expect problems on 32 bits.
13dccb9e Benjamin Herrenschmidt 2007-12-11  663   *
13dccb9e Benjamin Herrenschmidt 2007-12-11  664   *   - Some 32 bits platforms such as 4xx can have physical space larger than
13dccb9e Benjamin Herrenschmidt 2007-12-11  665   *     32 bits so we need to use 64 bits values for the parsing
13dccb9e Benjamin Herrenschmidt 2007-12-11  666   */
cad5cef6 Greg Kroah-Hartman     2012-12-21  667  void pci_process_bridge_OF_ranges(struct pci_controller *hose,
cad5cef6 Greg Kroah-Hartman     2012-12-21  668  				  struct device_node *dev, int primary)
13dccb9e Benjamin Herrenschmidt 2007-12-11  669  {
858957ab Kevin Hao              2013-05-16  670  	int memno = 0;
13dccb9e Benjamin Herrenschmidt 2007-12-11  671  	struct resource *res;
654837e8 Andrew Murray          2014-02-25  672  	struct of_pci_range range;
654837e8 Andrew Murray          2014-02-25  673  	struct of_pci_range_parser parser;
13dccb9e Benjamin Herrenschmidt 2007-12-11  674  
b7c670d6 Rob Herring            2017-08-21  675  	printk(KERN_INFO "PCI host bridge %pOF %s ranges:\n",
b7c670d6 Rob Herring            2017-08-21  676  	       dev, primary ? "(primary)" : "");
13dccb9e Benjamin Herrenschmidt 2007-12-11  677  
654837e8 Andrew Murray          2014-02-25  678  	/* Check for ranges property */
654837e8 Andrew Murray          2014-02-25  679  	if (of_pci_range_parser_init(&parser, dev))
13dccb9e Benjamin Herrenschmidt 2007-12-11  680  		return;
13dccb9e Benjamin Herrenschmidt 2007-12-11  681  
13dccb9e Benjamin Herrenschmidt 2007-12-11  682  	/* Parse it */
654837e8 Andrew Murray          2014-02-25  683  	for_each_of_pci_range(&parser, &range) {
e9f82cb7 Benjamin Herrenschmidt 2008-10-14  684  		/* If we failed translation or got a zero-sized region
e9f82cb7 Benjamin Herrenschmidt 2008-10-14  685  		 * (some FW try to feed us with non sensical zero sized regions
e9f82cb7 Benjamin Herrenschmidt 2008-10-14  686  		 * such as power3 which look like some kind of attempt at exposing
e9f82cb7 Benjamin Herrenschmidt 2008-10-14  687  		 * the VGA memory hole)
e9f82cb7 Benjamin Herrenschmidt 2008-10-14  688  		 */
654837e8 Andrew Murray          2014-02-25  689  		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
13dccb9e Benjamin Herrenschmidt 2007-12-11  690  			continue;
13dccb9e Benjamin Herrenschmidt 2007-12-11  691  
13dccb9e Benjamin Herrenschmidt 2007-12-11  692  		/* Act based on address space type */
13dccb9e Benjamin Herrenschmidt 2007-12-11  693  		res = NULL;
654837e8 Andrew Murray          2014-02-25  694  		switch (range.flags & IORESOURCE_TYPE_BITS) {
654837e8 Andrew Murray          2014-02-25  695  		case IORESOURCE_IO:
13dccb9e Benjamin Herrenschmidt 2007-12-11  696  			printk(KERN_INFO
13dccb9e Benjamin Herrenschmidt 2007-12-11  697  			       "  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
654837e8 Andrew Murray          2014-02-25  698  			       range.cpu_addr, range.cpu_addr + range.size - 1,
654837e8 Andrew Murray          2014-02-25  699  			       range.pci_addr);
13dccb9e Benjamin Herrenschmidt 2007-12-11  700  
13dccb9e Benjamin Herrenschmidt 2007-12-11  701  			/* We support only one IO range */
13dccb9e Benjamin Herrenschmidt 2007-12-11  702  			if (hose->pci_io_size) {
13dccb9e Benjamin Herrenschmidt 2007-12-11  703  				printk(KERN_INFO
13dccb9e Benjamin Herrenschmidt 2007-12-11  704  				       " \\--> Skipped (too many) !\n");
13dccb9e Benjamin Herrenschmidt 2007-12-11  705  				continue;
13dccb9e Benjamin Herrenschmidt 2007-12-11  706  			}
13dccb9e Benjamin Herrenschmidt 2007-12-11  707  #ifdef CONFIG_PPC32
13dccb9e Benjamin Herrenschmidt 2007-12-11  708  			/* On 32 bits, limit I/O space to 16MB */
654837e8 Andrew Murray          2014-02-25  709  			if (range.size > 0x01000000)
654837e8 Andrew Murray          2014-02-25  710  				range.size = 0x01000000;
13dccb9e Benjamin Herrenschmidt 2007-12-11  711  
13dccb9e Benjamin Herrenschmidt 2007-12-11  712  			/* 32 bits needs to map IOs here */
654837e8 Andrew Murray          2014-02-25  713  			hose->io_base_virt = ioremap(range.cpu_addr,
654837e8 Andrew Murray          2014-02-25  714  						range.size);
13dccb9e Benjamin Herrenschmidt 2007-12-11  715  
13dccb9e Benjamin Herrenschmidt 2007-12-11  716  			/* Expect trouble if pci_addr is not 0 */
13dccb9e Benjamin Herrenschmidt 2007-12-11  717  			if (primary)
13dccb9e Benjamin Herrenschmidt 2007-12-11  718  				isa_io_base =
13dccb9e Benjamin Herrenschmidt 2007-12-11  719  					(unsigned long)hose->io_base_virt;
13dccb9e Benjamin Herrenschmidt 2007-12-11  720  #endif /* CONFIG_PPC32 */
13dccb9e Benjamin Herrenschmidt 2007-12-11  721  			/* pci_io_size and io_base_phys always represent IO
13dccb9e Benjamin Herrenschmidt 2007-12-11  722  			 * space starting at 0 so we factor in pci_addr
13dccb9e Benjamin Herrenschmidt 2007-12-11  723  			 */
654837e8 Andrew Murray          2014-02-25  724  			hose->pci_io_size = range.pci_addr + range.size;
654837e8 Andrew Murray          2014-02-25  725  			hose->io_base_phys = range.cpu_addr - range.pci_addr;
13dccb9e Benjamin Herrenschmidt 2007-12-11  726  
13dccb9e Benjamin Herrenschmidt 2007-12-11  727  			/* Build resource */
13dccb9e Benjamin Herrenschmidt 2007-12-11  728  			res = &hose->io_resource;
654837e8 Andrew Murray          2014-02-25  729  			range.cpu_addr = range.pci_addr;
13dccb9e Benjamin Herrenschmidt 2007-12-11  730  			break;
654837e8 Andrew Murray          2014-02-25  731  		case IORESOURCE_MEM:
13dccb9e Benjamin Herrenschmidt 2007-12-11  732  			printk(KERN_INFO
13dccb9e Benjamin Herrenschmidt 2007-12-11  733  			       " MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
654837e8 Andrew Murray          2014-02-25  734  			       range.cpu_addr, range.cpu_addr + range.size - 1,
654837e8 Andrew Murray          2014-02-25  735  			       range.pci_addr,
654837e8 Andrew Murray          2014-02-25  736  			       (range.pci_space & 0x40000000) ?
654837e8 Andrew Murray          2014-02-25  737  			       "Prefetch" : "");
13dccb9e Benjamin Herrenschmidt 2007-12-11  738  
13dccb9e Benjamin Herrenschmidt 2007-12-11  739  			/* We support only 3 memory ranges */
13dccb9e Benjamin Herrenschmidt 2007-12-11  740  			if (memno >= 3) {
13dccb9e Benjamin Herrenschmidt 2007-12-11  741  				printk(KERN_INFO
13dccb9e Benjamin Herrenschmidt 2007-12-11  742  				       " \\--> Skipped (too many) !\n");
13dccb9e Benjamin Herrenschmidt 2007-12-11  743  				continue;
13dccb9e Benjamin Herrenschmidt 2007-12-11  744  			}
13dccb9e Benjamin Herrenschmidt 2007-12-11  745  			/* Handles ISA memory hole space here */
654837e8 Andrew Murray          2014-02-25  746  			if (range.pci_addr == 0) {
13dccb9e Benjamin Herrenschmidt 2007-12-11  747  				if (primary || isa_mem_base == 0)
654837e8 Andrew Murray          2014-02-25  748  					isa_mem_base = range.cpu_addr;
654837e8 Andrew Murray          2014-02-25  749  				hose->isa_mem_phys = range.cpu_addr;
654837e8 Andrew Murray          2014-02-25  750  				hose->isa_mem_size = range.size;
13dccb9e Benjamin Herrenschmidt 2007-12-11  751  			}
13dccb9e Benjamin Herrenschmidt 2007-12-11  752  
13dccb9e Benjamin Herrenschmidt 2007-12-11  753  			/* Build resource */
654837e8 Andrew Murray          2014-02-25  754  			hose->mem_offset[memno] = range.cpu_addr -
654837e8 Andrew Murray          2014-02-25  755  							range.pci_addr;
13dccb9e Benjamin Herrenschmidt 2007-12-11  756  			res = &hose->mem_resources[memno++];
13dccb9e Benjamin Herrenschmidt 2007-12-11  757  			break;
13dccb9e Benjamin Herrenschmidt 2007-12-11  758  		}
13dccb9e Benjamin Herrenschmidt 2007-12-11  759  		if (res != NULL) {
aeba3731 Michael Ellerman       2014-10-16  760  			res->name = dev->full_name;
aeba3731 Michael Ellerman       2014-10-16  761  			res->flags = range.flags;
aeba3731 Michael Ellerman       2014-10-16  762  			res->start = range.cpu_addr;
aeba3731 Michael Ellerman       2014-10-16  763  			res->end = range.cpu_addr + range.size - 1;
aeba3731 Michael Ellerman       2014-10-16 @764  			res->parent = res->child = res->sibling = NULL;
13dccb9e Benjamin Herrenschmidt 2007-12-11  765  		}
13dccb9e Benjamin Herrenschmidt 2007-12-11  766  	}
13dccb9e Benjamin Herrenschmidt 2007-12-11  767  }
fa462f2d Benjamin Herrenschmidt 2007-12-20  768  

:::::: The code at line 764 was first introduced by commit
:::::: aeba3731b150188685225b510886f1370d8814de powerpc/pci: Fix IO space breakage after of_pci_range_to_resource() change

:::::: TO: Michael Ellerman <mpe@ellerman.id.au>
:::::: CC: Michael Ellerman <mpe@ellerman.id.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
