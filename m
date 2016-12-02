Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B1CF81F5C
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:22:28 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 8/8 linux-next] mm: use SECTION_MASK where possible
Date: Fri,  2 Dec 2016 20:22:20 +0100
Message-Id: <1480706540-21323-1-git-send-email-fabf@skynet.be>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/memremap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index 1bb5eec..8ebf9dd 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -198,7 +198,7 @@ static void pgmap_radix_release(struct resource *res)
 {
 	resource_size_t key, align_start, align_size, align_end;
 
-	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_start = res->start & SECTION_MASK;
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	align_end = align_start + align_size - 1;
 
@@ -244,7 +244,7 @@ static void devm_memremap_pages_release(struct device *dev, void *data)
 	}
 
 	/* pages are dead and unused, undo the arch mapping */
-	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_start = res->start & SECTION_MASK;
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	arch_remove_memory(align_start, align_size);
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
@@ -289,7 +289,7 @@ void *devm_memremap_pages(struct device *dev, struct resource *res,
 	int error, nid, is_ram;
 	unsigned long pfn;
 
-	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_start = res->start & SECTION_MASK;
 	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
 		- align_start;
 	is_ram = region_intersects(align_start, align_size,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
