Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24BDC1A1ECF
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:58 -0700 (PDT)
Subject: [PATCH 14/14] libnvdimm,
 namespace: allow creation of multiple pmem-namespaces per region
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:55 -0700
Message-ID: <147585839519.22349.12795050693441093936.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to BLK regions, publish new seed namespace devices to allow
unused PMEM region capacity to be consumed by additional namespaces.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   48 +++++++++++++++++++++++++++++++++++++--
 drivers/nvdimm/nd-core.h        |    2 +-
 drivers/nvdimm/region_devs.c    |   18 +++++++++++----
 3 files changed, 59 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index fa51d751ccf7..3509cff68ef9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1860,16 +1860,58 @@ static struct device *nd_namespace_blk_create(struct nd_region *nd_region)
 	return &nsblk->common.dev;
 }
 
-void nd_region_create_blk_seed(struct nd_region *nd_region)
+static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
+{
+	struct nd_namespace_pmem *nspm;
+	struct resource *res;
+	struct device *dev;
+
+	if (!is_nd_pmem(&nd_region->dev))
+		return NULL;
+
+	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
+	if (!nspm)
+		return NULL;
+
+	dev = &nspm->nsio.common.dev;
+	dev->type = &namespace_pmem_device_type;
+	dev->parent = &nd_region->dev;
+	res = &nspm->nsio.res;
+	res->name = dev_name(&nd_region->dev);
+	res->flags = IORESOURCE_MEM;
+
+	nspm->id = ida_simple_get(&nd_region->ns_ida, 0, 0, GFP_KERNEL);
+	if (nspm->id < 0) {
+		kfree(nspm);
+		return NULL;
+	}
+	dev_set_name(dev, "namespace%d.%d", nd_region->id, nspm->id);
+	dev->parent = &nd_region->dev;
+	dev->groups = nd_namespace_attribute_groups;
+	nd_namespace_pmem_set_resource(nd_region, nspm, 0);
+
+	return dev;
+}
+
+void nd_region_create_ns_seed(struct nd_region *nd_region)
 {
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
-	nd_region->ns_seed = nd_namespace_blk_create(nd_region);
+
+	if (nd_region_to_nstype(nd_region) == ND_DEVICE_NAMESPACE_IO)
+		return;
+
+	if (is_nd_blk(&nd_region->dev))
+		nd_region->ns_seed = nd_namespace_blk_create(nd_region);
+	else
+		nd_region->ns_seed = nd_namespace_pmem_create(nd_region);
+
 	/*
 	 * Seed creation failures are not fatal, provisioning is simply
 	 * disabled until memory becomes available
 	 */
 	if (!nd_region->ns_seed)
-		dev_err(&nd_region->dev, "failed to create blk namespace\n");
+		dev_err(&nd_region->dev, "failed to create %s namespace\n",
+				is_nd_blk(&nd_region->dev) ? "blk" : "pmem");
 	else
 		nd_device_register(nd_region->ns_seed);
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 3ba0b96ce7de..8623e57c2ce3 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -71,7 +71,7 @@ void nvdimm_devs_exit(void);
 void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
-void nd_region_create_blk_seed(struct nd_region *nd_region);
+void nd_region_create_ns_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
 void nd_region_create_pfn_seed(struct nd_region *nd_region);
 void nd_region_create_dax_seed(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 3ac534aec60c..4f74e009b135 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -530,11 +530,12 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 		if (is_nd_pmem(dev))
 			return;
 	}
-	if (dev->parent && is_nd_blk(dev->parent) && probe) {
+	if (dev->parent && (is_nd_blk(dev->parent) || is_nd_pmem(dev->parent))
+			&& probe) {
 		nd_region = to_nd_region(dev->parent);
 		nvdimm_bus_lock(dev);
 		if (nd_region->ns_seed == dev)
-			nd_region_create_blk_seed(nd_region);
+			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
 	if (is_nd_btt(dev) && probe) {
@@ -544,23 +545,30 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 		nvdimm_bus_lock(dev);
 		if (nd_region->btt_seed == dev)
 			nd_region_create_btt_seed(nd_region);
-		if (nd_region->ns_seed == &nd_btt->ndns->dev &&
-				is_nd_blk(dev->parent))
-			nd_region_create_blk_seed(nd_region);
+		if (nd_region->ns_seed == &nd_btt->ndns->dev)
+			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
 	if (is_nd_pfn(dev) && probe) {
+		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
+
 		nd_region = to_nd_region(dev->parent);
 		nvdimm_bus_lock(dev);
 		if (nd_region->pfn_seed == dev)
 			nd_region_create_pfn_seed(nd_region);
+		if (nd_region->ns_seed == &nd_pfn->ndns->dev)
+			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
 	if (is_nd_dax(dev) && probe) {
+		struct nd_dax *nd_dax = to_nd_dax(dev);
+
 		nd_region = to_nd_region(dev->parent);
 		nvdimm_bus_lock(dev);
 		if (nd_region->dax_seed == dev)
 			nd_region_create_dax_seed(nd_region);
+		if (nd_region->ns_seed == &nd_dax->nd_pfn.ndns->dev)
+			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
