Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x243.google.com (mail-pg0-x243.google.com
 [IPv6:2607:f8b0:400e:c05::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1345321A6F105
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 08:59:52 -0700 (PDT)
Received: by mail-pg0-x243.google.com with SMTP id 79so236859pgf.0
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 08:59:52 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] device-dax: Improve fault handler debug output
Date: Wed, 12 Apr 2017 01:59:36 +1000
Message-Id: <20170411155936.11251-1-oohall@gmail.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A couple of minor improvements to the debug output in the fault handlers:

a) Print the region alignment and fault size when we sent a SIGBUS
   because the region alignment is greater than the fault size.
b) Fix the message in the PFN_{DEV|MAP} check.
c) Additionally print the fault size enum value in the huge fault handler.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 drivers/dax/dax.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index ef93aa84622b..c7a977aef337 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -395,7 +395,8 @@ static int __dax_dev_pte_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 
 	dax_region = dax_dev->region;
 	if (dax_region->align > PAGE_SIZE) {
-		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
+			__func__, dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -436,13 +437,14 @@ static int __dax_dev_pmd_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 
 	dax_region = dax_dev->region;
 	if (dax_region->align > PMD_SIZE) {
-		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
+			__func__, dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		dev_dbg(dev, "%s: region lacks devmap flags\n", __func__);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -487,13 +489,14 @@ static int __dax_dev_pud_fault(struct dax_dev *dax_dev, struct vm_fault *vmf)
 
 	dax_region = dax_dev->region;
 	if (dax_region->align > PUD_SIZE) {
-		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
+			__func__, dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
 	/* dax pud mappings require pfn_t_devmap() */
 	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "%s: alignment > fault size\n", __func__);
+		dev_dbg(dev, "%s: region lacks devmap flags\n", __func__);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -534,10 +537,10 @@ static int dax_dev_huge_fault(struct vm_fault *vmf,
 	struct file *filp = vmf->vma->vm_file;
 	struct dax_dev *dax_dev = filp->private_data;
 
-	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx)\n", __func__,
+	dev_dbg(&dax_dev->dev, "%s: %s: %s (%#lx - %#lx) size = %d\n", __func__,
 			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
 			? "write" : "read",
-			vmf->vma->vm_start, vmf->vma->vm_end);
+			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
 
 	id = srcu_read_lock(&dax_srcu);
 	switch (pe_size) {
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
