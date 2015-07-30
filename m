Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 01/24] mm: enhance region_is_ram() to region_intersects()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:53:45 -0400
Message-ID: <20150730165345.33962.80299.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

region_is_ram() is used to prevent the establishment of aliased mappings
to physical "System RAM" with incompatible cache settings.  However, it
uses "-1" to indicate both "unknown" memory ranges (ranges not described
by platform firmware) and "mixed" ranges (where the parameters describe
a range that partially overlaps "System RAM").

Fix this up by explicitly tracking the "unknown" vs "mixed" resource
cases and returning REGION_INTERSECTS, REGION_MIXED, or REGION_DISJOINT.
This re-write also adds support for detecting when the requested region
completely eclipses all of a resource.  Note, the implementation treats
overlaps between "unknown" and the requested memory type as
REGION_INTERSECTS.

Finally, other memory types can be passed in by name, for now the only
usage "System RAM".

Suggested-by: Luis R. Rodriguez <mcgrof@suse.com>
Reviewed-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h |    9 +++++++-
 kernel/resource.c  |   61 +++++++++++++++++++++++++++++++---------------------
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2e872f92dbac..84b05ebedb2d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -369,7 +369,14 @@ static inline int put_page_unless_one(struct page *page)
 }
 
 extern int page_is_ram(unsigned long pfn);
-extern int region_is_ram(resource_size_t phys_addr, unsigned long size);
+
+enum {
+	REGION_INTERSECTS,
+	REGION_DISJOINT,
+	REGION_MIXED,
+};
+
+int region_intersects(resource_size_t offset, size_t size, const char *type);
 
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
diff --git a/kernel/resource.c b/kernel/resource.c
index fed052a1bc9f..f150dbbe6f62 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -492,40 +492,51 @@ int __weak page_is_ram(unsigned long pfn)
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
-/*
- * Search for a resouce entry that fully contains the specified region.
- * If found, return 1 if it is RAM, 0 if not.
- * If not found, or region is not fully contained, return -1
+/**
+ * region_intersects() - determine intersection of region with known resources
+ * @start: region start address
+ * @size: size of region
+ * @name: name of resource (in iomem_resource)
  *
- * Used by the ioremap functions to ensure the user is not remapping RAM and is
- * a vast speed up over walking through the resource table page by page.
+ * Check if the specified region partially overlaps or fully eclipses a
+ * resource identified by @name.  Return REGION_DISJOINT if the region
+ * does not overlap @name, return REGION_MIXED if the region overlaps
+ * @type and another resource, and return REGION_INTERSECTS if the
+ * region overlaps @type and no other defined resource. Note, that
+ * REGION_INTERSECTS is also returned in the case when the specified
+ * region overlaps RAM and undefined memory holes.
+ *
+ * region_intersect() is used by memory remapping functions to ensure
+ * the user is not remapping RAM and is a vast speed up over walking
+ * through the resource table page by page.
  */
-int region_is_ram(resource_size_t start, unsigned long size)
+int region_intersects(resource_size_t start, size_t size, const char *name)
 {
-	struct resource *p;
-	resource_size_t end = start + size - 1;
 	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-	const char *name = "System RAM";
-	int ret = -1;
+	resource_size_t end = start + size - 1;
+	int type = 0; int other = 0;
+	struct resource *p;
 
 	read_lock(&resource_lock);
 	for (p = iomem_resource.child; p ; p = p->sibling) {
-		if (p->end < start)
-			continue;
-
-		if (p->start <= start && end <= p->end) {
-			/* resource fully contains region */
-			if ((p->flags != flags) || strcmp(p->name, name))
-				ret = 0;
-			else
-				ret = 1;
-			break;
-		}
-		if (end < p->start)
-			break;	/* not found */
+		bool is_type = strcmp(p->name, name) == 0 && p->flags == flags;
+
+		if (start >= p->start && start <= p->end)
+			is_type ? type++ : other++;
+		if (end >= p->start && end <= p->end)
+			is_type ? type++ : other++;
+		if (p->start >= start && p->end <= end)
+			is_type ? type++ : other++;
 	}
 	read_unlock(&resource_lock);
-	return ret;
+
+	if (other == 0)
+		return type ? REGION_INTERSECTS : REGION_DISJOINT;
+
+	if (type)
+		return REGION_MIXED;
+
+	return REGION_DISJOINT;
 }
 
 void __weak arch_remove_reservations(struct resource *avail)

