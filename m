Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
 [216.82.243.206])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C700203BBB98
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 19:30:40 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: RE: [External] [RFC PATCH v1 1/6] mm/memblock: Expand definition of
 flags to support NVDIMM
Date: Tue, 8 May 2018 02:30:23 +0000
Message-ID: <HK2PR03MB1684FC46E0F2F70F9EF1F6D1929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-2-git-send-email-yehs1@lenovo.com>
In-Reply-To: <1525746628-114136-2-git-send-email-yehs1@lenovo.com>
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

This patch makes mm to have capability to get special regions
from memblock.

During boot process, memblock marks NVDIMM regions with flag
MEMBLOCK_NVDIMM, also expands the interface of functions and
macros with flags.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 include/linux/memblock.h | 19 +++++++++++++++++++
 mm/memblock.c            | 46 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index f92ea77..cade5c8d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -26,6 +26,8 @@ enum {
 	MEMBLOCK_HOTPLUG	= 0x1,	/* hotpluggable region */
 	MEMBLOCK_MIRROR		= 0x2,	/* mirrored region */
 	MEMBLOCK_NOMAP		= 0x4,	/* don't add to kernel direct mapping */
+	MEMBLOCK_NVDIMM		= 0x8,	/* NVDIMM region */
+	MEMBLOCK_MAX_TYPE	= 0x10	/* all regions */
 };
 
 struct memblock_region {
@@ -89,6 +91,8 @@ bool memblock_overlaps_region(struct memblock_type *type,
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
 int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nvdimm(phys_addr_t base, phys_addr_t size);
+int memblock_clear_nvdimm(phys_addr_t base, phys_addr_t size);
 ulong choose_memblock_flags(void);
 
 /* Low level functions */
@@ -167,6 +171,11 @@ void __next_reserved_mem_region(u64 *idx, phys_addr_t *out_start,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_reserved_mem_region(&i, p_start, p_end))
 
+static inline bool memblock_is_nvdimm(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_NVDIMM;
+}
+
 static inline bool memblock_is_hotpluggable(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_HOTPLUG;
@@ -187,6 +196,11 @@ int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 			  unsigned long *out_end_pfn, int *out_nid);
+void __next_mem_pfn_range_with_flags(int *idx, int nid,
+				     unsigned long *out_start_pfn,
+				     unsigned long *out_end_pfn,
+				     int *out_nid,
+				     unsigned long flags);
 
 /**
  * for_each_mem_pfn_range - early memory pfn range iterator
@@ -201,6 +215,11 @@ void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
 #define for_each_mem_pfn_range(i, nid, p_start, p_end, p_nid)		\
 	for (i = -1, __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid); \
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
+
+#define for_each_mem_pfn_range_with_flags(i, nid, p_start, p_end, p_nid, flags) \
+	for (i = -1, __next_mem_pfn_range_with_flags(&i, nid, p_start, p_end, p_nid, flags);\
+	     i >= 0; __next_mem_pfn_range_with_flags(&i, nid, p_start, p_end, p_nid, flags))
+
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 /**
diff --git a/mm/memblock.c b/mm/memblock.c
index 48376bd..7699637 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -771,6 +771,16 @@ int __init_memblock memblock_clear_hotplug(phys_addr_t base, phys_addr_t size)
 	return memblock_setclr_flag(base, size, 0, MEMBLOCK_HOTPLUG);
 }
 
+int __init_memblock memblock_mark_nvdimm(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(base, size, 1, MEMBLOCK_NVDIMM);
+}
+
+int __init_memblock memblock_clear_nvdimm(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(base, size, 0, MEMBLOCK_NVDIMM);
+}
+
 /**
  * memblock_mark_mirror - Mark mirrored memory with flag MEMBLOCK_MIRROR.
  * @base: the base phys addr of the region
@@ -891,6 +901,10 @@ void __init_memblock __next_mem_range(u64 *idx, int nid, ulong flags,
 		if (nid != NUMA_NO_NODE && nid != m_nid)
 			continue;
 
+		/* skip nvdimm memory regions if needed */
+		if (!(flags & MEMBLOCK_NVDIMM) && memblock_is_nvdimm(m))
+			continue;
+
 		/* skip hotpluggable memory regions if needed */
 		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
 			continue;
@@ -1007,6 +1021,10 @@ void __init_memblock __next_mem_range_rev(u64 *idx, int nid, ulong flags,
 		if (nid != NUMA_NO_NODE && nid != m_nid)
 			continue;
 
+		/* skip nvdimm memory regions if needed */
+		if (!(flags & MEMBLOCK_NVDIMM) && memblock_is_nvdimm(m))
+			continue;
+
 		/* skip hotpluggable memory regions if needed */
 		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
 			continue;
@@ -1070,12 +1088,9 @@ void __init_memblock __next_mem_range_rev(u64 *idx, int nid, ulong flags,
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-/*
- * Common iterator interface used to define for_each_mem_range().
- */
-void __init_memblock __next_mem_pfn_range(int *idx, int nid,
+void __init_memblock __next_mem_pfn_range_with_flags(int *idx, int nid,
 				unsigned long *out_start_pfn,
-				unsigned long *out_end_pfn, int *out_nid)
+				unsigned long *out_end_pfn, int *out_nid, unsigned long flags)
 {
 	struct memblock_type *type = &memblock.memory;
 	struct memblock_region *r;
@@ -1085,6 +1100,16 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
 
 		if (PFN_UP(r->base) >= PFN_DOWN(r->base + r->size))
 			continue;
+
+		/*
+		 *  Use "flags & r->flags " to find region with multi-flags
+		 *  Use "flags == r->flags" to include region flags of MEMBLOCK_NONE
+		 *  Set flags = MEMBLOCK_MAX_TYPE to ignore to check flags
+		 */
+
+		if ((flags != MEMBLOCK_MAX_TYPE) && (flags != r->flags) && !(flags & r->flags))
+			continue;
+
 		if (nid == MAX_NUMNODES || nid == r->nid)
 			break;
 	}
@@ -1101,6 +1126,17 @@ void __init_memblock __next_mem_pfn_range(int *idx, int nid,
 		*out_nid = r->nid;
 }
 
+/*
+ * Common iterator interface used to define for_each_mem_range().
+ */
+void __init_memblock __next_mem_pfn_range(int *idx, int nid,
+				unsigned long *out_start_pfn,
+				unsigned long *out_end_pfn, int *out_nid)
+{
+	__next_mem_pfn_range_with_flags(idx, nid, out_start_pfn, out_end_pfn,
+						out_nid, MEMBLOCK_MAX_TYPE);
+}
+
 /**
  * memblock_set_node - set node ID on memblock regions
  * @base: base of area to set node ID for
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
