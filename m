Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/6] x86, pmem: add PMEM API for persistent memory
Date: Thu, 28 May 2015 16:35:50 -0600
Message-Id: <1432852553-24865-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1432852553-24865-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add a new PMEM API to x86, and allow for architectures that do not
implement this API.  Architectures that implement the PMEM API should
define ARCH_HAS_PMEM_API in their kernel configuration and must provide
implementations for persistent_copy(), persistent_flush() and
persistent_sync().

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: linux-nvdimm@lists.01.org
---
 MAINTAINERS                       |  1 +
 arch/x86/Kconfig                  |  3 ++
 arch/x86/include/asm/cacheflush.h | 23 ++++++++++++
 include/linux/pmem.h              | 79 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 106 insertions(+)
 create mode 100644 include/linux/pmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 0448fec8e44a..ca1f3d99618d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5944,6 +5944,7 @@ L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/block/nd/pmem.c
+F:	include/linux/pmem.h
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 23c587938804..eb8f12e715af 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -215,6 +215,9 @@ config ARCH_HAS_CPU_RELAX
 config ARCH_HAS_CACHE_LINE_SIZE
 	def_bool y
 
+config ARCH_HAS_PMEM_API
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 47c8e32f621a..ffd5ccdc86f0 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -4,6 +4,7 @@
 /* Caches aren't brain-dead on the intel. */
 #include <asm-generic/cacheflush.h>
 #include <asm/special_insns.h>
+#include <asm/uaccess.h>
 
 /*
  * The set_memory_* API can be used to change various attributes of a virtual
@@ -84,6 +85,28 @@ int set_pages_rw(struct page *page, int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
+static inline void arch_persistent_copy(void *dst, const void *src, size_t n)
+{
+	/*
+	 * We are copying between two kernel buffers, so it should be
+	 * impossible for us to hit this BUG_ON() because we should never need
+	 * to take a page fault.
+	 */
+	BUG_ON(__copy_from_user_inatomic_nocache(dst,
+				(__user const void *)src, n));
+}
+
+static inline void arch_persistent_flush(void *vaddr, size_t size)
+{
+	clflush_cache_range(vaddr, size);
+}
+
+static inline void arch_persistent_sync(void)
+{
+	wmb();
+	pcommit_sfence();
+}
+
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 extern const int rodata_test_data;
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
new file mode 100644
index 000000000000..88ade7376632
--- /dev/null
+++ b/include/linux/pmem.h
@@ -0,0 +1,79 @@
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
+#ifndef __PMEM_H__
+#define __PMEM_H__
+
+#include <asm/cacheflush.h>
+
+/*
+ * Architectures that define ARCH_HAS_PMEM_API must provide implementations
+ * for persistent_copy(), persistent_flush() and persistent_sync().
+ */
+
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+/**
+ * persistent_copy - copy data to persistent memory
+ * @dst: destination buffer for the copy
+ * @src: source buffer for the copy
+ * @n: length of the copy in bytes
+ *
+ * Perform a memory copy that results in the destination of the copy being
+ * evicted from the processor cache hierarchy ("accepted to memory").  This
+ * can typically be accomplished with non-temporal stores or by regular stores
+ * followed by cache flush commands via persistent_flush().
+ */
+static inline void persistent_copy(void *dst, const void *src, size_t n)
+{
+	arch_persistent_copy(dst, src, n);
+}
+
+/**
+ * persistent_flush - flush a memory range from the processor cache
+ * @vaddr: virtual address to begin flushing
+ * @size: number of bytes to flush
+ *
+ * This call needs to include fencing so that the flushing will be ordered
+ * with respect to both reads and writes.
+ */
+static inline void persistent_flush(void *vaddr, size_t size)
+{
+	arch_persistent_flush(vaddr, size);
+}
+
+/**
+ * persistent_sync - synchronize writes to persistent memory
+ *
+ * To be used after a series of copies and/or flushes, this should perform any
+ * necessary fencing to order writes/flushes and then ensure that writes that
+ * have been "accepted to memory", i.e. previously flushed from the cache
+ * hierarchy, are actually written to the appropriate DIMMs.  This typically
+ * involves making sure they are flushed from any platform buffers not covered
+ * by the cache flushes performed by persistent_flush().
+ */
+static inline void persistent_sync(void)
+{
+	arch_persistent_sync();
+}
+
+#else /* ! CONFIG_ARCH_HAS_PMEM_API */
+
+static inline void persistent_copy(void *dst, const void *src, size_t n)
+{
+	memcpy(dst, src, n);
+}
+static inline void persistent_flush(void *vaddr, size_t size) {}
+static inline void persistent_sync(void) {}
+
+#endif /* CONFIG_ARCH_HAS_PMEM_API */
+
+#endif /* __PMEM_H__ */
-- 
1.9.3

