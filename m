Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F7A61A1E3E
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:41:49 -0700 (PDT)
Subject: [PATCH 01/14] libnvdimm,
 region: move region-mapping input-paramters to nd_mapping_desc
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:38:46 -0700
Message-ID: <147585832654.22349.375929223700039836.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Before we add more libnvdimm-private fields to nd_mapping make it clear
which parameters are input vs libnvdimm internals. Use struct
nd_mapping_desc instead of struct nd_mapping in nd_region_desc and make
struct nd_mapping private to libnvdimm.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c     |   30 +++++++++++++++---------------
 drivers/nvdimm/nd.h          |   14 ++++++++++++++
 drivers/nvdimm/region_devs.c |   16 +++++++++-------
 include/linux/libnvdimm.h    |   25 +++++++------------------
 4 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 02838f928d7e..6490a15abdd3 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1627,9 +1627,9 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	if (!info)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
-		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
+		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
 		struct nfit_set_info_map *map = &info->mapping[i];
-		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		struct nvdimm *nvdimm = mapping->nvdimm;
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 		struct acpi_nfit_memory_map *memdev = memdev_from_spa(acpi_desc,
 				spa->range_index, i);
@@ -2053,7 +2053,7 @@ static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
 }
 
 static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
-		struct nd_mapping *nd_mapping, struct nd_region_desc *ndr_desc,
+		struct nd_mapping_desc *mapping, struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_memory_map *memdev,
 		struct nfit_spa *nfit_spa)
 {
@@ -2070,12 +2070,12 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		return -ENODEV;
 	}
 
-	nd_mapping->nvdimm = nvdimm;
+	mapping->nvdimm = nvdimm;
 	switch (nfit_spa_type(spa)) {
 	case NFIT_SPA_PM:
 	case NFIT_SPA_VOLATILE:
-		nd_mapping->start = memdev->address;
-		nd_mapping->size = memdev->region_size;
+		mapping->start = memdev->address;
+		mapping->size = memdev->region_size;
 		break;
 	case NFIT_SPA_DCR:
 		nfit_mem = nvdimm_provider_data(nvdimm);
@@ -2083,13 +2083,13 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 			dev_dbg(acpi_desc->dev, "spa%d %s missing bdw\n",
 					spa->range_index, nvdimm_name(nvdimm));
 		} else {
-			nd_mapping->size = nfit_mem->bdw->capacity;
-			nd_mapping->start = nfit_mem->bdw->start_address;
+			mapping->size = nfit_mem->bdw->capacity;
+			mapping->start = nfit_mem->bdw->start_address;
 			ndr_desc->num_lanes = nfit_mem->bdw->windows;
 			blk_valid = 1;
 		}
 
-		ndr_desc->nd_mapping = nd_mapping;
+		ndr_desc->mapping = mapping;
 		ndr_desc->num_mappings = blk_valid;
 		ndbr_desc = to_blk_region_desc(ndr_desc);
 		ndbr_desc->enable = acpi_nfit_blk_region_enable;
@@ -2115,7 +2115,7 @@ static bool nfit_spa_is_virtual(struct acpi_nfit_system_address *spa)
 static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
-	static struct nd_mapping nd_mappings[ND_MAX_MAPPINGS];
+	static struct nd_mapping_desc mappings[ND_MAX_MAPPINGS];
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
 	struct nd_blk_region_desc ndbr_desc;
 	struct nd_region_desc *ndr_desc;
@@ -2134,7 +2134,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	}
 
 	memset(&res, 0, sizeof(res));
-	memset(&nd_mappings, 0, sizeof(nd_mappings));
+	memset(&mappings, 0, sizeof(mappings));
 	memset(&ndbr_desc, 0, sizeof(ndbr_desc));
 	res.start = spa->address;
 	res.end = res.start + spa->length - 1;
@@ -2150,7 +2150,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
-		struct nd_mapping *nd_mapping;
+		struct nd_mapping_desc *mapping;
 
 		if (memdev->range_index != spa->range_index)
 			continue;
@@ -2159,14 +2159,14 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 					spa->range_index, ND_MAX_MAPPINGS);
 			return -ENXIO;
 		}
-		nd_mapping = &nd_mappings[count++];
-		rc = acpi_nfit_init_mapping(acpi_desc, nd_mapping, ndr_desc,
+		mapping = &mappings[count++];
+		rc = acpi_nfit_init_mapping(acpi_desc, mapping, ndr_desc,
 				memdev, nfit_spa);
 		if (rc)
 			goto out;
 	}
 
-	ndr_desc->nd_mapping = nd_mappings;
+	ndr_desc->mapping = mappings;
 	ndr_desc->num_mappings = count;
 	rc = acpi_nfit_init_interleave_set(acpi_desc, ndr_desc, spa);
 	if (rc)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 38d6f039234e..e58c40824e1f 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -98,6 +98,20 @@ struct nd_percpu_lane {
 	spinlock_t lock;
 };
 
+struct nd_mapping {
+	struct nvdimm *nvdimm;
+	struct nd_namespace_label **labels;
+	u64 start;
+	u64 size;
+	/*
+	 * @ndd is for private use at region enable / disable time for
+	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
+	 * conversions use to_ndd() which respects enabled state of the
+	 * nvdimm.
+	 */
+	struct nvdimm_drvdata *ndd;
+};
+
 struct nd_region {
 	struct device dev;
 	struct ida ns_ida;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e8d5ba7b29af..0ff43cbb15e3 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -755,10 +755,10 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 	int ro = 0;
 
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
-		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
-		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
+		struct nvdimm *nvdimm = mapping->nvdimm;
 
-		if ((nd_mapping->start | nd_mapping->size) % SZ_4K) {
+		if ((mapping->start | mapping->size) % SZ_4K) {
 			dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
 					caller, dev_name(&nvdimm->dev), i);
 
@@ -809,11 +809,13 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		ndl->count = 0;
 	}
 
-	memcpy(nd_region->mapping, ndr_desc->nd_mapping,
-			sizeof(struct nd_mapping) * ndr_desc->num_mappings);
 	for (i = 0; i < ndr_desc->num_mappings; i++) {
-		struct nd_mapping *nd_mapping = &ndr_desc->nd_mapping[i];
-		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
+		struct nvdimm *nvdimm = mapping->nvdimm;
+
+		nd_region->mapping[i].nvdimm = nvdimm;
+		nd_region->mapping[i].start = mapping->start;
+		nd_region->mapping[i].size = mapping->size;
 
 		get_device(&nvdimm->dev);
 	}
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 4a5f8c51f2a5..f4947fda11e7 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -50,23 +50,6 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc);
 
-struct nd_namespace_label;
-struct nvdimm_drvdata;
-
-struct nd_mapping {
-	struct nvdimm *nvdimm;
-	struct nd_namespace_label **labels;
-	u64 start;
-	u64 size;
-	/*
-	 * @ndd is for private use at region enable / disable time for
-	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
-	 * conversions use to_ndd() which respects enabled state of the
-	 * nvdimm.
-	 */
-	struct nvdimm_drvdata *ndd;
-};
-
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long cmd_mask;
@@ -89,9 +72,15 @@ struct nd_interleave_set {
 	u64 cookie;
 };
 
+struct nd_mapping_desc {
+	struct nvdimm *nvdimm;
+	u64 start;
+	u64 size;
+};
+
 struct nd_region_desc {
 	struct resource *res;
-	struct nd_mapping *nd_mapping;
+	struct nd_mapping_desc *mapping;
 	u16 num_mappings;
 	const struct attribute_group **attr_groups;
 	struct nd_interleave_set *nd_set;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
