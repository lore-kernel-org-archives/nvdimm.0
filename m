Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id E338A21C91255
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 03:54:14 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 5/6] arm64: Implement pmem API support
Date: Tue, 25 Jul 2017 11:55:42 +0100
Message-Id: <ba8c28bcffc3bc856163441793bb4ef0fefa0f75.1500397441.git.robin.murphy@arm.com>
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

Add a clean-to-point-of-persistence cache maintenance helper, and wire
up the basic architectural support for the pmem driver based on it.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/arm64/Kconfig                  | 11 +++++++++++
 arch/arm64/include/asm/assembler.h  |  6 ++++++
 arch/arm64/include/asm/cacheflush.h |  1 +
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
 arch/arm64/mm/cache.S               | 14 ++++++++++++++
 arch/arm64/mm/pageattr.c            | 18 ++++++++++++++++++
 7 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index dfd908630631..0b0576a54724 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -960,6 +960,17 @@ config ARM64_UAO
 	  regular load/store instructions if the cpu does not implement the
 	  feature.
 
+config ARM64_PMEM
+	bool "Enable support for persistent memory"
+	select ARCH_HAS_PMEM_API
+	help
+	  Say Y to enable support for the persistent memory API based on the
+	  ARMv8.2 DCPoP feature.
+
+	  The feature is detected at runtime, and the kernel will use DC CVAC
+	  operations if DC CVAP is not supported (following the behaviour of
+	  DC CVAP itself if the system does not define a point of persistence).
+
 endmenu
 
 config ARM64_MODULE_CMODEL_LARGE
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 1b67c3782d00..5d8903c45031 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -353,6 +353,12 @@ alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
 alternative_else
 	dc	civac, \kaddr
 alternative_endif
+	.elseif	(\op == cvap)
+alternative_if ARM64_HAS_DCPOP
+	sys 3, c7, c12, 1, \kaddr	// dc cvap
+alternative_else
+	dc	cvac, \kaddr
+alternative_endif
 	.else
 	dc	\op, \kaddr
 	.endif
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index b4b43a94dffd..76d1cc85d5b1 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -69,6 +69,7 @@ extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void __flush_dcache_area(void *addr, size_t len);
 extern void __inval_dcache_area(void *addr, size_t len);
 extern void __clean_dcache_area_poc(void *addr, size_t len);
+extern void __clean_dcache_area_pop(void *addr, size_t len);
 extern void __clean_dcache_area_pou(void *addr, size_t len);
 extern long __flush_cache_user_range(unsigned long start, unsigned long end);
 extern void sync_icache_aliases(void *kaddr, unsigned long len);
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8d2272c6822c..8da621627d7c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -39,7 +39,8 @@
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
+#define ARM64_HAS_DCPOP				21
 
-#define ARM64_NCAPS				21
+#define ARM64_NCAPS				22
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a2542ef3ff25..cd52d365d1f0 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -889,6 +889,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
+#ifdef CONFIG_ARM64_PMEM
+	{
+		.desc = "Data cache clean to Point of Persistence",
+		.capability = ARM64_HAS_DCPOP,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.field_pos = ID_AA64ISAR1_DPB_SHIFT,
+		.min_field_value = 1,
+	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index ed47fbbb4b05..7f1dbe962cf5 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -172,6 +172,20 @@ ENDPIPROC(__clean_dcache_area_poc)
 ENDPROC(__dma_clean_area)
 
 /*
+ *	__clean_dcache_area_pop(kaddr, size)
+ *
+ * 	Ensure that any D-cache lines for the interval [kaddr, kaddr+size)
+ * 	are cleaned to the PoP.
+ *
+ *	- kaddr   - kernel address
+ *	- size    - size in question
+ */
+ENTRY(__clean_dcache_area_pop)
+	dcache_by_line_op cvap, sy, x0, x1, x2, x3
+	ret
+ENDPIPROC(__clean_dcache_area_pop)
+
+/*
  *	__dma_flush_area(start, size)
  *
  *	clean & invalidate D / U line
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index a682a0a2a0fa..a461a00ceb3e 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -183,3 +183,21 @@ bool kernel_page_present(struct page *page)
 }
 #endif /* CONFIG_HIBERNATION */
 #endif /* CONFIG_DEBUG_PAGEALLOC */
+
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+#include <asm/cacheflush.h>
+
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
+{
+	/* Ensure order against any prior non-cacheable writes */
+	dmb(sy);
+	__clean_dcache_area_pop(addr, size);
+}
+EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);
+
+static inline void arch_invalidate_pmem(void *addr, size_t size)
+{
+	__inval_dcache_area(addr, size);
+}
+EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
+#endif
-- 
2.12.2.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
