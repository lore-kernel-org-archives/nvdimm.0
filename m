Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0EC41A1E93
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:15 -0700 (PDT)
Subject: [PATCH 06/14] libnvdimm,
 namespace: allow multiple pmem-namespaces per region at scan time
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:13 -0700
Message-ID: <147585835321.22349.8852857198901777164.stgit@dwillia2-desk3.amr.corp.intel.com>
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

If label scanning finds multiple valid pmem namespaces allow them to be
surfaced rather than fail namespace scanning. Support for creating
multiple namespaces per region is saved for a later patch.

Note that this adds some new error messages to clarify which of the pmem
namespaces in the set are potentially impacted by invalid labels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   84 +++++++++++++++++++++++++++++++++------
 include/linux/nd.h              |    2 +
 2 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index fbcadc7cb8fd..47d29632b937 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -29,7 +29,10 @@ static void namespace_io_release(struct device *dev)
 static void namespace_pmem_release(struct device *dev)
 {
 	struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+	struct nd_region *nd_region = to_nd_region(dev->parent);
 
+	if (nspm->id >= 0)
+		ida_simple_remove(&nd_region->ns_ida, nspm->id);
 	kfree(nspm->alt_name);
 	kfree(nspm->uuid);
 	kfree(nspm);
@@ -833,13 +836,45 @@ static int grow_dpa_allocation(struct nd_region *nd_region,
 	return 0;
 }
 
-static void nd_namespace_pmem_set_size(struct nd_region *nd_region,
+static void nd_namespace_pmem_set_resource(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size)
 {
 	struct resource *res = &nspm->nsio.res;
+	resource_size_t offset = 0;
 
-	res->start = nd_region->ndr_start;
-	res->end = nd_region->ndr_start + size - 1;
+	if (size && !nspm->uuid) {
+		WARN_ON_ONCE(1);
+		size = 0;
+	}
+
+	if (size && nspm->uuid) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[0];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct nd_label_id label_id;
+		struct resource *res;
+
+		if (!ndd) {
+			size = 0;
+			goto out;
+		}
+
+		nd_label_gen_id(&label_id, nspm->uuid, 0);
+
+		/* calculate a spa offset from the dpa allocation offset */
+		for_each_dpa_resource(ndd, res)
+			if (strcmp(res->name, label_id.id) == 0) {
+				offset = (res->start - nd_mapping->start)
+					* nd_region->ndr_mappings;
+				goto out;
+			}
+
+		WARN_ON_ONCE(1);
+		size = 0;
+	}
+
+ out:
+	res->start = nd_region->ndr_start + offset;
+	res->end = res->start + size - 1;
 }
 
 static bool uuid_not_set(const u8 *uuid, struct device *dev, const char *where)
@@ -930,7 +965,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 	if (is_namespace_pmem(dev)) {
 		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
 
-		nd_namespace_pmem_set_size(nd_region, nspm,
+		nd_namespace_pmem_set_resource(nd_region, nspm,
 				val * nd_region->ndr_mappings);
 	} else if (is_namespace_blk(dev)) {
 		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
@@ -1546,6 +1581,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nd_namespace_label *nd_label = NULL;
 		u64 hw_start, hw_end, pmem_start, pmem_end;
 		struct nd_label_ent *label_ent;
@@ -1573,10 +1609,14 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 		hw_end = hw_start + nd_mapping->size;
 		pmem_start = __le64_to_cpu(nd_label->dpa);
 		pmem_end = pmem_start + __le64_to_cpu(nd_label->rawsize);
-		if (pmem_start == hw_start && pmem_end <= hw_end)
+		if (pmem_start >= hw_start && pmem_start < hw_end
+				&& pmem_end <= hw_end && pmem_end > hw_start)
 			/* pass */;
-		else
+		else {
+			dev_dbg(&nd_region->dev, "%s invalid label for %pUb\n",
+					dev_name(ndd->dev), nd_label->uuid);
 			return -EINVAL;
+		}
 
 		/* move recently validated label to the front of the list */
 		list_move(&label_ent->list, &nd_mapping->labels);
@@ -1618,6 +1658,7 @@ struct device *create_namespace_pmem(struct nd_region *nd_region,
 	if (!nspm)
 		return ERR_PTR(-ENOMEM);
 
+	nspm->id = -1;
 	dev = &nspm->nsio.common.dev;
 	dev->type = &namespace_pmem_device_type;
 	dev->parent = &nd_region->dev;
@@ -1629,11 +1670,15 @@ struct device *create_namespace_pmem(struct nd_region *nd_region,
 		if (!has_uuid_at_pos(nd_region, nd_label->uuid, cookie, i))
 			break;
 	if (i < nd_region->ndr_mappings) {
+		struct nvdimm_drvdata *ndd = to_ndd(&nd_region->mapping[i]);
+
 		/*
 		 * Give up if we don't find an instance of a uuid at each
 		 * position (from 0 to nd_region->ndr_mappings - 1), or if we
 		 * find a dimm with two instances of the same uuid.
 		 */
+		dev_err(&nd_region->dev, "%s missing label for %pUb\n",
+				dev_name(ndd->dev), nd_label->uuid);
 		rc = -EINVAL;
 		goto err;
 	}
@@ -1679,7 +1724,7 @@ struct device *create_namespace_pmem(struct nd_region *nd_region,
 		goto err;
 	}
 
-	nd_namespace_pmem_set_size(nd_region, nspm, size);
+	nd_namespace_pmem_set_resource(nd_region, nspm, size);
 
 	return dev;
  err:
@@ -1961,23 +2006,31 @@ static struct device **scan_labels(struct nd_region *nd_region)
 				goto err;
 			dev = &nspm->nsio.common.dev;
 			dev->type = &namespace_pmem_device_type;
-			nd_namespace_pmem_set_size(nd_region, nspm, 0);
+			nd_namespace_pmem_set_resource(nd_region, nspm, 0);
 		}
 		dev->parent = &nd_region->dev;
 		devs[count++] = dev;
 	} else if (is_nd_pmem(&nd_region->dev)) {
 		/* clean unselected labels */
 		for (i = 0; i < nd_region->ndr_mappings; i++) {
+			struct list_head *l, *e;
+			LIST_HEAD(list);
+			int j;
+
 			nd_mapping = &nd_region->mapping[i];
 			if (list_empty(&nd_mapping->labels)) {
 				WARN_ON(1);
 				continue;
 			}
-			label_ent = list_first_entry(&nd_mapping->labels,
-					typeof(*label_ent), list);
-			list_del(&label_ent->list);
+
+			j = count;
+			list_for_each_safe(l, e, &nd_mapping->labels) {
+				if (!j--)
+					break;
+				list_move_tail(l, &list);
+			}
 			nd_mapping_free_labels(nd_mapping);
-			list_add(&label_ent->list, &nd_mapping->labels);
+			list_splice_init(&list, &nd_mapping->labels);
 		}
 	}
 
@@ -2117,6 +2170,13 @@ int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
 			id = ida_simple_get(&nd_region->ns_ida, 0, 0,
 					GFP_KERNEL);
 			nsblk->id = id;
+		} else if (type == ND_DEVICE_NAMESPACE_PMEM) {
+			struct nd_namespace_pmem *nspm;
+
+			nspm = to_nd_namespace_pmem(dev);
+			id = ida_simple_get(&nd_region->ns_ida, 0, 0,
+					GFP_KERNEL);
+			nspm->id = id;
 		} else
 			id = i;
 
diff --git a/include/linux/nd.h b/include/linux/nd.h
index f1ea426d6a5e..ddcc7788305c 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -77,11 +77,13 @@ struct nd_namespace_io {
  * @nsio: device and system physical address range to drive
  * @alt_name: namespace name supplied in the dimm label
  * @uuid: namespace name supplied in the dimm label
+ * @id: ida allocated id
  */
 struct nd_namespace_pmem {
 	struct nd_namespace_io nsio;
 	char *alt_name;
 	u8 *uuid;
+	int id;
 };
 
 /**

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
