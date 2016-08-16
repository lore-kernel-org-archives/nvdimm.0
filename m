Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id DCDCF1A1E14
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:13:20 -0700 (PDT)
Subject: [PATCH 3/4] dax: convert devm_create_dax_dev to PTR_ERR
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:09:43 -0700
Message-ID: <147136738382.26813.15989459067594066962.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For sub-division support we need access to the dax_dev created by
devm_create_dax_dev().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |   16 ++++++++++------
 drivers/dax/dax.h  |    5 +++--
 drivers/dax/pmem.c |    5 +++--
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 257cad62bd1d..cbc765c81600 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -644,8 +644,8 @@ static void unregister_dax_dev(void *dev)
 	device_unregister(dev);
 }
 
-int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
-		int count)
+struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
+		struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
@@ -656,7 +656,7 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 
 	dax_dev = kzalloc(sizeof(*dax_dev), GFP_KERNEL);
 	if (!dax_dev)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	dax_dev->res = kzalloc(sizeof(res) * count, GFP_KERNEL);
 	if (!dax_dev->res)
@@ -736,10 +736,14 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 	rc = device_add(dev);
 	if (rc) {
 		put_device(dev);
-		return rc;
+		return ERR_PTR(rc);
 	}
 
-	return devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_dev, dev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return dax_dev;
 
  err_cdev:
 	iput(dax_dev->inode);
@@ -757,7 +761,7 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
  err_res:
 	kfree(dax_dev);
 
-	return rc;
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_GPL(devm_create_dax_dev);
 
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index d8b8f1f25054..ddd829ab58c0 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -13,12 +13,13 @@
 #ifndef __DAX_H__
 #define __DAX_H__
 struct device;
+struct dax_dev;
 struct resource;
 struct dax_region;
 void dax_region_put(struct dax_region *dax_region);
 struct dax_region *alloc_dax_region(struct device *parent,
 		int region_id, struct resource *res, unsigned int align,
 		void *addr, unsigned long flags);
-int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
-		int count);
+struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
+		struct resource *res, int count);
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 59b75c5972bb..c24d32ec9ce6 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -61,6 +61,7 @@ static int dax_pmem_probe(struct device *dev)
 	int rc;
 	void *addr;
 	struct resource res;
+	struct dax_dev *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
 	struct dax_pmem *dax_pmem;
 	struct nd_region *nd_region;
@@ -123,12 +124,12 @@ static int dax_pmem_probe(struct device *dev)
 		return -ENOMEM;
 
 	/* TODO: support for subdividing a dax region... */
-	rc = devm_create_dax_dev(dax_region, &res, 1);
+	dax_dev = devm_create_dax_dev(dax_region, &res, 1);
 
 	/* child dax_dev instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);
 
-	return rc;
+	return PTR_ERR_OR_ZERO(dax_dev);
 }
 
 static struct nd_device_driver dax_pmem_driver = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
