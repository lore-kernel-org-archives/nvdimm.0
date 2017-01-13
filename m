Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D8B081C2E
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jan 2017 17:54:52 -0800 (PST)
Subject: [PATCH] libnvdimm, namespace: fix pmem namespace leak,
 delete when size set to zero
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Jan 2017 17:50:45 -0800
Message-ID: <148427224588.7792.6051599203953803121.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple
pmem-namespaces per region") added support for establishing additional
pmem namespace beyond the seed device, similar to blk namespaces.
However, it neglected to delete the namespace when the size is set to
zero.

Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pmem-namespaces per region")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 6307088b375f..a518cb1b59d4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -957,6 +957,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 {
 	resource_size_t allocated = 0, available = 0;
 	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_namespace_common *ndns = to_ndns(dev);
 	struct nd_mapping *nd_mapping;
 	struct nvdimm_drvdata *ndd;
 	struct nd_label_id label_id;
@@ -964,7 +965,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 	u8 *uuid = NULL;
 	int rc, i;
 
-	if (dev->driver || to_ndns(dev)->claim)
+	if (dev->driver || ndns->claim)
 		return -EBUSY;
 
 	if (is_namespace_pmem(dev)) {
@@ -1034,20 +1035,16 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		nd_namespace_pmem_set_resource(nd_region, nspm,
 				val * nd_region->ndr_mappings);
-	} else if (is_namespace_blk(dev)) {
-		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
-
-		/*
-		 * Try to delete the namespace if we deleted all of its
-		 * allocation, this is not the seed device for the
-		 * region, and it is not actively claimed by a btt
-		 * instance.
-		 */
-		if (val == 0 && nd_region->ns_seed != dev
-				&& !nsblk->common.claim)
-			nd_device_unregister(dev, ND_ASYNC);
 	}
 
+	/*
+	 * Try to delete the namespace if we deleted all of its
+	 * allocation, this is not the seed device for the region, and
+	 * it is not actively claimed by a btt instance.
+	 */
+	if (val == 0 && nd_region->ns_seed != dev && !ndns->claim)
+		nd_device_unregister(dev, ND_ASYNC);
+
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
