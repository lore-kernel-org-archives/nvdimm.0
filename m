Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta12.messagelabs.com (mail1.bemta12.messagelabs.com
 [216.82.251.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FC60203BBB91
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 19:35:32 -0700 (PDT)
From: Huaisheng HS1 Ye <yehs1@lenovo.com>
Subject: [External] [RFC PATCH v1 6/6] arch/x86/mm: create page table mapping
 for DRAM and NVDIMM both
Date: Tue, 8 May 2018 02:35:13 +0000
Message-ID: <HK2PR03MB1684101846A9D9639BE00001929A0@HK2PR03MB1684.apcprd03.prod.outlook.com>
References: <1525746628-114136-1-git-send-email-yehs1@lenovo.com>
 <1525746628-114136-7-git-send-email-yehs1@lenovo.com>
In-Reply-To: <1525746628-114136-7-git-send-email-yehs1@lenovo.com>
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

Create PTE, PMD, PUD and P4D levels page table mapping for physical
addresses of DRAM and NVDIMM both. Here E820_TYPE_PMEM represents
the region of e820_table.

Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 arch/x86/mm/init_64.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index af11a28..c03c2091 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -420,6 +420,10 @@ void __init cleanup_highmap(void)
 			if (!after_bootmem &&
 			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
 					     E820_TYPE_RAM) &&
+#ifdef CONFIG_ZONE_NVM
+			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
+					     E820_TYPE_PMEM) &&
+#endif
 			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
 					     E820_TYPE_RESERVED_KERN))
 				set_pte(pte, __pte(0));
@@ -475,6 +479,10 @@ void __init cleanup_highmap(void)
 			if (!after_bootmem &&
 			    !e820__mapped_any(paddr & PMD_MASK, paddr_next,
 					     E820_TYPE_RAM) &&
+#ifdef CONFIG_ZONE_NVM
+			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
+					     E820_TYPE_PMEM) &&
+#endif
 			    !e820__mapped_any(paddr & PMD_MASK, paddr_next,
 					     E820_TYPE_RESERVED_KERN))
 				set_pmd(pmd, __pmd(0));
@@ -561,6 +569,10 @@ void __init cleanup_highmap(void)
 			if (!after_bootmem &&
 			    !e820__mapped_any(paddr & PUD_MASK, paddr_next,
 					     E820_TYPE_RAM) &&
+#ifdef CONFIG_ZONE_NVM
+			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
+					     E820_TYPE_PMEM) &&
+#endif
 			    !e820__mapped_any(paddr & PUD_MASK, paddr_next,
 					     E820_TYPE_RESERVED_KERN))
 				set_pud(pud, __pud(0));
@@ -647,6 +659,10 @@ void __init cleanup_highmap(void)
 			if (!after_bootmem &&
 			    !e820__mapped_any(paddr & P4D_MASK, paddr_next,
 					     E820_TYPE_RAM) &&
+#ifdef CONFIG_ZONE_NVM
+			    !e820__mapped_any(paddr & PAGE_MASK, paddr_next,
+					     E820_TYPE_PMEM) &&
+#endif
 			    !e820__mapped_any(paddr & P4D_MASK, paddr_next,
 					     E820_TYPE_RESERVED_KERN))
 				set_p4d(p4d, __p4d(0));
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
