Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A132E2194D387
 for <linux-nvdimm@lists.01.org>; Sun, 27 Jan 2019 16:31:17 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 4/5] libnvdimm,
 namespace: extract __init_active_labels to initialize labels for one
 nd_mapping
Date: Mon, 28 Jan 2019 08:30:17 +0800
Message-Id: <20190128003018.4087-4-richardw.yang@linux.intel.com>
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

This is a preparation for next patch, so that init_active_labels not too
huge.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 41 ++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 0d64c4b38a56..cdf3049bd2b9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2449,6 +2449,29 @@ static struct device **create_namespaces(struct nd_region *nd_region)
 	return devs;
 }
 
+static int __init_active_labels(struct nd_mapping *nd_mapping, int count)
+{
+	struct nvdimm_drvdata *ndd = nd_mapping->ndd;
+	struct nd_label_ent *label_ent;
+	int j;
+
+	for (j = 0; j < count; j++) {
+		struct nd_namespace_label *label;
+
+		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
+		if (!label_ent)
+			break;
+		label = nd_label_active(ndd, j);
+		label_ent->label = label;
+
+		mutex_lock(&nd_mapping->lock);
+		list_add_tail(&label_ent->list, &nd_mapping->labels);
+		mutex_unlock(&nd_mapping->lock);
+	}
+
+	return j;
+}
+
 static int init_active_labels(struct nd_region *nd_region)
 {
 	int i, errno = -ENOMEM;
@@ -2457,8 +2480,7 @@ static int init_active_labels(struct nd_region *nd_region)
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
-		struct nd_label_ent *label_ent;
-		int count, j;
+		int count;
 
 		/*
 		 * If the dimm is disabled then we may need to prevent
@@ -2485,21 +2507,8 @@ static int init_active_labels(struct nd_region *nd_region)
 
 		count = nd_label_active_count(ndd);
 		dev_dbg(ndd->dev, "count: %d\n", count);
-		for (j = 0; j < count; j++) {
-			struct nd_namespace_label *label;
-
-			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
-			if (!label_ent)
-				break;
-			label = nd_label_active(ndd, j);
-			label_ent->label = label;
-
-			mutex_lock(&nd_mapping->lock);
-			list_add_tail(&label_ent->list, &nd_mapping->labels);
-			mutex_unlock(&nd_mapping->lock);
-		}
 
-		if (j < count)
+		if (__init_active_labels(nd_mapping, count) < count)
 			goto error;
 	}
 
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
