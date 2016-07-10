Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 167D81A1E34
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:27:45 -0700 (PDT)
Subject: [PATCH v2 04/17] libnvdimm, nfit: remove nfit_spa_map() infrastructure
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:24:50 -0700
Message-ID: <146812109076.32932.17697397436811104559.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Now that all shared mappings are handled by devm_nvdimm_memremap() we no
longer need nfit_spa_map() nor do we need to trigger a callback to the
bus provider at region disable time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |  146 ------------------------------------------
 drivers/acpi/nfit.h          |   21 ------
 drivers/nvdimm/nd.h          |    1 
 drivers/nvdimm/region_devs.c |    3 -
 include/linux/libnvdimm.h    |    1 
 5 files changed, 172 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index b047dbe13bed..b76c95981547 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1509,126 +1509,6 @@ static int acpi_nfit_blk_region_do_io(struct nd_blk_region *ndbr,
 	return rc;
 }
 
-static void nfit_spa_mapping_release(struct kref *kref)
-{
-	struct nfit_spa_mapping *spa_map = to_spa_map(kref);
-	struct acpi_nfit_system_address *spa = spa_map->spa;
-	struct acpi_nfit_desc *acpi_desc = spa_map->acpi_desc;
-
-	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
-	dev_dbg(acpi_desc->dev, "%s: SPA%d\n", __func__, spa->range_index);
-	if (spa_map->type == SPA_MAP_APERTURE)
-		memunmap((void __force *)spa_map->addr.aperture);
-	else
-		iounmap(spa_map->addr.base);
-	release_mem_region(spa->address, spa->length);
-	list_del(&spa_map->list);
-	kfree(spa_map);
-}
-
-static struct nfit_spa_mapping *find_spa_mapping(
-		struct acpi_nfit_desc *acpi_desc,
-		struct acpi_nfit_system_address *spa)
-{
-	struct nfit_spa_mapping *spa_map;
-
-	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
-	list_for_each_entry(spa_map, &acpi_desc->spa_maps, list)
-		if (spa_map->spa == spa)
-			return spa_map;
-
-	return NULL;
-}
-
-static void nfit_spa_unmap(struct acpi_nfit_desc *acpi_desc,
-		struct acpi_nfit_system_address *spa)
-{
-	struct nfit_spa_mapping *spa_map;
-
-	mutex_lock(&acpi_desc->spa_map_mutex);
-	spa_map = find_spa_mapping(acpi_desc, spa);
-
-	if (spa_map)
-		kref_put(&spa_map->kref, nfit_spa_mapping_release);
-	mutex_unlock(&acpi_desc->spa_map_mutex);
-}
-
-static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
-		struct acpi_nfit_system_address *spa, enum spa_map_type type)
-{
-	resource_size_t start = spa->address;
-	resource_size_t n = spa->length;
-	struct nfit_spa_mapping *spa_map;
-	struct resource *res;
-
-	WARN_ON(!mutex_is_locked(&acpi_desc->spa_map_mutex));
-
-	spa_map = find_spa_mapping(acpi_desc, spa);
-	if (spa_map) {
-		kref_get(&spa_map->kref);
-		return spa_map->addr.base;
-	}
-
-	spa_map = kzalloc(sizeof(*spa_map), GFP_KERNEL);
-	if (!spa_map)
-		return NULL;
-
-	INIT_LIST_HEAD(&spa_map->list);
-	spa_map->spa = spa;
-	kref_init(&spa_map->kref);
-	spa_map->acpi_desc = acpi_desc;
-
-	res = request_mem_region(start, n, dev_name(acpi_desc->dev));
-	if (!res)
-		goto err_mem;
-
-	spa_map->type = type;
-	if (type == SPA_MAP_APERTURE)
-		spa_map->addr.aperture = (void __pmem *)memremap(start, n,
-							ARCH_MEMREMAP_PMEM);
-	else
-		spa_map->addr.base = ioremap_nocache(start, n);
-
-
-	if (!spa_map->addr.base)
-		goto err_map;
-
-	list_add_tail(&spa_map->list, &acpi_desc->spa_maps);
-	return spa_map->addr.base;
-
- err_map:
-	release_mem_region(start, n);
- err_mem:
-	kfree(spa_map);
-	return NULL;
-}
-
-/**
- * nfit_spa_map - interleave-aware managed-mappings of acpi_nfit_system_address ranges
- * @nvdimm_bus: NFIT-bus that provided the spa table entry
- * @nfit_spa: spa table to map
- * @type: aperture or control region
- *
- * In the case where block-data-window apertures and
- * dimm-control-regions are interleaved they will end up sharing a
- * single request_mem_region() + ioremap() for the address range.  In
- * the style of devm nfit_spa_map() mappings are automatically dropped
- * when all region devices referencing the same mapping are disabled /
- * unbound.
- */
-static __maybe_unused void __iomem *nfit_spa_map(
-		struct acpi_nfit_desc *acpi_desc,
-		struct acpi_nfit_system_address *spa, enum spa_map_type type)
-{
-	void __iomem *iomem;
-
-	mutex_lock(&acpi_desc->spa_map_mutex);
-	iomem = __nfit_spa_map(acpi_desc, spa, type);
-	mutex_unlock(&acpi_desc->spa_map_mutex);
-
-	return iomem;
-}
-
 static int nfit_blk_init_interleave(struct nfit_blk_mmio *mmio,
 		struct acpi_nfit_interleave *idt, u16 interleave_ways)
 {
@@ -1773,29 +1653,6 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	return 0;
 }
 
-static void acpi_nfit_blk_region_disable(struct nvdimm_bus *nvdimm_bus,
-		struct device *dev)
-{
-	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
-	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
-	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
-	struct nfit_blk *nfit_blk = nd_blk_region_provider_data(ndbr);
-	int i;
-
-	if (!nfit_blk)
-		return; /* never enabled */
-
-	/* auto-free BLK spa mappings */
-	for (i = 0; i < 2; i++) {
-		struct nfit_blk_mmio *mmio = &nfit_blk->mmio[i];
-
-		if (mmio->addr.base)
-			nfit_spa_unmap(acpi_desc, mmio->spa);
-	}
-	nd_blk_region_set_provider_data(ndbr, NULL);
-	/* devm will free nfit_blk */
-}
-
 static int ars_get_cap(struct acpi_nfit_desc *acpi_desc,
 		struct nd_cmd_ars_cap *cmd, struct nfit_spa *nfit_spa)
 {
@@ -1969,7 +1826,6 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		ndr_desc->num_mappings = blk_valid;
 		ndbr_desc = to_blk_region_desc(ndr_desc);
 		ndbr_desc->enable = acpi_nfit_blk_region_enable;
-		ndbr_desc->disable = acpi_nfit_blk_region_disable;
 		ndbr_desc->do_io = acpi_desc->blk_do_io;
 		nfit_spa->nd_region = nvdimm_blk_region_create(acpi_desc->nvdimm_bus,
 				ndr_desc);
@@ -2509,7 +2365,6 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	nd_desc->clear_to_send = acpi_nfit_clear_to_send;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
-	INIT_LIST_HEAD(&acpi_desc->spa_maps);
 	INIT_LIST_HEAD(&acpi_desc->spas);
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
 	INIT_LIST_HEAD(&acpi_desc->bdws);
@@ -2517,7 +2372,6 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	INIT_LIST_HEAD(&acpi_desc->flushes);
 	INIT_LIST_HEAD(&acpi_desc->memdevs);
 	INIT_LIST_HEAD(&acpi_desc->dimms);
-	mutex_init(&acpi_desc->spa_map_mutex);
 	mutex_init(&acpi_desc->init_mutex);
 	INIT_WORK(&acpi_desc->work, acpi_nfit_scrub);
 }
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index f06fa91c5abf..52078475d969 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -135,9 +135,7 @@ struct acpi_nfit_desc {
 	struct nvdimm_bus_descriptor nd_desc;
 	struct acpi_table_header acpi_header;
 	struct acpi_nfit_header *nfit;
-	struct mutex spa_map_mutex;
 	struct mutex init_mutex;
-	struct list_head spa_maps;
 	struct list_head memdevs;
 	struct list_head flushes;
 	struct list_head dimms;
@@ -188,25 +186,6 @@ struct nfit_blk {
 	u32 dimm_flags;
 };
 
-enum spa_map_type {
-	SPA_MAP_CONTROL,
-	SPA_MAP_APERTURE,
-};
-
-struct nfit_spa_mapping {
-	struct acpi_nfit_desc *acpi_desc;
-	struct acpi_nfit_system_address *spa;
-	struct list_head list;
-	struct kref kref;
-	enum spa_map_type type;
-	struct nd_blk_addr addr;
-};
-
-static inline struct nfit_spa_mapping *to_spa_map(struct kref *kref)
-{
-	return container_of(kref, struct nfit_spa_mapping, kref);
-}
-
 static inline struct acpi_nfit_memory_map *__to_nfit_memdev(
 		struct nfit_mem *nfit_mem)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index d0ac93c31dda..2819e886dfd2 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -119,7 +119,6 @@ struct nd_region {
 
 struct nd_blk_region {
 	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
-	void (*disable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 	void *blk_provider_data;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 40fcfea26fbb..694b21024871 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -433,8 +433,6 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 
 		if (is_nd_pmem(dev))
 			return;
-
-		to_nd_blk_region(dev)->disable(nvdimm_bus, dev);
 	}
 	if (dev->parent && is_nd_blk(dev->parent) && probe) {
 		nd_region = to_nd_region(dev->parent);
@@ -698,7 +696,6 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		if (ndbr) {
 			nd_region = &ndbr->nd_region;
 			ndbr->enable = ndbr_desc->enable;
-			ndbr->disable = ndbr_desc->disable;
 			ndbr->do_io = ndbr_desc->do_io;
 		}
 		region_buf = ndbr;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 18c3cc48a970..1050f9aa3a3e 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -114,7 +114,6 @@ struct device;
 struct nd_blk_region;
 struct nd_blk_region_desc {
 	int (*enable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
-	void (*disable)(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 	int (*do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
 			void *iobuf, u64 len, int rw);
 	struct nd_region_desc ndr_desc;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
