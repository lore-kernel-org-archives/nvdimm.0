Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 728222097DD18
 for <linux-nvdimm@lists.01.org>; Mon, 16 Jul 2018 10:10:46 -0700 (PDT)
Subject: [PATCH v2 05/14] mm, memremap: Up-level foreach_order_pgoff()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 Jul 2018 10:00:48 -0700
Message-ID: <153176044796.12695.10692625606054072713.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153176041838.12695.3365448145295112857.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The foreach_order_pgoff() helper takes advantage of the ability to
insert multi-order entries into a radix. It is currently used by
devm_memremap_pages() to minimize the number of entries in the pgmap
radix. Instead of dividing a range by a constant power-of-2 sized unit
and inserting an entry for each unit, it determines the maximum
power-of-2 sized entry (subject to alignment offset) that can be
inserted at each iteration.

Up-level this helper so it can be used for populating other radix
instances. For example asynchronous-memmap-initialization-thread lookups
arriving in a follow on change.

Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h |   25 +++++++++++++++++++++++++
 kernel/memremap.c        |   25 -------------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index bfdc7363b13b..bff314de3f55 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -126,6 +126,31 @@ struct dev_pagemap {
 	enum memory_type type;
 };
 
+static inline unsigned long order_at(struct resource *res, unsigned long pgoff)
+{
+	unsigned long phys_pgoff = PHYS_PFN(res->start) + pgoff;
+	unsigned long nr_pages, mask;
+
+	nr_pages = PHYS_PFN(resource_size(res));
+	if (nr_pages == pgoff)
+		return ULONG_MAX;
+
+	/*
+	 * What is the largest aligned power-of-2 range available from
+	 * this resource pgoff to the end of the resource range,
+	 * considering the alignment of the current pgoff?
+	 */
+	mask = phys_pgoff | rounddown_pow_of_two(nr_pages - pgoff);
+	if (!mask)
+		return ULONG_MAX;
+
+	return find_first_bit(&mask, BITS_PER_LONG);
+}
+
+#define foreach_order_pgoff(res, order, pgoff) \
+	for (pgoff = 0, order = order_at((res), pgoff); order < ULONG_MAX; \
+			pgoff += 1UL << order, order = order_at((res), pgoff))
+
 #ifdef CONFIG_ZONE_DEVICE
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap,
 		void (*kill)(struct percpu_ref *));
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 85e4a7c576b2..fc2f28033460 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -16,31 +16,6 @@ static RADIX_TREE(pgmap_radix, GFP_KERNEL);
 #define SECTION_MASK ~((1UL << PA_SECTION_SHIFT) - 1)
 #define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
-static unsigned long order_at(struct resource *res, unsigned long pgoff)
-{
-	unsigned long phys_pgoff = PHYS_PFN(res->start) + pgoff;
-	unsigned long nr_pages, mask;
-
-	nr_pages = PHYS_PFN(resource_size(res));
-	if (nr_pages == pgoff)
-		return ULONG_MAX;
-
-	/*
-	 * What is the largest aligned power-of-2 range available from
-	 * this resource pgoff to the end of the resource range,
-	 * considering the alignment of the current pgoff?
-	 */
-	mask = phys_pgoff | rounddown_pow_of_two(nr_pages - pgoff);
-	if (!mask)
-		return ULONG_MAX;
-
-	return find_first_bit(&mask, BITS_PER_LONG);
-}
-
-#define foreach_order_pgoff(res, order, pgoff) \
-	for (pgoff = 0, order = order_at((res), pgoff); order < ULONG_MAX; \
-			pgoff += 1UL << order, order = order_at((res), pgoff))
-
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
 int device_private_entry_fault(struct vm_area_struct *vma,
 		       unsigned long addr,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
