Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9F9151A1E10
 for <linux-nvdimm@lists.01.org>; Sat, 25 Jun 2016 10:42:23 -0700 (PDT)
Subject: [PATCH 2/2] mm: cleanup ifdef guards for vmem_altmap
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 25 Jun 2016 10:41:07 -0700
Message-ID: <146687646788.39261.8020536391978771940.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146687645727.39261.14620086569655191314.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Now that ZONE_DEVICE depends on SPARSEMEM_VMEMMAP we can simplify some
ifdef guards to just ZONE_DEVICE.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h |    2 +-
 kernel/memremap.c        |    8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index bcaa634139a9..93416196ba64 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -26,7 +26,7 @@ struct vmem_altmap {
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
 
-#if defined(CONFIG_SPARSEMEM_VMEMMAP) && defined(CONFIG_ZONE_DEVICE)
+#ifdef CONFIG_ZONE_DEVICE
 struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start);
 #else
 static inline struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 017532193fb1..ddb3247a872a 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -308,12 +308,6 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	if (is_ram == REGION_INTERSECTS)
 		return __va(res->start);
 
-	if (altmap && !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP)) {
-		dev_err(dev, "%s: altmap requires CONFIG_SPARSEMEM_VMEMMAP=y\n",
-				__func__);
-		return ERR_PTR(-ENXIO);
-	}
-
 	if (!ref)
 		return ERR_PTR(-EINVAL);
 
@@ -401,7 +395,6 @@ void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns)
 	altmap->alloc -= nr_pfns;
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
 {
 	/*
@@ -427,5 +420,4 @@ struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
 
 	return pgmap ? pgmap->altmap : NULL;
 }
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 #endif /* CONFIG_ZONE_DEVICE */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
