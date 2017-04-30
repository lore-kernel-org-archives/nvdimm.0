Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B01FF21A0480E
 for <linux-nvdimm@lists.01.org>; Sun, 30 Apr 2017 07:27:46 -0700 (PDT)
Subject: [PATCH] device-dax: fix sysfs attribute deadlock
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 30 Apr 2017 07:21:54 -0700
Message-ID: <149356211395.12803.4163197195995720592.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <0193aa84-a6ad-8472-43de-a49ea8617fc4@redhat.com>
References: <0193aa84-a6ad-8472-43de-a49ea8617fc4@redhat.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Usage of device_lock() for dax_region attributes is unnecessary and
deadlock prone. It's unnecessary because the order of registration /
un-registration guarantees that drvdata is always valid. It's deadlock
prone because it sets up this situation:

 ndctl           D    0  2170   2082 0x00000000
 Call Trace:
  __schedule+0x31f/0x980
  schedule+0x3d/0x90
  schedule_preempt_disabled+0x15/0x20
  __mutex_lock+0x402/0x980
  ? __mutex_lock+0x158/0x980
  ? align_show+0x2b/0x80 [dax]
  ? kernfs_seq_start+0x2f/0x90
  mutex_lock_nested+0x1b/0x20
  align_show+0x2b/0x80 [dax]
  dev_attr_show+0x20/0x50

 ndctl           D    0  2186   2079 0x00000000
 Call Trace:
  __schedule+0x31f/0x980
  schedule+0x3d/0x90
  __kernfs_remove+0x1f6/0x340
  ? kernfs_remove_by_name_ns+0x45/0xa0
  ? remove_wait_queue+0x70/0x70
  kernfs_remove_by_name_ns+0x45/0xa0
  remove_files.isra.1+0x35/0x70
  sysfs_remove_group+0x44/0x90
  sysfs_remove_groups+0x2e/0x50
  dax_region_unregister+0x25/0x40 [dax]
  devm_action_release+0xf/0x20
  release_nodes+0x16d/0x2b0
  devres_release_all+0x3c/0x60
  device_release_driver_internal+0x17d/0x220
  device_release_driver+0x12/0x20
  unbind_store+0x112/0x160

ndctl/2170 is trying to acquire the device_lock() to read an attribute,
and ndctl/2186 is holding the device_lock() while trying to drain all
active attribute readers.

Thanks to Yi Zhang for the reproduction script.

Fixes: d7fe1a67f658 ("dax: add region 'id', 'size', and 'align' attributes")
Cc: <stable@vger.kernel.org>
Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   40 ++++++++++++----------------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index ef93aa84622b..5e8302d3a89c 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -36,36 +36,27 @@ static struct kmem_cache *dax_cache __read_mostly;
 static struct super_block *dax_superblock __read_mostly;
 MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
 
+/*
+ * Rely on the fact that drvdata is set before the attributes are
+ * registered, and that the attributes are unregistered before drvdata
+ * is cleared to assume that drvdata is always valid.
+ */
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dax_region *dax_region;
-	ssize_t rc = -ENXIO;
+	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	device_lock(dev);
-	dax_region = dev_get_drvdata(dev);
-	if (dax_region)
-		rc = sprintf(buf, "%d\n", dax_region->id);
-	device_unlock(dev);
-
-	return rc;
+	return sprintf(buf, "%d\n", dax_region->id);
 }
 static DEVICE_ATTR_RO(id);
 
 static ssize_t region_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dax_region *dax_region;
-	ssize_t rc = -ENXIO;
+	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	device_lock(dev);
-	dax_region = dev_get_drvdata(dev);
-	if (dax_region)
-		rc = sprintf(buf, "%llu\n", (unsigned long long)
-				resource_size(&dax_region->res));
-	device_unlock(dev);
-
-	return rc;
+	return sprintf(buf, "%llu\n", (unsigned long long)
+			resource_size(&dax_region->res));
 }
 static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
 		region_size_show, NULL);
@@ -73,16 +64,9 @@ static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
 static ssize_t align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dax_region *dax_region;
-	ssize_t rc = -ENXIO;
+	struct dax_region *dax_region = dev_get_drvdata(dev);
 
-	device_lock(dev);
-	dax_region = dev_get_drvdata(dev);
-	if (dax_region)
-		rc = sprintf(buf, "%u\n", dax_region->align);
-	device_unlock(dev);
-
-	return rc;
+	return sprintf(buf, "%u\n", dax_region->align);
 }
 static DEVICE_ATTR_RO(align);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
