From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH v2] fs/dax: deposit pagetable even when installing zero page
Date: Sat,  9 Mar 2019 17:37:21 +0530
Message-ID: <20190309120721.21416-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Architectures like ppc64 use the deposited page table to store hardware
page table slot information. Make sure we deposit a page table when
using zero page at the pmd level for hash.

Without this we hit

Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xc000000000082a74
Oops: Kernel access of bad area, sig: 11 [#1]
....

NIP [c000000000082a74] __hash_page_thp+0x224/0x5b0
LR [c0000000000829a4] __hash_page_thp+0x154/0x5b0
Call Trace:
 hash_page_mm+0x43c/0x740
 do_hash_page+0x2c/0x3c
 copy_from_iter_flushcache+0xa4/0x4a0
 pmem_copy_from_iter+0x2c/0x50 [nd_pmem]
 dax_copy_from_iter+0x40/0x70
 dax_iomap_actor+0x134/0x360
 iomap_apply+0xfc/0x1b0
 dax_iomap_rw+0xac/0x130
 ext4_file_write_iter+0x254/0x460 [ext4]
 __vfs_write+0x120/0x1e0
 vfs_write+0xd8/0x220
 SyS_write+0x6c/0x110
 system_call+0x3c/0x130

Fixes: b5beae5e224f ("powerpc/pseries: Add driver for PAPR SCM regions")
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
Changes from v1:
* Add reviewed-by:
* Add Fixes:

 fs/dax.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 6959837cc465..01bfb2ac34f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -33,6 +33,7 @@
 #include <linux/sizes.h>
 #include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
+#include <asm/pgalloc.h>
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -1410,7 +1411,9 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
 	struct inode *inode = mapping->host;
+	pgtable_t pgtable = NULL;
 	struct page *zero_page;
 	spinlock_t *ptl;
 	pmd_t pmd_entry;
@@ -1425,12 +1428,22 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
 			DAX_PMD | DAX_ZERO_PAGE, false);
 
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
 	ptl = pmd_lock(vmf->vma->vm_mm, vmf->pmd);
 	if (!pmd_none(*(vmf->pmd))) {
 		spin_unlock(ptl);
 		goto fallback;
 	}
 
+	if (pgtable) {
+		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
+		mm_inc_nr_ptes(vma->vm_mm);
+	}
 	pmd_entry = mk_pmd(zero_page, vmf->vma->vm_page_prot);
 	pmd_entry = pmd_mkhuge(pmd_entry);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
@@ -1439,6 +1452,8 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	return VM_FAULT_NOPAGE;
 
 fallback:
+	if (pgtable)
+		pte_free(vma->vm_mm, pgtable);
 	trace_dax_pmd_load_hole_fallback(inode, vmf, zero_page, *entry);
 	return VM_FAULT_FALLBACK;
 }
-- 
2.20.1
