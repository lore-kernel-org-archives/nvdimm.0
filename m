Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 22/24] arch: remove ioremap_cache,
 replace with arch_memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:55:42 -0400
Message-ID: <20150730165542.33962.41850.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Now that all call sites for ioremap_cache() have been converted to
memremap(MEMREMAP_CACHE) we can now proceed with removing the
implementation in the archs.  This amounts to replacing the per-arch
ioremap_cache() implementation with arch_memremap.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/x86/pat.txt    |    4 ++--
 arch/arm/Kconfig             |    1 +
 arch/arm/include/asm/io.h    |    5 +----
 arch/arm/mm/ioremap.c        |   18 ++++++++++++++----
 arch/arm/mm/nommu.c          |   11 +++++++----
 arch/arm64/Kconfig           |    1 +
 arch/arm64/include/asm/io.h  |    1 -
 arch/arm64/mm/ioremap.c      |   20 +++++++-------------
 arch/ia64/Kconfig            |    1 +
 arch/ia64/include/asm/io.h   |    6 ------
 arch/ia64/mm/ioremap.c       |   16 ++++++++++++++++
 arch/sh/Kconfig              |    1 +
 arch/sh/include/asm/io.h     |    7 -------
 arch/sh/mm/ioremap.c         |   15 +++++++++++++++
 arch/x86/Kconfig             |    1 +
 arch/x86/include/asm/io.h    |    2 --
 arch/x86/mm/ioremap.c        |   26 +++++++++++++++++++++-----
 arch/xtensa/include/asm/io.h |   11 -----------
 drivers/nvdimm/Kconfig       |    2 +-
 include/linux/io.h           |    2 ++
 kernel/Makefile              |    2 +-
 kernel/memremap.c            |   28 ++++++++++++++++++++--------
 lib/Kconfig                  |    5 ++++-
 23 files changed, 116 insertions(+), 70 deletions(-)

diff --git a/Documentation/x86/pat.txt b/Documentation/x86/pat.txt
index 54944c71b819..73d3635f6a3f 100644
--- a/Documentation/x86/pat.txt
+++ b/Documentation/x86/pat.txt
@@ -32,14 +32,14 @@ API                    |    RAM   |  ACPI,...  |  Reserved/Holes  |
                        |          |            |                  |
 ioremap                |    --    |    UC-     |       UC-        |
                        |          |            |                  |
-ioremap_cache          |    --    |    WB      |       WB         |
-                       |          |            |                  |
 ioremap_uc             |    --    |    UC      |       UC         |
                        |          |            |                  |
 ioremap_nocache        |    --    |    UC-     |       UC-        |
                        |          |            |                  |
 ioremap_wc             |    --    |    --      |       WC         |
                        |          |            |                  |
+memremap(MEMREMAP_WB)  |    WB    |    WB      |       WB         |
+                       |          |            |                  |
 ioremap_wt             |    --    |    --      |       WT         |
                        |          |            |                  |
 set_memory_uc          |    UC-   |    --      |       --         |
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 1c5021002fe4..1d64aae0a226 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -3,6 +3,7 @@ config ARM
 	default y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
+	select ARCH_HAS_MEMREMAP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 485982084fe9..191d0f6eeead 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -355,7 +355,7 @@ static inline void memcpy_toio(volatile void __iomem *to, const void *from,
  * Function		Memory type	Cacheability	Cache hint
  * ioremap()		Device		n/a		n/a
  * ioremap_nocache()	Device		n/a		n/a
- * ioremap_cache()	Normal		Writeback	Read allocate
+ * memremap(WB)		Normal		Writeback	Read allocate
  * ioremap_wc()		Normal		Non-cacheable	n/a
  * ioremap_wt()		Normal		Non-cacheable	n/a
  *
@@ -392,9 +392,6 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size);
 #define ioremap ioremap
 #define ioremap_nocache ioremap
 
-void __iomem *ioremap_cache(resource_size_t res_cookie, size_t size);
-#define ioremap_cache ioremap_cache
-
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size);
 #define ioremap_wc ioremap_wc
 #define ioremap_wt ioremap_wc
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 0c81056c1dd7..8b0c7ce3c520 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -378,12 +378,22 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size)
 }
 EXPORT_SYMBOL(ioremap);
 
-void __iomem *ioremap_cache(resource_size_t res_cookie, size_t size)
+void *arch_memremap(resource_size_t res_cookie, size_t size,
+		unsigned long flags)
 {
-	return arch_ioremap_caller(res_cookie, size, MT_DEVICE_CACHED,
-				   __builtin_return_address(0));
+	if ((flags & MEMREMAP_WB) == 0)
+		return NULL;
+
+	return (void __force *) arch_ioremap_caller(res_cookie, size,
+			MT_DEVICE_CACHED, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(arch_memremap);
+
+void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
 }
-EXPORT_SYMBOL(ioremap_cache);
+EXPORT_SYMBOL(arch_memunmap);
 
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size)
 {
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index 1dd10936d68d..84d033501553 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -366,12 +366,15 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size)
 }
 EXPORT_SYMBOL(ioremap);
 
-void __iomem *ioremap_cache(resource_size_t res_cookie, size_t size)
+void *arch_memremap(resource_size_t res_cookie, size_t size, unsigned long flags)
 {
-	return __arm_ioremap_caller(res_cookie, size, MT_DEVICE_CACHED,
-				    __builtin_return_address(0));
+	if ((flags & MEMREMAP_WB) == 0)
+		return NULL;
+
+	return (void __force *) __arm_ioremap_caller(res_cookie, size,
+			MT_DEVICE_CACHED, __builtin_return_address(0));
 }
-EXPORT_SYMBOL(ioremap_cache);
+EXPORT_SYMBOL(arch_memremap);
 
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size)
 {
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 318175f62c24..305def28385f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -6,6 +6,7 @@ config ARM64
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_MEMREMAP
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_USE_CMPXCHG_LOCKREF
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 44be1e03ed65..51376353a722 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -165,7 +165,6 @@ extern void __memset_io(volatile void __iomem *, int, size_t);
  */
 extern void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot);
 extern void __iounmap(volatile void __iomem *addr);
-extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 01e88c8bcab0..83b9db4672d1 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -84,25 +84,19 @@ void __iounmap(volatile void __iomem *io_addr)
 {
 	unsigned long addr = (unsigned long)io_addr & PAGE_MASK;
 
-	/*
-	 * We could get an address outside vmalloc range in case
-	 * of ioremap_cache() reusing a RAM mapping.
-	 */
-	if (VMALLOC_START <= addr && addr < VMALLOC_END)
-		vunmap((void *)addr);
+	vunmap((void *)addr);
 }
 EXPORT_SYMBOL(__iounmap);
 
-void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
+void *arch_memremap(phys_addr_t phys_addr, size_t size, unsigned long flags)
 {
-	/* For normal memory we already have a cacheable mapping. */
-	if (pfn_valid(__phys_to_pfn(phys_addr)))
-		return (void __iomem *)__phys_to_virt(phys_addr);
+	if ((flags & MEMREMAP_WB) == 0)
+		return NULL;
 
-	return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
-				__builtin_return_address(0));
+	return (void __force *) __ioremap_caller(phys_addr, size,
+			__pgprot(PROT_NORMAL), __builtin_return_address(0));
 }
-EXPORT_SYMBOL(ioremap_cache);
+EXPORT_SYMBOL(arch_memremap);
 
 /*
  * Must be called after early_fixmap_init
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 42a91a7aa2b0..aa83a5da1c99 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -52,6 +52,7 @@ config IA64
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
+	select ARCH_HAS_MEMREMAP
 	select HAVE_ARCH_AUDITSYSCALL
 	default y
 	help
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 9041bbe2b7b4..defcd10bbf54 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -431,12 +431,6 @@ extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size
 #define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 #define early_memunmap(addr, size)             early_iounmap(addr, size)
-static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
-{
-	return ioremap(phys_addr, size);
-}
-#define ioremap_cache ioremap_cache
-
 
 /*
  * String version of IO memory access ops:
diff --git a/arch/ia64/mm/ioremap.c b/arch/ia64/mm/ioremap.c
index 43964cde6214..3236d28ac2d5 100644
--- a/arch/ia64/mm/ioremap.c
+++ b/arch/ia64/mm/ioremap.c
@@ -101,6 +101,22 @@ ioremap (unsigned long phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap);
 
+/*
+ * Cache mapping-type is determined internal to ioremap and can't be
+ * externally specified
+ */
+void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	return (void __force *) ioremap(offset, size);
+}
+EXPORT_SYMBOL(arch_memremap);
+
+void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+EXPORT_SYMBOL(arch_memunmap);
+
 void __iomem *
 ioremap_nocache (unsigned long phys_addr, unsigned long size)
 {
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 50057fed819d..78d2bd6531cc 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -54,6 +54,7 @@ config SUPERH32
 	def_bool ARCH = "sh"
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select ARCH_HAS_MEMREMAP
 	select HAVE_IOREMAP_PROT if MMU && !X2TLB
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 6194e20fccca..7511796ce543 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -337,13 +337,6 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
 	return __ioremap_mode(offset, size, PAGE_KERNEL_NOCACHE);
 }
 
-static inline void __iomem *
-ioremap_cache(phys_addr_t offset, unsigned long size)
-{
-	return __ioremap_mode(offset, size, PAGE_KERNEL);
-}
-#define ioremap_cache ioremap_cache
-
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 static inline void __iomem *
 ioremap_prot(phys_addr_t offset, unsigned long size, unsigned long flags)
diff --git a/arch/sh/mm/ioremap.c b/arch/sh/mm/ioremap.c
index 0c99ec2e7ed8..e59605a9ed67 100644
--- a/arch/sh/mm/ioremap.c
+++ b/arch/sh/mm/ioremap.c
@@ -86,6 +86,21 @@ __ioremap_caller(phys_addr_t phys_addr, unsigned long size,
 }
 EXPORT_SYMBOL(__ioremap_caller);
 
+void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	if ((flags & MEMREMAP_WB) == 0)
+		return NULL;
+
+	return (void __force *) __ioremap_mode(offset, size, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(arch_memremap);
+
+void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+EXPORT_SYMBOL(arch_memunmap);
+
 /*
  * Simple checks for non-translatable mappings.
  */
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b3a1a5d77d92..9c2fb6b896aa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -27,6 +27,7 @@ config X86
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_GCOV_PROFILE_ALL
+	select ARCH_HAS_MEMREMAP
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 8aeb6456188a..349027c2943d 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -180,10 +180,8 @@ static inline unsigned int isa_virt_to_bus(volatile void *address)
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_uc(resource_size_t offset, unsigned long size);
-extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
 				unsigned long prot_val);
-
 /*
  * The default ioremap() behavior is non-cached:
  */
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index dcaadc6a125b..4516974f3bad 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -310,16 +310,26 @@ void __iomem *ioremap_wt(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_wt);
 
-void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
+void *arch_memremap(resource_size_t phys_addr, size_t size,
+		unsigned long flags)
 {
-	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WB,
-				__builtin_return_address(0));
+	int prot;
+
+	if (flags & MEMREMAP_WB)
+		prot = _PAGE_CACHE_MODE_WB;
+	else if (flags & MEMREMAP_WT)
+		prot = _PAGE_CACHE_MODE_WT;
+	else
+		return NULL;
+
+	return (void __force *) __ioremap_caller(phys_addr, size, prot,
+			__builtin_return_address(0));
 }
-EXPORT_SYMBOL(ioremap_cache);
+EXPORT_SYMBOL(arch_memremap);
 
 void __pmem *arch_memremap_pmem(resource_size_t offset, size_t size)
 {
-	return (void __force __pmem *) ioremap_cache(offset, size);
+	return (void __pmem *) arch_memremap(offset, size, MEMREMAP_WB);
 }
 EXPORT_SYMBOL(arch_memremap_pmem);
 
@@ -381,6 +391,12 @@ void iounmap(volatile void __iomem *addr)
 }
 EXPORT_SYMBOL(iounmap);
 
+void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+EXPORT_SYMBOL(arch_memunmap);
+
 int __init arch_ioremap_pud_supported(void)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index 867840f5400f..9bfbecc0fc99 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -48,17 +48,6 @@ static inline void __iomem *ioremap_nocache(unsigned long offset,
 		BUG();
 }
 
-static inline void __iomem *ioremap_cache(unsigned long offset,
-		unsigned long size)
-{
-	if (offset >= XCHAL_KIO_PADDR
-	    && offset - XCHAL_KIO_PADDR < XCHAL_KIO_SIZE)
-		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_CACHED_VADDR);
-	else
-		BUG();
-}
-#define ioremap_cache ioremap_cache
-
 #define ioremap_wc ioremap_nocache
 #define ioremap_wt ioremap_nocache
 
diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 72226acb5c0f..1c249926b6d0 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -1,5 +1,6 @@
 menuconfig LIBNVDIMM
 	tristate "NVDIMM (Non-Volatile Memory Device) Support"
+	depends on ARCH_HAS_MEMREMAP
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
 	help
@@ -19,7 +20,6 @@ if LIBNVDIMM
 config BLK_DEV_PMEM
 	tristate "PMEM: Persistent memory block device support"
 	default LIBNVDIMM
-	depends on HAS_IOMEM
 	select ND_BTT if BTT
 	help
 	  Memory ranges for PMEM are described by either an NFIT
diff --git a/include/linux/io.h b/include/linux/io.h
index 3fcf6256c088..e2546f1f7fef 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -129,5 +129,7 @@ enum {
 
 void *memremap(resource_size_t offset, size_t size, unsigned long flags);
 void memunmap(void *addr);
+void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags);
+void arch_memunmap(void *addr);
 
 #endif /* _LINUX_IO_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 92866d36e376..6d12e8006150 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -99,7 +99,7 @@ obj-$(CONFIG_JUMP_LABEL) += jump_label.o
 obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
 obj-$(CONFIG_TORTURE_TEST) += torture.o
 
-obj-$(CONFIG_HAS_IOMEM) += memremap.o
+obj-$(CONFIG_ARCH_HAS_MEMREMAP) += memremap.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/memremap.c b/kernel/memremap.c
index 27637f42f30d..d3cee1460354 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -14,13 +14,22 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 
-#ifndef ioremap_cache
-/* temporary while we convert existing ioremap_cache users to memremap */
-__weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
+__weak void *arch_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
 {
-	return ioremap(offset, size);
+	if (!IS_ENABLED(CONFIG_MMU))
+		return (void *) (unsigned long) offset;
+	WARN_ONCE(1, "%s in %s should only be called in NOMMU configurations\n",
+			__func__, __FILE__);
+	return NULL;
+}
+
+__weak void arch_memunmap(void *addr)
+{
+	WARN_ONCE(IS_ENABLED(CONFIG_MMU),
+		"%s in %s should only be called in NOMMU configurations\n",
+		__func__, __FILE__);
 }
-#endif
 
 /**
  * memremap() - remap an iomem_resource as cacheable memory
@@ -42,6 +51,9 @@ __weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
  * cache or are written through to memory and never exist in a
  * cache-dirty state with respect to program visibility.  Attempts to
  * map "System RAM" with this mapping type will fail.
+ *
+ * Note, that overlapping mappings can be established provided they are
+ * all of the same mapping type.
  */
 void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 {
@@ -66,7 +78,7 @@ void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 		if (is_ram == REGION_INTERSECTS)
 			addr = __va(offset);
 		else
-			addr = ioremap_cache(offset, size);
+			addr = arch_memremap(offset, size, MEMREMAP_WB);
 	}
 
 	/*
@@ -83,7 +95,7 @@ void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 
 	if (!addr && (flags & MEMREMAP_WT)) {
 		flags &= ~MEMREMAP_WT;
-		addr = ioremap_wt(offset, size);
+		addr = arch_memremap(offset, size, MEMREMAP_WT);
 	}
 
 	return addr;
@@ -93,6 +105,6 @@ EXPORT_SYMBOL(memremap);
 void memunmap(void *addr)
 {
 	if (is_vmalloc_addr(addr))
-		iounmap((void __iomem *) addr);
+		arch_memunmap(addr);
 }
 EXPORT_SYMBOL(memunmap);
diff --git a/lib/Kconfig b/lib/Kconfig
index 3a2ef67db6c7..097b99073924 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -526,7 +526,10 @@ source "lib/fonts/Kconfig"
 #
 
 config ARCH_HAS_SG_CHAIN
-	def_bool n
+	bool
+
+config ARCH_HAS_MEMREMAP
+	bool
 
 config ARCH_HAS_PMEM_API
 	bool

