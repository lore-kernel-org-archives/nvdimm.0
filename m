Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id E5A291A1E24
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:27:39 -0700 (PDT)
Subject: [PATCH v2 03/17] libnvdimm: introduce devm_nvdimm_memremap(),
 convert nfit_spa_map() users
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:24:45 -0700
Message-ID: <146812108537.32932.4793673688677479548.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for generically mapping flush hint addresses for both the
BLK and PMEM use case, provide a generic / reference counted mapping
api.  Given the fact that a dimm may belong to multiple regions (PMEM
and BLK), the flush hint addresses need to be held valid as long as any
region associated with the dimm is active.  This is similar to the
existing BLK-region case where multiple BLK-regions may share an
aperture mapping.  Up-level this shared / reference-counted mapping
capability from the nfit driver to a core nvdimm capability.

This eliminates the need for the nd_blk_region.disable() callback.  Note
that the removal of nfit_spa_map() and related infrastructure is
deferred to a later patch.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c       |   14 +++--
 drivers/nvdimm/core.c     |  122 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/nvdimm/nd-core.h  |    1 
 include/linux/libnvdimm.h |    9 +++
 4 files changed, 139 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index f8c1a850effc..b047dbe13bed 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1616,7 +1616,8 @@ static void __iomem *__nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
  * when all region devices referencing the same mapping are disabled /
  * unbound.
  */
-static void __iomem *nfit_spa_map(struct acpi_nfit_desc *acpi_desc,
+static __maybe_unused void __iomem *nfit_spa_map(
+		struct acpi_nfit_desc *acpi_desc,
 		struct acpi_nfit_system_address *spa, enum spa_map_type type)
 {
 	void __iomem *iomem;
@@ -1669,7 +1670,6 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
-	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
 	struct nfit_flush *nfit_flush;
 	struct nfit_blk_mmio *mmio;
@@ -1697,8 +1697,8 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	/* map block aperture memory */
 	nfit_blk->bdw_offset = nfit_mem->bdw->offset;
 	mmio = &nfit_blk->mmio[BDW];
-	mmio->addr.base = nfit_spa_map(acpi_desc, nfit_mem->spa_bdw,
-			SPA_MAP_APERTURE);
+	mmio->addr.base = devm_nvdimm_memremap(dev, nfit_mem->spa_bdw->address,
+                        nfit_mem->spa_bdw->length, ARCH_MEMREMAP_PMEM);
 	if (!mmio->addr.base) {
 		dev_dbg(dev, "%s: %s failed to map bdw\n", __func__,
 				nvdimm_name(nvdimm));
@@ -1720,8 +1720,8 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	nfit_blk->cmd_offset = nfit_mem->dcr->command_offset;
 	nfit_blk->stat_offset = nfit_mem->dcr->status_offset;
 	mmio = &nfit_blk->mmio[DCR];
-	mmio->addr.base = nfit_spa_map(acpi_desc, nfit_mem->spa_dcr,
-			SPA_MAP_CONTROL);
+	mmio->addr.base = devm_nvdimm_ioremap(dev, nfit_mem->spa_dcr->address,
+			nfit_mem->spa_dcr->length);
 	if (!mmio->addr.base) {
 		dev_dbg(dev, "%s: %s failed to map dcr\n", __func__,
 				nvdimm_name(nvdimm));
@@ -1748,7 +1748,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 
 	nfit_flush = nfit_mem->nfit_flush;
 	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
-		nfit_blk->nvdimm_flush = devm_ioremap_nocache(dev,
+		nfit_blk->nvdimm_flush = devm_nvdimm_ioremap(dev,
 				nfit_flush->flush->hint_address[0], 8);
 		if (!nfit_blk->nvdimm_flush)
 			return -ENOMEM;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 32e4fe2f6274..f9686297ff79 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -57,6 +57,127 @@ bool is_nvdimm_bus_locked(struct device *dev)
 }
 EXPORT_SYMBOL(is_nvdimm_bus_locked);
 
+struct nvdimm_map {
+	struct nvdimm_bus *nvdimm_bus;
+	struct list_head list;
+	resource_size_t offset;
+	unsigned long flags;
+	size_t size;
+	union {
+		void *mem;
+		void __iomem *iomem;
+	};
+	struct kref kref;
+};
+
+static struct nvdimm_map *find_nvdimm_map(struct device *dev,
+		resource_size_t offset)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nvdimm_map *nvdimm_map;
+
+	list_for_each_entry(nvdimm_map, &nvdimm_bus->mapping_list, list)
+		if (nvdimm_map->offset == offset)
+			return nvdimm_map;
+	return NULL;
+}
+
+static struct nvdimm_map *alloc_nvdimm_map(struct device *dev,
+		resource_size_t offset, size_t size, unsigned long flags)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nvdimm_map *nvdimm_map;
+
+	nvdimm_map = kzalloc(sizeof(*nvdimm_map), GFP_KERNEL);
+	if (!nvdimm_map)
+		return NULL;
+
+	INIT_LIST_HEAD(&nvdimm_map->list);
+	nvdimm_map->nvdimm_bus = nvdimm_bus;
+	nvdimm_map->offset = offset;
+	nvdimm_map->flags = flags;
+	nvdimm_map->size = size;
+	kref_init(&nvdimm_map->kref);
+
+	if (!request_mem_region(offset, size, dev_name(&nvdimm_bus->dev)))
+		goto err_request_region;
+
+	if (flags)
+		nvdimm_map->mem = memremap(offset, size, flags);
+	else
+		nvdimm_map->iomem = ioremap(offset, size);
+
+	if (!nvdimm_map->mem)
+		goto err_map;
+
+	dev_WARN_ONCE(dev, !is_nvdimm_bus_locked(dev), "%s: bus unlocked!",
+			__func__);
+	list_add(&nvdimm_map->list, &nvdimm_bus->mapping_list);
+
+	return nvdimm_map;
+
+ err_map:
+	release_mem_region(offset, size);
+ err_request_region:
+	kfree(nvdimm_map);
+	return NULL;
+}
+
+static void nvdimm_map_release(struct kref *kref)
+{
+	struct nvdimm_bus *nvdimm_bus;
+	struct nvdimm_map *nvdimm_map;
+
+	nvdimm_map = container_of(kref, struct nvdimm_map, kref);
+	nvdimm_bus = nvdimm_map->nvdimm_bus;
+
+	dev_dbg(&nvdimm_bus->dev, "%s: %pa\n", __func__, &nvdimm_map->offset);
+	list_del(&nvdimm_map->list);
+	if (nvdimm_map->flags)
+		memunmap(nvdimm_map->mem);
+	else
+		iounmap(nvdimm_map->iomem);
+	release_mem_region(nvdimm_map->offset, nvdimm_map->size);
+	kfree(nvdimm_map);
+}
+
+static void nvdimm_map_put(void *data)
+{
+	struct nvdimm_map *nvdimm_map = data;
+	struct nvdimm_bus *nvdimm_bus = nvdimm_map->nvdimm_bus;
+
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	kref_put(&nvdimm_map->kref, nvdimm_map_release);
+	nvdimm_bus_unlock(&nvdimm_bus->dev);
+}
+
+/**
+ * devm_nvdimm_memremap - map a resource that is shared across regions
+ * @dev: device that will own a reference to the shared mapping
+ * @offset: physical base address of the mapping
+ * @size: mapping size
+ * @flags: memremap flags, or, if zero, perform an ioremap instead
+ */
+void *devm_nvdimm_memremap(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags)
+{
+	struct nvdimm_map *nvdimm_map;
+
+	nvdimm_bus_lock(dev);
+	nvdimm_map = find_nvdimm_map(dev, offset);
+	if (!nvdimm_map)
+		nvdimm_map = alloc_nvdimm_map(dev, offset, size, flags);
+	else
+		kref_get(&nvdimm_map->kref);
+	nvdimm_bus_unlock(dev);
+
+	if (devm_add_action_or_reset(dev, nvdimm_map_put, nvdimm_map))
+		return NULL;
+
+	return nvdimm_map->mem;
+}
+EXPORT_SYMBOL_GPL(devm_nvdimm_memremap);
+
 u64 nd_fletcher64(void *addr, size_t len, bool le)
 {
 	u32 *buf = addr;
@@ -335,6 +456,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	if (!nvdimm_bus)
 		return NULL;
 	INIT_LIST_HEAD(&nvdimm_bus->list);
+	INIT_LIST_HEAD(&nvdimm_bus->mapping_list);
 	INIT_LIST_HEAD(&nvdimm_bus->poison_list);
 	init_waitqueue_head(&nvdimm_bus->probe_wait);
 	nvdimm_bus->id = ida_simple_get(&nd_ida, 0, 0, GFP_KERNEL);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 284cdaa268cf..790b62cc81ed 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -31,6 +31,7 @@ struct nvdimm_bus {
 	struct device dev;
 	int id, probe_active;
 	struct list_head poison_list;
+	struct list_head mapping_list;
 	struct mutex reconfig_mutex;
 };
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0c3c30cbbea5..18c3cc48a970 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -99,6 +99,15 @@ struct nd_region_desc {
 	unsigned long flags;
 };
 
+struct device;
+void *devm_nvdimm_memremap(struct device *dev, resource_size_t offset,
+		size_t size, unsigned long flags);
+static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
+		resource_size_t offset, size_t size)
+{
+	return (void __iomem *) devm_nvdimm_memremap(dev, offset, size, 0);
+}
+
 struct nvdimm_bus;
 struct module;
 struct device;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
