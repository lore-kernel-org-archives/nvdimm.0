Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 499A221E0C2EB
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 06:10:47 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/7] dax, iomap: Add support for synchronous faults
Date: Thu, 27 Jul 2017 15:12:43 +0200
Message-Id: <20170727131245.28279-6-jack@suse.cz>
In-Reply-To: <20170727131245.28279-1-jack@suse.cz>
References: <20170727131245.28279-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add a flag to iomap interface informing the caller that inode needs
fdstasync(2) for returned extent to become persistent and use it in DAX
fault code so that we map such extents only read only. We propagate the
information that the page table entry has been inserted write-protected
from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
handler is then responsible for calling fdatasync(2) and updating page
tables to map pfns read-write. dax_iomap_fault() also takes care of
updating vmf->orig_pte to match the PTE that was inserted so that we can
safely recheck that PTE did not change while write-enabling it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c              | 42 +++++++++++++++++++++++++++++++++++-------
 include/linux/iomap.h |  2 ++
 include/linux/mm.h    |  2 ++
 3 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9658975b926a..8a6cf158c691 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -829,7 +829,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 }
 
 static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-			      loff_t pos, void *entry)
+			      loff_t pos, void *entry, bool force_ro)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	struct vm_area_struct *vma = vmf->vma;
@@ -858,7 +858,7 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 		return PTR_ERR(ret);
 
 	trace_dax_insert_mapping(mapping->host, vmf, ret);
-	if (vmf->flags & FAULT_FLAG_WRITE)
+	if ((vmf->flags & FAULT_FLAG_WRITE) && !force_ro)
 		rc = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
 	else
 		rc = vm_insert_mixed(vma, vaddr, pfn);
@@ -870,6 +870,14 @@ static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 	vmf_ret = dax_fault_return(rc);
 	if (iomap->flags & IOMAP_F_NEW)
 		vmf_ret |= VM_FAULT_MAJOR;
+	if (!rc && (vmf->flags & FAULT_FLAG_WRITE) && force_ro) {
+		vmf_ret |= VM_FAULT_RO;
+		/*
+		 * Hack: Store PFN here so that we can pass it to
+		 * vm_insert_mixed_mkwrite() when changing PTE to RW.
+		 */
+		vmf->orig_pte = pfn_t_pte(pfn, vma->vm_page_prot);
+	}
 	return vmf_ret;
 }
 
@@ -1092,6 +1100,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 	int error;
 	int vmf_ret = 0;
 	void *entry;
+	bool force_ro;
 
 	trace_dax_pte_fault(inode, vmf, vmf_ret);
 	/*
@@ -1167,13 +1176,15 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 		goto finish_iomap;
 	}
 
+	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
+			(iomap.flags & IOMAP_F_NEEDDSYNC);
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
 		if (iomap.flags & IOMAP_F_NEW) {
 			count_vm_event(PGMAJFAULT);
 			count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 		}
-		vmf_ret = dax_insert_mapping(vmf, &iomap, pos, entry);
+		vmf_ret = dax_insert_mapping(vmf, &iomap, pos, entry, force_ro);
 		goto finish_iomap;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
@@ -1219,7 +1230,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf, bool sync,
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
 static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-		loff_t pos, void *entry)
+		loff_t pos, void *entry, bool force_ro)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	const sector_t sector = dax_iomap_sector(iomap, pos);
@@ -1232,6 +1243,7 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 	pgoff_t pgoff;
 	pfn_t pfn;
 	int id;
+	int result;
 
 	if (bdev_dax_pgoff(bdev, sector, size, &pgoff) != 0)
 		goto fallback;
@@ -1256,8 +1268,19 @@ static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
 		goto fallback;
 
 	trace_dax_pmd_insert_mapping(inode, vmf, length, pfn, ret);
-	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
-			pfn, vmf->flags & FAULT_FLAG_WRITE);
+	result = vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
+			pfn, (vmf->flags & FAULT_FLAG_WRITE) && !force_ro);
+	/* Did we insert RO PMD despite the fault being a write one? */
+	if (!(result & VM_FAULT_ERROR) && (vmf->flags & FAULT_FLAG_WRITE) &&
+	    force_ro) {
+		result |= VM_FAULT_RO;
+		/*
+		 * Hack: Store PFN here so that we can pass it to
+		 * vmf_insert_pfn_pmd() when changing PMD to RW.
+		 */
+		vmf->orig_pte = pfn_t_pte(pfn, vmf->vma->vm_page_prot);
+	}
+	return result;
 
 unlock_fallback:
 	dax_read_unlock(id);
@@ -1320,6 +1343,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, bool sync,
 	void *entry;
 	loff_t pos;
 	int error;
+	bool force_ro;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1385,9 +1409,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, bool sync,
 	if (iomap.offset + iomap.length < pos + PMD_SIZE)
 		goto finish_iomap;
 
+	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
+			(iomap.flags & IOMAP_F_NEEDDSYNC);
+
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		result = dax_pmd_insert_mapping(vmf, &iomap, pos, entry);
+		result = dax_pmd_insert_mapping(vmf, &iomap, pos, entry,
+						force_ro);
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f64dc6ce5161..957463602f6e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -22,6 +22,8 @@ struct vm_fault;
  * Flags for all iomap mappings:
  */
 #define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
+#define IOMAP_F_NEEDDSYNC	0x02	/* inode needs fdatasync for storage to
+					 * become persistent */
 
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa036093e76c..5085647d9f2f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1142,6 +1142,8 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
+#define VM_FAULT_RO	0x2000		/* Write fault was handled just by
+					 * inserting RO page table entry for DAX */
 
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | \
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
