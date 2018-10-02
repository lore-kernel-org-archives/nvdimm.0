Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 09EF521160A3A
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 03:05:33 -0700 (PDT)
Date: Tue, 2 Oct 2018 12:05:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002100531.GC4135@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
mean time certain customer of ours started poking into /proc/<pid>/smaps
and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
flags, the application just fails to start complaining that DAX support is
missing in the kernel. The question now is how do we go about this?

Strictly speaking, this is a userspace visible regression (as much as I
think that application poking into VMA flags at this level is just too
bold). Is there any precedens in handling similar issues with smaps which
really exposes a lot of information that is dependent on kernel
implementation details?

I have attached a patch that is an obvious "fix" for the issue - just fake
VM_MIXEDMAP flag in smaps. But I'm open to other suggestions...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--YZ5djTAD1cGYuMQK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-proc-Show-DAX-mappings-as-having-VM_MIXEDMAP-flag.patch"

>From a3bfac5e1582d9c31e67090b306efedf7c392d36 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 2 Oct 2018 11:58:22 +0200
Subject: [PATCH] proc: Show DAX mappings as having VM_MIXEDMAP flag

Until commit e1fb4a08649 "dax: remove VM_MIXEDMAP for fsdax and device
dax", userspace could distinguish DAX and non-DAX mappings in
/proc/<pid>/smaps by checking whether the VMA has VM_MIXEDMAP (mm in
smaps) flag. And indeed some applications started doing this. Maintain
backwards compatibility by faking VM_MIXEDMAP flag in smaps for DAX
mappings.

Fixes: e1fb4a0864958fac2fb1b23f9f4562a9f90e3e8f
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/proc/task_mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 5ea1d64cb0b4..9cd8e84610a7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -19,6 +19,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/uaccess.h>
 #include <linux/pkeys.h>
+#include <linux/fs.h>
 
 #include <asm/elf.h>
 #include <asm/tlb.h>
@@ -654,12 +655,18 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #endif /* CONFIG_ARCH_HAS_PKEYS */
 	};
 	size_t i;
+	unsigned long flags = vma->vm_flags;
 
+	/*
+	 * We fake VM_MIXEDMAP for DAX mappings here as some apps depend on it.
+	 */
+	if (vma_is_dax(vma))
+		flags |= VM_MIXEDMAP;
 	seq_puts(m, "VmFlags: ");
 	for (i = 0; i < BITS_PER_LONG; i++) {
 		if (!mnemonics[i][0])
 			continue;
-		if (vma->vm_flags & (1UL << i)) {
+		if (flags & (1UL << i)) {
 			seq_putc(m, mnemonics[i][0]);
 			seq_putc(m, mnemonics[i][1]);
 			seq_putc(m, ' ');
-- 
2.16.4


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--YZ5djTAD1cGYuMQK--
