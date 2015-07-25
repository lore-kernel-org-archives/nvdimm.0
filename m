Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 08/25] arch: introduce memremap()
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:38:42 -0400
Message-ID: <20150725023842.8664.97620.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Existing users of ioremap_cache() are mapping memory that is known in
advance to not have i/o side effects.  These users are forced to cast
away the __iomem annotation, or otherwise neglect to fix the sparse
errors thrown when dereferencing pointers to this memory.  Provide
memremap() as a non __iomem annotated ioremap_*() in the case when
ioremap is otherwise a pointer to memory. Outside of ioremap() and
ioremap_nocache(), the expectation is that most calls to
ioremap_<type>() are seeking memory-like semantics (e.g.  speculative
reads, and prefetching permitted).  These callsites can be moved to
memremap() over time.

memremap() is a break from the ioremap implementation pattern of adding
a new memremap_<type>() for each mapping type and having silent
compatibility fall backs.  Instead, the
implementation defines flags that are passed to the central memremap()
and if a mapping type is not supported by an arch memremap returns NULL.

The behavior change to return NULL on an unsupported request is reserved
for a later patch.  This initial implementation starts off by using
ioremap_cache() directly.  Once all ioremap_cache() and ioremap_wt()
instances have been converted the functionality for establishing these
mappings will be pushed to a per-architecture arch_memremap()
implementation.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/ia64/include/asm/io.h   |    1 +
 arch/sh/include/asm/io.h     |    1 +
 arch/xtensa/include/asm/io.h |    1 +
 include/linux/io.h           |    9 +++++
 kernel/Makefile              |    2 +
 kernel/memremap.c            |   82 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+)
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
index fb5a99800e77..dfed9d608bb3 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -121,4 +121,13 @@ static inline int arch_phys_wc_index(int handle)
 #endif
 #endif
 
+enum {
+	MEMREMAP_WB = 1 << 0,
+	MEMREMAP_WT = 1 << 1,
+	MEMREMAP_CACHE = MEMREMAP_WB,
+};
+
+extern void *memremap(resource_size_t offset, size_t size, unsigned long flags);
+extern void memunmap(void *addr);
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
index 000000000000..ba206fd11785
--- /dev/null
+++ b/kernel/memremap.c
@@ -0,0 +1,82 @@
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
+/*
+ * memremap() is "ioremap" for cases where it is known that the resource
+ * being mapped does not have i/o side effects and the __iomem
+ * annotation is not applicable.
+ */
+void *memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	int is_ram = region_is_ram(offset, size);
+	void *addr = NULL;
+
+	if (is_ram < 0) {
+		WARN_ONCE(1, "memremap attempted on mixed range %pa size: %zu\n",
+				&offset, size);
+		return NULL;
+	}
+
+	/* Try all mapping types requested until one returns non-NULL */
+	if (flags & MEMREMAP_CACHE) {
+		flags &= ~MEMREMAP_CACHE;
+		/*
+		 * MEMREMAP_CACHE is special in that it can be satisifed
+		 * from the direct map.  Some archs depend on the
+		 * capability of memremap() to autodetect cases where
+		 * the requested range is potentially in "System RAM"
+		 */
+		if (is_ram)
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
+	if (!addr && is_ram && flags) {
+		WARN_ONCE(1, "memremap attempted on ram %pa size: %zu\n",
+				&offset, size);
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

