Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCE3D211CC3AF
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 14:09:08 -0800 (PST)
Subject: [PATCH] device-dax: Add a 'target_node' attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Feb 2019 13:56:30 -0800
Message-ID: <155069979014.1936094.2387722425017107280.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The target-node attribute is the Linux numa-node that a device-dax
instance may create when it is online. Prior to being online the
device's 'numa_node' property reflects the closest online cpu node which
is the typical expectation of a device 'numa_node'. Once it is online it
becomes its own distinct numa node, i.e. 'target_node'.

Export the 'target_node' property to give userspace tooling the ability
to predict the effective numa-node from a device-dax instance configured
to provide 'System RAM' capacity.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index a410154d75fb..28c3324271ac 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -279,13 +279,41 @@ static ssize_t size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(size);
 
+static int dev_dax_target_node(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region = dev_dax->region;
+
+	return dax_region->target_node;
+}
+
+static ssize_t target_node_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax_target_node(dev_dax));
+}
+static DEVICE_ATTR_RO(target_node);
+
+static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	if (a == &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) < 0)
+		return 0;
+	return a->mode;
+}
+
 static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_size.attr,
+	&dev_attr_target_node.attr,
 	NULL,
 };
 
 static const struct attribute_group dev_dax_attribute_group = {
 	.attrs = dev_dax_attributes,
+	.is_visible = dev_dax_visible,
 };
 
 static const struct attribute_group *dax_attribute_groups[] = {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
