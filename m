Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3/3] libnvdimm: Add sysfs numa_node to NVDIMM devices
Date: Tue,  2 Jun 2015 18:26:52 -0600
Message-Id: <1433291212-23367-4-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

Since NVDIMMs are installed on memory slots, they expose the NUMA
topology of a platform.

This patch adds support of sysfs 'numa_node' to the NVDIMM devices
under /sys/bus/nd/devices, such as regionN, namespaceN.0, and bttN.
When bttN is not set up, its numa_node returns -1 (NUMA_NO_NODE).
nmemN/numa_node always returns -1 for now since this device is for
dimm-ioctl message interface and has little use of NUMA.  It can be
enhanced later to set a valid value if necessary.

Here is an example of numa_node values on a 2-socket system with
a single NVDIMM range on each socket.
  /sys/bus/nd/devices
  |-- btt0/numa_node:-1
  |-- btt1/numa_node:0
  |-- namespace0.0/numa_node:0
  |-- namespace1.0/numa_node:1
  |-- nmem0/numa_node:-1
  |-- nmem1/numa_node:-1
  |-- region0/numa_node:0
  |-- region1/numa_node:1

With this change, numactl(8) accepts 'block:' and 'file:' paths of
pmem and btt devices as shown in the examples below.
  numactl --preferred block:pmem0 --show
  numactl --preferred file:/dev/pmem0s --show

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 drivers/acpi/nfit.c          |    2 ++
 drivers/nvdimm/btt.c         |    2 ++
 drivers/nvdimm/bus.c         |   12 ++++++++++++
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region.c      |    1 +
 drivers/nvdimm/region_devs.c |    1 +
 include/linux/libnvdimm.h    |    1 +
 7 files changed, 20 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 5731e4a..a255f3a 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1255,6 +1255,8 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 	ndr_desc->res = &res;
 	ndr_desc->provider_data = nfit_spa;
 	ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
+	ndr_desc->numa_node = acpi_map_pxm_to_node(spa->proximity_domain);
+
 	list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
 		struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
 		struct nd_mapping *nd_mapping;
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 2d7ce9e..3b3e115 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1369,6 +1369,8 @@ static int nd_btt_probe(struct device *dev)
 		rc = -ENOMEM;
 		goto err_btt;
 	}
+
+	set_dev_node(dev, nd_region->numa_node);
 	dev_set_drvdata(dev, btt);
 
 	return 0;
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index d8a1794..5c34e68 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -339,9 +339,21 @@ static ssize_t devtype_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(devtype);
 
+#ifdef CONFIG_NUMA
+static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%d\n", dev->numa_node);
+}
+DEVICE_ATTR_RO(numa_node);
+#endif
+
 static struct attribute *nd_device_attributes[] = {
 	&dev_attr_modalias.attr,
 	&dev_attr_devtype.attr,
+#ifdef CONFIG_NUMA
+	&dev_attr_numa_node.attr,
+#endif
 	NULL,
 };
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index c807379..fefd8f6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -108,6 +108,7 @@ struct nd_region {
 	u64 ndr_size;
 	u64 ndr_start;
 	int id, num_lanes;
+	int numa_node;
 	void *provider_data;
 	struct nd_interleave_set *nd_set;
 	struct nd_mapping mapping[0];
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 373eab4..783220e 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -123,6 +123,7 @@ static int nd_region_probe(struct device *dev)
 
 	num_ns->active = rc;
 	num_ns->count = rc + err;
+	set_dev_node(dev, nd_region->numa_node);
 	dev_set_drvdata(dev, num_ns);
 
 	if (err == 0)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 86adbd8..352bc80 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -627,6 +627,7 @@ static noinline struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus
 	nd_region->provider_data = ndr_desc->provider_data;
 	nd_region->nd_set = ndr_desc->nd_set;
 	nd_region->num_lanes = ndr_desc->num_lanes;
+	nd_region->numa_node = ndr_desc->numa_node;
 	ida_init(&nd_region->ns_ida);
 	dev = &nd_region->dev;
 	dev_set_name(dev, "region%d", nd_region->id);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 96b9507..5d0c75a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -78,6 +78,7 @@ struct nd_region_desc {
 	struct nd_interleave_set *nd_set;
 	void *provider_data;
 	int num_lanes;
+	int numa_node;
 };
 
 struct nvdimm_bus;
