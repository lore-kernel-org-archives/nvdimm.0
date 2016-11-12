Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0ED9381DC8
 for <linux-nvdimm@lists.01.org>; Fri, 11 Nov 2016 20:24:39 -0800 (PST)
Subject: [PATCH] mm: disable numa migration faults for dax vmas
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Nov 2016 20:21:41 -0800
Message-ID: <147892450132.22062.16875659431109209179.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

Mark dax vmas as not migratable to exclude them from task_numa_work().
This is especially relevant for device-dax which wants to ensure
predictable access latency and not incur periodic faults.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mempolicy.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 5e5b2969d931..d72c691afaa6 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -7,6 +7,7 @@
 
 
 #include <linux/mmzone.h>
+#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
@@ -177,6 +178,9 @@ static inline bool vma_migratable(struct vm_area_struct *vma)
 	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
 		return false;
 
+	if (vma_is_dax(vma))
+		return false;
+
 #ifndef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	if (vma->vm_flags & VM_HUGETLB)
 		return false;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
