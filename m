Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC0FB2094606A
 for <linux-nvdimm@lists.01.org>; Sat,  5 May 2018 23:31:38 -0700 (PDT)
Date: Sun, 6 May 2018 14:31:32 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link sibling resource
Message-ID: <20180506063132.GH19030@localhost.localdomain>
References: <20180419001848.3041-2-bhe@redhat.com>
 <201804261045.v9iHAD1T%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201804261045.v9iHAD1T%fengguang.wu@intel.com>
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
Cc: nicolas.pitre@linaro.org, Brijesh Singh <brijesh.singh@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Frank Rowand <frowand.list@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, devicetree@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, josh@joshtriplett.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, robh+dt@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, kbuild-all@01.org, devel@linuxdriverproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/26/18 at 11:01am, kbuild test robot wrote:
> Hi Baoquan,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.17-rc2 next-20180424]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Baoquan-He/resource-Use-list_head-to-link-sibling-resource/20180419-223752
> config: microblaze-mmu_defconfig (attached as .config)
> compiler: microblaze-linux-gcc (GCC) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=microblaze 
> 
> All errors (new ones prefixed by >>):

Thanks, below patch can fix it. Will repost including the fix.


diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 161f9758c631..56d189cb4be4 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -533,7 +533,9 @@ void pci_process_bridge_OF_ranges(struct pci_controller *hose,
 			res->flags = range.flags;
 			res->start = range.cpu_addr;
 			res->end = range.cpu_addr + range.size - 1;
-			res->parent = res->child = res->sibling = NULL;
+			res->parent = NULL;
+			INIT_LIST_HEAD(&res->child);
+			INIT_LIST_HEAD(&res->sibling);
 		}
 	}
 
@@ -625,28 +627,31 @@ EXPORT_SYMBOL(pcibios_add_device);
 static int __init reparent_resources(struct resource *parent,
 				     struct resource *res)
 {
-	struct resource *p, **pp;
-	struct resource **firstpp = NULL;
+	struct resource *p, *first = NULL;
 
-	for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
+	list_for_each_entry(p, &parent->child, sibling) {
 		if (p->end < res->start)
 			continue;
 		if (res->end < p->start)
 			break;
 		if (p->start < res->start || p->end > res->end)
 			return -1;	/* not completely contained */
-		if (firstpp == NULL)
-			firstpp = pp;
+		if (first == NULL)
+			first = p;
 	}
-	if (firstpp == NULL)
+	if (first == NULL)
 		return -1;	/* didn't find any conflicting entries? */
 	res->parent = parent;
-	res->child = *firstpp;
-	res->sibling = *pp;
-	*firstpp = res;
-	*pp = NULL;
-	for (p = res->child; p != NULL; p = p->sibling) {
-		p->parent = res;
+	list_add(&res->sibling, &p->sibling.prev);
+	INIT_LIST_HEAD(&res->child);
+
+	/*
+	 * From first to p's previous sibling, they all fall into
+	 * res's region, change them as res's children.
+	 */
+	list_cut_position(&res->child, first->sibling.prev, res->sibling.prev);
+	list_for_each_entry(p, &new->child, sibling) {
+                p->parent = new;
 		pr_debug("PCI: Reparented %s [%llx..%llx] under %s\n",
 			 p->name,
 			 (unsigned long long)p->start,

> 
>    arch/microblaze/pci/pci-common.c: In function 'pci_process_bridge_OF_ranges':
> >> arch/microblaze/pci/pci-common.c:536:44: error: incompatible types when assigning to type 'struct list_head' from type 'void *'
>        res->parent = res->child = res->sibling = NULL;
>                                                ^
>    arch/microblaze/pci/pci-common.c: In function 'reparent_resources':
> >> arch/microblaze/pci/pci-common.c:631:10: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>      for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
>              ^
>    arch/microblaze/pci/pci-common.c:631:50: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>      for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
>                                                      ^
> >> arch/microblaze/pci/pci-common.c:644:13: error: incompatible types when assigning to type 'struct list_head' from type 'struct resource *'
>      res->child = *firstpp;
>                 ^
>    arch/microblaze/pci/pci-common.c:645:15: error: incompatible types when assigning to type 'struct list_head' from type 'struct resource *'
>      res->sibling = *pp;
>                   ^
> >> arch/microblaze/pci/pci-common.c:648:9: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
>      for (p = res->child; p != NULL; p = p->sibling) {
>             ^
>    arch/microblaze/pci/pci-common.c:648:36: error: incompatible types when assigning to type 'struct resource *' from type 'struct list_head'
>      for (p = res->child; p != NULL; p = p->sibling) {
>                                        ^
>    cc1: some warnings being treated as errors
> 
> vim +536 arch/microblaze/pci/pci-common.c
> 
> d3afa58c Michal Simek        2010-01-18  387  
> d3afa58c Michal Simek        2010-01-18  388  /**
> d3afa58c Michal Simek        2010-01-18  389   * pci_process_bridge_OF_ranges - Parse PCI bridge resources from device tree
> d3afa58c Michal Simek        2010-01-18  390   * @hose: newly allocated pci_controller to be setup
> d3afa58c Michal Simek        2010-01-18  391   * @dev: device node of the host bridge
> d3afa58c Michal Simek        2010-01-18  392   * @primary: set if primary bus (32 bits only, soon to be deprecated)
> d3afa58c Michal Simek        2010-01-18  393   *
> d3afa58c Michal Simek        2010-01-18  394   * This function will parse the "ranges" property of a PCI host bridge device
> d3afa58c Michal Simek        2010-01-18  395   * node and setup the resource mapping of a pci controller based on its
> d3afa58c Michal Simek        2010-01-18  396   * content.
> d3afa58c Michal Simek        2010-01-18  397   *
> d3afa58c Michal Simek        2010-01-18  398   * Life would be boring if it wasn't for a few issues that we have to deal
> d3afa58c Michal Simek        2010-01-18  399   * with here:
> d3afa58c Michal Simek        2010-01-18  400   *
> d3afa58c Michal Simek        2010-01-18  401   *   - We can only cope with one IO space range and up to 3 Memory space
> d3afa58c Michal Simek        2010-01-18  402   *     ranges. However, some machines (thanks Apple !) tend to split their
> d3afa58c Michal Simek        2010-01-18  403   *     space into lots of small contiguous ranges. So we have to coalesce.
> d3afa58c Michal Simek        2010-01-18  404   *
> d3afa58c Michal Simek        2010-01-18  405   *   - We can only cope with all memory ranges having the same offset
> d3afa58c Michal Simek        2010-01-18  406   *     between CPU addresses and PCI addresses. Unfortunately, some bridges
> d3afa58c Michal Simek        2010-01-18  407   *     are setup for a large 1:1 mapping along with a small "window" which
> d3afa58c Michal Simek        2010-01-18  408   *     maps PCI address 0 to some arbitrary high address of the CPU space in
> d3afa58c Michal Simek        2010-01-18  409   *     order to give access to the ISA memory hole.
> d3afa58c Michal Simek        2010-01-18  410   *     The way out of here that I've chosen for now is to always set the
> d3afa58c Michal Simek        2010-01-18  411   *     offset based on the first resource found, then override it if we
> d3afa58c Michal Simek        2010-01-18  412   *     have a different offset and the previous was set by an ISA hole.
> d3afa58c Michal Simek        2010-01-18  413   *
> d3afa58c Michal Simek        2010-01-18  414   *   - Some busses have IO space not starting at 0, which causes trouble with
> d3afa58c Michal Simek        2010-01-18  415   *     the way we do our IO resource renumbering. The code somewhat deals with
> d3afa58c Michal Simek        2010-01-18  416   *     it for 64 bits but I would expect problems on 32 bits.
> d3afa58c Michal Simek        2010-01-18  417   *
> d3afa58c Michal Simek        2010-01-18  418   *   - Some 32 bits platforms such as 4xx can have physical space larger than
> d3afa58c Michal Simek        2010-01-18  419   *     32 bits so we need to use 64 bits values for the parsing
> d3afa58c Michal Simek        2010-01-18  420   */
> b881bc46 Greg Kroah-Hartman  2012-12-21  421  void pci_process_bridge_OF_ranges(struct pci_controller *hose,
> b881bc46 Greg Kroah-Hartman  2012-12-21  422  				  struct device_node *dev, int primary)
> d3afa58c Michal Simek        2010-01-18  423  {
> d3afa58c Michal Simek        2010-01-18  424  	int memno = 0, isa_hole = -1;
> d3afa58c Michal Simek        2010-01-18  425  	unsigned long long isa_mb = 0;
> d3afa58c Michal Simek        2010-01-18  426  	struct resource *res;
> 4f7b6de4 Andrew Murray       2013-07-27  427  	struct of_pci_range range;
> 4f7b6de4 Andrew Murray       2013-07-27  428  	struct of_pci_range_parser parser;
> d3afa58c Michal Simek        2010-01-18  429  
> f2b8ae0e Rob Herring         2017-06-06  430  	pr_info("PCI host bridge %pOF %s ranges:\n",
> f2b8ae0e Rob Herring         2017-06-06  431  	       dev, primary ? "(primary)" : "");
> d3afa58c Michal Simek        2010-01-18  432  
> 4f7b6de4 Andrew Murray       2013-07-27  433  	/* Check for ranges property */
> 4f7b6de4 Andrew Murray       2013-07-27  434  	if (of_pci_range_parser_init(&parser, dev))
> d3afa58c Michal Simek        2010-01-18  435  		return;
> d3afa58c Michal Simek        2010-01-18  436  
> d3afa58c Michal Simek        2010-01-18  437  	pr_debug("Parsing ranges property...\n");
> 4f7b6de4 Andrew Murray       2013-07-27  438  	for_each_of_pci_range(&parser, &range) {
> d3afa58c Michal Simek        2010-01-18  439  		/* Read next ranges element */
> 6bd55f0b Michal Simek        2012-12-27  440  		pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> 4f7b6de4 Andrew Murray       2013-07-27  441  				range.pci_space, range.pci_addr);
> 6bd55f0b Michal Simek        2012-12-27  442  		pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> 4f7b6de4 Andrew Murray       2013-07-27  443  					range.cpu_addr, range.size);
> d3afa58c Michal Simek        2010-01-18  444  
> d3afa58c Michal Simek        2010-01-18  445  		/* If we failed translation or got a zero-sized region
> d3afa58c Michal Simek        2010-01-18  446  		 * (some FW try to feed us with non sensical zero sized regions
> d3afa58c Michal Simek        2010-01-18  447  		 * such as power3 which look like some kind of attempt
> d3afa58c Michal Simek        2010-01-18  448  		 * at exposing the VGA memory hole)
> d3afa58c Michal Simek        2010-01-18  449  		 */
> 4f7b6de4 Andrew Murray       2013-07-27  450  		if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> d3afa58c Michal Simek        2010-01-18  451  			continue;
> d3afa58c Michal Simek        2010-01-18  452  
> d3afa58c Michal Simek        2010-01-18  453  		/* Act based on address space type */
> d3afa58c Michal Simek        2010-01-18  454  		res = NULL;
> 4f7b6de4 Andrew Murray       2013-07-27  455  		switch (range.flags & IORESOURCE_TYPE_BITS) {
> 4f7b6de4 Andrew Murray       2013-07-27  456  		case IORESOURCE_IO:
> 6bd55f0b Michal Simek        2012-12-27  457  			pr_info("  IO 0x%016llx..0x%016llx -> 0x%016llx\n",
> 4f7b6de4 Andrew Murray       2013-07-27  458  				range.cpu_addr, range.cpu_addr + range.size - 1,
> 4f7b6de4 Andrew Murray       2013-07-27  459  				range.pci_addr);
> d3afa58c Michal Simek        2010-01-18  460  
> d3afa58c Michal Simek        2010-01-18  461  			/* We support only one IO range */
> d3afa58c Michal Simek        2010-01-18  462  			if (hose->pci_io_size) {
> 6bd55f0b Michal Simek        2012-12-27  463  				pr_info(" \\--> Skipped (too many) !\n");
> d3afa58c Michal Simek        2010-01-18  464  				continue;
> d3afa58c Michal Simek        2010-01-18  465  			}
> d3afa58c Michal Simek        2010-01-18  466  			/* On 32 bits, limit I/O space to 16MB */
> 4f7b6de4 Andrew Murray       2013-07-27  467  			if (range.size > 0x01000000)
> 4f7b6de4 Andrew Murray       2013-07-27  468  				range.size = 0x01000000;
> d3afa58c Michal Simek        2010-01-18  469  
> d3afa58c Michal Simek        2010-01-18  470  			/* 32 bits needs to map IOs here */
> 4f7b6de4 Andrew Murray       2013-07-27  471  			hose->io_base_virt = ioremap(range.cpu_addr,
> 4f7b6de4 Andrew Murray       2013-07-27  472  						range.size);
> d3afa58c Michal Simek        2010-01-18  473  
> d3afa58c Michal Simek        2010-01-18  474  			/* Expect trouble if pci_addr is not 0 */
> d3afa58c Michal Simek        2010-01-18  475  			if (primary)
> d3afa58c Michal Simek        2010-01-18  476  				isa_io_base =
> d3afa58c Michal Simek        2010-01-18  477  					(unsigned long)hose->io_base_virt;
> d3afa58c Michal Simek        2010-01-18  478  			/* pci_io_size and io_base_phys always represent IO
> d3afa58c Michal Simek        2010-01-18  479  			 * space starting at 0 so we factor in pci_addr
> d3afa58c Michal Simek        2010-01-18  480  			 */
> 4f7b6de4 Andrew Murray       2013-07-27  481  			hose->pci_io_size = range.pci_addr + range.size;
> 4f7b6de4 Andrew Murray       2013-07-27  482  			hose->io_base_phys = range.cpu_addr - range.pci_addr;
> d3afa58c Michal Simek        2010-01-18  483  
> d3afa58c Michal Simek        2010-01-18  484  			/* Build resource */
> d3afa58c Michal Simek        2010-01-18  485  			res = &hose->io_resource;
> 4f7b6de4 Andrew Murray       2013-07-27  486  			range.cpu_addr = range.pci_addr;
> 4f7b6de4 Andrew Murray       2013-07-27  487  
> d3afa58c Michal Simek        2010-01-18  488  			break;
> 4f7b6de4 Andrew Murray       2013-07-27  489  		case IORESOURCE_MEM:
> 6bd55f0b Michal Simek        2012-12-27  490  			pr_info(" MEM 0x%016llx..0x%016llx -> 0x%016llx %s\n",
> 4f7b6de4 Andrew Murray       2013-07-27  491  				range.cpu_addr, range.cpu_addr + range.size - 1,
> 4f7b6de4 Andrew Murray       2013-07-27  492  				range.pci_addr,
> 4f7b6de4 Andrew Murray       2013-07-27  493  				(range.pci_space & 0x40000000) ?
> 4f7b6de4 Andrew Murray       2013-07-27  494  				"Prefetch" : "");
> d3afa58c Michal Simek        2010-01-18  495  
> d3afa58c Michal Simek        2010-01-18  496  			/* We support only 3 memory ranges */
> d3afa58c Michal Simek        2010-01-18  497  			if (memno >= 3) {
> 6bd55f0b Michal Simek        2012-12-27  498  				pr_info(" \\--> Skipped (too many) !\n");
> d3afa58c Michal Simek        2010-01-18  499  				continue;
> d3afa58c Michal Simek        2010-01-18  500  			}
> d3afa58c Michal Simek        2010-01-18  501  			/* Handles ISA memory hole space here */
> 4f7b6de4 Andrew Murray       2013-07-27  502  			if (range.pci_addr == 0) {
> 4f7b6de4 Andrew Murray       2013-07-27  503  				isa_mb = range.cpu_addr;
> d3afa58c Michal Simek        2010-01-18  504  				isa_hole = memno;
> d3afa58c Michal Simek        2010-01-18  505  				if (primary || isa_mem_base == 0)
> 4f7b6de4 Andrew Murray       2013-07-27  506  					isa_mem_base = range.cpu_addr;
> 4f7b6de4 Andrew Murray       2013-07-27  507  				hose->isa_mem_phys = range.cpu_addr;
> 4f7b6de4 Andrew Murray       2013-07-27  508  				hose->isa_mem_size = range.size;
> d3afa58c Michal Simek        2010-01-18  509  			}
> d3afa58c Michal Simek        2010-01-18  510  
> d3afa58c Michal Simek        2010-01-18  511  			/* We get the PCI/Mem offset from the first range or
> d3afa58c Michal Simek        2010-01-18  512  			 * the, current one if the offset came from an ISA
> d3afa58c Michal Simek        2010-01-18  513  			 * hole. If they don't match, bugger.
> d3afa58c Michal Simek        2010-01-18  514  			 */
> d3afa58c Michal Simek        2010-01-18  515  			if (memno == 0 ||
> 4f7b6de4 Andrew Murray       2013-07-27  516  			    (isa_hole >= 0 && range.pci_addr != 0 &&
> d3afa58c Michal Simek        2010-01-18  517  			     hose->pci_mem_offset == isa_mb))
> 4f7b6de4 Andrew Murray       2013-07-27  518  				hose->pci_mem_offset = range.cpu_addr -
> 4f7b6de4 Andrew Murray       2013-07-27  519  							range.pci_addr;
> 4f7b6de4 Andrew Murray       2013-07-27  520  			else if (range.pci_addr != 0 &&
> 4f7b6de4 Andrew Murray       2013-07-27  521  				 hose->pci_mem_offset != range.cpu_addr -
> 4f7b6de4 Andrew Murray       2013-07-27  522  							range.pci_addr) {
> 6bd55f0b Michal Simek        2012-12-27  523  				pr_info(" \\--> Skipped (offset mismatch) !\n");
> d3afa58c Michal Simek        2010-01-18  524  				continue;
> d3afa58c Michal Simek        2010-01-18  525  			}
> d3afa58c Michal Simek        2010-01-18  526  
> d3afa58c Michal Simek        2010-01-18  527  			/* Build resource */
> d3afa58c Michal Simek        2010-01-18  528  			res = &hose->mem_resources[memno++];
> d3afa58c Michal Simek        2010-01-18  529  			break;
> d3afa58c Michal Simek        2010-01-18  530  		}
> 70dcd942 Michal Simek        2014-10-27  531  		if (res != NULL) {
> 70dcd942 Michal Simek        2014-10-27  532  			res->name = dev->full_name;
> 70dcd942 Michal Simek        2014-10-27  533  			res->flags = range.flags;
> 70dcd942 Michal Simek        2014-10-27  534  			res->start = range.cpu_addr;
> 70dcd942 Michal Simek        2014-10-27  535  			res->end = range.cpu_addr + range.size - 1;
> 70dcd942 Michal Simek        2014-10-27 @536  			res->parent = res->child = res->sibling = NULL;
> 70dcd942 Michal Simek        2014-10-27  537  		}
> d3afa58c Michal Simek        2010-01-18  538  	}
> d3afa58c Michal Simek        2010-01-18  539  
> d3afa58c Michal Simek        2010-01-18  540  	/* If there's an ISA hole and the pci_mem_offset is -not- matching
> d3afa58c Michal Simek        2010-01-18  541  	 * the ISA hole offset, then we need to remove the ISA hole from
> d3afa58c Michal Simek        2010-01-18  542  	 * the resource list for that brige
> d3afa58c Michal Simek        2010-01-18  543  	 */
> d3afa58c Michal Simek        2010-01-18  544  	if (isa_hole >= 0 && hose->pci_mem_offset != isa_mb) {
> d3afa58c Michal Simek        2010-01-18  545  		unsigned int next = isa_hole + 1;
> 6bd55f0b Michal Simek        2012-12-27  546  		pr_info(" Removing ISA hole at 0x%016llx\n", isa_mb);
> d3afa58c Michal Simek        2010-01-18  547  		if (next < memno)
> d3afa58c Michal Simek        2010-01-18  548  			memmove(&hose->mem_resources[isa_hole],
> d3afa58c Michal Simek        2010-01-18  549  				&hose->mem_resources[next],
> d3afa58c Michal Simek        2010-01-18  550  				sizeof(struct resource) * (memno - next));
> d3afa58c Michal Simek        2010-01-18  551  		hose->mem_resources[--memno].flags = 0;
> d3afa58c Michal Simek        2010-01-18  552  	}
> d3afa58c Michal Simek        2010-01-18  553  }
> d3afa58c Michal Simek        2010-01-18  554  
> 9413d968 Bharat Kumar Gogada 2016-09-01  555  /* Display the domain number in /proc */
> d3afa58c Michal Simek        2010-01-18  556  int pci_proc_domain(struct pci_bus *bus)
> d3afa58c Michal Simek        2010-01-18  557  {
> 9413d968 Bharat Kumar Gogada 2016-09-01  558  	return pci_domain_nr(bus);
> d3afa58c Michal Simek        2010-01-18  559  }
> d3afa58c Michal Simek        2010-01-18  560  
> d3afa58c Michal Simek        2010-01-18  561  /* This header fixup will do the resource fixup for all devices as they are
> d3afa58c Michal Simek        2010-01-18  562   * probed, but not for bridge ranges
> d3afa58c Michal Simek        2010-01-18  563   */
> b881bc46 Greg Kroah-Hartman  2012-12-21  564  static void pcibios_fixup_resources(struct pci_dev *dev)
> d3afa58c Michal Simek        2010-01-18  565  {
> d3afa58c Michal Simek        2010-01-18  566  	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> d3afa58c Michal Simek        2010-01-18  567  	int i;
> d3afa58c Michal Simek        2010-01-18  568  
> d3afa58c Michal Simek        2010-01-18  569  	if (!hose) {
> 6bd55f0b Michal Simek        2012-12-27  570  		pr_err("No host bridge for PCI dev %s !\n",
> d3afa58c Michal Simek        2010-01-18  571  		       pci_name(dev));
> d3afa58c Michal Simek        2010-01-18  572  		return;
> d3afa58c Michal Simek        2010-01-18  573  	}
> d3afa58c Michal Simek        2010-01-18  574  	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> d3afa58c Michal Simek        2010-01-18  575  		struct resource *res = dev->resource + i;
> d3afa58c Michal Simek        2010-01-18  576  		if (!res->flags)
> d3afa58c Michal Simek        2010-01-18  577  			continue;
> e5b36841 Bjorn Helgaas       2012-02-23  578  		if (res->start == 0) {
> 6bd55f0b Michal Simek        2012-12-27  579  			pr_debug("PCI:%s Resource %d %016llx-%016llx [%x]",
> d3afa58c Michal Simek        2010-01-18  580  				 pci_name(dev), i,
> d3afa58c Michal Simek        2010-01-18  581  				 (unsigned long long)res->start,
> d3afa58c Michal Simek        2010-01-18  582  				 (unsigned long long)res->end,
> d3afa58c Michal Simek        2010-01-18  583  				 (unsigned int)res->flags);
> 6bd55f0b Michal Simek        2012-12-27  584  			pr_debug("is unassigned\n");
> d3afa58c Michal Simek        2010-01-18  585  			res->end -= res->start;
> d3afa58c Michal Simek        2010-01-18  586  			res->start = 0;
> d3afa58c Michal Simek        2010-01-18  587  			res->flags |= IORESOURCE_UNSET;
> d3afa58c Michal Simek        2010-01-18  588  			continue;
> d3afa58c Michal Simek        2010-01-18  589  		}
> d3afa58c Michal Simek        2010-01-18  590  
> aa23bdc0 Bjorn Helgaas       2012-02-23  591  		pr_debug("PCI:%s Resource %d %016llx-%016llx [%x]\n",
> d3afa58c Michal Simek        2010-01-18  592  			 pci_name(dev), i,
> 6bd55f0b Michal Simek        2012-12-27  593  			 (unsigned long long)res->start,
> d3afa58c Michal Simek        2010-01-18  594  			 (unsigned long long)res->end,
> d3afa58c Michal Simek        2010-01-18  595  			 (unsigned int)res->flags);
> d3afa58c Michal Simek        2010-01-18  596  	}
> d3afa58c Michal Simek        2010-01-18  597  }
> d3afa58c Michal Simek        2010-01-18  598  DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pcibios_fixup_resources);
> d3afa58c Michal Simek        2010-01-18  599  
> d3afa58c Michal Simek        2010-01-18  600  /*
> d3afa58c Michal Simek        2010-01-18  601   * We need to avoid collisions with `mirrored' VGA ports
> d3afa58c Michal Simek        2010-01-18  602   * and other strange ISA hardware, so we always want the
> d3afa58c Michal Simek        2010-01-18  603   * addresses to be allocated in the 0x000-0x0ff region
> d3afa58c Michal Simek        2010-01-18  604   * modulo 0x400.
> d3afa58c Michal Simek        2010-01-18  605   *
> d3afa58c Michal Simek        2010-01-18  606   * Why? Because some silly external IO cards only decode
> d3afa58c Michal Simek        2010-01-18  607   * the low 10 bits of the IO address. The 0x00-0xff region
> d3afa58c Michal Simek        2010-01-18  608   * is reserved for motherboard devices that decode all 16
> d3afa58c Michal Simek        2010-01-18  609   * bits, so it's ok to allocate at, say, 0x2800-0x28ff,
> d3afa58c Michal Simek        2010-01-18  610   * but we want to try to avoid allocating at 0x2900-0x2bff
> d3afa58c Michal Simek        2010-01-18  611   * which might have be mirrored at 0x0100-0x03ff..
> d3afa58c Michal Simek        2010-01-18  612   */
> 01cf9d52 Bharat Kumar Gogada 2016-02-11  613  int pcibios_add_device(struct pci_dev *dev)
> 01cf9d52 Bharat Kumar Gogada 2016-02-11  614  {
> 01cf9d52 Bharat Kumar Gogada 2016-02-11  615  	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> c86fac43 Michal Simek        2010-04-16  616  
> 01cf9d52 Bharat Kumar Gogada 2016-02-11  617  	return 0;
> d3afa58c Michal Simek        2010-01-18  618  }
> 01cf9d52 Bharat Kumar Gogada 2016-02-11  619  EXPORT_SYMBOL(pcibios_add_device);
> d3afa58c Michal Simek        2010-01-18  620  
> d3afa58c Michal Simek        2010-01-18  621  /*
> d3afa58c Michal Simek        2010-01-18  622   * Reparent resource children of pr that conflict with res
> d3afa58c Michal Simek        2010-01-18  623   * under res, and make res replace those children.
> d3afa58c Michal Simek        2010-01-18  624   */
> d3afa58c Michal Simek        2010-01-18  625  static int __init reparent_resources(struct resource *parent,
> d3afa58c Michal Simek        2010-01-18  626  				     struct resource *res)
> d3afa58c Michal Simek        2010-01-18  627  {
> d3afa58c Michal Simek        2010-01-18  628  	struct resource *p, **pp;
> d3afa58c Michal Simek        2010-01-18  629  	struct resource **firstpp = NULL;
> d3afa58c Michal Simek        2010-01-18  630  
> d3afa58c Michal Simek        2010-01-18 @631  	for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
> d3afa58c Michal Simek        2010-01-18  632  		if (p->end < res->start)
> d3afa58c Michal Simek        2010-01-18  633  			continue;
> d3afa58c Michal Simek        2010-01-18  634  		if (res->end < p->start)
> d3afa58c Michal Simek        2010-01-18  635  			break;
> d3afa58c Michal Simek        2010-01-18  636  		if (p->start < res->start || p->end > res->end)
> d3afa58c Michal Simek        2010-01-18  637  			return -1;	/* not completely contained */
> d3afa58c Michal Simek        2010-01-18  638  		if (firstpp == NULL)
> d3afa58c Michal Simek        2010-01-18  639  			firstpp = pp;
> d3afa58c Michal Simek        2010-01-18  640  	}
> d3afa58c Michal Simek        2010-01-18  641  	if (firstpp == NULL)
> d3afa58c Michal Simek        2010-01-18  642  		return -1;	/* didn't find any conflicting entries? */
> d3afa58c Michal Simek        2010-01-18  643  	res->parent = parent;
> d3afa58c Michal Simek        2010-01-18 @644  	res->child = *firstpp;
> d3afa58c Michal Simek        2010-01-18  645  	res->sibling = *pp;
> d3afa58c Michal Simek        2010-01-18  646  	*firstpp = res;
> d3afa58c Michal Simek        2010-01-18  647  	*pp = NULL;
> d3afa58c Michal Simek        2010-01-18 @648  	for (p = res->child; p != NULL; p = p->sibling) {
> d3afa58c Michal Simek        2010-01-18  649  		p->parent = res;
> d3afa58c Michal Simek        2010-01-18  650  		pr_debug("PCI: Reparented %s [%llx..%llx] under %s\n",
> d3afa58c Michal Simek        2010-01-18  651  			 p->name,
> d3afa58c Michal Simek        2010-01-18  652  			 (unsigned long long)p->start,
> d3afa58c Michal Simek        2010-01-18  653  			 (unsigned long long)p->end, res->name);
> d3afa58c Michal Simek        2010-01-18  654  	}
> d3afa58c Michal Simek        2010-01-18  655  	return 0;
> d3afa58c Michal Simek        2010-01-18  656  }
> d3afa58c Michal Simek        2010-01-18  657  
> 
> :::::: The code at line 536 was first introduced by commit
> :::::: 70dcd942dc4af3cc6c3dcc2ba499cd841c7f65a7 microblaze: Fix IO space breakage after of_pci_range_to_resource() change
> 
> :::::: TO: Michal Simek <michal.simek@xilinx.com>
> :::::: CC: Michal Simek <michal.simek@xilinx.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
