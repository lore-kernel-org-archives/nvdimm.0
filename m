Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 651A41A1F78
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 15:55:55 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 05/14] mincore: Add support for PUDs
Date: Thu, 10 Mar 2016 18:55:22 -0500
Message-Id: <1457654131-4562-6-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1457654131-4562-1-git-send-email-matthew.r.wilcox@intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Matthew Wilcox <willy@linux.intel.com>

We don't actually care about the contents of the PUD, as long as it's
present (which is checked by the pagewalk code), so just set the bits
to indicate presence and return.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 mm/mincore.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/mincore.c b/mm/mincore.c
index 563f320..948a906 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -108,6 +108,18 @@ static int mincore_unmapped_range(unsigned long addr, unsigned long end,
 	return 0;
 }
 
+static int mincore_pud_range(pud_t *pud, unsigned long addr, unsigned long end,
+			struct mm_walk *walk)
+{
+	unsigned char *vec = walk->private;
+	int nr = (end - addr) >> PAGE_SHIFT;
+
+	memset(vec, 1, nr);
+	walk->private += nr;
+
+	return 0;
+}
+
 static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
@@ -177,6 +189,7 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 	unsigned long end;
 	int err;
 	struct mm_walk mincore_walk = {
+		.pud_entry = mincore_pud_range,
 		.pmd_entry = mincore_pte_range,
 		.pte_hole = mincore_unmapped_range,
 		.hugetlb_entry = mincore_hugetlb,
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
