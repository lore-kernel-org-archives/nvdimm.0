Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B6ED2095C3C9
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:05 -0700 (PDT)
Received: by mail-pg0-x242.google.com with SMTP id o123so688765pga.1
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 10:43:05 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH 4/9] powerpc/mm: Reshuffle vmemmap_free()
Date: Wed, 12 Apr 2017 03:42:28 +1000
Message-Id: <20170411174233.21902-5-oohall@gmail.com>
In-Reply-To: <20170411174233.21902-1-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: bsingharora@gmail.com, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Removes an indentation level and shuffles some code around to make the
following patch cleaner. No functional changes.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
---
 arch/powerpc/mm/init_64.c | 47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index ec84b31c6c86..f8124edb6ffa 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -234,12 +234,15 @@ static unsigned long vmemmap_list_free(unsigned long start)
 void __ref vmemmap_free(unsigned long start, unsigned long end)
 {
 	unsigned long page_size = 1 << mmu_psize_defs[mmu_vmemmap_psize].shift;
+	unsigned long page_order = get_order(page_size);
 
 	start = _ALIGN_DOWN(start, page_size);
 
 	pr_debug("vmemmap_free %lx...%lx\n", start, end);
 
 	for (; start < end; start += page_size) {
+		struct page *page = pfn_to_page(addr >> PAGE_SHIFT);
+		unsigned int nr_pages;
 		unsigned long addr;
 
 		/*
@@ -251,29 +254,29 @@ void __ref vmemmap_free(unsigned long start, unsigned long end)
 			continue;
 
 		addr = vmemmap_list_free(start);
-		if (addr) {
-			struct page *page = pfn_to_page(addr >> PAGE_SHIFT);
-
-			if (PageReserved(page)) {
-				/* allocated from bootmem */
-				if (page_size < PAGE_SIZE) {
-					/*
-					 * this shouldn't happen, but if it is
-					 * the case, leave the memory there
-					 */
-					WARN_ON_ONCE(1);
-				} else {
-					unsigned int nr_pages =
-						1 << get_order(page_size);
-					while (nr_pages--)
-						free_reserved_page(page++);
-				}
-			} else
-				free_pages((unsigned long)(__va(addr)),
-							get_order(page_size));
-
-			vmemmap_remove_mapping(start, page_size);
+		if (!addr)
+			continue;
+
+		page = pfn_to_page(addr >> PAGE_SHIFT);
+		nr_pages = 1 << page_order;
+
+		if (PageReserved(page)) {
+			/* allocated from bootmem */
+			if (page_size < PAGE_SIZE) {
+				/*
+				 * this shouldn't happen, but if it is
+				 * the case, leave the memory there
+				 */
+				WARN_ON_ONCE(1);
+			} else {
+				while (nr_pages--)
+					free_reserved_page(page++);
+			}
+		} else {
+			free_pages((unsigned long)(__va(addr)), page_order);
 		}
+
+		vmemmap_remove_mapping(start, page_size);
 	}
 }
 #endif
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
