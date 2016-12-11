Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E09B482029
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:32:44 -0800 (PST)
Subject: [PATCH 2/8] dax: add region 'id', 'size', and 'align' attributes
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:28:35 -0800
Message-ID: <148143771566.10950.14259879317434171984.stgit@dwillia2-desk3.amr.corp.intel.com>
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

While this information is available by looking at the nvdimm parent
device that may not always be the case when/if we add support for other
memory regions. Tooling should not depend on walking a given ancestor
topology that is not guaranteed by the device's class. For example, a
device-dax instance will always have a dax_region parent, but it may not
always have a libnvdimm "dax" device as a grandparent.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index cc7c4aa4bcc2..da2962b6f8de 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -111,8 +111,61 @@ static ssize_t available_size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_size);
 
+static ssize_t id_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	dax_region = dev_get_drvdata(dev);
+	if (dax_region)
+		rc = sprintf(buf, "%d\n", dax_region->id);
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(id);
+
+static ssize_t region_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	dax_region = dev_get_drvdata(dev);
+	if (dax_region)
+		rc = sprintf(buf, "%llu\n", (unsigned long long)
+				resource_size(&dax_region->res));
+	device_unlock(dev);
+
+	return rc;
+}
+static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
+		region_size_show, NULL);
+
+static ssize_t align_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region;
+	ssize_t rc = -ENXIO;
+
+	device_lock(dev);
+	dax_region = dev_get_drvdata(dev);
+	if (dax_region)
+		rc = sprintf(buf, "%u\n", dax_region->align);
+	device_unlock(dev);
+
+	return rc;
+}
+static DEVICE_ATTR_RO(align);
+
 static struct attribute *dax_region_attributes[] = {
 	&dev_attr_available_size.attr,
+	&dev_attr_region_size.attr,
+	&dev_attr_align.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
