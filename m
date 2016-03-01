Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 5B51E1A1E3E
 for <linux-nvdimm@lists.01.org>; Mon, 29 Feb 2016 18:57:02 -0800 (PST)
Subject: [PATCH 2/2] mm: fix mixed zone detection in devm_memremap_pages
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Feb 2016 18:56:31 -0800
Message-ID: <20160301025631.12812.85197.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160301025620.12812.87268.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160301025620.12812.87268.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The check for whether we overlap "System RAM" needs to be done at
section granularity.  For example a system with the following mapping:

    100000000-37bffffff : System RAM
    37c000000-837ffffff : Persistent Memory

...is unable to use devm_memremap_pages() as it would result in two
zones colliding within a given section.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/memremap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index b981a7b023f0..4c7d08339f62 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -270,9 +270,10 @@ struct dev_pagemap *find_dev_pagemap(resource_size_t phys)
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	int is_ram = region_intersects(res->start, resource_size(res),
-			"System RAM");
-	resource_size_t key, align_start, align_size, align_end;
+	resource_size_t align_start = res->start & ~(SECTION_SIZE - 1);
+	resource_size_t align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	int is_ram = region_intersects(align_start, align_size, "System RAM");
+	resource_size_t key, align_end;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
 	unsigned long pfn;
@@ -314,8 +315,6 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	align_end = align_start + align_size - 1;
 	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
 		struct dev_pagemap *dup;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
