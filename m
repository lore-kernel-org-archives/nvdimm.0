Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] pmem, nfit: Fix ARCH_MEMREMAP_PMEM handling on x86_32
Date: Fri, 28 Aug 2015 18:16:06 -0600
Message-Id: <1440807366-31223-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, hch@lst.de, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

ARCH_MEMREMAP_PMEM is defined on x86_64 only per ARCH_HAS_PMEM_API.
The following compile error in __nfit_spa_map() was observed on
x86_32 as it refers ARCH_MEMREMAP_PMEM without #ifdef.

  drivers/acpi/nfit.c:1205:8: error: 'ARCH_MEMREMAP_PMEM'
  undeclared (first use in this function)

Fix it by defining ARCH_MEMREMAP_PMEM to MEMREMAP_WT in <linux/pmem.h>
when CONFIG_ARCH_HAS_PMEM_API is not set, i.e. x86_32.

Remove '#ifdef ARCH_MEMREMAP_PMEM's that are no longer necessary
with this change.

Also remove the redundant definition of ARCH_MEMREMAP_PMEM in
<asm/pmem.h>.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>
----
Apply on top of libnvdimm-for-next of the nvdimm tree.
---
 arch/x86/include/asm/pmem.h     |    2 --
 drivers/nvdimm/namespace_devs.c |    4 ----
 include/linux/pmem.h            |    6 +-----
 3 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 5c8c753..5111f1f 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -18,8 +18,6 @@
 #include <asm/cpufeature.h>
 #include <asm/special_insns.h>
 
-#define ARCH_MEMREMAP_PMEM MEMREMAP_WB
-
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #define ARCH_MEMREMAP_PMEM MEMREMAP_WB
 /**
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 0955b2c..6b40e1c 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -90,11 +90,7 @@ bool pmem_should_map_pages(struct device *dev)
 	if (is_nd_pfn(dev) || is_nd_btt(dev))
 		return false;
 
-#ifdef ARCH_MEMREMAP_PMEM
 	return ARCH_MEMREMAP_PMEM == MEMREMAP_WB;
-#else
-	return false;
-#endif
 }
 EXPORT_SYMBOL(pmem_should_map_pages);
 
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index ebf95a6..04eefc6 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -19,6 +19,7 @@
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 #include <asm/pmem.h>
 #else
+#define ARCH_MEMREMAP_PMEM MEMREMAP_WT
 /*
  * These are simply here to enable compilation, all call sites gate
  * calling these symbols with arch_has_pmem_api() and redirect to the
@@ -129,13 +130,8 @@ static inline void default_clear_pmem(void __pmem *addr, size_t size)
 static inline void __pmem *memremap_pmem(struct device *dev,
 		resource_size_t offset, unsigned long size)
 {
-#ifdef ARCH_MEMREMAP_PMEM
 	return (void __pmem *) devm_memremap(dev, offset, size,
 			ARCH_MEMREMAP_PMEM);
-#else
-	return (void __pmem *) devm_memremap(dev, offset, size,
-			MEMREMAP_WT);
-#endif
 }
 
 /**
