Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 16/20] libnd: write pmem label set
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:41 -0400
Message-ID: <20150428182541.35812.82094.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

After 'uuid', 'size', and optionally 'alt_name' have been set to valid
values the labels on the dimms can be updated.

Write procedure is:
1/ Allocate and write new labels in the "next" index
2/ Free the old labels in the working copy
3/ Write the bitmap and the label space on the dimm
4/ Write the index to make the update valid

Label ranges directly mirror the dpa resource values for the given
label_id of the namespace.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/dimm_devs.c      |   49 ++++++
 drivers/block/nd/label.c          |  327 +++++++++++++++++++++++++++++++++++++
 drivers/block/nd/label.h          |    6 +
 drivers/block/nd/namespace_devs.c |   82 ++++++++-
 drivers/block/nd/nd.h             |    3 
 5 files changed, 453 insertions(+), 14 deletions(-)

diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 4aa5654354ac..358b2a06d680 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -132,6 +132,55 @@ int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd)
 	return rc;
 }
 
+int nd_dimm_set_config_data(struct nd_dimm_drvdata *ndd, size_t offset,
+		void *buf, size_t len)
+{
+	int rc = validate_dimm(ndd);
+	size_t max_cmd_size, buf_offset;
+	struct nd_cmd_set_config_hdr *cmd;
+	struct nd_bus *nd_bus = walk_to_nd_bus(ndd->dev);
+	struct nd_bus_descriptor *nd_desc = nd_bus->nd_desc;
+
+	if (rc)
+		return rc;
+
+	if (!ndd->data)
+		return -ENXIO;
+
+	if (offset + len > ndd->nsarea.config_size)
+		return -ENXIO;
+
+	max_cmd_size = min_t(u32, PAGE_SIZE, len);
+	max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
+	cmd = kzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	for (buf_offset = 0; len; len -= cmd->in_length,
+			buf_offset += cmd->in_length) {
+		size_t cmd_size;
+		u32 *status;
+
+		cmd->in_offset = offset + buf_offset;
+		cmd->in_length = min(max_cmd_size, len);
+		memcpy(cmd->in_buf, buf + buf_offset, cmd->in_length);
+
+		/* status is output in the last 4-bytes of the command buffer */
+		cmd_size = sizeof(*cmd) + cmd->in_length + sizeof(u32);
+		status = ((void *) cmd) + cmd_size - sizeof(u32);
+
+		rc = nd_desc->ndctl(nd_desc, to_nd_dimm(ndd->dev),
+				ND_CMD_SET_CONFIG_DATA, cmd, cmd_size);
+		if (rc || *status) {
+			rc = rc ? rc : -ENXIO;
+			break;
+		}
+	}
+	kfree(cmd);
+
+	return rc;
+}
+
 static void nd_dimm_release(struct device *dev)
 {
 	struct nd_dimm *nd_dimm = to_nd_dimm(dev);
diff --git a/drivers/block/nd/label.c b/drivers/block/nd/label.c
index b55fa2a6f872..78898b642191 100644
--- a/drivers/block/nd/label.c
+++ b/drivers/block/nd/label.c
@@ -12,6 +12,7 @@
  */
 #include <linux/device.h>
 #include <linux/ndctl.h>
+#include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/nd.h>
 #include "nd-private.h"
@@ -57,6 +58,11 @@ size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd)
 	return ndd->nsindex_size;
 }
 
+static int nd_dimm_num_label_slots(struct nd_dimm_drvdata *ndd)
+{
+	return ndd->nsarea.config_size / 129;
+}
+
 int nd_label_validate(struct nd_dimm_drvdata *ndd)
 {
 	/*
@@ -202,23 +208,30 @@ static struct nd_namespace_label __iomem *nd_label_base(struct nd_dimm_drvdata *
 	return base + 2 * sizeof_namespace_index(ndd);
 }
 
+static int to_slot(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_label __iomem *nd_label)
+{
+	return nd_label - nd_label_base(ndd);
+}
+
 #define for_each_clear_bit_le(bit, addr, size) \
 	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
 	     (bit) < (size);                                    \
 	     (bit) = find_next_zero_bit_le((addr), (size), (bit) + 1))
 
 /**
- * preamble_current - common variable initialization for nd_label_* routines
+ * preamble_index - common variable initialization for nd_label_* routines
  * @nd_dimm: dimm container for the relevant label set
+ * @idx: namespace_index index
  * @nsindex: on return set to the currently active namespace index
  * @free: on return set to the free label bitmap in the index
  * @nslot: on return set to the number of slots in the label space
  */
-static bool preamble_current(struct nd_dimm_drvdata *ndd,
+static bool preamble_index(struct nd_dimm_drvdata *ndd, int idx,
 		struct nd_namespace_index **nsindex,
 		unsigned long **free, u32 *nslot)
 {
-	*nsindex = to_current_namespace_index(ndd);
+	*nsindex = to_namespace_index(ndd, idx);
 	if (*nsindex == NULL)
 		return false;
 
@@ -237,6 +250,22 @@ char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
 	return label_id->id;
 }
 
+static bool preamble_current(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_index **nsindex,
+		unsigned long **free, u32 *nslot)
+{
+	return preamble_index(ndd, ndd->ns_current, nsindex,
+			free, nslot);
+}
+
+static bool preamble_next(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_index **nsindex,
+		unsigned long **free, u32 *nslot)
+{
+	return preamble_index(ndd, ndd->ns_next, nsindex,
+			free, nslot);
+}
+
 static bool slot_valid(struct nd_namespace_label __iomem *nd_label, u32 slot)
 {
 	/* check that we are written where we expect to be written */
@@ -341,3 +370,295 @@ struct nd_namespace_label __iomem *nd_label_active(
 
 	return NULL;
 }
+
+u32 nd_label_alloc_slot(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return UINT_MAX;
+
+	WARN_ON(!is_nd_bus_locked(ndd->dev));
+
+	slot = find_next_bit_le(free, nslot, 0);
+	if (slot == nslot)
+		return UINT_MAX;
+
+	clear_bit_le(slot, free);
+
+	return slot;
+}
+
+bool nd_label_free_slot(struct nd_dimm_drvdata *ndd, u32 slot)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return false;
+
+	WARN_ON(!is_nd_bus_locked(ndd->dev));
+
+	if (slot < nslot)
+		return !test_and_set_bit_le(slot, free);
+	return false;
+}
+
+u32 nd_label_nfree(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot;
+
+	WARN_ON(!is_nd_bus_locked(ndd->dev));
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return 0;
+
+	return bitmap_weight(free, nslot);
+}
+
+static int nd_label_write_index(struct nd_dimm_drvdata *ndd, int index, u32 seq,
+		unsigned long flags)
+{
+	struct nd_namespace_index *nsindex = to_namespace_index(ndd, index);
+	unsigned long offset;
+	u64 checksum;
+	u32 nslot;
+	int rc;
+
+	if (flags & ND_NSINDEX_INIT)
+		nslot = nd_dimm_num_label_slots(ndd);
+	else
+		nslot = readl(&nsindex->nslot);
+
+	memcpy_toio(nsindex->sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN);
+	writel(0, &nsindex->flags);
+	writel(seq, &nsindex->seq);
+	offset = (unsigned long) nsindex
+		- (unsigned long) to_namespace_index(ndd, 0);
+	writeq(offset, &nsindex->myoff);
+	writeq(sizeof_namespace_index(ndd), &nsindex->mysize);
+	offset = (unsigned long) to_namespace_index(ndd,
+			nd_label_next_nsindex(index))
+		- (unsigned long) to_namespace_index(ndd, 0);
+	writeq(offset, &nsindex->otheroff);
+	offset = (unsigned long) nd_label_base(ndd)
+		- (unsigned long) to_namespace_index(ndd, 0);
+	writeq(offset, &nsindex->labeloff);
+	writel(nslot, &nsindex->nslot);
+	writew(1, &nsindex->major);
+	writew(1, &nsindex->minor);
+	writeq(0, &nsindex->checksum);
+	if (flags & ND_NSINDEX_INIT) {
+		unsigned long *free = (unsigned long __force *) nsindex->free;
+		u32 nfree = ALIGN(nslot, BITS_PER_LONG);
+		int last_bits, i;
+
+		memset_io(nsindex->free, 0xff, nfree / 8);
+		for (i = 0, last_bits = nfree - nslot; i < last_bits; i++)
+			clear_bit_le(nslot + i, free);
+	}
+	checksum = nd_fletcher64(nsindex, sizeof_namespace_index(ndd));
+	writeq(checksum, &nsindex->checksum);
+	rc = nd_dimm_set_config_data(ndd, readq(&nsindex->myoff),
+			nsindex, sizeof_namespace_index(ndd));
+	if (rc < 0)
+		return rc;
+
+	if (flags & ND_NSINDEX_INIT)
+		return 0;
+
+	/* copy the index we just wrote to the new 'next' */
+	WARN_ON(index != ndd->ns_next);
+	nd_label_copy(ndd, to_current_namespace_index(ndd), nsindex);
+	ndd->ns_current = nd_label_next_nsindex(ndd->ns_current);
+	ndd->ns_next = nd_label_next_nsindex(ndd->ns_next);
+	WARN_ON(ndd->ns_current == ndd->ns_next);
+
+	return 0;
+}
+
+static unsigned long nd_label_offset(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_label __iomem *nd_label)
+{
+	return (unsigned long) nd_label
+		- (unsigned long) to_namespace_index(ndd, 0);
+}
+
+static int __pmem_label_update(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
+		int pos)
+{
+	u64 cookie = nd_region_interleave_set_cookie(nd_region), rawsize;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_namespace_label __iomem *victim_label;
+	struct nd_namespace_label __iomem *nd_label;
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+	size_t offset;
+	int rc;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
+	/* allocate and write the label to the staging (next) index */
+	slot = nd_label_alloc_slot(ndd);
+	if (slot == UINT_MAX)
+		return -ENXIO;
+	dev_dbg(ndd->dev, "%s: allocated: %d\n", __func__, slot);
+
+	nd_label = nd_label_base(ndd) + slot;
+	memset_io(nd_label, 0, sizeof(struct nd_namespace_label));
+	memcpy_toio(nd_label->uuid, nspm->uuid, NSLABEL_UUID_LEN);
+	if (nspm->alt_name)
+		memcpy_toio(nd_label->name, nspm->alt_name, NSLABEL_NAME_LEN);
+	writel(NSLABEL_FLAG_UPDATING, &nd_label->flags);
+	writew(nd_region->ndr_mappings, &nd_label->nlabel);
+	writew(pos, &nd_label->position);
+	writeq(cookie, &nd_label->isetcookie);
+	rawsize = div_u64(resource_size(&nspm->nsio.res),
+			nd_region->ndr_mappings);
+	writeq(rawsize, &nd_label->rawsize);
+	writeq(nd_mapping->start, &nd_label->dpa);
+	writel(slot, &nd_label->slot);
+
+	/* update label */
+	offset = nd_label_offset(ndd, nd_label);
+	rc = nd_dimm_set_config_data(ndd, offset, nd_label,
+			sizeof(struct nd_namespace_label));
+	if (rc < 0)
+		return rc;
+
+	/* Garbage collect the previous label */
+	victim_label = nd_get_label(nd_mapping->labels, 0);
+	if (victim_label) {
+		slot = to_slot(ndd, victim_label);
+		nd_label_free_slot(ndd, slot);
+		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
+	}
+
+	/* update index */
+	rc = nd_label_write_index(ndd, ndd->ns_next,
+			nd_inc_seq(readl(&nsindex->seq)), 0);
+	if (rc < 0)
+		return rc;
+
+	nd_set_label(nd_mapping->labels, nd_label, 0);
+
+	return 0;
+}
+
+static int init_labels(struct nd_mapping *nd_mapping)
+{
+	int i;
+	struct nd_namespace_index __iomem *nsindex;
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+
+	if (!nd_mapping->labels)
+		nd_mapping->labels = kcalloc(2, sizeof(void *), GFP_KERNEL);
+
+	if (!nd_mapping->labels)
+		return -ENOMEM;
+
+	if (ndd->ns_current == -1 || ndd->ns_next == -1)
+		/* pass */;
+	else
+		return 0;
+
+	nsindex = to_namespace_index(ndd, 0);
+	memset_io(nsindex, 0, ndd->nsarea.config_size);
+	for (i = 0; i < 2; i++) {
+		int rc = nd_label_write_index(ndd, i, i*2, ND_NSINDEX_INIT);
+
+		if (rc)
+			return rc;
+	}
+	ndd->ns_next = 1;
+	ndd->ns_current = 0;
+
+	return 0;
+}
+
+static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
+{
+	struct nd_dimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_namespace_label __iomem *nd_label;
+	struct nd_namespace_index __iomem *nsindex;
+	u8 label_uuid[NSLABEL_UUID_LEN];
+	int l, num_freed = 0;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!uuid)
+		return 0;
+
+	/* no index || no labels == nothing to delete */
+	if (!preamble_next(ndd, &nsindex, &free, &nslot)
+			|| !nd_mapping->labels)
+		return 0;
+
+	for_each_label(l, nd_label, nd_mapping->labels) {
+		int j;
+
+		memcpy_fromio(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+		if (memcmp(label_uuid, uuid, NSLABEL_UUID_LEN) != 0)
+			continue;
+		slot = to_slot(ndd, nd_label);
+		nd_label_free_slot(ndd, slot);
+		dev_dbg(ndd->dev, "%s: free: %d\n", __func__, slot);
+		for (j = l; nd_get_label(nd_mapping->labels, j + 1); j++) {
+			struct nd_namespace_label __iomem *next_label;
+
+			next_label = nd_get_label(nd_mapping->labels, j + 1);
+			nd_set_label(nd_mapping->labels, next_label, j);
+		}
+		nd_set_label(nd_mapping->labels, NULL, j);
+		num_freed++;
+	}
+
+	if (num_freed > l) {
+		/*
+		 * num_freed will only ever be > l when we delete the last
+		 * label
+		 */
+		kfree(nd_mapping->labels);
+		nd_mapping->labels = NULL;
+		dev_dbg(ndd->dev, "%s: no more labels\n", __func__);
+	}
+
+	return nd_label_write_index(ndd, ndd->ns_next,
+			nd_inc_seq(readl(&nsindex->seq)), 0);
+}
+
+int nd_pmem_namespace_label_update(struct nd_region *nd_region,
+		struct nd_namespace_pmem *nspm, resource_size_t size)
+{
+	int i;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		int rc;
+
+		if (size == 0) {
+			rc = del_labels(nd_mapping, nspm->uuid);
+			if (rc)
+				return rc;
+			continue;
+		}
+
+		rc = init_labels(nd_mapping);
+		if (rc)
+			return rc;
+
+		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
diff --git a/drivers/block/nd/label.h b/drivers/block/nd/label.h
index 4436624f4146..e17958941e34 100644
--- a/drivers/block/nd/label.h
+++ b/drivers/block/nd/label.h
@@ -34,6 +34,7 @@ enum {
 	BTTINFO_MAJOR_VERSION = 1,
 	ND_LABEL_MIN_SIZE = 512 * 129, /* see sizeof_namespace_index() */
 	ND_LABEL_ID_SIZE = 50,
+	ND_NSINDEX_INIT = 0x1,
 };
 
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
@@ -129,4 +130,9 @@ size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd);
 int nd_label_active_count(struct nd_dimm_drvdata *ndd);
 struct nd_namespace_label __iomem *nd_label_active(
 		struct nd_dimm_drvdata *ndd, int n);
+u32 nd_label_nfree(struct nd_dimm_drvdata *ndd);
+struct nd_region;
+struct nd_namespace_pmem;
+int nd_pmem_namespace_label_update(struct nd_region *nd_region,
+		struct nd_namespace_pmem *nspm, resource_size_t size);
 #endif /* __LABEL_H__ */
diff --git a/drivers/block/nd/namespace_devs.c b/drivers/block/nd/namespace_devs.c
index e229755509a2..c04f55fb7c7c 100644
--- a/drivers/block/nd/namespace_devs.c
+++ b/drivers/block/nd/namespace_devs.c
@@ -151,20 +151,52 @@ static resource_size_t nd_namespace_blk_size(struct nd_namespace_blk *nsblk)
 	return size;
 }
 
+static int nd_namespace_label_update(struct nd_region *nd_region, struct device *dev)
+{
+	dev_WARN_ONCE(dev, dev->driver,
+			"namespace must be idle during label update\n");
+	if (dev->driver)
+		return 0;
+
+	/*
+	 * Only allow label writes that will result in a valid namespace
+	 * or deletion of an existing namespace.
+	 */
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+		struct resource *res = &nspm->nsio.res;
+		resource_size_t size = resource_size(res);
+
+		if (size == 0 && nspm->uuid)
+			/* delete allocation */;
+		else if (!nspm->uuid)
+			return 0;
+
+		return nd_pmem_namespace_label_update(nd_region, nspm, size);
+	} else if (is_namespace_blk(dev)) {
+		/* TODO: implement blk labels */
+		return 0;
+	} else
+		return -ENXIO;
+}
+
 static ssize_t alt_name_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	ssize_t rc;
 
 	device_lock(dev);
 	nd_bus_lock(dev);
 	wait_nd_bus_probe_idle(dev);
 	rc = __alt_name_store(dev, buf, len);
+	if (rc >= 0)
+		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "%s: %s (%zd)\n", __func__, rc < 0 ? "fail" : "success", rc);
 	nd_bus_unlock(dev);
 	device_unlock(dev);
 
-	return rc;
+	return rc < 0 ? rc : len;
 }
 
 static ssize_t alt_name_show(struct device *dev,
@@ -707,6 +739,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 static ssize_t size_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	unsigned long long val;
 	u8 **uuid = NULL;
 	int rc;
@@ -719,6 +752,8 @@ static ssize_t size_store(struct device *dev,
 	nd_bus_lock(dev);
 	wait_nd_bus_probe_idle(dev);
 	rc = __size_store(dev, val);
+	if (rc >= 0)
+		rc = nd_namespace_label_update(nd_region, dev);
 
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
@@ -742,7 +777,7 @@ static ssize_t size_store(struct device *dev,
 	nd_bus_unlock(dev);
 	device_unlock(dev);
 
-	return rc ? rc : len;
+	return rc < 0 ? rc : len;
 }
 
 static ssize_t size_show(struct device *dev,
@@ -802,17 +837,34 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 	u32 flags = is_namespace_blk(dev) ? NSLABEL_FLAG_LOCAL : 0;
 	struct nd_label_id old_label_id;
 	struct nd_label_id new_label_id;
-	int i, rc;
+	int i;
 
-	rc = nd_is_uuid_unique(dev, new_uuid) ? 0 : -EINVAL;
-	if (rc) {
-		kfree(new_uuid);
-		return rc;
-	}
+	if (!nd_is_uuid_unique(dev, new_uuid))
+		return -EINVAL;
 
 	if (*old_uuid == NULL)
 		goto out;
 
+	/*
+	 * If we've already written a label with this uuid, then it's
+	 * too late to rename because we can't reliably update the uuid
+	 * without losing the old namespace.  Userspace must delete this
+	 * namespace to abandon the old uuid.
+	 */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+
+		/*
+		 * This check by itself is sufficient because old_uuid
+		 * would be NULL above if this uuid did not exist in the
+		 * currently written set.
+		 *
+		 * FIXME: can we delete uuid with zero dpa allocated?
+		 */
+		if (nd_mapping->labels)
+			return -EBUSY;
+	}
+
 	nd_label_gen_id(&old_label_id, *old_uuid, flags);
 	nd_label_gen_id(&new_label_id, new_uuid, flags);
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
@@ -856,12 +908,16 @@ static ssize_t uuid_store(struct device *dev,
 	rc = nd_uuid_store(dev, &uuid, buf, len);
 	if (rc >= 0)
 		rc = namespace_update_uuid(nd_region, dev, uuid, ns_uuid);
+	if (rc >= 0)
+		rc = nd_namespace_label_update(nd_region, dev);
+	else
+		kfree(uuid);
 	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
 			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
 	nd_bus_unlock(dev);
 	device_unlock(dev);
 
-	return rc ? rc : len;
+	return rc < 0 ? rc : len;
 }
 static DEVICE_ATTR_RW(uuid);
 
@@ -905,6 +961,7 @@ static ssize_t sector_size_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 	ssize_t rc;
 
 	if (!is_namespace_blk(dev))
@@ -914,8 +971,11 @@ static ssize_t sector_size_store(struct device *dev,
 	nd_bus_lock(dev);
 	rc = nd_sector_size_store(dev, buf, &nsblk->lbasize,
 			ns_lbasize_supported);
-	dev_dbg(dev, "%s: result: %zd wrote: %s%s", __func__,
-			rc, buf, buf[len - 1] == '\n' ? "" : "\n");
+	if (rc >= 0)
+		rc = nd_namespace_label_update(nd_region, dev);
+	dev_dbg(dev, "%s: result: %zd %s: %s%s", __func__,
+			rc, rc < 0 ? "tried" : "wrote", buf,
+			buf[len - 1] == '\n' ? "" : "\n");
 	nd_bus_unlock(dev);
 	device_unlock(dev);
 
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index 63d4c6c09275..8eaf0ae82db4 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -110,6 +110,7 @@ static inline unsigned nd_inc_seq(unsigned seq)
 
 	return next[seq & 3];
 }
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -128,6 +129,8 @@ struct nd_dimm;
 struct nd_dimm_drvdata *to_ndd(struct nd_mapping *nd_mapping);
 int nd_dimm_init_nsarea(struct nd_dimm_drvdata *ndd);
 int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd);
+int nd_dimm_set_config_data(struct nd_dimm_drvdata *ndd, size_t offset,
+		void *buf, size_t len);
 struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_namespace_type(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);

