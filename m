Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 582AE1A1DF2
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:12:30 -0700 (PDT)
Subject: [PATCH 4/4] dax: register seed device
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:09:49 -0700
Message-ID: <147136738895.26813.7749212910378676162.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Towards adding support for sub-dividing device-dax regions, add a seed
device.  Similar to libnvdimm a 'seed' device is un-configured device
that is enabled after setting configuration parameters.  After a given
seed device is enabled another is created and this process repeats until
no more seed devices can be activated due to dax_available_size being
exhausted.

For now, this simply registers a seed instance after the first dax
device instance is established.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index cbc765c81600..51334bcb5aa7 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -40,8 +40,10 @@ MODULE_PARM_DESC(nr_dax, "max number of device-dax instances");
  * @kref: to pin while other agents have a need to do lookups
  * @lock: synchronize changes / consistent-access to the resource tree (@res)
  * @dev: parent device backing this region
+ * @seed: next device for dynamic allocation / configuration
  * @align: allocation and mapping alignment for child dax devices
  * @res: physical address range of the region
+ * @child_count: number of registered dax device instances
  * @pfn_flags: identify whether the pfns are paged back or not
  */
 struct dax_region {
@@ -51,8 +53,10 @@ struct dax_region {
 	struct kref kref;
 	struct mutex lock;
 	struct device *dev;
+	struct device *seed;
 	unsigned int align;
 	struct resource res;
+	atomic_t child_count;
 	unsigned long pfn_flags;
 };
 
@@ -111,8 +115,29 @@ static ssize_t available_size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_size);
 
+static ssize_t seed_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	dax_region = dev_get_drvdata(dev);
+	if (dax_region) {
+		mutex_lock(&dax_region->lock);
+		if (dax_region->seed)
+			rc = sprintf(buf, "%s\n", dev_name(dax_region->seed));
+		mutex_unlock(&dax_region->lock);
+	}
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(seed);
+
 static struct attribute *dax_region_attributes[] = {
 	&dev_attr_available_size.attr,
+	&dev_attr_seed.attr,
 	NULL,
 };
 
@@ -242,6 +267,9 @@ static void dax_region_free(struct kref *kref)
 	struct dax_region *dax_region;
 
 	dax_region = container_of(kref, struct dax_region, kref);
+	WARN(atomic_read(&dax_region->child_count),
+			"%s: child count not zero\n",
+			dev_name(dax_region->dev));
 	kfree(dax_region);
 }
 
@@ -638,7 +666,10 @@ static void unregister_dax_dev(void *dev)
 	for (i = 0; i < dax_dev->num_resources; i++)
 		__release_region(&dax_region->res, dax_dev->res[i]->start,
 				resource_size(dax_dev->res[i]));
+	if (dax_region->seed == dev)
+		dax_region->seed = NULL;
 	mutex_unlock(&dax_region->lock);
+	atomic_dec(&dax_region->child_count);
 
 	cdev_del(cdev);
 	device_unregister(dev);
@@ -743,6 +774,16 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	if (rc)
 		return ERR_PTR(rc);
 
+	if (atomic_inc_return(&dax_region->child_count) == 1) {
+		struct dax_dev *seed;
+
+		seed = devm_create_dax_dev(dax_region, NULL, 0);
+		if (IS_ERR(seed))
+			dev_warn(parent, "failed to create region seed\n");
+		else
+			dax_region->seed = &seed->dev;
+	}
+
 	return dax_dev;
 
  err_cdev:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
