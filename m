Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68E8481EA0
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jan 2017 19:54:57 -0800 (PST)
Subject: [PATCH 07/13] x86, libnvdimm,
 pmem: move arch_invalidate_pmem() to libnvdimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Jan 2017 19:50:50 -0800
Message-ID: <148488425088.37913.1241235353803048107.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Kill this globally defined wrapper and move to libnvdimm so that we can
ultimately remove the public pmem api.

Cc: <x86@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/pmem.h |    4 ----
 drivers/nvdimm/claim.c      |    3 ++-
 drivers/nvdimm/pmem.c       |    2 +-
 drivers/nvdimm/pmem.h       |    4 ++++
 drivers/nvdimm/x86.c        |    6 ++++++
 include/linux/pmem.h        |   19 -------------------
 6 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 4759a179aa52..ded2541a7ba9 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -44,9 +44,5 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 		BUG();
 }
 
-static inline void arch_invalidate_pmem(void *addr, size_t size)
-{
-	clflush_cache_range(addr, size);
-}
 #endif /* CONFIG_ARCH_HAS_PMEM_API */
 #endif /* __ASM_X86_PMEM_H__ */
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 61293504b52c..dca2a15dc01d 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -14,6 +14,7 @@
 #include <linux/sizes.h>
 #include <linux/pmem.h>
 #include "nd-core.h"
+#include "pmem.h"
 #include "pfn.h"
 #include "btt.h"
 #include "nd.h"
@@ -253,7 +254,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 				cleared /= 512;
 				badblocks_clear(&nsio->bb, sector, cleared);
 			}
-			invalidate_pmem(nsio->addr + offset, size);
+			arch_invalidate_pmem(nsio->addr + offset, size);
 		} else
 			rc = -EIO;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 838241bb31d1..d551bd2ef9dd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -68,7 +68,7 @@ static int pmem_clear_poison(struct pmem_device *pmem, phys_addr_t offset,
 		badblocks_clear(&pmem->bb, sector, cleared);
 	}
 
-	invalidate_pmem(pmem->virt_addr + offset, len);
+	arch_invalidate_pmem(pmem->virt_addr + offset, len);
 
 	return rc;
 }
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 4faacff434ff..02f94e1f14ea 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -10,10 +10,14 @@ long pmem_direct_access(struct block_device *bdev, sector_t sector,
 
 #ifdef CONFIG_ARCH_HAS_PMEM_API
 void arch_wb_cache_pmem(void *addr, size_t size);
+void arch_invalidate_pmem(void *addr, size_t size);
 #else
 static inline void arch_wb_cache_pmem(void *addr, size_t size)
 {
 }
+static inline void arch_invalidate_pmem(void *addr, size_t size)
+{
+}
 #endif
 
 /* this definition is in it's own header for tools/testing/nvdimm to consume */
diff --git a/drivers/nvdimm/x86.c b/drivers/nvdimm/x86.c
index 79d7267da4d2..07478ed7ce97 100644
--- a/drivers/nvdimm/x86.c
+++ b/drivers/nvdimm/x86.c
@@ -34,3 +34,9 @@ void arch_wb_cache_pmem(void *addr, size_t size)
 		clwb(p);
 }
 EXPORT_SYMBOL_GPL(arch_wb_cache_pmem);
+
+void arch_invalidate_pmem(void *addr, size_t size)
+{
+	clflush_cache_range(addr, size);
+}
+EXPORT_SYMBOL_GPL(arch_invalidate_pmem);
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 33ae761f010a..559c00848583 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -30,11 +30,6 @@ static inline void arch_memcpy_to_pmem(void *dst, const void *src, size_t n)
 {
 	BUG();
 }
-
-static inline void arch_invalidate_pmem(void *addr, size_t size)
-{
-	BUG();
-}
 #endif
 
 static inline bool arch_has_pmem_api(void)
@@ -61,18 +56,4 @@ static inline void memcpy_to_pmem(void *dst, const void *src, size_t n)
 	else
 		memcpy(dst, src, n);
 }
-
-/**
- * invalidate_pmem - flush a pmem range from the cache hierarchy
- * @addr:	virtual start address
- * @size:	bytes to invalidate (internally aligned to cache line size)
- *
- * For platforms that support clearing poison this flushes any poisoned
- * ranges out of the cache
- */
-static inline void invalidate_pmem(void *addr, size_t size)
-{
-	if (arch_has_pmem_api())
-		arch_invalidate_pmem(addr, size);
-}
 #endif /* __PMEM_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
