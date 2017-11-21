Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0CBC21B00DD4
 for <linux-nvdimm@lists.01.org>; Tue, 21 Nov 2017 14:47:00 -0800 (PST)
Subject: [PATCH 1/2] mm, hugetlbfs: introduce ->split() to vm_operations_struct
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 21 Nov 2017 14:43:01 -0800
Message-ID: <151130418135.4029.6783191281930729710.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151130417573.4029.6745923267963684469.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151130417573.4029.6745923267963684469.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The device-dax interface has similar constraints as hugetlbfs in that it
requires the munmap path to unmap in huge page aligned units.  Rather
than add more custom vma handling code in __split_vma() introduce a new
vm operation to perform this vma specific check.

Cc: <stable@vger.kernel.org>
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h |    1 +
 mm/hugetlb.c       |    8 ++++++++
 mm/mmap.c          |    8 +++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ee073146aaa7..b3b6a7e313e9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -377,6 +377,7 @@ enum page_entry_size {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
+	int (*split)(struct vm_area_struct * area, unsigned long addr);
 	int (*mremap)(struct vm_area_struct * area);
 	int (*fault)(struct vm_fault *vmf);
 	int (*huge_fault)(struct vm_fault *vmf, enum page_entry_size pe_size);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 681b300185c0..698e8fb34031 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3125,6 +3125,13 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 	}
 }
 
+static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	if (addr & ~(huge_page_mask(hstate_vma(vma))))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  * We cannot handle pagefaults against hugetlb pages at all.  They cause
  * handle_mm_fault() to try to instantiate regular-sized pages in the
@@ -3141,6 +3148,7 @@ const struct vm_operations_struct hugetlb_vm_ops = {
 	.fault = hugetlb_vm_op_fault,
 	.open = hugetlb_vm_op_open,
 	.close = hugetlb_vm_op_close,
+	.split = hugetlb_vm_op_split,
 };
 
 static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
diff --git a/mm/mmap.c b/mm/mmap.c
index 924839fac0e6..a4d546821214 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2555,9 +2555,11 @@ int __split_vma(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct vm_area_struct *new;
 	int err;
 
-	if (is_vm_hugetlb_page(vma) && (addr &
-					~(huge_page_mask(hstate_vma(vma)))))
-		return -EINVAL;
+	if (vma->vm_ops && vma->vm_ops->split) {
+		err = vma->vm_ops->split(vma, addr);
+		if (err)
+			return err;
+	}
 
 	new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 	if (!new)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
