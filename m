Return-Path: <owner-linux-mm@kvack.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/3] resource: Add region_intersects_pmem()
Date: Thu, 22 Oct 2015 17:20:43 -0600
Message-Id: <1445556044-30322-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1445556044-30322-1-git-send-email-toshi.kani@hpe.com>
References: <1445556044-30322-1-git-send-email-toshi.kani@hpe.com>
Sender: owner-linux-mm@kvack.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, rjw@rjwysocki.net
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add region_intersects_pmem(), which checks if a specified address
range is persistent memory registered as "Persistent Memory" in
the iomem_resource list.

Note, it does not support legacy persistent memory registered as
"Persistent Memory (legacy)".  It can be supported by extending
this function or a separate function, if necessary.

This interface is exported so that it can be called from modules,
such as the EINJ driver.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
---
 include/linux/mm.h |    1 +
 kernel/resource.c  |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 699224e..ae1790f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -361,6 +361,7 @@ enum {
 int region_intersects(resource_size_t offset, size_t size, const char *type,
 			unsigned long flags);
 int region_intersects_ram(resource_size_t offset, size_t size);
+int region_intersects_pmem(resource_size_t offset, size_t size);
 
 /* Support for virtually mapped pages */
 struct page *vmalloc_to_page(const void *addr);
diff --git a/kernel/resource.c b/kernel/resource.c
index 8a77ed8..b6b61a1 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -547,6 +547,18 @@ int region_intersects_ram(resource_size_t start, size_t size)
 				 IORESOURCE_MEM | IORESOURCE_BUSY);
 }
 
+/*
+ * region_intersects_pmem() checks if a specified address range is
+ * persistent memory, registered as "Persistent Memory", in the
+ * iomem_resource list.
+ */
+int region_intersects_pmem(resource_size_t start, size_t size)
+{
+	return region_intersects(start, size, "Persistent Memory",
+				 IORESOURCE_MEM);
+}
+EXPORT_SYMBOL_GPL(region_intersects_pmem);
+
 void __weak arch_remove_reservations(struct resource *avail)
 {
 }

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
