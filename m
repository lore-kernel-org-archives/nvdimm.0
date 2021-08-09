Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76936D0F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 22:28:41 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="275829990"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="275829990"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="444726850"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:41 -0700
Subject: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ben.widawsky@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, ira.weiny@intel.com
Date: Mon, 09 Aug 2021 15:28:40 -0700
Message-ID: <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for CXL labels that move the uuid to a different offset
in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
proper uuid_t type. That type definition predated the libnvdimm
subsystem, so now is as a good a time as any to convert all the uuid
handling in the subsystem to uuid_t to match the helpers.

As for the whitespace changes, all new code is clang-format compliant.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/btt.c            |   11 +++--
 drivers/nvdimm/btt.h            |    4 +-
 drivers/nvdimm/btt_devs.c       |   12 +++---
 drivers/nvdimm/core.c           |   40 ++-----------------
 drivers/nvdimm/label.c          |   34 +++++++---------
 drivers/nvdimm/label.h          |    3 -
 drivers/nvdimm/namespace_devs.c |   83 ++++++++++++++++++++-------------------
 drivers/nvdimm/nd-core.h        |    5 +-
 drivers/nvdimm/nd.h             |   37 ++++++++++++++++-
 drivers/nvdimm/pfn_devs.c       |    2 -
 include/linux/nd.h              |    4 +-
 11 files changed, 115 insertions(+), 120 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 92dec4952297..1cdfbadb7408 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -973,7 +973,7 @@ static int btt_arena_write_layout(struct arena_info *arena)
 	u64 sum;
 	struct btt_sb *super;
 	struct nd_btt *nd_btt = arena->nd_btt;
-	const u8 *parent_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
+	const uuid_t *parent_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
 
 	ret = btt_map_init(arena);
 	if (ret)
@@ -988,8 +988,8 @@ static int btt_arena_write_layout(struct arena_info *arena)
 		return -ENOMEM;
 
 	strncpy(super->signature, BTT_SIG, BTT_SIG_LEN);
-	memcpy(super->uuid, nd_btt->uuid, 16);
-	memcpy(super->parent_uuid, parent_uuid, 16);
+	uuid_copy(&super->uuid, nd_btt->uuid);
+	uuid_copy(&super->parent_uuid, parent_uuid);
 	super->flags = cpu_to_le32(arena->flags);
 	super->version_major = cpu_to_le16(arena->version_major);
 	super->version_minor = cpu_to_le16(arena->version_minor);
@@ -1575,7 +1575,8 @@ static void btt_blk_cleanup(struct btt *btt)
  * Pointer to a new struct btt on success, NULL on failure.
  */
 static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
-		u32 lbasize, u8 *uuid, struct nd_region *nd_region)
+			    u32 lbasize, uuid_t *uuid,
+			    struct nd_region *nd_region)
 {
 	int ret;
 	struct btt *btt;
@@ -1694,7 +1695,7 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns)
 	}
 	nd_region = to_nd_region(nd_btt->dev.parent);
 	btt = btt_init(nd_btt, rawsize, nd_btt->lbasize, nd_btt->uuid,
-			nd_region);
+		       nd_region);
 	if (!btt)
 		return -ENOMEM;
 	nd_btt->btt = btt;
diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
index 0c76c0333f6e..fc3512d92ae5 100644
--- a/drivers/nvdimm/btt.h
+++ b/drivers/nvdimm/btt.h
@@ -94,8 +94,8 @@ struct log_group {
 
 struct btt_sb {
 	u8 signature[BTT_SIG_LEN];
-	u8 uuid[16];
-	u8 parent_uuid[16];
+	uuid_t uuid;
+	uuid_t parent_uuid;
 	__le32 flags;
 	__le16 version_major;
 	__le16 version_minor;
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index 05feb97e11ce..5ad45e9e48c9 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -180,8 +180,8 @@ bool is_nd_btt(struct device *dev)
 EXPORT_SYMBOL(is_nd_btt);
 
 static struct device *__nd_btt_create(struct nd_region *nd_region,
-		unsigned long lbasize, u8 *uuid,
-		struct nd_namespace_common *ndns)
+				      unsigned long lbasize, uuid_t *uuid,
+				      struct nd_namespace_common *ndns)
 {
 	struct nd_btt *nd_btt;
 	struct device *dev;
@@ -244,14 +244,14 @@ struct device *nd_btt_create(struct nd_region *nd_region)
  */
 bool nd_btt_arena_is_valid(struct nd_btt *nd_btt, struct btt_sb *super)
 {
-	const u8 *parent_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
+	const uuid_t *parent_uuid = nd_dev_to_uuid(&nd_btt->ndns->dev);
 	u64 checksum;
 
 	if (memcmp(super->signature, BTT_SIG, BTT_SIG_LEN) != 0)
 		return false;
 
-	if (!guid_is_null((guid_t *)&super->parent_uuid))
-		if (memcmp(super->parent_uuid, parent_uuid, 16) != 0)
+	if (!uuid_is_null(&super->parent_uuid))
+		if (!uuid_equal(&super->parent_uuid, parent_uuid))
 			return false;
 
 	checksum = le64_to_cpu(super->checksum);
@@ -319,7 +319,7 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
 		return rc;
 
 	nd_btt->lbasize = le32_to_cpu(btt_sb->external_lbasize);
-	nd_btt->uuid = kmemdup(btt_sb->uuid, 16, GFP_KERNEL);
+	nd_btt->uuid = kmemdup(&btt_sb->uuid, sizeof(uuid_t), GFP_KERNEL);
 	if (!nd_btt->uuid)
 		return -ENOMEM;
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 7de592d7eff4..690152d62bf0 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -206,38 +206,6 @@ struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus)
 }
 EXPORT_SYMBOL_GPL(to_nvdimm_bus_dev);
 
-static bool is_uuid_sep(char sep)
-{
-	if (sep == '\n' || sep == '-' || sep == ':' || sep == '\0')
-		return true;
-	return false;
-}
-
-static int nd_uuid_parse(struct device *dev, u8 *uuid_out, const char *buf,
-		size_t len)
-{
-	const char *str = buf;
-	u8 uuid[16];
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		if (!isxdigit(str[0]) || !isxdigit(str[1])) {
-			dev_dbg(dev, "pos: %d buf[%zd]: %c buf[%zd]: %c\n",
-					i, str - buf, str[0],
-					str + 1 - buf, str[1]);
-			return -EINVAL;
-		}
-
-		uuid[i] = (hex_to_bin(str[0]) << 4) | hex_to_bin(str[1]);
-		str += 2;
-		if (is_uuid_sep(*str))
-			str++;
-	}
-
-	memcpy(uuid_out, uuid, sizeof(uuid));
-	return 0;
-}
-
 /**
  * nd_uuid_store: common implementation for writing 'uuid' sysfs attributes
  * @dev: container device for the uuid property
@@ -248,21 +216,21 @@ static int nd_uuid_parse(struct device *dev, u8 *uuid_out, const char *buf,
  * (driver detached)
  * LOCKING: expects nd_device_lock() is held on entry
  */
-int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
+int nd_uuid_store(struct device *dev, uuid_t **uuid_out, const char *buf,
 		size_t len)
 {
-	u8 uuid[16];
+	uuid_t uuid;
 	int rc;
 
 	if (dev->driver)
 		return -EBUSY;
 
-	rc = nd_uuid_parse(dev, uuid, buf, len);
+	rc = uuid_parse(buf, &uuid);
 	if (rc)
 		return rc;
 
 	kfree(*uuid_out);
-	*uuid_out = kmemdup(uuid, sizeof(uuid), GFP_KERNEL);
+	*uuid_out = kmemdup(&uuid, sizeof(uuid), GFP_KERNEL);
 	if (!(*uuid_out))
 		return -ENOMEM;
 
diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 2ba31b883b28..99608e6aeaae 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -326,7 +326,8 @@ static bool preamble_index(struct nvdimm_drvdata *ndd, int idx,
 	return true;
 }
 
-char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags)
+char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
+		      u32 flags)
 {
 	if (!label_id || !uuid)
 		return NULL;
@@ -405,9 +406,9 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		struct nvdimm *nvdimm = to_nvdimm(ndd->dev);
 		struct nd_namespace_label *nd_label;
 		struct nd_region *nd_region = NULL;
-		u8 label_uuid[NSLABEL_UUID_LEN];
 		struct nd_label_id label_id;
 		struct resource *res;
+		uuid_t label_uuid;
 		u32 flags;
 
 		nd_label = to_label(ndd, slot);
@@ -415,11 +416,11 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		if (!slot_valid(ndd, nd_label, slot))
 			continue;
 
-		memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
+		nsl_get_uuid(ndd, nd_label, &label_uuid);
 		flags = nsl_get_flags(ndd, nd_label);
 		if (test_bit(NDD_NOBLK, &nvdimm->flags))
 			flags &= ~NSLABEL_FLAG_LOCAL;
-		nd_label_gen_id(&label_id, label_uuid, flags);
+		nd_label_gen_id(&label_id, &label_uuid, flags);
 		res = nvdimm_allocate_dpa(ndd, &label_id,
 					  nsl_get_dpa(ndd, nd_label),
 					  nsl_get_rawsize(ndd, nd_label));
@@ -896,7 +897,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 
 	nd_label = to_label(ndd, slot);
 	memset(nd_label, 0, sizeof_namespace_label(ndd));
-	memcpy(nd_label->uuid, nspm->uuid, NSLABEL_UUID_LEN);
+	nsl_set_uuid(ndd, nd_label, nspm->uuid);
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
 	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
@@ -923,9 +924,8 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
-		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags)
-				|| memcmp(nspm->uuid, label_ent->label->uuid,
-					NSLABEL_UUID_LEN) == 0)
+		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
+		    uuid_equal(nspm->uuid, nsl_ref_uuid(ndd, label_ent->label)))
 			reap_victim(nd_mapping, label_ent);
 	}
 
@@ -1050,7 +1050,6 @@ static int __blk_label_update(struct nd_region *nd_region,
 	unsigned long *free, *victim_map = NULL;
 	struct resource *res, **old_res_list;
 	struct nd_label_id label_id;
-	u8 uuid[NSLABEL_UUID_LEN];
 	int min_dpa_idx = 0;
 	LIST_HEAD(list);
 	u32 nslot, slot;
@@ -1088,8 +1087,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 		/* mark unused labels for garbage collection */
 		for_each_clear_bit_le(slot, free, nslot) {
 			nd_label = to_label(ndd, slot);
-			memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
-			if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+			if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
 				continue;
 			res = to_resource(ndd, nd_label);
 			if (res && is_old_resource(res, old_res_list,
@@ -1158,7 +1156,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 
 		nd_label = to_label(ndd, slot);
 		memset(nd_label, 0, sizeof_namespace_label(ndd));
-		memcpy(nd_label->uuid, nsblk->uuid, NSLABEL_UUID_LEN);
+		nsl_set_uuid(ndd, nd_label, nsblk->uuid);
 		nsl_set_name(ndd, nd_label, nsblk->alt_name);
 		nsl_set_flags(ndd, nd_label, NSLABEL_FLAG_LOCAL);
 
@@ -1206,8 +1204,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 		if (!nd_label)
 			continue;
 		nlabel++;
-		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
-		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+		if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
 			continue;
 		nlabel--;
 		list_move(&label_ent->list, &list);
@@ -1237,8 +1234,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 	}
 	for_each_clear_bit_le(slot, free, nslot) {
 		nd_label = to_label(ndd, slot);
-		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
-		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
+		if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
 			continue;
 		res = to_resource(ndd, nd_label);
 		res->flags &= ~DPA_RESOURCE_ADJUSTED;
@@ -1318,12 +1314,11 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
 	return max(num_labels, old_num_labels);
 }
 
-static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
+static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 	struct nd_label_ent *label_ent, *e;
 	struct nd_namespace_index *nsindex;
-	u8 label_uuid[NSLABEL_UUID_LEN];
 	unsigned long *free;
 	LIST_HEAD(list);
 	u32 nslot, slot;
@@ -1343,8 +1338,7 @@ static int del_labels(struct nd_mapping *nd_mapping, u8 *uuid)
 		if (!nd_label)
 			continue;
 		active++;
-		memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
-		if (memcmp(label_uuid, uuid, NSLABEL_UUID_LEN) != 0)
+		if (!nsl_validate_uuid(ndd, nd_label, uuid))
 			continue;
 		active--;
 		slot = to_slot(ndd, nd_label);
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 31f94fad7b92..e6e77691dbec 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -14,7 +14,6 @@ enum {
 	NSINDEX_SIG_LEN = 16,
 	NSINDEX_ALIGN = 256,
 	NSINDEX_SEQ_MASK = 0x3,
-	NSLABEL_UUID_LEN = 16,
 	NSLABEL_NAME_LEN = 64,
 	NSLABEL_FLAG_ROLABEL = 0x1,  /* read-only label */
 	NSLABEL_FLAG_LOCAL = 0x2,    /* DIMM-local namespace */
@@ -80,7 +79,7 @@ struct nd_namespace_index {
  * @unused: must be zero
  */
 struct nd_namespace_label {
-	u8 uuid[NSLABEL_UUID_LEN];
+	uuid_t uuid;
 	u8 name[NSLABEL_NAME_LEN];
 	__le32 flags;
 	__le16 nlabel;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 58c76d74127a..20ea3ccd1f29 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -51,7 +51,7 @@ static bool is_namespace_io(const struct device *dev);
 
 static int is_uuid_busy(struct device *dev, void *data)
 {
-	u8 *uuid1 = data, *uuid2 = NULL;
+	uuid_t *uuid1 = data, *uuid2 = NULL;
 
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
@@ -71,7 +71,7 @@ static int is_uuid_busy(struct device *dev, void *data)
 		uuid2 = nd_pfn->uuid;
 	}
 
-	if (uuid2 && memcmp(uuid1, uuid2, NSLABEL_UUID_LEN) == 0)
+	if (uuid2 && uuid_equal(uuid1, uuid2))
 		return -EBUSY;
 
 	return 0;
@@ -89,7 +89,7 @@ static int is_namespace_uuid_busy(struct device *dev, void *data)
  * @dev: any device on a nvdimm_bus
  * @uuid: uuid to check
  */
-bool nd_is_uuid_unique(struct device *dev, u8 *uuid)
+bool nd_is_uuid_unique(struct device *dev, uuid_t *uuid)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 
@@ -192,12 +192,10 @@ const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 }
 EXPORT_SYMBOL(nvdimm_namespace_disk_name);
 
-const u8 *nd_dev_to_uuid(struct device *dev)
+const uuid_t *nd_dev_to_uuid(struct device *dev)
 {
-	static const u8 null_uuid[16];
-
 	if (!dev)
-		return null_uuid;
+		return &uuid_null;
 
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
@@ -208,7 +206,7 @@ const u8 *nd_dev_to_uuid(struct device *dev)
 
 		return nsblk->uuid;
 	} else
-		return null_uuid;
+		return &uuid_null;
 }
 EXPORT_SYMBOL(nd_dev_to_uuid);
 
@@ -938,7 +936,8 @@ static void nd_namespace_pmem_set_resource(struct nd_region *nd_region,
 	res->end = res->start + size - 1;
 }
 
-static bool uuid_not_set(const u8 *uuid, struct device *dev, const char *where)
+static bool uuid_not_set(const uuid_t *uuid, struct device *dev,
+			 const char *where)
 {
 	if (!uuid) {
 		dev_dbg(dev, "%s: uuid not set\n", where);
@@ -957,7 +956,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 	struct nd_label_id label_id;
 	u32 flags = 0, remainder;
 	int rc, i, id = -1;
-	u8 *uuid = NULL;
+	uuid_t *uuid = NULL;
 
 	if (dev->driver || ndns->claim)
 		return -EBUSY;
@@ -1050,7 +1049,7 @@ static ssize_t size_store(struct device *dev,
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	unsigned long long val;
-	u8 **uuid = NULL;
+	uuid_t **uuid = NULL;
 	int rc;
 
 	rc = kstrtoull(buf, 0, &val);
@@ -1147,7 +1146,7 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR(size, 0444, size_show, size_store);
 
-static u8 *namespace_to_uuid(struct device *dev)
+static uuid_t *namespace_to_uuid(struct device *dev)
 {
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
@@ -1161,10 +1160,10 @@ static u8 *namespace_to_uuid(struct device *dev)
 		return ERR_PTR(-ENXIO);
 }
 
-static ssize_t uuid_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
-	u8 *uuid = namespace_to_uuid(dev);
+	uuid_t *uuid = namespace_to_uuid(dev);
 
 	if (IS_ERR(uuid))
 		return PTR_ERR(uuid);
@@ -1181,7 +1180,8 @@ static ssize_t uuid_show(struct device *dev,
  * @old_uuid: reference to the uuid storage location in the namespace object
  */
 static int namespace_update_uuid(struct nd_region *nd_region,
-		struct device *dev, u8 *new_uuid, u8 **old_uuid)
+				 struct device *dev, uuid_t *new_uuid,
+				 uuid_t **old_uuid)
 {
 	u32 flags = is_namespace_blk(dev) ? NSLABEL_FLAG_LOCAL : 0;
 	struct nd_label_id old_label_id;
@@ -1234,7 +1234,7 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 
 			if (!nd_label)
 				continue;
-			nd_label_gen_id(&label_id, nd_label->uuid,
+			nd_label_gen_id(&label_id, nsl_ref_uuid(ndd, nd_label),
 					nsl_get_flags(ndd, nd_label));
 			if (strcmp(old_label_id.id, label_id.id) == 0)
 				set_bit(ND_LABEL_REAP, &label_ent->flags);
@@ -1251,9 +1251,9 @@ static ssize_t uuid_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
-	u8 *uuid = NULL;
+	uuid_t *uuid = NULL;
+	uuid_t **ns_uuid;
 	ssize_t rc = 0;
-	u8 **ns_uuid;
 
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
@@ -1378,8 +1378,8 @@ static ssize_t dpa_extents_show(struct device *dev,
 {
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	struct nd_label_id label_id;
+	uuid_t *uuid = NULL;
 	int count = 0, i;
-	u8 *uuid = NULL;
 	u32 flags = 0;
 
 	nvdimm_bus_lock(dev);
@@ -1831,8 +1831,8 @@ static struct device **create_namespace_io(struct nd_region *nd_region)
 	return devs;
 }
 
-static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
-		u64 cookie, u16 pos)
+static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
+			    u64 cookie, u16 pos)
 {
 	struct nd_namespace_label *found = NULL;
 	int i;
@@ -1856,7 +1856,7 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
 				continue;
 
-			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
+			if (!nsl_validate_uuid(ndd, nd_label, uuid))
 				continue;
 
 			if (!nsl_validate_type_guid(ndd, nd_label,
@@ -1881,7 +1881,7 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 	return found != NULL;
 }
 
-static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
+static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 {
 	int i;
 
@@ -1900,7 +1900,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 			nd_label = label_ent->label;
 			if (!nd_label)
 				continue;
-			if (memcmp(nd_label->uuid, pmem_id, NSLABEL_UUID_LEN) == 0)
+			if (nsl_validate_uuid(ndd, nd_label, pmem_id))
 				break;
 			nd_label = NULL;
 		}
@@ -1923,7 +1923,8 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 			/* pass */;
 		else {
 			dev_dbg(&nd_region->dev, "%s invalid label for %pUb\n",
-					dev_name(ndd->dev), nd_label->uuid);
+				dev_name(ndd->dev),
+				nsl_ref_uuid(ndd, nd_label));
 			return -EINVAL;
 		}
 
@@ -1963,12 +1964,12 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 
 	if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
 		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
-				nd_label->uuid);
+			nsl_ref_uuid(ndd, nd_label));
 		if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
 			return ERR_PTR(-EAGAIN);
 
 		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
-				nd_label->uuid);
+			nsl_ref_uuid(ndd, nd_label));
 	}
 
 	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
@@ -1984,9 +1985,11 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	res->flags = IORESOURCE_MEM;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		if (has_uuid_at_pos(nd_region, nd_label->uuid, cookie, i))
+		if (has_uuid_at_pos(nd_region, nsl_ref_uuid(ndd, nd_label),
+				    cookie, i))
 			continue;
-		if (has_uuid_at_pos(nd_region, nd_label->uuid, altcookie, i))
+		if (has_uuid_at_pos(nd_region, nsl_ref_uuid(ndd, nd_label),
+				    altcookie, i))
 			continue;
 		break;
 	}
@@ -2000,7 +2003,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		 * find a dimm with two instances of the same uuid.
 		 */
 		dev_err(&nd_region->dev, "%s missing label for %pUb\n",
-				nvdimm_name(nvdimm), nd_label->uuid);
+			nvdimm_name(nvdimm), nsl_ref_uuid(ndd, nd_label));
 		rc = -EINVAL;
 		goto err;
 	}
@@ -2013,7 +2016,7 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 	 * the dimm being enabled (i.e. nd_label_reserve_dpa()
 	 * succeeded).
 	 */
-	rc = select_pmem_id(nd_region, nd_label->uuid);
+	rc = select_pmem_id(nd_region, nsl_ref_uuid(ndd, nd_label));
 	if (rc)
 		goto err;
 
@@ -2039,8 +2042,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		WARN_ON(nspm->alt_name || nspm->uuid);
 		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
 					 NSLABEL_NAME_LEN, GFP_KERNEL);
-		nspm->uuid = kmemdup((void __force *) label0->uuid,
-				NSLABEL_UUID_LEN, GFP_KERNEL);
+		nspm->uuid = kmemdup(nsl_ref_uuid(ndd, label0), sizeof(uuid_t),
+				     GFP_KERNEL);
 		nspm->lbasize = nsl_get_lbasize(ndd, label0);
 		nspm->nsio.common.claim_class =
 			nsl_get_claim_class(ndd, label0);
@@ -2217,15 +2220,15 @@ static int add_namespace_resource(struct nd_region *nd_region,
 	int i;
 
 	for (i = 0; i < count; i++) {
-		u8 *uuid = namespace_to_uuid(devs[i]);
+		uuid_t *uuid = namespace_to_uuid(devs[i]);
 		struct resource *res;
 
-		if (IS_ERR_OR_NULL(uuid)) {
+		if (IS_ERR(uuid)) {
 			WARN_ON(1);
 			continue;
 		}
 
-		if (memcmp(uuid, nd_label->uuid, NSLABEL_UUID_LEN) != 0)
+		if (!nsl_validate_uuid(ndd, nd_label, uuid))
 			continue;
 		if (is_namespace_blk(devs[i])) {
 			res = nsblk_add_resource(nd_region, ndd,
@@ -2236,8 +2239,8 @@ static int add_namespace_resource(struct nd_region *nd_region,
 			nd_dbg_dpa(nd_region, ndd, res, "%d assign\n", count);
 		} else {
 			dev_err(&nd_region->dev,
-					"error: conflicting extents for uuid: %pUb\n",
-					nd_label->uuid);
+				"error: conflicting extents for uuid: %pUb\n",
+				uuid);
 			return -ENXIO;
 		}
 		break;
@@ -2271,7 +2274,7 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	dev->parent = &nd_region->dev;
 	nsblk->id = -1;
 	nsblk->lbasize = nsl_get_lbasize(ndd, nd_label);
-	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN, GFP_KERNEL);
+	nsblk->uuid = kmemdup(nsl_ref_uuid(ndd, nd_label), sizeof(uuid_t), GFP_KERNEL);
 	nsblk->common.claim_class = nsl_get_claim_class(ndd, nd_label);
 	if (!nsblk->uuid)
 		goto blk_err;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 564faa36a3ca..a11850dd475d 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -126,8 +126,9 @@ void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus);
 void nd_synchronize(void);
 void __nd_device_register(struct device *dev);
 struct nd_label_id;
-char *nd_label_gen_id(struct nd_label_id *label_id, u8 *uuid, u32 flags);
-bool nd_is_uuid_unique(struct device *dev, u8 *uuid);
+char *nd_label_gen_id(struct nd_label_id *label_id, const uuid_t *uuid,
+		      u32 flags);
+bool nd_is_uuid_unique(struct device *dev, uuid_t *uuid);
 struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ac80d9680367..132a8021e3ad 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -176,6 +176,35 @@ static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
 	nd_label->lbasize = __cpu_to_le64(lbasize);
 }
 
+static inline const uuid_t *nsl_get_uuid(struct nvdimm_drvdata *ndd,
+					 struct nd_namespace_label *nd_label,
+					 uuid_t *uuid)
+{
+	uuid_copy(uuid, &nd_label->uuid);
+	return uuid;
+}
+
+static inline const uuid_t *nsl_set_uuid(struct nvdimm_drvdata *ndd,
+					 struct nd_namespace_label *nd_label,
+					 const uuid_t *uuid)
+{
+	uuid_copy(&nd_label->uuid, uuid);
+	return &nd_label->uuid;
+}
+
+static inline bool nsl_validate_uuid(struct nvdimm_drvdata *ndd,
+				     struct nd_namespace_label *nd_label,
+				     const uuid_t *uuid)
+{
+	return uuid_equal(&nd_label->uuid, uuid);
+}
+
+static inline const uuid_t *nsl_ref_uuid(struct nvdimm_drvdata *ndd,
+					 struct nd_namespace_label *nd_label)
+{
+	return &nd_label->uuid;
+}
+
 bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 u64 isetcookie);
@@ -334,7 +363,7 @@ struct nd_btt {
 	struct btt *btt;
 	unsigned long lbasize;
 	u64 size;
-	u8 *uuid;
+	uuid_t *uuid;
 	int id;
 	int initial_offset;
 	u16 version_major;
@@ -349,7 +378,7 @@ enum nd_pfn_mode {
 
 struct nd_pfn {
 	int id;
-	u8 *uuid;
+	uuid_t *uuid;
 	struct device dev;
 	unsigned long align;
 	unsigned long npfns;
@@ -377,7 +406,7 @@ void wait_nvdimm_bus_probe_idle(struct device *dev);
 void nd_device_register(struct device *dev);
 void nd_device_unregister(struct device *dev, enum nd_async_mode mode);
 void nd_device_notify(struct device *dev, enum nvdimm_event event);
-int nd_uuid_store(struct device *dev, u8 **uuid_out, const char *buf,
+int nd_uuid_store(struct device *dev, uuid_t **uuid_out, const char *buf,
 		size_t len);
 ssize_t nd_size_select_show(unsigned long current_size,
 		const unsigned long *supported, char *buf);
@@ -560,6 +589,6 @@ static inline bool is_bad_pmem(struct badblocks *bb, sector_t sector,
 	return false;
 }
 resource_size_t nd_namespace_blk_validate(struct nd_namespace_blk *nsblk);
-const u8 *nd_dev_to_uuid(struct device *dev);
+const uuid_t *nd_dev_to_uuid(struct device *dev);
 bool pmem_should_map_pages(struct device *dev);
 #endif /* __ND_H__ */
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index b499df630d4d..58eda16f5c53 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -452,7 +452,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
 	unsigned long align, start_pad;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
-	const u8 *parent_uuid = nd_dev_to_uuid(&ndns->dev);
+	const uuid_t *parent_uuid = nd_dev_to_uuid(&ndns->dev);
 
 	if (!pfn_sb || !ndns)
 		return -ENODEV;
diff --git a/include/linux/nd.h b/include/linux/nd.h
index ee9ad76afbba..8a8c63edb1b2 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -88,7 +88,7 @@ struct nd_namespace_pmem {
 	struct nd_namespace_io nsio;
 	unsigned long lbasize;
 	char *alt_name;
-	u8 *uuid;
+	uuid_t *uuid;
 	int id;
 };
 
@@ -105,7 +105,7 @@ struct nd_namespace_pmem {
 struct nd_namespace_blk {
 	struct nd_namespace_common common;
 	char *alt_name;
-	u8 *uuid;
+	uuid_t *uuid;
 	int id;
 	unsigned long lbasize;
 	resource_size_t size;

