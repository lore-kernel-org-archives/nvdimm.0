Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AD7C211CD635
 for <linux-nvdimm@lists.01.org>; Fri, 22 Feb 2019 15:59:07 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] dax: add a 'modalias' attribute to DAX 'bus' devices
Date: Fri, 22 Feb 2019 16:58:54 -0700
Message-Id: <20190222235854.18927-1-vishal.l.verma@intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a 'modalias' attribute to devices under the DAX bus so that userspace
is able to dynamically load modules as needed. The modalias already
exists, it was only the sysfs attribute that was missing.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 28c3324271ac..2109cfe80219 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -295,6 +295,17 @@ static ssize_t target_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_node);
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	/*
+	 * We only ever expect to handle device-dax instances, i.e. the
+	 * @type argument to MODULE_ALIAS_DAX_DEVICE() is always zero
+	 */
+	return sprintf(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
+}
+static DEVICE_ATTR_RO(modalias);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -306,6 +317,7 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 }
 
 static struct attribute *dev_dax_attributes[] = {
+	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
 	NULL,
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
