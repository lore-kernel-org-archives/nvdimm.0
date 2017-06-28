Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F33BC21CB74A9
 for <linux-nvdimm@lists.01.org>; Wed, 28 Jun 2017 13:05:59 -0700 (PDT)
Subject: [4.9-stable PATCH] x86/mm: Fix boot crash caused by incorrect loop
 count calculation in sync_global_pgds()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Jun 2017 13:00:53 -0700
Message-ID: <149868005301.40163.12845524970445215160.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, x86@kernel.org, Dave Young <dyoung@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Yasuaki Ishimatsu <yasu.isimatu@gmail.com>, Jinbum Park <jinb.park7@gmail.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Garnier <thgarnie@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Baoquan He <bhe@redhat.com>

commit fc5f9d5f151c9fff21d3d1d2907b888a5aec3ff7 upstream.

Jeff Moyer reported that on his system with two memory regions 0~64G and
1T~1T+192G, and kernel option "memmap=192G!1024G" added, enabling KASLR
will make the system hang intermittently during boot. While adding 'nokaslr'
won't.

The back trace is:

 Oops: 0000 [#1] SMP

 RIP: memcpy_erms()
 [ .... ]
 Call Trace:
  pmem_rw_page()
  bdev_read_page()
  do_mpage_readpage()
  mpage_readpages()
  blkdev_readpages()
  __do_page_cache_readahead()
  force_page_cache_readahead()
  page_cache_sync_readahead()
  generic_file_read_iter()
  blkdev_read_iter()
  __vfs_read()
  vfs_read()
  SyS_read()
  entry_SYSCALL_64_fastpath()

This crash happens because the for loop count calculation in sync_global_pgds()
is not correct. When a mapping area crosses PGD entries, we should
calculate the starting address of region which next PGD covers and assign
it to next for loop count, but not add PGDIR_SIZE directly. The old
code works right only if the mapping area is an exact multiple of PGDIR_SIZE,
otherwize the end region could be skipped so that it can't be synchronized
to all other processes from kernel PGD init_mm.pgd.

In Jeff's system, emulated pmem area [1024G, 1216G) is smaller than
PGDIR_SIZE. While 'nokaslr' works because PAGE_OFFSET is 1T aligned, it
makes this area be mapped inside one PGD entry. With KASLR enabled,
this area could cross two PGD entries, then the next PGD entry won't
be synced to all other processes. That is why we saw empty PGD.

Fix it.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jinbum Park <jinb.park7@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1493864747-8506-1-git-send-email-bhe@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/mm/init_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 14b9dd71d9e8..9a324fc8bed8 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -94,10 +94,10 @@ __setup("noexec32=", nonx32_setup);
  */
 void sync_global_pgds(unsigned long start, unsigned long end, int removed)
 {
-	unsigned long address;
+	unsigned long addr;
 
-	for (address = start; address <= end; address += PGDIR_SIZE) {
-		const pgd_t *pgd_ref = pgd_offset_k(address);
+	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
+		const pgd_t *pgd_ref = pgd_offset_k(addr);
 		struct page *page;
 
 		/*
@@ -113,7 +113,7 @@ void sync_global_pgds(unsigned long start, unsigned long end, int removed)
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgd = (pgd_t *)page_address(page) + pgd_index(addr);
 			/* the pgt_lock only for Xen */
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 			spin_lock(pgt_lock);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
