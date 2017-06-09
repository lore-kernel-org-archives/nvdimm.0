Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4448420082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:34 -0700 (PDT)
Subject: [PATCH 5/9] libnvdimm,
 label: populate 'isetcookie' for blk-aperture namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:17 -0700
Message-ID: <149698495727.11651.1303472971386238629.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Starting with the v1.2 definition of namespace labels, the isetcookie
field is populated and validated for blk-aperture namespaces. This adds
some safety against inadvertent copying of namespace labels from one
DIMM-device to another.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c        |    7 +------
 drivers/nvdimm/label.c          |   12 +++++++++++-
 drivers/nvdimm/namespace_devs.c |   20 ++++++++++++++------
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 83ee3c829411..47d2dbb45695 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1736,12 +1736,12 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 		struct nd_region_desc *ndr_desc,
 		struct acpi_nfit_system_address *spa)
 {
-	int i, spa_type = nfit_spa_type(spa);
 	struct device *dev = acpi_desc->dev;
 	struct nd_interleave_set *nd_set;
 	u16 nr = ndr_desc->num_mappings;
 	struct nfit_set_info2 *info2;
 	struct nfit_set_info *info;
+	int i;
 
 	nd_set = devm_kzalloc(dev, sizeof(*nd_set), GFP_KERNEL);
 	if (!nd_set)
@@ -1749,11 +1749,6 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	ndr_desc->nd_set = nd_set;
 	guid_copy(&nd_set->type_guid, (guid_t *) spa->range_guid);
 
-	if (spa_type == NFIT_SPA_PM || spa_type == NFIT_SPA_VOLATILE)
-		/* pass */;
-	else
-		return 0;
-
 	info = devm_kzalloc(dev, sizeof_nfit_set_info(nr), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index d8b87d3a0ebe..ba0582fb0e21 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -787,7 +787,17 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nd_label->flags = __cpu_to_le32(NSLABEL_FLAG_LOCAL);
 		nd_label->nlabel = __cpu_to_le16(0); /* N/A */
 		nd_label->position = __cpu_to_le16(0); /* N/A */
-		nd_label->isetcookie = __cpu_to_le64(0); /* N/A */
+
+		/*
+		 * Use the presence of the type_guid as a flag to
+		 * determine isetcookie usage for blk-aperture
+		 * namespaces.
+		 */
+		if (namespace_label_has(ndd, type_guid))
+			nd_label->isetcookie = __cpu_to_le64(nd_set->cookie2);
+		else
+			nd_label->isetcookie = __cpu_to_le64(0); /* N/A */
+
 		nd_label->dpa = __cpu_to_le64(res->start);
 		nd_label->rawsize = __cpu_to_le64(resource_size(res));
 		nd_label->lbasize = __cpu_to_le64(nsblk->lbasize);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index e101aec186c7..7aba9a569c8e 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2065,12 +2065,20 @@ struct device *create_namespace_blk(struct nd_region *nd_region,
 	struct device *dev = NULL;
 	struct resource *res;
 
-	if (namespace_label_has(ndd, type_guid)
-			&& !guid_equal(&nd_set->type_guid,
-				&nd_label->type_guid)) {
-		dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
-				nd_set->type_guid.b, nd_label->type_guid.b);
-		return ERR_PTR(-EAGAIN);
+	if (namespace_label_has(ndd, type_guid)) {
+		if (!guid_equal(&nd_set->type_guid, &nd_label->type_guid)) {
+			dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
+					nd_set->type_guid.b,
+					nd_label->type_guid.b);
+			return ERR_PTR(-EAGAIN);
+		}
+
+		if (nd_label->isetcookie != __cpu_to_le64(nd_set->cookie2)) {
+			dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n",
+					nd_set->cookie2,
+					__le64_to_cpu(nd_label->isetcookie));
+			return ERR_PTR(-EAGAIN);
+		}
 	}
 
 	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
