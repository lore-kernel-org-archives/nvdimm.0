Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E13D1A1F18
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 14:36:00 -0800 (PST)
From: Kamal Mostafa <kamal@canonical.com>
Subject: [4.2.y-ckt stable] Patch "x86/mm: Fix vmalloc_fault() to handle large
 pages properly" has been added to the 4.2.y-ckt tree
Date: Mon,  7 Mar 2016 14:34:26 -0800
Message-Id: <1457390066-32641-1-git-send-email-kamal@canonical.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>, Henning Schild <henning.schild@siemens.com>, Denys Vlasenko <dvlasenk@redhat.com>, linux-nvdimm@lists.01.org, Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-mm@kvack.org, kernel-team@lists.ubuntu.com, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <linux-nvdimm@lists.01.org>

This is a note to let you know that I have just added a patch titled

    x86/mm: Fix vmalloc_fault() to handle large pages properly

to the linux-4.2.y-queue branch of the 4.2.y-ckt extended stable tree 
which can be found at:

    http://kernel.ubuntu.com/git/ubuntu/linux.git/log/?h=linux-4.2.y-queue

This patch is scheduled to be released in version 4.2.8-ckt5.

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 4.2.y-ckt tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Kamal

---8<------------------------------------------------------------

>From f2282ee1b90bbfbbaccbad1945c38611aa2d8810 Mon Sep 17 00:00:00 2001
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 17 Feb 2016 18:16:54 -0700
Subject: x86/mm: Fix vmalloc_fault() to handle large pages properly

commit f4eafd8bcd5229e998aa252627703b8462c3b90f upstream.

A kernel page fault oops with the callstack below was observed
when a read syscall was made to a pmem device after a huge amount
(>512GB) of vmalloc ranges was allocated by ioremap() on a x86_64
system:

     BUG: unable to handle kernel paging request at ffff880840000ff8
     IP: vmalloc_fault+0x1be/0x300
     PGD c7f03a067 PUD 0
     Oops: 0000 [#1] SM
     Call Trace:
        __do_page_fault+0x285/0x3e0
        do_page_fault+0x2f/0x80
        ? put_prev_entity+0x35/0x7a0
        page_fault+0x28/0x30
        ? memcpy_erms+0x6/0x10
        ? schedule+0x35/0x80
        ? pmem_rw_bytes+0x6a/0x190 [nd_pmem]
        ? schedule_timeout+0x183/0x240
        btt_log_read+0x63/0x140 [nd_btt]
         :
        ? __symbol_put+0x60/0x60
        ? kernel_read+0x50/0x80
        SyS_finit_module+0xb9/0xf0
        entry_SYSCALL_64_fastpath+0x1a/0xa4

Since v4.1, ioremap() supports large page (pud/pmd) mappings in
x86_64 and PAE.  vmalloc_fault() however assumes that the vmalloc
range is limited to pte mappings.

vmalloc faults do not normally happen in ioremap'd ranges since
ioremap() sets up the kernel page tables, which are shared by
user processes.  pgd_ctor() sets the kernel's PGD entries to
user's during fork().  When allocation of the vmalloc ranges
crosses a 512GB boundary, ioremap() allocates a new pud table
and updates the kernel PGD entry to point it.  If user process's
PGD entry does not have this update yet, a read/write syscall
to the range will cause a vmalloc fault, which hits the Oops
above as it does not handle a large page properly.

Following changes are made to vmalloc_fault().

64-bit:

 - No change for the PGD sync operation as it handles large
   pages already.
 - Add pud_huge() and pmd_huge() to the validation code to
   handle large pages.
 - Change pud_page_vaddr() to pud_pfn() since an ioremap range
   is not directly mapped (while the if-statement still works
   with a bogus addr).
 - Change pmd_page() to pmd_pfn() since an ioremap range is not
   backed by struct page (while the if-statement still works
   with a bogus addr).

32-bit:
 - No change for the sync operation since the index3 PGD entry
   covers the entire vmalloc range, which is always valid.
   (A separate change to sync PGD entry is necessary if this
    memory layout is changed regardless of the page size.)
 - Add pmd_huge() to the validation code to handle large pages.
   This is for completeness since vmalloc_fault() won't happen
   in ioremap'd ranges as its PGD entry is always valid.

Reported-by: Henning Schild <henning.schild@siemens.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis R. Rodriguez <mcgrof@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-mm@kvack.org
Cc: linux-nvdimm@lists.01.org
Link: http://lkml.kernel.org/r/1455758214-24623-1-git-send-email-toshi.kani@hpe.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/mm/fault.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9dc9098..1d3beaf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -286,6 +286,9 @@ static noinline int vmalloc_fault(unsigned long address)
 	if (!pmd_k)
 		return -1;

+	if (pmd_huge(*pmd_k))
+		return 0;
+
 	pte_k = pte_offset_kernel(pmd_k, address);
 	if (!pte_present(*pte_k))
 		return -1;
@@ -357,8 +360,6 @@ void vmalloc_sync_all(void)
  * 64-bit:
  *
  *   Handle a fault on the vmalloc area
- *
- * This assumes no large pages in there.
  */
 static noinline int vmalloc_fault(unsigned long address)
 {
@@ -400,17 +401,23 @@ static noinline int vmalloc_fault(unsigned long address)
 	if (pud_none(*pud_ref))
 		return -1;

-	if (pud_none(*pud) || pud_page_vaddr(*pud) != pud_page_vaddr(*pud_ref))
+	if (pud_none(*pud) || pud_pfn(*pud) != pud_pfn(*pud_ref))
 		BUG();

+	if (pud_huge(*pud))
+		return 0;
+
 	pmd = pmd_offset(pud, address);
 	pmd_ref = pmd_offset(pud_ref, address);
 	if (pmd_none(*pmd_ref))
 		return -1;

-	if (pmd_none(*pmd) || pmd_page(*pmd) != pmd_page(*pmd_ref))
+	if (pmd_none(*pmd) || pmd_pfn(*pmd) != pmd_pfn(*pmd_ref))
 		BUG();

+	if (pmd_huge(*pmd))
+		return 0;
+
 	pte_ref = pte_offset_kernel(pmd_ref, address);
 	if (!pte_present(*pte_ref))
 		return -1;
--
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
