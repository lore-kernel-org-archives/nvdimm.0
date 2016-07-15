Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from invmail3.skhynix.com (exvmail3.skhynix.com [166.125.252.90])
 by ml01.01.org (Postfix) with ESMTP id 0FE0B1A1F2A
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 19:47:26 -0700 (PDT)
From: Kwangwoo Lee <kwangwoo.lee@sk.com>
Subject: [PATCH v3 3/3] arm64: pmem: add pmem support codes
Date: Fri, 15 Jul 2016 11:46:22 +0900
Message-Id: <1468550782-14454-4-git-send-email-kwangwoo.lee@sk.com>
In-Reply-To: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
References: <1468550782-14454-1-git-send-email-kwangwoo.lee@sk.com>
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
To: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Kwangwoo Lee <kwangwoo.lee@sk.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>
List-ID: <linux-nvdimm@lists.01.org>

This patch adds support pmem on arm64 platform. The limitation of
current implementation is that the persistency of pmem on NVDIMM
is not guaranteed on arm64 yet.

pmem driver expects that the persistency need to be guaranteed in
arch_wmb_pmem(), but the PoP(Point of Persistency) is going to be
supported on ARMv8.2 with DC CVAP instruction. Until then,
__arch_has_wmb_pmem() will return false and shows warning message.

[    6.250487] nd_pmem namespace0.0: unable to guarantee persistence of writes
[    6.305000] pmem0: detected capacity change from 0 to 1073741824
...
[   29.215249] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[   29.308960] EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: dax

Signed-off-by: Kwangwoo Lee <kwangwoo.lee@sk.com>
---
 arch/arm64/Kconfig            |   1 +
 arch/arm64/include/asm/pmem.h | 143 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)
 create mode 100644 arch/arm64/include/asm/pmem.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 12546ce..e14fd31 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -16,6 +16,7 @@ config ARM64
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_MMIO_FLUSH
+	select ARCH_HAS_PMEM_API
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/include/asm/pmem.h b/arch/arm64/include/asm/pmem.h
new file mode 100644
index 0000000..0bcfd87
--- /dev/null
+++ b/arch/arm64/include/asm/pmem.h
@@ -0,0 +1,143 @@
+/*
+ * Based on arch/x86/include/asm/pmem.h
+ *
+ * Copyright(c) 2016 SK hynix Inc. Kwangwoo Lee <kwangwoo.lee@sk.com>
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
+#ifndef __ASM_PMEM_H__
+#define __ASM_PMEM_H__
+
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+
+/**
+ * arch_memcpy_to_pmem - copy data to persistent memory
+ * @dst: destination buffer for the copy
+ * @src: source buffer for the copy
+ * @n: length of the copy in bytes
+ *
+ * Copy data to persistent memory media. if ARCH_HAS_PMEM_API is defined,
+ * then MEMREMAP_WB is used to memremap() during probe. A subsequent
+ * arch_wmb_pmem() need to guarantee durability.
+ */
+static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
+		size_t n)
+{
+	memcpy((void __force *) dst, src, n);
+	__flush_dcache_area(dst, n);
+}
+
+static inline int arch_memcpy_from_pmem(void *dst, const void __pmem *src,
+		size_t n)
+{
+	memcpy(dst, (void __force *) src, n);
+	return 0;
+}
+
+/**
+ * arch_wmb_pmem - synchronize writes to persistent memory
+ *
+ * After a series of arch_memcpy_to_pmem() operations this need to be called to
+ * ensure that written data is durable on persistent memory media.
+ */
+static inline void arch_wmb_pmem(void)
+{
+	/* pmem writes has been done in arch_memcpy_to_pmem() */
+	wmb();
+
+	/*
+	 * ARMv8.2 will support DC CVAP to ensure Point-of-Persistency and here
+	 * is the point for the API like __clean_dcache_area_pop().
+	 */
+}
+
+/**
+ * arch_wb_cache_pmem - write back a cache range
+ * @vaddr:	virtual start address
+ * @size:	number of bytes to write back
+ *
+ * Write back a cache range. Leave data in cache for performance of next access.
+ * This function requires explicit ordering with an arch_wmb_pmem() call.
+ */
+static inline void arch_wb_cache_pmem(void __pmem *addr, size_t size)
+{
+	/*
+	 * Just clean cache to PoC. The data in cache is remained to use the
+	 * next access. arch_wmb_pmem() need to be the point to ensure the
+	 * persistency under the current implementation.
+	 */
+	__clean_dcache_area(addr, size);
+}
+
+/**
+ * arch_copy_from_iter_pmem - copy data from an iterator to PMEM
+ * @addr:	PMEM destination address
+ * @bytes:	number of bytes to copy
+ * @i:		iterator with source data
+ *
+ * Copy data from the iterator 'i' to the PMEM buffer starting at 'addr'.
+ * This function requires explicit ordering with an arch_wmb_pmem() call.
+ */
+static inline size_t arch_copy_from_iter_pmem(void __pmem *addr, size_t bytes,
+		struct iov_iter *i)
+{
+	void *vaddr = (void __force *)addr;
+	size_t len;
+
+	/*
+	 * ARCH_HAS_NOCACHE_UACCESS is not defined and the default mapping is
+	 * MEMREMAP_WB. Instead of using copy_from_iter_nocache(), use cacheable
+	 * version and call arch_wb_cache_pmem().
+	 */
+	len = copy_from_iter(vaddr, bytes, i);
+
+	arch_wb_cache_pmem(addr, bytes);
+
+	return len;
+}
+
+/**
+ * arch_clear_pmem - zero a PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to zero
+ *
+ * Write zeros into the memory range starting at 'addr' for 'size' bytes.
+ * This function requires explicit ordering with an arch_wmb_pmem() call.
+ */
+static inline void arch_clear_pmem(void __pmem *addr, size_t size)
+{
+	void *vaddr = (void __force *)addr;
+
+	memset(vaddr, 0, size);
+	arch_wb_cache_pmem(addr, size);
+}
+
+/**
+ * arch_invalidate_pmem - invalidate a PMEM memory range
+ * @addr:	virtual start address
+ * @size:	number of bytes to zero
+ *
+ * After finishing ARS(Address Range Scrubbing), clean and invalidate the
+ * address range.
+ */
+static inline void arch_invalidate_pmem(void __pmem *addr, size_t size)
+{
+	__flush_dcache_area(addr, size);
+}
+
+static inline bool __arch_has_wmb_pmem(void)
+{
+	/* return false until arch_wmb_pmem() guarantee PoP on ARMv8.2. */
+	return false;
+}
+#endif /* CONFIG_ARCH_HAS_PMEM_API */
+#endif /* __ASM_PMEM_H__ */
-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
