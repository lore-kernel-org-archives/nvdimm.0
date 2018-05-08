Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta8.messagelabs.com (mail1.bemta8.messagelabs.com
 [216.82.243.201])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DDDE203BBB91
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 19:33:08 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: [External]  [RFC PATCH v1 2/6] mm/page_alloc.c: get pfn range with
 flags of memblock
Date: Tue, 8 May 2018 02:32:47 +0000
Message-ID: <HK2PR03MB1684A17E526A6E93444D871E929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-3-git-send-email-yehs1@lenovo.com>
In-Reply-To: <1525746628-114136-3-git-send-email-yehs1@lenovo.com>
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

This is used to expand the interface of get_pfn_range_for_nid with
flags of memblock, so mm can get pfn range with special flags.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 include/linux/mm.h |  4 ++++
 mm/page_alloc.c    | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ad06d42..8abf9c9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2046,6 +2046,10 @@ extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
+extern void get_pfn_range_for_nid_with_flags(unsigned int nid,
+					     unsigned long *start_pfn,
+					     unsigned long *end_pfn,
+					     unsigned long flags);
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1741dd2..266c065 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5705,13 +5705,28 @@ void __init sparse_memory_present_with_active_regions(int nid)
 void __meminit get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn)
 {
+	get_pfn_range_for_nid_with_flags(nid, start_pfn, end_pfn,
+					 MEMBLOCK_MAX_TYPE);
+}
+
+/*
+ * If MAX_NUMNODES, includes all node memmory regions.
+ * If MEMBLOCK_MAX_TYPE, includes all memory regions with or without Flags.
+ */
+
+void __meminit get_pfn_range_for_nid_with_flags(unsigned int nid,
+						unsigned long *start_pfn,
+						unsigned long *end_pfn,
+						unsigned long flags)
+{
 	unsigned long this_start_pfn, this_end_pfn;
 	int i;
 
 	*start_pfn = -1UL;
 	*end_pfn = 0;
 
-	for_each_mem_pfn_range(i, nid, &this_start_pfn, &this_end_pfn, NULL) {
+	for_each_mem_pfn_range_with_flags(i, nid, &this_start_pfn,
+					  &this_end_pfn, NULL, flags) {
 		*start_pfn = min(*start_pfn, this_start_pfn);
 		*end_pfn = max(*end_pfn, this_end_pfn);
 	}
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
