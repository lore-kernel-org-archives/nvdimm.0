Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 8148D2095BB9E
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 11:19:12 -0700 (PDT)
From: Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH] nd_blk: Remove mmio_flush_range()
Date: Wed, 30 Aug 2017 19:19:01 +0100
Message-Id: <a8de5c42cbfcd467586d3f93adbbee877050b6b9.1504113975.git.robin.murphy@arm.com>
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
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

mmio_flush_range() suffers from a lack of clearly-defined semantics,
and is somewhat ambiguous to port to other architectures where the
scope of the writeback implied by "flush" and ordering might matter,
but MMIO would tend to imply non-cacheable anyway. Per the rationale
in 67a3e8fe9015 ("nd_blk: change aperture mapping from WC to WB"), the
only existing use is actually to invalidate clean cache lines for
ARCH_MEMREMAP_PMEM type mappings *without* writeback. Since the recent
cleanup of the pmem API, that also now happens to be the exact purpose
of arch_invalidate_pmem(), which would be a far more well-defined tool
for the job.

Rather than risk potentially inconsistent implementations of
mmio_flush_range() for the sake of one callsite, streamline things by
removing it entirely and instead move the ARCH_MEMREMAP_PMEM related
definitions up to the libnvdimm level, so they can be shared by NFIT
as well. This allows NFIT to be enabled for arm64.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 arch/x86/Kconfig                  |  1 -
 arch/x86/include/asm/cacheflush.h |  2 --
 drivers/acpi/nfit/Kconfig         |  1 -
 drivers/acpi/nfit/core.c          |  2 +-
 drivers/nvdimm/pmem.h             | 14 --------------
 include/linux/libnvdimm.h         | 15 +++++++++++++++
 lib/Kconfig                       |  3 ---
 tools/testing/nvdimm/test/nfit.c  |  4 ++--
 8 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 781521b7cf9e..5f3b756ec0d3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -53,7 +53,6 @@ config X86
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_KCOV			if X86_64
-	select ARCH_HAS_MMIO_FLUSH
 	select ARCH_HAS_PMEM_API		if X86_64
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
 	select ARCH_HAS_SET_MEMORY
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 8b4140f6724f..cb9a1af109b4 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -7,6 +7,4 @@
 
 void clflush_cache_range(void *addr, unsigned int size);
 
-#define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
-
 #endif /* _ASM_X86_CACHEFLUSH_H */
diff --git a/drivers/acpi/nfit/Kconfig b/drivers/acpi/nfit/Kconfig
index 6d3351452ea2..97117ba582f3 100644
--- a/drivers/acpi/nfit/Kconfig
+++ b/drivers/acpi/nfit/Kconfig
@@ -2,7 +2,6 @@ config ACPI_NFIT
 	tristate "ACPI NVDIMM Firmware Interface Table (NFIT)"
 	depends on PHYS_ADDR_T_64BIT
 	depends on BLK_DEV
-	depends on ARCH_HAS_MMIO_FLUSH
 	select LIBNVDIMM
 	help
 	  Infrastructure to probe ACPI 6 compliant platforms for
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d091587..ee7726a16693 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1930,7 +1930,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 			memcpy_flushcache(mmio->addr.aperture + offset, iobuf + copied, c);
 		else {
 			if (nfit_blk->dimm_flags & NFIT_BLK_READ_FLUSH)
-				mmio_flush_range((void __force *)
+				arch_invalidate_pmem((void __force *)
 					mmio->addr.aperture + offset, c);
 
 			memcpy(iobuf + copied, mmio->addr.aperture + offset, c);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 5434321cad67..c5917f040fa7 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -5,20 +5,6 @@
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
 
-#ifdef CONFIG_ARCH_HAS_PMEM_API
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
-void arch_wb_cache_pmem(void *addr, size_t size);
-void arch_invalidate_pmem(void *addr, size_t size);
-#else
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
-static inline void arch_wb_cache_pmem(void *addr, size_t size)
-{
-}
-static inline void arch_invalidate_pmem(void *addr, size_t size)
-{
-}
-#endif
-
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
 struct pmem_device {
 	/* One contiguous memory region per device */
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f3d3e6af8838..d11bc9881206 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -173,4 +173,19 @@ u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
+
+#ifdef CONFIG_ARCH_HAS_PMEM_API
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
+void arch_wb_cache_pmem(void *addr, size_t size);
+void arch_invalidate_pmem(void *addr, size_t size);
+#else
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
+static inline void arch_wb_cache_pmem(void *addr, size_t size)
+{
+}
+static inline void arch_invalidate_pmem(void *addr, size_t size)
+{
+}
+#endif
+
 #endif /* __LIBNVDIMM_H__ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 6762529ad9e4..527da69e3be1 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -559,9 +559,6 @@ config ARCH_HAS_PMEM_API
 config ARCH_HAS_UACCESS_FLUSHCACHE
 	bool
 
-config ARCH_HAS_MMIO_FLUSH
-	bool
-
 config STACKDEPOT
 	bool
 	select STACKTRACE
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 4c2fa98ef39d..d20791c3f499 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1546,8 +1546,8 @@ static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
 	else {
 		memcpy(iobuf, mmio->addr.base + dpa, len);
 
-		/* give us some some coverage of the mmio_flush_range() API */
-		mmio_flush_range(mmio->addr.base + dpa, len);
+		/* give us some some coverage of the arch_invalidate_pmem() API */
+		arch_invalidate_pmem(mmio->addr.base + dpa, len);
 	}
 	nd_region_release_lane(nd_region, lane);
 
-- 
2.13.4.dirty

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
