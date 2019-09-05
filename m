From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH v9 1/7] libnvdimm/region: Rewrite _probe_success() to
 _advance_seeds()
Date: Thu,  5 Sep 2019 21:15:57 +0530
Message-ID: <20190905154603.10349-2-aneesh.kumar@linux.ibm.com>
References: <20190905154603.10349-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190905154603.10349-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The nd_region_probe_success() helper collides seed management with
nvdimm->busy tracking. Given the 'busy' increment is handled internal to the
nd_region driver 'probe' path move the decrement to the 'remove' path.
With that cleanup the routine can be renamed to the more descriptive
nd_region_advance_seeds().

The change is prompted by an incoming need to optionally advance the
seeds on other events besides 'probe' success.

Cc: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 drivers/nvdimm/bus.c            |  7 +---
 drivers/nvdimm/namespace_devs.c | 34 ++++++++++++++---
 drivers/nvdimm/nd-core.h        |  3 +-
 drivers/nvdimm/region_devs.c    | 68 +++++----------------------------
 4 files changed, 41 insertions(+), 71 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 798c5c4aea9c..9b64e68a20b8 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -95,10 +95,8 @@ static int nvdimm_bus_probe(struct device *dev)
 	rc = nd_drv->probe(dev);
 	debug_nvdimm_unlock(dev);
 
-	if (rc == 0)
-		nd_region_probe_success(nvdimm_bus, dev);
-	else
-		nd_region_disable(nvdimm_bus, dev);
+	if (rc == 0 && dev->parent && is_nd_region(dev->parent))
+		nd_region_advance_seeds(to_nd_region(dev->parent), dev);
 	nvdimm_bus_probe_end(nvdimm_bus);
 
 	dev_dbg(&nvdimm_bus->dev, "END: %s.probe(%s) = %d\n", dev->driver->name,
@@ -121,7 +119,6 @@ static int nvdimm_bus_remove(struct device *dev)
 		rc = nd_drv->remove(dev);
 		debug_nvdimm_unlock(dev);
 	}
-	nd_region_disable(nvdimm_bus, dev);
 
 	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index a16e52251a30..3be81f7b9ed3 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2462,6 +2462,27 @@ static struct device **create_namespaces(struct nd_region *nd_region)
 	return devs;
 }
 
+static void deactivate_labels(void *region)
+{
+	struct nd_region *nd_region = region;
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = nd_mapping->ndd;
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		mutex_lock(&nd_mapping->lock);
+		nd_mapping_free_labels(nd_mapping);
+		mutex_unlock(&nd_mapping->lock);
+
+		put_ndd(ndd);
+		nd_mapping->ndd = NULL;
+		if (ndd)
+			atomic_dec(&nvdimm->busy);
+	}
+}
+
 static int init_active_labels(struct nd_region *nd_region)
 {
 	int i;
@@ -2519,16 +2540,17 @@ static int init_active_labels(struct nd_region *nd_region)
 			mutex_unlock(&nd_mapping->lock);
 		}
 
-		if (j >= count)
-			continue;
+		if (j < count)
+			break;
+	}
 
-		mutex_lock(&nd_mapping->lock);
-		nd_mapping_free_labels(nd_mapping);
-		mutex_unlock(&nd_mapping->lock);
+	if (i < nd_region->ndr_mappings) {
+		deactivate_labels(nd_region);
 		return -ENOMEM;
 	}
 
-	return 0;
+	return devm_add_action_or_reset(&nd_region->dev, deactivate_labels,
+			nd_region);
 }
 
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 0ac52b6eb00e..945658cc32ec 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -128,13 +128,12 @@ int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
 void nd_region_devs_exit(void);
-void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
+void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev);
 void nd_region_create_ns_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
 void nd_region_create_pfn_seed(struct nd_region *nd_region);
 void nd_region_create_dax_seed(struct nd_region *nd_region);
-void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index af30cbe7a8ea..57de49b79d7d 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -715,85 +715,37 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
 }
 
 /*
- * Upon successful probe/remove, take/release a reference on the
- * associated interleave set (if present), and plant new btt + namespace
- * seeds.  Also, on the removal of a BLK region, notify the provider to
- * disable the region.
+ * When a namespace is activated create new seeds for the next
+ * namespace, or namespace-personality to be configured.
  */
-static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
-		struct device *dev, bool probe)
+void nd_region_advance_seeds(struct nd_region *nd_region, struct device *dev)
 {
-	struct nd_region *nd_region;
-
-	if (!probe && is_nd_region(dev)) {
-		int i;
-
-		nd_region = to_nd_region(dev);
-		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-			struct nvdimm_drvdata *ndd = nd_mapping->ndd;
-			struct nvdimm *nvdimm = nd_mapping->nvdimm;
-
-			mutex_lock(&nd_mapping->lock);
-			nd_mapping_free_labels(nd_mapping);
-			mutex_unlock(&nd_mapping->lock);
-
-			put_ndd(ndd);
-			nd_mapping->ndd = NULL;
-			if (ndd)
-				atomic_dec(&nvdimm->busy);
-		}
-	}
-	if (dev->parent && is_nd_region(dev->parent) && probe) {
-		nd_region = to_nd_region(dev->parent);
-		nvdimm_bus_lock(dev);
-		if (nd_region->ns_seed == dev)
-			nd_region_create_ns_seed(nd_region);
-		nvdimm_bus_unlock(dev);
-	}
-	if (is_nd_btt(dev) && probe) {
+	nvdimm_bus_lock(dev);
+	if (nd_region->ns_seed == dev) {
+		nd_region_create_ns_seed(nd_region);
+	} else if (is_nd_btt(dev)) {
 		struct nd_btt *nd_btt = to_nd_btt(dev);
 
-		nd_region = to_nd_region(dev->parent);
-		nvdimm_bus_lock(dev);
 		if (nd_region->btt_seed == dev)
 			nd_region_create_btt_seed(nd_region);
 		if (nd_region->ns_seed == &nd_btt->ndns->dev)
 			nd_region_create_ns_seed(nd_region);
-		nvdimm_bus_unlock(dev);
-	}
-	if (is_nd_pfn(dev) && probe) {
+	} else if (is_nd_pfn(dev)) {
 		struct nd_pfn *nd_pfn = to_nd_pfn(dev);
 
-		nd_region = to_nd_region(dev->parent);
-		nvdimm_bus_lock(dev);
 		if (nd_region->pfn_seed == dev)
 			nd_region_create_pfn_seed(nd_region);
 		if (nd_region->ns_seed == &nd_pfn->ndns->dev)
 			nd_region_create_ns_seed(nd_region);
-		nvdimm_bus_unlock(dev);
-	}
-	if (is_nd_dax(dev) && probe) {
+	} else if (is_nd_dax(dev)) {
 		struct nd_dax *nd_dax = to_nd_dax(dev);
 
-		nd_region = to_nd_region(dev->parent);
-		nvdimm_bus_lock(dev);
 		if (nd_region->dax_seed == dev)
 			nd_region_create_dax_seed(nd_region);
 		if (nd_region->ns_seed == &nd_dax->nd_pfn.ndns->dev)
 			nd_region_create_ns_seed(nd_region);
-		nvdimm_bus_unlock(dev);
 	}
-}
-
-void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)
-{
-	nd_region_notify_driver_action(nvdimm_bus, dev, true);
-}
-
-void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev)
-{
-	nd_region_notify_driver_action(nvdimm_bus, dev, false);
+	nvdimm_bus_unlock(dev);
 }
 
 static ssize_t mappingN(struct device *dev, char *buf, int n)
-- 
2.21.0
