Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74A5221939249
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 19:41:36 -0700 (PDT)
Subject: [PATCH v2 31/33] libnvdimm, nfit: enable support for volatile ranges
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Apr 2017 19:35:52 -0700
Message-ID: <149222375246.32363.537195815269326385.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149222358726.32363.15876405696577002849.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
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
 drivers/nvdimm/bus.c            |   10 +++++-----
 drivers/nvdimm/core.c           |    2 +-
 drivers/nvdimm/dax_devs.c       |    2 +-
 drivers/nvdimm/dimm_devs.c      |    2 +-
 drivers/nvdimm/namespace_devs.c |    8 ++++----
 drivers/nvdimm/nd-core.h        |    9 +++++++++
 drivers/nvdimm/pfn_devs.c       |    4 ++--
 drivers/nvdimm/region_devs.c    |   27 ++++++++++++++-------------
 9 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 8b4c6212737c..6ac31846c4df 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2162,6 +2162,13 @@ static bool nfit_spa_is_virtual(struct acpi_nfit_system_address *spa)
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
@@ -2236,7 +2243,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
 			rc = -ENOMEM;
-	} else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE) {
+	} else if (nfit_spa_is_volatile(spa)) {
 		nfit_spa->nd_region = nvdimm_volatile_region_create(nvdimm_bus,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 351bac8f6503..d4173fbdba28 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -37,13 +37,13 @@ static int to_nd_device_type(struct device *dev)
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
@@ -55,7 +55,7 @@ static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	 * Ensure that region devices always have their numa node set as
 	 * early as possible.
 	 */
-	if (is_nd_pmem(dev) || is_nd_blk(dev))
+	if (is_nd_region(dev))
 		set_dev_node(dev, to_nd_region(dev)->numa_node);
 	return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
 			to_nd_device_type(dev));
@@ -64,7 +64,7 @@ static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 static struct module *to_bus_provider(struct device *dev)
 {
 	/* pin bus providers while regions are enabled */
-	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
+	if (is_nd_region(dev)) {
 		struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 
 		return nvdimm_bus->nd_desc->module;
@@ -771,7 +771,7 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 
 static int pmem_active(struct device *dev, void *data)
 {
-	if (is_nd_pmem(dev) && dev->driver)
+	if (is_memory(dev) && dev->driver)
 		return -EBUSY;
 	return 0;
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 9303cfeb8bee..875ef4cecb35 100644
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
index 45fa82cae87c..6a92b84c8072 100644
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
index 8b721321be5b..d814e5adab5c 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -403,7 +403,7 @@ int alias_dpa_busy(struct device *dev, void *data)
 	struct resource *res;
 	int i;
 
-	if (!is_nd_pmem(dev))
+	if (!is_memory(dev))
 		return 0;
 
 	nd_region = to_nd_region(dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2580f6655bea..4fa3c1fce6bf 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -111,7 +111,7 @@ static int is_uuid_busy(struct device *dev, void *data)
 
 static int is_namespace_uuid_busy(struct device *dev, void *data)
 {
-	if (is_nd_pmem(dev) || is_nd_blk(dev))
+	if (is_nd_region(dev))
 		return device_for_each_child(dev, data, is_uuid_busy);
 	return 0;
 }
@@ -786,7 +786,7 @@ static int __reserve_free_pmem(struct device *dev, void *data)
 	struct nd_label_id label_id;
 	int i;
 
-	if (!is_nd_pmem(dev))
+	if (!is_memory(dev))
 		return 0;
 
 	nd_region = to_nd_region(dev);
@@ -1875,7 +1875,7 @@ static struct device *nd_namespace_pmem_create(struct nd_region *nd_region)
 	struct resource *res;
 	struct device *dev;
 
-	if (!is_nd_pmem(&nd_region->dev))
+	if (!is_memory(&nd_region->dev))
 		return NULL;
 
 	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
@@ -2155,7 +2155,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		}
 		dev->parent = &nd_region->dev;
 		devs[count++] = dev;
-	} else if (is_nd_pmem(&nd_region->dev)) {
+	} else if (is_memory(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct list_head *l, *e;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 8623e57c2ce3..f26263cc8a36 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -63,7 +63,16 @@ struct blk_alloc_info {
 
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
index 6c033c9a2f06..7cc77684316b 100644
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
 
 	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb)))
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 5976f6c0407f..2df259010720 100644
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
@@ -278,7 +283,7 @@ static ssize_t set_cookie_show(struct device *dev,
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 
-	if (is_nd_pmem(dev) && nd_set)
+	if (is_memory(dev) && nd_set)
 		/* pass, should be precluded by region_visible */;
 	else
 		return -ENXIO;
@@ -305,7 +310,7 @@ resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 		if (!ndd)
 			return 0;
 
-		if (is_nd_pmem(&nd_region->dev)) {
+		if (is_memory(&nd_region->dev)) {
 			available += nd_pmem_available_dpa(nd_region,
 					nd_mapping, &overlap);
 			if (overlap > blk_max_overlap) {
@@ -469,10 +474,10 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	int type = nd_region_to_nstype(nd_region);
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_pfn_seed.attr)
+	if (!is_memory(dev) && a == &dev_attr_pfn_seed.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_dax_seed.attr)
+	if (!is_memory(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
 	if (a != &dev_attr_set_cookie.attr
@@ -483,7 +488,7 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 				|| type == ND_DEVICE_NAMESPACE_BLK)
 			&& a == &dev_attr_available_size.attr)
 		return a->mode;
-	else if (is_nd_pmem(dev) && nd_set)
+	else if (is_memory(dev) && nd_set)
 		return a->mode;
 
 	return 0;
@@ -535,7 +540,7 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 {
 	struct nd_region *nd_region;
 
-	if (!probe && (is_nd_pmem(dev) || is_nd_blk(dev))) {
+	if (!probe && is_nd_region(dev)) {
 		int i;
 
 		nd_region = to_nd_region(dev);
@@ -553,12 +558,8 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
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
