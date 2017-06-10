Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97BD121A143F0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Jun 2017 14:54:53 -0700 (PDT)
Subject: [PATCH 2/2] mm: always enable thp for dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Jun 2017 14:49:37 -0700
Message-ID: <149713137723.17377.8854203820807564559.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The madvise policy for transparent huge pages is meant to avoid unwanted
allocations of transparent huge pages. It allows a policy of disabling
the extra memory pressure and effort to arrange for a huge page when it
is not needed.

DAX by definition never incurs this overhead since it is statically
allocated. The policy choice makes even less sense for device-dax which
tries to guarantee a given tlb-fault size. Specifically, the following
setting:

	echo never > /sys/kernel/mm/transparent_hugepage/enabled

...violates that guarantee and silently disables all device-dax
instances with a 2M or 1G alignment. So, let's avoid that non-obvious
side effect by force enabling thp for dax mappings in all cases.

It is worth noting that the reason this uses vma_is_dax(), and the
resulting header include changes, is that previous attempts to add a
VM_DAX flag were NAKd.

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/dax.h     |    5 -----
 include/linux/fs.h      |    6 ++++++
 include/linux/huge_mm.h |    5 +++++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/dax.h b/include/linux/dax.h
index 1f6b6072af64..cbaf3d53d66b 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -151,11 +151,6 @@ static inline unsigned int dax_radix_order(void *entry)
 #endif
 int dax_pfn_mkwrite(struct vm_fault *vmf);
 
-static inline bool vma_is_dax(struct vm_area_struct *vma)
-{
-	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
-}
-
 static inline bool dax_mapping(struct address_space *mapping)
 {
 	return mapping->host && IS_DAX(mapping->host);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 803e5a9b2654..5916ab3a12d5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -18,6 +18,7 @@
 #include <linux/bug.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
+#include <linux/mm_types.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
@@ -3042,6 +3043,11 @@ static inline bool io_is_direct(struct file *filp)
 	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
 }
 
+static inline bool vma_is_dax(struct vm_area_struct *vma)
+{
+	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
+}
+
 static inline int iocb_flags(struct file *file)
 {
 	int res = 0;
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index c4706e2c3358..901ed3767d1b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_HUGE_MM_H
 #define _LINUX_HUGE_MM_H
 
+#include <linux/fs.h>
+
 extern int do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 extern int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			 pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
@@ -92,6 +94,9 @@ static inline bool transparent_hugepage_enabled(struct vm_area_struct *vma)
 	if (transparent_hugepage_flags & (1 << TRANSPARENT_HUGEPAGE_FLAG))
 		return true;
 
+	if (vma_is_dax(vma))
+		return true;
+
 	if (transparent_hugepage_flags
 			& (1 << TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG))
 		/* check vma flags */;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
