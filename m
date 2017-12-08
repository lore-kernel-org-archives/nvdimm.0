Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 248AA21B0284B
 for <linux-nvdimm@lists.01.org>; Thu,  7 Dec 2017 19:19:36 -0800 (PST)
Subject: [PATCH] libnvdimm,
 dax: fix 1GB-aligned namespaces vs physical misalignment
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 07 Dec 2017 19:15:55 -0800
Message-ID: <151270295560.20101.17643775623938598123.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jane Chu <jane.chu@oracle.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The following namespace configuration attempt:

    # ndctl create-namespace -e namespace0.0 -m devdax -a 1G -f
    libndctl: ndctl_dax_enable: dax0.1: failed to enable
      Error: namespace0.0: failed to enable

    failed to reconfigure namespace: No such device or address

...fails when the backing memory range is not physically aligned to 1G:

    # cat /proc/iomem | grep Persistent
    210000000-30fffffff : Persistent Memory (legacy)

In the above example the 4G persistent memory range starts and ends on a
256MB boundary.

We handle this case correctly when needing to handle cases that violate
section alignment (128MB) collisions against "System RAM", and we simply
need to extend that padding/truncation for the 1GB alignment use case.

Cc: <stable@vger.kernel.org>
Fixes: 315c562536c4 ("libnvdimm, pfn: add 'align' attribute...")
Reported-and-tested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 65cc171c721d..5ba9ab7af736 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -582,6 +582,12 @@ static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
 	return altmap;
 }
 
+static u64 phys_pmem_align_down(struct nd_pfn *nd_pfn, u64 phys)
+{
+	return min_t(u64, PHYS_SECTION_ALIGN_DOWN(phys),
+			ALIGN_DOWN(phys, nd_pfn->align));
+}
+
 static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
 	u32 dax_label_reserve = is_nd_dax(&nd_pfn->dev) ? SZ_128K : 0;
@@ -637,13 +643,16 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	start = nsio->res.start;
 	size = PHYS_SECTION_ALIGN_UP(start + size) - start;
 	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
-				IORES_DESC_NONE) == REGION_MIXED) {
+				IORES_DESC_NONE) == REGION_MIXED
+			|| !IS_ALIGNED(start + resource_size(&nsio->res),
+				nd_pfn->align)) {
 		size = resource_size(&nsio->res);
-		end_trunc = start + size - PHYS_SECTION_ALIGN_DOWN(start + size);
+		end_trunc = start + size - phys_pmem_align_down(nd_pfn,
+				start + size);
 	}
 
 	if (start_pad + end_trunc)
-		dev_info(&nd_pfn->dev, "%s section collision, truncate %d bytes\n",
+		dev_info(&nd_pfn->dev, "%s alignment collision, truncate %d bytes\n",
 				dev_name(&ndns->dev), start_pad + end_trunc);
 
 	/*

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
