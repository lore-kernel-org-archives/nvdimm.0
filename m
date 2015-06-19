Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v3 2/3] libnvdimm: Set numa_node to NVDIMM devices
Date: Fri, 19 Jun 2015 12:18:33 -0600
Message-Id: <1434737914-18466-3-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1434737914-18466-1-git-send-email-toshi.kani@hp.com>
References: <1434737914-18466-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

ACPI NFIT table has System Physical Address Range Structure
entries that describe a proximity ID of each range when
ACPI_NFIT_PROXIMITY_VALID is set in the flags.

Change acpi_nfit_register_region() to map a proximity ID to its
node ID, and set it to a new numa_node field of nd_region_desc,
which is then conveyed to nd_region.

nd_region_probe() and nd_btt_probe() set the numa_node of nd_region
to their device object being probed.  A namespace device inherits
the numa_node from the parent region device.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/nfit.c          |    6 ++++++
 drivers/nvdimm/btt.c         |    2 ++
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region.c      |    1 +
 drivers/nvdimm/region_devs.c |    1 +
 include/linux/libnvdimm.h    |    1 +
 6 files changed, 12 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 5f64582..5997753 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1392,6 +1392,12 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	ndr_desc->res = &res;
 	ndr_desc->provider_data = nfit_spa;
 	ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
+	if (spa->flags & ACPI_NFIT_PROXIMITY_VALID)
+		ndr_desc->numa_node = acpi_map_pxm_to_online_node(
+						spa->proximity_domain);
+	else
+		ndr_desc->numa_node = NUMA_NO_NODE;
+
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping *nd_mapping;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 57d3b27..ab082e5 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1495,6 +1495,8 @@ static int nd_btt_probe(struct device *dev)
 		rc = -ENOMEM;
 		goto err_btt;
 	}
+
+	set_dev_node(dev, nd_region->numa_node);
 	dev_set_drvdata(dev, btt);
 
 	return 0;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 011d7c5..0bfd20a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -93,6 +93,7 @@ struct nd_region {
 	u64 ndr_size;
 	u64 ndr_start;
 	int id, num_lanes;
+	int numa_node;
 	void *provider_data;
 	struct nd_interleave_set *nd_set;
 	struct nd_mapping mapping[0];
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index d9d82e7..a764ca6 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -123,6 +123,7 @@ static int nd_region_probe(struct device *dev)
 
 	num_ns->active = rc;
 	num_ns->count = rc + err;
+	set_dev_node(dev, nd_region->numa_node);
 	dev_set_drvdata(dev, num_ns);
 
 	if (err == 0)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index bb9f329..703dfae 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -632,6 +632,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
 	nd_region->num_lanes = ndr_desc->num_lanes;
+	nd_region->numa_node = ndr_desc->numa_node;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index dc799a2..30b3dea 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -89,6 +89,7 @@ struct nd_region_desc {
 	struct nd_interleave_set *nd_set;
 	void *provider_data;
 	int num_lanes;
+	int numa_node;
 };
 
 struct nvdimm_bus;
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
