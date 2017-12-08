Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F0CA62217CE53
 for <linux-nvdimm@lists.01.org>; Fri,  8 Dec 2017 12:55:45 -0800 (PST)
Subject: [PATCH v2 3/4] libnvdimm: expose platform persistence attribute for
 nd_region
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 08 Dec 2017 14:00:20 -0700
Message-ID: <151276682022.31888.4940531735214813355.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151276655874.31888.13113966406333561201.stgit@djiang5-desk3.ch.intel.com>
References: <151276655874.31888.13113966406333561201.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Providing a sysfs attribute for nd_region that shows the persistence
capabilities for the platform.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/region_devs.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 87e8cd10de05..211639d836c8 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -528,6 +528,18 @@ static ssize_t resource_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(resource);
 
+static ssize_t persistence_domain_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+	unsigned long flags = nd_region->flags;
+
+	return sprintf(buf, "%s%s\n",
+			flags & BIT(ND_REGION_PERSIST_CACHE) ? "cpu_cache " : "",
+			flags & BIT(ND_REGION_PERSIST_MEMCTRL) ? "memory_controller " : "");
+}
+static DEVICE_ATTR_RO(persistence_domain);
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
@@ -543,6 +555,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_init_namespaces.attr,
 	&dev_attr_badblocks.attr,
 	&dev_attr_resource.attr,
+	&dev_attr_persistence_domain.attr,
 	NULL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
