Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 1/5] pmem, dax: clean up clear_pmem()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Oct 2015 02:41:48 -0400
Message-ID: <20151022064148.12700.3630.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, willy@linux.intel.com, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Both, __dax_pmd_fault, and clear_pmem() were taking special steps to
clear memory a page at a time to take advantage of non-temporal
clear_page() implementations.  However, x86_64 does not use
non-temporal instructions for clear_page(), and arch_clear_pmem() was
always incurring the cost of __arch_wb_cache_pmem().

Clean up the assumption that doing clear_pmem() a page at a time is more
performant.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |    7 +------
 fs/dax.c                    |    4 +---
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index d8ce3ec816ab..1544fabcd7f9 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -132,12 +132,7 @@ static inline void arch_clear_pmem(void __pmem *addr, size_t size)
 {
 	void *vaddr = (void __force *)addr;
 
-	/* TODO: implement the zeroing via non-temporal writes */
-	if (size == PAGE_SIZE && ((unsigned long)vaddr & ~PAGE_MASK) == 0)
-		clear_page(vaddr);
-	else
-		memset(vaddr, 0, size);
-
+	memset(vaddr, 0, size);
 	__arch_wb_cache_pmem(vaddr, size);
 }
 
diff --git a/fs/dax.c b/fs/dax.c
index a86d3cc2b389..5dc33d788d50 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -623,9 +623,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 			goto fallback;
 
 		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			int i;
-			for (i = 0; i < PTRS_PER_PMD; i++)
-				clear_pmem(kaddr + i * PAGE_SIZE, PAGE_SIZE);
+			clear_pmem(kaddr, HPAGE_SIZE);
 			wmb_pmem();
 			count_vm_event(PGMAJFAULT);
 			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);

