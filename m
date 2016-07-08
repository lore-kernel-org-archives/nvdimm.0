Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from invmail3.skhynix.com (exvmail3.skhynix.com [166.125.252.90])
 by ml01.01.org (Postfix) with ESMTP id 9D33C1A1DF2
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jul 2016 00:53:11 -0700 (PDT)
From: Kwangwoo Lee <kwangwoo.lee@sk.com>
Subject: [PATCH v2] pmem: add pmem support codes on ARM64
Date: Fri,  8 Jul 2016 16:51:38 +0900
Message-Id: <1467964298-29241-1-git-send-email-kwangwoo.lee@sk.com>
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
To: linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org, Mark Rutland <mark.rutland@arm.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Kwangwoo Lee <kwangwoo.lee@sk.com>, linux-kernel@vger.kernel.org, Woosuk Chung <woosuk.chung@sk.com>
List-ID: <linux-nvdimm@lists.01.org>

v2)
rewrite functions under the mapping information MEMREMAP_WB.
rewrite the comments for ARM64 in pmem.h
add __clean_dcache_area() to clean data in PoC.

v1)
The PMEM driver on top of NVDIMM(Non-Volatile DIMM) has already been
supported on X86_64 and there exist several ARM64 platforms which support
DIMM type memories.

This patch set enables the PMEM driver on ARM64 (AArch64) architecture
on top of NVDIMM. While developing this patch set, QEMU 2.6.50 with NVDIMM
emulation for ARM64 has also been developed and tested on it.

$ dmesg
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.6.0-rc2kw-dirty (kwangwoo@VBox15) (gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu1) ) #10 SMP Tue Jul 5 11:30:33 KST 2016
[    0.000000] Boot CPU: AArch64 Processor [411fd070]
[    0.000000] efi: Getting EFI parameters from FDT:
[    0.000000] EFI v2.60 by EDK II
[    0.000000] efi:  SMBIOS 3.0=0x58710000  ACPI 2.0=0x589b0000
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000589B0000 000024 (v02 BOCHS )
[    0.000000] ACPI: XSDT 0x00000000589A0000 00005C (v01 BOCHS  BXPCFACP 00000001      01000013)
[    0.000000] ACPI: FACP 0x0000000058620000 00010C (v05 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000058630000 00108F (v02 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000058610000 0000A8 (v03 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: GTDT 0x0000000058600000 000060 (v02 BOCHS  BXPCGTDT 00000001 BXPC 00000001)
[    0.000000] ACPI: MCFG 0x00000000585F0000 00003C (v01 BOCHS  BXPCMCFG 00000001 BXPC 00000001)
[    0.000000] ACPI: SPCR 0x00000000585E0000 000050 (v02 BOCHS  BXPCSPCR 00000001 BXPC 00000001)
[    0.000000] ACPI: NFIT 0x00000000585D0000 0000E0 (v01 BOCHS  BXPCNFIT 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0x00000000585C0000 000131 (v01 BOCHS  NVDIMM 00000001 BXPC 00000001)
...
[    5.386743] pmem0: detected capacity change from 0 to 1073741824
...
[  531.952466] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[  531.961073] EXT4-fs (pmem0): mounted filesystem with ordered data mode. Opts: dax

$ mount
rootfs on / type rootfs (rw,size=206300k,nr_inodes=51575)
...
/dev/pmem0 on /mnt/mem type ext4 (rw,relatime,dax,data=ordered)

$ df -h
Filesystem                Size      Used Available Use% Mounted on
...
/dev/pmem0              975.9M      1.3M    907.4M   0% /mnt/mem

Signed-off-by: Kwangwoo Lee <kwangwoo.lee@sk.com>
---
 arch/arm64/Kconfig                  |   2 +
 arch/arm64/include/asm/cacheflush.h |   3 +
 arch/arm64/include/asm/pmem.h       | 151 ++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/cache.S               |  18 +++++
 4 files changed, 174 insertions(+)
 create mode 100644 arch/arm64/include/asm/pmem.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 4f43622..ee1d679 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -15,6 +15,8 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_HAS_PMEM_API
+	select ARCH_HAS_MMIO_FLUSH
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index c64268d..fba18e4 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -68,6 +68,7 @@
 extern void flush_cache_range(struct vm_area_struct *vma, unsigned long start, unsigned long end);
 extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void __flush_dcache_area(void *addr, size_t len);
+extern void __clean_dcache_area(void *addr, size_t len);
 extern void __clean_dcache_area_pou(void *addr, size_t len);
 extern long __flush_cache_user_range(unsigned long start, unsigned long end);
 
@@ -133,6 +134,8 @@ static inline void __flush_icache_all(void)
  */
 #define flush_icache_page(vma,page)	do { } while (0)
 
+#define mmio_flush_range(addr, size)	__flush_dcache_area(addr, size)
+
 /*
  * Not required on AArch64 (PIPT or VIPT non-aliasing D-cache).
  */
diff --git a/arch/arm64/include/asm/pmem.h b/arch/arm64/include/asm/pmem.h
new file mode 100644
index 0000000..7504b2b
--- /dev/null
+++ b/arch/arm64/include/asm/pmem.h
@@ -0,0 +1,151 @@
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
+	int unwritten;
+
+	unwritten = __copy_from_user_inatomic((void __force *) dst,
+			(void __user *) src, n);
+	if (WARN(unwritten, "%s: fault copying %p <- %p unwritten: %d\n",
+				__func__, dst, src, unwritten))
+		BUG();
+
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
+	/*
+	 * We've already arranged for pmem writes to avoid the cache in
+	 * arch_memcpy_to_pmem()
+	 */
+	wmb();
+
+	/*
+	 * pcommit_sfence() on X86 has been removed and will be replaced with
+	 * a function after ARMv8.2 which will support DC CVAP to ensure
+	 * Point-of-Persistency. Until then, mark here with a comment to keep
+	 * the point for __clean_dcache_area_pop().
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
+	/* cache clean PoC */
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
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 6df0706..5a350e4 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -93,6 +93,24 @@ ENTRY(__flush_dcache_area)
 ENDPIPROC(__flush_dcache_area)
 
 /*
+ *	__clean_dcache_area(kaddr, size)
+ *
+ * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
+ * 	are cleaned to the PoC.
+ *
+ *	- kaddr   - kernel address
+ *	- size    - size in question
+ */
+ENTRY(__clean_dcache_area)
+alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
+	dcache_by_line_op cvac, sy, x0, x1, x2, x3
+alternative_else
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+alternative_endif
+	ret
+ENDPROC(__clean_dcache_area)
+
+/*
  *	__clean_dcache_area_pou(kaddr, size)
  *
  * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
-- 
2.5.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
