Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CA2D1A1E31
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:41:55 -0700 (PDT)
Subject: [PATCH 02/14] libnvdimm,
 label: convert label tracking to a linked list
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:38:51 -0700
Message-ID: <147585833188.22349.14776633482376714877.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for enabling multiple namespaces per pmem region, convert
the label tracking to use a linked list.  In particular this will allow
select_pmem_id() to move labels from the unvalidated state to the
validated state.  Currently we only track one validated set per-region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c          |  136 +++++++++++++++++--------------
 drivers/nvdimm/namespace_devs.c |  173 +++++++++++++++++++++++++++------------
 drivers/nvdimm/nd-core.h        |    1 
 drivers/nvdimm/nd.h             |   16 +++-
 drivers/nvdimm/region_devs.c    |   19 ++++
 5 files changed, 225 insertions(+), 120 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 96526dcfdd37..c37357210428 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -499,6 +499,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	struct nd_namespace_label *victim_label;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
 	unsigned long *free;
 	u32 nslot, slot;
 	size_t offset;
@@ -536,8 +537,13 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return rc;
 
 	/* Garbage collect the previous label */
-	victim_label = nd_mapping->labels[0];
+	mutex_lock(&nd_mapping->lock);
+	label_ent = list_first_entry_or_null(&nd_mapping->labels,
+			typeof(*label_ent), list);
+	WARN_ON(!label_ent);
+	victim_label = label_ent ? label_ent->label : NULL;
 	if (victim_label) {
+		label_ent->label = NULL;
 		slot = to_slot(ndd, victim_label);
 		nd_label_free_slot(ndd, slot);
 		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
@@ -546,28 +552,11 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	/* update index */
 	rc = nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
-	if (rc < 0)
-		return rc;
-
-	nd_mapping->labels[0] = nd_label;
-
-	return 0;
-}
-
-static void del_label(struct nd_mapping *nd_mapping, int l)
-{
-	struct nd_namespace_label *next_label, *nd_label;
-	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	unsigned int slot;
-	int j;
+	if (rc == 0 && label_ent)
+		label_ent->label = nd_label;
+	mutex_unlock(&nd_mapping->lock);
 
-	nd_label = nd_mapping->labels[l];
-	slot = to_slot(ndd, nd_label);
-	dev_vdbg(ndd->dev, "%s: clear: %d\n", __func__, slot);
-
-	for (j = l; (next_label = nd_mapping->labels[j + 1]); j++)
-		nd_mapping->labels[j] = next_label;
-	nd_mapping->labels[j] = NULL;
+	return rc;
 }
 
 static bool is_old_resource(struct resource *res, struct resource **list, int n)
@@ -607,14 +596,16 @@ static int __blk_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_blk *nsblk,
 		int num_labels)
 {
-	int i, l, alloc, victims, nfree, old_num_resources, nlabel, rc = -ENXIO;
+	int i, alloc, victims, nfree, old_num_resources, nlabel, rc = -ENXIO;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_namespace_label *nd_label;
+	struct nd_label_ent *label_ent, *e;
 	struct nd_namespace_index *nsindex;
 	unsigned long *free, *victim_map = NULL;
 	struct resource *res, **old_res_list;
 	struct nd_label_id label_id;
 	u8 uuid[NSLABEL_UUID_LEN];
+	LIST_HEAD(list);
 	u32 nslot, slot;
 
 	if (!preamble_next(ndd, &nsindex, &free, &nslot))
@@ -736,15 +727,22 @@ static int __blk_label_update(struct nd_region *nd_region,
 	 * entries in nd_mapping->labels
 	 */
 	nlabel = 0;
-	for_each_label(l, nd_label, nd_mapping->labels) {
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
+		nd_label = label_ent->label;
+		if (!nd_label)
+			continue;
 		nlabel++;
 		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
 		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
 			continue;
 		nlabel--;
-		del_label(nd_mapping, l);
-		l--; /* retry with the new label at this index */
+		list_move(&label_ent->list, &list);
+		label_ent->label = NULL;
 	}
+	list_splice_tail_init(&list, &nd_mapping->labels);
+	mutex_unlock(&nd_mapping->lock);
+
 	if (nlabel + nsblk->num_resources > num_labels) {
 		/*
 		 * Bug, we can't end up with more resources than
@@ -755,6 +753,15 @@ static int __blk_label_update(struct nd_region *nd_region,
 		goto out;
 	}
 
+	mutex_lock(&nd_mapping->lock);
+	label_ent = list_first_entry_or_null(&nd_mapping->labels,
+			typeof(*label_ent), list);
+	if (!label_ent) {
+		WARN_ON(1);
+		mutex_unlock(&nd_mapping->lock);
+		rc = -ENXIO;
+		goto out;
+	}
 	for_each_clear_bit_le(slot, free, nslot) {
 		nd_label = nd_label_base(ndd) + slot;
 		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
@@ -762,11 +769,19 @@ static int __blk_label_update(struct nd_region *nd_region,
 			continue;
 		res = to_resource(ndd, nd_label);
 		res->flags &= ~DPA_RESOURCE_ADJUSTED;
-		dev_vdbg(&nsblk->common.dev, "assign label[%d] slot: %d\n",
-				l, slot);
-		nd_mapping->labels[l++] = nd_label;
+		dev_vdbg(&nsblk->common.dev, "assign label slot: %d\n", slot);
+		list_for_each_entry_from(label_ent, &nd_mapping->labels, list) {
+			if (label_ent->label)
+				continue;
+			label_ent->label = nd_label;
+			nd_label = NULL;
+			break;
+		}
+		if (nd_label)
+			dev_WARN(&nsblk->common.dev,
+					"failed to track label slot%d\n", slot);
 	}
-	nd_mapping->labels[l] = NULL;
+	mutex_unlock(&nd_mapping->lock);
 
  out:
 	kfree(old_res_list);
@@ -788,32 +803,28 @@ static int __blk_label_update(struct nd_region *nd_region,
 
 static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 {
-	int i, l, old_num_labels = 0;
+	int i, old_num_labels = 0;
+	struct nd_label_ent *label_ent;
 	struct nd_namespace_index *nsindex;
-	struct nd_namespace_label *nd_label;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	size_t size = (num_labels + 1) * sizeof(struct nd_namespace_label *);
 
-	for_each_label(l, nd_label, nd_mapping->labels)
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
 		old_num_labels++;
+	mutex_unlock(&nd_mapping->lock);
 
 	/*
 	 * We need to preserve all the old labels for the mapping so
 	 * they can be garbage collected after writing the new labels.
 	 */
-	if (num_labels > old_num_labels) {
-		struct nd_namespace_label **labels;
-
-		labels = krealloc(nd_mapping->labels, size, GFP_KERNEL);
-		if (!labels)
+	for (i = old_num_labels; i < num_labels; i++) {
+		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
+		if (!label_ent)
 			return -ENOMEM;
-		nd_mapping->labels = labels;
+		mutex_lock(&nd_mapping->lock);
+		list_add_tail(&label_ent->list, &nd_mapping->labels);
+		mutex_unlock(&nd_mapping->lock);
 	}
-	if (!nd_mapping->labels)
-		return -ENOMEM;
-
-	for (i = old_num_labels; i <= num_labels; i++)
-		nd_mapping->labels[i] = NULL;
 
 	if (ndd->ns_current == -1 || ndd->ns_next == -1)
 		/* pass */;
@@ -837,42 +848,45 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_namespace_label *nd_label;
+	struct nd_label_ent *label_ent, *e;
 	struct nd_namespace_index *nsindex;
 	u8 label_uuid[NSLABEL_UUID_LEN];
-	int l, num_freed = 0;
 	unsigned long *free;
+	LIST_HEAD(list);
 	u32 nslot, slot;
+	int active = 0;
 
 	if (!uuid)
 		return 0;
 
 	/* no index || no labels == nothing to delete */
-	if (!preamble_next(ndd, &nsindex, &free, &nslot)
-			|| !nd_mapping->labels)
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
 		return 0;
 
-	for_each_label(l, nd_label, nd_mapping->labels) {
+	mutex_lock(&nd_mapping->lock);
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
+		struct nd_namespace_label *nd_label = label_ent->label;
+
+		if (!nd_label)
+			continue;
+		active++;
 		memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
 		if (memcmp(label_uuid, uuid, NSLABEL_UUID_LEN) != 0)
 			continue;
+		active--;
 		slot = to_slot(ndd, nd_label);
 		nd_label_free_slot(ndd, slot);
 		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
-		del_label(nd_mapping, l);
-		num_freed++;
-		l--; /* retry with new label at this index */
+		list_move_tail(&label_ent->list, &list);
+		label_ent->label = NULL;
 	}
+	list_splice_tail_init(&list, &nd_mapping->labels);
 
-	if (num_freed > l) {
-		/*
-		 * num_freed will only ever be > l when we delete the last
-		 * label
-		 */
-		kfree(nd_mapping->labels);
-		nd_mapping->labels = NULL;
-		dev_dbg(ndd->dev, "%s: no more labels\n", __func__);
+	if (active == 0) {
+		nd_mapping_free_labels(nd_mapping);
+		dev_dbg(ndd->dev, "%s: no more active labels\n", __func__);
 	}
+	mutex_unlock(&nd_mapping->lock);
 
 	return nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 4f0a21308417..9f4188c78120 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
+#include <linux/list.h>
 #include <linux/nd.h>
 #include "nd-core.h"
 #include "nd.h"
@@ -1089,7 +1090,7 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 		 *
 		 * FIXME: can we delete uuid with zero dpa allocated?
 		 */
-		if (nd_mapping->labels)
+		if (list_empty(&nd_mapping->labels))
 			return -EBUSY;
 	}
 
@@ -1491,14 +1492,19 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		struct nd_namespace_label *nd_label;
+		struct nd_label_ent *label_ent;
 		bool found_uuid = false;
-		int l;
 
-		for_each_label(l, nd_label, nd_mapping->labels) {
-			u64 isetcookie = __le64_to_cpu(nd_label->isetcookie);
-			u16 position = __le16_to_cpu(nd_label->position);
-			u16 nlabel = __le16_to_cpu(nd_label->nlabel);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			struct nd_namespace_label *nd_label = label_ent->label;
+			u16 position, nlabel;
+			u64 isetcookie;
+
+			if (!nd_label)
+				continue;
+			isetcookie = __le64_to_cpu(nd_label->isetcookie);
+			position = __le16_to_cpu(nd_label->position);
+			nlabel = __le16_to_cpu(nd_label->nlabel);
 
 			if (isetcookie != cookie)
 				continue;
@@ -1528,7 +1534,6 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 
 static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 {
-	struct nd_namespace_label *select = NULL;
 	int i;
 
 	if (!pmem_id)
@@ -1536,35 +1541,47 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		struct nd_namespace_label *nd_label;
+		struct nd_namespace_label *nd_label = NULL;
 		u64 hw_start, hw_end, pmem_start, pmem_end;
-		int l;
+		struct nd_label_ent *label_ent;
 
-		for_each_label(l, nd_label, nd_mapping->labels)
+		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+			nd_label = label_ent->label;
+			if (!nd_label)
+				continue;
 			if (memcmp(nd_label->uuid, pmem_id, NSLABEL_UUID_LEN) == 0)
 				break;
+			nd_label = NULL;
+		}
+		mutex_unlock(&nd_mapping->lock);
 
 		if (!nd_label) {
 			WARN_ON(1);
 			return -EINVAL;
 		}
 
-		select = nd_label;
 		/*
 		 * Check that this label is compliant with the dpa
 		 * range published in NFIT
 		 */
 		hw_start = nd_mapping->start;
 		hw_end = hw_start + nd_mapping->size;
-		pmem_start = __le64_to_cpu(select->dpa);
-		pmem_end = pmem_start + __le64_to_cpu(select->rawsize);
+		pmem_start = __le64_to_cpu(nd_label->dpa);
+		pmem_end = pmem_start + __le64_to_cpu(nd_label->rawsize);
 		if (pmem_start == hw_start && pmem_end <= hw_end)
 			/* pass */;
 		else
 			return -EINVAL;
 
-		nd_mapping->labels[0] = select;
-		nd_mapping->labels[1] = NULL;
+		mutex_lock(&nd_mapping->lock);
+		label_ent = list_first_entry(&nd_mapping->labels,
+				typeof(*label_ent), list);
+		label_ent->label = nd_label;
+		list_del(&label_ent->list);
+		nd_mapping_free_labels(nd_mapping);
+		list_add(&label_ent->list, &nd_mapping->labels);
+		mutex_unlock(&nd_mapping->lock);
 	}
 	return 0;
 }
@@ -1577,11 +1594,12 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm)
 {
 	u64 cookie = nd_region_interleave_set_cookie(nd_region);
-	struct nd_namespace_label *nd_label;
 	u8 select_id[NSLABEL_UUID_LEN];
+	struct nd_label_ent *label_ent;
+	struct nd_mapping *nd_mapping;
 	resource_size_t size = 0;
 	u8 *pmem_id = NULL;
-	int rc = -ENODEV, l;
+	int rc = 0;
 	u16 i;
 
 	if (cookie == 0) {
@@ -1593,13 +1611,19 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 	 * Find a complete set of labels by uuid.  By definition we can start
 	 * with any mapping as the reference label
 	 */
-	for_each_label(l, nd_label, nd_region->mapping[0].labels) {
-		u64 isetcookie = __le64_to_cpu(nd_label->isetcookie);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		nd_mapping = &nd_region->mapping[i];
+		mutex_lock_nested(&nd_mapping->lock, i);
+	}
+	list_for_each_entry(label_ent, &nd_region->mapping[0].labels, list) {
+		struct nd_namespace_label *nd_label = label_ent->label;
 
-		if (isetcookie != cookie)
+		if (!nd_label)
+			continue;
+		if (__le64_to_cpu(nd_label->isetcookie) != cookie)
 			continue;
 
-		for (i = 0; nd_region->ndr_mappings; i++)
+		for (i = 0; i < nd_region->ndr_mappings; i++)
 			if (!has_uuid_at_pos(nd_region, nd_label->uuid,
 						cookie, i))
 				break;
@@ -1611,18 +1635,27 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 			 * dimm with two instances of the same uuid.
 			 */
 			rc = -EINVAL;
-			goto err;
+			break;
 		} else if (pmem_id) {
 			/*
 			 * If there is more than one valid uuid set, we
 			 * need userspace to clean this up.
 			 */
 			rc = -EBUSY;
-			goto err;
+			break;
 		}
 		memcpy(select_id, nd_label->uuid, NSLABEL_UUID_LEN);
 		pmem_id = select_id;
 	}
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		int reverse = nd_region->ndr_mappings - 1 - i;
+
+		nd_mapping = &nd_region->mapping[reverse];
+		mutex_unlock(&nd_mapping->lock);
+	}
+
+	if (rc)
+		goto err;
 
 	/*
 	 * Fix up each mapping's 'labels' to have the validated pmem label for
@@ -1638,8 +1671,19 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 
 	/* Calculate total size and populate namespace properties from label0 */
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-		struct nd_namespace_label *label0 = nd_mapping->labels[0];
+		struct nd_namespace_label *label0;
+
+		nd_mapping = &nd_region->mapping[i];
+		mutex_lock(&nd_mapping->lock);
+		label_ent = list_first_entry_or_null(&nd_mapping->labels,
+				typeof(*label_ent), list);
+		label0 = label_ent ? label_ent->label : 0;
+		mutex_unlock(&nd_mapping->lock);
+
+		if (!label0) {
+			WARN_ON(1);
+			continue;
+		}
 
 		size += __le64_to_cpu(label0->rawsize);
 		if (__le16_to_cpu(label0->position) != 0)
@@ -1700,8 +1744,9 @@ static struct device **create_namespace_pmem(struct nd_region *nd_region)
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
 			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 
-			kfree(nd_mapping->labels);
-			nd_mapping->labels = NULL;
+			mutex_lock(&nd_mapping->lock);
+			nd_mapping_free_labels(nd_mapping);
+			mutex_unlock(&nd_mapping->lock);
 		}
 
 		/* Publish a zero-sized namespace for userspace to configure. */
@@ -1822,25 +1867,25 @@ void nd_region_create_btt_seed(struct nd_region *nd_region)
 		dev_err(&nd_region->dev, "failed to create btt namespace\n");
 }
 
-static struct device **create_namespace_blk(struct nd_region *nd_region)
+static struct device **scan_labels(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping)
 {
-	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
-	struct nd_namespace_label *nd_label;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct device *dev, **devs = NULL;
 	struct nd_namespace_blk *nsblk;
-	struct nvdimm_drvdata *ndd;
-	int i, l, count = 0;
-	struct resource *res;
-
-	if (nd_region->ndr_mappings == 0)
-		return NULL;
+	struct nd_label_ent *label_ent;
+	int i, count = 0;
 
-	ndd = to_ndd(nd_mapping);
-	for_each_label(l, nd_label, nd_mapping->labels) {
-		u32 flags = __le32_to_cpu(nd_label->flags);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		struct nd_namespace_label *nd_label = label_ent->label;
 		char *name[NSLABEL_NAME_LEN];
 		struct device **__devs;
+		struct resource *res;
+		u32 flags;
 
+		if (!nd_label)
+			continue;
+		flags = __le32_to_cpu(nd_label->flags);
 		if (flags & NSLABEL_FLAG_LOCAL)
 			/* pass */;
 		else
@@ -1899,12 +1944,7 @@ static struct device **create_namespace_blk(struct nd_region *nd_region)
 
 	if (count == 0) {
 		/* Publish a zero-sized namespace for userspace to configure. */
-		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-
-			kfree(nd_mapping->labels);
-			nd_mapping->labels = NULL;
-		}
+		nd_mapping_free_labels(nd_mapping);
 
 		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
 		if (!devs)
@@ -1920,8 +1960,8 @@ static struct device **create_namespace_blk(struct nd_region *nd_region)
 
 	return devs;
 
-err:
-	for (i = 0; i < count; i++) {
+ err:
+	for (i = 0; devs[i]; i++) {
 		nsblk = to_nd_namespace_blk(devs[i]);
 		namespace_blk_release(&nsblk->common.dev);
 	}
@@ -1929,6 +1969,21 @@ err:
 	return NULL;
 }
 
+static struct device **create_namespace_blk(struct nd_region *nd_region)
+{
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct device **devs;
+
+	if (nd_region->ndr_mappings == 0)
+		return NULL;
+
+	mutex_lock(&nd_mapping->lock);
+	devs = scan_labels(nd_region, nd_mapping);
+	mutex_unlock(&nd_mapping->lock);
+
+	return devs;
+}
+
 static int init_active_labels(struct nd_region *nd_region)
 {
 	int i;
@@ -1937,6 +1992,7 @@ static int init_active_labels(struct nd_region *nd_region)
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
+		struct nd_label_ent *label_ent;
 		int count, j;
 
 		/*
@@ -1958,16 +2014,27 @@ static int init_active_labels(struct nd_region *nd_region)
 		dev_dbg(ndd->dev, "%s: %d\n", __func__, count);
 		if (!count)
 			continue;
-		nd_mapping->labels = kcalloc(count + 1, sizeof(void *),
-				GFP_KERNEL);
-		if (!nd_mapping->labels)
-			return -ENOMEM;
 		for (j = 0; j < count; j++) {
 			struct nd_namespace_label *label;
 
+			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
+			if (!label_ent)
+				break;
 			label = nd_label_active(ndd, j);
-			nd_mapping->labels[j] = label;
+			label_ent->label = label;
+
+			mutex_lock(&nd_mapping->lock);
+			list_add_tail(&label_ent->list, &nd_mapping->labels);
+			mutex_unlock(&nd_mapping->lock);
 		}
+
+		if (j >= count)
+			continue;
+
+		mutex_lock(&nd_mapping->lock);
+		nd_mapping_free_labels(nd_mapping);
+		mutex_unlock(&nd_mapping->lock);
+		return -ENOMEM;
 	}
 
 	return 0;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 1414784c6c2b..fb3ade0d4a83 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -73,6 +73,7 @@ bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
 struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
+void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
 resource_size_t nd_blk_available_dpa(struct nd_mapping *nd_mapping);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e58c40824e1f..f67c61f1a8a4 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -83,9 +83,6 @@ static inline struct nd_namespace_index *to_next_namespace_index(
 		(unsigned long long) (res ? resource_size(res) : 0), \
 		(unsigned long long) (res ? res->start : 0), ##arg)
 
-#define for_each_label(l, label, labels) \
-	for (l = 0; (label = labels ? labels[l] : NULL); l++)
-
 #define for_each_dpa_resource(ndd, res) \
 	for (res = (ndd)->dpa.child; res; res = res->sibling)
 
@@ -98,11 +95,22 @@ struct nd_percpu_lane {
 	spinlock_t lock;
 };
 
+struct nd_label_ent {
+	struct list_head list;
+	struct nd_namespace_label *label;
+};
+
+enum nd_mapping_lock_class {
+	ND_MAPPING_CLASS0,
+	ND_MAPPING_UUID_SCAN,
+};
+
 struct nd_mapping {
 	struct nvdimm *nvdimm;
-	struct nd_namespace_label **labels;
 	u64 start;
 	u64 size;
+	struct list_head labels;
+	struct mutex lock;
 	/*
 	 * @ndd is for private use at region enable / disable time for
 	 * get_ndd() + put_ndd(), all other nd_mapping to ndd
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 0ff43cbb15e3..19bcd68c4141 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -487,6 +487,17 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
 	return 0;
 }
 
+void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
+{
+	struct nd_label_ent *label_ent, *e;
+
+	WARN_ON(!mutex_is_locked(&nd_mapping->lock));
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
+		list_del(&label_ent->list);
+		kfree(label_ent);
+	}
+}
+
 /*
  * Upon successful probe/remove, take/release a reference on the
  * associated interleave set (if present), and plant new btt + namespace
@@ -507,8 +518,10 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			struct nvdimm_drvdata *ndd = nd_mapping->ndd;
 			struct nvdimm *nvdimm = nd_mapping->nvdimm;
 
-			kfree(nd_mapping->labels);
-			nd_mapping->labels = NULL;
+			mutex_lock(&nd_mapping->lock);
+			nd_mapping_free_labels(nd_mapping);
+			mutex_unlock(&nd_mapping->lock);
+
 			put_ndd(ndd);
 			nd_mapping->ndd = NULL;
 			if (ndd)
@@ -816,6 +829,8 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		nd_region->mapping[i].nvdimm = nvdimm;
 		nd_region->mapping[i].start = mapping->start;
 		nd_region->mapping[i].size = mapping->size;
+		INIT_LIST_HEAD(&nd_region->mapping[i].labels);
+		mutex_init(&nd_region->mapping[i].lock);
 
 		get_device(&nvdimm->dev);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
