Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 13/20] libnd: namespace indices: read and validate
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Apr 2015 14:25:25 -0400
Message-ID: <20150428182525.35812.86014.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On media label format consists of two index blocks followed by an array
of labels.  None of these structures are ever updated in place.  A
sequence number tracks the current active index and the next one to
write, while labels are written to free slots.

    +------------+
    |            |
    |  nsindex0  |
    |            |
    +------------+
    |            |
    |  nsindex1  |
    |            |
    +------------+
    |   label0   |
    +------------+
    |   label1   |
    +------------+
    |            |
     ....nslot...
    |            |
    +------------+
    |   labelN   |
    +------------+

After reading valid labels, store the dpa ranges they claim into
per-dimm resource trees.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/block/nd/Makefile    |    1 
 drivers/block/nd/dimm.c      |   26 +++-
 drivers/block/nd/dimm_devs.c |    6 +
 drivers/block/nd/label.c     |  291 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/nd/label.h     |  129 +++++++++++++++++++
 drivers/block/nd/nd.h        |   45 ++++++
 include/uapi/linux/ndctl.h   |    1 
 7 files changed, 495 insertions(+), 4 deletions(-)
 create mode 100644 drivers/block/nd/label.c
 create mode 100644 drivers/block/nd/label.h

diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
index ebb212af9f15..d588f691163c 100644
--- a/drivers/block/nd/Makefile
+++ b/drivers/block/nd/Makefile
@@ -31,3 +31,4 @@ libnd-y += dimm.o
 libnd-y += region_devs.o
 libnd-y += region.o
 libnd-y += namespace_devs.o
+libnd-y += label.o
diff --git a/drivers/block/nd/dimm.c b/drivers/block/nd/dimm.c
index 6b7d2842509c..5477176c5de0 100644
--- a/drivers/block/nd/dimm.c
+++ b/drivers/block/nd/dimm.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/nd.h>
+#include "label.h"
 #include "nd.h"
 
 static void free_data(struct nd_dimm_drvdata *ndd)
@@ -42,7 +43,12 @@ static int nd_dimm_probe(struct device *dev)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, ndd);
-        ndd->dev = dev;
+	ndd->dpa.name = dev_name(dev);
+	ndd->ns_current = -1;
+	ndd->ns_next = -1;
+	ndd->dpa.start = 0;
+	ndd->dpa.end = -1;
+	ndd->dev = dev;
 
 	rc = nd_dimm_init_nsarea(ndd);
 	if (rc)
@@ -54,18 +60,34 @@ static int nd_dimm_probe(struct device *dev)
 
 	dev_dbg(dev, "config data size: %d\n", ndd->nsarea.config_size);
 
+	nd_bus_lock(dev);
+	ndd->ns_current = nd_label_validate(ndd);
+	ndd->ns_next = nd_label_next_nsindex(ndd->ns_current);
+	nd_label_copy(ndd, to_next_namespace_index(ndd),
+			to_current_namespace_index(ndd));
+	rc = nd_label_reserve_dpa(ndd);
+	nd_bus_unlock(dev);
+
+	if (rc)
+		goto err;
+
 	return 0;
 
  err:
 	free_data(ndd);
 	return rc;
-
 }
 
 static int nd_dimm_remove(struct device *dev)
 {
 	struct nd_dimm_drvdata *ndd = dev_get_drvdata(dev);
+	struct resource *res, *_r;
 
+	nd_bus_lock(dev);
+	dev_set_drvdata(dev, NULL);
+	for_each_dpa_resource_safe(ndd, res, _r)
+		__release_region(&ndd->dpa, res->start, resource_size(res));
+	nd_bus_unlock(dev);
 	free_data(ndd);
 
 	return 0;
diff --git a/drivers/block/nd/dimm_devs.c b/drivers/block/nd/dimm_devs.c
index 8981adc59ba4..3fbd0d0502eb 100644
--- a/drivers/block/nd/dimm_devs.c
+++ b/drivers/block/nd/dimm_devs.c
@@ -92,8 +92,12 @@ int nd_dimm_init_config_data(struct nd_dimm_drvdata *ndd)
 	if (ndd->data)
 		return 0;
 
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0)
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0
+			|| ndd->nsarea.config_size < ND_LABEL_MIN_SIZE) {
+		dev_dbg(ndd->dev, "failed to init config data area: (%d:%d)\n",
+				ndd->nsarea.max_xfer, ndd->nsarea.config_size);
 		return -ENXIO;
+	}
 
 	ndd->data = kmalloc(ndd->nsarea.config_size, GFP_KERNEL);
 	if (!ndd->data)
diff --git a/drivers/block/nd/label.c b/drivers/block/nd/label.c
new file mode 100644
index 000000000000..e791ea8bbdde
--- /dev/null
+++ b/drivers/block/nd/label.c
@@ -0,0 +1,291 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#include <linux/device.h>
+#include <linux/ndctl.h>
+#include <linux/io.h>
+#include <linux/nd.h>
+#include "nd-private.h"
+#include "label.h"
+#include "nd.h"
+
+#include <asm-generic/io-64-nonatomic-lo-hi.h>
+
+static u32 best_seq(u32 a, u32 b)
+{
+	a &= NSINDEX_SEQ_MASK;
+	b &= NSINDEX_SEQ_MASK;
+
+	if (a == 0 || a == b)
+		return b;
+	else if (b == 0)
+		return a;
+	else if (nd_inc_seq(a) == b)
+		return b;
+	else
+		return a;
+}
+
+size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd)
+{
+	u32 index_span;
+
+	if (ndd->nsindex_size)
+		return ndd->nsindex_size;
+
+	/*
+	 * The minimum index space is 512 bytes, with that amount of
+	 * index we can describe ~1400 labels which is less than a byte
+	 * of overhead per label.  Round up to a byte of overhead per
+	 * label and determine the size of the index region.  Yes, this
+	 * starts to waste space at larger config_sizes, but it's
+	 * unlikely we'll ever see anything but 128K.
+	 */
+	index_span = ndd->nsarea.config_size / 129;
+	index_span /= NSINDEX_ALIGN * 2;
+	ndd->nsindex_size = index_span * NSINDEX_ALIGN;
+
+	return ndd->nsindex_size;
+}
+
+int nd_label_validate(struct nd_dimm_drvdata *ndd)
+{
+	/*
+	 * On media label format consists of two index blocks followed
+	 * by an array of labels.  None of these structures are ever
+	 * updated in place.  A sequence number tracks the current
+	 * active index and the next one to write, while labels are
+	 * written to free slots.
+	 *
+	 *     +------------+
+	 *     |            |
+	 *     |  nsindex0  |
+	 *     |            |
+	 *     +------------+
+	 *     |            |
+	 *     |  nsindex1  |
+	 *     |            |
+	 *     +------------+
+	 *     |   label0   |
+	 *     +------------+
+	 *     |   label1   |
+	 *     +------------+
+	 *     |            |
+	 *      ....nslot...
+	 *     |            |
+	 *     +------------+
+	 *     |   labelN   |
+	 *     +------------+
+	 */
+	struct nd_namespace_index __iomem *nsindex[] = {
+		to_namespace_index(ndd, 0),
+		to_namespace_index(ndd, 1),
+	};
+	const int num_index = ARRAY_SIZE(nsindex);
+	struct device *dev = ndd->dev;
+	bool valid[] = { false, false };
+	int i, num_valid = 0;
+	u32 seq;
+
+	for (i = 0; i < num_index; i++) {
+		u64 sum_save, sum;
+		u8 sig[NSINDEX_SIG_LEN];
+
+		memcpy_fromio(sig, nsindex[i]->sig, NSINDEX_SIG_LEN);
+		if (memcmp(sig, NSINDEX_SIGNATURE, NSINDEX_SIG_LEN) != 0) {
+			dev_dbg(dev, "%s: nsindex%d signature invalid\n",
+					__func__, i);
+			continue;
+		}
+		sum_save = readq(&nsindex[i]->checksum);
+		writeq(0, &nsindex[i]->checksum);
+		sum = nd_fletcher64(nsindex[i], sizeof_namespace_index(ndd));
+		writeq(sum_save, &nsindex[i]->checksum);
+		if (sum != sum_save) {
+			dev_dbg(dev, "%s: nsindex%d checksum invalid\n",
+					__func__, i);
+			continue;
+		}
+		if ((readl(&nsindex[i]->seq) & NSINDEX_SEQ_MASK) == 0) {
+			dev_dbg(dev, "%s: nsindex%d sequence: %#x invalid\n",
+					__func__, i, readl(&nsindex[i]->seq));
+			continue;
+		}
+
+		/* sanity check the index against expected values */
+		if (readq(&nsindex[i]->myoff)
+				!= i * sizeof_namespace_index(ndd)) {
+			dev_dbg(dev, "%s: nsindex%d myoff: %#llx invalid\n",
+					__func__, i, (unsigned long long)
+					readq(&nsindex[i]->myoff));
+			continue;
+		}
+		if (readq(&nsindex[i]->otheroff)
+				!= (!i) * sizeof_namespace_index(ndd)) {
+			dev_dbg(dev, "%s: nsindex%d otheroff: %#llx invalid\n",
+					__func__, i, (unsigned long long)
+					readq(&nsindex[i]->otheroff));
+			continue;
+		}
+		if (readq(&nsindex[i]->mysize) > sizeof_namespace_index(ndd)
+				|| readq(&nsindex[i]->mysize)
+				< sizeof(struct nd_namespace_index)) {
+			dev_dbg(dev, "%s: nsindex%d mysize: %#llx invalid\n",
+					__func__, i, (unsigned long long)
+					readq(&nsindex[i]->mysize));
+			continue;
+		}
+		if (readl(&nsindex[i]->nslot) * sizeof(struct nd_namespace_label)
+				+ 2 * sizeof_namespace_index(ndd)
+				> ndd->nsarea.config_size) {
+			dev_dbg(dev, "%s: nsindex%d nslot: %u invalid, config_size: %#x\n",
+					__func__, i, readl(&nsindex[i]->nslot),
+					ndd->nsarea.config_size);
+			continue;
+		}
+		valid[i] = true;
+		num_valid++;
+	}
+
+	switch (num_valid) {
+	case 0:
+		break;
+	case 1:
+		for (i = 0; i < num_index; i++)
+			if (valid[i])
+				return i;
+		/* can't have num_valid > 0 but valid[] = { false, false } */
+		WARN_ON(1);
+		break;
+	default:
+		/* pick the best index... */
+		seq = best_seq(readl(&nsindex[0]->seq), readl(&nsindex[1]->seq));
+		if (seq == (readl(&nsindex[1]->seq) & NSINDEX_SEQ_MASK))
+			return 1;
+		else
+			return 0;
+		break;
+	}
+
+	return -1;
+}
+
+void nd_label_copy(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_index __iomem *dst,
+		struct nd_namespace_index __iomem *src)
+{
+	void *s, *d;
+
+	if (dst && src)
+		/* pass */;
+	else
+		return;
+
+	d = (void * __force) dst;
+	s = (void * __force) src;
+	memcpy(d, s, sizeof_namespace_index(ndd));
+}
+
+static struct nd_namespace_label __iomem *nd_label_base(struct nd_dimm_drvdata *ndd)
+{
+	void *base = to_namespace_index(ndd, 0);
+
+	return base + 2 * sizeof_namespace_index(ndd);
+}
+
+#define for_each_clear_bit_le(bit, addr, size) \
+	for ((bit) = find_next_zero_bit_le((addr), (size), 0);  \
+	     (bit) < (size);                                    \
+	     (bit) = find_next_zero_bit_le((addr), (size), (bit) + 1))
+
+/**
+ * preamble_current - common variable initialization for nd_label_* routines
+ * @nd_dimm: dimm container for the relevant label set
+ * @nsindex: on return set to the currently active namespace index
+ * @free: on return set to the free label bitmap in the index
+ * @nslot: on return set to the number of slots in the label space
+ */
+static bool preamble_current(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_index **nsindex,
+		unsigned long **free, u32 *nslot)
+{
+	*nsindex = to_current_namespace_index(ndd);
+	if (*nsindex == NULL)
+		return false;
+
+	*free = (unsigned long __force *) (*nsindex)->free;
+	*nslot = readl(&(*nsindex)->nslot);
+
+	return true;
+}
+
+static char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
+{
+	if (!label_id || !uuid)
+		return NULL;
+	snprintf(label_id->id, ND_LABEL_ID_SIZE, "%s-%pUb",
+			flags & NSLABEL_FLAG_LOCAL ? "blk" : "pmem", uuid);
+	return label_id->id;
+}
+
+static bool slot_valid(struct nd_namespace_label __iomem *nd_label, u32 slot)
+{
+	/* check that we are written where we expect to be written */
+	if (slot != readl(&nd_label->slot))
+		return false;
+
+	/* check that DPA allocations are page aligned */
+	if ((readq(&nd_label->dpa) | readq(&nd_label->rawsize)) % SZ_4K)
+		return false;
+
+	return true;
+}
+
+int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd)
+{
+	struct nd_namespace_index __iomem *nsindex;
+	unsigned long *free;
+	u32 nslot, slot;
+
+	if (!preamble_current(ndd, &nsindex, &free, &nslot))
+		return 0; /* no label, nothing to reserve */
+
+	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_namespace_label __iomem *nd_label;
+		struct nd_region *nd_region = NULL;
+		u8 label_uuid[NSLABEL_UUID_LEN];
+		struct nd_label_id *label_id;
+		struct resource *res;
+		u32 flags;
+
+		nd_label = nd_label_base(ndd) + slot;
+
+		if (!slot_valid(nd_label, slot))
+			continue;
+
+		label_id = devm_kzalloc(ndd->dev, sizeof(*label_id),
+				GFP_KERNEL);
+		if (!label_id)
+			return -ENOMEM;
+		memcpy_fromio(label_uuid, nd_label->uuid,
+				NSLABEL_UUID_LEN);
+		flags = readl(&nd_label->flags);
+		res = __request_region(&ndd->dpa, readq(&nd_label->dpa),
+				readq(&nd_label->rawsize),
+				nd_label_gen_id(label_id, label_uuid, flags), 0);
+		nd_dbg_dpa(nd_region, ndd, res, "reserve\n");
+		if (!res)
+			return -EBUSY;
+	}
+
+	return 0;
+}
diff --git a/drivers/block/nd/label.h b/drivers/block/nd/label.h
new file mode 100644
index 000000000000..79ed885a43c0
--- /dev/null
+++ b/drivers/block/nd/label.h
@@ -0,0 +1,129 @@
+/*
+ * Copyright(c) 2013-2015 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __LABEL_H__
+#define __LABEL_H__
+
+#include <linux/ndctl.h>
+#include <linux/sizes.h>
+#include <linux/io.h>
+
+enum {
+	NSINDEX_SIG_LEN = 16,
+	NSINDEX_ALIGN = 256,
+	NSINDEX_SEQ_MASK = 0x3,
+	NSLABEL_UUID_LEN = 16,
+	NSLABEL_NAME_LEN = 64,
+	NSLABEL_FLAG_ROLABEL = 0x1,  /* read-only label */
+	NSLABEL_FLAG_LOCAL = 0x2,    /* DIMM-local namespace */
+	NSLABEL_FLAG_BTT = 0x4,      /* namespace contains a BTT */
+	NSLABEL_FLAG_UPDATING = 0x8, /* label being updated */
+	BTT_ALIGN = 4096,            /* all btt structures */
+	BTTINFO_SIG_LEN = 16,
+	BTTINFO_UUID_LEN = 16,
+	BTTINFO_FLAG_ERROR = 0x1,    /* error state (read-only) */
+	BTTINFO_MAJOR_VERSION = 1,
+	ND_LABEL_MIN_SIZE = 512 * 129, /* see sizeof_namespace_index() */
+	ND_LABEL_ID_SIZE = 50,
+};
+
+static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
+
+/**
+ * struct nd_namespace_index - label set superblock
+ * @sig: NAMESPACE_INDEX\0
+ * @flags: placeholder
+ * @seq: sequence number for this index
+ * @myoff: offset of this index in label area
+ * @mysize: size of this index struct
+ * @otheroff: offset of other index
+ * @labeloff: offset of first label slot
+ * @nslot: total number of label slots
+ * @major: label area major version
+ * @minor: label area minor version
+ * @checksum: fletcher64 of all fields
+ * @free[0]: bitmap, nlabel bits
+ *
+ * The size of free[] is rounded up so the total struct size is a
+ * multiple of NSINDEX_ALIGN bytes.  Any bits this allocates beyond
+ * nlabel bits must be zero.
+ */
+struct nd_namespace_index {
+	u8 sig[NSINDEX_SIG_LEN];
+	__le32 flags;
+	__le32 seq;
+	__le64 myoff;
+	__le64 mysize;
+	__le64 otheroff;
+	__le64 labeloff;
+	__le32 nslot;
+	__le16 major;
+	__le16 minor;
+	__le64 checksum;
+	u8 free[0];
+};
+
+/**
+ * struct nd_namespace_label - namespace superblock
+ * @uuid: UUID per RFC 4122
+ * @name: optional name (NULL-terminated)
+ * @flags: see NSLABEL_FLAG_*
+ * @nlabel: num labels to describe this ns
+ * @position: labels position in set
+ * @isetcookie: interleave set cookie
+ * @lbasize: LBA size in bytes or 0 for pmem
+ * @dpa: DPA of NVM range on this DIMM
+ * @rawsize: size of namespace
+ * @slot: slot of this label in label area
+ * @unused: must be zero
+ */
+struct nd_namespace_label {
+	u8 uuid[NSLABEL_UUID_LEN];
+	u8 name[NSLABEL_NAME_LEN];
+	__le32 flags;
+	__le16 nlabel;
+	__le16 position;
+	__le64 isetcookie;
+	__le64 lbasize;
+	__le64 dpa;
+	__le64 rawsize;
+	__le32 slot;
+	__le32 unused;
+};
+
+/**
+ * struct nd_label_id - identifier string for dpa allocation
+ * @id: "{blk|pmem}-<namespace uuid>"
+ */
+struct nd_label_id {
+	char id[ND_LABEL_ID_SIZE];
+};
+
+/*
+ * If the 'best' index is invalid, so is the 'next' index.  Otherwise,
+ * the next index is MOD(index+1, 2)
+ */
+static inline int nd_label_next_nsindex(int index)
+{
+	if (index < 0)
+		return -1;
+
+	return (index + 1) % 2;
+}
+
+struct nd_dimm_drvdata;
+int nd_label_validate(struct nd_dimm_drvdata *ndd);
+void nd_label_copy(struct nd_dimm_drvdata *ndd,
+		struct nd_namespace_index *dst,
+		struct nd_namespace_index *src);
+size_t sizeof_namespace_index(struct nd_dimm_drvdata *ndd);
+#endif /* __LABEL_H__ */
diff --git a/drivers/block/nd/nd.h b/drivers/block/nd/nd.h
index c69707dbd272..832103a5e3f7 100644
--- a/drivers/block/nd/nd.h
+++ b/drivers/block/nd/nd.h
@@ -16,11 +16,15 @@
 #include <linux/mutex.h>
 #include <linux/ndctl.h>
 #include "libnd.h"
+#include "label.h"
 
 struct nd_dimm_drvdata {
 	struct device *dev;
+	int nsindex_size;
 	struct nd_cmd_get_config_size nsarea;
 	void *data;
+	int ns_current, ns_next;
+	struct resource dpa;
 };
 
 struct nd_region_namespaces {
@@ -28,6 +32,37 @@ struct nd_region_namespaces {
 	int active;
 };
 
+static inline struct nd_namespace_index __iomem *to_namespace_index(
+		struct nd_dimm_drvdata *ndd, int i)
+{
+	if (i < 0)
+		return NULL;
+
+	return ((void __iomem *) ndd->data + sizeof_namespace_index(ndd) * i);
+}
+
+static inline struct nd_namespace_index __iomem *to_current_namespace_index(
+		struct nd_dimm_drvdata *ndd)
+{
+	return to_namespace_index(ndd, ndd->ns_current);
+}
+
+static inline struct nd_namespace_index __iomem *to_next_namespace_index(
+		struct nd_dimm_drvdata *ndd)
+{
+	return to_namespace_index(ndd, ndd->ns_next);
+}
+
+#define nd_dbg_dpa(r, d, res, fmt, arg...) \
+	dev_dbg((r) ? &(r)->dev : (d)->dev, "%s: %.13s: %#llx @ %#llx " fmt, \
+		(r) ? dev_name((d)->dev) : "", res ? res->name : "null", \
+		(unsigned long long) (res ? resource_size(res) : 0), \
+		(unsigned long long) (res ? res->start : 0), ##arg)
+
+#define for_each_dpa_resource_safe(ndd, res, next) \
+	for (res = (ndd)->dpa.child, next = res ? res->sibling : NULL; \
+			res; res = next, next = next ? next->sibling : NULL)
+
 struct nd_region {
 	struct device dev;
 	u16 ndr_mappings;
@@ -39,6 +74,15 @@ struct nd_region {
 	struct nd_mapping mapping[0];
 };
 
+/*
+ * Lookup next in the repeating sequence of 01, 10, and 11.
+ */
+static inline unsigned nd_inc_seq(unsigned seq)
+{
+	static const unsigned next[] = { 0, 2, 3, 1 };
+
+	return next[seq & 3];
+}
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -54,4 +98,5 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 void nd_bus_lock(struct device *dev);
 void nd_bus_unlock(struct device *dev);
 bool is_nd_bus_locked(struct device *dev);
+int nd_label_reserve_dpa(struct nd_dimm_drvdata *ndd);
 #endif /* __ND_H__ */
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 5ffa319f3408..624a19d9e6e4 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -175,7 +175,6 @@ static inline const char *nd_dimm_cmd_name(unsigned cmd)
 #define ND_IOCTL_ARS_QUERY		_IOWR(ND_IOCTL, ND_CMD_ARS_QUERY,\
 					struct nd_cmd_ars_query)
 
-
 #define ND_DEVICE_DIMM 1            /* nd_dimm: container for "config data" */
 #define ND_DEVICE_REGION_PMEM 2     /* nd_region: (parent of pmem namespaces) */
 #define ND_DEVICE_REGION_BLK 3      /* nd_region: (parent of blk namespaces) */

