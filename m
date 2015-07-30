Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 21/24] arch: kill ioremap_fullcache()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Jul 2015 12:55:36 -0400
Message-ID: <20150730165536.33962.67351.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150730165155.33962.64121.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Cc: linux-arch@vger.kernel.org, toshi.kani@hp.com, linux-nvdimm@lists.01.org, mcgrof@suse.com, linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk, hch@lst.de, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Nothing calls this helper, and now that ioremap_cache() is being
deprecated these can also be removed.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/frv/include/asm/io.h        |    5 -----
 arch/m68k/include/asm/io_mm.h    |    6 ------
 arch/m68k/include/asm/io_no.h    |    5 -----
 arch/microblaze/include/asm/io.h |    1 -
 arch/tile/include/asm/io.h       |    1 -
 5 files changed, 18 deletions(-)

diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
index a31b63ec4930..15a49a268754 100644
--- a/arch/frv/include/asm/io.h
+++ b/arch/frv/include/asm/io.h
@@ -272,11 +272,6 @@ static inline void __iomem *ioremap_wt(unsigned long physaddr, unsigned long siz
 	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
 }
 
-static inline void __iomem *ioremap_fullcache(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
-}
-
 #define ioremap_wc ioremap_nocache
 
 extern void iounmap(void volatile __iomem *addr);
diff --git a/arch/m68k/include/asm/io_mm.h b/arch/m68k/include/asm/io_mm.h
index f55cad529400..910e90770eb2 100644
--- a/arch/m68k/include/asm/io_mm.h
+++ b/arch/m68k/include/asm/io_mm.h
@@ -473,12 +473,6 @@ static inline void __iomem *ioremap_wt(unsigned long physaddr,
 {
 	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
 }
-static inline void __iomem *ioremap_fullcache(unsigned long physaddr,
-				      unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
-}
-
 static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
 	__builtin_memset((void __force *) addr, val, count);
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index ad7bd40e6742..2690fa99dc56 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -159,11 +159,6 @@ static inline void *ioremap_wt(unsigned long physaddr, unsigned long size)
 {
 	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
 }
-static inline void *ioremap_fullcache(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
-}
-
 #define	iounmap(addr)	do { } while(0)
 
 /*
diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index 39b6315db82e..5e0cbf4e4204 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -40,7 +40,6 @@ extern void iounmap(void __iomem *addr);
 
 extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
 #define ioremap_nocache(addr, size)		ioremap((addr), (size))
-#define ioremap_fullcache(addr, size)		ioremap((addr), (size))
 #define ioremap_wc(addr, size)			ioremap((addr), (size))
 #define ioremap_wt(addr, size)			ioremap((addr), (size))
 
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index dc61de15c1f9..e2867d235170 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -55,7 +55,6 @@ extern void iounmap(volatile void __iomem *addr);
 #define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
 #define ioremap_wc(physaddr, size)		ioremap(physaddr, size)
 #define ioremap_wt(physaddr, size)		ioremap(physaddr, size)
-#define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
 
 #define mmiowb()
 

