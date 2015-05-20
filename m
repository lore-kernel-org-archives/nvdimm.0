Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 16/21] libnd: write blk label set
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 May 2015 16:57:38 -0400
Message-ID: <20150520205738.32249.79704.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150520205536.32249.89779.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-nvdimm@lists.01.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

After 'uuid', 'size', 'sector_size', and optionally 'alt_name' have been
set to valid values the labels on the dimm can be updated.  The
difference with the pmem case is that blk namespaces are limited to one
dimm and can cover discontiguous ranges in dpa space.

Also, after allocating label slots, it is useful for userspace to know
how many slots are left.  Export this information in sysfs.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/bus.c            |    4 
 drivers/block/nd/dimm_devs.c      |   25 +++
 drivers/block/nd/label.c          |  297 +++++++++++++++++++++++++++++++++++--
 drivers/block/nd/label.h          |    5 +
 drivers/block/nd/namespace_devs.c |   57 +++++++
 drivers/block/nd/nd-private.h     |    1 
 6 files changed, 367 insertions(+), 22 deletions(-)

diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
index 65af6bcc5472..4a2185a99bd7 100644
--- a/drivers/block/nd/bus.c
+++ b/drivers/block/nd/bus.c
@@ -136,6 +136,10 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 {
 	struct device *dev = d;
 
+	/* flush bus operations before delete */
+	nd_bus_lock(dev);
+	nd_bus_unlock(dev);
+
 	device_unregister(dev);
 	put_device(dev);
 }
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 358b2a06d680..4b225c8b7d0a 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include "nd-private.h"
+#include "label.h"
 #include "nd.h"
 
 static DEFINE_IDA(dimm_ida);
@@ -262,9 +263,33 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(state);
 
+static ssize_t available_slots_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_dimm_drvdata *ndd = dev_get_drvdata(dev);
+	ssize_t rc;
+	u32 nfree;
+
+	if (!ndd)
+		return -ENXIO;
+
+	nd_bus_lock(dev);
+	nfree = nd_label_nfree(ndd);
+	if (nfree - 1 > nfree) {
+		dev_WARN_ONCE(dev, 1, "we ate our last label?\n");
+		nfree = 0;
+	} else
+		nfree--;
+	rc = sprintf(buf, "%d\n", nfree);
+	nd_bus_unlock(dev);
+	return rc;
+}
+static DEVICE_ATTR_RO(available_slots);
+
 static struct attribute *nd_dimm_attributes[] = {
 	&dev_attr_state.attr,
 	&dev_attr_commands.attr,
+	&dev_attr_available_slots.attr,
 	NULL,
 };
 
diff --git a/drivers/block/nd/label.c b/drivers/block/nd/label.c
index a4746f1fe99c..5052db591bec 100644
--- a/drivers/block/nd/label.c
+++ b/drivers/block/nd/label.c
@@ -58,7 +58,7 @@ size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd)
 	return ndd->nsindex_size;
 }
 
-static int nd_dimm_num_label_slots(struct nd_dimm_drvdata *ndd)
+int nd_dimm_num_label_slots(struct nd_dimm_drvdata *ndd)
 {
 	return ndd->nsarea.config_size / 129;
 }
@@ -412,7 +412,7 @@ u32 nd_label_nfree(struct nd_dimm_drvdata *ndd)
 	WARN_ON(!is_nd_bus_locked(ndd->dev));
 
 	if (!preamble_next(ndd, &nsindex, &free, &nslot))
-		return 0;
+		return nd_dimm_num_label_slots(ndd);
 
 	return bitmap_weight(free, nslot);
 }
@@ -550,22 +550,270 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	return 0;
 }
 
-static int init_labels(struct nd_mapping *nd_mapping)
+static void del_label(struct nd_mapping *nd_mapping, int l)
+{
+	struct nd_namespace_label __iomem *next_label, __iomem *nd_label;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	unsigned int slot;
+	int j;
+
+	nd_label = nd_get_label(nd_mapping->labels, l);
+	slot = to_slot(ndd, nd_label);
+	dev_vdbg(ndd->dev, "%s: clear: %d\n", __func__, slot);
+
+	for (j = l; (next_label = nd_get_label(nd_mapping->labels, j + 1)); j++)
+		nd_set_label(nd_mapping->labels, next_label, j);
+	nd_set_label(nd_mapping->labels, NULL, j);
+}
+
+static bool is_old_resource(struct resource *res, struct resource **list, int n)
 {
 	int i;
+
+	if (res->flags & DPA_RESOURCE_ADJUSTED)
+		return false;
+	for (i = 0; i < n; i++)
+		if (res == list[i])
+			return true;
+	return false;
+}
+
+static struct resource *to_resource(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_label __iomem *nd_label)
+{
+	struct resource *res;
+
+	for_each_dpa_resource(ndd, res) {
+		if (res->start != readq(&nd_label->dpa))
+			continue;
+		if (resource_size(res) != readq(&nd_label->rawsize))
+			continue;
+		return res;
+	}
+
+	return NULL;
+}
+
+/*
+ * 1/ Account all the labels that can be freed after this update
+ * 2/ Allocate and write the label to the staging (next) index
+ * 3/ Record the resources in the namespace device
+ */
+static int __blk_label_update(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, struct nd_namespace_blk *nsblk,
+		int num_labels)
+{
+	int i, l, alloc, victims, nfree, old_num_resources, nlabel, rc = -ENXIO;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_namespace_label __iomem *nd_label;
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free, *victim_map = NULL;
+	struct resource *res, **old_res_list;
+	struct nd_label_id label_id;
+	u8 uuid[NSLABEL_UUID_LEN];
+	u32 nslot, slot;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
+	old_res_list = nsblk->res;
+	nfree = nd_label_nfree(ndd);
+	old_num_resources = nsblk->num_resources;
+	nd_label_gen_id(&label_id, nsblk->uuid, NSLABEL_FLAG_LOCAL);
+
+	/*
+	 * We need to loop over the old resources a few times, which seems a
+	 * bit inefficient, but we need to know that we have the label
+	 * space before we start mutating the tracking structures.
+	 * Otherwise the recovery method of last resort for userspace is
+	 * disable and re-enable the parent region.
+	 */
+	alloc = 0;
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, label_id.id) != 0)
+			continue;
+		if (!is_old_resource(res, old_res_list, old_num_resources))
+			alloc++;
+	}
+
+	victims = 0;
+	if (old_num_resources) {
+		/* convert old local-label-map to dimm-slot victim-map */
+		victim_map = kcalloc(BITS_TO_LONGS(nslot), sizeof(long),
+				GFP_KERNEL);
+		if (!victim_map)
+			return -ENOMEM;
+
+		/* mark unused labels for garbage collection */
+		for_each_clear_bit_le(slot, free, nslot) {
+			nd_label = nd_label_base(ndd) + slot;
+			memcpy_fromio(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+			if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+				continue;
+			res = to_resource(ndd, nd_label);
+			if (res && is_old_resource(res, old_res_list,
+						old_num_resources))
+				continue;
+			slot = to_slot(ndd, nd_label);
+			set_bit(slot, victim_map);
+			victims++;
+		}
+	}
+
+	/* don't allow updates that consume the last label */
+	if (nfree - alloc < 0 || nfree - alloc + victims < 1) {
+		dev_info(&nsblk->dev, "insufficient label space\n");
+		kfree(victim_map);
+		return -ENOSPC;
+	}
+	/* from here on we need to abort on error */
+
+
+	/* assign all resources to the namespace before writing the labels */
+	nsblk->res = NULL;
+	nsblk->num_resources = 0;
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, label_id.id) != 0)
+			continue;
+		if (!nsblk_add_resource(nd_region, ndd, nsblk, res->start)) {
+			rc = -ENOMEM;
+			goto abort;
+		}
+	}
+
+	for (i = 0; i < nsblk->num_resources; i++) {
+		size_t offset;
+
+		res = nsblk->res[i];
+		if (is_old_resource(res, old_res_list, old_num_resources))
+			continue; /* carry-over */
+		slot = nd_label_alloc_slot(ndd);
+		if (slot == UINT_MAX)
+			goto abort;
+		dev_dbg(ndd->dev, "%s: allocated: %d\n", __func__, slot);
+
+		nd_label = nd_label_base(ndd) + slot;
+		memset_io(nd_label, 0, sizeof(struct nd_namespace_label));
+		memcpy_toio(nd_label->uuid, nsblk->uuid, NSLABEL_UUID_LEN);
+		if (nsblk->alt_name)
+			memcpy_toio(nd_label->name, nsblk->alt_name,
+					NSLABEL_NAME_LEN);
+		writel(NSLABEL_FLAG_LOCAL, &nd_label->flags);
+		writew(0, &nd_label->nlabel); /* N/A */
+		writew(0, &nd_label->position); /* N/A */
+		writeq(0, &nd_label->isetcookie); /* N/A */
+		writeq(res->start, &nd_label->dpa);
+		writeq(resource_size(res), &nd_label->rawsize);
+		writeq(nsblk->lbasize, &nd_label->lbasize);
+		writel(slot, &nd_label->slot);
+
+		/* update label */
+		offset = nd_label_offset(ndd, nd_label);
+		rc = nd_dimm_set_config_data(ndd, offset, nd_label,
+				sizeof(struct nd_namespace_label));
+		if (rc < 0)
+			goto abort;
+	}
+
+	/* free up now unused slots in the new index */
+	for_each_set_bit(slot, victim_map, victim_map ? nslot : 0) {
+		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
+		nd_label_free_slot(ndd, slot);
+	}
+
+	/* update index */
+	rc = nd_label_write_index(ndd, ndd->ns_next,
+			nd_inc_seq(readl(&nsindex->seq)), 0);
+	if (rc)
+		goto abort;
+
+	/*
+	 * Now that the on-dimm labels are up to date, fix up the tracking
+	 * entries in nd_mapping->labels
+	 */
+	nlabel = 0;
+	for_each_label(l, nd_label, nd_mapping->labels) {
+		nlabel++;
+		memcpy_fromio(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+			continue;
+		nlabel--;
+		del_label(nd_mapping, l);
+		l--; /* retry with the new label at this index */
+	}
+	if (nlabel + nsblk->num_resources > num_labels) {
+		/*
+		 * Bug, we can't end up with more resources than
+		 * available labels
+		 */
+		WARN_ON_ONCE(1);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		nd_label = nd_label_base(ndd) + slot;
+		memcpy_fromio(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+			continue;
+		res = to_resource(ndd, nd_label);
+		res->flags &= ~DPA_RESOURCE_ADJUSTED;
+		dev_vdbg(&nsblk->dev, "assign label[%d] slot: %d\n", l, slot);
+		nd_set_label(nd_mapping->labels, nd_label, l++);
+	}
+	nd_set_label(nd_mapping->labels, NULL, l);
+
+ out:
+	kfree(old_res_list);
+	kfree(victim_map);
+	return rc;
+
+ abort:
+	/*
+	 * 1/ repair the allocated label bitmap in the index
+	 * 2/ restore the resource list
+	 */
+	nd_label_copy(ndd, nsindex, to_current_namespace_index(ndd));
+	kfree(nsblk->res);
+	nsblk->res = old_res_list;
+	nsblk->num_resources = old_num_resources;
+	old_res_list = NULL;
+	goto out;
+}
+
+static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
+{
+	int i, l, old_num_labels = 0;
 	struct nd_namespace_index __iomem *nsindex;
+	struct nd_namespace_label __iomem *nd_label;
 	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	size_t size = (num_labels + 1) * sizeof(struct nd_namespace_label *);
 
-	if (!nd_mapping->labels)
-		nd_mapping->labels = kcalloc(2, sizeof(void *), GFP_KERNEL);
+	for_each_label(l, nd_label, nd_mapping->labels)
+		old_num_labels++;
 
+	/*
+	 * We need to preserve all the old labels for the mapping so
+	 * they can be garbage collected after writing the new labels.
+	 */
+	if (num_labels > old_num_labels) {
+		struct nd_namespace_label **labels;
+
+		labels = krealloc(nd_mapping->labels, size, GFP_KERNEL);
+		if (!labels)
+			return -ENOMEM;
+		nd_mapping->labels = labels;
+	}
 	if (!nd_mapping->labels)
 		return -ENOMEM;
 
+	for (i = old_num_labels; i <= num_labels; i++)
+		nd_set_label(nd_mapping->labels, NULL, i);
+
 	if (ndd->ns_current == -1 || ndd->ns_next == -1)
 		/* pass */;
 	else
-		return 0;
+		return max(num_labels, old_num_labels);
 
 	nsindex = to_namespace_index(ndd, 0);
 	memset_io(nsindex, 0, ndd->nsarea.config_size);
@@ -578,7 +826,7 @@ static int init_labels(struct nd_mapping *nd_mapping)
 	ndd->ns_next = 1;
 	ndd->ns_current = 0;
 
-	return 0;
+	return max(num_labels, old_num_labels);
 }
 
 static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
@@ -600,22 +848,15 @@ static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
 		return 0;
 
 	for_each_label(l, nd_label, nd_mapping->labels) {
-		int j;
-
 		memcpy_fromio(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
 		if (memcmp(label_uuid, uuid, NSLABEL_UUID_LEN) != 0)
 			continue;
 		slot = to_slot(ndd, nd_label);
 		nd_label_free_slot(ndd, slot);
 		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
-		for (j = l; nd_get_label(nd_mapping->labels, j + 1); j++) {
-			struct nd_namespace_label __iomem *next_label;
-
-			next_label = nd_get_label(nd_mapping->labels, j + 1);
-			nd_set_label(nd_mapping->labels, next_label, j);
-		}
-		nd_set_label(nd_mapping->labels, NULL, j);
+		del_label(nd_mapping, l);
 		num_freed++;
+		l--; /* retry with new label at this index */
 	}
 
 	if (num_freed > l) {
@@ -648,8 +889,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 			continue;
 		}
 
-		rc = init_labels(nd_mapping);
-		if (rc)
+		rc = init_labels(nd_mapping, 1);
+		if (rc < 0)
 			return rc;
 
 		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i);
@@ -659,3 +900,23 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 
 	return 0;
 }
+
+int nd_blk_namespace_label_update(struct nd_region *nd_region,
+		struct nd_namespace_blk *nsblk, resource_size_t size)
+{
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct resource *res;
+	int count = 0;
+
+	if (size == 0)
+		return del_labels(nd_mapping, nsblk->uuid);
+
+	for_each_dpa_resource(to_ndd(nd_mapping), res)
+		count++;
+
+	count = init_labels(nd_mapping, count);
+	if (count < 0)
+		return count;
+
+	return __blk_label_update(nd_region, nd_mapping, nsblk, count);
+}
diff --git a/drivers/block/nd/label.h b/drivers/block/nd/label.h
index e17958941e34..a26cebc9f389 100644
--- a/drivers/block/nd/label.h
+++ b/drivers/block/nd/label.h
@@ -130,9 +130,14 @@ size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd);
 int nd_label_active_count(struct nd_dimm_drvdata *ndd);
 struct nd_namespace_label __iomem *nd_label_active(
 		struct nd_dimm_drvdata *ndd, int n);
+u32 nd_label_alloc_slot(struct nd_dimm_drvdata *ndd);
+bool nd_label_free_slot(struct nd_dimm_drvdata *ndd, u32 slot);
 u32 nd_label_nfree(struct nd_dimm_drvdata *ndd);
 struct nd_region;
 struct nd_namespace_pmem;
+struct nd_namespace_blk;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
+int nd_blk_namespace_label_update(struct nd_region *nd_region,
+		struct nd_namespace_blk *nsblk, resource_size_t size);
 #endif /* __LABEL_H__ */
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index cdb78dddcfa9..c193ba6c6445 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -164,8 +164,7 @@ static int nd_namespace_label_update(struct nd_region *nd_region, struct device
 	 */
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
-		struct resource *res = &nspm->nsio.res;
-		resource_size_t size = resource_size(res);
+		resource_size_t size = resource_size(&nspm->nsio.res);
 
 		if (size == 0 && nspm->uuid)
 			/* delete allocation */;
@@ -174,8 +173,15 @@ static int nd_namespace_label_update(struct nd_region *nd_region, struct device
 
 		return nd_pmem_namespace_label_update(nd_region, nspm, size);
 	} else if (is_namespace_blk(dev)) {
-		/* TODO: implement blk labels */
-		return 0;
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+		resource_size_t size = nd_namespace_blk_size(nsblk);
+
+		if (size == 0 && nsblk->uuid)
+			/* delete allocation */;
+		else if (!nsblk->uuid || !nsblk->lbasize)
+			return 0;
+
+		return nd_blk_namespace_label_update(nd_region, nsblk, size);
 	} else
 		return -ENXIO;
 }
@@ -983,6 +989,48 @@ static ssize_t sector_size_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(sector_size);
 
+static ssize_t dpa_extents_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_label_id label_id;
+	int count = 0, i;
+	u8 *uuid = NULL;
+	u32 flags = 0;
+
+	nd_bus_lock(dev);
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		uuid = nspm->uuid;
+		flags = 0;
+	} else if (is_namespace_blk(dev)) {
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		uuid = nsblk->uuid;
+		flags = NSLABEL_FLAG_LOCAL;
+	}
+
+	if (!uuid)
+		goto out;
+
+	nd_label_gen_id(&label_id, uuid, flags);
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct resource *res;
+
+		for_each_dpa_resource(ndd, res)
+			if (strcmp(res->name, label_id.id) == 0)
+				count++;
+	}
+ out:
+	nd_bus_unlock(dev);
+
+	return sprintf(buf, "%d\n", count);
+}
+static DEVICE_ATTR_RO(dpa_extents);
+
 static struct attribute *nd_namespace_attributes[] = {
 	&dev_attr_nstype.attr,
 	&dev_attr_size.attr,
@@ -990,6 +1038,7 @@ static struct attribute *nd_namespace_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_alt_name.attr,
 	&dev_attr_sector_size.attr,
+	&dev_attr_dpa_extents.attr,
 	NULL,
 };
 
diff --git a/drivers/block/nd/nd-private.h b/drivers/block/nd/nd-private.h
index fe852175a3b8..fffd65436e2b 100644
--- a/drivers/block/nd/nd-private.h
+++ b/drivers/block/nd/nd-private.h
@@ -79,4 +79,5 @@ struct nd_mapping;
 struct resource *nsblk_add_resource(struct nd_region *nd_region,
 		struct nd_dimm_drvdata *ndd, struct nd_namespace_blk *nsblk,
 		resource_size_t start);
+int nd_dimm_num_label_slots(struct nd_dimm_drvdata *ndd);
 #endif /* __ND_PRIVATE_H__ */

