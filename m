Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2] dax: check return value of dax_radix_entry()
Date: Wed,  2 Mar 2016 10:00:51 -0700
Message-Id: <1456938051-14847-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

dax_pfn_mkwrite() previously wasn't checking the return value of the call
to dax_radix_entry(), which was a mistake.

Instead, capture this return value and return the appropriate VM_FAULT_
value.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7111724..bbb2ad7 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1056,6 +1056,7 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
 int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
+	int error;
 
 	/*
 	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
@@ -1065,7 +1066,13 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * saves us from having to make a call to get_block() here to look
 	 * up the sector.
 	 */
-	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
+	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
+			true);
+
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (error)
+		return VM_FAULT_SIGBUS;
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
-- 
2.5.0
