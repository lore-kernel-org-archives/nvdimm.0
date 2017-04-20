Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E986F20082EEA
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 22:47:39 -0700 (PDT)
Date: Thu, 20 Apr 2017 13:46:55 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3] axon_ram: add dax_operations support
Message-ID: <201704201331.ZRvwTFof%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <149264111867.36586.15762148888692084363.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test WARNING on powerpc/next]
[also build test WARNING on v4.11-rc7 next-20170419]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/axon_ram-add-dax_operations-support/20170420-091615
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
config: powerpc-allyesconfig (attached as .config)
compiler: powerpc64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=powerpc 

All warnings (new ones prefixed by >>):

   arch/powerpc/sysdev/axonram.c: In function 'axon_ram_dax_direct_access':
   arch/powerpc/sysdev/axonram.c:176:31: error: implicit declaration of function 'dax_get_private' [-Werror=implicit-function-declaration]
     struct axon_ram_bank *bank = dax_get_private(dax_dev);
                                  ^~~~~~~~~~~~~~~
>> arch/powerpc/sysdev/axonram.c:176:31: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
   arch/powerpc/sysdev/axonram.c: At top level:
   arch/powerpc/sysdev/axonram.c:181:21: error: variable 'axon_ram_dax_ops' has initializer but incomplete type
    static const struct dax_operations axon_ram_dax_ops = {
                        ^~~~~~~~~~~~~~
   arch/powerpc/sysdev/axonram.c:182:2: error: unknown field 'direct_access' specified in initializer
     .direct_access = axon_ram_dax_direct_access,
     ^
>> arch/powerpc/sysdev/axonram.c:182:19: warning: excess elements in struct initializer
     .direct_access = axon_ram_dax_direct_access,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/sysdev/axonram.c:182:19: note: (near initialization for 'axon_ram_dax_ops')
   arch/powerpc/sysdev/axonram.c: In function 'axon_ram_probe':
   arch/powerpc/sysdev/axonram.c:255:18: error: implicit declaration of function 'alloc_dax' [-Werror=implicit-function-declaration]
     bank->dax_dev = alloc_dax(bank, bank->disk->disk_name,
                     ^~~~~~~~~
>> arch/powerpc/sysdev/axonram.c:255:16: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     bank->dax_dev = alloc_dax(bank, bank->disk->disk_name,
                   ^
   arch/powerpc/sysdev/axonram.c:313:3: error: implicit declaration of function 'kill_dax' [-Werror=implicit-function-declaration]
      kill_dax(bank->dax_dev);
      ^~~~~~~~
   arch/powerpc/sysdev/axonram.c:314:3: error: implicit declaration of function 'put_dax' [-Werror=implicit-function-declaration]
      put_dax(bank->dax_dev);
      ^~~~~~~
   arch/powerpc/sysdev/axonram.c: At top level:
   arch/powerpc/sysdev/axonram.c:181:36: error: storage size of 'axon_ram_dax_ops' isn't known
    static const struct dax_operations axon_ram_dax_ops = {
                                       ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +176 arch/powerpc/sysdev/axonram.c

   170	};
   171	
   172	static long
   173	axon_ram_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
   174			       void **kaddr, pfn_t *pfn)
   175	{
 > 176		struct axon_ram_bank *bank = dax_get_private(dax_dev);
   177	
   178		return __axon_ram_direct_access(bank, pgoff, nr_pages, kaddr, pfn);
   179	}
   180	
   181	static const struct dax_operations axon_ram_dax_ops = {
 > 182		.direct_access = axon_ram_dax_direct_access,
   183	};
   184	
   185	/**
   186	 * axon_ram_probe - probe() method for platform driver
   187	 * @device: see platform_driver method
   188	 */
   189	static int axon_ram_probe(struct platform_device *device)
   190	{
   191		static int axon_ram_bank_id = -1;
   192		struct axon_ram_bank *bank;
   193		struct resource resource;
   194		int rc = 0;
   195	
   196		axon_ram_bank_id++;
   197	
   198		dev_info(&device->dev, "Found memory controller on %s\n",
   199				device->dev.of_node->full_name);
   200	
   201		bank = kzalloc(sizeof(struct axon_ram_bank), GFP_KERNEL);
   202		if (bank == NULL) {
   203			dev_err(&device->dev, "Out of memory\n");
   204			rc = -ENOMEM;
   205			goto failed;
   206		}
   207	
   208		device->dev.platform_data = bank;
   209	
   210		bank->device = device;
   211	
   212		if (of_address_to_resource(device->dev.of_node, 0, &resource) != 0) {
   213			dev_err(&device->dev, "Cannot access device tree\n");
   214			rc = -EFAULT;
   215			goto failed;
   216		}
   217	
   218		bank->size = resource_size(&resource);
   219	
   220		if (bank->size == 0) {
   221			dev_err(&device->dev, "No DDR2 memory found for %s%d\n",
   222					AXON_RAM_DEVICE_NAME, axon_ram_bank_id);
   223			rc = -ENODEV;
   224			goto failed;
   225		}
   226	
   227		dev_info(&device->dev, "Register DDR2 memory device %s%d with %luMB\n",
   228				AXON_RAM_DEVICE_NAME, axon_ram_bank_id, bank->size >> 20);
   229	
   230		bank->ph_addr = resource.start;
   231		bank->io_addr = (unsigned long) ioremap_prot(
   232				bank->ph_addr, bank->size, _PAGE_NO_CACHE);
   233		if (bank->io_addr == 0) {
   234			dev_err(&device->dev, "ioremap() failed\n");
   235			rc = -EFAULT;
   236			goto failed;
   237		}
   238	
   239		bank->disk = alloc_disk(AXON_RAM_MINORS_PER_DISK);
   240		if (bank->disk == NULL) {
   241			dev_err(&device->dev, "Cannot register disk\n");
   242			rc = -EFAULT;
   243			goto failed;
   244		}
   245	
   246	
   247		bank->disk->major = azfs_major;
   248		bank->disk->first_minor = azfs_minor;
   249		bank->disk->fops = &axon_ram_devops;
   250		bank->disk->private_data = bank;
   251	
   252		sprintf(bank->disk->disk_name, "%s%d",
   253				AXON_RAM_DEVICE_NAME, axon_ram_bank_id);
   254	
 > 255		bank->dax_dev = alloc_dax(bank, bank->disk->disk_name,
   256				&axon_ram_dax_ops);
   257		if (!bank->dax_dev) {
   258			rc = -ENOMEM;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
