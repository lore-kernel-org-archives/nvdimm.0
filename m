Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A66482029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:33:00 -0800 (PST)
Subject: [PATCH 5/8] dax: refactor locking out of size calculation routines
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:28:51 -0800
Message-ID: <148143773119.10950.13840765929901351011.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143770485.10950.13227732273892953675.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for other callers of these routines make the locking the
responsibility of the caller.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index d878a56cf3e3..5b65eaff6ace 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -90,11 +90,11 @@ static unsigned long long dax_region_avail_size(
 	unsigned long long size;
 	struct resource *res;
 
-	mutex_lock(&dax_region->lock);
+	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
+
 	size = resource_size(&dax_region->res);
 	for_each_dax_region_resource(dax_region, res)
 		size -= resource_size(res);
-	mutex_unlock(&dax_region->lock);
 
 	return size;
 }
@@ -107,8 +107,11 @@ static ssize_t available_size_show(struct device *dev,
 
 	device_lock(dev);
 	dax_region = dev_get_drvdata(dev);
-	if (dax_region)
+	if (dax_region) {
+		mutex_lock(&dax_region->lock);
 		rc = sprintf(buf, "%llu\n", dax_region_avail_size(dax_region));
+		mutex_unlock(&dax_region->lock);
+	}
 	device_unlock(dev);
 
 	return rc;
@@ -389,16 +392,31 @@ static struct dax_dev *to_dax_dev(struct device *dev)
 	return container_of(dev, struct dax_dev, dev);
 }
 
-static ssize_t size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+static unsigned long long dax_dev_size(struct dax_dev *dax_dev)
 {
-	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
 	unsigned long long size = 0;
 	int i;
 
+	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
+
 	for (i = 0; i < dax_dev->num_resources; i++)
 		size += resource_size(dax_dev->res[i]);
 
+	return size;
+}
+
+static ssize_t size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned long long size;
+	struct dax_dev *dax_dev = to_dax_dev(dev);
+	struct dax_region *dax_region = dax_dev->region;
+
+	mutex_lock(&dax_region->lock);
+	size = dax_dev_size(dax_dev);
+	mutex_unlock(&dax_region->lock);
+
 	return sprintf(buf, "%llu\n", size);
 }
 static DEVICE_ATTR_RO(size);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
