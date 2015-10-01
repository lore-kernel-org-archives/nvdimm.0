Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Thu, 1 Oct 2015 16:35:50 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/7] Revert "mm: take i_mmap_lock in
 unmap_mapping_range() for DAX"
Message-ID: <201510011627.eAfVmtFF%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1443685599-4843-2-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: kbuild-all@01.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, willy@linux.intel.com, dan.j.williams@intel.com, kirill.shutemov@linux.intel.com, linux-nvdimm@lists.01.org, jack@suse.cz, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/dax.c:626:50: sparse: incorrect type in argument 1 (different address spaces)
   fs/dax.c:626:50:    expected void *page
   fs/dax.c:626:50:    got void [noderef] <asn:5>*

vim +626 fs/dax.c

   610			result = VM_FAULT_NOPAGE;
   611			spin_unlock(ptl);
   612		} else {
   613			sector = bh.b_blocknr << (blkbits - 9);
   614			length = bdev_direct_access(bh.b_bdev, sector, &kaddr, &pfn,
   615							bh.b_size);
   616			if (length < 0) {
   617				result = VM_FAULT_SIGBUS;
   618				goto out;
   619			}
   620			if ((length < PMD_SIZE) || (pfn & PG_PMD_COLOUR))
   621				goto fallback;
   622	
   623			if (buffer_unwritten(&bh) || buffer_new(&bh)) {
   624				int i;
   625				for (i = 0; i < PTRS_PER_PMD; i++)
 > 626					clear_page(kaddr + i * PAGE_SIZE);
   627				count_vm_event(PGMAJFAULT);
   628				mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
   629				result |= VM_FAULT_MAJOR;
   630			}
   631	
   632			result |= vmf_insert_pfn_pmd(vma, address, pmd, pfn, write);
   633		}
   634	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
