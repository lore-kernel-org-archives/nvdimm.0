Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1875F21959CB2
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 02:17:16 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v4 1/6] nvdimm: Consider probe return -EOPNOTSUPP as success
Date: Thu, 20 Jun 2019 14:46:21 +0530
Message-Id: <20190620091626.31824-2-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190620091626.31824-1-aneesh.kumar@linux.ibm.com>
References: <20190620091626.31824-1-aneesh.kumar@linux.ibm.com>
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

This patch add -EOPNOTSUPP as return from probe callback to
indicate we were not able to initialize a namespace due to pfn superblock
feature/version mismatch. We want to consider this a probe success so that
we can create new namesapce seed and there by avoid marking the failed
namespace as the seed namespace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/bus.c         |  4 ++--
 drivers/nvdimm/nd-core.h     |  3 ++-
 drivers/nvdimm/pmem.c        | 26 ++++++++++++++++++++++----
 drivers/nvdimm/region_devs.c | 19 +++++++++++++++----
 4 files changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 2dca3034fee0..3b8ffb3966ab 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -92,8 +92,8 @@ static int nvdimm_bus_probe(struct device *dev)
 
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
index 391e88de3a29..4e6ffa0d89bb 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -126,7 +126,8 @@ int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
 void nvdimm_devs_exit(void);
 void nd_region_devs_exit(void);
-void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
+void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus,
+			     struct device *dev, int ret);
 struct nd_region;
 void nd_region_create_ns_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 24d7fe7c74ed..422b11c01301 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -497,6 +497,7 @@ static int pmem_attach_disk(struct device *dev,
 
 static int nd_pmem_probe(struct device *dev)
 {
+	int ret;
 	struct nd_namespace_common *ndns;
 
 	ndns = nvdimm_namespace_common_probe(dev);
@@ -512,12 +513,29 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return pmem_attach_disk(dev, ndns);
 
-	/* if we find a valid info-block we'll come back as that personality */
-	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
-			|| nd_dax_probe(dev, ndns) == 0)
+	ret = nd_btt_probe(dev, ndns);
+	if (ret == 0)
 		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
 
-	/* ...otherwise we're just a raw pmem device */
+	ret = nd_pfn_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+
+	ret = nd_dax_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+	/*
+	 * We have two failure conditions here, there is no
+	 * info reserver block or we found a valid info reserve block
+	 * but failed to initialize the pfn superblock.
+	 * Don't create a raw pmem disk for the second case.
+	 */
 	return pmem_attach_disk(dev, ndns);
 }
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4fed9ce9c2fe..1e74a1c9fdac 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -715,7 +715,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
  * disable the region.
  */
 static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
-		struct device *dev, bool probe)
+					   struct device *dev, bool probe, int ret)
 {
 	struct nd_region *nd_region;
 
@@ -745,6 +745,16 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
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
 
@@ -780,14 +790,15 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
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

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
