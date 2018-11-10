Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE12221184AAC
 for <linux-nvdimm@lists.01.org>; Sat, 10 Nov 2018 02:47:13 -0800 (PST)
Date: Sat, 10 Nov 2018 18:46:25 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [linux-nvdimm:for-5.0/nvdimm-security 2/17]
 arch/powerpc//platforms/pseries/papr_scm.c:219:14: error: too few arguments
 to function 'nvdimm_create'
Message-ID: <201811101821.6gdlPSK3%fengguang.wu@intel.com>
MIME-Version: 1.0
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
Cc: kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git for-5.0/nvdimm-security
head:   bddbf9de5dcd455addac2862e8bc3f41881d29f7
commit: 625fea4fc86b6dca5a43b5882f23f537088571a6 [2/17] acpi/nfit, libnvdimm: Store dimm id as a member to struct nvdimm
config: powerpc64-allyesconfig (attached as .config)
compiler: powerpc64-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 625fea4fc86b6dca5a43b5882f23f537088571a6
        # save the attached .config to linux build tree
        GCC_VERSION=7.2.0 make.cross ARCH=powerpc64 

Note: the linux-nvdimm/for-5.0/nvdimm-security HEAD bddbf9de5dcd455addac2862e8bc3f41881d29f7 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   arch/powerpc//platforms/pseries/papr_scm.c: In function 'papr_scm_nvdimm_init':
>> arch/powerpc//platforms/pseries/papr_scm.c:219:14: error: too few arguments to function 'nvdimm_create'
     p->nvdimm = nvdimm_create(p->bus, p, papr_scm_dimm_groups,
                 ^~~~~~~~~~~~~
   In file included from arch/powerpc//platforms/pseries/papr_scm.c:12:0:
   include/linux/libnvdimm.h:178:16: note: declared here
    struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
                   ^~~~~~~~~~~~~

vim +/nvdimm_create +219 arch/powerpc//platforms/pseries/papr_scm.c

b5beae5e Oliver O'Halloran 2018-10-15  193  
b5beae5e Oliver O'Halloran 2018-10-15  194  static int papr_scm_nvdimm_init(struct papr_scm_priv *p)
b5beae5e Oliver O'Halloran 2018-10-15  195  {
b5beae5e Oliver O'Halloran 2018-10-15  196  	struct device *dev = &p->pdev->dev;
b5beae5e Oliver O'Halloran 2018-10-15  197  	struct nd_mapping_desc mapping;
b5beae5e Oliver O'Halloran 2018-10-15  198  	struct nd_region_desc ndr_desc;
b5beae5e Oliver O'Halloran 2018-10-15  199  	unsigned long dimm_flags;
b5beae5e Oliver O'Halloran 2018-10-15  200  
b5beae5e Oliver O'Halloran 2018-10-15  201  	p->bus_desc.ndctl = papr_scm_ndctl;
b5beae5e Oliver O'Halloran 2018-10-15  202  	p->bus_desc.module = THIS_MODULE;
b5beae5e Oliver O'Halloran 2018-10-15  203  	p->bus_desc.of_node = p->pdev->dev.of_node;
b5beae5e Oliver O'Halloran 2018-10-15  204  	p->bus_desc.attr_groups = bus_attr_groups;
b5beae5e Oliver O'Halloran 2018-10-15  205  	p->bus_desc.provider_name = kstrdup(p->pdev->name, GFP_KERNEL);
b5beae5e Oliver O'Halloran 2018-10-15  206  
b5beae5e Oliver O'Halloran 2018-10-15  207  	if (!p->bus_desc.provider_name)
b5beae5e Oliver O'Halloran 2018-10-15  208  		return -ENOMEM;
b5beae5e Oliver O'Halloran 2018-10-15  209  
b5beae5e Oliver O'Halloran 2018-10-15  210  	p->bus = nvdimm_bus_register(NULL, &p->bus_desc);
b5beae5e Oliver O'Halloran 2018-10-15  211  	if (!p->bus) {
b5beae5e Oliver O'Halloran 2018-10-15  212  		dev_err(dev, "Error creating nvdimm bus %pOF\n", p->dn);
b5beae5e Oliver O'Halloran 2018-10-15  213  		return -ENXIO;
b5beae5e Oliver O'Halloran 2018-10-15  214  	}
b5beae5e Oliver O'Halloran 2018-10-15  215  
b5beae5e Oliver O'Halloran 2018-10-15  216  	dimm_flags = 0;
b5beae5e Oliver O'Halloran 2018-10-15  217  	set_bit(NDD_ALIASING, &dimm_flags);
b5beae5e Oliver O'Halloran 2018-10-15  218  
b5beae5e Oliver O'Halloran 2018-10-15 @219  	p->nvdimm = nvdimm_create(p->bus, p, papr_scm_dimm_groups,
b5beae5e Oliver O'Halloran 2018-10-15  220  				dimm_flags, PAPR_SCM_DIMM_CMD_MASK, 0, NULL);
b5beae5e Oliver O'Halloran 2018-10-15  221  	if (!p->nvdimm) {
b5beae5e Oliver O'Halloran 2018-10-15  222  		dev_err(dev, "Error creating DIMM object for %pOF\n", p->dn);
b5beae5e Oliver O'Halloran 2018-10-15  223  		goto err;
b5beae5e Oliver O'Halloran 2018-10-15  224  	}
b5beae5e Oliver O'Halloran 2018-10-15  225  
b5beae5e Oliver O'Halloran 2018-10-15  226  	/* now add the region */
b5beae5e Oliver O'Halloran 2018-10-15  227  
b5beae5e Oliver O'Halloran 2018-10-15  228  	memset(&mapping, 0, sizeof(mapping));
b5beae5e Oliver O'Halloran 2018-10-15  229  	mapping.nvdimm = p->nvdimm;
b5beae5e Oliver O'Halloran 2018-10-15  230  	mapping.start = 0;
b5beae5e Oliver O'Halloran 2018-10-15  231  	mapping.size = p->blocks * p->block_size; // XXX: potential overflow?
b5beae5e Oliver O'Halloran 2018-10-15  232  
b5beae5e Oliver O'Halloran 2018-10-15  233  	memset(&ndr_desc, 0, sizeof(ndr_desc));
b5beae5e Oliver O'Halloran 2018-10-15  234  	ndr_desc.attr_groups = region_attr_groups;
b5beae5e Oliver O'Halloran 2018-10-15  235  	ndr_desc.numa_node = dev_to_node(&p->pdev->dev);
b5beae5e Oliver O'Halloran 2018-10-15  236  	ndr_desc.res = &p->res;
b5beae5e Oliver O'Halloran 2018-10-15  237  	ndr_desc.of_node = p->dn;
b5beae5e Oliver O'Halloran 2018-10-15  238  	ndr_desc.provider_data = p;
b5beae5e Oliver O'Halloran 2018-10-15  239  	ndr_desc.mapping = &mapping;
b5beae5e Oliver O'Halloran 2018-10-15  240  	ndr_desc.num_mappings = 1;
b5beae5e Oliver O'Halloran 2018-10-15  241  	ndr_desc.nd_set = &p->nd_set;
b5beae5e Oliver O'Halloran 2018-10-15  242  	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
b5beae5e Oliver O'Halloran 2018-10-15  243  
b5beae5e Oliver O'Halloran 2018-10-15  244  	p->region = nvdimm_pmem_region_create(p->bus, &ndr_desc);
b5beae5e Oliver O'Halloran 2018-10-15  245  	if (!p->region) {
b5beae5e Oliver O'Halloran 2018-10-15  246  		dev_err(dev, "Error registering region %pR from %pOF\n",
b5beae5e Oliver O'Halloran 2018-10-15  247  				ndr_desc.res, p->dn);
b5beae5e Oliver O'Halloran 2018-10-15  248  		goto err;
b5beae5e Oliver O'Halloran 2018-10-15  249  	}
b5beae5e Oliver O'Halloran 2018-10-15  250  
b5beae5e Oliver O'Halloran 2018-10-15  251  	return 0;
b5beae5e Oliver O'Halloran 2018-10-15  252  

:::::: The code at line 219 was first introduced by commit
:::::: b5beae5e224f1c72c4482b0ab36fc3d89481a6b2 powerpc/pseries: Add driver for PAPR SCM regions

:::::: TO: Oliver O'Halloran <oohall@gmail.com>
:::::: CC: Michael Ellerman <mpe@ellerman.id.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
