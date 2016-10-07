Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 134AA1A1E73
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:37 -0700 (PDT)
Subject: [PATCH 10/14] libnvdimm,
 namespace: update label implementation for multi-pmem
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:34 -0700
Message-ID: <147585837408.22349.11125786887021701571.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Instead of assuming that there will only ever be one allocated range at
the start of the region, account for additional namespaces that might
start at an offset from the region base.

After this change pmem namespaces now have a reason to carry an array of
resources similar to blk.  Unifying the resource tracking infrastructure
in nd_namespace_common is a future cleanup candidate.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   72 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index c37357210428..fac7cabe8f56 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -494,12 +494,13 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos)
 {
-	u64 cookie = nd_region_interleave_set_cookie(nd_region), rawsize;
+	u64 cookie = nd_region_interleave_set_cookie(nd_region);
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_namespace_label *victim_label;
+	struct nd_label_ent *label_ent, *victim = NULL;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
-	struct nd_label_ent *label_ent;
+	struct nd_label_id label_id;
+	struct resource *res;
 	unsigned long *free;
 	u32 nslot, slot;
 	size_t offset;
@@ -508,6 +509,16 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	if (!preamble_next(ndd, &nsindex, &free, &nslot))
 		return -ENXIO;
 
+	nd_label_gen_id(&label_id, nspm->uuid, 0);
+	for_each_dpa_resource(ndd, res)
+		if (strcmp(res->name, label_id.id) == 0)
+			break;
+
+	if (!res) {
+		WARN_ON_ONCE(1);
+		return -ENXIO;
+	}
+
 	/* allocate and write the label to the staging (next) index */
 	slot = nd_label_alloc_slot(ndd);
 	if (slot == UINT_MAX)
@@ -523,11 +534,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
 	nd_label->position = __cpu_to_le16(pos);
 	nd_label->isetcookie = __cpu_to_le64(cookie);
-	rawsize = div_u64(resource_size(&nspm->nsio.res),
-			nd_region->ndr_mappings);
-	nd_label->rawsize = __cpu_to_le64(rawsize);
-	nd_label->dpa = __cpu_to_le64(nd_mapping->start);
+	nd_label->rawsize = __cpu_to_le64(resource_size(res));
+	nd_label->dpa = __cpu_to_le64(res->start);
 	nd_label->slot = __cpu_to_le32(slot);
+	nd_dbg_dpa(nd_region, ndd, res, "%s\n", __func__);
 
 	/* update label */
 	offset = nd_label_offset(ndd, nd_label);
@@ -538,22 +548,39 @@ static int __pmem_label_update(struct nd_region *nd_region,
 
 	/* Garbage collect the previous label */
 	mutex_lock(&nd_mapping->lock);
-	label_ent = list_first_entry_or_null(&nd_mapping->labels,
-			typeof(*label_ent), list);
-	WARN_ON(!label_ent);
-	victim_label = label_ent ? label_ent->label : NULL;
-	if (victim_label) {
-		label_ent->label = NULL;
-		slot = to_slot(ndd, victim_label);
-		nd_label_free_slot(ndd, slot);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		if (!label_ent->label)
+			continue;
+		if (memcmp(nspm->uuid, label_ent->label->uuid,
+					NSLABEL_UUID_LEN) != 0)
+			continue;
+		victim = label_ent;
+		list_move_tail(&victim->list, &nd_mapping->labels);
+		break;
+	}
+	if (victim) {
 		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
+		slot = to_slot(ndd, victim->label);
+		nd_label_free_slot(ndd, slot);
+		victim->label = NULL;
 	}
 
 	/* update index */
 	rc = nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
-	if (rc == 0 && label_ent)
-		label_ent->label = nd_label;
+	if (rc == 0) {
+		list_for_each_entry(label_ent, &nd_mapping->labels, list)
+			if (!label_ent->label) {
+				label_ent->label = nd_label;
+				nd_label = NULL;
+				break;
+			}
+		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
+				"failed to track label: %d\n",
+				to_slot(ndd, nd_label));
+		if (nd_label)
+			rc = -ENXIO;
+	}
 	mutex_unlock(&nd_mapping->lock);
 
 	return rc;
@@ -899,7 +926,9 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		int rc;
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct resource *res;
+		int rc, count = 0;
 
 		if (size == 0) {
 			rc = del_labels(nd_mapping, nspm->uuid);
@@ -908,7 +937,12 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 			continue;
 		}
 
-		rc = init_labels(nd_mapping, 1);
+		for_each_dpa_resource(ndd, res)
+			if (strncmp(res->name, "pmem", 3) == 0)
+				count++;
+		WARN_ON_ONCE(!count);
+
+		rc = init_labels(nd_mapping, count);
 		if (rc < 0)
 			return rc;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
