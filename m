Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 766D921E2DA45
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Date: Thu, 17 Aug 2017 18:08:13 +0200
Message-Id: <20170817160815.30466-12-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
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
 fs/dax.c              | 31 +++++++++++++++++++++++++++++++
 include/linux/iomap.h |  2 ++
 include/linux/mm.h    |  6 +++++-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index bc040e654cc9..ca88fc356786 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1177,6 +1177,22 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			goto error_finish_iomap;
 		}
 
+		/*
+		 * If we are doing synchronous page fault and inode needs fsync,
+		 * we can insert PTE into page tables only after that happens.
+		 * Skip insertion for now and return the pfn so that caller can
+		 * insert it after fsync is done.
+		 */
+		if (write && (vma->vm_flags & VM_SYNC) &&
+		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {
+			if (WARN_ON_ONCE(!pfnp)) {
+				error = -EIO;
+				goto error_finish_iomap;
+			}
+			*pfnp = pfn;
+			vmf_ret = VM_FAULT_NEEDDSYNC | major;
+			goto finish_iomap;
+		}
 		trace_dax_insert_mapping(inode, vmf, entry);
 		if (write)
 			error = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
@@ -1362,6 +1378,21 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 		if (IS_ERR(entry))
 			goto finish_iomap;
 
+		/*
+		 * If we are doing synchronous page fault and inode needs fsync,
+		 * we can insert PMD into page tables only after that happens.
+		 * Skip insertion for now and return the pfn so that caller can
+		 * insert it after fsync is done.
+		 */
+		if (write && (vmf->vma->vm_flags & VM_SYNC) &&
+		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {
+			if (WARN_ON_ONCE(!pfnp))
+				goto finish_iomap;
+			*pfnp = pfn;
+			result = VM_FAULT_NEEDDSYNC;
+			goto finish_iomap;
+		}
+
 		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
 		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
 					    write);
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
index d0fb385414a4..20e95c3a7701 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1143,6 +1143,9 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
+#define VM_FAULT_NEEDDSYNC  0x2000	/* ->fault did not modify page tables
+					 * and needs fsync() to complete (for
+					 * synchronous page faults in DAX) */
 
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | \
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
@@ -1160,7 +1163,8 @@ static inline void clear_page_pfmemalloc(struct page *page)
 	{ VM_FAULT_LOCKED,		"LOCKED" }, \
 	{ VM_FAULT_RETRY,		"RETRY" }, \
 	{ VM_FAULT_FALLBACK,		"FALLBACK" }, \
-	{ VM_FAULT_DONE_COW,		"DONE_COW" }
+	{ VM_FAULT_DONE_COW,		"DONE_COW" }, \
+	{ VM_FAULT_NEEDDSYNC,		"NEEDDSYNC" }
 
 /* Encode hstate index for a hwpoisoned large page */
 #define VM_FAULT_SET_HINDEX(x) ((x) << 12)
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
