Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37ED121A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 15:33:21 -0700 (PDT)
Subject: [PATCH v6 1/4] libnvdimm: add mechanism to publish badblocks at the
 region level
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 07 Apr 2017 15:33:20 -0700
Message-ID: <149160440045.52935.12075328472007815165.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

badblocks sysfs file will be export at region level. When nvdimm event
notifier happens for NVDIMM_REVALIATE_POISON, the badblocks in the
region will be updated.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region.c      |   24 ++++++++++++++++++++++++
 drivers/nvdimm/region_devs.c |   19 +++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 2a99c83..c3b33cf 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -154,6 +154,7 @@ struct nd_region {
 	u64 ndr_start;
 	int id, num_lanes, ro, numa_node;
 	void *provider_data;
+	struct badblocks bb;
 	struct nd_interleave_set *nd_set;
 	struct nd_percpu_lane __percpu *lane;
 	struct nd_mapping mapping[0];
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 8f24177..869a886 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/nd.h>
+#include "nd-core.h"
 #include "nd.h"
 
 static int nd_region_probe(struct device *dev)
@@ -52,6 +53,17 @@ static int nd_region_probe(struct device *dev)
 	if (rc && err && rc == err)
 		return -ENODEV;
 
+	if (is_nd_pmem(&nd_region->dev)) {
+		struct resource ndr_res;
+
+		if (devm_init_badblocks(dev, &nd_region->bb))
+			return -ENODEV;
+		ndr_res.start = nd_region->ndr_start;
+		ndr_res.end = nd_region->ndr_start + nd_region->ndr_size - 1;
+		nvdimm_badblocks_populate(nd_region,
+				&nd_region->bb, &ndr_res);
+	}
+
 	nd_region->btt_seed = nd_btt_create(nd_region);
 	nd_region->pfn_seed = nd_pfn_create(nd_region);
 	nd_region->dax_seed = nd_dax_create(nd_region);
@@ -104,6 +116,18 @@ static int child_notify(struct device *dev, void *data)
 
 static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 {
+	if (event == NVDIMM_REVALIDATE_POISON) {
+		struct nd_region *nd_region = to_nd_region(dev);
+		struct resource res;
+
+		if (is_nd_pmem(&nd_region->dev)) {
+			res.start = nd_region->ndr_start;
+			res.end = nd_region->ndr_start +
+				nd_region->ndr_size - 1;
+			nvdimm_badblocks_populate(nd_region,
+					&nd_region->bb, &res);
+		}
+	}
 	device_for_each_child(dev, &event, child_notify);
 }
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index b7cb506..3500fc8 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -448,6 +448,21 @@ static ssize_t read_only_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(read_only);
 
+static ssize_t nd_badblocks_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nd_region *nd_region = to_nd_region(dev);
+
+	return badblocks_show(&nd_region->bb, buf, 0);
+}
+static struct device_attribute dev_attr_nd_badblocks = {
+	.attr = {
+		.name = "badblocks",
+		.mode = S_IRUGO
+	},
+	.show = nd_badblocks_show,
+};
+
 static struct attribute *nd_region_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_nstype.attr,
@@ -460,6 +475,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_available_size.attr,
 	&dev_attr_namespace_seed.attr,
 	&dev_attr_init_namespaces.attr,
+	&dev_attr_nd_badblocks.attr,
 	NULL,
 };
 
@@ -476,6 +492,9 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
+	if (!is_nd_pmem(dev) && a == &dev_attr_nd_badblocks.attr)
+		return 0;
+
 	if (a != &dev_attr_set_cookie.attr
 			&& a != &dev_attr_available_size.attr)
 		return a->mode;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
