Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/6] x86: clean up conditional pmem includes
Date: Thu,  6 Aug 2015 11:43:16 -0600
Message-Id: <1438883000-9011-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Toshi Kani <toshi.kani@hp.com>, Juergen Gross <jgross@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

Prior to this change x86_64 used the pmem defines in
arch/x86/include/asm/cacheflush.h, and UM used the default ones at the
top of include/linux/pmem.h.  The inclusion or exclusion in pmem.h was
controlled by CONFIG_ARCH_HAS_PMEM_API, but the ones in cacheflush.h
were controlled by ARCH_HAS_NOCACHE_UACCESS.

Instead, control them both with CONFIG_ARCH_HAS_PMEM_API so that it's
clear that they are related and we don't run into the possibility where
they are both included or excluded.  Also remove a bunch of stale
function prototypes meant for UM in cacheflush.h - these just conflicted
with the inline defaults in pmem.h, and gave compile errors:

include/linux/pmem.h:21:91: error: static declaration of
	'arch_wmb_pmem' follows non-static declaration
static inline void arch_wmb_pmem(void)
In file included from include/linux/highmem.h:11:0,
				 from include/linux/pagemap.h:10,
				 from include/linux/blkdev.h:14,
				 from fs/dax.c:18:
./arch/x86/include/asm/cacheflush.h:185:13: note: previous declaration of
	'arch_wmb_pmem' was here
 extern void arch_wmb_pmem(void);

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 arch/x86/include/asm/cacheflush.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 9bf3ea1..ae00766 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -109,8 +109,7 @@ static inline int rodata_test(void)
 }
 #endif
 
-#ifdef ARCH_HAS_NOCACHE_UACCESS
-
+#ifdef CONFIG_ARCH_HAS_PMEM_API
 /**
  * arch_memcpy_to_pmem - copy data to persistent memory
  * @dst: destination buffer for the copy
@@ -170,14 +169,6 @@ static inline bool __arch_has_wmb_pmem(void)
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
 
 #endif /* _ASM_X86_CACHEFLUSH_H */
-- 
2.1.0

