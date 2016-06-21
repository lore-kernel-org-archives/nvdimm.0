Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 489FB1A1E5B
 for <linux-nvdimm@lists.01.org>; Tue, 21 Jun 2016 10:32:29 -0700 (PDT)
Date: Wed, 22 Jun 2016 01:31:00 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 3/3] dax: Clear dirty entry tags on cache flush
Message-ID: <201606220132.oV9yZWCR%fengguang.wu@intel.com>
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
config: i386-allmodconfig (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/pagemap.h:10:0,
                    from include/linux/blkdev.h:14,
                    from fs/dax.c:18:
   fs/dax.c: In function 'dax_mapping_entry_mkclean':
>> arch/x86/include/asm/pgtable_32.h:52:38: error: incompatible type for argument 1 of '__kunmap_atomic'
    #define pte_unmap(pte) kunmap_atomic((pte))
                                         ^
   include/linux/highmem.h:127:18: note: in definition of macro 'kunmap_atomic'
     __kunmap_atomic(addr);                                  \
                     ^~~~
>> include/linux/mm.h:1681:2: note: in expansion of macro 'pte_unmap'
     pte_unmap(pte);     \
     ^~~~~~~~~
>> fs/dax.c:714:3: note: in expansion of macro 'pte_unmap_unlock'
      pte_unmap_unlock(pte, ptl);
      ^~~~~~~~~~~~~~~~
   In file included from include/linux/highmem.h:34:0,
                    from include/linux/pagemap.h:10,
                    from include/linux/blkdev.h:14,
                    from fs/dax.c:18:
   arch/x86/include/asm/highmem.h:68:6: note: expected 'void *' but argument is of type 'pte_t {aka union <anonymous>}'
    void __kunmap_atomic(void *kvaddr);
         ^~~~~~~~~~~~~~~

vim +/pte_unmap_unlock +714 fs/dax.c

   698			address = pgoff_address(index, vma);
   699			changed = false;
   700			if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
   701				continue;
   702			if (pfn != pte_pfn(*ptep))
   703				goto unlock;
   704			if (!pte_dirty(*ptep) && !pte_write(*ptep))
   705				goto unlock;
   706	
   707			flush_cache_page(vma, address, pfn);
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
   718		}
   719		i_mmap_unlock_read(mapping);
   720	}
   721	
   722	static int dax_writeback_one(struct block_device *bdev,

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
