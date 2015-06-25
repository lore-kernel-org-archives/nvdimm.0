Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v2 16/17] libnvdimm: Add sysfs numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jun 2015 05:37:43 -0400
Message-ID: <20150625093743.40066.92148.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
References: <20150625090554.40066.69562.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: axboe@kernel.dk, boaz@plexistor.com, toshi.kani@hp.com, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Toshi Kani <toshi.kani@hp.com>

Add support of sysfs 'numa_node' to I/O-related NVDIMM devices
under /sys/bus/nd/devices, regionN, namespaceN.0, and bttN.
When bttN is not set up, its numa_node returns -1 (NUMA_NO_NODE).

An example of numa_node values on a 2-socket system with a single
NVDIMM range on each socket is shown below.
  /sys/bus/nd/devices
  |-- btt0/numa_node:-1
  |-- btt1/numa_node:0
  |-- namespace0.0/numa_node:0
  |-- namespace1.0/numa_node:1
  |-- region0/numa_node:0
  |-- region1/numa_node:1

These numa_node files are then linked under the block class of
their device names.
  /sys/class/block/pmem0/device/numa_node:0
  /sys/class/block/pmem0s/device/numa_node:0
  /sys/class/block/pmem1/device/numa_node:1

This enables numactl(8) to accept 'block:' and 'file:' paths of
pmem and btt devices as shown in the examples below.
  numactl --preferred block:pmem0 --show
  numactl --preferred file:/dev/pmem0s --show

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c             |    1 +
 drivers/nvdimm/btt_devs.c       |    1 +
 drivers/nvdimm/bus.c            |   30 ++++++++++++++++++++++++++++++
 drivers/nvdimm/namespace_devs.c |    1 +
 include/linux/libnvdimm.h       |    1 +
 5 files changed, 34 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index d96c8fe974dd..2161fa178c8d 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -873,6 +873,7 @@ static const struct attribute_group *acpi_nfit_region_attribute_groups[] = {
 	&nd_region_attribute_group,
 	&nd_mapping_attribute_group,
 	&nd_device_attribute_group,
+	&nd_numa_attribute_group,
 	&acpi_nfit_region_attribute_group,
 	NULL,
 };
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index b6724cfbcfca..2dfb529f4d35 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -294,6 +294,7 @@ static struct attribute_group nd_btt_attribute_group = {
 static const struct attribute_group *nd_btt_attribute_groups[] = {
 	&nd_btt_attribute_group,
 	&nd_device_attribute_group,
+	&nd_numa_attribute_group,
 	NULL,
 };
 
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index ec59f1f26d95..1380954a6593 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -274,6 +274,36 @@ struct attribute_group nd_device_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nd_device_attribute_group);
 
+static ssize_t numa_node_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", dev_to_node(dev));
+}
+static DEVICE_ATTR_RO(numa_node);
+
+static struct attribute *nd_numa_attributes[] = {
+	&dev_attr_numa_node.attr,
+	NULL,
+};
+
+static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
+		int n)
+{
+	if (!IS_ENABLED(CONFIG_NUMA))
+		return 0;
+
+	return a->mode;
+}
+
+/**
+ * nd_numa_attribute_group - NUMA attributes for all devices on an nd bus
+ */
+struct attribute_group nd_numa_attribute_group = {
+	.attrs = nd_numa_attributes,
+	.is_visible = nd_numa_attr_visible,
+};
+EXPORT_SYMBOL_GPL(nd_numa_attribute_group);
+
 int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 {
 	dev_t devt = MKDEV(nvdimm_bus_major, nvdimm_bus->id);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 27d69bd3b4d6..fef0dd80d4ad 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1228,6 +1228,7 @@ static struct attribute_group nd_namespace_attribute_group = {
 static const struct attribute_group *nd_namespace_attribute_groups[] = {
 	&nd_device_attribute_group,
 	&nd_namespace_attribute_group,
+	&nd_numa_attribute_group,
 	NULL,
 };
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 30b3deaafd51..75e3af01ee32 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -38,6 +38,7 @@ enum {
 extern struct attribute_group nvdimm_bus_attribute_group;
 extern struct attribute_group nvdimm_attribute_group;
 extern struct attribute_group nd_device_attribute_group;
+extern struct attribute_group nd_numa_attribute_group;
 extern struct attribute_group nd_region_attribute_group;
 extern struct attribute_group nd_mapping_attribute_group;
 

