Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2221847F
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 06:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685772846; x=1717308846;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M1v4TiCX8AvusZkEJT8GFuAqlj18O4sl+0gBX3a0sRk=;
  b=UKP8e6SMEkDuZNdqWC8IzGSSvHEqGSXf3IZY219GOKNpnIiQu1epLa+R
   0t6iWsewa6VgM2IPRm2ty8EJXzYOdGj7io8CXUqc1rCb2BIT9gtnLPpXf
   JXDHNvSkt2jvR9gSL+dvjT6KxjGZQWL82kGuu/VrN1ag20Nh90RV8C2yA
   YOx7J3cvLVTjfOnBY+Shx5NNpsuMDvsoSvomM/iTfTlOHKf0A5TNcA+CO
   anY1kL85izjqYSmHJO/OqAjaAtFFFxUDWwjGzp5IVsSR8jH2JqrybEd3g
   Eksxr0V8NRMRqfyt7+qo2zEDH0wPqaXEGNR+ueefhxKBYUj8ICmJ31/KP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="442417635"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="442417635"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="711211576"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="711211576"
Received: from rjkoval-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.230.247])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:14:06 -0700
Subject: [PATCH 3/4] dax: Introduce alloc_dev_dax_id()
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>, Paul Cassella <cassella@hpe.com>,
 Ira Weiny <ira.weiny@intel.com>, linux-cxl@vger.kernel.org
Date: Fri, 02 Jun 2023 23:14:05 -0700
Message-ID: <168577284563.1672036.13493034988900989554.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
References: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The reference counting of dax_region objects is needlessly complicated,
has lead to confusion [1], and has hidden a bug [2]. Towards cleaning up
that mess introduce alloc_dev_dax_id() to minimize the holding of a
dax_region reference to only what dev_dax_release() needs, the
dax_region->ida.

Part of the reason for the mess was the design to dereference a
dax_region in all cases in free_dev_dax_id() even if the id was
statically assigned by the upper level dax_region driver. Remove the
need to call "is_static(dax_region)" by tracking whether the id is
dynamic directly in the dev_dax instance itself.

With that flag the dax_region pinning and release per dev_dax instance
can move to alloc_dev_dax_id() and free_dev_dax_id() respectively.

A follow-on cleanup address the unnecessary references in the dax_region
setup and drivers.

Fixes: 0f3da14a4f05 ("device-dax: introduce 'seed' devices")
Link: http://lore.kernel.org/r/20221203095858.612027-1-liuyongqiang13@huawei.com [1]
Link: http://lore.kernel.org/r/3cf0890b-4eb0-e70e-cd9c-2ecc3d496263@hpe.com [2]
Reported-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Reported-by: Paul Cassella <cassella@hpe.com>
Reported-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c         |   56 +++++++++++++++++++++++++++------------------
 drivers/dax/dax-private.h |    4 ++-
 2 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c99ea08aafc3..a4cc3eca774f 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -446,18 +446,34 @@ static void unregister_dev_dax(void *dev)
 	put_device(dev);
 }
 
+static void dax_region_free(struct kref *kref)
+{
+	struct dax_region *dax_region;
+
+	dax_region = container_of(kref, struct dax_region, kref);
+	kfree(dax_region);
+}
+
+void dax_region_put(struct dax_region *dax_region)
+{
+	kref_put(&dax_region->kref, dax_region_free);
+}
+EXPORT_SYMBOL_GPL(dax_region_put);
+
 /* a return value >= 0 indicates this invocation invalidated the id */
 static int __free_dev_dax_id(struct dev_dax *dev_dax)
 {
-	struct dax_region *dax_region = dev_dax->region;
 	struct device *dev = &dev_dax->dev;
+	struct dax_region *dax_region;
 	int rc = dev_dax->id;
 
 	device_lock_assert(dev);
 
-	if (is_static(dax_region) || dev_dax->id < 0)
+	if (!dev_dax->dyn_id || dev_dax->id < 0)
 		return -1;
+	dax_region = dev_dax->region;
 	ida_free(&dax_region->ida, dev_dax->id);
+	dax_region_put(dax_region);
 	dev_dax->id = -1;
 	return rc;
 }
@@ -473,6 +489,20 @@ static int free_dev_dax_id(struct dev_dax *dev_dax)
 	return rc;
 }
 
+static int alloc_dev_dax_id(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region = dev_dax->region;
+	int id;
+
+	id = ida_alloc(&dax_region->ida, GFP_KERNEL);
+	if (id < 0)
+		return id;
+	kref_get(&dax_region->kref);
+	dev_dax->dyn_id = true;
+	dev_dax->id = id;
+	return id;
+}
+
 static ssize_t delete_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t len)
 {
@@ -560,20 +590,6 @@ static const struct attribute_group *dax_region_attribute_groups[] = {
 	NULL,
 };
 
-static void dax_region_free(struct kref *kref)
-{
-	struct dax_region *dax_region;
-
-	dax_region = container_of(kref, struct dax_region, kref);
-	kfree(dax_region);
-}
-
-void dax_region_put(struct dax_region *dax_region)
-{
-	kref_put(&dax_region->kref, dax_region_free);
-}
-EXPORT_SYMBOL_GPL(dax_region_put);
-
 static void dax_region_unregister(void *region)
 {
 	struct dax_region *dax_region = region;
@@ -1297,12 +1313,10 @@ static const struct attribute_group *dax_attribute_groups[] = {
 static void dev_dax_release(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
-	struct dax_region *dax_region = dev_dax->region;
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 
 	put_dax(dax_dev);
 	free_dev_dax_id(dev_dax);
-	dax_region_put(dax_region);
 	kfree(dev_dax->pgmap);
 	kfree(dev_dax);
 }
@@ -1326,6 +1340,7 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
 
+	dev_dax->region = dax_region;
 	if (is_static(dax_region)) {
 		if (dev_WARN_ONCE(parent, data->id < 0,
 				"dynamic id specified to static region\n")) {
@@ -1341,13 +1356,11 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 			goto err_id;
 		}
 
-		rc = ida_alloc(&dax_region->ida, GFP_KERNEL);
+		rc = alloc_dev_dax_id(dev_dax);
 		if (rc < 0)
 			goto err_id;
-		dev_dax->id = rc;
 	}
 
-	dev_dax->region = dax_region;
 	dev = &dev_dax->dev;
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
@@ -1388,7 +1401,6 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	dev_dax->target_node = dax_region->target_node;
 	dev_dax->align = dax_region->align;
 	ida_init(&dev_dax->ida);
-	kref_get(&dax_region->kref);
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 1c974b7caae6..afcada6fd2ed 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -52,7 +52,8 @@ struct dax_mapping {
  * @region - parent region
  * @dax_dev - core dax functionality
  * @target_node: effective numa node if dev_dax memory range is onlined
- * @id: ida allocated id
+ * @dyn_id: is this a dynamic or statically created instance
+ * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
@@ -64,6 +65,7 @@ struct dev_dax {
 	struct dax_device *dax_dev;
 	unsigned int align;
 	int target_node;
+	bool dyn_id;
 	int id;
 	struct ida ida;
 	struct device dev;

