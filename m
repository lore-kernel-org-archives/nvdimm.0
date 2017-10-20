Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A99FB2034C087
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 19:42:04 -0700 (PDT)
Subject: [PATCH v3 04/13] dax: stop using VM_HUGEPAGE for dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:18 -0700
Message-ID: <150846715834.24336.16116465399870762825.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

This flag is deprecated in favor of the vma_is_dax() check in
transparent_hugepage_enabled() added in commit baabda261424 "mm: always
enable thp for dax mappings"

Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device.c |    1 -
 fs/ext4/file.c       |    1 -
 fs/xfs/xfs_file.c    |    2 --
 3 files changed, 4 deletions(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index ed79d006026e..74a35eb5e6d3 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -450,7 +450,6 @@ static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
 		return rc;
 
 	vma->vm_ops = &dax_vm_ops;
-	vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0cc9d205bd96..a54e1b4c49f9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -352,7 +352,6 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c419c6fdb769..c6780743f8ec 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1133,8 +1133,6 @@ xfs_file_mmap(
 {
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
-	if (IS_DAX(file_inode(filp)))
-		vma->vm_flags |= VM_HUGEPAGE;
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
