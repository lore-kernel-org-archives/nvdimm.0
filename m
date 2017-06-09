Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72EAF20082E7E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:14:23 -0700 (PDT)
Subject: [PATCH 3/9] libnvdimm,
 label: honor the lba size specified in v1.2 labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:09:06 -0700
Message-ID: <149698494677.11651.18368611989371406465.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149698493023.11651.13036549892428981091.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Previously we only honored the lba size for blk-aperture mode
namespaces. For pmem namespaces the lba size was just assumed to be 512.
With the new v1.2 label definition and compatibility with other
operating environments, the ->lbasize property is now respected for pmem
namespaces.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   65 ++++++++++++++++++++++++++++++++-------
 drivers/nvdimm/nd.h             |    1 +
 drivers/nvdimm/pmem.c           |    1 +
 include/linux/nd.h              |    2 +
 4 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 51f304fe8a52..e034b003a5e2 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -163,6 +163,29 @@ bool pmem_should_map_pages(struct device *dev)
 }
 EXPORT_SYMBOL(pmem_should_map_pages);
 
+unsigned int pmem_sector_size(struct nd_namespace_common *ndns)
+{
+	if (is_namespace_pmem(&ndns->dev)) {
+		struct nd_namespace_pmem *nspm;
+
+		nspm = to_nd_namespace_pmem(&ndns->dev);
+		if (nspm->lbasize == 0 || nspm->lbasize == 512)
+			/* default */;
+		else if (nspm->lbasize == 4096)
+			return 4096;
+		else
+			dev_WARN(&ndns->dev, "unsupported sector size: %ld\n",
+					nspm->lbasize);
+	}
+
+	/*
+	 * There is no namespace label (is_namespace_io()), or the label
+	 * indicates the default sector size.
+	 */
+	return 512;
+}
+EXPORT_SYMBOL(pmem_sector_size);
+
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name)
 {
@@ -1283,28 +1306,49 @@ static ssize_t resource_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(resource);
 
-static const unsigned long ns_lbasize_supported[] = { 512, 520, 528,
+static const unsigned long blk_lbasize_supported[] = { 512, 520, 528,
 	4096, 4104, 4160, 4224, 0 };
 
+static const unsigned long pmem_lbasize_supported[] = { 512, 4096, 0 };
+
 static ssize_t sector_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+	if (is_namespace_blk(dev)) {
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 
-	if (!is_namespace_blk(dev))
-		return -ENXIO;
+		return nd_sector_size_show(nsblk->lbasize,
+				blk_lbasize_supported, buf);
+	}
 
-	return nd_sector_size_show(nsblk->lbasize, ns_lbasize_supported, buf);
+	if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		return nd_sector_size_show(nspm->lbasize,
+				pmem_lbasize_supported, buf);
+	}
+	return -ENXIO;
 }
 
 static ssize_t sector_size_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
 	struct nd_region *nd_region = to_nd_region(dev->parent);
+	const unsigned long *supported;
+	unsigned long *lbasize;
 	ssize_t rc = 0;
 
-	if (!is_namespace_blk(dev))
+	if (is_namespace_blk(dev)) {
+		struct nd_namespace_blk *nsblk = to_nd_namespace_blk(dev);
+
+		lbasize = &nsblk->lbasize;
+		supported = blk_lbasize_supported;
+	} else if (is_namespace_pmem(dev)) {
+		struct nd_namespace_pmem *nspm = to_nd_namespace_pmem(dev);
+
+		lbasize = &nspm->lbasize;
+		supported = pmem_lbasize_supported;
+	} else
 		return -ENXIO;
 
 	device_lock(dev);
@@ -1312,8 +1356,7 @@ static ssize_t sector_size_store(struct device *dev,
 	if (to_ndns(dev)->claim)
 		rc = -EBUSY;
 	if (rc >= 0)
-		rc = nd_sector_size_store(dev, buf, &nsblk->lbasize,
-				ns_lbasize_supported);
+		rc = nd_sector_size_store(dev, buf, lbasize, supported);
 	if (rc >= 0)
 		rc = nd_namespace_label_update(nd_region, dev);
 	dev_dbg(dev, "%s: result: %zd %s: %s%s", __func__,
@@ -1458,9 +1501,6 @@ static umode_t namespace_visible(struct kobject *kobj,
 		if (a == &dev_attr_size.attr)
 			return 0644;
 
-		if (is_namespace_pmem(dev) && a == &dev_attr_sector_size.attr)
-			return 0;
-
 		return a->mode;
 	}
 
@@ -1795,6 +1835,7 @@ struct device *create_namespace_pmem(struct nd_region *nd_region,
 				NSLABEL_NAME_LEN, GFP_KERNEL);
 		nspm->uuid = kmemdup((void __force *) label0->uuid,
 				NSLABEL_UUID_LEN, GFP_KERNEL);
+		nspm->lbasize = __le64_to_cpu(label0->lbasize);
 	}
 
 	if (!nspm->alt_name || !nspm->uuid) {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ad4e518940c9..17cecb38dfc9 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -356,6 +356,7 @@ int nvdimm_namespace_attach_btt(struct nd_namespace_common *ndns);
 int nvdimm_namespace_detach_btt(struct nd_btt *nd_btt);
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
+unsigned int pmem_sector_size(struct nd_namespace_common *ndns);
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
 		struct badblocks *bb, const struct resource *res);
 #if IS_ENABLED(CONFIG_ND_CLAIM)
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index c544d466ea51..5c45e178bd4a 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -342,6 +342,7 @@ static int pmem_attach_disk(struct device *dev,
 	blk_queue_write_cache(q, true, true);
 	blk_queue_make_request(q, pmem_make_request);
 	blk_queue_physical_block_size(q, PAGE_SIZE);
+	blk_queue_logical_block_size(q, pmem_sector_size(ndns));
 	blk_queue_max_hw_sectors(q, UINT_MAX);
 	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
diff --git a/include/linux/nd.h b/include/linux/nd.h
index 194b8e002ea7..d8f5023b49ae 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -75,12 +75,14 @@ struct nd_namespace_io {
 /**
  * struct nd_namespace_pmem - namespace device for dimm-backed interleaved memory
  * @nsio: device and system physical address range to drive
+ * @lbasize: logical sector size for the namespace in block-device-mode
  * @alt_name: namespace name supplied in the dimm label
  * @uuid: namespace name supplied in the dimm label
  * @id: ida allocated id
  */
 struct nd_namespace_pmem {
 	struct nd_namespace_io nsio;
+	unsigned long lbasize;
 	char *alt_name;
 	u8 *uuid;
 	int id;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
