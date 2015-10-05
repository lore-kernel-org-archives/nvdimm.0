Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] coredump: add DAX filtering for FDPIC ELF coredumps
Date: Mon,  5 Oct 2015 16:33:37 -0600
Message-Id: <1444084417-19192-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1444084417-19192-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1444084417-19192-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add explicit filtering for DAX mappings to FDPIC ELF coredump.  This is
useful because DAX mappings have the potential to be very large.

This patch has only been compile tested.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/binfmt_elf_fdpic.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d3634bf..8632501 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -35,6 +35,7 @@
 #include <linux/elf-fdpic.h>
 #include <linux/elfcore.h>
 #include <linux/coredump.h>
+#include <linux/dax.h>
 
 #include <asm/uaccess.h>
 #include <asm/param.h>
@@ -1206,6 +1207,20 @@ static int maydump(struct vm_area_struct *vma, unsigned long mm_flags)
 		return 0;
 	}
 
+	/* support for DAX */
+	if (vma_is_dax(vma)) {
+		if (vma->vm_flags & VM_SHARED) {
+			dump_ok = test_bit(MMF_DUMP_DAX_SHARED, &mm_flags);
+			kdcore("%08lx: %08lx: %s (DAX shared)", vma->vm_start,
+			       vma->vm_flags, dump_ok ? "yes" : "no");
+		} else {
+			dump_ok = test_bit(MMF_DUMP_DAX_PRIVATE, &mm_flags);
+			kdcore("%08lx: %08lx: %s (DAX private)", vma->vm_start,
+			       vma->vm_flags, dump_ok ? "yes" : "no");
+		}
+		return dump_ok;
+	}
+
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
 		if (file_inode(vma->vm_file)->i_nlink == 0) {
-- 
2.1.0

