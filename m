Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F3E821A00AC2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 13:55:04 -0700 (PDT)
Subject: [PATCH] acpi, nfit: quiet invalid block-aperture-region warnings
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 13:50:10 -0700
Message-ID: <149876941080.10690.5544516251617645982.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This state is already visible by userspace since the BLK region will not
be enabled, and it is otherwise benign as it usually indicates that the
DIMM is not configured.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 282b8991ea83..ab141f8b5140 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -833,7 +833,7 @@ int nd_blk_region_init(struct nd_region *nd_region)
 		return 0;
 
 	if (nd_region->ndr_mappings < 1) {
-		dev_err(dev, "invalid BLK region\n");
+		dev_dbg(dev, "invalid BLK region\n");
 		return -ENXIO;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
