Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9B3F21959CB2
 for <linux-nvdimm@lists.01.org>; Sun, 27 Jan 2019 16:31:19 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 5/5] libnvdimm,
 namespace: allocate devs for namespace just once
Date: Mon, 28 Jan 2019 08:30:18 +0800
Message-Id: <20190128003018.4087-5-richardw.yang@linux.intel.com>
In-Reply-To: <20190128003018.4087-1-richardw.yang@linux.intel.com>
References: <20190128003018.4087-1-richardw.yang@linux.intel.com>
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
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Current scan_labels() will allocate devs for namespace step by step. The
logic is correct while it requires:

  * more interaction with mm subsystem
  * memcpy for each new allocation

Since each namespace has different uuid for its label, we can calculate
the number of possible namespace during label initialization and
allocate devs for namespace just once.

This patch achieve the effect by:

  * add a labels_uuid_num field in nd_mapping
  * record number of different label uuid in labels_uuid_num
  * allocate devs for namespace based on labels_uuid_num

After that, we could clean up the memory allocation in scan_labels().

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 29 +++++++++++++++++------------
 drivers/nvdimm/nd.h             |  1 +
 drivers/nvdimm/region_devs.c    |  1 +
 3 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index cdf3049bd2b9..53ac2716b2b4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2293,10 +2293,14 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
 	resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
 
+	devs = kcalloc(nd_mapping->labels_uuid_num + 2,
+		       sizeof(dev), GFP_KERNEL);
+	if (!devs)
+		return NULL;
+
 	/* "safe" because create_namespace_pmem() might list_move() label_ent */
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		struct nd_namespace_label *nd_label = label_ent->label;
-		struct device **__devs;
 		u32 flags;
 
 		if (!nd_label)
@@ -2317,12 +2321,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
 			goto err;
 		if (i < count)
 			continue;
-		__devs = kcalloc(count + 2, sizeof(dev), GFP_KERNEL);
-		if (!__devs)
-			goto err;
-		memcpy(__devs, devs, sizeof(dev) * count);
-		kfree(devs);
-		devs = __devs;
 
 		if (is_nd_blk(&nd_region->dev))
 			dev = create_namespace_blk(nd_region, nd_label, count);
@@ -2358,9 +2356,6 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		/* Publish a zero-sized namespace for userspace to configure. */
 		nd_mapping_free_labels(nd_mapping);
 
-		devs = kcalloc(2, sizeof(dev), GFP_KERNEL);
-		if (!devs)
-			goto err;
 		if (is_nd_blk(&nd_region->dev)) {
 			struct nd_namespace_blk *nsblk;
 
@@ -2452,11 +2447,12 @@ static struct device **create_namespaces(struct nd_region *nd_region)
 static int __init_active_labels(struct nd_mapping *nd_mapping, int count)
 {
 	struct nvdimm_drvdata *ndd = nd_mapping->ndd;
-	struct nd_label_ent *label_ent;
+	struct nd_label_ent *label_ent, *e;
 	int j;
 
 	for (j = 0; j < count; j++) {
-		struct nd_namespace_label *label;
+		struct nd_namespace_label *label, *l;
+		int new_uuid = 1;
 
 		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 		if (!label_ent)
@@ -2465,6 +2461,15 @@ static int __init_active_labels(struct nd_mapping *nd_mapping, int count)
 		label_ent->label = label;
 
 		mutex_lock(&nd_mapping->lock);
+		list_for_each_entry(e, &nd_mapping->labels, list) {
+			l = e->label;
+
+			if (!memcmp(label->uuid, l->uuid, NSLABEL_UUID_LEN)) {
+				new_uuid = 0;
+				break;
+			}
+		}
+		nd_mapping->labels_uuid_num += new_uuid;
 		list_add_tail(&label_ent->list, &nd_mapping->labels);
 		mutex_unlock(&nd_mapping->lock);
 	}
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e79cc8e5c114..b143a67a1a34 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -128,6 +128,7 @@ struct nd_mapping {
 	u64 start;
 	u64 size;
 	int position;
+	int labels_uuid_num;
 	struct list_head labels;
 	struct mutex lock;
 	/*
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e7377f1028ef..cb10cd2045ef 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -1049,6 +1049,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		nd_region->mapping[i].size = mapping->size;
 		nd_region->mapping[i].position = mapping->position;
 		INIT_LIST_HEAD(&nd_region->mapping[i].labels);
+		nd_region->mapping[i].labels_uuid_num = 0;
 		mutex_init(&nd_region->mapping[i].lock);
 
 		get_device(&nvdimm->dev);
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
