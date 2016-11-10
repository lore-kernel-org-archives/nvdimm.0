Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77EF381E6D
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 14:14:55 -0800 (PST)
Subject: [PATCH] mm: add ZONE_DEVICE statistics to smaps
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Nov 2016 14:11:57 -0800
Message-ID: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ZONE_DEVICE pages are mapped into a process via the filesystem-dax and
device-dax mechanisms.  There are also proposals to use ZONE_DEVICE
pages for other usages outside of dax.  Add statistics to smaps so
applications can debug that they are obtaining the mappings they expect,
or otherwise accounting them.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/proc/task_mmu.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 35b92d81692f..6765cafcf057 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -445,6 +445,8 @@ struct mem_size_stats {
 	unsigned long swap;
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
+	unsigned long device;
+	unsigned long device_huge;
 	u64 pss;
 	u64 swap_pss;
 	bool check_shmem_swap;
@@ -458,6 +460,8 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 
 	if (PageAnon(page))
 		mss->anonymous += size;
+	else if (is_zone_device_page(page))
+		mss->device += size;
 
 	mss->resident += size;
 	/* Accumulate the size in pages that have been accessed. */
@@ -575,7 +579,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	else if (PageSwapBacked(page))
 		mss->shmem_thp += HPAGE_PMD_SIZE;
 	else if (is_zone_device_page(page))
-		/* pass */;
+		mss->device_huge += HPAGE_PMD_SIZE;
 	else
 		VM_BUG_ON_PAGE(1, page);
 	smaps_account(mss, page, true, pmd_young(*pmd), pmd_dirty(*pmd));
@@ -774,6 +778,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 		   "ShmemPmdMapped: %8lu kB\n"
 		   "Shared_Hugetlb: %8lu kB\n"
 		   "Private_Hugetlb: %7lu kB\n"
+		   "Device:         %8lu kB\n"
+		   "DeviceHugePages: %7lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
@@ -792,6 +798,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
 		   mss.shmem_thp >> 10,
 		   mss.shared_hugetlb >> 10,
 		   mss.private_hugetlb >> 10,
+		   mss.device >> 10,
+		   mss.device_huge >> 10,
 		   mss.swap >> 10,
 		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
 		   vma_kernel_pagesize(vma) >> 10,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
