Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v4 04/10] arch: introduce memremap()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Aug 2015 23:38:11 -0400
Message-ID: <20150811033811.4987.28661.stgit@otcpl-bsw-rvp-2.jf.intel.com>
In-Reply-To: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
References: <20150811033345.4987.17983.stgit@otcpl-bsw-rvp-2.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: ross.zwisler@linux.intel.com, mcgrof@suse.com, hch@lst.de, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Existing users of ioremap_cache() are mapping memory that is known in
advance to not have i/o side effects.  These users are forced to cast
away the __iomem annotation, or otherwise neglect to fix the sparse
errors thrown when dereferencing pointers to this memory.  Provide
memremap() as a non __iomem annotated ioremap_*() in the case when
ioremap is otherwise a pointer to cacheable memory. Empirically,
ioremap_<cacheable-type>() call sites are seeking memory-like semantics
(e.g.  speculative reads, and prefetching permitted).

memremap() is a break from the ioremap implementation pattern of adding
a new memremap_<type>() for each mapping type and having silent
compatibility fall backs.  Instead, the implementation defines flags
that are passed to the central memremap() and if a mapping type is not
supported by an arch memremap returns NULL.

We introduce a memremap prototype as a trivial wrapper of
ioremap_cache() and ioremap_wt().  Later, once all ioremap_cache() and
ioremap_wt() usage has been removed from drivers we teach archs to
implement arch_memremap() with the ability to strictly enforce the
mapping type.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/ia64/include/asm/io.h   |    1 
 arch/sh/include/asm/io.h     |    1 
 arch/xtensa/include/asm/io.h |    1 
 include/linux/io.h           |    9 ++++
 kernel/Makefile              |    2 +
 kernel/memremap.c            |   98 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 112 insertions(+)
 create mode 100644 kernel/memremap.c

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 80a7e34be009..9041bbe2b7b4 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -435,6 +435,7 @@ static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned lo
 {
 	return ioremap(phys_addr, size);
 }
+#define ioremap_cache ioremap_cache
 
 
 /*
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 728c4c571f40..6194e20fccca 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -342,6 +342,7 @@ ioremap_cache(phys_addr_t offset, unsigned long size)
 {
 	return __ioremap_mode(offset, size, PAGE_KERNEL);
 }
+#define ioremap_cache ioremap_cache
 
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 static inline void __iomem *
diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index c39bb6e61911..867840f5400f 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -57,6 +57,7 @@ static inline void __iomem *ioremap_cache(unsigned long offset,
 	else
 		BUG();
 }
+#define ioremap_cache ioremap_cache
 
 #define ioremap_wc ioremap_nocache
 #define ioremap_wt ioremap_nocache
diff --git a/include/linux/io.h b/include/linux/io.h
index fb5a99800e77..3fcf6256c088 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -121,4 +121,13 @@ static inline int arch_phys_wc_index(int handle)
 #endif
 #endif
 
+enum {
+	/* See memremap() kernel-doc for usage description... */
+	MEMREMAP_WB = 1 << 0,
+	MEMREMAP_WT = 1 << 1,
+};
+
+void *memremap(resource_size_t offset, size_t size, unsigned long flags);
+void memunmap(void *addr);
+
 #endif /* _LINUX_IO_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 43c4c920f30a..92866d36e376 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -99,6 +99,8 @@ obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
 
+obj-$(CONFIG_HAS_IOMEM) += memremap.o
+
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
diff --git a/kernel/memremap.c b/kernel/memremap.c
new file mode 100644
index 000000000000..a293de52e837
--- /dev/null
+++ b/kernel/memremap.c
@@ -0,0 +1,98 @@
+/*
+ * Copyright(c) 2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/types.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+
+#ifndef ioremap_cache
+/* temporary while we convert existing ioremap_cache users to memremap */
+__weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
+{
+	return ioremap(offset, size);
+}
+#endif
+
+/**
+ * memremap() - remap an iomem_resource as cacheable memory
+ * @offset: iomem resource start address
+ * @size: size of remap
+ * @flags: either MEMREMAP_WB or MEMREMAP_WT
+ *
+ * memremap() is "ioremap" for cases where it is known that the resource
+ * being mapped does not have i/o side effects and the __iomem
+ * annotation is not applicable.
+ *
+ * MEMREMAP_WB - matches the default mapping for "System RAM" on
+ * the architecture.  This is usually a read-allocate write-back cache.
+ * Morever, if MEMREMAP_WB is specified and the requested remap region is RAM
+ * memremap() will bypass establishing a new mapping and instead return
+ * a pointer into the direct map.
+ *
+ * MEMREMAP_WT - establish a mapping whereby writes either bypass the
+ * cache or are written through to memory and never exist in a
+ * cache-dirty state with respect to program visibility.  Attempts to
+ * map "System RAM" with this mapping type will fail.
+ */
+void *memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	int is_ram = region_intersects(offset, size, "System RAM");
+	void *addr = NULL;
+
+	if (is_ram == REGION_MIXED) {
+		WARN_ONCE(1, "memremap attempted on mixed range %pa size: %#lx\n",
+				&offset, (unsigned long) size);
+		return NULL;
+	}
+
+	/* Try all mapping types requested until one returns non-NULL */
+	if (flags & MEMREMAP_WB) {
+		flags &= ~MEMREMAP_WB;
+		/*
+		 * MEMREMAP_WB is special in that it can be satisifed
+		 * from the direct map.  Some archs depend on the
+		 * capability of memremap() to autodetect cases where
+		 * the requested range is potentially in "System RAM"
+		 */
+		if (is_ram == REGION_INTERSECTS)
+			addr = __va(offset);
+		else
+			addr = ioremap_cache(offset, size);
+	}
+
+	/*
+	 * If we don't have a mapping yet and more request flags are
+	 * pending then we will be attempting to establish a new virtual
+	 * address mapping.  Enforce that this mapping is not aliasing
+	 * "System RAM"
+	 */
+	if (!addr && is_ram == REGION_INTERSECTS && flags) {
+		WARN_ONCE(1, "memremap attempted on ram %pa size: %#lx\n",
+				&offset, (unsigned long) size);
+		return NULL;
+	}
+
+	if (!addr && (flags & MEMREMAP_WT)) {
+		flags &= ~MEMREMAP_WT;
+		addr = ioremap_wt(offset, size);
+	}
+
+	return addr;
+}
+EXPORT_SYMBOL(memremap);
+
+void memunmap(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		iounmap((void __iomem *) addr);
+}
+EXPORT_SYMBOL(memunmap);

