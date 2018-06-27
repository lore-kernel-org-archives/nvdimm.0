Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9465D21B02845
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 08:43:59 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v2] dev-dax: check_vma: ratelimit dev_info-s
Date: Wed, 27 Jun 2018 11:43:58 -0400
Message-ID: <x49h8logrpd.fsf@segfault.boston.devel.redhat.com>
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
To: "Dan J. Williams" <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This is easily triggered from userspace, so let's ratelimit the
messages.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

---
v2 - fix up all of the dev_info calls in check_vma

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index de2f8297a210..108c37fca782 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -189,14 +189,16 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 
 	/* prevent private mappings from being established */
 	if ((vma->vm_flags & VM_MAYSHARE) != VM_MAYSHARE) {
-		dev_info(dev, "%s: %s: fail, attempted private mapping\n",
+		dev_info_ratelimited(dev,
+				"%s: %s: fail, attempted private mapping\n",
 				current->comm, func);
 		return -EINVAL;
 	}
 
 	mask = dax_region->align - 1;
 	if (vma->vm_start & mask || vma->vm_end & mask) {
-		dev_info(dev, "%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
+		dev_info_ratelimited(dev,
+				"%s: %s: fail, unaligned vma (%#lx - %#lx, %#lx)\n",
 				current->comm, func, vma->vm_start, vma->vm_end,
 				mask);
 		return -EINVAL;
@@ -204,13 +206,15 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 
 	if ((dax_region->pfn_flags & (PFN_DEV|PFN_MAP)) == PFN_DEV
 			&& (vma->vm_flags & VM_DONTCOPY) == 0) {
-		dev_info(dev, "%s: %s: fail, dax range requires MADV_DONTFORK\n",
+		dev_info_ratelimited(dev,
+				"%s: %s: fail, dax range requires MADV_DONTFORK\n",
 				current->comm, func);
 		return -EINVAL;
 	}
 
 	if (!vma_is_dax(vma)) {
-		dev_info(dev, "%s: %s: fail, vma is not DAX capable\n",
+		dev_info_ratelimited(dev,
+				"%s: %s: fail, vma is not DAX capable\n",
 				current->comm, func);
 		return -EINVAL;
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
