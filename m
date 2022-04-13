Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A873D8D;
	Wed, 13 Apr 2022 18:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875097; x=1681411097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A08ZtqBkpxmYlMioCtWhkKAwbN/JwTf6N/V87wbOrSU=;
  b=FE6VXa4tpdGKY1egNPoVGBHzdid3IrEViD3z8ijoPHSCYMyO3Hb7y1do
   KUpeHS+Z8SaM2TfgDNnL7xfSC6ZwIxs1ItQVYyzMtRAmgP3RjHiMmUcku
   54QBDrA40MN8H9aqzxFwTPRBhHx7g/DkJkzWwS1x6uTb5rEFBD33Anlbz
   88UBBaA2NdNPLdTIhi7UBnFIpHclSh+jBGlz4+Wk8G/LWJYWCl44E9CQP
   zRSetTq869bf77uaVPqIZygqD1JgX1tEvuEqJmOEHcSI+871NcuemiiX6
   c1btpRh2ZurG0YKScn9v7t3s7nkxKvF6GtiaF/iRqIVcv3Cmqh+4Ekh94
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631858"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631858"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013626"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:51 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 12/15] cxl/region: Add region creation ABI
Date: Wed, 13 Apr 2022 11:37:17 -0700
Message-Id: <20220413183720.2444089-13-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
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

Multiple processes which are trying not to race with each other
shouldn't need special userspace synchronization to do so.

// Allocate a new region name
region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)

// Create a new region by name
while
region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
! echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
do true; done

// Region now exists in sysfs
stat -t /sys/bus/cxl/devices/decoder0.0/$region

// Delete the region, and name
echo $region > /sys/bus/cxl/devices/decoder0.0/delete_region

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl       |  23 ++
 .../driver-api/cxl/memory-devices.rst         |  11 +
 drivers/cxl/Kconfig                           |   5 +
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/port.c                       |  39 ++-
 drivers/cxl/core/region.c                     | 234 ++++++++++++++++++
 drivers/cxl/cxl.h                             |   7 +
 drivers/cxl/region.h                          |  29 +++
 tools/testing/cxl/Kbuild                      |   1 +
 9 files changed, 347 insertions(+), 3 deletions(-)
 create mode 100644 drivers/cxl/core/region.c
 create mode 100644 drivers/cxl/region.h

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 01fee09b8473..5229f4bd109a 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -174,3 +174,26 @@ Description:
 		Provide a knob to set/get whether the desired media is volatile
 		or persistent. This applies only to decoders of devtype
 		"cxl_decoder_endpoint",
+
+What:		/sys/bus/cxl/devices/decoderX.Y/create_pmem_region
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write an integer value to instantiate a new region to be named
+		regionZ within the decode range bounded by decoderX.Y. Where X,
+		Y, and Z are unsigned integers, and where decoderX.Y exists in
+		the CXL sysfs topology. The value written must match the current
+		value returned from reading this attribute. This behavior lets
+		the kernel arbitrate racing attempts to create a region. The
+		thread that fails to write loops and tries the next value.
+		Regions must subsequently configured and bound to a region
+		driver before they can be used.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/delete_region
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Deletes the named region. The attribute expects a region number
+		as an integer.
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
 
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 8796fd4b22bc..7ce86eee8bda 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -99,4 +99,9 @@ config CXL_PORT
 	default CXL_BUS
 	select DEVICE_PRIVATE
 
+config CXL_REGION
+	tristate
+	default CXL_BUS
+	select MEMREGION
+
 endif
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
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index bdafdec80d98..5ef8a6e1ea23 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/memregion.h>
 #include <linux/workqueue.h>
 #include <linux/genalloc.h>
 #include <linux/device.h>
@@ -11,6 +12,7 @@
 #include <linux/idr.h>
 #include <cxlmem.h>
 #include <cxlpci.h>
+#include <region.h>
 #include <cxl.h>
 #include "core.h"
 
@@ -328,6 +330,8 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 };
 
 static struct attribute *cxl_decoder_root_attrs[] = {
+	&dev_attr_create_pmem_region.attr,
+	&dev_attr_delete_region.attr,
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
 	&dev_attr_cap_type2.attr,
@@ -375,6 +379,8 @@ static void cxl_decoder_release(struct device *dev)
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 	struct cxl_port *port = to_cxl_port(dev->parent);
 
+	if (is_root_decoder(dev))
+		memregion_free(to_cxl_root_decoder(cxld)->next_region_id);
 	ida_free(&port->decoder_ida, cxld->id);
 	kfree(cxld);
 	put_device(&port->dev);
@@ -1414,12 +1420,22 @@ static struct cxl_decoder *cxl_decoder_alloc(struct cxl_port *port,
 	device_set_pm_not_required(dev);
 	dev->parent = &port->dev;
 	dev->bus = &cxl_bus_type;
-	if (is_cxl_root(port))
+	if (is_cxl_root(port)) {
+		struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+
 		cxld->dev.type = &cxl_decoder_root_type;
-	else if (is_cxl_endpoint(port))
+		mutex_init(&cxlrd->id_lock);
+		rc = memregion_alloc(GFP_KERNEL);
+		if (rc < 0)
+			goto err;
+
+		cxlrd->next_region_id = rc;
+		cxld->dev.type = &cxl_decoder_root_type;
+	} else if (is_cxl_endpoint(port)) {
 		cxld->dev.type = &cxl_decoder_endpoint_type;
-	else
+	} else {
 		cxld->dev.type = &cxl_decoder_switch_type;
+	}
 
 	/* Pre initialize an "empty" decoder */
 	cxld->interleave_ways = 1;
@@ -1582,6 +1598,17 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
 
 static void cxld_unregister(void *dev)
 {
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled;
+
+	if (!is_endpoint_decoder(&cxld->dev))
+		goto out;
+
+	mutex_lock(&cxled->cxlr->remove_lock);
+	device_release_driver(&cxled->cxlr->dev);
+	mutex_unlock(&cxled->cxlr->remove_lock);
+
+out:
 	device_unregister(dev);
 }
 
@@ -1681,6 +1708,12 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
 
+bool schedule_cxl_region_unregister(struct cxl_region *cxlr)
+{
+	return queue_work(cxl_bus_wq, &cxlr->detach_work);
+}
+EXPORT_SYMBOL_NS_GPL(schedule_cxl_region_unregister, CXL);
+
 /* for user tooling to ensure port disable work has completed */
 static ssize_t flush_store(struct bus_type *bus, const char *buf, size_t count)
 {
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
new file mode 100644
index 000000000000..16829bf2f73a
--- /dev/null
+++ b/drivers/cxl/core/region.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/memregion.h>
+#include <linux/genalloc.h>
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
+ * CXL Regions represent mapped memory capacity in system physical address
+ * space. Whereas the CXL Root Decoders identify the bounds of potential CXL
+ * Memory ranges, Regions represent the active mapped capacity by the HDM
+ * Decoder Capability structures throughout the Host Bridges, Switches, and
+ * Endpoints in the topology.
+ */
+
+static struct cxl_region *to_cxl_region(struct device *dev);
+
+static void cxl_region_release(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	memregion_free(cxlr->id);
+	kfree(cxlr);
+}
+
+static const struct device_type cxl_region_type = {
+	.name = "cxl_region",
+	.release = cxl_region_release,
+};
+
+bool is_cxl_region(struct device *dev)
+{
+	return dev->type == &cxl_region_type;
+}
+EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
+
+static struct cxl_region *to_cxl_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
+			  "not a cxl_region device\n"))
+		return NULL;
+
+	return container_of(dev, struct cxl_region, dev);
+}
+
+static void unregister_region(struct work_struct *work)
+{
+	struct cxl_region *cxlr;
+
+	cxlr = container_of(work, typeof(*cxlr), detach_work);
+	device_unregister(&cxlr->dev);
+}
+
+static void schedule_unregister(void *cxlr)
+{
+	schedule_cxl_region_unregister(cxlr);
+}
+
+static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
+{
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	struct cxl_region *cxlr;
+	struct device *dev;
+	int rc;
+
+	lockdep_assert_held(&cxlrd->id_lock);
+
+	rc = memregion_alloc(GFP_KERNEL);
+	if (rc < 0) {
+		dev_dbg(dev, "Failed to get next cached id (%d)\n", rc);
+		return ERR_PTR(rc);
+	}
+
+	cxlr = kzalloc(sizeof(*cxlr), GFP_KERNEL);
+	if (!cxlr) {
+		memregion_free(rc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	cxlr->id = cxlrd->next_region_id;
+	cxlrd->next_region_id = rc;
+
+	dev = &cxlr->dev;
+	device_initialize(dev);
+	dev->parent = &cxld->dev;
+	device_set_pm_not_required(dev);
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_region_type;
+	INIT_WORK(&cxlr->detach_work, unregister_region);
+	mutex_init(&cxlr->remove_lock);
+
+	return cxlr;
+}
+
+/**
+ * devm_cxl_add_region - Adds a region to a decoder
+ * @cxld: Parent decoder.
+ *
+ * This is the second step of region initialization. Regions exist within an
+ * address space which is mapped by a @cxld. That @cxld must be a root decoder,
+ * and it enforces constraints upon the region as it is configured.
+ *
+ * Return: 0 if the region was added to the @cxld, else returns negative error
+ * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
+ * decoder id, and Z is the region number.
+ */
+static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+	struct cxl_region *cxlr;
+	struct device *dev;
+	int rc;
+
+	cxlr = cxl_region_alloc(cxld);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	dev = &cxlr->dev;
+
+	rc = dev_set_name(dev, "region%d", cxlr->id);
+	if (rc)
+		goto err_out;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err_put;
+
+	rc = devm_add_action_or_reset(port->uport, schedule_unregister, cxlr);
+	if (rc)
+		goto err_put;
+
+	return cxlr;
+
+err_put:
+	put_device(&cxld->dev);
+
+err_out:
+	put_device(dev);
+	return ERR_PTR(rc);
+}
+
+static ssize_t create_pmem_region_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	size_t rc;
+
+	/*
+	 * There's no point in returning known bad answers when the lock is held
+	 * on the store side, even though the answer given here may be
+	 * immediately invalidated as soon as the lock is dropped it's still
+	 * useful to throttle readers in the presence of writers.
+	 */
+	rc = mutex_lock_interruptible(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+	rc = sysfs_emit(buf, "%d\n", cxlrd->next_region_id);
+	mutex_unlock(&cxlrd->id_lock);
+
+	return rc;
+}
+
+static ssize_t create_pmem_region_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(cxld);
+	struct cxl_region *cxlr;
+	size_t id, rc;
+
+	rc = kstrtoul(buf, 10, &id);
+	if (rc)
+		return rc;
+
+	rc = mutex_lock_interruptible(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+
+	if (cxlrd->next_region_id != id) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	cxlr = devm_cxl_add_region(cxld);
+	rc = 0;
+	dev_dbg(dev, "Created %s\n", dev_name(&cxlr->dev));
+
+out:
+	mutex_unlock(&cxlrd->id_lock);
+	if (rc)
+		return rc;
+	return len;
+}
+DEVICE_ATTR_RW(create_pmem_region);
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
+static ssize_t delete_region_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t len)
+{
+	struct cxl_port *port = to_cxl_port(dev->parent);
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_region *cxlr;
+
+	cxlr = cxl_find_region_by_name(cxld, buf);
+	if (IS_ERR(cxlr))
+		return PTR_ERR(cxlr);
+
+	/* Reference held for wq */
+	devm_release_action(port->uport, schedule_unregister, cxlr);
+
+	return len;
+}
+DEVICE_ATTR_WO(delete_region);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 0586c3d4592c..3abc8b0cf8f4 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -249,6 +249,7 @@ struct cxl_decoder {
  * @skip: The skip count as specified in the CXL specification.
  * @res_lock: Synchronize device's resource usage
  * @volatil: Configuration param. Decoder target is non-persistent mem
+ * @cxlr: Region this decoder belongs to.
  */
 struct cxl_endpoint_decoder {
 	struct cxl_decoder base;
@@ -256,6 +257,7 @@ struct cxl_endpoint_decoder {
 	u64 skip;
 	struct mutex res_lock; /* sync access to decoder's resource */
 	bool volatil;
+	struct cxl_region *cxlr;
 };
 
 /**
@@ -454,6 +456,8 @@ struct cxl_hdm *devm_cxl_setup_hdm(struct cxl_port *port);
 int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm);
 int devm_cxl_add_passthrough_decoder(struct cxl_port *port);
 
+bool is_cxl_region(struct device *dev);
+
 extern struct bus_type cxl_bus_type;
 
 struct cxl_driver {
@@ -508,6 +512,7 @@ enum cxl_lock_class {
 	CXL_ANON_LOCK,
 	CXL_NVDIMM_LOCK,
 	CXL_NVDIMM_BRIDGE_LOCK,
+	CXL_REGION_LOCK,
 	CXL_PORT_LOCK,
 	/*
 	 * Be careful to add new lock classes here, CXL_PORT_LOCK is
@@ -536,6 +541,8 @@ static inline void cxl_nested_lock(struct device *dev)
 		mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_BRIDGE_LOCK);
 	else if (is_cxl_nvdimm(dev))
 		mutex_lock_nested(&dev->lockdep_mutex, CXL_NVDIMM_LOCK);
+	else if (is_cxl_region(dev))
+		mutex_lock_nested(&dev->lockdep_mutex, CXL_REGION_LOCK);
 	else
 		mutex_lock_nested(&dev->lockdep_mutex, CXL_ANON_LOCK);
 }
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
new file mode 100644
index 000000000000..66d9ba195c34
--- /dev/null
+++ b/drivers/cxl/region.h
@@ -0,0 +1,29 @@
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
+ * @id: This region's id. Id is globally unique across all regions.
+ * @flags: Flags representing the current state of the region.
+ * @detach_work: Async unregister to allow attrs to take device_lock.
+ * @remove_lock: Coordinates region removal against decoder removal
+ */
+struct cxl_region {
+	struct device dev;
+	int id;
+	unsigned long flags;
+#define REGION_DEAD 0
+	struct work_struct detach_work;
+	struct mutex remove_lock; /* serialize region removal */
+};
+
+bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
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
2.35.1

