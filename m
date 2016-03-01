Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 9D5881A1E57
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 14:15:39 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: check return value of dax_radix_entry()
Date: Tue,  1 Mar 2016 15:15:08 -0700
Message-Id: <1456870508-20385-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

dax_pfn_mkwrite() previously wasn't checking the return value of the call
to dax_radix_entry(), which was a mistake.

Instead, capture this return value and pass it up the stack if it is an
error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7111724..5a587dc 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1056,6 +1056,7 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
 int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
+	int error;
 
 	/*
 	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
@@ -1065,7 +1066,11 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * saves us from having to make a call to get_block() here to look
 	 * up the sector.
 	 */
-	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
+	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
+			true);
+	if (error)
+		return error;
+
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
