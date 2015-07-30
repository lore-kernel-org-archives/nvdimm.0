Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 23/24] arch: remove ioremap_wt,
 optionally replace with arch_memremap
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:55:47 -0400
Message-ID: <20150730165547.33962.57434.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>, toshi.kani@hp.com, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Now that all call sites for ioremap_wt() have been converted to
memremap(MEMREMAP_WT) we can now proceed with removing the
implementation in the archs.  This amounts to replacing the per-arch
ioremap_wt() implementation with arch_memremap in the case where
ioremap_wt() was actually providing "writethrough" semantics.
Otherwise, ioremap_wt() support that falls back to ioremap() is simply
removed.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/x86/pat.txt        |    2 +-
 arch/arc/include/asm/io.h        |    1 -
 arch/arm/include/asm/io.h        |    2 --
 arch/arm64/include/asm/io.h      |    1 -
 arch/avr32/include/asm/io.h      |    1 -
 arch/frv/include/asm/io.h        |    7 -------
 arch/m32r/include/asm/io.h       |    1 -
 arch/m68k/Kconfig                |    1 +
 arch/m68k/include/asm/io_mm.h    |    8 +-------
 arch/m68k/include/asm/io_no.h    |    6 ------
 arch/m68k/include/asm/raw_io.h   |    1 -
 arch/m68k/mm/kmap.c              |   17 ++++++++++++++++-
 arch/m68k/mm/sun3kmap.c          |    6 ++++++
 arch/metag/include/asm/io.h      |    3 ---
 arch/microblaze/include/asm/io.h |    1 -
 arch/mn10300/include/asm/io.h    |    1 -
 arch/nios2/include/asm/io.h      |    1 -
 arch/s390/include/asm/io.h       |    1 -
 arch/sparc/include/asm/io_32.h   |    1 -
 arch/sparc/include/asm/io_64.h   |    1 -
 arch/tile/include/asm/io.h       |    1 -
 arch/x86/include/asm/io.h        |    2 --
 arch/x86/mm/ioremap.c            |   17 -----------------
 arch/xtensa/include/asm/io.h     |    1 -
 drivers/video/fbdev/Kconfig      |    2 +-
 include/asm-generic/io.h         |    8 --------
 include/asm-generic/iomap.h      |    4 ----
 27 files changed, 26 insertions(+), 72 deletions(-)

diff --git a/Documentation/x86/pat.txt b/Documentation/x86/pat.txt
index 73d3635f6a3f..7e0e43c648f7 100644
--- a/Documentation/x86/pat.txt
+++ b/Documentation/x86/pat.txt
@@ -40,7 +40,7 @@ ioremap_wc             |    --    |    --      |       WC         |
                        |          |            |                  |
 memremap(MEMREMAP_WB)  |    WB    |    WB      |       WB         |
                        |          |            |                  |
-ioremap_wt             |    --    |    --      |       WT         |
+memremap(MEMREMAP_WT)  |    --    |    --      |       WT         |
                        |          |            |                  |
 set_memory_uc          |    UC-   |    --      |       --         |
  set_memory_wb         |          |            |                  |
diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 694ece8a0243..00f97a2f5fa6 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -20,7 +20,6 @@ extern void iounmap(const void __iomem *addr);
 
 #define ioremap_nocache(phy, sz)	ioremap(phy, sz)
 #define ioremap_wc(phy, sz)		ioremap(phy, sz)
-#define ioremap_wt(phy, sz)		ioremap(phy, sz)
 
 /* Change struct page to physical address */
 #define page_to_phys(page)		(page_to_pfn(page) << PAGE_SHIFT)
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 191d0f6eeead..5616c4f4304d 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -357,7 +357,6 @@ static inline void memcpy_toio(volatile void __iomem *to, const void *from,
  * ioremap_nocache()	Device		n/a		n/a
  * memremap(WB)		Normal		Writeback	Read allocate
  * ioremap_wc()		Normal		Non-cacheable	n/a
- * ioremap_wt()		Normal		Non-cacheable	n/a
  *
  * All device mappings have the following properties:
  * - no access speculation
@@ -394,7 +393,6 @@ void __iomem *ioremap(resource_size_t res_cookie, size_t size);
 
 void __iomem *ioremap_wc(resource_size_t res_cookie, size_t size);
 #define ioremap_wc ioremap_wc
-#define ioremap_wt ioremap_wc
 
 void iounmap(volatile void __iomem *iomem_cookie);
 #define iounmap iounmap
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 51376353a722..054fb4def2c9 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -169,7 +169,6 @@ extern void __iounmap(volatile void __iomem *addr);
 #define ioremap(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_nocache(addr, size)	__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define ioremap_wc(addr, size)		__ioremap((addr), (size), __pgprot(PROT_NORMAL_NC))
-#define ioremap_wt(addr, size)		__ioremap((addr), (size), __pgprot(PROT_DEVICE_nGnRE))
 #define iounmap				__iounmap
 
 /*
diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
index e998ff5d8e1a..4f5ec2bb7172 100644
--- a/arch/avr32/include/asm/io.h
+++ b/arch/avr32/include/asm/io.h
@@ -296,7 +296,6 @@ extern void __iounmap(void __iomem *addr);
 	__iounmap(addr)
 
 #define ioremap_wc ioremap_nocache
-#define ioremap_wt ioremap_nocache
 
 #define cached(addr) P1SEGADDR(addr)
 #define uncached(addr) P2SEGADDR(addr)
diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
index 15a49a268754..2177a164cc67 100644
--- a/arch/frv/include/asm/io.h
+++ b/arch/frv/include/asm/io.h
@@ -17,8 +17,6 @@
 
 #ifdef __KERNEL__
 
-#define ARCH_HAS_IOREMAP_WT
-
 #include <linux/types.h>
 #include <asm/virtconvert.h>
 #include <asm/string.h>
@@ -267,11 +265,6 @@ static inline void __iomem *ioremap_nocache(unsigned long physaddr, unsigned lon
 	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
 }
 
-static inline void __iomem *ioremap_wt(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
-}
-
 #define ioremap_wc ioremap_nocache
 
 extern void iounmap(void volatile __iomem *addr);
diff --git a/arch/m32r/include/asm/io.h b/arch/m32r/include/asm/io.h
index f8de767ce2bc..d7a034d8c671 100644
--- a/arch/m32r/include/asm/io.h
+++ b/arch/m32r/include/asm/io.h
@@ -68,7 +68,6 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 extern void iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(off,size) ioremap(off,size)
 #define ioremap_wc ioremap_nocache
-#define ioremap_wt ioremap_nocache
 
 /*
  * IO bus memory addresses are also 1:1 with the physical address
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 2dd8f63bfbbb..693d06dc0a40 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -9,6 +9,7 @@ config M68K
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
 	select VIRT_TO_BUS
+	select ARCH_HAS_MEMREMAP
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IOMAP
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index 910e90770eb2..fce53a1be7e3 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -20,8 +20,6 @@
 
 #ifdef __KERNEL__
 
-#define ARCH_HAS_IOREMAP_WT
-
 #include <linux/compiler.h>
 #include <asm/raw_io.h>
 #include <asm/virtconvert.h>
@@ -468,11 +466,7 @@ static inline void __iomem *ioremap_nocache(unsigned long physaddr, unsigned lon
 {
 	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
 }
-static inline void __iomem *ioremap_wt(unsigned long physaddr,
-					 unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
-}
+
 static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
 	__builtin_memset((void __force *) addr, val, count);
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 2690fa99dc56..b5890e593961 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -3,8 +3,6 @@
 
 #ifdef __KERNEL__
 
-#define ARCH_HAS_IOREMAP_WT
-
 #include <asm/virtconvert.h>
 #include <asm-generic/iomap.h>
 
@@ -155,10 +153,6 @@ static inline void *ioremap_nocache(unsigned long physaddr, unsigned long size)
 {
 	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
 }
-static inline void *ioremap_wt(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
-}
 #define	iounmap(addr)	do { } while(0)
 
 /*
diff --git a/arch/m68k/include/asm/raw_io.h b/arch/m68k/include/asm/raw_io.h
index 932faa35655b..9f6e5a4e531b 100644
--- a/arch/m68k/include/asm/raw_io.h
+++ b/arch/m68k/include/asm/raw_io.h
@@ -25,7 +25,6 @@ extern void __iomem *__ioremap(unsigned long physaddr, unsigned long size,
 		       int cacheflag);
 extern void __iounmap(void *addr, unsigned long size);
 
-
 /* ++roman: The assignments to temp. vars avoid that gcc sometimes generates
  * two accesses to memory, which may be undesirable for some devices.
  */
diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 6e4955bc542b..519c45865127 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -14,12 +14,12 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/io.h>
 
 #include <asm/setup.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/io.h>
 
 #undef DEBUG
 
@@ -223,6 +223,21 @@ void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cachefla
 }
 EXPORT_SYMBOL(__ioremap);
 
+void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	int mode;
+
+	if (flags & MEMREMAP_WB)
+		mode = IOMAP_FULL_CACHING;
+	else if (flags & MEMREMAP_WT)
+		mode = IOMAP_WRITETHROUGH;
+	else
+		return NULL;
+
+	return (void __force *) __ioremap(offset, size, mode);
+}
+EXPORT_SYMBOL(arch_memremap);
+
 /*
  * Unmap an ioremap()ed region again
  */
diff --git a/arch/m68k/mm/sun3kmap.c b/arch/m68k/mm/sun3kmap.c
index 3dc41158c05e..46af60b7f0c7 100644
--- a/arch/m68k/mm/sun3kmap.c
+++ b/arch/m68k/mm/sun3kmap.c
@@ -116,6 +116,12 @@ void __iomem *__ioremap(unsigned long phys, unsigned long size, int cache)
 }
 EXPORT_SYMBOL(__ioremap);
 
+void *arch_memremap(resource_size_t offset, size_t size, unsigned long flags)
+{
+	return (void __force *) sun3_ioremap(offset, size, SUN3_PAGE_TYPE_IO);
+}
+EXPORT_SYMBOL(arch_memremap);
+
 void iounmap(void __iomem *addr)
 {
 	vfree((void *)(PAGE_MASK & (unsigned long)addr));
diff --git a/arch/metag/include/asm/io.h b/arch/metag/include/asm/io.h
index 5432949e627e..482ef3b5f5ba 100644
--- a/arch/metag/include/asm/io.h
+++ b/arch/metag/include/asm/io.h
@@ -157,9 +157,6 @@ extern void __iounmap(void __iomem *addr);
 #define ioremap_wc(offset, size)                \
 	__ioremap((offset), (size), _PAGE_WR_COMBINE)
 
-#define ioremap_wt(offset, size)                \
-	__ioremap((offset), (size), 0)
-
 #define iounmap(addr)                           \
 	__iounmap(addr)
 
diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index 5e0cbf4e4204..df7ffb3d9898 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -41,7 +41,6 @@ extern void iounmap(void __iomem *addr);
 extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 #define ioremap_nocache(addr, size)		ioremap((addr), (size))
 #define ioremap_wc(addr, size)			ioremap((addr), (size))
-#define ioremap_wt(addr, size)			ioremap((addr), (size))
 
 #endif /* CONFIG_MMU */
 
diff --git a/arch/mn10300/include/asm/io.h b/arch/mn10300/include/asm/io.h
index 07c5b4a3903b..cc4a2ba9e228 100644
--- a/arch/mn10300/include/asm/io.h
+++ b/arch/mn10300/include/asm/io.h
@@ -282,7 +282,6 @@ static inline void __iomem *ioremap_nocache(unsigned long offset, unsigned long
 }
 
 #define ioremap_wc ioremap_nocache
-#define ioremap_wt ioremap_nocache
 
 static inline void iounmap(void __iomem *addr)
 {
diff --git a/arch/nios2/include/asm/io.h b/arch/nios2/include/asm/io.h
index c5a62da22cd2..6e24d7cceb0c 100644
--- a/arch/nios2/include/asm/io.h
+++ b/arch/nios2/include/asm/io.h
@@ -46,7 +46,6 @@ static inline void iounmap(void __iomem *addr)
 }
 
 #define ioremap_wc ioremap_nocache
-#define ioremap_wt ioremap_nocache
 
 /* Pages to physical address... */
 #define page_to_phys(page)	virt_to_phys(page_to_virt(page))
diff --git a/arch/s390/include/asm/io.h b/arch/s390/include/asm/io.h
index cb5fdf3a78fc..30fd5c84680e 100644
--- a/arch/s390/include/asm/io.h
+++ b/arch/s390/include/asm/io.h
@@ -29,7 +29,6 @@ void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 
 #define ioremap_nocache(addr, size)	ioremap(addr, size)
 #define ioremap_wc			ioremap_nocache
-#define ioremap_wt			ioremap_nocache
 
 static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 {
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 57f26c398dc9..407ac14295f4 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -129,7 +129,6 @@ static inline void sbus_memcpy_toio(volatile void __iomem *dst,
 void __iomem *ioremap(unsigned long offset, unsigned long size);
 #define ioremap_nocache(X,Y)	ioremap((X),(Y))
 #define ioremap_wc(X,Y)		ioremap((X),(Y))
-#define ioremap_wt(X,Y)		ioremap((X),(Y))
 void iounmap(volatile void __iomem *addr);
 
 /* Create a virtual mapping cookie for an IO port range */
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index c32fa3f752c8..50d4840d9aeb 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -402,7 +402,6 @@ static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 
 #define ioremap_nocache(X,Y)		ioremap((X),(Y))
 #define ioremap_wc(X,Y)			ioremap((X),(Y))
-#define ioremap_wt(X,Y)			ioremap((X),(Y))
 
 static inline void iounmap(volatile void __iomem *addr)
 {
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index e2867d235170..549ca9548928 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -54,7 +54,6 @@ extern void iounmap(volatile void __iomem *addr);
 
 #define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
 #define ioremap_wc(physaddr, size)		ioremap(physaddr, size)
-#define ioremap_wt(physaddr, size)		ioremap(physaddr, size)
 
 #define mmiowb()
 
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 349027c2943d..1a9d44ee9ed0 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -35,7 +35,6 @@
   */
 
 #define ARCH_HAS_IOREMAP_WC
-#define ARCH_HAS_IOREMAP_WT
 
 #include <linux/string.h>
 #include <linux/compiler.h>
@@ -320,7 +319,6 @@ extern void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr);
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				enum page_cache_mode pcm);
 extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
-extern void __iomem *ioremap_wt(resource_size_t offset, unsigned long size);
 
 extern bool is_early_ioremap_ptep(pte_t *ptep);
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 4516974f3bad..ffbfcf2e701b 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -293,23 +293,6 @@ void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 }
 EXPORT_SYMBOL(ioremap_wc);
 
-/**
- * ioremap_wt	-	map memory into CPU space write through
- * @phys_addr:	bus address of the memory
- * @size:	size of the resource to map
- *
- * This version of ioremap ensures that the memory is marked write through.
- * Write through stores data into memory while keeping the cache up-to-date.
- *
- * Must be freed with iounmap.
- */
-void __iomem *ioremap_wt(resource_size_t phys_addr, unsigned long size)
-{
-	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_MODE_WT,
-					__builtin_return_address(0));
-}
-EXPORT_SYMBOL(ioremap_wt);
-
 void *arch_memremap(resource_size_t phys_addr, size_t size,
 		unsigned long flags)
 {
diff --git a/arch/xtensa/include/asm/io.h b/arch/xtensa/include/asm/io.h
index 9bfbecc0fc99..aaafd90c70db 100644
--- a/arch/xtensa/include/asm/io.h
+++ b/arch/xtensa/include/asm/io.h
@@ -49,7 +49,6 @@ static inline void __iomem *ioremap_nocache(unsigned long offset,
 }
 
 #define ioremap_wc ioremap_nocache
-#define ioremap_wt ioremap_nocache
 
 static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 {
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 2d98de535e0f..b76ec47c6810 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -699,7 +699,7 @@ config FB_MAC
 
 config FB_HP300
 	bool
-	depends on (FB = y) && DIO
+	depends on (FB = y) && DIO && ARCH_HAS_MEMREMAP
 	select FB_CFB_IMAGEBLIT
 	default y
 
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index f56094cfdeff..f5abd5540249 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -785,14 +785,6 @@ static inline void __iomem *ioremap_wc(phys_addr_t offset, size_t size)
 }
 #endif
 
-#ifndef ioremap_wt
-#define ioremap_wt ioremap_wt
-static inline void __iomem *ioremap_wt(phys_addr_t offset, size_t size)
-{
-	return ioremap_nocache(offset, size);
-}
-#endif
-
 #ifndef iounmap
 #define iounmap iounmap
 
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index d8f8622fa044..1b41011643a5 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -66,10 +66,6 @@ extern void ioport_unmap(void __iomem *);
 #define ioremap_wc ioremap_nocache
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_WT
-#define ioremap_wt ioremap_nocache
-#endif
-
 #ifdef CONFIG_PCI
 /* Destroy a virtual mapping cookie for a PCI BAR (memory or IO) */
 struct pci_dev;

