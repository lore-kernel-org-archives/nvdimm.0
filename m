Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 8A7CE21C91255
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 03:54:10 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 2/6] arm64: Convert __inval_cache_range() to area-based
Date: Tue, 25 Jul 2017 11:55:39 +0100
Message-Id: <d8ee26edfc114ba4d93b042a22b159ba90936b6c.1500397441.git.robin.murphy@arm.com>
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

__inval_cache_range() is already the odd one out among our data cache
maintenance routines as the only remaining range-based one; as we're
going to want an invalidation routine to call from C code for the pmem
API, let's tweak the prototype and name to bring it in line with the
clean operations, and to make its relationship with __dma_inv_area()
neatly mirror that of __clean_dcache_area_poc() and __dma_clean_area().
The loop clearing the early page tables gets mildly massaged in the
process for the sake of consistency.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/arm64/include/asm/cacheflush.h |  1 +
 arch/arm64/kernel/head.S            | 18 +++++++++---------
 arch/arm64/mm/cache.S               | 23 ++++++++++++++---------
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 4d4f650c290e..b4b43a94dffd 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -67,6 +67,7 @@
  */
 extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void __flush_dcache_area(void *addr, size_t len);
+extern void __inval_dcache_area(void *addr, size_t len);
 extern void __clean_dcache_area_poc(void *addr, size_t len);
 extern void __clean_dcache_area_pou(void *addr, size_t len);
 extern long __flush_cache_user_range(unsigned long start, unsigned long end);
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 973df7de7bf8..73a0531e0187 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -143,8 +143,8 @@ preserve_boot_args:
 	dmb	sy				// needed before dc ivac with
 						// MMU off
 
-	add	x1, x0, #0x20			// 4 x 8 bytes
-	b	__inval_cache_range		// tail call
+	mov	x1, #0x20			// 4 x 8 bytes
+	b	__inval_dcache_area		// tail call
 ENDPROC(preserve_boot_args)
 
 /*
@@ -221,20 +221,20 @@ __create_page_tables:
 	 * dirty cache lines being evicted.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x1, swapper_pg_dir + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
-	bl	__inval_cache_range
+	ldr	x1, =(IDMAP_DIR_SIZE + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE)
+	bl	__inval_dcache_area
 
 	/*
 	 * Clear the idmap and swapper page tables.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x6, swapper_pg_dir + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
+	ldr	x1, =(IDMAP_DIR_SIZE + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE)
 1:	stp	xzr, xzr, [x0], #16
 	stp	xzr, xzr, [x0], #16
 	stp	xzr, xzr, [x0], #16
 	stp	xzr, xzr, [x0], #16
-	cmp	x0, x6
-	b.lo	1b
+	subs	x1, x1, #64
+	b.ne	1b
 
 	mov	x7, SWAPPER_MM_MMUFLAGS
 
@@ -307,9 +307,9 @@ __create_page_tables:
 	 * tables again to remove any speculatively loaded cache lines.
 	 */
 	adrp	x0, idmap_pg_dir
-	adrp	x1, swapper_pg_dir + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
+	ldr	x1, =(IDMAP_DIR_SIZE + SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE)
 	dmb	sy
-	bl	__inval_cache_range
+	bl	__inval_dcache_area
 
 	ret	x28
 ENDPROC(__create_page_tables)
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 83c27b6e6dca..ed47fbbb4b05 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -109,20 +109,25 @@ ENTRY(__clean_dcache_area_pou)
 ENDPROC(__clean_dcache_area_pou)
 
 /*
+ *	__inval_dcache_area(kaddr, size)
+ *
+ * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
+ * 	are invalidated. Any partial lines at the ends of the interval are
+ *	also cleaned to PoC to prevent data loss.
+ *
+ *	- kaddr   - kernel address
+ *	- size    - size in question
+ */
+ENTRY(__inval_dcache_area)
+	/* FALLTHROUGH */
+
+/*
  *	__dma_inv_area(start, size)
  *	- start   - virtual start address of region
  *	- size    - size in question
  */
 __dma_inv_area:
 	add	x1, x1, x0
-	/* FALLTHROUGH */
-
-/*
- *	__inval_cache_range(start, end)
- *	- start   - start address of region
- *	- end     - end address of region
- */
-ENTRY(__inval_cache_range)
 	dcache_line_size x2, x3
 	sub	x3, x2, #1
 	tst	x1, x3				// end cache line aligned?
@@ -140,7 +145,7 @@ ENTRY(__inval_cache_range)
 	b.lo	2b
 	dsb	sy
 	ret
-ENDPIPROC(__inval_cache_range)
+ENDPIPROC(__inval_dcache_area)
 ENDPROC(__dma_inv_area)
 
 /*
-- 
2.12.2.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
