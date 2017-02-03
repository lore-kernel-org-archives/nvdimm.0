Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62FE982059
 for <linux-nvdimm@lists.01.org>; Fri,  3 Feb 2017 14:57:19 -0800 (PST)
Date: Sat, 4 Feb 2017 06:56:38 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <201702040648.oOjnlEcm%fengguang.wu@intel.com>
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

[auto build test ERROR on mmotm/master]
[cannot apply to linus/master linux/master v4.10-rc6 next-20170203]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/mm-replace-FAULT_FLAG_SIZE-with-parameter-to-huge_fault/20170204-053548
base:   git://git.cmpxchg.org/linux-mmotm.git master
config: i386-randconfig-x004-201705 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

>> fs/ext4/file.c:280:1: error: conflicting types for 'ext4_dax_huge_fault'
    ext4_dax_huge_fault(struct vm_fault *vmf)
    ^~~~~~~~~~~~~~~~~~~
   fs/ext4/file.c:258:12: note: previous definition of 'ext4_dax_huge_fault' was here
    static int ext4_dax_huge_fault(struct vm_fault *vmf,
               ^~~~~~~~~~~~~~~~~~~
   fs/ext4/file.c: In function 'ext4_dax_huge_fault':
>> fs/ext4/file.c:292:32: error: incompatible type for argument 2 of 'dax_iomap_fault'
     result = dax_iomap_fault(vmf, &ext4_iomap_ops);
                                   ^
   In file included from fs/ext4/file.c:25:0:
   include/linux/dax.h:41:5: note: expected 'enum page_entry_size' but argument is of type 'struct iomap_ops *'
    int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
        ^~~~~~~~~~~~~~~
>> fs/ext4/file.c:292:11: error: too few arguments to function 'dax_iomap_fault'
     result = dax_iomap_fault(vmf, &ext4_iomap_ops);
              ^~~~~~~~~~~~~~~
   In file included from fs/ext4/file.c:25:0:
   include/linux/dax.h:41:5: note: declared here
    int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
        ^~~~~~~~~~~~~~~
   fs/ext4/file.c: In function 'ext4_dax_fault':
>> fs/ext4/file.c:302:9: error: too many arguments to function 'ext4_dax_huge_fault'
     return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
            ^~~~~~~~~~~~~~~~~~~
   fs/ext4/file.c:280:1: note: declared here
    ext4_dax_huge_fault(struct vm_fault *vmf)
    ^~~~~~~~~~~~~~~~~~~
   fs/ext4/file.c: At top level:
>> fs/ext4/file.c:337:16: error: initialization from incompatible pointer type [-Werror=incompatible-pointer-types]
     .huge_fault = ext4_dax_huge_fault,
                   ^~~~~~~~~~~~~~~~~~~
   fs/ext4/file.c:337:16: note: (near initialization for 'ext4_dax_vm_ops.huge_fault')
   fs/ext4/file.c:258:12: warning: 'ext4_dax_huge_fault' defined but not used [-Wunused-function]
    static int ext4_dax_huge_fault(struct vm_fault *vmf,
               ^~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/ext4_dax_huge_fault +280 fs/ext4/file.c

01a33b4ac Matthew Wilcox 2015-09-08  274  		sb_end_pagefault(sb);
01a33b4ac Matthew Wilcox 2015-09-08  275  
01a33b4ac Matthew Wilcox 2015-09-08  276  	return result;
923ae0ff9 Ross Zwisler   2015-02-16  277  }
923ae0ff9 Ross Zwisler   2015-02-16  278  
c6da0697e Dave Jiang     2017-02-02  279  static int
30599588c Dave Jiang     2017-02-02 @280  ext4_dax_huge_fault(struct vm_fault *vmf)
11bd1a9ec Matthew Wilcox 2015-09-08  281  {
01a33b4ac Matthew Wilcox 2015-09-08  282  	int result;
e6ae40ec2 Dave Jiang     2017-02-02  283  	struct inode *inode = file_inode(vmf->vma->vm_file);
01a33b4ac Matthew Wilcox 2015-09-08  284  	struct super_block *sb = inode->i_sb;
c6da0697e Dave Jiang     2017-02-02  285  	bool write = vmf->flags & FAULT_FLAG_WRITE;
01a33b4ac Matthew Wilcox 2015-09-08  286  
01a33b4ac Matthew Wilcox 2015-09-08  287  	if (write) {
01a33b4ac Matthew Wilcox 2015-09-08  288  		sb_start_pagefault(sb);
e6ae40ec2 Dave Jiang     2017-02-02  289  		file_update_time(vmf->vma->vm_file);
1db175428 Jan Kara       2016-10-21  290  	}
ea3d7209c Jan Kara       2015-12-07  291  	down_read(&EXT4_I(inode)->i_mmap_sem);
30599588c Dave Jiang     2017-02-02 @292  	result = dax_iomap_fault(vmf, &ext4_iomap_ops);
ea3d7209c Jan Kara       2015-12-07  293  	up_read(&EXT4_I(inode)->i_mmap_sem);
1db175428 Jan Kara       2016-10-21  294  	if (write)
01a33b4ac Matthew Wilcox 2015-09-08  295  		sb_end_pagefault(sb);
01a33b4ac Matthew Wilcox 2015-09-08  296  
01a33b4ac Matthew Wilcox 2015-09-08  297  	return result;
11bd1a9ec Matthew Wilcox 2015-09-08  298  }
11bd1a9ec Matthew Wilcox 2015-09-08  299  
22711acc4 Dave Jiang     2017-02-03  300  static int ext4_dax_fault(struct vm_fault *vmf)
22711acc4 Dave Jiang     2017-02-03  301  {
22711acc4 Dave Jiang     2017-02-03 @302  	return ext4_dax_huge_fault(vmf, PE_SIZE_PTE);
22711acc4 Dave Jiang     2017-02-03  303  }
22711acc4 Dave Jiang     2017-02-03  304  
ea3d7209c Jan Kara       2015-12-07  305  /*
1e9d180ba Ross Zwisler   2016-02-27  306   * Handle write fault for VM_MIXEDMAP mappings. Similarly to ext4_dax_fault()
ea3d7209c Jan Kara       2015-12-07  307   * handler we check for races agaist truncate. Note that since we cycle through
ea3d7209c Jan Kara       2015-12-07  308   * i_mmap_sem, we are sure that also any hole punching that began before we
ea3d7209c Jan Kara       2015-12-07  309   * were called is finished by now and so if it included part of the file we
ea3d7209c Jan Kara       2015-12-07  310   * are working on, our pte will get unmapped and the check for pte_same() in
ea3d7209c Jan Kara       2015-12-07  311   * wp_pfn_shared() fails. Thus fault gets retried and things work out as
ea3d7209c Jan Kara       2015-12-07  312   * desired.
ea3d7209c Jan Kara       2015-12-07  313   */
1ebf3e0da Dave Jiang     2017-02-02  314  static int ext4_dax_pfn_mkwrite(struct vm_fault *vmf)
ea3d7209c Jan Kara       2015-12-07  315  {
1ebf3e0da Dave Jiang     2017-02-02  316  	struct inode *inode = file_inode(vmf->vma->vm_file);
ea3d7209c Jan Kara       2015-12-07  317  	struct super_block *sb = inode->i_sb;
ea3d7209c Jan Kara       2015-12-07  318  	loff_t size;
d5be7a03b Ross Zwisler   2016-01-22  319  	int ret;
ea3d7209c Jan Kara       2015-12-07  320  
ea3d7209c Jan Kara       2015-12-07  321  	sb_start_pagefault(sb);
1ebf3e0da Dave Jiang     2017-02-02  322  	file_update_time(vmf->vma->vm_file);
ea3d7209c Jan Kara       2015-12-07  323  	down_read(&EXT4_I(inode)->i_mmap_sem);
ea3d7209c Jan Kara       2015-12-07  324  	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
ea3d7209c Jan Kara       2015-12-07  325  	if (vmf->pgoff >= size)
ea3d7209c Jan Kara       2015-12-07  326  		ret = VM_FAULT_SIGBUS;
d5be7a03b Ross Zwisler   2016-01-22  327  	else
1ebf3e0da Dave Jiang     2017-02-02  328  		ret = dax_pfn_mkwrite(vmf);
ea3d7209c Jan Kara       2015-12-07  329  	up_read(&EXT4_I(inode)->i_mmap_sem);
ea3d7209c Jan Kara       2015-12-07  330  	sb_end_pagefault(sb);
ea3d7209c Jan Kara       2015-12-07  331  
ea3d7209c Jan Kara       2015-12-07  332  	return ret;
923ae0ff9 Ross Zwisler   2015-02-16  333  }
923ae0ff9 Ross Zwisler   2015-02-16  334  
923ae0ff9 Ross Zwisler   2015-02-16  335  static const struct vm_operations_struct ext4_dax_vm_ops = {
923ae0ff9 Ross Zwisler   2015-02-16  336  	.fault		= ext4_dax_fault,
22711acc4 Dave Jiang     2017-02-03 @337  	.huge_fault	= ext4_dax_huge_fault,
1e9d180ba Ross Zwisler   2016-02-27  338  	.page_mkwrite	= ext4_dax_fault,
ea3d7209c Jan Kara       2015-12-07  339  	.pfn_mkwrite	= ext4_dax_pfn_mkwrite,
923ae0ff9 Ross Zwisler   2015-02-16  340  };

:::::: The code at line 280 was first introduced by commit
:::::: 30599588c9eaccc211d383c9974a3a88dfa6e7d5 mm,fs,dax: change ->pmd_fault to ->huge_fault

:::::: TO: Dave Jiang <dave.jiang@intel.com>
:::::: CC: Johannes Weiner <hannes@cmpxchg.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
