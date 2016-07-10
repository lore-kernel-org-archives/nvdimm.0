Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 7535F1A1E24
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:27:50 -0700 (PDT)
Subject: [PATCH v2 05/17] libnvdimm,
 nfit: move flush hint mapping to region-device driver-data
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:24:56 -0700
Message-ID: <146812109613.32932.9879982884048235667.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for triggering flushes of a DIMM's writes-posted-queue
(WPQ) via the pmem driver move mapping of flush hint addresses to the
region driver.  Since this uses devm_nvdimm_memremap() the flush
addresses will remain mapped while any region to which the dimm belongs
is active.

We need to communicate more information to the nvdimm core to facilitate
this mapping, namely each dimm object now carries an array of flush hint
address resources.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c          |   21 +++++++++++
 drivers/acpi/nfit.h          |    1 +
 drivers/nvdimm/dimm_devs.c   |    5 ++-
 drivers/nvdimm/nd-core.h     |    3 +-
 drivers/nvdimm/nd.h          |    8 +++-
 drivers/nvdimm/region.c      |   16 ++++-----
 drivers/nvdimm/region_devs.c |   79 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/libnvdimm.h    |    4 ++
 8 files changed, 119 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index b76c95981547..6796f780870a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -714,9 +714,24 @@ static int nfit_mem_dcr_init(struct acpi_nfit_desc *acpi_desc,
 		}
 
 		list_for_each_entry(nfit_flush, &acpi_desc->flushes, list) {
+			struct acpi_nfit_flush_address *flush;
+			u16 i;
+
 			if (nfit_flush->flush->device_handle != device_handle)
 				continue;
 			nfit_mem->nfit_flush = nfit_flush;
+			flush = nfit_flush->flush;
+			nfit_mem->flush_wpq = devm_kzalloc(acpi_desc->dev,
+					flush->hint_count
+					* sizeof(struct resource), GFP_KERNEL);
+			if (!nfit_mem->flush_wpq)
+				return -ENOMEM;
+			for (i = 0; i < flush->hint_count; i++) {
+				struct resource *res = &nfit_mem->flush_wpq[i];
+
+				res->start = flush->hint_address[i];
+				res->end = res->start + 8 - 1;
+			}
 			break;
 		}
 
@@ -1171,6 +1186,7 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 	int dimm_count = 0;
 
 	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+		struct acpi_nfit_flush_address *flush;
 		unsigned long flags = 0, cmd_mask;
 		struct nvdimm *nvdimm;
 		u32 device_handle;
@@ -1204,9 +1220,12 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
 		if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
 			cmd_mask |= nfit_mem->dsm_mask;
 
+		flush = nfit_mem->nfit_flush ? nfit_mem->nfit_flush->flush
+			: NULL;
 		nvdimm = nvdimm_create(acpi_desc->nvdimm_bus, nfit_mem,
 				acpi_nfit_dimm_attribute_groups,
-				flags, cmd_mask);
+				flags, cmd_mask, flush ? flush->hint_count : 0,
+				nfit_mem->flush_wpq);
 		if (!nvdimm)
 			return -ENOMEM;
 
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index 52078475d969..9282eb324dcc 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -127,6 +127,7 @@ struct nfit_mem {
 	struct list_head list;
 	struct acpi_device *adev;
 	struct acpi_nfit_desc *acpi_desc;
+	struct resource *flush_wpq;
 	unsigned long dsm_mask;
 	int family;
 };
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index bbde28d3dec5..d9bba5edd8dc 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -346,7 +346,8 @@ EXPORT_SYMBOL_GPL(nvdimm_attribute_group);
 
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask)
+		unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq)
 {
 	struct nvdimm *nvdimm = kzalloc(sizeof(*nvdimm), GFP_KERNEL);
 	struct device *dev;
@@ -362,6 +363,8 @@ struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 	nvdimm->provider_data = provider_data;
 	nvdimm->flags = flags;
 	nvdimm->cmd_mask = cmd_mask;
+	nvdimm->num_flush = num_flush;
+	nvdimm->flush_wpq = flush_wpq;
 	atomic_set(&nvdimm->busy, 0);
 	dev = &nvdimm->dev;
 	dev_set_name(dev, "nmem%d", nvdimm->id);
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 790b62cc81ed..6e961f7f43e7 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -41,7 +41,8 @@ struct nvdimm {
 	unsigned long cmd_mask;
 	struct device dev;
 	atomic_t busy;
-	int id;
+	int id, num_flush;
+	struct resource *flush_wpq;
 };
 
 bool is_nvdimm(struct device *dev);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 2819e886dfd2..5912bd6b4234 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -49,9 +49,10 @@ struct nvdimm_drvdata {
 	struct kref kref;
 };
 
-struct nd_region_namespaces {
-	int count;
-	int active;
+struct nd_region_data {
+	int ns_count;
+	int ns_active;
+	void __iomem *flush_wpq[0][0];
 };
 
 static inline struct nd_namespace_index *to_namespace_index(
@@ -324,6 +325,7 @@ static inline void devm_nsio_disable(struct device *dev,
 }
 #endif
 int nd_blk_region_init(struct nd_region *nd_region);
+int nd_region_activate(struct nd_region *nd_region);
 void __nd_iostat_start(struct bio *bio, unsigned long *start);
 static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
 {
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 05a912359939..333175dac8d5 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -20,7 +20,7 @@ static int nd_region_probe(struct device *dev)
 {
 	int err, rc;
 	static unsigned long once;
-	struct nd_region_namespaces *num_ns;
+	struct nd_region_data *ndrd;
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (nd_region->num_lanes > num_online_cpus()
@@ -33,21 +33,21 @@ static int nd_region_probe(struct device *dev)
 				nd_region->num_lanes);
 	}
 
+	rc = nd_region_activate(nd_region);
+	if (rc)
+		return rc;
+
 	rc = nd_blk_region_init(nd_region);
 	if (rc)
 		return rc;
 
 	rc = nd_region_register_namespaces(nd_region, &err);
-	num_ns = devm_kzalloc(dev, sizeof(*num_ns), GFP_KERNEL);
-	if (!num_ns)
-		return -ENOMEM;
-
 	if (rc < 0)
 		return rc;
 
-	num_ns->active = rc;
-	num_ns->count = rc + err;
-	dev_set_drvdata(dev, num_ns);
+	ndrd = dev_get_drvdata(dev);
+	ndrd->ns_active = rc;
+	ndrd->ns_count = rc + err;
 
 	if (rc && err && rc == err)
 		return -ENODEV;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 694b21024871..67022f74febc 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -22,6 +22,79 @@
 
 static DEFINE_IDA(region_ida);
 
+static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
+		struct nd_region_data *ndrd)
+{
+	int i, j;
+
+	dev_dbg(dev, "%s: map %d flush address%s\n", nvdimm_name(nvdimm),
+			nvdimm->num_flush, nvdimm->num_flush == 1 ? "" : "es");
+	for (i = 0; i < nvdimm->num_flush; i++) {
+		struct resource *res = &nvdimm->flush_wpq[i];
+		unsigned long pfn = PHYS_PFN(res->start);
+		void __iomem *flush_page;
+
+		/* check if flush hints share a page */
+		for (j = 0; j < i; j++) {
+			struct resource *res_j = &nvdimm->flush_wpq[j];
+			unsigned long pfn_j = PHYS_PFN(res_j->start);
+
+			if (pfn == pfn_j)
+				break;
+		}
+
+		if (j < i)
+			flush_page = (void __iomem *) ((unsigned long)
+					ndrd->flush_wpq[dimm][j] & PAGE_MASK);
+		else
+			flush_page = devm_nvdimm_ioremap(dev,
+					PHYS_PFN(pfn), PAGE_SIZE);
+		if (!flush_page)
+			return -ENXIO;
+		ndrd->flush_wpq[dimm][i] = flush_page
+			+ (res->start & ~PAGE_MASK);
+	}
+
+	return 0;
+}
+
+int nd_region_activate(struct nd_region *nd_region)
+{
+	int i;
+	struct nd_region_data *ndrd;
+	struct device *dev = &nd_region->dev;
+	size_t flush_data_size = sizeof(void *);
+
+	nvdimm_bus_lock(&nd_region->dev);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+
+		/* at least one null hint slot per-dimm for the "no-hint" case */
+		flush_data_size += sizeof(void *);
+		if (!nvdimm->num_flush)
+			continue;
+		flush_data_size += nvdimm->num_flush * sizeof(void *);
+	}
+	nvdimm_bus_unlock(&nd_region->dev);
+
+	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
+	if (!ndrd)
+		return -ENOMEM;
+	dev_set_drvdata(dev, ndrd);
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		int rc = nvdimm_map_flush(&nd_region->dev, nvdimm, i, ndrd);
+
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 static void nd_region_release(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
@@ -242,12 +315,12 @@ static DEVICE_ATTR_RO(available_size);
 static ssize_t init_namespaces_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_region_namespaces *num_ns = dev_get_drvdata(dev);
+	struct nd_region_data *ndrd = dev_get_drvdata(dev);
 	ssize_t rc;
 
 	nvdimm_bus_lock(dev);
-	if (num_ns)
-		rc = sprintf(buf, "%d/%d\n", num_ns->active, num_ns->count);
+	if (ndrd)
+		rc = sprintf(buf, "%d/%d\n", ndrd->ns_active, ndrd->ns_count);
 	else
 		rc = -ENXIO;
 	nvdimm_bus_unlock(dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 1050f9aa3a3e..815b9b430ead 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -52,6 +52,7 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 
 struct nd_namespace_label;
 struct nvdimm_drvdata;
+
 struct nd_mapping {
 	struct nvdimm *nvdimm;
 	struct nd_namespace_label **labels;
@@ -142,7 +143,8 @@ unsigned long nvdimm_cmd_mask(struct nvdimm *nvdimm);
 void *nvdimm_provider_data(struct nvdimm *nvdimm);
 struct nvdimm *nvdimm_create(struct nvdimm_bus *nvdimm_bus, void *provider_data,
 		const struct attribute_group **groups, unsigned long flags,
-		unsigned long cmd_mask);
+		unsigned long cmd_mask, int num_flush,
+		struct resource *flush_wpq);
 const struct nd_cmd_desc *nd_cmd_dimm_desc(int cmd);
 const struct nd_cmd_desc *nd_cmd_bus_desc(int cmd);
 u32 nd_cmd_in_size(struct nvdimm *nvdimm, int cmd,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
