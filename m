Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 960111A1E4F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:05 -0700 (PDT)
Subject: [PATCH 04/14] libnvdimm, namespace: unify blk and pmem label scanning
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:02 -0700
Message-ID: <147585834240.22349.16618657482026683365.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for allowing multiple namespace per pmem region, unify
blk and pmem label scanning.  Given that blk regions already support
multiple namespaces, teaching that path how to do pmem namespace
scanning is an incremental step towards multiple pmem namespace support.
This should be functionally equivalent to the previous state in that
stops after finding the first valid pmem label set.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |  385 +++++++++++++++++++++------------------
 1 file changed, 207 insertions(+), 178 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 0e62f46755e7..fbcadc7cb8fd 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1550,7 +1550,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 		u64 hw_start, hw_end, pmem_start, pmem_end;
 		struct nd_label_ent *label_ent;
 
-		mutex_lock(&nd_mapping->lock);
+		WARN_ON(!mutex_is_locked(&nd_mapping->lock));
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 			nd_label = label_ent->label;
 			if (!nd_label)
@@ -1559,7 +1559,6 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 				break;
 			nd_label = NULL;
 		}
-		mutex_unlock(&nd_mapping->lock);
 
 		if (!nd_label) {
 			WARN_ON(1);
@@ -1579,88 +1578,65 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 		else
 			return -EINVAL;
 
-		mutex_lock(&nd_mapping->lock);
-		label_ent = list_first_entry(&nd_mapping->labels,
-				typeof(*label_ent), list);
-		label_ent->label = nd_label;
-		list_del(&label_ent->list);
-		nd_mapping_free_labels(nd_mapping);
-		list_add(&label_ent->list, &nd_mapping->labels);
-		mutex_unlock(&nd_mapping->lock);
+		/* move recently validated label to the front of the list */
+		list_move(&label_ent->list, &nd_mapping->labels);
 	}
 	return 0;
 }
 
 /**
- * find_pmem_label_set - validate interleave set labelling, retrieve label0
+ * create_namespace_pmem - validate interleave set labelling, retrieve label0
  * @nd_region: region with mappings to validate
+ * @nspm: target namespace to create
+ * @nd_label: target pmem namespace label to evaluate
  */
-static int find_pmem_label_set(struct nd_region *nd_region,
-		struct nd_namespace_pmem *nspm)
+struct device *create_namespace_pmem(struct nd_region *nd_region,
+		struct nd_namespace_label *nd_label)
 {
 	u64 cookie = nd_region_interleave_set_cookie(nd_region);
-	u8 select_id[NSLABEL_UUID_LEN];
 	struct nd_label_ent *label_ent;
+	struct nd_namespace_pmem *nspm;
 	struct nd_mapping *nd_mapping;
 	resource_size_t size = 0;
-	u8 *pmem_id = NULL;
+	struct resource *res;
+	struct device *dev;
 	int rc = 0;
 	u16 i;
 
 	if (cookie == 0) {
 		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
-		return -ENXIO;
+		return ERR_PTR(-ENXIO);
 	}
 
-	/*
-	 * Find a complete set of labels by uuid.  By definition we can start
-	 * with any mapping as the reference label
-	 */
-	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		nd_mapping = &nd_region->mapping[i];
-		mutex_lock_nested(&nd_mapping->lock, i);
+	if (__le64_to_cpu(nd_label->isetcookie) != cookie) {
+		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
+				nd_label->uuid);
+		return ERR_PTR(-EAGAIN);
 	}
-	list_for_each_entry(label_ent, &nd_region->mapping[0].labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
 
-		if (!nd_label)
-			continue;
-		if (__le64_to_cpu(nd_label->isetcookie) != cookie)
-			continue;
-
-		for (i = 0; i < nd_region->ndr_mappings; i++)
-			if (!has_uuid_at_pos(nd_region, nd_label->uuid,
-						cookie, i))
-				break;
-		if (i < nd_region->ndr_mappings) {
-			/*
-			 * Give up if we don't find an instance of a
-			 * uuid at each position (from 0 to
-			 * nd_region->ndr_mappings - 1), or if we find a
-			 * dimm with two instances of the same uuid.
-			 */
-			rc = -EINVAL;
-			break;
-		} else if (pmem_id) {
-			/*
-			 * If there is more than one valid uuid set, we
-			 * need userspace to clean this up.
-			 */
-			rc = -EBUSY;
-			break;
-		}
-		memcpy(select_id, nd_label->uuid, NSLABEL_UUID_LEN);
-		pmem_id = select_id;
-	}
-	for (i = 0; i < nd_region->ndr_mappings; i++) {
-		int reverse = nd_region->ndr_mappings - 1 - i;
+	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
+	if (!nspm)
+		return ERR_PTR(-ENOMEM);
 
-		nd_mapping = &nd_region->mapping[reverse];
-		mutex_unlock(&nd_mapping->lock);
-	}
+	dev = &nspm->nsio.common.dev;
+	dev->type = &namespace_pmem_device_type;
+	dev->parent = &nd_region->dev;
+	res = &nspm->nsio.res;
+	res->name = dev_name(&nd_region->dev);
+	res->flags = IORESOURCE_MEM;
 
-	if (rc)
+	for (i = 0; i < nd_region->ndr_mappings; i++)
+		if (!has_uuid_at_pos(nd_region, nd_label->uuid, cookie, i))
+			break;
+	if (i < nd_region->ndr_mappings) {
+		/*
+		 * Give up if we don't find an instance of a uuid at each
+		 * position (from 0 to nd_region->ndr_mappings - 1), or if we
+		 * find a dimm with two instances of the same uuid.
+		 */
+		rc = -EINVAL;
 		goto err;
+	}
 
 	/*
 	 * Fix up each mapping's 'labels' to have the validated pmem label for
@@ -1670,7 +1646,7 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 	 * the dimm being enabled (i.e. nd_label_reserve_dpa()
 	 * succeeded).
 	 */
-	rc = select_pmem_id(nd_region, pmem_id);
+	rc = select_pmem_id(nd_region, nd_label->uuid);
 	if (rc)
 		goto err;
 
@@ -1679,11 +1655,9 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 		struct nd_namespace_label *label0;
 
 		nd_mapping = &nd_region->mapping[i];
-		mutex_lock(&nd_mapping->lock);
 		label_ent = list_first_entry_or_null(&nd_mapping->labels,
 				typeof(*label_ent), list);
 		label0 = label_ent ? label_ent->label : 0;
-		mutex_unlock(&nd_mapping->lock);
 
 		if (!label0) {
 			WARN_ON(1);
@@ -1707,8 +1681,9 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 
 	nd_namespace_pmem_set_size(nd_region, nspm, size);
 
-	return 0;
+	return dev;
  err:
+	namespace_pmem_release(dev);
 	switch (rc) {
 	case -EINVAL:
 		dev_dbg(&nd_region->dev, "%s: invalid label(s)\n", __func__);
@@ -1721,56 +1696,7 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 				__func__, rc);
 		break;
 	}
-	return rc;
-}
-
-static struct device **create_namespace_pmem(struct nd_region *nd_region)
-{
-	struct nd_namespace_pmem *nspm;
-	struct device *dev, **devs;
-	struct resource *res;
-	int rc;
-
-	nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
-	if (!nspm)
-		return NULL;
-
-	dev = &nspm->nsio.common.dev;
-	dev->type = &namespace_pmem_device_type;
-	dev->parent = &nd_region->dev;
-	res = &nspm->nsio.res;
-	res->name = dev_name(&nd_region->dev);
-	res->flags = IORESOURCE_MEM;
-	rc = find_pmem_label_set(nd_region, nspm);
-	if (rc == -ENODEV) {
-		int i;
-
-		/* Pass, try to permit namespace creation... */
-		for (i = 0; i < nd_region->ndr_mappings; i++) {
-			struct nd_mapping *nd_mapping = &nd_region->mapping[i];
-
-			mutex_lock(&nd_mapping->lock);
-			nd_mapping_free_labels(nd_mapping);
-			mutex_unlock(&nd_mapping->lock);
-		}
-
-		/* Publish a zero-sized namespace for userspace to configure. */
-		nd_namespace_pmem_set_size(nd_region, nspm, 0);
-
-		rc = 0;
-	} else if (rc)
-		goto err;
-
-	devs = kcalloc(2, sizeof(struct device *), GFP_KERNEL);
-	if (!devs)
-		goto err;
-
-	devs[0] = dev;
-	return devs;
-
- err:
-	namespace_pmem_release(&nspm->nsio.common.dev);
-	return NULL;
+	return ERR_PTR(rc);
 }
 
 struct resource *nsblk_add_resource(struct nd_region *nd_region,
@@ -1872,43 +1798,107 @@ void nd_region_create_btt_seed(struct nd_region *nd_region)
 		dev_err(&nd_region->dev, "failed to create btt namespace\n");
 }
 
-static struct device **scan_labels(struct nd_region *nd_region,
-		struct nd_mapping *nd_mapping)
+static int add_namespace_resource(struct nd_region *nd_region,
+		struct nd_namespace_label *nd_label, struct device **devs,
+		int count)
 {
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	int i;
+
+	for (i = 0; i < count; i++) {
+		u8 *uuid = namespace_to_uuid(devs[i]);
+		struct resource *res;
+
+		if (IS_ERR_OR_NULL(uuid)) {
+			WARN_ON(1);
+			continue;
+		}
+
+		if (memcmp(uuid, nd_label->uuid, NSLABEL_UUID_LEN) != 0)
+			continue;
+		if (is_namespace_blk(devs[i])) {
+			res = nsblk_add_resource(nd_region, ndd,
+					to_nd_namespace_blk(devs[i]),
+					__le64_to_cpu(nd_label->dpa));
+			if (!res)
+				return -ENXIO;
+			nd_dbg_dpa(nd_region, ndd, res, "%d assign\n", count);
+		} else {
+			dev_err(&nd_region->dev,
+					"error: conflicting extents for uuid: %pUb\n",
+					nd_label->uuid);
+			return -ENXIO;
+		}
+		break;
+	}
+
+	return i;
+}
+
+struct device *create_namespace_blk(struct nd_region *nd_region,
+		struct nd_namespace_label *nd_label, int count)
+{
+
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct device *dev, **devs = NULL;
 	struct nd_namespace_blk *nsblk;
-	struct nd_label_ent *label_ent;
+	char *name[NSLABEL_NAME_LEN];
+	struct device *dev = NULL;
+	struct resource *res;
+
+	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
+	if (!nsblk)
+		return ERR_PTR(-ENOMEM);
+	dev = &nsblk->common.dev;
+	dev->type = &namespace_blk_device_type;
+	dev->parent = &nd_region->dev;
+	nsblk->id = -1;
+	nsblk->lbasize = __le64_to_cpu(nd_label->lbasize);
+	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
+			GFP_KERNEL);
+	if (!nsblk->uuid)
+		goto blk_err;
+	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
+	if (name[0])
+		nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
+				GFP_KERNEL);
+	res = nsblk_add_resource(nd_region, ndd, nsblk,
+			__le64_to_cpu(nd_label->dpa));
+	if (!res)
+		goto blk_err;
+	nd_dbg_dpa(nd_region, ndd, res, "%d: assign\n", count);
+	return dev;
+ blk_err:
+	namespace_blk_release(dev);
+	return ERR_PTR(-ENXIO);
+}
+
+static struct device **scan_labels(struct nd_region *nd_region)
+{
+	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+	struct device *dev, **devs = NULL;
+	struct nd_label_ent *label_ent, *e;
 	int i, count = 0;
 
-	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+	/* "safe" because create_namespace_pmem() might list_move() label_ent */
+	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		struct nd_namespace_label *nd_label = label_ent->label;
-		char *name[NSLABEL_NAME_LEN];
 		struct device **__devs;
-		struct resource *res;
 		u32 flags;
 
 		if (!nd_label)
 			continue;
 		flags = __le32_to_cpu(nd_label->flags);
-		if (flags & NSLABEL_FLAG_LOCAL)
-			/* pass */;
+		if (is_nd_blk(&nd_region->dev)
+				== !!(flags & NSLABEL_FLAG_LOCAL))
+			/* pass, region matches label type */;
 		else
 			continue;
 
-		for (i = 0; i < count; i++) {
-			nsblk = to_nd_namespace_blk(devs[i]);
-			if (memcmp(nsblk->uuid, nd_label->uuid,
-						NSLABEL_UUID_LEN) == 0) {
-				res = nsblk_add_resource(nd_region, ndd, nsblk,
-						__le64_to_cpu(nd_label->dpa));
-				if (!res)
-					goto err;
-				nd_dbg_dpa(nd_region, ndd, res, "%s assign\n",
-					dev_name(&nsblk->common.dev));
-				break;
-			}
-		}
+		i = add_namespace_resource(nd_region, nd_label, devs, count);
+		if (i < 0)
+			goto err;
 		if (i < count)
 			continue;
 		__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
@@ -1918,34 +1908,35 @@ static struct device **scan_labels(struct nd_region *nd_region,
 		kfree(devs);
 		devs = __devs;
 
-		nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
-		if (!nsblk)
-			goto err;
-		dev = &nsblk->common.dev;
-		dev->type = &namespace_blk_device_type;
-		dev->parent = &nd_region->dev;
-		dev_set_name(dev, "namespace%d.%d", nd_region->id, count);
-		devs[count++] = dev;
-		nsblk->id = -1;
-		nsblk->lbasize = __le64_to_cpu(nd_label->lbasize);
-		nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
-				GFP_KERNEL);
-		if (!nsblk->uuid)
-			goto err;
-		memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
-		if (name[0])
-			nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
-					GFP_KERNEL);
-		res = nsblk_add_resource(nd_region, ndd, nsblk,
-				__le64_to_cpu(nd_label->dpa));
-		if (!res)
-			goto err;
-		nd_dbg_dpa(nd_region, ndd, res, "%s assign\n",
-				dev_name(&nsblk->common.dev));
+		if (is_nd_blk(&nd_region->dev)) {
+			dev = create_namespace_blk(nd_region, nd_label, count);
+			if (IS_ERR(dev))
+				goto err;
+			devs[count++] = dev;
+		} else {
+			dev = create_namespace_pmem(nd_region, nd_label);
+			if (IS_ERR(dev)) {
+				switch (PTR_ERR(dev)) {
+				case -EAGAIN:
+					/* skip invalid labels */
+					continue;
+				case -ENODEV:
+					/* fallthrough to seed creation */
+					break;
+				default:
+					goto err;
+				}
+			} else
+				devs[count++] = dev;
+
+			/* we only expect one valid pmem label set per region */
+			break;
+		}
 	}
 
-	dev_dbg(&nd_region->dev, "%s: discovered %d blk namespace%s\n",
-			__func__, count, count == 1 ? "" : "s");
+	dev_dbg(&nd_region->dev, "%s: discovered %d %s namespace%s\n",
+			__func__, count, is_nd_blk(&nd_region->dev)
+			? "blk" : "pmem", count == 1 ? "" : "s");
 
 	if (count == 0) {
 		/* Publish a zero-sized namespace for userspace to configure. */
@@ -1954,37 +1945,77 @@ static struct device **scan_labels(struct nd_region *nd_region,
 		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
 		if (!devs)
 			goto err;
-		nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
-		if (!nsblk)
-			goto err;
-		dev = &nsblk->common.dev;
-		dev->type = &namespace_blk_device_type;
+		if (is_nd_blk(&nd_region->dev)) {
+			struct nd_namespace_blk *nsblk;
+
+			nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
+			if (!nsblk)
+				goto err;
+			dev = &nsblk->common.dev;
+			dev->type = &namespace_blk_device_type;
+		} else {
+			struct nd_namespace_pmem *nspm;
+
+			nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
+			if (!nspm)
+				goto err;
+			dev = &nspm->nsio.common.dev;
+			dev->type = &namespace_pmem_device_type;
+			nd_namespace_pmem_set_size(nd_region, nspm, 0);
+		}
 		dev->parent = &nd_region->dev;
 		devs[count++] = dev;
+	} else if (is_nd_pmem(&nd_region->dev)) {
+		/* clean unselected labels */
+		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			nd_mapping = &nd_region->mapping[i];
+			if (list_empty(&nd_mapping->labels)) {
+				WARN_ON(1);
+				continue;
+			}
+			label_ent = list_first_entry(&nd_mapping->labels,
+					typeof(*label_ent), list);
+			list_del(&label_ent->list);
+			nd_mapping_free_labels(nd_mapping);
+			list_add(&label_ent->list, &nd_mapping->labels);
+		}
 	}
 
 	return devs;
 
  err:
-	for (i = 0; devs[i]; i++) {
-		nsblk = to_nd_namespace_blk(devs[i]);
-		namespace_blk_release(&nsblk->common.dev);
-	}
+	for (i = 0; devs[i]; i++)
+		if (is_nd_blk(&nd_region->dev))
+			namespace_blk_release(devs[i]);
+		else
+			namespace_pmem_release(devs[i]);
 	kfree(devs);
 	return NULL;
 }
 
-static struct device **create_namespace_blk(struct nd_region *nd_region)
+static struct device **create_namespaces(struct nd_region *nd_region)
 {
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	struct device **devs;
+	int i;
 
 	if (nd_region->ndr_mappings == 0)
 		return NULL;
 
-	mutex_lock(&nd_mapping->lock);
-	devs = scan_labels(nd_region, nd_mapping);
-	mutex_unlock(&nd_mapping->lock);
+	/* lock down all mappings while we scan labels */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		nd_mapping = &nd_region->mapping[i];
+		mutex_lock_nested(&nd_mapping->lock, i);
+	}
+
+	devs = scan_labels(nd_region);
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		int reverse = nd_region->ndr_mappings - 1 - i;
+
+		nd_mapping = &nd_region->mapping[reverse];
+		mutex_unlock(&nd_mapping->lock);
+	}
 
 	return devs;
 }
@@ -2064,10 +2095,8 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 		devs = create_namespace_io(nd_region);
 		break;
 	case ND_DEVICE_NAMESPACE_PMEM:
-		devs = create_namespace_pmem(nd_region);
-		break;
 	case ND_DEVICE_NAMESPACE_BLK:
-		devs = create_namespace_blk(nd_region);
+		devs = create_namespaces(nd_region);
 		break;
 	default:
 		break;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
