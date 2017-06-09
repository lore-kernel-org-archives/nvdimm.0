Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CB5420082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:44 -0700 (PDT)
Subject: [PATCH 7/9] libnvdimm, label: add v1.2 label checksum support
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:27 -0700
Message-ID: <149698496760.11651.5395658910793252806.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The v1.2 namespace label specification adds a fletcher checksum to each
label instance. Add generation and validation support for the new field.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index d7f9916c6ed5..c503362a03c7 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -326,7 +326,8 @@ static bool preamble_next(struct nvdimm_drvdata *ndd,
 			free, nslot);
 }
 
-static bool slot_valid(struct nd_namespace_label *nd_label, u32 slot)
+static bool slot_valid(struct nvdimm_drvdata *ndd,
+		struct nd_namespace_label *nd_label, u32 slot)
 {
 	/* check that we are written where we expect to be written */
 	if (slot != __le32_to_cpu(nd_label->slot))
@@ -337,6 +338,21 @@ static bool slot_valid(struct nd_namespace_label *nd_label, u32 slot)
 				| __le64_to_cpu(nd_label->rawsize)) % SZ_4K)
 		return false;
 
+	/* check checksum */
+	if (namespace_label_has(ndd, checksum)) {
+		u64 sum, sum_save;
+
+		sum_save = __le64_to_cpu(nd_label->checksum);
+		nd_label->checksum = __cpu_to_le64(0);
+		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
+		nd_label->checksum = __cpu_to_le64(sum_save);
+		if (sum != sum_save) {
+			dev_dbg(ndd->dev, "%s fail checksum. slot: %d expect: %#llx\n",
+				__func__, slot, sum);
+			return false;
+		}
+	}
+
 	return true;
 }
 
@@ -359,7 +375,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 
 		nd_label = to_label(ndd, slot);
 
-		if (!slot_valid(nd_label, slot))
+		if (!slot_valid(ndd, nd_label, slot))
 			continue;
 
 		memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
@@ -391,7 +407,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 
 		nd_label = to_label(ndd, slot);
 
-		if (!slot_valid(nd_label, slot)) {
+		if (!slot_valid(ndd, nd_label, slot)) {
 			u32 label_slot = __le32_to_cpu(nd_label->slot);
 			u64 size = __le64_to_cpu(nd_label->rawsize);
 			u64 dpa = __le64_to_cpu(nd_label->dpa);
@@ -419,7 +435,7 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 		struct nd_namespace_label *nd_label;
 
 		nd_label = to_label(ndd, slot);
-		if (!slot_valid(nd_label, slot))
+		if (!slot_valid(ndd, nd_label, slot))
 			continue;
 
 		if (n-- == 0)
@@ -600,6 +616,13 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_label->slot = __cpu_to_le32(slot);
 	if (namespace_label_has(ndd, type_guid))
 		guid_copy(&nd_label->type_guid, &nd_set->type_guid);
+	if (namespace_label_has(ndd, checksum)) {
+		u64 sum;
+
+		nd_label->checksum = __cpu_to_le64(0);
+		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
+		nd_label->checksum = __cpu_to_le64(sum);
+	}
 	nd_dbg_dpa(nd_region, ndd, res, "%s\n", __func__);
 
 	/* update label */
@@ -825,6 +848,14 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nd_label->slot = __cpu_to_le32(slot);
 		if (namespace_label_has(ndd, type_guid))
 			guid_copy(&nd_label->type_guid, &nd_set->type_guid);
+		if (namespace_label_has(ndd, checksum)) {
+			u64 sum;
+
+			nd_label->checksum = __cpu_to_le64(0);
+			sum = nd_fletcher64(nd_label,
+					sizeof_namespace_label(ndd), 1);
+			nd_label->checksum = __cpu_to_le64(sum);
+		}
 
 		/* update label */
 		offset = nd_label_offset(ndd, nd_label);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
