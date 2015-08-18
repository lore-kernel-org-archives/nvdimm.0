Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 3/7] pmem: remove layer when calling arch_has_wmb_pmem()
Date: Tue, 18 Aug 2015 13:55:37 -0600
Message-Id: <1439927741-29580-4-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prior to this change arch_has_wmb_pmem() was only called by
arch_has_pmem_api().  Both arch_has_wmb_pmem() and arch_has_pmem_api()
checked to make sure that CONFIG_ARCH_HAS_PMEM_API was enabled.

Instead, remove the old arch_has_wmb_pmem() wrapper to be rid of one
extra layer of indirection and the redundant CONFIG_ARCH_HAS_PMEM_API
check. Rename __arch_has_wmb_pmem() to arch_has_wmb_pmem() since we no
longer have a wrapper, and just have arch_has_pmem_api() call the
architecture specific arch_has_wmb_pmem() directly.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/pmem.h |  2 +-
 include/linux/pmem.h        | 13 +++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index f43462c..1e8dbb7 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -67,7 +67,7 @@ static inline void arch_wmb_pmem(void)
 	pcommit_sfence();
 }
 
-static inline bool __arch_has_wmb_pmem(void)
+static inline bool arch_has_wmb_pmem(void)
 {
 #ifdef CONFIG_X86_64
 	/*
diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index c2af613..a0706ea 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -23,7 +23,7 @@ static inline void arch_wmb_pmem(void)
 	BUG();
 }
 
-static inline bool __arch_has_wmb_pmem(void)
+static inline bool arch_has_wmb_pmem(void)
 {
 	return false;
 }
@@ -38,7 +38,7 @@ static inline void arch_memcpy_to_pmem(void __pmem *dst, const void *src,
 /*
  * Architectures that define ARCH_HAS_PMEM_API must provide
  * implementations for arch_memcpy_to_pmem(), arch_wmb_pmem(), and
- * __arch_has_wmb_pmem().
+ * arch_has_wmb_pmem().
  */
 
 static inline void memcpy_from_pmem(void *dst, void __pmem const *src, size_t size)
@@ -52,7 +52,7 @@ static inline void memunmap_pmem(struct device *dev, void __pmem *addr)
 }
 
 /**
- * arch_has_wmb_pmem - true if wmb_pmem() ensures durability
+ * arch_has_pmem_api - true if wmb_pmem() ensures durability
  *
  * For a given cpu implementation within an architecture it is possible
  * that wmb_pmem() resolves to a nop.  In the case this returns
@@ -60,13 +60,6 @@ static inline void memunmap_pmem(struct device *dev, void __pmem *addr)
  * fall back to a different data consistency model, or otherwise notify
  * the user.
  */
-static inline bool arch_has_wmb_pmem(void)
-{
-	if (IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API))
-		return __arch_has_wmb_pmem();
-	return false;
-}
-
 static inline bool arch_has_pmem_api(void)
 {
 	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && arch_has_wmb_pmem();
-- 
2.1.0

