Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 23/25] arch: remove ioremap_cache,
 replace with arch_memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 Jul 2015 22:40:07 -0400
Message-ID: <20150725024007.8664.58668.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150725023649.8664.59145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
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
 arch/arm/Kconfig             |    1 +
 arch/arm/include/asm/io.h    |   11 ++++++++---
 arch/arm/mm/ioremap.c        |   12 ++++++++----
 arch/arm/mm/nommu.c          |   11 +++++++----
 arch/arm64/Kconfig           |    1 +
 arch/arm64/include/asm/io.h  |    7 ++++++-
 arch/arm64/mm/ioremap.c      |   20 +++++++-------------
 arch/ia64/Kconfig            |    1 +
 arch/ia64/include/asm/io.h   |   12 +++++++++---
 arch/sh/Kconfig              |    1 +
 arch/sh/include/asm/io.h     |   21 ++++++++++++++-------
 arch/sh/mm/ioremap.c         |   10 ++++++++++
 arch/x86/Kconfig             |    1 +
 arch/x86/include/asm/io.h    |    8 +++++++-
 arch/x86/mm/ioremap.c        |   20 +++++++++++++++-----
 arch/xtensa/Kconfig          |    1 +
 arch/xtensa/include/asm/io.h |    9 ++++++---
 drivers/nvdimm/Kconfig       |    2 +-
 kernel/Makefile              |    2 +-
 kernel/memremap.c            |   14 +++-----------
 lib/Kconfig                  |    5 ++++-
 21 files changed, 112 insertions(+), 58 deletions(-)

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
index 485982084fe9..989eeaa8dd84 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -355,7 +355,7 @@ static inline void memcpy_toio(volatile void __iomem *to, const void *from,
  * Function		Memory type	Cacheability	Cache hint
  * ioremap()		Device		n/a		n/a
  * ioremap_nocache()	Device		n/a		n/a
- * ioremap_cache()	Normal		Writeback	Read allocate
+ * memremap(CACHE)	Normal		Writeback	Read allocate
  * ioremap_wc()		Normal		Non-cacheable	n/a
  * ioremap_wt()		Normal		Non-cacheable	n/a
  *
@@ -392,8 +392,8 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size);
 #define ioremap ioremap
 #define ioremap_nocache ioremap
 
-void __iomem *ioremap_cache(resource_size_t res_cookie, size_t size);
-#define ioremap_cache ioremap_cache
+void __iomem *arch_memremap(resource_size_t res_cookie, size_t size,
+		unsigned long flags);
 
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size);
 #define ioremap_wc ioremap_wc
@@ -402,6 +402,11 @@ void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size);
 void iounmap(volatile void __iomem *iomem_cookie);
 #define iounmap iounmap
 
+static inline void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+
 /*
  * io{read,write}{16,32}be() macros
  */
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 0c81056c1dd7..4e64247ba083 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -378,12 +378,16 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size)
 }
 EXPORT_SYMBOL(ioremap);
 
-void __iomem *ioremap_cache(resource_size_t res_cookie, size_t size)
+void *arch_memremap(resource_size_t res_cookie, size_t size,
+		unsigned long flags)
 {
-	return arch_ioremap_caller(res_cookie, size, MT_DEVICE_CACHED,
-				   __builtin_return_address(0));
+	if ((flags & MEMREMAP_CACHE) == 0)
+		return NULL;
+
+	return (void __force *) arch_ioremap_caller(res_cookie, size,
+			MT_DEVICE_CACHED, __builtin_return_address(0));
 }
-EXPORT_SYMBOL(ioremap_cache);
+EXPORT_SYMBOL(arch_memremap);
 
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size)
 {
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index 1dd10936d68d..ec42be4d6e6e 100644
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
+	if ((flags & MEMREMAP_CACHE) == 0)
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
index 44be1e03ed65..305d1c9b3352 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -165,7 +165,7 @@ extern void __memset_io(volatile void __iomem *, int, size_t);
  */
 extern void __iomem *__ioremap(phys_addr_t phys_addr, size_t size, pgprot_t prot);
 extern void __iounmap(volatile void __iomem *addr);
-extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
+extern void *arch_memremap(phys_addr_t phys_addr, size_t size, unsigned long flags);
 
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
@@ -173,6 +173,11 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 #define ioremap_wt(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define iounmap				__iounmap
 
+static inline void memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+
 /*
  * io{read,write}{16,32}be() macros
  */
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 01e88c8bcab0..dc408d8db938 100644
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
+	if ((flags & MEMREMAP_CACHE) == 0)
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
index 9041bbe2b7b4..64e8e2fbf2b0 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -431,12 +431,18 @@ extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size
 #define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 #define early_memunmap(addr, size)             early_iounmap(addr, size)
-static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
+
+/* caching type is determined internal to ioremap */
+static inline void *arch_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
 {
-	return ioremap(phys_addr, size);
+	return (void __force *) ioremap(offset, size);
 }
-#define ioremap_cache ioremap_cache
 
+static inline void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
 
 /*
  * String version of IO memory access ops:
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
index 6194e20fccca..aec5f5f8cde6 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -326,10 +326,19 @@ __ioremap_mode(phys_addr_t offset, unsigned long size, pgprot_t prot)
 
 	return __ioremap(offset, size, prot);
 }
+
+void *arch_memremap(resource_size_t offset, unsigned long size,
+		unsigned long flags);
+
 #else
 #define __ioremap(offset, size, prot)		((void __iomem *)(offset))
 #define __ioremap_mode(offset, size, prot)	((void __iomem *)(offset))
 #define __iounmap(addr)				do { } while (0)
+static inline void *arch_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
+{
+	return (void *) offset;
+}
 #endif /* CONFIG_MMU */
 
 static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
@@ -337,13 +346,6 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
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
@@ -371,6 +373,11 @@ static inline int iounmap_fixed(void __iomem *addr) { return -EINVAL; }
 #define ioremap_nocache	ioremap
 #define iounmap		__iounmap
 
+static inline void arch_memunmap(void *addr)
+{
+	iounmap((void __iomem *) addr);
+}
+
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff --git a/arch/sh/mm/ioremap.c b/arch/sh/mm/ioremap.c
index 0c99ec2e7ed8..40414bca4241 100644
--- a/arch/sh/mm/ioremap.c
+++ b/arch/sh/mm/ioremap.c
@@ -86,6 +86,16 @@ __ioremap_caller(phys_addr_t phys_addr, unsigned long size,
 }
 EXPORT_SYMBOL(__ioremap_caller);
 
+void *arch_memremap(resource_size_t offset, unsigned long size,
+		unsigned long flags)
+{
+	if ((flags & MEMREMAP_CACHE) == 0)
+		return NULL;
+
+	return (void __force *) __ioremap_mode(offset, size, PAGE_KERNEL);
+}
+EXPORT_SYMBOL(arch_memremap);
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
index 8aeb6456188a..d13ac9cbdc30 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -180,9 +180,10 @@ static inline unsigned int isa_virt_to_bus(volatile void *address)
  */
 extern void __iomem *ioremap_nocache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_uc(resource_size_t offset, unsigned long size);
-extern void __iomem *ioremap_cache(resource_size_t offset, unsigned long size);
 extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
 				unsigned long prot_val);
+extern void *arch_memremap(resource_size_t offset, size_t size,
+		unsigned long flags);
 
 /*
  * The default ioremap() behavior is non-cached:
@@ -194,6 +195,11 @@ static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 
 extern void iounmap(volatile void __iomem *addr);
 
+static inline void arch_memunmap(void *addr)
+{
+	iounmap((volatile void __iomem *) addr);
+}
+
 extern void set_iounmap_nonlazy(void);
 
 #ifdef __KERNEL__
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 7b422e7574b1..8d5c88bcd09b 100644
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
+	if (flags & MEMREMAP_CACHE)
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
+	return (void __pmem *) arch_memremap(offset, size, MEMREMAP_CACHE);
 }
 EXPORT_SYMBOL(arch_memremap_pmem);
 
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index e5b872ba2484..da1078692c41 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -3,6 +3,7 @@ config ZONE_DMA
 
 config XTENSA
 	def_bool y
+	select ARCH_HAS_MEMREMAP
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_OPTIONAL_GPIOLIB
diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index 867840f5400f..da6c8290e432 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -48,8 +48,8 @@ static inline void __iomem *ioremap_nocache(unsigned long offset,
 		BUG();
 }
 
-static inline void __iomem *ioremap_cache(unsigned long offset,
-		unsigned long size)
+static inline void *arch_memremap(resource_size_t offset, size_t size,
+		unsigned long flags)
 {
 	if (offset >= XCHAL_KIO_PADDR
 	    && offset - XCHAL_KIO_PADDR < XCHAL_KIO_SIZE)
@@ -57,7 +57,6 @@ static inline void __iomem *ioremap_cache(unsigned long offset,
 	else
 		BUG();
 }
-#define ioremap_cache ioremap_cache
 
 #define ioremap_wc ioremap_nocache
 #define ioremap_wt ioremap_nocache
@@ -71,6 +70,10 @@ static inline void iounmap(volatile void __iomem *addr)
 {
 }
 
+static inline void memunmap(void *addr)
+{
+}
+
 #define virt_to_bus     virt_to_phys
 #define bus_to_virt     phys_to_virt
 
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
index ba206fd11785..c99aa4f12e2b 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -14,14 +14,6 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 
-#ifndef ioremap_cache
-/* temporary while we convert existing ioremap_cache users to memremap */
-__weak void __iomem *ioremap_cache(resource_size_t offset, unsigned long size)
-{
-	return ioremap(offset, size);
-}
-#endif
-
 /*
  * memremap() is "ioremap" for cases where it is known that the resource
  * being mapped does not have i/o side effects and the __iomem
@@ -50,7 +42,7 @@ void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 		if (is_ram)
 			addr = __va(offset);
 		else
-			addr = ioremap_cache(offset, size);
+			addr = arch_memremap(offset, size, MEMREMAP_CACHE);
 	}
 
 	/*
@@ -67,7 +59,7 @@ void *memremap(resource_size_t offset, size_t size, unsigned long flags)
 
 	if (!addr && (flags & MEMREMAP_WT)) {
 		flags &= ~MEMREMAP_WT;
-		addr = ioremap_wt(offset, size);
+		addr = arch_memremap(offset, size, MEMREMAP_WT);
 	}
 
 	return addr;
@@ -77,6 +69,6 @@ EXPORT_SYMBOL(memremap);
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

