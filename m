Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 2/7] pmem, x86: move x86 PMEM API to new pmem.h header
Date: Tue, 18 Aug 2015 13:55:36 -0600
Message-Id: <1439927741-29580-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.com>, Joe Perches <joe@perches.com>, Juergen Gross <jgross@suse.com>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Toshi Kani <toshi.kani@hp.com>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Move the x86 PMEM API implementation out of asm/cacheflush.h and into
its own header asm/pmem.h.  This will allow members of the PMEM API to
be more easily identified on this and other architectures.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS                       |  1 +
 arch/x86/include/asm/cacheflush.h | 71 ------------------------------
 arch/x86/include/asm/pmem.h       | 92 +++++++++++++++++++++++++++++++++++++++
 include/linux/pmem.h              |  2 +-
 4 files changed, 94 insertions(+), 72 deletions(-)
 create mode 100644 arch/x86/include/asm/pmem.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 9289ecb..8fcde371 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6161,6 +6161,7 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
 F:	drivers/nvdimm/pmem.c
 F:	include/linux/pmem.h
+F:	arch/*/include/asm/pmem.h
 
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 9bf3ea1..471418a 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -109,75 +109,4 @@ static inline int rodata_test(void)
 }
 #endif
 
-#ifdef ARCH_HAS_NOCACHE_UACCESS
-
-/**
- * arch_memcpy_to_pmem - copy data to persistent memory
- * @dst: destination buffer for the copy
- * @src: source buffer for the copy
- * @n: length of the copy in bytes
- *
- * Copy data to persistent memory media via non-temporal stores so that
- * a subsequent arch_wmb_pmem() can flush cpu and memory controller
- * write buffers to guarantee durability.
- */
-static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
-		size_t n)
-{
-	int unwritten;
-
-	/*
-	 * We are copying between two kernel buffers, if
-	 * __copy_from_user_inatomic_nocache() returns an error (page
-	 * fault) we would have already reported a general protection fault
-	 * before the WARN+BUG.
-	 */
-	unwritten = __copy_from_user_inatomic_nocache((void __force *) dst,
-			(void __user *) src, n);
-	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
-				__func__, dst, src, unwritten))
-		BUG();
-}
-
-/**
- * arch_wmb_pmem - synchronize writes to persistent memory
- *
- * After a series of arch_memcpy_to_pmem() operations this drains data
- * from cpu write buffers and any platform (memory controller) buffers
- * to ensure that written data is durable on persistent memory media.
- */
-static inline void arch_wmb_pmem(void)
-{
-	/*
-	 * wmb() to 'sfence' all previous writes such that they are
-	 * architecturally visible to 'pcommit'.  Note, that we've
-	 * already arranged for pmem writes to avoid the cache via
-	 * arch_memcpy_to_pmem().
-	 */
-	wmb();
-	pcommit_sfence();
-}
-
-static inline bool __arch_has_wmb_pmem(void)
-{
-#ifdef CONFIG_X86_64
-	/*
-	 * We require that wmb() be an 'sfence', that is only guaranteed on
-	 * 64-bit builds
-	 */
-	return static_cpu_has(X86_FEATURE_PCOMMIT);
-#else
-	return false;
-#endif
-}
-#else /* ARCH_HAS_NOCACHE_UACCESS i.e. ARCH=um */
-extern void arch_memcpy_to_pmem(void __pmem *dst, const void *src, size_t n);
-extern void arch_wmb_pmem(void);
-
-static inline bool __arch_has_wmb_pmem(void)
-{
-	return false;
-}
-#endif
-
 #endif /* _ASM_X86_CACHEFLUSH_H */
diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
new file mode 100644
index 0000000..f43462c
--- /dev/null
+++ b/arch/x86/include/asm/pmem.h
@@ -0,0 +1,92 @@
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
+#ifndef __ASM_X86_PMEM_H__
+#define __ASM_X86_PMEM_H__
+
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/cpufeature.h>
+#include <asm/special_insns.h>
+
+#ifdef ARCH_HAS_NOCACHE_UACCESS
+
+/**
+ * arch_memcpy_to_pmem - copy data to persistent memory
+ * @dst: destination buffer for the copy
+ * @src: source buffer for the copy
+ * @n: length of the copy in bytes
+ *
+ * Copy data to persistent memory media via non-temporal stores so that
+ * a subsequent arch_wmb_pmem() can flush cpu and memory controller
+ * write buffers to guarantee durability.
+ */
+static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
+		size_t n)
+{
+	int unwritten;
+
+	/*
+	 * We are copying between two kernel buffers, if
+	 * __copy_from_user_inatomic_nocache() returns an error (page
+	 * fault) we would have already reported a general protection fault
+	 * before the WARN+BUG.
+	 */
+	unwritten = __copy_from_user_inatomic_nocache((void __force *) dst,
+			(void __user *) src, n);
+	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
+				__func__, dst, src, unwritten))
+		BUG();
+}
+
+/**
+ * arch_wmb_pmem - synchronize writes to persistent memory
+ *
+ * After a series of arch_memcpy_to_pmem() operations this drains data
+ * from cpu write buffers and any platform (memory controller) buffers
+ * to ensure that written data is durable on persistent memory media.
+ */
+static inline void arch_wmb_pmem(void)
+{
+	/*
+	 * wmb() to 'sfence' all previous writes such that they are
+	 * architecturally visible to 'pcommit'.  Note, that we've
+	 * already arranged for pmem writes to avoid the cache via
+	 * arch_memcpy_to_pmem().
+	 */
+	wmb();
+	pcommit_sfence();
+}
+
+static inline bool __arch_has_wmb_pmem(void)
+{
+#ifdef CONFIG_X86_64
+	/*
+	 * We require that wmb() be an 'sfence', that is only guaranteed on
+	 * 64-bit builds
+	 */
+	return static_cpu_has(X86_FEATURE_PCOMMIT);
+#else
+	return false;
+#endif
+}
+#else /* ARCH_HAS_NOCACHE_UACCESS i.e. ARCH=um */
+extern void arch_memcpy_to_pmem(void __pmem *dst, const void *src, size_t n);
+extern void arch_wmb_pmem(void);
+
+static inline bool __arch_has_wmb_pmem(void)
+{
+	return false;
+}
+#endif
+
+#endif /* __ASM_X86_PMEM_H__ */
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 20c367c..c2af613 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -16,7 +16,7 @@
 #include <linux/io.h>
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
-#include <asm/cacheflush.h>
+#include <asm/pmem.h>
 #else
 static inline void arch_wmb_pmem(void)
 {
-- 
2.1.0

