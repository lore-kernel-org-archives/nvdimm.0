Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 380F322352290
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 17:12:24 -0800 (PST)
Subject: [PATCH] device-dax: remove redundant __func__ in dev_dbg
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 05 Mar 2018 17:09:32 -0800
Message-ID: <152029856688.39547.15137553409024621536.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dynamic debug can be instructed to add the function name to the debug
output using the +f switch, so there is no need for the dax modules to
do it again. If a user decides to add the +f switch for the dax modules'
dynamic debug this results in double prints of the function name.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |   38 +++++++++++++++++---------------------
 drivers/dax/pmem.c   |    6 +++---
 2 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 2137dbc29877..37be5a306c8f 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -257,8 +257,8 @@ static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 
 	dax_region = dev_dax->region;
 	if (dax_region->align > PAGE_SIZE) {
-		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
-			__func__, dax_region->align, fault_size);
+		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
+			dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -267,8 +267,7 @@ static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 
 	phys = dax_pgoff_to_phys(dev_dax, vmf->pgoff, PAGE_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
-				vmf->pgoff);
+		dev_dbg(dev, "pgoff_to_phys(%#lx) failed\n", vmf->pgoff);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -299,14 +298,14 @@ static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 
 	dax_region = dev_dax->region;
 	if (dax_region->align > PMD_SIZE) {
-		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
-			__func__, dax_region->align, fault_size);
+		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
+			dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
 	/* dax pmd mappings require pfn_t_devmap() */
 	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "%s: region lacks devmap flags\n", __func__);
+		dev_dbg(dev, "region lacks devmap flags\n");
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -323,8 +322,7 @@ static int __dev_dax_pmd_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 	pgoff = linear_page_index(vmf->vma, pmd_addr);
 	phys = dax_pgoff_to_phys(dev_dax, pgoff, PMD_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
-				pgoff);
+		dev_dbg(dev, "pgoff_to_phys(%#lx) failed\n", pgoff);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -351,14 +349,14 @@ static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 
 	dax_region = dev_dax->region;
 	if (dax_region->align > PUD_SIZE) {
-		dev_dbg(dev, "%s: alignment (%#x) > fault size (%#x)\n",
-			__func__, dax_region->align, fault_size);
+		dev_dbg(dev, "alignment (%#x) > fault size (%#x)\n",
+			dax_region->align, fault_size);
 		return VM_FAULT_SIGBUS;
 	}
 
 	/* dax pud mappings require pfn_t_devmap() */
 	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) != (PFN_DEV|PFN_MAP)) {
-		dev_dbg(dev, "%s: region lacks devmap flags\n", __func__);
+		dev_dbg(dev, "region lacks devmap flags\n");
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -375,8 +373,7 @@ static int __dev_dax_pud_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
 	pgoff = linear_page_index(vmf->vma, pud_addr);
 	phys = dax_pgoff_to_phys(dev_dax, pgoff, PUD_SIZE);
 	if (phys == -1) {
-		dev_dbg(dev, "%s: pgoff_to_phys(%#lx) failed\n", __func__,
-				pgoff);
+		dev_dbg(dev, "pgoff_to_phys(%#lx) failed\n", pgoff);
 		return VM_FAULT_SIGBUS;
 	}
 
@@ -399,9 +396,8 @@ static int dev_dax_huge_fault(struct vm_fault *vmf,
 	struct file *filp = vmf->vma->vm_file;
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s: %s: %s (%#lx - %#lx) size = %d\n", __func__,
-			current->comm, (vmf->flags & FAULT_FLAG_WRITE)
-			? "write" : "read",
+	dev_dbg(&dev_dax->dev, "%s: %s (%#lx - %#lx) size = %d\n", current->comm,
+			(vmf->flags & FAULT_FLAG_WRITE) ? "write" : "read",
 			vmf->vma->vm_start, vmf->vma->vm_end, pe_size);
 
 	id = dax_read_lock();
@@ -450,7 +446,7 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 	struct dev_dax *dev_dax = filp->private_data;
 	int rc, id;
 
-	dev_dbg(&dev_dax->dev, "%s\n", __func__);
+	dev_dbg(&dev_dax->dev, "trace\n");
 
 	/*
 	 * We lock to check dax_dev liveness and will re-check at
@@ -508,7 +504,7 @@ static int dax_open(struct inode *inode, struct file *filp)
 	struct inode *__dax_inode = dax_inode(dax_dev);
 	struct dev_dax *dev_dax = dax_get_private(dax_dev);
 
-	dev_dbg(&dev_dax->dev, "%s\n", __func__);
+	dev_dbg(&dev_dax->dev, "trace\n");
 	inode->i_mapping = __dax_inode->i_mapping;
 	inode->i_mapping->host = __dax_inode;
 	filp->f_mapping = inode->i_mapping;
@@ -523,7 +519,7 @@ static int dax_release(struct inode *inode, struct file *filp)
 {
 	struct dev_dax *dev_dax = filp->private_data;
 
-	dev_dbg(&dev_dax->dev, "%s\n", __func__);
+	dev_dbg(&dev_dax->dev, "trace\n");
 	return 0;
 }
 
@@ -565,7 +561,7 @@ static void unregister_dev_dax(void *dev)
 	struct inode *inode = dax_inode(dax_dev);
 	struct cdev *cdev = inode->i_cdev;
 
-	dev_dbg(dev, "%s\n", __func__);
+	dev_dbg(dev, "trace\n");
 
 	kill_dev_dax(dev_dax);
 	cdev_device_del(cdev, dev);
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 31b6ecce4c64..f7c0137e9325 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -34,7 +34,7 @@ static void dax_pmem_percpu_release(struct percpu_ref *ref)
 {
 	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
 
-	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	dev_dbg(dax_pmem->dev, "trace\n");
 	complete(&dax_pmem->cmp);
 }
 
@@ -43,7 +43,7 @@ static void dax_pmem_percpu_exit(void *data)
 	struct percpu_ref *ref = data;
 	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
 
-	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	dev_dbg(dax_pmem->dev, "trace\n");
 	wait_for_completion(&dax_pmem->cmp);
 	percpu_ref_exit(ref);
 }
@@ -53,7 +53,7 @@ static void dax_pmem_percpu_kill(void *data)
 	struct percpu_ref *ref = data;
 	struct dax_pmem *dax_pmem = to_dax_pmem(ref);
 
-	dev_dbg(dax_pmem->dev, "%s\n", __func__);
+	dev_dbg(dax_pmem->dev, "trace\n");
 	percpu_ref_kill(ref);
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
