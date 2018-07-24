Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com
 [192.185.51.228])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04FC6210C1251
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 06:40:09 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
 by gateway24.websitewelcome.com (Postfix) with ESMTP id A89369F615B
 for <linux-nvdimm@lists.01.org>;
 Tue, 24 Jul 2018 08:40:07 -0500 (CDT)
Date: Tue, 24 Jul 2018 08:40:06 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] libnvdimm: fix NULL pointer dereference
Message-ID: <20180724134006.GA2775@embeddedor.com>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Keith Busch <keith.busch@intel.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <zwisler@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ndd is being dereferenced before it is null checked, hence there is a
potential null pointer dereference.

Fix this by moving the pointer dereference after ndd has been properly
null checked at line 554: if (!ndd)

Addresses-Coverity-ID: 1472020 ("Dereference before null check")
Fixes: 42218e643bd2 ("libnvdimm: Use max contiguous area for namespace size")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/nvdimm/dimm_devs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 9e977cb..1dc3125 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -546,7 +546,7 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
 					   struct nd_mapping *nd_mapping)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+	struct nvdimm_bus *nvdimm_bus;
 	resource_size_t max = 0;
 	struct resource *res;
 
@@ -554,6 +554,8 @@ resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
 	if (!ndd)
 		return 0;
 
+	nvdimm_bus = walk_to_nvdimm_bus(ndd->dev);
+
 	if (reserve_free_pmem(nvdimm_bus, nd_mapping))
 		return 0;
 	for_each_dpa_resource(ndd, res) {
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
