Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAA5420082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:28 -0700 (PDT)
Subject: [PATCH 4/9] libnvdimm,
 label: populate the type_guid property for v1.2 namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:12 -0700
Message-ID: <149698495194.11651.5290943969549755841.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The type_guid refers to the "Address Range Type GUID" for the region
backing a namespace as defined the ACPI NFIT (NVDIMM Firmware Interface
Table). This 'type' identifier specifies an access mechanism for the
given namespace. This capability replaces the confusing usage of the
'NSLABEL_FLAG_LOCAL' flag to indicate a block-aperture-mode namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c        |   15 +++++++---
 drivers/nvdimm/label.c          |    6 ++++
 drivers/nvdimm/namespace_devs.c |   57 ++++++++++++++++++++++++++-------------
 include/linux/libnvdimm.h       |    3 ++
 4 files changed, 57 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index db21f5b62562..83ee3c829411 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1743,15 +1743,17 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	struct nfit_set_info2 *info2;
 	struct nfit_set_info *info;
 
+	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
+	if (!nd_set)
+		return -ENOMEM;
+	ndr_desc->nd_set = nd_set;
+	guid_copy(&nd_set->type_guid, (guid_t *) spa->range_guid);
+
 	if (spa_type == NFIT_SPA_PM || spa_type == NFIT_SPA_VOLATILE)
 		/* pass */;
 	else
 		return 0;
 
-	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
-	if (!nd_set)
-		return -ENOMEM;
-
 	info = devm_kzalloc(dev, sizeof_nfit_set_info(nr), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
@@ -2228,7 +2230,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 	struct acpi_nfit_system_address *spa = nfit_spa->spa;
 	struct nd_blk_region_desc *ndbr_desc;
 	struct nfit_mem *nfit_mem;
-	int blk_valid = 0;
+	int blk_valid = 0, rc;
 
 	if (!nvdimm) {
 		dev_err(acpi_desc->dev, "spa%d dimm: %#x not found\n",
@@ -2260,6 +2262,9 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
 		ndbr_desc = to_blk_region_desc(ndr_desc);
 		ndbr_desc->enable = acpi_nfit_blk_region_enable;
 		ndbr_desc->do_io = acpi_desc->blk_do_io;
+		rc = acpi_nfit_init_interleave_set(acpi_desc, ndr_desc, spa);
+		if (rc)
+			return rc;
 		nfit_spa->nd_region = nvdimm_blk_region_create(acpi_desc->nvdimm_bus,
 				ndr_desc);
 		if (!nfit_spa->nd_region)
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 1aacd4866c76..d8b87d3a0ebe 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -553,6 +553,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos)
 {
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
@@ -597,6 +598,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_label->rawsize = __cpu_to_le64(resource_size(res));
 	nd_label->dpa = __cpu_to_le64(res->start);
 	nd_label->slot = __cpu_to_le32(slot);
+	if (namespace_label_has(ndd, type_guid))
+		guid_copy(&nd_label->type_guid, &nd_set->type_guid);
 	nd_dbg_dpa(nd_region, ndd, res, "%s\n", __func__);
 
 	/* update label */
@@ -684,6 +687,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 		int num_labels)
 {
 	int i, alloc, victims, nfree, old_num_resources, nlabel, rc = -ENXIO;
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_namespace_label *nd_label;
 	struct nd_label_ent *label_ent, *e;
@@ -788,6 +792,8 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nd_label->rawsize = __cpu_to_le64(resource_size(res));
 		nd_label->lbasize = __cpu_to_le64(nsblk->lbasize);
 		nd_label->slot = __cpu_to_le32(slot);
+		if (namespace_label_has(ndd, type_guid))
+			guid_copy(&nd_label->type_guid, &nd_set->type_guid);
 
 		/* update label */
 		offset = nd_label_offset(ndd, nd_label);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index e034b003a5e2..e101aec186c7 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1639,6 +1639,8 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_interleave_set *nd_set = nd_region->nd_set;
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nd_label_ent *label_ent;
 		bool found_uuid = false;
 
@@ -1659,8 +1661,17 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
 				continue;
 
+			if (namespace_label_has(ndd, type_guid)
+					&& !guid_equal(&nd_set->type_guid,
+						&nd_label->type_guid)) {
+				dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
+						nd_set->type_guid.b,
+						nd_label->type_guid.b);
+				continue;
+			}
+
 			if (found_uuid) {
-				dev_dbg(to_ndd(nd_mapping)->dev,
+				dev_dbg(ndd->dev,
 						"%s duplicate entry for uuid\n",
 						__func__);
 				return false;
@@ -2047,12 +2058,21 @@ struct device *create_namespace_blk(struct nd_region *nd_region,
 {
 
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_namespace_blk *nsblk;
 	char name[NSLABEL_NAME_LEN];
 	struct device *dev = NULL;
 	struct resource *res;
 
+	if (namespace_label_has(ndd, type_guid)
+			&& !guid_equal(&nd_set->type_guid,
+				&nd_label->type_guid)) {
+		dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
+				nd_set->type_guid.b, nd_label->type_guid.b);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
 	if (!nsblk)
 		return ERR_PTR(-ENOMEM);
@@ -2144,31 +2164,30 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		kfree(devs);
 		devs = __devs;
 
-		if (is_nd_blk(&nd_region->dev)) {
+		if (is_nd_blk(&nd_region->dev))
 			dev = create_namespace_blk(nd_region, nd_label, count);
-			if (IS_ERR(dev))
-				goto err;
-			devs[count++] = dev;
-		} else {
+		else {
 			struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 			struct nd_namespace_index *nsindex;
 
 			nsindex = to_namespace_index(ndd, ndd->ns_current);
 			dev = create_namespace_pmem(nd_region, nsindex, nd_label);
-			if (IS_ERR(dev)) {
-				switch (PTR_ERR(dev)) {
-				case -EAGAIN:
-					/* skip invalid labels */
-					continue;
-				case -ENODEV:
-					/* fallthrough to seed creation */
-					break;
-				default:
-					goto err;
-				}
-			} else
-				devs[count++] = dev;
 		}
+
+		if (IS_ERR(dev)) {
+			switch (PTR_ERR(dev)) {
+			case -EAGAIN:
+				/* skip invalid labels */
+				continue;
+			case -ENODEV:
+				/* fallthrough to seed creation */
+				break;
+			default:
+				goto err;
+			}
+		} else
+			devs[count++] = dev;
+
 	}
 
 	dev_dbg(&nd_region->dev, "%s: discovered %d %s namespace%s\n",
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 722cdf21429f..4b9f178c82e6 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/sizes.h>
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 enum {
 	/* when a dimm supports both PMEM and BLK access a label is required */
@@ -77,6 +78,8 @@ struct nd_interleave_set {
 	u64 cookie2;
 	/* compatibility with initial buggy Linux implementation */
 	u64 altcookie;
+
+	guid_t type_guid;
 };
 
 struct nd_mapping_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
