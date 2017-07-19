Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5AF3C2095D8F5
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:25:58 -0700 (PDT)
Subject: [PATCH] device-dax: fix sysfs duplicate warnings
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:21:21 -0700
Message-ID: <150048848091.12483.4155932901717578114.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Fix warnings of the form...

     WARNING: CPU: 10 PID: 4983 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
     sysfs: cannot create duplicate filename '/class/dax/dax12.0'
     Call Trace:
      dump_stack+0x63/0x86
      __warn+0xcb/0xf0
      warn_slowpath_fmt+0x5a/0x80
      ? kernfs_path_from_node+0x4f/0x60
      sysfs_warn_dup+0x62/0x80
      sysfs_do_create_link_sd.isra.2+0x97/0xb0
      sysfs_create_link+0x25/0x40
      device_add+0x266/0x630
      devm_create_dax_dev+0x2cf/0x340 [dax]
      dax_pmem_probe+0x1f5/0x26e [dax_pmem]
      nvdimm_bus_probe+0x71/0x120

...by reusing the namespace id for the device-dax instance name.

Now that we have decided that there will never by more than one
device-dax instance per libnvdimm-namespace parent device [1], we can
directly reuse the namepace ids. There are some possible follow-on
cleanups, but those are saved for a later patch to simplify the -stable
backport.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-December/008266.html

Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pmem...")
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/device-dax.h |    2 +-
 drivers/dax/device.c     |   24 ++++++++++++++++--------
 drivers/dax/pmem.c       |   12 +++++++-----
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/device-dax.h b/drivers/dax/device-dax.h
index fdcd9769ffde..688b051750bd 100644
--- a/drivers/dax/device-dax.h
+++ b/drivers/dax/device-dax.h
@@ -21,5 +21,5 @@ struct dax_region *alloc_dax_region(struct device *parent,
 		int region_id, struct resource *res, unsigned int align,
 		void *addr, unsigned long flags);
 struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
-		struct resource *res, int count);
+		int id, struct resource *res, int count);
 #endif /* __DEVICE_DAX_H__ */
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 44d72e5e64cc..e9f3b3e4bbf4 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -529,7 +529,8 @@ static void dev_dax_release(struct device *dev)
 	struct dax_region *dax_region = dev_dax->region;
 	struct dax_device *dax_dev = dev_dax->dax_dev;
 
-	ida_simple_remove(&dax_region->ida, dev_dax->id);
+	if (dev_dax->id >= 0)
+		ida_simple_remove(&dax_region->ida, dev_dax->id);
 	dax_region_put(dax_region);
 	put_dax(dax_dev);
 	kfree(dev_dax);
@@ -559,7 +560,7 @@ static void unregister_dev_dax(void *dev)
 }
 
 struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
-		struct resource *res, int count)
+		int id, struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
 	struct dax_device *dax_dev;
@@ -590,10 +591,16 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	if (i < count)
 		goto err_id;
 
-	dev_dax->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
-	if (dev_dax->id < 0) {
-		rc = dev_dax->id;
-		goto err_id;
+	if (id < 0) {
+		id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
+		dev_dax->id = id;
+		if (id < 0) {
+			rc = id;
+			goto err_id;
+		}
+	} else {
+		/* region provider owns @id lifetime */
+		dev_dax->id = -1;
 	}
 
 	/*
@@ -625,7 +632,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	dev->parent = parent;
 	dev->groups = dax_attribute_groups;
 	dev->release = dev_dax_release;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, id);
 
 	rc = cdev_device_add(cdev, dev);
 	if (rc) {
@@ -641,7 +648,8 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	return dev_dax;
 
  err_dax:
-	ida_simple_remove(&dax_region->ida, dev_dax->id);
+	if (dev_dax->id >= 0)
+		ida_simple_remove(&dax_region->ida, dev_dax->id);
  err_id:
 	kfree(dev_dax);
 
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 9f2a0b4fd801..8d8c852ba8f2 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -58,13 +58,12 @@ static void dax_pmem_percpu_kill(void *data)
 
 static int dax_pmem_probe(struct device *dev)
 {
-	int rc;
 	void *addr;
 	struct resource res;
+	int rc, id, region_id;
 	struct nd_pfn_sb *pfn_sb;
 	struct dev_dax *dev_dax;
 	struct dax_pmem *dax_pmem;
-	struct nd_region *nd_region;
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
 	struct nd_namespace_common *ndns;
@@ -123,14 +122,17 @@ static int dax_pmem_probe(struct device *dev)
 	/* adjust the dax_region resource to the start of data */
 	res.start += le64_to_cpu(pfn_sb->dataoff);
 
-	nd_region = to_nd_region(dev->parent);
-	dax_region = alloc_dax_region(dev, nd_region->id, &res,
+	rc = sscanf(dev_name(&ndns->dev), "namespace%d.%d", &region_id, &id);
+	if (rc != 2)
+		return -EINVAL;
+
+	dax_region = alloc_dax_region(dev, region_id, &res,
 			le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);
 	if (!dax_region)
 		return -ENOMEM;
 
 	/* TODO: support for subdividing a dax region... */
-	dev_dax = devm_create_dev_dax(dax_region, &res, 1);
+	dev_dax = devm_create_dev_dax(dax_region, id, &res, 1);
 
 	/* child dev_dax instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
