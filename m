Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DB2720082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:18 -0700 (PDT)
Subject: [PATCH 2/9] libnvdimm, label: add v1.2 interleave-set-cookie algorithm
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:01 -0700
Message-ID: <149698494141.11651.11254238772643685302.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The interleave-set-cookie algorithm is extended to incorporate all the
same components that are used to generate an nvdimm unique-id. For
backwards compatibility we still maintain the old v1.1 definition.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c        |   53 ++++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/label.c          |    3 +-
 drivers/nvdimm/namespace_devs.c |    9 +++++--
 drivers/nvdimm/nd.h             |    3 +-
 drivers/nvdimm/region_devs.c    |   43 ++++++++++++++++++++++++++++----
 include/linux/libnvdimm.h       |    5 +++-
 6 files changed, 104 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 097eff0b963d..db21f5b62562 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1663,12 +1663,29 @@ struct nfit_set_info {
 	} mapping[0];
 };
 
+struct nfit_set_info2 {
+	struct nfit_set_info_map2 {
+		u64 region_offset;
+		u32 serial_number;
+		u16 vendor_id;
+		u16 manufacturing_date;
+		u8  manufacturing_location;
+		u8  reserved[31];
+	} mapping[0];
+};
+
 static size_t sizeof_nfit_set_info(int num_mappings)
 {
 	return sizeof(struct nfit_set_info)
 		+ num_mappings * sizeof(struct nfit_set_info_map);
 }
 
+static size_t sizeof_nfit_set_info2(int num_mappings)
+{
+	return sizeof(struct nfit_set_info2)
+		+ num_mappings * sizeof(struct nfit_set_info_map2);
+}
+
 static int cmp_map_compat(const void *m0, const void *m1)
 {
 	const struct nfit_set_info_map *map0 = m0;
@@ -1690,6 +1707,18 @@ static int cmp_map(const void *m0, const void *m1)
 	return 0;
 }
 
+static int cmp_map2(const void *m0, const void *m1)
+{
+	const struct nfit_set_info_map2 *map0 = m0;
+	const struct nfit_set_info_map2 *map1 = m1;
+
+	if (map0->region_offset < map1->region_offset)
+		return -1;
+	else if (map0->region_offset > map1->region_offset)
+		return 1;
+	return 0;
+}
+
 /* Retrieve the nth entry referencing this spa */
 static struct acpi_nfit_memory_map *memdev_from_spa(
 		struct acpi_nfit_desc *acpi_desc, u16 range_index, int n)
@@ -1711,6 +1740,7 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	struct device *dev = acpi_desc->dev;
 	struct nd_interleave_set *nd_set;
 	u16 nr = ndr_desc->num_mappings;
+	struct nfit_set_info2 *info2;
 	struct nfit_set_info *info;
 
 	if (spa_type == NFIT_SPA_PM || spa_type == NFIT_SPA_VOLATILE)
@@ -1725,9 +1755,15 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	info = devm_kzalloc(dev, sizeof_nfit_set_info(nr), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
+
+	info2 = devm_kzalloc(dev, sizeof_nfit_set_info2(nr), GFP_KERNEL);
+	if (!info2)
+		return -ENOMEM;
+
 	for (i = 0; i < nr; i++) {
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
 		struct nfit_set_info_map *map = &info->mapping[i];
+		struct nfit_set_info_map2 *map2 = &info2->mapping[i];
 		struct nvdimm *nvdimm = mapping->nvdimm;
 		struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
 		struct acpi_nfit_memory_map *memdev = memdev_from_spa(acpi_desc,
@@ -1740,19 +1776,32 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 
 		map->region_offset = memdev->region_offset;
 		map->serial_number = nfit_mem->dcr->serial_number;
+
+		map2->region_offset = memdev->region_offset;
+		map2->serial_number = nfit_mem->dcr->serial_number;
+		map2->vendor_id = nfit_mem->dcr->vendor_id;
+		map2->manufacturing_date = nfit_mem->dcr->manufacturing_date;
+		map2->manufacturing_location = nfit_mem->dcr->manufacturing_location;
 	}
 
+	/* v1.1 namespaces */
 	sort(&info->mapping[0], nr, sizeof(struct nfit_set_info_map),
 			cmp_map, NULL);
-	nd_set->cookie = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
+	nd_set->cookie1 = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
+
+	/* v1.2 namespaces */
+	sort(&info2->mapping[0], nr, sizeof(struct nfit_set_info_map2),
+			cmp_map2, NULL);
+	nd_set->cookie2 = nd_fletcher64(info, sizeof_nfit_set_info2(nr), 0);
 
-	/* support namespaces created with the wrong sort order */
+	/* support v1.1 namespaces created with the wrong sort order */
 	sort(&info->mapping[0], nr, sizeof(struct nfit_set_info_map),
 			cmp_map_compat, NULL);
 	nd_set->altcookie = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
 
 	ndr_desc->nd_set = nd_set;
 	devm_kfree(dev, info);
+	devm_kfree(dev, info2);
 
 	return 0;
 }
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index d6233d220bfd..1aacd4866c76 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -553,7 +553,6 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos)
 {
-	u64 cookie = nd_region_interleave_set_cookie(nd_region);
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
@@ -563,11 +562,13 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	unsigned long *free;
 	u32 nslot, slot;
 	size_t offset;
+	u64 cookie;
 	int rc;
 
 	if (!preamble_next(ndd, &nsindex, &free, &nslot))
 		return -ENXIO;
 
+	cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
 	nd_label_gen_id(&label_id, nspm->uuid, 0);
 	for_each_dpa_resource(ndd, res)
 		if (strcmp(res->name, label_id.id) == 0)
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2f9dfbd2dbec..51f304fe8a52 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1698,10 +1698,11 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
  * @nd_label: target pmem namespace label to evaluate
  */
 struct device *create_namespace_pmem(struct nd_region *nd_region,
+		struct nd_namespace_index *nsindex,
 		struct nd_namespace_label *nd_label)
 {
+	u64 cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
 	u64 altcookie = nd_region_interleave_set_altcookie(nd_region);
-	u64 cookie = nd_region_interleave_set_cookie(nd_region);
 	struct nd_label_ent *label_ent;
 	struct nd_namespace_pmem *nspm;
 	struct nd_mapping *nd_mapping;
@@ -2108,7 +2109,11 @@ static struct device **scan_labels(struct nd_region *nd_region)
 				goto err;
 			devs[count++] = dev;
 		} else {
-			dev = create_namespace_pmem(nd_region, nd_label);
+			struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+			struct nd_namespace_index *nsindex;
+
+			nsindex = to_namespace_index(ndd, ndd->ns_current);
+			dev = create_namespace_pmem(nd_region, nsindex, nd_label);
 			if (IS_ERR(dev)) {
 				switch (PTR_ERR(dev)) {
 				case -EAGAIN:
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 28d9f4481547..ad4e518940c9 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -336,7 +336,8 @@ static inline struct device *nd_dax_create(struct nd_region *nd_region)
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
-u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
+u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
+		struct nd_namespace_index *nsindex);
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b550edf2571f..282b8991ea83 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -307,13 +307,41 @@ static ssize_t set_cookie_show(struct device *dev,
 {
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	ssize_t rc = 0;
 
 	if (is_nd_pmem(dev) && nd_set)
 		/* pass, should be precluded by region_visible */;
 	else
 		return -ENXIO;
 
-	return sprintf(buf, "%#llx\n", nd_set->cookie);
+	/*
+	 * The cookie to show depends on which specification of the
+	 * labels we are using. If there are not labels then default to
+	 * the v1.1 namespace label cookie definition. To read all this
+	 * data we need to wait for probing to settle.
+	 */
+	device_lock(dev);
+	nvdimm_bus_lock(dev);
+	wait_nvdimm_bus_probe_idle(dev);
+	if (nd_region->ndr_mappings) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		if (ndd) {
+			struct nd_namespace_index *nsindex;
+
+			nsindex = to_namespace_index(ndd, ndd->ns_current);
+			rc = sprintf(buf, "%#llx\n",
+					nd_region_interleave_set_cookie(nd_region,
+						nsindex));
+		}
+	}
+	nvdimm_bus_unlock(dev);
+	device_unlock(dev);
+
+	if (rc)
+		return rc;
+	return sprintf(buf, "%#llx\n", nd_set->cookie1);
 }
 static DEVICE_ATTR_RO(set_cookie);
 
@@ -564,13 +592,18 @@ struct attribute_group nd_region_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_region_attribute_group);
 
-u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
+u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
+		struct nd_namespace_index *nsindex)
 {
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 
-	if (nd_set)
-		return nd_set->cookie;
-	return 0;
+	if (!nd_set)
+		return 0;
+
+	if (nsindex && __le16_to_cpu(nsindex->major) == 1
+			&& __le16_to_cpu(nsindex->minor) == 1)
+		return nd_set->cookie1;
+	return nd_set->cookie2;
 }
 
 u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 6c807017128d..722cdf21429f 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -71,7 +71,10 @@ struct nd_cmd_desc {
 };
 
 struct nd_interleave_set {
-	u64 cookie;
+	/* v1.1 definition of the interleave-set-cookie algorithm */
+	u64 cookie1;
+	/* v1.2 definition of the interleave-set-cookie algorithm */
+	u64 cookie2;
 	/* compatibility with initial buggy Linux implementation */
 	u64 altcookie;
 };

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
