Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321E1820DE
 for <linux-nvdimm@lists.01.org>; Fri,  3 Feb 2017 19:52:35 -0800 (PST)
Date: Sat, 4 Feb 2017 11:51:57 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <201702041153.JZlQT4wK%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
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
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, vbabka@suse.cz, dave.hansen@linux.intel.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, jack@suse.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

[auto build test WARNING on mmotm/master]
[cannot apply to linus/master linux/master v4.10-rc6 next-20170203]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/mm-replace-FAULT_FLAG_SIZE-with-parameter-to-huge_fault/20170204-053548
base:   git://git.cmpxchg.org/linux-mmotm.git master
config: x86_64-randconfig-in0-02040556 (attached as .config)
compiler: gcc-4.6 (Debian 4.6.4-7) 4.6.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   fs/ext4/file.c:280:1: error: conflicting types for 'ext4_dax_huge_fault'
   fs/ext4/file.c:258:12: note: previous definition of 'ext4_dax_huge_fault' was here
   fs/ext4/file.c: In function 'ext4_dax_huge_fault':
   fs/ext4/file.c:292:2: error: incompatible type for argument 2 of 'dax_iomap_fault'
   include/linux/dax.h:41:5: note: expected 'enum page_entry_size' but argument is of type 'struct iomap_ops *'
   fs/ext4/file.c:292:2: error: too few arguments to function 'dax_iomap_fault'
   include/linux/dax.h:41:5: note: declared here
   fs/ext4/file.c: In function 'ext4_dax_fault':
   fs/ext4/file.c:302:2: error: too many arguments to function 'ext4_dax_huge_fault'
   fs/ext4/file.c:280:1: note: declared here
   fs/ext4/file.c: At top level:
>> fs/ext4/file.c:337:2: warning: initialization from incompatible pointer type [enabled by default]
   fs/ext4/file.c:337:2: warning: (near initialization for 'ext4_dax_vm_ops.huge_fault') [enabled by default]
   fs/ext4/file.c:258:12: warning: 'ext4_dax_huge_fault' defined but not used [-Wunused-function]

vim +337 fs/ext4/file.c

   286	
   287		if (write) {
   288			sb_start_pagefault(sb);
   289			file_update_time(vmf->vma->vm_file);
   290		}
   291		down_read(&EXT4_I(inode)->i_mmap_sem);
 > 292		result = dax_iomap_fault(vmf, &ext4_iomap_ops);
   293		up_read(&EXT4_I(inode)->i_mmap_sem);
   294		if (write)
   295			sb_end_pagefault(sb);
   296	
   297		return result;
   298	}
   299	
   300	static int ext4_dax_fault(struct vm_fault *vmf)
   301	{
   302		return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
   303	}
   304	
   305	/*
   306	 * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
   307	 * handler we check for races agaist truncate. Note that since we cycle through
   308	 * i_mmap_sem, we are sure that also any hole punching that began before we
   309	 * were called is finished by now and so if it included part of the file we
   310	 * are working on, our pte will get unmapped and the check for pte_same() in
   311	 * wp_pfn_shared() fails. Thus fault gets retried and things work out as
   312	 * desired.
   313	 */
   314	static int ext4_dax_pfn_mkwrite(struct vm_fault *vmf)
   315	{
   316		struct inode *inode = file_inode(vmf->vma->vm_file);
   317		struct super_block *sb = inode->i_sb;
   318		loff_t size;
   319		int ret;
   320	
   321		sb_start_pagefault(sb);
   322		file_update_time(vmf->vma->vm_file);
   323		down_read(&EXT4_I(inode)->i_mmap_sem);
   324		size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
   325		if (vmf->pgoff >= size)
   326			ret = VM_FAULT_SIGBUS;
   327		else
   328			ret = dax_pfn_mkwrite(vmf);
   329		up_read(&EXT4_I(inode)->i_mmap_sem);
   330		sb_end_pagefault(sb);
   331	
   332		return ret;
   333	}
   334	
   335	static const struct vm_operations_struct ext4_dax_vm_ops = {
   336		.fault		= ext4_dax_fault,
 > 337		.huge_fault	= ext4_dax_huge_fault,
   338		.page_mkwrite	= ext4_dax_fault,
   339		.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
   340	};

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
