Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF3E92034C087
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 19:42:31 -0700 (PDT)
Subject: [PATCH v3 09/13] IB/core: disable memory registration of
 fileystem-dax vmas
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:45 -0700
Message-ID: <150846718583.24336.7817353741483230017.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Sean Hefty <sean.hefty@intel.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Until there is a solution to the dma-to-dax vs truncate problem it is
not safe to allow RDMA to create long standing memory registrations
against filesytem-dax vmas. Device-dax vmas do not have this problem and
are explicitly allowed.

This is temporary until a "memory registration with layout-lease"
mechanism can be implemented, and is limited to non-ODP (On Demand
Paging) capable RDMA devices.

Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: <linux-rdma@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/infiniband/core/umem.c |   49 +++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 21e60b1e2ff4..c30d286c1f24 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -147,19 +147,21 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->hugetlb   = 1;
 
 	page_list = (struct page **) __get_free_page(GFP_KERNEL);
-	if (!page_list) {
-		put_pid(umem->pid);
-		kfree(umem);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!page_list)
+		goto err_pagelist;
 
 	/*
-	 * if we can't alloc the vma_list, it's not so bad;
-	 * just assume the memory is not hugetlb memory
+	 * If DAX is enabled we need the vma to protect against
+	 * registering filesystem-dax memory. Otherwise we can tolerate
+	 * a failure to allocate the vma_list and just assume that all
+	 * vmas are not hugetlb-vmas.
 	 */
 	vma_list = (struct vm_area_struct **) __get_free_page(GFP_KERNEL);
-	if (!vma_list)
+	if (!vma_list) {
+		if (IS_ENABLED(CONFIG_FS_DAX))
+			goto err_vmalist;
 		umem->hugetlb = 0;
+	}
 
 	npages = ib_umem_num_pages(umem);
 
@@ -199,15 +201,34 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		if (ret < 0)
 			goto out;
 
-		umem->npages += ret;
 		cur_base += ret * PAGE_SIZE;
 		npages   -= ret;
 
 		for_each_sg(sg_list_start, sg, ret, i) {
-			if (vma_list && !is_vm_hugetlb_page(vma_list[i]))
-				umem->hugetlb = 0;
+			struct vm_area_struct *vma;
+			struct inode *inode;
 
 			sg_set_page(sg, page_list[i], PAGE_SIZE, 0);
+			umem->npages++;
+
+			if (!vma_list)
+				continue;
+			vma = vma_list[i];
+
+			if (!is_vm_hugetlb_page(vma))
+				umem->hugetlb = 0;
+
+			if (!vma_is_dax(vma))
+				continue;
+
+			/* device-dax is safe for rdma... */
+			inode = file_inode(vma->vm_file);
+			if (inode->i_mode == S_IFCHR)
+				continue;
+
+			/* ...filesystem-dax is not. */
+			ret = -EOPNOTSUPP;
+			goto out;
 		}
 
 		/* preparing for next loop */
@@ -242,6 +263,12 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	free_page((unsigned long) page_list);
 
 	return ret < 0 ? ERR_PTR(ret) : umem;
+err_vmalist:
+	free_page((unsigned long) page_list);
+err_pagelist:
+	put_pid(umem->pid);
+	kfree(umem);
+	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL(ib_umem_get);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
