Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x244.google.com (mail-pf0-x244.google.com
 [IPv6:2607:f8b0:400e:c00::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ABA4F1A1E0A
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 03:22:24 -0700 (PDT)
Received: by mail-pf0-x244.google.com with SMTP id n24so7080578pfb.3
 for <linux-nvdimm@lists.01.org>; Mon, 19 Sep 2016 03:22:24 -0700 (PDT)
From: Oliver O'Halloran <oohall@gmail.com>
Subject: [PATCH] nvdimm: fix PHYS_PFN/PFN_PHYS mixup
Date: Mon, 19 Sep 2016 20:19:00 +1000
Message-Id: <1474280340-6394-1-git-send-email-oohall@gmail.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

nd_activate_region() iomaps any hint addresses required when activating
a region. To prevent duplicate mappings it checks the PFN of the hint to
be mapped against the PFNs of the already mapped hints. Unfortunately it
doesn't convert the PFN back into a physical address before passing it
to devm_nvdimm_ioremap(). Instead it applies PHYS_PFN a second time
which ends about as well as you would imagine.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region_devs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e8d5ba7b29af..4eef88eb5144 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -57,7 +57,7 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 					ndrd->flush_wpq[dimm][j] & PAGE_MASK);
 		else
 			flush_page = devm_nvdimm_ioremap(dev,
-					PHYS_PFN(pfn), PAGE_SIZE);
+					PFN_PHYS(pfn), PAGE_SIZE);
 		if (!flush_page)
 			return -ENXIO;
 		ndrd->flush_wpq[dimm][i] = flush_page
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
