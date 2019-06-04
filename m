Return-Path: <owner-linux-mm@kvack.org>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v3 1/6] nvdimm: Consider probe return -EOPNOTSUPP as success
Date: Tue,  4 Jun 2019 14:43:52 +0530
Message-Id: <20190604091357.32213-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

With following patches we add EOPNOTSUPP as return from probe callback to
indicate we were not able to initialize a namespace due to pfn superblock
feature/version mismatch. We want to consider this a probe success so that
we can create new namesapce seed and there by avoid marking the failed
namespace as the seed namespace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/bus.c         |  4 ++--
 drivers/nvdimm/nd-core.h     |  3 ++-
 drivers/nvdimm/region_devs.c | 19 +++++++++++++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2eb6a6cfe9e4..792b3e90453b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -100,8 +100,8 @@ static int nvdimm_bus_probe(struct device *dev)
 
 	nvdimm_bus_probe_start(nvdimm_bus);
 	rc = nd_drv->probe(dev);
-	if (rc == 0)
-		nd_region_probe_success(nvdimm_bus, dev);
+	if (rc == 0 || rc == -EOPNOTSUPP)
+		nd_region_probe_success(nvdimm_bus, dev, rc);
 	else
 		nd_region_disable(nvdimm_bus, dev);
 	nvdimm_bus_probe_end(nvdimm_bus);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index e5ffd5733540..9e67a79fb6d5 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -134,7 +134,8 @@ int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
 void nd_region_devs_exit(void);
-void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus,
+			     struct device *dev, int ret);
 struct nd_region;
 void nd_region_create_ns_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b4ef7d9ff22e..fcf3d8828540 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -723,7 +723,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
  * disable the region.
  */
 static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
-		struct device *dev, bool probe)
+					   struct device *dev, bool probe, int ret)
 {
 	struct nd_region *nd_region;
 
@@ -753,6 +753,16 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
+
+	if (dev->parent && is_nd_region(dev->parent) &&
+	    !probe && (ret == -EOPNOTSUPP)) {
+		nd_region = to_nd_region(dev->parent);
+		nvdimm_bus_lock(dev);
+		if (nd_region->ns_seed == dev)
+			nd_region_create_ns_seed(nd_region);
+		nvdimm_bus_unlock(dev);
+	}
+
 	if (is_nd_btt(dev) && probe) {
 		struct nd_btt *nd_btt = to_nd_btt(dev);
 
@@ -788,14 +798,15 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 	}
 }
 
-void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)
+void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus,
+			     struct device *dev, int ret)
 {
-	nd_region_notify_driver_action(nvdimm_bus, dev, true);
+	nd_region_notify_driver_action(nvdimm_bus, dev, true, ret);
 }
 
 void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev)
 {
-	nd_region_notify_driver_action(nvdimm_bus, dev, false);
+	nd_region_notify_driver_action(nvdimm_bus, dev, false, 0);
 }
 
 static ssize_t mappingN(struct device *dev, char *buf, int n)
-- 
2.21.0
