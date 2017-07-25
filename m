Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 7868221C9125C
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 03:54:16 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 6/6] arm64: uaccess: Implement *_flushcache variants
Date: Tue, 25 Jul 2017 11:55:43 +0100
Message-Id: <a82a48f72b8099c1ef6a32a63819619637797ef8.1500397441.git.robin.murphy@arm.com>
In-Reply-To: <cover.1500397441.git.robin.murphy@arm.com>
References: <cover.1500397441.git.robin.murphy@arm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Implement the set of copy functions with guarantees of a clean cache
upon completion necessary to support the pmem driver.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/arm64/Kconfig                  |  1 +
 arch/arm64/include/asm/string.h     |  4 ++++
 arch/arm64/include/asm/uaccess.h    | 12 ++++++++++
 arch/arm64/lib/Makefile             |  2 ++
 arch/arm64/lib/uaccess_flushcache.c | 47 +++++++++++++++++++++++++++++++++++++
 5 files changed, 66 insertions(+)
 create mode 100644 arch/arm64/lib/uaccess_flushcache.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0b0576a54724..e43a63b3d14b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -963,6 +963,7 @@ config ARM64_UAO
 config ARM64_PMEM
 	bool "Enable support for persistent memory"
 	select ARCH_HAS_PMEM_API
+	select ARCH_HAS_UACCESS_FLUSHCACHE
 	help
 	  Say Y to enable support for the persistent memory API based on the
 	  ARMv8.2 DCPoP feature.
diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
index d0aa42907569..dd95d33a5bd5 100644
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -52,6 +52,10 @@ extern void *__memset(void *, int, __kernel_size_t);
 #define __HAVE_ARCH_MEMCMP
 extern int memcmp(const void *, const void *, size_t);
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
+#define __HAVE_ARCH_MEMCPY_FLUSHCACHE
+void memcpy_flushcache(void *dst, const void *src, size_t cnt);
+#endif
 
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
 
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 8f0a1de11e4a..bb056fee297c 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -347,4 +347,16 @@ extern long strncpy_from_user(char *dest, const char __user *src, long count);
 
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+#ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
+struct page;
+void memcpy_page_flushcache(char *to, struct page *page, size_t offset, size_t len);
+extern unsigned long __must_check __copy_user_flushcache(void *to, const void __user *from, unsigned long n);
+
+static inline int __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
+{
+	kasan_check_write(dst, size);
+	return __copy_user_flushcache(dst, src, size);
+}
+#endif
+
 #endif /* __ASM_UACCESS_H */
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index c86b7909ef31..a0abc142c92b 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -17,3 +17,5 @@ CFLAGS_atomic_ll_sc.o	:= -fcall-used-x0 -ffixed-x1 -ffixed-x2		\
 		   -fcall-saved-x10 -fcall-saved-x11 -fcall-saved-x12	\
 		   -fcall-saved-x13 -fcall-saved-x14 -fcall-saved-x15	\
 		   -fcall-saved-x18
+
+lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
diff --git a/arch/arm64/lib/uaccess_flushcache.c b/arch/arm64/lib/uaccess_flushcache.c
new file mode 100644
index 000000000000..b6ceafdb8b72
--- /dev/null
+++ b/arch/arm64/lib/uaccess_flushcache.c
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2017 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/uaccess.h>
+#include <asm/barrier.h>
+#include <asm/cacheflush.h>
+
+void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+{
+	/*
+	 * We assume this should not be called with @dst pointing to
+	 * non-cacheable memory, such that we don't need an explicit
+	 * barrier to order the cache maintenance against the memcpy.
+	 */
+	memcpy(dst, src, cnt);
+	__clean_dcache_area_pop(dst, cnt);
+}
+EXPORT_SYMBOL_GPL(memcpy_flushcache);
+
+void memcpy_page_flushcache(char *to, struct page *page, size_t offset,
+			    size_t len)
+{
+	memcpy_flushcache(to, page_address(page) + offset, len);
+}
+
+unsigned long __copy_user_flushcache(void *to, const void __user *from,
+				     unsigned long n)
+{
+	unsigned long rc = __arch_copy_from_user(to, from, n);
+
+	/* See above */
+	__clean_dcache_area_pop(to, n - rc);
+	return rc;
+}
-- 
2.12.2.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
