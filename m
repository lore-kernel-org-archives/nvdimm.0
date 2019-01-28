Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79C092194D387
 for <linux-nvdimm@lists.01.org>; Sun, 27 Jan 2019 16:31:12 -0800 (PST)
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [PATCH 1/5] libnvdimm, namespace: release labels properly on error
Date: Mon, 28 Jan 2019 08:30:14 +0800
Message-Id: <20190128003018.4087-1-richardw.yang@linux.intel.com>
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

In init_active_labels(), it iterates on ndr_mappings to create its
corresponding labels. When there is an error, it is supposed to release
those labels created. But current implementation doesn't handle this
well in two aspects:

  * when error happens during ndd check, labels are not released
  * just labels on current nd_mapping released, previous ones are lost

This patch extracts labels releasing code to error branch and release
labels on all nd_mapping besides only current one. By goto error branch
on error, it release all labels allocated.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
---
 drivers/nvdimm/namespace_devs.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 9471b9ca04f5..234c0c79726a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2451,7 +2451,7 @@ static struct device **create_namespaces(struct nd_region *nd_region)
 
 static int init_active_labels(struct nd_region *nd_region)
 {
-	int i;
+	int i, errno = -ENOMEM;
 
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
@@ -2476,7 +2476,8 @@ static int init_active_labels(struct nd_region *nd_region)
 					dev_name(&nd_mapping->nvdimm->dev),
 					test_bit(NDD_LOCKED, &nvdimm->flags)
 					? "locked" : "disabled");
-			return -ENXIO;
+			errno = -ENXIO;
+			goto error;
 		}
 		nd_mapping->ndd = ndd;
 		atomic_inc(&nvdimm->busy);
@@ -2500,16 +2501,20 @@ static int init_active_labels(struct nd_region *nd_region)
 			mutex_unlock(&nd_mapping->lock);
 		}
 
-		if (j >= count)
-			continue;
+		if (j < count)
+			goto error;
+	}
+
+	return 0;
 
+error:
+	for (; i >= 0; i--) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		mutex_lock(&nd_mapping->lock);
 		nd_mapping_free_labels(nd_mapping);
 		mutex_unlock(&nd_mapping->lock);
-		return -ENOMEM;
 	}
-
-	return 0;
+	return errno;
 }
 
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err)
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
