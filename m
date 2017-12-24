Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1084122225C0C
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 16:59:50 -0800 (PST)
Subject: [PATCH v4 05/18] dax: stop using VM_MIXEDMAP for dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:27 -0800
Message-ID: <151407698763.38751.8605535379424429182.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
the memory page it is dealing with is not typical memory from the linear
map. The get_user_pages_fast() path, since it does not resolve the vma,
is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
use that as a VM_MIXEDMAP replacement in some locations. In the cases
where there is no pte to consult we fallback to using vma_is_dax() to
detect the VM_MIXEDMAP special case.

Now that we have explicit driver pfn_t-flag opt-in/opt-out for
get_user_pages() support for DAX we can stop setting VM_MIXEDMAP.  This
also means we no longer need to worry about safely manipulating vm_flags
in a future where we support dynamically changing the dax mode of a
file.

Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |    2 +-
 fs/ext2/file.c       |    1 -
 fs/ext4/file.c       |    2 +-
 fs/xfs/xfs_file.c    |    2 +-
 include/linux/mm.h   |    1 +
 include/linux/vma.h  |   23 +++++++++++++++++++++++
 mm/huge_memory.c     |    6 ++----
 mm/ksm.c             |    3 +++
 mm/madvise.c         |    2 +-
 mm/memory.c          |    8 ++++++--
 mm/migrate.c         |    3 ++-
 mm/mlock.c           |    5 +++--
 mm/mmap.c            |    8 ++++----
 13 files changed, 48 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/vma.h

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 7b0bf825c4e7..c514ad48ff73 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -463,7 +463,7 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_ops = &dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 2da67699dc33..62c12c75b788 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -126,7 +126,6 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
 #else
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a0ae27b1bc66..983cee466a89 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -367,7 +367,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8601275cc5e6..1d6d4a3ecd42 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1130,7 +1130,7 @@ xfs_file_mmap(
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 09637c353de0..dc124b278173 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2405,6 +2405,7 @@ int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn);
 int vm_insert_mixed_mkwrite(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn);
+bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 
diff --git a/include/linux/vma.h b/include/linux/vma.h
new file mode 100644
index 000000000000..e71487e8c5f0
--- /dev/null
+++ b/include/linux/vma.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 Intel Corporation. All rights reserved. */
+#ifndef __VMA_H__
+#define __VMA_H__
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/hugetlb_inline.h>
+
+/*
+ * There are several vma types that have special handling in the
+ * get_user_pages() path and other core mm paths that must not assume
+ * normal pages. vma_is_special() consolidates some common checks for
+ * VM_SPECIAL, hugetlb and dax vmas, but note that there are 'special'
+ * vmas and circumstances beyond these types. In other words this helper
+ * is not exhaustive for example this does not replace VM_PFNMAP checks.
+ */
+static inline bool vma_is_special(struct vm_area_struct *vma)
+{
+	return vma && (is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL)
+			|| vma_is_dax(vma));
+}
+#endif /* __VMA_H__ */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f2f5e774902..d1b891f27675 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -765,11 +765,10 @@ int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON(!((vma->vm_flags & VM_PFNMAP) || vm_mixed_ok(vma, pfn)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
@@ -824,11 +823,10 @@ int vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON(!((vma->vm_flags & VM_PFNMAP) || vm_mixed_ok(vma, pfn)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
diff --git a/mm/ksm.c b/mm/ksm.c
index be8f4576f842..0bd1fda485fd 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2372,6 +2372,9 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				 VM_HUGETLB | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
+		if (vma_is_dax(vma))
+			return 0;
+
 #ifdef VM_SAO
 		if (*vm_flags & VM_SAO)
 			return 0;
diff --git a/mm/madvise.c b/mm/madvise.c
index 751e97aa2210..eff3ec1e2574 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -96,7 +96,7 @@ static long madvise_behavior(struct vm_area_struct *vma,
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if (new_flags & VM_SPECIAL) {
+		if (vma_is_dax(vma) || (new_flags & VM_SPECIAL)) {
 			error = -EINVAL;
 			goto out;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index 48a13473b401..1efb005e8fab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -831,6 +831,8 @@ struct page *_vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			return vma->vm_ops->find_special_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
+		if (pte_devmap(pte))
+			return NULL;
 		if (is_zero_pfn(pfn))
 			return NULL;
 
@@ -918,6 +920,8 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 		}
 	}
 
+	if (pmd_devmap(pmd))
+		return NULL;
 	if (is_zero_pfn(pfn))
 		return NULL;
 	if (unlikely(pfn > highest_memmap_pfn))
@@ -1228,7 +1232,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * efficient than faulting.
 	 */
 	if (!(vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
-			!vma->anon_vma)
+			!vma->anon_vma && !vma_is_dax(vma))
 		return 0;
 
 	if (is_vm_hugetlb_page(vma))
@@ -1897,7 +1901,7 @@ int vm_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pfn_prot);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn)
+bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn)
 {
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
diff --git a/mm/migrate.c b/mm/migrate.c
index 4d0be47a322a..624d43a455be 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -46,6 +46,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/mm.h>
 #include <linux/ptrace.h>
+#include <linux/vma.h>
 
 #include <asm/tlbflush.h>
 
@@ -2938,7 +2939,7 @@ int migrate_vma(const struct migrate_vma_ops *ops,
 	/* Sanity check the arguments */
 	start &= PAGE_MASK;
 	end &= PAGE_MASK;
-	if (!vma || is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL))
+	if (!vma || vma_is_special(vma))
 		return -EINVAL;
 	if (start < vma->vm_start || start >= vma->vm_end)
 		return -EINVAL;
diff --git a/mm/mlock.c b/mm/mlock.c
index 30472d438794..a10580f77c84 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -23,6 +23,7 @@
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
+#include <linux/vma.h>
 
 #include "internal.h"
 
@@ -520,8 +521,8 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	int lock = !!(newflags & VM_LOCKED);
 	vm_flags_t old_flags = vma->vm_flags;
 
-	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
-	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
+	if (newflags == vma->vm_flags || vma_is_special(vma)
+			|| vma == get_gate_vma(current->mm))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index a4d546821214..b063e363cf27 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -45,6 +45,7 @@
 #include <linux/moduleparam.h>
 #include <linux/pkeys.h>
 #include <linux/oom.h>
+#include <linux/vma.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1737,11 +1738,10 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	vm_stat_account(mm, vm_flags, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
-		if (!((vm_flags & VM_SPECIAL) || is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(current->mm)))
-			mm->locked_vm += (len >> PAGE_SHIFT);
-		else
+		if (vma_is_special(vma) || vma == get_gate_vma(current->mm))
 			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
+		else
+			mm->locked_vm += (len >> PAGE_SHIFT);
 	}
 
 	if (file)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
