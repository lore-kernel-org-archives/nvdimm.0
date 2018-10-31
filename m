Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F0952116DF85
 for <linux-nvdimm@lists.01.org>; Tue, 30 Oct 2018 20:24:43 -0700 (PDT)
Subject: [PATCH 1/8] device-dax: Kill dax_region ida
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 30 Oct 2018 20:12:54 -0700
Message-ID: <154095557491.3271337.10354816564776020500.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154095556915.3271337.12581429676272726902.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154095556915.3271337.12581429676272726902.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-mm@kvack.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Commit bbb3be170ac2 "device-dax: fix sysfs duplicate warnings" arranged
for passing a dax instance-id to devm_create_dax_dev(), rather than
generating one internally. Remove the dax_region ida and related code.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h |    3 ---
 drivers/dax/device.c      |   24 +++---------------------
 2 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index b6fc4f04636d..d1b36a42132f 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -28,7 +28,6 @@
  */
 struct dax_region {
 	int id;
-	struct ida ida;
 	void *base;
 	struct kref kref;
 	struct device *dev;
@@ -42,7 +41,6 @@ struct dax_region {
  * @region - parent region
  * @dax_dev - core dax functionality
  * @dev - device core
- * @id - child id in the region
  * @num_resources - number of physical address extents in this device
  * @res - array of physical address ranges
  */
@@ -50,7 +48,6 @@ struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
 	struct device dev;
-	int id;
 	int num_resources;
 	struct resource res[0];
 };
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 948806e57cee..a5a670c1cd58 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -128,7 +128,6 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 	dax_region->pfn_flags = pfn_flags;
 	kref_init(&dax_region->kref);
 	dax_region->id = region_id;
-	ida_init(&dax_region->ida);
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->base = addr;
@@ -582,8 +581,6 @@ static void dev_dax_release(struct device *dev)
 	struct dax_region *dax_region = dev_dax->region;
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 
-	if (dev_dax->id >= 0)
-		ida_simple_remove(&dax_region->ida, dev_dax->id);
 	dax_region_put(dax_region);
 	put_dax(dax_dev);
 	kfree(dev_dax);
@@ -642,19 +639,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	}
 
 	if (i < count)
-		goto err_id;
-
-	if (id < 0) {
-		id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
-		dev_dax->id = id;
-		if (id < 0) {
-			rc = id;
-			goto err_id;
-		}
-	} else {
-		/* region provider owns @id lifetime */
-		dev_dax->id = -1;
-	}
+		goto err;
 
 	/*
 	 * No 'host' or dax_operations since there is no access to this
@@ -663,7 +648,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	dax_dev = alloc_dax(dev_dax, NULL, NULL);
 	if (!dax_dev) {
 		rc = -ENOMEM;
-		goto err_dax;
+		goto err;
 	}
 
 	/* from here on we're committed to teardown via dax_dev_release() */
@@ -700,10 +685,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 
 	return dev_dax;
 
- err_dax:
-	if (dev_dax->id >= 0)
-		ida_simple_remove(&dax_region->ida, dev_dax->id);
- err_id:
+ err:
 	kfree(dev_dax);
 
 	return ERR_PTR(rc);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
