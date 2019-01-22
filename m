Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CFDE21962301
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 18:49:15 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 1/2] libnvdimm, pfn: use size is enough
Date: Tue, 22 Jan 2019 10:48:09 +0800
Message-Id: <20190122024810.4448-1-richardw.yang@linux.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When trying to see whether current nd_region intersects with others, we
have already calculated the *size* to be expanded to SECTION size.

So just pass size is enough.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/pfn_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index becf0bb481b3..5eca050b3660 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -686,7 +686,7 @@ static void trim_pfn_device(struct nd_pfn *nd_pfn, u32 *start_pad, u32 *end_trun
 	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
 				IORES_DESC_NONE) == REGION_MIXED
 			|| !IS_ALIGNED(end, nd_pfn->align)
-			|| nd_region_conflict(nd_region, start, size + adjust))
+			|| nd_region_conflict(nd_region, start, size))
 		*end_trunc = end - phys_pmem_align_down(nd_pfn, end);
 }
 
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
