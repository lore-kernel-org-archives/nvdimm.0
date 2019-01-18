Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95344211B15B5
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 19:36:12 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH] libnvdimm,
 pfn: not allocate nd_pfn->pfn_sb if already allocated
Date: Fri, 18 Jan 2019 11:35:44 +0800
Message-Id: <20190118033544.3980-1-richardw.yang@linux.intel.com>
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

In current implementation, we might re-allocate nd_pfn->pfn_sb.

For example:

    nd_dax_probe()
        nd_pfn->pfn_sb = devm_kzalloc()

    dax_pmem_probe()
        nvdimm_setup_pfn()
            nd_pfn_init()
                nd_pfn->pfn_sb = devm_kzalloc()

This patch checks nd_pfn->pfn_sb before allocating it in nd_pfn_init().

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/pfn_devs.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 6f22272e8d80..1f4f07007483 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -687,21 +687,25 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	u32 dax_label_reserve = is_nd_dax(&nd_pfn->dev) ? SZ_128K : 0;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
+	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	resource_size_t start, size;
 	struct nd_region *nd_region;
 	u32 start_pad, end_trunc;
-	struct nd_pfn_sb *pfn_sb;
 	unsigned long npfns;
 	phys_addr_t offset;
 	const char *sig;
 	u64 checksum;
 	int rc;
 
-	pfn_sb = devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
-	if (!pfn_sb)
-		return -ENOMEM;
+	if (!pfn_sb) {
+		pfn_sb = devm_kzalloc(&nd_pfn->dev,
+				      sizeof(*pfn_sb), GFP_KERNEL);
+		if (!pfn_sb)
+			return -ENOMEM;
+
+		nd_pfn->pfn_sb = pfn_sb;
+	}
 
-	nd_pfn->pfn_sb = pfn_sb;
 	if (is_nd_dax(&nd_pfn->dev))
 		sig = DAX_SIG;
 	else
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
