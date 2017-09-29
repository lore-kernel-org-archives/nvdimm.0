Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C5092095E519
 for <linux-nvdimm@lists.01.org>; Thu, 28 Sep 2017 18:24:28 -0700 (PDT)
Subject: [PATCH v2 3/4] dax: stop using VM_MIXEDMAP for dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Sep 2017 18:21:18 -0700
Message-ID: <150664807800.36094.3685385297224300424.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

VM_MIXEDMAP is used by dax to direct mm paths like vm_normal_page() that
the memory page it is dealing with is not typical memory from the linear
map. The get_user_pages_fast() path, since it does not resolve the vma,
is already using {pte,pmd}_devmap() as a stand-in for VM_MIXEDMAP, so we
use that as a VM_MIXEDMAP replacement in some locations. In the cases
where there is no pte to consult we fallback to using vma_is_dax() to
detect the VM_MIXEDMAP special case.

Now that we always have pages for DAX we can stop setting VM_MIXEDMAP.
This also means we no longer need to worry about safely manipulating
vm_flags in a future where we support dynamically changing the dax mode
of a file.

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
 mm/huge_memory.c     |    8 ++++----
 mm/ksm.c             |    3 +++
 mm/madvise.c         |    2 +-
 mm/memory.c          |   20 ++++++++++++++++++--
 mm/migrate.c         |    3 ++-
 mm/mlock.c           |    3 ++-
 mm/mmap.c            |    3 ++-
 11 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index e9f3b3e4bbf4..ed79d006026e 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -450,7 +450,7 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_ops = &dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ff3a3636a5ca..70657e8550ed 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -125,7 +125,6 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
 #else
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b1da660ac3bc..0cc9d205bd96 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -352,7 +352,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebdd0bd2b261..dece8fe937f5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1131,7 +1131,7 @@ xfs_file_mmap(
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+		vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 269b5df58543..c69d30e27fd9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -765,11 +765,11 @@ int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON(!((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))
+				|| pfn_t_devmap(pfn)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
@@ -824,11 +824,11 @@ int vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON(!((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))
+				|| pfn_t_devmap(pfn)));
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
diff --git a/mm/ksm.c b/mm/ksm.c
index 15dd7415f7b3..787dfe4f3d44 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2358,6 +2358,9 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 				 VM_HUGETLB | VM_MIXEDMAP))
 			return 0;		/* just ignore the advice */
 
+		if (vma_is_dax(vma))
+			return 0;
+
 #ifdef VM_SAO
 		if (*vm_flags & VM_SAO)
 			return 0;
diff --git a/mm/madvise.c b/mm/madvise.c
index 21261ff0466f..40344d43e565 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -95,7 +95,7 @@ static long madvise_behavior(struct vm_area_struct *vma,
 		new_flags |= VM_DONTDUMP;
 		break;
 	case MADV_DODUMP:
-		if (new_flags & VM_SPECIAL) {
+		if (vma_is_dax(vma) || (new_flags & VM_SPECIAL)) {
 			error = -EINVAL;
 			goto out;
 		}
diff --git a/mm/memory.c b/mm/memory.c
index ec4e15494901..771acaf54fe6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -830,6 +830,8 @@ struct page *_vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			return vma->vm_ops->find_special_page(vma, addr);
 		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
 			return NULL;
+		if (pte_devmap(pte))
+			return NULL;
 		if (is_zero_pfn(pfn))
 			return NULL;
 
@@ -917,6 +919,8 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 		}
 	}
 
+	if (pmd_devmap(pmd))
+		return NULL;
 	if (is_zero_pfn(pfn))
 		return NULL;
 	if (unlikely(pfn > highest_memmap_pfn))
@@ -1227,7 +1231,7 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * efficient than faulting.
 	 */
 	if (!(vma->vm_flags & (VM_HUGETLB | VM_PFNMAP | VM_MIXEDMAP)) &&
-			!vma->anon_vma)
+			!vma->anon_vma && !vma_is_dax(vma))
 		return 0;
 
 	if (is_vm_hugetlb_page(vma))
@@ -1896,12 +1900,24 @@ int vm_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_pfn_prot);
 
+static bool vm_mixed_ok(struct vm_area_struct *vma, pfn_t pfn)
+{
+	/* these checks mirror the abort conditions in vm_normal_page */
+	if (vma->vm_flags & VM_MIXEDMAP)
+		return true;
+	if (pfn_t_devmap(pfn))
+		return true;
+	if (is_zero_pfn(pfn_t_to_pfn(pfn)))
+		return true;
+	return false;
+}
+
 static int __vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			pfn_t pfn, bool mkwrite)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 
-	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
+	BUG_ON(!vm_mixed_ok(vma, pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
diff --git a/mm/migrate.c b/mm/migrate.c
index 6954c1435833..179a84a311f6 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2927,7 +2927,8 @@ int migrate_vma(const struct migrate_vma_ops *ops,
 	/* Sanity check the arguments */
 	start &= PAGE_MASK;
 	end &= PAGE_MASK;
-	if (!vma || is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL))
+	if (!vma || is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_SPECIAL)
+			|| vma_is_dax(dma))
 		return -EINVAL;
 	if (start < vma->vm_start || start >= vma->vm_end)
 		return -EINVAL;
diff --git a/mm/mlock.c b/mm/mlock.c
index dfc6f1912176..4d009350893f 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -520,7 +520,8 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	vm_flags_t old_flags = vma->vm_flags;
 
 	if (newflags == vma->vm_flags || (vma->vm_flags & VM_SPECIAL) ||
-	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm))
+	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
+	    vma_is_dax(vma))
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
 		goto out;
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 680506faceae..2f3971a051c6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1723,7 +1723,8 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	vm_stat_account(mm, vm_flags, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
 		if (!((vm_flags & VM_SPECIAL) || is_vm_hugetlb_page(vma) ||
-					vma == get_gate_vma(current->mm)))
+					vma == get_gate_vma(current->mm) ||
+					vma_is_dax(vma)))
 			mm->locked_vm += (len >> PAGE_SHIFT);
 		else
 			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
