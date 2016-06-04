Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id C4AD11A1E44
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:53:56 -0700 (PDT)
Subject: [PATCH 04/13] libnvdimm, nfit: move flush hint mapping to dimm driver
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:52:54 -0700
Message-ID: <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Since flush hints are a per-dimm property and we want to start using
them outside of block-window I/O context, move their initialization to
nvdimm_probe() context.

For the future use of flush hints in the pmem driver it would be
unfortunate to call back into the bus provider just to issue a write, so
make flush hints a generic property of an nvdimm.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |   86 ++++++++++++++++++++++++++----------------
 drivers/acpi/nfit.h          |    1 
 drivers/nvdimm/dimm.c        |    7 +++
 drivers/nvdimm/dimm_devs.c   |   25 ++++++++++++
 drivers/nvdimm/nd-core.h     |    1 
 drivers/nvdimm/nd.h          |   14 +++++++
 drivers/nvdimm/region_devs.c |   47 +++++++++++++++++++----
 include/linux/libnvdimm.h    |    8 +++-
 8 files changed, 145 insertions(+), 44 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 4771872810ef..4643dd7a4284 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1104,6 +1104,47 @@ static struct nvdimm *acpi_nfit_dimm_by_handle(struct acpi_nfit_desc *acpi_desc,
 	return NULL;
 }
 
+static int acpi_nfit_populate_flush_hints(struct device *dev,
+		void __iomem *flush_wpq[])
+{
+	int i, j;
+	struct nfit_flush *nfit_flush;
+	struct acpi_nfit_flush_address *flush;
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+	nfit_flush = nfit_mem->nfit_flush;
+	if (!nfit_flush || !nfit_flush->flush->hint_count)
+		return 0;
+	flush = nfit_flush->flush;
+
+	for (i = 0; i < flush->hint_count; i++) {
+		unsigned long pfn = PHYS_PFN(flush->hint_address[i]);
+		void __iomem *hint_page;
+
+		/* check if flush hints share a page */
+		for (j = 0; j < i; j++) {
+			unsigned long pfn_j = PHYS_PFN(flush->hint_address[j]);
+
+			if (pfn == pfn_j)
+				break;
+		}
+
+		if (j < i)
+			hint_page = (void *) ((unsigned long) flush_wpq[j]
+					& PAGE_MASK);
+		else
+			hint_page = devm_ioremap_nocache(dev,
+					PHYS_PFN(pfn), PAGE_SIZE);
+		if (!hint_page)
+			return -ENXIO;
+		flush_wpq[i] = hint_page
+			+ (flush->hint_address[i] & ~PAGE_MASK);
+	}
+
+	return 0;
+}
+
 static int acpi_nfit_add_dimm(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_mem *nfit_mem, u32 device_handle)
 {
@@ -1170,10 +1211,10 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 
 	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
 		unsigned long flags = 0, cmd_mask;
+		int rc, flush_hints = 0;
 		struct nvdimm *nvdimm;
 		u32 device_handle;
 		u16 mem_flags;
-		int rc;
 
 		device_handle = __to_nfit_memdev(nfit_mem)->device_handle;
 		nvdimm = acpi_nfit_dimm_by_handle(acpi_desc, device_handle);
@@ -1202,9 +1243,16 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
 			cmd_mask |= nfit_mem->dsm_mask;
 
+		if (nfit_mem->nfit_flush) {
+			struct acpi_nfit_flush_address *flush;
+
+			flush = nfit_mem->nfit_flush->flush;
+			flush_hints = flush->hint_count;
+		}
+
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
-				flags, cmd_mask);
+				flags, cmd_mask, flush_hints);
 		if (!nvdimm)
 			return -ENOMEM;
 
@@ -1372,24 +1420,6 @@ static u64 to_interleave_offset(u64 offset, struct nfit_blk_mmio *mmio)
 	return mmio->base_offset + line_offset + table_offset + sub_line_offset;
 }
 
-static void wmb_blk(struct nfit_blk *nfit_blk)
-{
-
-	if (nfit_blk->nvdimm_flush) {
-		/*
-		 * The first wmb() is needed to 'sfence' all previous writes
-		 * such that they are architecturally visible for the platform
-		 * buffer flush.  Note that we've already arranged for pmem
-		 * writes to avoid the cache via arch_memcpy_to_pmem().  The
-		 * final wmb() ensures ordering for the NVDIMM flush write.
-		 */
-		wmb();
-		writeq(1, nfit_blk->nvdimm_flush);
-		wmb();
-	} else
-		wmb_pmem();
-}
-
 static u32 read_blk_stat(struct nfit_blk *nfit_blk, unsigned int bw)
 {
 	struct nfit_blk_mmio *mmio = &nfit_blk->mmio[DCR];
@@ -1424,7 +1454,7 @@ static void write_blk_ctl(struct nfit_blk *nfit_blk, unsigned int bw,
 		offset = to_interleave_offset(offset, mmio);
 
 	writeq(cmd, mmio->addr.base + offset);
-	wmb_blk(nfit_blk);
+	nvdimm_flush(nfit_blk->nd_region);
 
 	if (nfit_blk->dimm_flags & NFIT_BLK_DCR_LATCH)
 		readq(mmio->addr.base + offset);
@@ -1475,7 +1505,7 @@ static int acpi_nfit_blk_single_io(struct nfit_blk *nfit_blk,
 	}
 
 	if (rw)
-		wmb_blk(nfit_blk);
+		nvdimm_flush(nfit_blk->nd_region);
 
 	rc = read_blk_stat(nfit_blk, lane) ? -EIO : 0;
 	return rc;
@@ -1669,7 +1699,6 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 	struct nvdimm_bus_descriptor *nd_desc = to_nd_desc(nvdimm_bus);
 	struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
 	struct nd_blk_region *ndbr = to_nd_blk_region(dev);
-	struct nfit_flush *nfit_flush;
 	struct nfit_blk_mmio *mmio;
 	struct nfit_blk *nfit_blk;
 	struct nfit_mem *nfit_mem;
@@ -1744,15 +1773,7 @@ static int acpi_nfit_blk_region_enable(struct nvdimm_bus *nvdimm_bus,
 		return rc;
 	}
 
-	nfit_flush = nfit_mem->nfit_flush;
-	if (nfit_flush && nfit_flush->flush->hint_count != 0) {
-		nfit_blk->nvdimm_flush = devm_ioremap_nocache(dev,
-				nfit_flush->flush->hint_address[0], 8);
-		if (!nfit_blk->nvdimm_flush)
-			return -ENOMEM;
-	}
-
-	if (!arch_has_wmb_pmem() && !nfit_blk->nvdimm_flush)
+	if (nvdimm_has_flush(nfit_blk->nd_region) < 0)
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (mmio->line_size == 0)
@@ -2504,6 +2525,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
 	nd_desc->ndctl = acpi_nfit_ctl;
+	nd_desc->populate_flush_hints = acpi_nfit_populate_flush_hints;
 	nd_desc->flush_probe = acpi_nfit_flush_probe;
 	nd_desc->clear_to_send = acpi_nfit_clear_to_send;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 11cb38348aef..9c8a6cf760be 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -180,7 +180,6 @@ struct nfit_blk {
 	u64 bdw_offset; /* post interleave offset */
 	u64 stat_offset;
 	u64 cmd_offset;
-	void __iomem *nvdimm_flush;
 	u32 dimm_flags;
 };
 
diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 71d12bb67339..642dd2c21009 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -26,7 +26,7 @@ static int nvdimm_probe(struct device *dev)
 	struct nvdimm_drvdata *ndd;
 	int rc;
 
-	ndd = kzalloc(sizeof(*ndd), GFP_KERNEL);
+	ndd = nvdimm_alloc_drvdata(dev);
 	if (!ndd)
 		return -ENOMEM;
 
@@ -40,6 +40,11 @@ static int nvdimm_probe(struct device *dev)
 	get_device(dev);
 	kref_init(&ndd->kref);
 
+	/* trigger bus-provider specific probing */
+	rc = nvdimm_populate_flush_hints(dev);
+	if (rc)
+		goto err;
+
 	rc = nvdimm_init_nsarea(ndd);
 	if (rc)
 		goto err;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index bbde28d3dec5..e58e8ba155aa 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -24,6 +24,26 @@
 
 static DEFINE_IDA(dimm_ida);
 
+struct nvdimm_drvdata *nvdimm_alloc_drvdata(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	return kzalloc(sizeof(struct nvdimm_drvdata)
+			+ sizeof(void *) * max(1, nvdimm->flush_hints),
+			GFP_KERNEL);
+}
+
+int nvdimm_populate_flush_hints(struct device *dev)
+{
+	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
+
+	if (nd_desc->populate_flush_hints)
+		return nd_desc->populate_flush_hints(dev, ndd->flush_wpq);
+	return 0;
+}
+
 /*
  * Retrieve bus and dimm handle and return if this bus supports
  * get_config_data commands
@@ -346,7 +366,7 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask)
+		unsigned long cmd_mask, int flush_hints)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -362,6 +382,7 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
+	nvdimm->flush_hints = flush_hints;
 	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
@@ -370,6 +391,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	dev->devt = MKDEV(nvdimm_major, nvdimm->id);
 	dev->groups = groups;
 	nd_device_register(dev);
+	dev_dbg(dev, "%s: flush_hints: %d cmds: %#lx\n", __func__, flush_hints,
+			cmd_mask);
 
 	return nvdimm;
 }
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 284cdaa268cf..1fa36dd45093 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -39,6 +39,7 @@ struct nvdimm {
 	void *provider_data;
 	unsigned long cmd_mask;
 	struct device dev;
+	int flush_hints;
 	atomic_t busy;
 	int id;
 };
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index d0ac93c31dda..4bba7c50961d 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -47,6 +47,7 @@ struct nvdimm_drvdata {
 	int ns_current, ns_next;
 	struct resource dpa;
 	struct kref kref;
+	void __iomem *flush_wpq[0];
 };
 
 struct nd_region_namespaces {
@@ -189,12 +190,25 @@ void nvdimm_exit(void);
 void nd_region_exit(void);
 struct nvdimm;
 struct nvdimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
+
+/*
+ * ...for contexts where the dimm is guaranteed not to be disabled while
+ * the returned data is in use.
+ */
+static inline struct nvdimm_drvdata *to_ndd_unlocked(
+		struct nd_mapping *nd_mapping)
+{
+	return nd_mapping->ndd;
+}
+
 int nvdimm_init_nsarea(struct nvdimm_drvdata *ndd);
 int nvdimm_init_config_data(struct nvdimm_drvdata *ndd);
 int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
 long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		unsigned int len);
+int nvdimm_populate_flush_hints(struct device *dev);
+struct nvdimm_drvdata *nvdimm_alloc_drvdata(struct device *dev);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 420e1a5e2250..5b6f85d00bb5 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -803,11 +803,29 @@ EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
  */
 void nvdimm_flush(struct nd_region *nd_region)
 {
+	int i;
+
 	/*
-	 * TODO: replace wmb_pmem() usage with flush hint writes where
-	 * available.
+	 * The first wmb() is needed to 'sfence' all previous writes
+	 * such that they are architecturally visible for the platform
+	 * buffer flush.  Note that we've already arranged for pmem
+	 * writes to avoid the cache via arch_memcpy_to_pmem().  The
+	 * final wmb() ensures ordering for the NVDIMM flush write.
 	 */
-	wmb_pmem();
+	wmb();
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd_unlocked(nd_mapping);
+
+		/*
+		 * Note, nvdimm_drvdata guaranteed to be live since we
+		 * arrange for all associated regions to be disabled
+		 * before the dimm is disabled.
+		 */
+		if (ndd->flush_wpq[0])
+			writeq(1, ndd->flush_wpq[0]);
+	}
+	wmb();
 }
 EXPORT_SYMBOL_GPL(nvdimm_flush);
 
@@ -821,13 +839,26 @@ EXPORT_SYMBOL_GPL(nvdimm_flush);
  */
 int nvdimm_has_flush(struct nd_region *nd_region)
 {
+	int i;
+
+	/* no nvdimm == flushing capability unknown */
+	if (nd_region->ndr_mappings == 0)
+		return -ENXIO;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		/* flush hints present, flushing required */
+		if (nvdimm->flush_hints)
+			return 1;
+	}
+
 	/*
-	 * TODO: return 0 / 1 for NFIT regions depending on presence of
-	 * flush hint tables
+	 * The platform defines dimm devices without hints, assume
+	 * platform persistence mechanism like ADR
 	 */
-	if (arch_has_wmb_pmem())
-		return 1;
-	return -ENXIO;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nvdimm_has_flush);
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 90eb3119c3ce..840dec0ebaa7 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -66,11 +66,17 @@ struct nd_mapping {
 	struct nvdimm_drvdata *ndd;
 };
 
+/**
+ * struct nvdimm_bus_descriptor - operations and attributes for an nvdimm bus
+ * @attr_groups: sysfs attributes for this bus
+ */
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long cmd_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
+	int (*populate_flush_hints)(struct device *dev,
+			void __iomem *flush_wpq[]);
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
 	int (*clear_to_send)(struct nvdimm_bus_descriptor *nd_desc,
 			struct nvdimm *nvdimm, unsigned int cmd);
@@ -134,7 +140,7 @@ unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask);
+		unsigned long cmd_mask, int flush_hints);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
