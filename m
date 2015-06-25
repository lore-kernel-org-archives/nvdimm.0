Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Subject: [PATCH v2 15/17] libnvdimm: Set numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:38 -0400
Message-ID: <20150625093738.40066.88750.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hp.com>

ACPI NFIT table has System Physical Address Range Structure entries that
describe a proximity ID of each range when ACPI_NFIT_PROXIMITY_VALID is
set in the flags.

Change acpi_nfit_register_region() to map a proximity ID to its node ID,
and set it to a new numa_node field of nd_region_desc, which is then
conveyed to the nd_region device.

The device core arranges for btt and namespace devices to inherit their
node from their parent region.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
[djbw: move set_dev_node() from region 'probe' to 'create']
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |    6 ++++++
 drivers/nvdimm/region_devs.c |    4 +++-
 include/linux/libnvdimm.h    |    1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 1f6f1b1a54f4..d96c8fe974dd 100644
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
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 8f8c7ea485f1..b2ec5045f5a5 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -738,13 +738,15 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	nd_region->ro = ro;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
+	device_initialize(dev);
 	dev_set_name(dev, "region%d", nd_region->id);
 	dev->parent = &nvdimm_bus->dev;
 	dev->type = dev_type;
 	dev->groups = ndr_desc->attr_groups;
+	set_dev_node(dev, ndr_desc->numa_node);
 	nd_region->ndr_size = resource_size(ndr_desc->res);
 	nd_region->ndr_start = ndr_desc->res->start;
-	nd_device_register(dev);
+	__nd_device_register(dev);
 
 	return nd_region;
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index dc799a29ed1a..30b3deaafd51 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -89,6 +89,7 @@ struct nd_region_desc {
 	struct nd_interleave_set *nd_set;
 	void *provider_data;
 	int num_lanes;
+	int numa_node;
 };
 
 struct nvdimm_bus;

