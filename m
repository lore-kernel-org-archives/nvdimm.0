Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/6] pmem: remove indirection layer arch_has_pmem_api()
Date: Thu,  6 Aug 2015 11:43:15 -0600
Message-Id: <1438883000-9011-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1438883000-9011-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Prior to this change arch_has_wmb_pmem() was only called by
arch_has_pmem_api().  Both arch_has_wmb_pmem() and arch_has_pmem_api()
checked to make sure that CONFIG_ARCH_HAS_PMEM_API was enabled.

Instead, remove one extra layer of indirection and the redundant
CONFIG_ARCH_HAS_PMEM_API check, and just have arch_has_pmem_api()
call __arch_has_wmb_pmem() directly.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/pmem.h | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/linux/pmem.h b/include/linux/pmem.h
index 03f9d73..fb62ce4 100644
--- a/include/linux/pmem.h
+++ b/include/linux/pmem.h
@@ -58,7 +58,7 @@ static inline void memunmap_pmem(void __pmem *addr)
 }
 
 /**
- * arch_has_wmb_pmem - true if wmb_pmem() ensures durability
+ * arch_has_pmem_api - true if wmb_pmem() ensures durability
  *
  * For a given cpu implementation within an architecture it is possible
  * that wmb_pmem() resolves to a nop.  In the case this returns
@@ -66,16 +66,9 @@ static inline void memunmap_pmem(void __pmem *addr)
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
-	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && arch_has_wmb_pmem();
+	return IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && __arch_has_wmb_pmem();
 }
 
 /*
-- 
2.1.0

