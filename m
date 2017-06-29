Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A978721B02B9D
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 10:58:55 -0700 (PDT)
Subject: [PATCH v4 12/16] libnvdimm, nfit: enable support for volatile ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 10:54:02 -0700
Message-ID: <149875884190.10031.6179599135820559644.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149875877608.10031.17813337234536358002.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Allow volatile nfit ranges to participate in all the same infrastructure
provided for persistent memory regions. A resulting resulting namespace
device will still be called "pmem", but the parent region type will be
"nd_volatile". This is in preparation for disabling the dax ->flush()
operation in the pmem driver when it is hosted on a volatile range.

Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c        |    9 ++++++++-
 drivers/nvdimm/bus.c            |    8 ++++----
 drivers/nvdimm/core.c           |    2 +-
 drivers/nvdimm/dax_devs.c       |    2 +-
 drivers/nvdimm/dimm_devs.c      |    2 +-
 drivers/nvdimm/namespace_devs.c |    8 ++++----
 drivers/nvdimm/nd-core.h        |    9 +++++++++
 drivers/nvdimm/pfn_devs.c       |    4 ++--
 drivers/nvdimm/region_devs.c    |   27 ++++++++++++++-------------
 9 files changed, 44 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ac2436538b7e..60d1ca149cc1 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2227,6 +2227,13 @@ static bool nfit_spa_is_virtual(struct acpi_nfit_system_address *spa)
 		nfit_spa_type(spa) == NFIT_SPA_PCD);
 }
 
+static bool nfit_spa_is_volatile(struct acpi_nfit_system_address *spa)
+{
+	return (nfit_spa_type(spa) == NFIT_SPA_VDISK ||
+		nfit_spa_type(spa) == NFIT_SPA_VCD   ||
+		nfit_spa_type(spa) == NFIT_SPA_VOLATILE);
+}
+
 static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		struct nfit_spa *nfit_spa)
 {
@@ -2301,7 +2308,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
 			rc = -ENOMEM;
-	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
+	} else if (nfit_spa_is_volatile(spa)) {
 		nfit_spa->nd_region = nvdimm_volatile_region_create(nvdimm_bus,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index e9361bffe5ee..4cfba534814b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -38,13 +38,13 @@ static int to_nd_device_type(struct device *dev)
 {
 	if (is_nvdimm(dev))
 		return ND_DEVICE_DIMM;
-	else if (is_nd_pmem(dev))
+	else if (is_memory(dev))
 		return ND_DEVICE_REGION_PMEM;
 	else if (is_nd_blk(dev))
 		return ND_DEVICE_REGION_BLK;
 	else if (is_nd_dax(dev))
 		return ND_DEVICE_DAX_PMEM;
-	else if (is_nd_pmem(dev->parent) || is_nd_blk(dev->parent))
+	else if (is_nd_region(dev->parent))
 		return nd_region_to_nstype(to_nd_region(dev->parent));
 
 	return 0;
@@ -56,7 +56,7 @@ static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	 * Ensure that region devices always have their numa node set as
 	 * early as possible.
 	 */
-	if (is_nd_pmem(dev) || is_nd_blk(dev))
+	if (is_nd_region(dev))
 		set_dev_node(dev, to_nd_region(dev)->numa_node);
 	return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
 			to_nd_device_type(dev));
@@ -65,7 +65,7 @@ static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 static struct module *to_bus_provider(struct device *dev)
 {
 	/* pin bus providers while regions are enabled */
-	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+	if (is_nd_region(dev)) {
 		struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 
 		return nvdimm_bus->nd_desc->module;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 2dee908e4bae..22e3ef463401 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -504,7 +504,7 @@ void nvdimm_badblocks_populate(struct nd_region *nd_region,
 	struct nvdimm_bus *nvdimm_bus;
 	struct list_head *poison_list;
 
-	if (!is_nd_pmem(&nd_region->dev)) {
+	if (!is_memory(&nd_region->dev)) {
 		dev_WARN_ONCE(&nd_region->dev, 1,
 				"%s only valid for pmem regions\n", __func__);
 		return;
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index c1b6556aea6e..a304983ac417 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -89,7 +89,7 @@ struct device *nd_dax_create(struct nd_region *nd_region)
 	struct device *dev = NULL;
 	struct nd_dax *nd_dax;
 
-	if (!is_nd_pmem(&nd_region->dev))
+	if (!is_memory(&nd_region->dev))
 		return NULL;
 
 	nd_dax = nd_dax_alloc(nd_region);
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 6a1e7a3c0c17..f0d1b7e5de01 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -419,7 +419,7 @@ int alias_dpa_busy(struct device *dev, void *data)
 	struct resource *res;
 	int i;
 
-	if (!is_nd_pmem(dev))
+	if (!is_memory(dev))
 		return 0;
 
 	nd_region = to_nd_region(dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 4e9261ef8a95..57724da484d0 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -112,7 +112,7 @@ static int is_uuid_busy(struct device *dev, void *data)
 
 static int is_namespace_uuid_busy(struct device *dev, void *data)
 {
-	if (is_nd_pmem(dev) || is_nd_blk(dev))
+	if (is_nd_region(dev))
 		return device_for_each_child(dev, data, is_uuid_busy);
 	return 0;
 }
@@ -783,7 +783,7 @@ static int __reserve_free_pmem(struct device *dev, void *data)
 	struct nd_label_id label_id;
 	int i;
 
-	if (!is_nd_pmem(dev))
+	if (!is_memory(dev))
 		return 0;
 
 	nd_region = to_nd_region(dev);
@@ -1872,7 +1872,7 @@ static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
 	struct resource *res;
 	struct device *dev;
 
-	if (!is_nd_pmem(&nd_region->dev))
+	if (!is_memory(&nd_region->dev))
 		return NULL;
 
 	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
@@ -2152,7 +2152,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		}
 		dev->parent = &nd_region->dev;
 		devs[count++] = dev;
-	} else if (is_nd_pmem(&nd_region->dev)) {
+	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct list_head *l, *e;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 4c4bd209e725..86bc19ae30da 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -64,7 +64,16 @@ struct blk_alloc_info {
 
 bool is_nvdimm(struct device *dev);
 bool is_nd_pmem(struct device *dev);
+bool is_nd_volatile(struct device *dev);
 bool is_nd_blk(struct device *dev);
+static inline bool is_nd_region(struct device *dev)
+{
+	return is_nd_pmem(dev) || is_nd_blk(dev) || is_nd_volatile(dev);
+}
+static inline bool is_memory(struct device *dev)
+{
+	return is_nd_pmem(dev) || is_nd_volatile(dev);
+}
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index a6c403600d19..5929eb65cee3 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -331,7 +331,7 @@ struct device *nd_pfn_create(struct nd_region *nd_region)
 	struct nd_pfn *nd_pfn;
 	struct device *dev;
 
-	if (!is_nd_pmem(&nd_region->dev))
+	if (!is_memory(&nd_region->dev))
 		return NULL;
 
 	nd_pfn = nd_pfn_alloc(nd_region);
@@ -354,7 +354,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	if (!pfn_sb || !ndns)
 		return -ENODEV;
 
-	if (!is_nd_pmem(nd_pfn->dev.parent))
+	if (!is_memory(nd_pfn->dev.parent))
 		return -ENODEV;
 
 	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0))
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 41b4cdf5dea8..53a64a16aba4 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -168,6 +168,11 @@ bool is_nd_blk(struct device *dev)
 	return dev ? dev->type == &nd_blk_device_type : false;
 }
 
+bool is_nd_volatile(struct device *dev)
+{
+	return dev ? dev->type == &nd_volatile_device_type : false;
+}
+
 struct nd_region *to_nd_region(struct device *dev)
 {
 	struct nd_region *nd_region = container_of(dev, struct nd_region, dev);
@@ -214,7 +219,7 @@ EXPORT_SYMBOL_GPL(nd_blk_region_set_provider_data);
  */
 int nd_region_to_nstype(struct nd_region *nd_region)
 {
-	if (is_nd_pmem(&nd_region->dev)) {
+	if (is_memory(&nd_region->dev)) {
 		u16 i, alias;
 
 		for (i = 0, alias = 0; i < nd_region->ndr_mappings; i++) {
@@ -242,7 +247,7 @@ static ssize_t size_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	unsigned long long size = 0;
 
-	if (is_nd_pmem(dev)) {
+	if (is_memory(dev)) {
 		size = nd_region->ndr_size;
 	} else if (nd_region->ndr_mappings == 1) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
@@ -307,7 +312,7 @@ static ssize_t set_cookie_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 
-	if (is_nd_pmem(dev) && nd_set)
+	if (is_memory(dev) && nd_set)
 		/* pass, should be precluded by region_visible */;
 	else
 		return -ENXIO;
@@ -334,7 +339,7 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 		if (!ndd)
 			return 0;
 
-		if (is_nd_pmem(&nd_region->dev)) {
+		if (is_memory(&nd_region->dev)) {
 			available += nd_pmem_available_dpa(nd_region,
 					nd_mapping, &overlap);
 			if (overlap > blk_max_overlap) {
@@ -520,10 +525,10 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	int type = nd_region_to_nstype(nd_region);
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_pfn_seed.attr)
+	if (!is_memory(dev) && a == &dev_attr_pfn_seed.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_dax_seed.attr)
+	if (!is_memory(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
 	if (!is_nd_pmem(dev) && a == &dev_attr_badblocks.attr)
@@ -551,7 +556,7 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 				|| type == ND_DEVICE_NAMESPACE_BLK)
 			&& a == &dev_attr_available_size.attr)
 		return a->mode;
-	else if (is_nd_pmem(dev) && nd_set)
+	else if (is_memory(dev) && nd_set)
 		return a->mode;
 
 	return 0;
@@ -603,7 +608,7 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 {
 	struct nd_region *nd_region;
 
-	if (!probe && (is_nd_pmem(dev) || is_nd_blk(dev))) {
+	if (!probe && is_nd_region(dev)) {
 		int i;
 
 		nd_region = to_nd_region(dev);
@@ -621,12 +626,8 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			if (ndd)
 				atomic_dec(&nvdimm->busy);
 		}
-
-		if (is_nd_pmem(dev))
-			return;
 	}
-	if (dev->parent && (is_nd_blk(dev->parent) || is_nd_pmem(dev->parent))
-			&& probe) {
+	if (dev->parent && is_nd_region(dev->parent) && probe) {
 		nd_region = to_nd_region(dev->parent);
 		nvdimm_bus_lock(dev);
 		if (nd_region->ns_seed == dev)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
