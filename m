Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 757A7203BA4FF
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 07:49:44 -0700 (PDT)
Subject: [PATCH 03/11] device-dax: enable page_mapping()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 07:39:47 -0700
Message-ID: <152699998750.24093.5270058390086110946.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152699997165.24093.12194490924829406111.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, tony.luck@intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

In support of enabling memory_failure() handling for device-dax
mappings, set the ->mapping association of pages backing device-dax
mappings. The rmap implementation requires page_mapping() to return the
address_space hosting the vmas that map the page.

The ->mapping pointer is never cleared. There is no possibility for the
page to become associated with another address_space while the device is
enabled. When the device is disabled the 'struct page' array for the
device is destroyed / later reinitialized to zero.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 686de08e120b..8e986478d48d 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -245,13 +245,12 @@ __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 }
 
 static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf)
+				struct vm_fault *vmf, pfn_t *pfn)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct device *dev = &dev_dax->dev;
 	struct dax_region *dax_region;
 	phys_addr_t phys;
-	pfn_t pfn;
 	unsigned int fault_size = PAGE_SIZE;
 
 	if (check_vma(dev_dax, vma, __func__))
@@ -273,13 +272,13 @@ static vm_fault_t __dev_dax_pte_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_mixed(vma, vmf->address, pfn);
+	return vmf_insert_mixed(vma, vmf->address, *pfn);
 }
 
 static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf)
+				struct vm_fault *vmf, pfn_t *pfn)
 {
 	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
@@ -287,7 +286,6 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
-	pfn_t pfn;
 	unsigned int fault_size = PMD_SIZE;
 
 	if (check_vma(dev_dax, vma, __func__))
@@ -322,15 +320,15 @@ static vm_fault_t __dev_dax_pmd_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
+	return vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, *pfn,
 			vmf->flags & FAULT_FLAG_WRITE);
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
-				struct vm_fault *vmf)
+				struct vm_fault *vmf, pfn_t *pfn)
 {
 	unsigned long pud_addr = vmf->address & PUD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
@@ -338,7 +336,6 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 	struct dax_region *dax_region;
 	phys_addr_t phys;
 	pgoff_t pgoff;
-	pfn_t pfn;
 	unsigned int fault_size = PUD_SIZE;
 
 
@@ -374,9 +371,9 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 		return VM_FAULT_SIGBUS;
 	}
 
-	pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
+	*pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
 
-	return vmf_insert_pfn_pud(vma, vmf->address, vmf->pud, pfn,
+	return vmf_insert_pfn_pud(vma, vmf->address, vmf->pud, *pfn,
 			vmf->flags & FAULT_FLAG_WRITE);
 }
 #else
@@ -390,9 +387,11 @@ static vm_fault_t __dev_dax_pud_fault(struct dev_dax *dev_dax,
 static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size)
 {
-	int rc, id;
 	struct vm_area_struct *vma = vmf->vma;
 	struct file *filp = vma->vm_file;
+	unsigned long fault_size;
+	int rc, id;
+	pfn_t pfn;
 	struct dev_dax *dev_dax = filp->private_data;
 
 	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
@@ -402,17 +401,33 @@ static vm_fault_t dev_dax_huge_fault(struct vm_fault *vmf,
 	id = dax_read_lock();
 	switch (pe_size) {
 	case PE_SIZE_PTE:
-		rc = __dev_dax_pte_fault(dev_dax, vmf);
+		fault_size = PAGE_SIZE;
+		rc = __dev_dax_pte_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PMD:
-		rc = __dev_dax_pmd_fault(dev_dax, vmf);
+		fault_size = PMD_SIZE;
+		rc = __dev_dax_pmd_fault(dev_dax, vmf, &pfn);
 		break;
 	case PE_SIZE_PUD:
-		rc = __dev_dax_pud_fault(dev_dax, vmf);
+		fault_size = PUD_SIZE;
+		rc = __dev_dax_pud_fault(dev_dax, vmf, &pfn);
 		break;
 	default:
 		rc = VM_FAULT_SIGBUS;
 	}
+
+	if (rc == VM_FAULT_NOPAGE) {
+		unsigned long i;
+
+		for (i = 0; i < fault_size / PAGE_SIZE; i++) {
+			struct page *page;
+
+			page = pfn_to_page(pfn_t_to_pfn(pfn) + i);
+			if (page->mapping)
+				continue;
+			page->mapping = filp->f_mapping;
+		}
+	}
 	dax_read_unlock(id);
 
 	return rc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
