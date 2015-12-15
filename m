Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 5/9] libnvdimm, pfn: fix pfn seed creation
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:14:55 -0800
Message-ID: <20151215021455.37090.36504.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Similar to btt, plant a new pfn seed when the existing one is activated.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   12 ++++++++++++
 drivers/nvdimm/nd-core.h        |    1 +
 drivers/nvdimm/region_devs.c    |    7 +++++++
 3 files changed, 20 insertions(+)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index f981177524a1..ea8dd0cb28ca 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1707,6 +1707,18 @@ void nd_region_create_blk_seed(struct nd_region *nd_region)
 		nd_device_register(nd_region->ns_seed);
 }
 
+void nd_region_create_pfn_seed(struct nd_region *nd_region)
+{
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+	nd_region->pfn_seed = nd_pfn_create(nd_region);
+	/*
+	 * Seed creation failures are not fatal, provisioning is simply
+	 * disabled until memory becomes available
+	 */
+	if (!nd_region->pfn_seed)
+		dev_err(&nd_region->dev, "failed to create pfn namespace\n");
+}
+
 void nd_region_create_btt_seed(struct nd_region *nd_region)
 {
 	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 159aed532042..3249c498892a 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -52,6 +52,7 @@ void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
 void nd_region_create_blk_seed(struct nd_region *nd_region);
 void nd_region_create_btt_seed(struct nd_region *nd_region);
+void nd_region_create_pfn_seed(struct nd_region *nd_region);
 void nd_region_disable(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 3d730d1f25db..9c632f73915e 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -490,6 +490,13 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			nd_region_create_blk_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
+	if (is_nd_pfn(dev) && probe) {
+		nd_region = to_nd_region(dev->parent);
+		nvdimm_bus_lock(dev);
+		if (nd_region->pfn_seed == dev)
+			nd_region_create_pfn_seed(nd_region);
+		nvdimm_bus_unlock(dev);
+	}
 }
 
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)

