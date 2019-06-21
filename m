Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB2A32129F0E4
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 17:40:57 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] device-dax: Add a 'resource' attribute
Date: Thu, 20 Jun 2019 18:40:38 -0600
Message-Id: <20190621004038.15180-1-vishal.l.verma@intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

device-dax based devices were missing a 'resource' attribute to indicate
the physical address range contributed by the device in question. This
information is desirable to userspace tooling that may want to use the
dax device as system-ram, and wants to selectively hotplug and online
the memory blocks associated with a given device.

Without this, the tooling would have to parse /proc/iomem for the memory
ranges contributed by dax devices, which can be a workaround, but it is
far easier to provide this information in the sysfs hierarchy.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 2109cfe80219..2f3c42ca416a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -295,6 +295,22 @@ static ssize_t target_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_node);
 
+static unsigned long long dev_dax_resource(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region = dev_dax->region;
+
+	return dax_region->res.start;
+}
+
+static ssize_t resource_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%#llx\n", dev_dax_resource(dev_dax));
+}
+static DEVICE_ATTR_RO(resource);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
@@ -313,6 +329,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 
 	if (a == &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) < 0)
 		return 0;
+	if (a == &dev_attr_resource.attr)
+		return 0400;
 	return a->mode;
 }
 
@@ -320,6 +338,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
+	&dev_attr_resource.attr,
 	NULL,
 };
 
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
