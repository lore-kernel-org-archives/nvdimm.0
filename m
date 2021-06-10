Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22406D10
	for <nvdimm@lists.linux.dev>; Thu, 10 Jun 2021 22:26:22 +0000 (UTC)
IronPort-SDR: hjrGKfEqcKFLnvrFiy4MUoQRTD5LY+6dcffo7wMWQEtFSOlH+6lU6ALjMii/H5MlouOzj/eGrJ
 uLWKrTca9mdw==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="205449397"
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="205449397"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:26:21 -0700
IronPort-SDR: IFzx37hSWmXT3sVyNty0Pq/g3GC1DCvLUszILGKDOF7bwjAh9X4Z7Nr8fBrvAvgbV3GfvUfHC8
 bT4gtaH/QvcA==
X-IronPort-AV: E=Sophos;i="5.83,264,1616482800"; 
   d="scan'208";a="483031982"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2021 15:26:20 -0700
Subject: [PATCH 4/5] libnvdimm: Drop unused device power management support
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, ben.widawsky@intel.com, alison.schofield@intel.com,
 vishal.l.verma@intel.com, ira.weiny@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 10 Jun 2021 15:26:19 -0700
Message-ID: <162336397948.2462439.5230237265829121099.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162336395765.2462439.11368504490069925374.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

LIBNVDIMM device objects register sysfs power attributes despite nothing
requiring that support. Clean up sysfs remove the power/ attribute
group. This requires a device_create() and a device_register() usage to
be converted to the device_initialize() + device_add() pattern.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index a11821df83b5..e6aa87043a95 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -363,8 +363,13 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	nvdimm_bus->dev.groups = nd_desc->attr_groups;
 	nvdimm_bus->dev.bus = &nvdimm_bus_type;
 	nvdimm_bus->dev.of_node = nd_desc->of_node;
-	dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
-	rc = device_register(&nvdimm_bus->dev);
+	device_initialize(&nvdimm_bus->dev);
+	device_set_pm_not_required(&nvdimm_bus->dev);
+	rc = dev_set_name(&nvdimm_bus->dev, "ndbus%d", nvdimm_bus->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(&nvdimm_bus->dev);
 	if (rc) {
 		dev_dbg(&nvdimm_bus->dev, "registration failed: %d\n", rc);
 		goto err;
@@ -525,6 +530,7 @@ void __nd_device_register(struct device *dev)
 		set_dev_node(dev, to_nd_region(dev)->numa_node);
 
 	dev->bus = &nvdimm_bus_type;
+	device_set_pm_not_required(dev);
 	if (dev->parent) {
 		get_device(dev->parent);
 		if (dev_to_node(dev) == NUMA_NO_NODE)
@@ -717,18 +723,41 @@ const struct attribute_group nd_numa_attribute_group = {
 	.is_visible = nd_numa_attr_visible,
 };
 
+static void ndctl_release(struct device *dev)
+{
+	kfree(dev);
+}
+
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 {
 	dev_t devt = MKDEV(nvdimm_bus_major, nvdimm_bus->id);
 	struct device *dev;
+	int rc;
 
-	dev = device_create(nd_class, &nvdimm_bus->dev, devt, nvdimm_bus,
-			"ndctl%d", nvdimm_bus->id);
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->class = nd_class;
+	dev->parent = &nvdimm_bus->dev;
+	dev->devt = devt;
+	dev->release = ndctl_release;
+	rc = dev_set_name(dev, "ndctl%d", nvdimm_bus->id);
+	if (rc)
+		goto err;
 
-	if (IS_ERR(dev))
-		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %ld\n",
-				nvdimm_bus->id, PTR_ERR(dev));
-	return PTR_ERR_OR_ZERO(dev);
+	rc = device_add(dev);
+	if (rc) {
+		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %d\n",
+				nvdimm_bus->id, rc);
+		goto err;
+	}
+	return 0;
+
+err:
+	put_device(dev);
+	return rc;
 }
 
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)

