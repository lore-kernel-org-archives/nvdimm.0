Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id F305C1A1E04
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 14:01:57 -0700 (PDT)
Date: Wed, 22 Jun 2016 04:59:51 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] dax: Clear dirty entry tags on cache flush
Message-ID: <201606220412.YCDu7dfb%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1466523915-14644-4-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test ERROR on v4.7-rc4]
[also build test ERROR on next-20160621]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jan-Kara/dax-Clear-dirty-bits-after-flushing-caches/20160621-234931
config: i386-allyesconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   fs/dax.c: In function 'dax_mapping_entry_mkclean':
>> fs/dax.c:714:343: error: incompatible type for argument 1 of '__kunmap_atomic'
      pte_unmap_unlock(pte, ptl);
                                                                                                                                                                                                                                                                                                                                                          ^
   In file included from include/linux/highmem.h:34:0,
                    from include/linux/pagemap.h:10,
                    from include/linux/blkdev.h:14,
                    from fs/dax.c:18:
   arch/x86/include/asm/highmem.h:68:6: note: expected 'void *' but argument is of type 'pte_t {aka union <anonymous>}'
    void __kunmap_atomic(void *kvaddr);
         ^~~~~~~~~~~~~~~

vim +/__kunmap_atomic +714 fs/dax.c

   708			pte = ptep_clear_flush(vma, address, ptep);
   709			pte = pte_wrprotect(pte);
   710			pte = pte_mkclean(pte);
   711			set_pte_at(vma->vm_mm, address, ptep, pte);
   712			changed = true;
   713	unlock:
 > 714			pte_unmap_unlock(pte, ptl);
   715	
   716			if (changed)
   717				mmu_notifier_invalidate_page(vma->vm_mm, address);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
