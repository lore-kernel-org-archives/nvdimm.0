Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030F22CA5;
	Fri, 28 Jan 2022 00:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643329644; x=1674865644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k4EyZJwC3PbUFi46FkaEvm2S5Ygc92wg6uxvDMN65bM=;
  b=JDZ//XDl78U/8e5tRhn/mu02rTaTdl+1m7OUS+6sXIGIO9C5thg3Npdk
   DxYhVZkoJxhASK8K98tZz8Q2yFnEh04qw59+9GHARKmkR9gMKTF/gmAc9
   DqpX5/qCGYUKsWJH8RGWyXCQevfb+DVpaRLsxpHyXwLRN6EcaddR/+vfj
   vK6AcdXswNnngNFv/SHyL/BlOaamE95g6D6H5JxGGPzKmWaIkgWfB0gTM
   TKELD4es5kctX0cO1fbevK/iy0pNLx3fJjDpEnOuYY5kwWLKiI9asAelI
   waNYRPjR+ETfehexWm1XCpnV4cMMb3785Dmm3HmTelCR2bcdjTDAVnHvy
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226982062"
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="226982062"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,322,1635231600"; 
   d="scan'208";a="674909600"
Received: from vrao2-mobl1.gar.corp.intel.com (HELO localhost.localdomain) ([10.252.129.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 16:27:22 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	nvdimm@lists.linux.dev,
	linux-pci@vger.kernel.org
Subject: [PATCH v3 01/14] cxl/region: Add region creation ABI
Date: Thu, 27 Jan 2022 16:26:54 -0800
Message-Id: <20220128002707.391076-2-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220128002707.391076-1-ben.widawsky@intel.com>
References: <20220128002707.391076-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Regions are created as a child of the decoder that encompasses an
address space with constraints. Regions have a number of attributes that
must be configured before the region can be activated.

The ABI is not meant to be secure, but is meant to avoid accidental
races. As a result, a buggy process may create a region by name that was
allocated by a different process. However, multiple processes which are
trying not to race with each other shouldn't need special
synchronization to do so.

// Allocate a new region name
region=$(cat /sys/bus/cxl/devices/decoder0.0/create_region)

// Create a new region by name
echo $region > /sys/bus/cxl/devices/decoder0.0/create_region

// Region now exists in sysfs
stat -t /sys/bus/cxl/devices/decoder0.0/$region

// Delete the region, and name
echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>

---
Changes since v2:
- Rename 'region' variables to 'cxlr'
- Update ABI docs for possible actual upstream version
---
 Documentation/ABI/testing/sysfs-bus-cxl       |  24 ++
 .../driver-api/cxl/memory-devices.rst         |  11 +
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   3 +
 drivers/cxl/core/port.c                       |  16 ++
 drivers/cxl/core/region.c                     | 208 ++++++++++++++++++
 drivers/cxl/cxl.h                             |   9 +
 drivers/cxl/region.h                          |  38 ++++
 tools/testing/cxl/Kbuild                      |   1 +
 9 files changed, 311 insertions(+)
 create mode 100644 drivers/cxl/core/region.c
 create mode 100644 drivers/cxl/region.h

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 7c2b846521f3..dcc728458936 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -163,3 +163,27 @@ Description:
 		memory (type-3). The 'target_type' attribute indicates the
 		current setting which may dynamically change based on what
 		memory regions are activated in this decode hierarchy.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/create_region
+Date:		August, 2021
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Creates a new CXL region. Writing a value of the form
+		"regionX.Y:Z" will create a new uninitialized region that will
+		be mapped by the CXL decoderX.Y. Reading from this node will
+		return a newly allocated region name. In order to create a
+		region (writing) you must use a value returned from reading the
+		node. Regions must be created for root decoders, and must
+		subsequently configured and bound to a region driver before they
+		can be used.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
+Date:		August, 2021
+KernelVersion:	v5.18
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Deletes the named region. A region must be unbound from the
+		region driver before being deleted. The attributes expects a
+		region in the form "regionX.Y:Z". The region's name, allocated
+		by reading create_region, will also be released.
diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index db476bb170b6..66ddc58a21b1 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -362,6 +362,17 @@ CXL Core
 .. kernel-doc:: drivers/cxl/core/mbox.c
    :doc: cxl mbox
 
+CXL Regions
+-----------
+.. kernel-doc:: drivers/cxl/region.h
+   :identifiers:
+
+.. kernel-doc:: drivers/cxl/core/region.c
+   :doc: cxl core region
+
+.. kernel-doc:: drivers/cxl/core/region.c
+   :identifiers:
+
 External Interfaces
 ===================
 
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 6d37cd78b151..39ce8f2f2373 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_CXL_BUS) += cxl_core.o
 ccflags-y += -I$(srctree)/drivers/cxl
 cxl_core-y := port.o
 cxl_core-y += pmem.o
+cxl_core-y += region.o
 cxl_core-y += regs.o
 cxl_core-y += memdev.o
 cxl_core-y += mbox.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index efbaa851929d..35fd08d560e2 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -10,6 +10,9 @@ extern const struct device_type cxl_memdev_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
+extern struct device_attribute dev_attr_create_region;
+extern struct device_attribute dev_attr_delete_region;
+
 struct cxl_send_command;
 struct cxl_mem_query_commands;
 int cxl_query_cmd(struct cxl_memdev *cxlmd,
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 631dec0fa79e..0826208b2bdf 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -215,6 +215,8 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 };
 
 static struct attribute *cxl_decoder_root_attrs[] = {
+	&dev_attr_create_region.attr,
+	&dev_attr_delete_region.attr,
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
 	&dev_attr_cap_type2.attr,
@@ -267,11 +269,23 @@ static const struct attribute_group *cxl_decoder_endpoint_attribute_groups[] = {
 	NULL,
 };
 
+static int delete_region(struct device *dev, void *arg)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
+
+	return cxl_delete_region(cxld, dev_name(dev));
+}
+
 static void cxl_decoder_release(struct device *dev)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 	struct cxl_port *port = to_cxl_port(dev->parent);
 
+	device_for_each_child(&cxld->dev, cxld, delete_region);
+
+	dev_WARN_ONCE(dev, !ida_is_empty(&cxld->region_ida),
+		      "Lost track of a region");
+
 	ida_free(&port->decoder_ida, cxld->id);
 	kfree(cxld);
 }
@@ -1194,6 +1208,8 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	cxld->target_type = CXL_DECODER_EXPANDER;
 	cxld->platform_res = (struct resource)DEFINE_RES_MEM(0, 0);
 
+	ida_init(&cxld->region_ida);
+
 	return cxld;
 err:
 	kfree(cxld);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
new file mode 100644
index 000000000000..1a448543db0d
--- /dev/null
+++ b/drivers/cxl/core/region.c
@@ -0,0 +1,208 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <region.h>
+#include <cxl.h>
+#include "core.h"
+
+/**
+ * DOC: cxl core region
+ *
+ * Regions are managed through the Linux device model. Each region instance is a
+ * unique struct device. CXL core provides functionality to create, destroy, and
+ * configure regions. This is all implemented here. Binding a region
+ * (programming the hardware) is handled by a separate region driver.
+ */
+
+static void cxl_region_release(struct device *dev);
+
+static const struct device_type cxl_region_type = {
+	.name = "cxl_region",
+	.release = cxl_region_release,
+};
+
+static ssize_t create_region_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct cxl_port *port = to_cxl_port(dev->parent);
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	int rc;
+
+	if (dev_WARN_ONCE(dev, !is_root_decoder(dev),
+			  "Invalid decoder selected for region.")) {
+		return -ENODEV;
+	}
+
+	rc = ida_alloc(&cxld->region_ida, GFP_KERNEL);
+	if (rc < 0) {
+		dev_err(&cxld->dev, "Couldn't get a new id\n");
+		return rc;
+	}
+
+	return sysfs_emit(buf, "region%d.%d:%d\n", port->id, cxld->id, rc);
+}
+
+static ssize_t create_region_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct cxl_port *port = to_cxl_port(dev->parent);
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	int decoder_id, port_id, region_id;
+	struct cxl_region *cxlr;
+	ssize_t rc;
+
+	if (sscanf(buf, "region%d.%d:%d", &port_id, &decoder_id, &region_id) != 3)
+		return -EINVAL;
+
+	if (decoder_id != cxld->id)
+		return -EINVAL;
+
+	if (port_id != port->id)
+		return -EINVAL;
+
+	cxlr = cxl_alloc_region(cxld, region_id);
+	if (IS_ERR(cxlr))
+		return PTR_ERR(cxlr);
+
+	rc = cxl_add_region(cxld, cxlr);
+	if (rc) {
+		kfree(cxlr);
+		return rc;
+	}
+
+	return len;
+}
+DEVICE_ATTR_RW(create_region);
+
+static ssize_t delete_region_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	int rc;
+
+	rc = cxl_delete_region(cxld, buf);
+	if (rc)
+		return rc;
+
+	return len;
+}
+DEVICE_ATTR_WO(delete_region);
+
+struct cxl_region *to_cxl_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
+			  "not a cxl_region device\n"))
+		return NULL;
+
+	return container_of(dev, struct cxl_region, dev);
+}
+EXPORT_SYMBOL_GPL(to_cxl_region);
+
+static void cxl_region_release(struct device *dev)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev->parent);
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	ida_free(&cxld->region_ida, cxlr->id);
+	kfree(cxlr);
+}
+
+struct cxl_region *cxl_alloc_region(struct cxl_decoder *cxld, int id)
+{
+	struct cxl_region *cxlr;
+
+	cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
+	if (!cxlr)
+		return ERR_PTR(-ENOMEM);
+
+	cxlr->id = id;
+
+	return cxlr;
+}
+
+/**
+ * cxl_add_region - Adds a region to a decoder
+ * @cxld: Parent decoder.
+ * @cxlr: Region to be added to the decoder.
+ *
+ * This is the second step of region initialization. Regions exist within an
+ * address space which is mapped by a @cxld. That @cxld must be a root decoder,
+ * and it enforces constraints upon the region as it is configured.
+ *
+ * Return: 0 if the region was added to the @cxld, else returns negative error
+ * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
+ * decoder id, and Z is the region number.
+ */
+int cxl_add_region(struct cxl_decoder *cxld, struct cxl_region *cxlr)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct device *dev = &cxlr->dev;
+	int rc;
+
+	device_initialize(dev);
+	dev->parent = &cxld->dev;
+	device_set_pm_not_required(dev);
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_region_type;
+	rc = dev_set_name(dev, "region%d.%d:%d", port->id, cxld->id, cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(dev, "Added to %s\n", dev_name(&cxld->dev));
+
+	return 0;
+
+err:
+	put_device(dev);
+	return rc;
+}
+
+static struct cxl_region *cxl_find_region_by_name(struct cxl_decoder *cxld,
+						  const char *name)
+{
+	struct device *region_dev;
+
+	region_dev = device_find_child_by_name(&cxld->dev, name);
+	if (!region_dev)
+		return ERR_PTR(-ENOENT);
+
+	return to_cxl_region(region_dev);
+}
+
+/**
+ * cxl_delete_region - Deletes a region
+ * @cxld: Parent decoder
+ * @region_name: Named region, ie. regionX.Y:Z
+ */
+int cxl_delete_region(struct cxl_decoder *cxld, const char *region_name)
+{
+	struct cxl_region *cxlr;
+
+	device_lock(&cxld->dev);
+
+	cxlr = cxl_find_region_by_name(cxld, region_name);
+	if (IS_ERR(cxlr)) {
+		device_unlock(&cxld->dev);
+		return PTR_ERR(cxlr);
+	}
+
+	dev_dbg(&cxld->dev, "Requested removal of %s from %s\n",
+		dev_name(&cxlr->dev), dev_name(&cxld->dev));
+
+	device_unregister(&cxlr->dev);
+	device_unlock(&cxld->dev);
+
+	put_device(&cxlr->dev);
+
+	return 0;
+}
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 13fb06849199..b9f0099c1f39 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -221,6 +221,7 @@ enum cxl_decoder_type {
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @flags: memory type capabilities and locking
  * @target_lock: coordinate coherent reads of the target list
+ * @region_ida: allocator for region ids.
  * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  */
@@ -236,6 +237,7 @@ struct cxl_decoder {
 	enum cxl_decoder_type target_type;
 	unsigned long flags;
 	seqlock_t target_lock;
+	struct ida region_ida;
 	int nr_targets;
 	struct cxl_dport *target[];
 };
@@ -323,6 +325,13 @@ struct cxl_ep {
 	struct list_head list;
 };
 
+bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
+struct cxl_region *cxl_alloc_region(struct cxl_decoder *cxld,
+				    int interleave_ways);
+int cxl_add_region(struct cxl_decoder *cxld, struct cxl_region *cxlr);
+int cxl_delete_region(struct cxl_decoder *cxld, const char *region);
+
 static inline bool is_cxl_root(struct cxl_port *port)
 {
 	return port->uport == port->dev.parent;
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
new file mode 100644
index 000000000000..eb1249e3c1d4
--- /dev/null
+++ b/drivers/cxl/region.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2021 Intel Corporation. */
+#ifndef __CXL_REGION_H__
+#define __CXL_REGION_H__
+
+#include <linux/uuid.h>
+
+#include "cxl.h"
+
+/**
+ * struct cxl_region - CXL region
+ * @dev: This region's device.
+ * @id: This regions id. Id is globally unique across all regions.
+ * @list: Node in decoder's region list.
+ * @res: Resource this region carves out of the platform decode range.
+ * @config: HDM decoder program config
+ * @config.size: Size of the region determined from LSA or userspace.
+ * @config.uuid: The UUID for this region.
+ * @config.interleave_ways: Number of interleave ways this region is configured for.
+ * @config.interleave_granularity: Interleave granularity of region
+ * @config.targets: The memory devices comprising the region.
+ */
+struct cxl_region {
+	struct device dev;
+	int id;
+	struct list_head list;
+	struct resource *res;
+
+	struct {
+		u64 size;
+		uuid_t uuid;
+		int interleave_ways;
+		int interleave_granularity;
+		struct cxl_memdev *targets[CXL_DECODER_MAX_INTERLEAVE];
+	} config;
+};
+
+#endif
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 82e49ab0937d..3fe6d34e6d59 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -46,6 +46,7 @@ cxl_core-y += $(CXL_CORE_SRC)/memdev.o
 cxl_core-y += $(CXL_CORE_SRC)/mbox.o
 cxl_core-y += $(CXL_CORE_SRC)/pci.o
 cxl_core-y += $(CXL_CORE_SRC)/hdm.o
+cxl_core-y += $(CXL_CORE_SRC)/region.o
 cxl_core-y += config_check.o
 
 obj-m += test/
-- 
2.35.0

