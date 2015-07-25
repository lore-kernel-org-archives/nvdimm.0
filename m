Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 04/25] mm: enhance region_is_ram() to distinguish
 'unknown' vs 'mixed'
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:21 -0400
Message-ID: <20150725023821.8664.81275.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

region_is_ram() is used to prevent the establishment of aliased mappings
to physical "System RAM" with incompatible cache settings.  However, it
uses "-1" to indicate both "unknown" memory ranges (ranges not described
by platform firmware) and "mixed" ranges (where the parameters describe
a range that partially overlaps "System RAM").

Fix this up by explicitly tracking the "unknown" vs "mixed" resource
cases. In addition to clarifying that "-1" means the requested spanned
RAM and non-RAM resource, this re-write also adds support for detecting
when the requested range completely covers all of a resource.

Finally, the implementation treats overlaps between "unknown" and RAM as
RAM.

Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/resource.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index fed052a1bc9f..119b282985f9 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -493,39 +493,42 @@ int __weak page_is_ram(unsigned long pfn)
 EXPORT_SYMBOL_GPL(page_is_ram);
 
 /*
- * Search for a resouce entry that fully contains the specified region.
- * If found, return 1 if it is RAM, 0 if not.
- * If not found, or region is not fully contained, return -1
+ * Check if the specified region partially overlaps or fully eclipses "System
+ * RAM". Return '0' if the region does not overlap RAM, return '-1' if the
+ * region overlaps RAM and another resource, and return '1' if the region
+ * overlaps RAM and no other defined resource. Note, that '1' is also returned
+ * in the case when the specified region overlaps RAM and undefined memory
+ * holes.
  *
  * Used by the ioremap functions to ensure the user is not remapping RAM and is
  * a vast speed up over walking through the resource table page by page.
  */
 int region_is_ram(resource_size_t start, unsigned long size)
 {
-	struct resource *p;
-	resource_size_t end = start + size - 1;
 	unsigned long flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+	resource_size_t end = start + size - 1;
 	const char *name = "System RAM";
-	int ret = -1;
+	int ram = 0; int other = 0;
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
+		bool is_ram = strcmp(p->name, name) == 0 && p->flags == flags;
+
+		if (start >= p->start && start <= p->end)
+			is_ram ? ram++ : other++;
+		if (end >= p->start && end <= p->end)
+			is_ram ? ram++ : other++;
+		if (p->start >= start && p->end <= end)
+			is_ram ? ram++ : other++;
 	}
 	read_unlock(&resource_lock);
-	return ret;
+
+	if (other == 0)
+		return !!ram;
+	if (ram)
+		return -1;
+	return 0;
 }
 
 void __weak arch_remove_reservations(struct resource *avail)

