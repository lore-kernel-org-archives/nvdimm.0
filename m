Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 367B580291
 for <linux-nvdimm@lists.01.org>; Thu,  9 Mar 2017 15:56:03 -0800 (PST)
Subject: [PATCH 1/2] dax: fix output of function name for the fault handlers
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 09 Mar 2017 16:56:01 -0700
Message-ID: <148910376176.27406.3341100457410288547.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The debug output for return of pgoff_to_phys in the fault handlers are
wrong.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/dax.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 8d9829f..174690a 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -439,7 +439,7 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 
 	phys = pgoff_to_phys(dax_dev, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				vmf->pgoff);
 		return VM_FAULT_SIGBUS;
 	}
@@ -483,7 +483,7 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	pgoff = linear_page_index(vmf->vma, pmd_addr);
 	phys = pgoff_to_phys(dax_dev, pgoff, PMD_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
 		return VM_FAULT_SIGBUS;
 	}
@@ -522,7 +522,7 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 	pgoff = linear_page_index(vmf->vma, pud_addr);
 	phys = pgoff_to_phys(dax_dev, pgoff, PUD_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: phys_to_pgoff(%#lx) failed\n", __func__,
+		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
 				pgoff);
 		return VM_FAULT_SIGBUS;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
