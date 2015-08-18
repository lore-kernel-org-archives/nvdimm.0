Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 4/7] pmem, x86: clean up conditional pmem includes
Date: Tue, 18 Aug 2015 13:55:38 -0600
Message-Id: <1439927741-29580-5-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1439927741-29580-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Prior to this change x86_64 used the pmem defines in
arch/x86/include/asm/pmem.h, and UM used the default ones at the
top of include/linux/pmem.h.  The inclusion or exclusion in linux/pmem.h
was controlled by CONFIG_ARCH_HAS_PMEM_API, but the ones in asm/pmem.h
were controlled by ARCH_HAS_NOCACHE_UACCESS.

Instead, control them both with CONFIG_ARCH_HAS_PMEM_API so that it's
clear that they are related and we don't run into the possibility where
they are both included or excluded.  Also remove a bunch of stale
function prototypes meant for UM in asm/pmem.h - these just conflicted
with the inline defaults in linux/pmem.h and gave compile errors.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/pmem.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/pmem.h b/arch/x86/include/asm/pmem.h
index 1e8dbb7..7f3413f 100644
--- a/arch/x86/include/asm/pmem.h
+++ b/arch/x86/include/asm/pmem.h
@@ -18,8 +18,7 @@
 #include <asm/cpufeature.h>
 #include <asm/special_insns.h>
 
-#ifdef ARCH_HAS_NOCACHE_UACCESS
-
+#ifdef CONFIG_ARCH_HAS_PMEM_API
 /**
  * arch_memcpy_to_pmem - copy data to persistent memory
  * @dst: destination buffer for the copy
@@ -79,14 +78,6 @@ static inline bool arch_has_wmb_pmem(void)
 	return false;
 #endif
 }
-#else /* ARCH_HAS_NOCACHE_UACCESS i.e. ARCH=um */
-extern void arch_memcpy_to_pmem(void __pmem *dst, const void *src, size_t n);
-extern void arch_wmb_pmem(void);
-
-static inline bool __arch_has_wmb_pmem(void)
-{
-	return false;
-}
-#endif
+#endif /* CONFIG_ARCH_HAS_PMEM_API */
 
 #endif /* __ASM_X86_PMEM_H__ */
-- 
2.1.0

