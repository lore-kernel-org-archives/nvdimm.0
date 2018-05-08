Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
 [216.82.243.208])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A1F7203BBB91
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 19:33:44 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: [External]  [RFC PATCH v1 3/6] mm, zone_type: create ZONE_NVM and
 fill into GFP_ZONE_TABLE
Date: Tue, 8 May 2018 02:33:30 +0000
Message-ID: <HK2PR03MB1684653383FFEDAE9B41A548929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-4-git-send-email-yehs1@lenovo.com>
In-Reply-To: <1525746628-114136-4-git-send-email-yehs1@lenovo.com>
Content-Language: zh-CN
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
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ocean HY1 He <hehy1@lenovo.com>, "penguin-kernel@I-love.SAKURA.ne.jp" <penguin-kernel@I-love.SAKURA.ne.jp>, NingTing Cheng <chengnt@lenovo.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "pasha.tatashin@oracle.com" <pasha.tatashin@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "colyli@suse.de" <colyli@suse.de>, "mgorman@techsingularity.net" <mgorman@techsingularity.net>, "vbabka@suse.cz" <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

Expand ZONE_NVM into enum zone_type, and create GFP_NVM
which represents gfp_t flag for NVM zone.

Because there is no lower plain integer GFP bitmask can be
used for ___GFP_NVM, a workable way is to get space from
GFP_ZONE_BAD to fill ZONE_NVM into GFP_ZONE_TABLE.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 include/linux/gfp.h    | 57 +++++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/mmzone.h |  3 +++
 mm/Kconfig             | 16 ++++++++++++++
 mm/page_alloc.c        |  3 +++
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 1a4582b..9e4d867 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -39,6 +39,9 @@
 #define ___GFP_DIRECT_RECLAIM	0x400000u
 #define ___GFP_WRITE		0x800000u
 #define ___GFP_KSWAPD_RECLAIM	0x1000000u
+#ifdef CONFIG_ZONE_NVM
+#define ___GFP_NVM		0x4000000u
+#endif
 #ifdef CONFIG_LOCKDEP
 #define ___GFP_NOLOCKDEP	0x2000000u
 #else
@@ -57,7 +60,12 @@
 #define __GFP_HIGHMEM	((__force gfp_t)___GFP_HIGHMEM)
 #define __GFP_DMA32	((__force gfp_t)___GFP_DMA32)
 #define __GFP_MOVABLE	((__force gfp_t)___GFP_MOVABLE)  /* ZONE_MOVABLE allowed */
+#ifdef CONFIG_ZONE_NVM
+#define __GFP_NVM	((__force gfp_t)___GFP_NVM)  /* ZONE_NVM allowed */
+#define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE|__GFP_NVM)
+#else
 #define GFP_ZONEMASK	(__GFP_DMA|__GFP_HIGHMEM|__GFP_DMA32|__GFP_MOVABLE)
+#endif
 
 /*
  * Page mobility and placement hints
@@ -205,7 +213,8 @@
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (25 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (25 + IS_ENABLED(CONFIG_LOCKDEP) + \
+				(IS_ENABLED(CONFIG_ZONE_NVM) << 1))
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /*
@@ -283,6 +292,9 @@
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
+#ifdef CONFIG_ZONE_NVM
+#define GFP_NVM		__GFP_NVM
+#endif
 
 /* Convert GFP flags to their corresponding migrate type */
 #define GFP_MOVABLE_MASK (__GFP_RECLAIMABLE|__GFP_MOVABLE)
@@ -342,7 +354,7 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
  *       0x0    => NORMAL
  *       0x1    => DMA or NORMAL
  *       0x2    => HIGHMEM or NORMAL
- *       0x3    => BAD (DMA+HIGHMEM)
+ *       0x3    => NVM (DMA+HIGHMEM), now it is used by NVDIMM zone
  *       0x4    => DMA32 or DMA or NORMAL
  *       0x5    => BAD (DMA+DMA32)
  *       0x6    => BAD (HIGHMEM+DMA32)
@@ -370,6 +382,29 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 #error GFP_ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
 #endif
 
+#ifdef CONFIG_ZONE_NVM
+#define ___GFP_NVM_BIT (___GFP_DMA | ___GFP_HIGHMEM)
+#define GFP_ZONE_TABLE ( \
+	((__force unsigned long)ZONE_NORMAL <<				       \
+			0 * GFP_ZONES_SHIFT)				       \
+	| ((__force unsigned long)OPT_ZONE_DMA <<			       \
+			___GFP_DMA * GFP_ZONES_SHIFT)			       \
+	| ((__force unsigned long)OPT_ZONE_HIGHMEM <<			       \
+			___GFP_HIGHMEM * GFP_ZONES_SHIFT)		       \
+	| ((__force unsigned long)OPT_ZONE_DMA32 <<			       \
+			___GFP_DMA32 * GFP_ZONES_SHIFT)			       \
+	| ((__force unsigned long)ZONE_NORMAL <<			       \
+			___GFP_MOVABLE * GFP_ZONES_SHIFT)		       \
+	| ((__force unsigned long)OPT_ZONE_DMA <<			       \
+			(___GFP_MOVABLE | ___GFP_DMA) * GFP_ZONES_SHIFT)       \
+	| ((__force unsigned long)ZONE_MOVABLE <<			       \
+			(___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)   \
+	| ((__force unsigned long)OPT_ZONE_DMA32 <<			       \
+			(___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)     \
+	| ((__force unsigned long)ZONE_NVM <<				       \
+			___GFP_NVM_BIT * GFP_ZONES_SHIFT)                      \
+)
+#else
 #define GFP_ZONE_TABLE ( \
 	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				       \
 	| (OPT_ZONE_DMA << ___GFP_DMA * GFP_ZONES_SHIFT)		       \
@@ -380,6 +415,7 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 	| (ZONE_MOVABLE << (___GFP_MOVABLE | ___GFP_HIGHMEM) * GFP_ZONES_SHIFT)\
 	| (OPT_ZONE_DMA32 << (___GFP_MOVABLE | ___GFP_DMA32) * GFP_ZONES_SHIFT)\
 )
+#endif
 
 /*
  * GFP_ZONE_BAD is a bitmap for all combinations of __GFP_DMA, __GFP_DMA32
@@ -387,6 +423,17 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
  * entry starting with bit 0. Bit is set if the combination is not
  * allowed.
  */
+#ifdef CONFIG_ZONE_NVM
+#define GFP_ZONE_BAD ( \
+	1 << (___GFP_DMA | ___GFP_DMA32)				      \
+	| 1 << (___GFP_DMA32 | ___GFP_HIGHMEM)				      \
+	| 1 << (___GFP_DMA | ___GFP_DMA32 | ___GFP_HIGHMEM)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_HIGHMEM | ___GFP_DMA)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_DMA)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_HIGHMEM)		      \
+	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_DMA | ___GFP_HIGHMEM)  \
+)
+#else
 #define GFP_ZONE_BAD ( \
 	1 << (___GFP_DMA | ___GFP_HIGHMEM)				      \
 	| 1 << (___GFP_DMA | ___GFP_DMA32)				      \
@@ -397,12 +444,16 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
 	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_HIGHMEM)		      \
 	| 1 << (___GFP_MOVABLE | ___GFP_DMA32 | ___GFP_DMA | ___GFP_HIGHMEM)  \
 )
+#endif
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
 	enum zone_type z;
 	int bit = (__force int) (flags & GFP_ZONEMASK);
-
+#ifdef CONFIG_ZONE_NVM
+	if (bit & __GFP_NVM)
+		bit = (__force int)___GFP_NVM_BIT;
+#endif
 	z = (GFP_ZONE_TABLE >> (bit * GFP_ZONES_SHIFT)) &
 					 ((1 << GFP_ZONES_SHIFT) - 1);
 	VM_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7522a69..f38e4a0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -345,6 +345,9 @@ enum zone_type {
 	 */
 	ZONE_HIGHMEM,
 #endif
+#ifdef CONFIG_ZONE_NVM
+	ZONE_NVM,
+#endif
 	ZONE_MOVABLE,
 #ifdef CONFIG_ZONE_DEVICE
 	ZONE_DEVICE,
diff --git a/mm/Kconfig b/mm/Kconfig
index c782e8f..5fe1f63 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -687,6 +687,22 @@ config ZONE_DEVICE
 
 	  If FS_DAX is enabled, then say Y.
 
+config ZONE_NVM
+	bool "Manage NVDIMM (pmem) by memory management (EXPERIMENTAL)"
+	depends on NUMA && X86_64
+	depends on HAVE_MEMBLOCK_NODE_MAP
+	depends on HAVE_MEMBLOCK
+	depends on !IA32_EMULATION
+	default n
+
+	help
+	  This option allows you to use memory management subsystem to manage
+	  NVDIMM (pmem). With it mm can arrange NVDIMMs into real physical zones
+	  like NORMAL and DMA32. That means buddy system and swap can be used
+	  directly to NVDIMM zone. This feature is beneficial to recover
+	  dirty pages from power fail or system crash by storing write cache
+	  to NVDIMM zone.
+
 config ARCH_HAS_HMM
 	bool
 	default y
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 266c065..d8bd20d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -228,6 +228,9 @@ bool pm_suspended_storage(void)
 	 "DMA32",
 #endif
 	 "Normal",
+#ifdef CONFIG_ZONE_NVM
+	 "NVM",
+#endif
 #ifdef CONFIG_HIGHMEM
 	 "HighMem",
 #endif
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
