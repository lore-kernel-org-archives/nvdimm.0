Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69E5B212741F1
 for <linux-nvdimm@lists.01.org>; Mon, 13 May 2019 19:55:21 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH] mm/nvdimm: Use correct alignment when looking at first pfn
 from a region
Date: Tue, 14 May 2019 08:25:12 +0530
Message-Id: <20190514025512.9670-1-aneesh.kumar@linux.ibm.com>
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
To: dan.j.williams@intel.com
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

We already add the start_pad to the resource->start but fails to section
align the start. This make sure with altmap we compute the right first
pfn when start_pad is zero and we are doing an align down of start address.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 kernel/memremap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/memremap.c b/kernel/memremap.c
index a856cb5ff192..23d77b60e728 100644
--- a/kernel/memremap.c
+++ b/kernel/memremap.c
@@ -59,9 +59,9 @@ static unsigned long pfn_first(struct dev_pagemap *pgmap)
 {
 	const struct resource *res = &pgmap->res;
 	struct vmem_altmap *altmap = &pgmap->altmap;
-	unsigned long pfn;
+	unsigned long pfn = PHYS_PFN(res->start);
 
-	pfn = res->start >> PAGE_SHIFT;
+	pfn = SECTION_ALIGN_DOWN(pfn);
 	if (pgmap->altmap_valid)
 		pfn += vmem_altmap_offset(altmap);
 	return pfn;
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
