Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7162D3D9C;
	Wed, 13 Apr 2022 18:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875099; x=1681411099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GE8WO4JA2nFKTniAJnVBzWWQMIr5tk1hbaCLNLMyyK0=;
  b=Fvw8tZQ8CtgMG0jIxBNqBNC8jaO9yvHmSkaTCXqmZXqlaRlmCWtgUXud
   W0+yn/DQfzLZsBLe4+P5MehtdU5U2myf24kQD2inX78dp6NpYKp8UoUIQ
   sNtICYRAGkvk6jiM8Jct+dPTS7zb0BpZEcjDDL+wNu68J7orTBvRh4ccm
   8ShpExmeSAX56bZQcmpN6IeNaRL6BZeSotagfdrBBazMF7LtSI1ZKukZg
   DDsKI9Wnmg/wm4VQHhC+NGyjw4obQnATE0yeXJtXASC2jBU1TNkaByTC2
   qm+x8ZIr8xU7XtXLRpVEsUmfTv76/IIghhJS5iDuCIfVFl/Nqrw0jAhfg
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631862"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631862"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013635"
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
Subject: [RFC PATCH 14/15] cxl/region: Introduce configuration
Date: Wed, 13 Apr 2022 11:37:19 -0700
Message-Id: <20220413183720.2444089-15-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The region creation APIs create a vacant region. Configuring the region
works in the same way as similar subsystems such as devdax. Sysfs attrs
will be provided to allow userspace to configure the region. Finally
once all configuration is complete, userspace may activate the region by
binding the driver.

Introduced here are the most basic attributes needed to configure a
region. Details of these attribute are described in the ABI
Documentation.

A example is provided below:

/sys/bus/cxl/devices/region0
├── devtype
├── interleave_granularity
├── interleave_ways
├── modalias
├── offset
├── size
├── subsystem -> ../../../../../../bus/cxl
├── target0
├── uevent
└── uuid

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  64 +++-
 drivers/cxl/core/region.c               | 455 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |  15 +
 drivers/cxl/region.h                    |  76 ++++
 4 files changed, 598 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 5229f4bd109a..9ace58635942 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -195,5 +195,65 @@ Date:		January, 2022
 KernelVersion:	v5.19
 Contact:	linux-cxl@vger.kernel.org
 Description:
-		Deletes the named region. The attribute expects a region number
-		as an integer.
+		Deletes the named region. The attribute expects a region name in
+		the form regionZ where Z is an integer value.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionZ/resource
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		A region is a contiguous partition of a CXL root decoder address
+		space. Region capacity is allocated by writing to the size
+		attribute, the resulting physical address space determined by
+		the driver is reflected here.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionZ/size
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		System physical address space to be consumed by the region. When
+		written to, this attribute will allocate space out of the CXL
+		root decoder's address space. When read the size of the address
+		space is reported and should match the span of the region's
+		resource attribute.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionZ/interleave_ways
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Configures the number of devices participating in the region is
+		set by writing this value. Each device will provide
+		1/interleave_ways of storage for the region.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionZ/interleave_granularity
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Set the number of consecutive bytes each device in the
+		interleave set will claim. The possible interleave granularity
+		values are determined by the CXL spec and the participating
+		devices.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionZ/uuid
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a unique identifier for the region. This field must be set
+		for persistent regions and it must not conflict with the UUID of
+		another region. If this field is set for volatile regions, the
+		value is ignored.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/regionX.Y:Z/target[0..interleave_ways]
+Date:		January, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Write a [endpoint] decoder object that is unused and will
+		participate in decoding memory transactions for the interleave
+		set, ie. decoderX.Y. All required attributes of the decoder must
+		be populated.
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 16829bf2f73a..4766d897f4bf 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -4,9 +4,12 @@
 #include <linux/genalloc.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/uuid.h>
 #include <linux/idr.h>
 #include <region.h>
+#include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
 
@@ -18,21 +21,453 @@
  * Memory ranges, Regions represent the active mapped capacity by the HDM
  * Decoder Capability structures throughout the Host Bridges, Switches, and
  * Endpoints in the topology.
+ *
+ * Region configuration has ordering constraints:
+ * - Targets: Must be set after size
+ * - Size: Must be set after interleave ways
+ * - Interleave ways: Must be set after Interleave Granularity
+ *
+ * UUID may be set at any time before binding the driver to the region.
  */
 
-static struct cxl_region *to_cxl_region(struct device *dev);
+static const struct attribute_group region_interleave_group;
+
+static void remove_target(struct cxl_region *cxlr, int target)
+{
+	struct cxl_endpoint_decoder *cxled;
+
+	mutex_lock(&cxlr->remove_lock);
+	cxled = cxlr->targets[target];
+	if (cxled) {
+		cxled->cxlr = NULL;
+		put_device(&cxled->base.dev);
+	}
+	cxlr->targets[target] = NULL;
+	mutex_unlock(&cxlr->remove_lock);
+}
 
 static void cxl_region_release(struct device *dev)
 {
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	int i;
 
 	memregion_free(cxlr->id);
+	for (i = 0; i < cxlr->interleave_ways; i++)
+		remove_target(cxlr, i);
 	kfree(cxlr);
 }
 
+static ssize_t interleave_ways_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_ways);
+}
+
+static ssize_t interleave_ways_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_decoder *rootd;
+	int rc, val;
+
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	cxl_device_lock(dev);
+
+	if (dev->driver) {
+		cxl_device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (cxlr->interleave_ways) {
+		cxl_device_unlock(dev);
+		return -EEXIST;
+	}
+
+	if (!cxlr->interleave_granularity) {
+		dev_dbg(&cxlr->dev, "IG must be set before IW\n");
+		cxl_device_unlock(dev);
+		return -EILSEQ;
+	}
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_region_ways_valid(rootd, val, cxlr->interleave_granularity)) {
+		cxl_device_unlock(dev);
+		return -EINVAL;
+	}
+
+	cxlr->interleave_ways = val;
+	cxl_device_unlock(dev);
+
+	rc = sysfs_update_group(&cxlr->dev.kobj, &region_interleave_group);
+	if (rc < 0) {
+		cxlr->interleave_ways = 0;
+		return rc;
+	}
+
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_ways);
+
+static ssize_t interleave_granularity_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->interleave_granularity);
+}
+
+static ssize_t interleave_granularity_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_decoder *rootd;
+	int val, ret;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	cxl_device_lock(dev);
+
+	if (dev->driver) {
+		cxl_device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (cxlr->interleave_granularity) {
+		cxl_device_unlock(dev);
+		return -EEXIST;
+	}
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	if (!cxl_region_granularity_valid(rootd, val)) {
+		cxl_device_unlock(dev);
+		return -EINVAL;
+	}
+
+	cxlr->interleave_granularity = val;
+	cxl_device_unlock(dev);
+
+	return len;
+}
+static DEVICE_ATTR_RW(interleave_granularity);
+
+static ssize_t resource_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%#llx\n", cxlr->range.start);
+}
+static DEVICE_ATTR_RO(resource);
+
+static ssize_t size_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_root_decoder *cxlrd;
+	struct cxl_decoder *rootd;
+	unsigned long addr;
+	u64 val;
+	int rc;
+
+	rc = kstrtou64(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (!cxl_region_size_valid(val, cxlr->interleave_ways)) {
+		dev_dbg(&cxlr->dev, "Size must be a multiple of %dM\n",
+			cxlr->interleave_ways * 256);
+		return -EINVAL;
+	}
+
+	cxl_device_lock(dev);
+
+	if (dev->driver) {
+		cxl_device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (!cxlr->interleave_ways) {
+		dev_dbg(&cxlr->dev, "IW must be set before size\n");
+		cxl_device_unlock(dev);
+		return -EILSEQ;
+	}
+
+	rootd = to_cxl_decoder(cxlr->dev.parent);
+	cxlrd = to_cxl_root_decoder(rootd);
+
+	addr = gen_pool_alloc(cxlrd->window, val);
+	if (addr == 0 && rootd->range.start != 0) {
+		rc = -ENOSPC;
+		goto out;
+	}
+
+	cxlr->range = (struct range) {
+		.start = addr,
+		.end = addr + val - 1,
+	};
+
+out:
+	cxl_device_unlock(dev);
+	return rc ? rc : len;
+}
+
+static ssize_t size_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%#llx\n", range_len(&cxlr->range));
+}
+static DEVICE_ATTR_RW(size);
+
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%pUb\n", &cxlr->uuid);
+}
+
+static int is_dupe(struct device *match, void *_cxlr)
+{
+	struct cxl_region *c, *cxlr = _cxlr;
+
+	if (!is_cxl_region(match))
+		return 0;
+
+	if (&cxlr->dev == match)
+		return 0;
+
+	c = to_cxl_region(match);
+	if (uuid_equal(&c->uuid, &cxlr->uuid))
+		return -EEXIST;
+
+	return 0;
+}
+
+static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	ssize_t rc;
+	uuid_t temp;
+
+	if (len != UUID_STRING_LEN + 1)
+		return -EINVAL;
+
+	rc = uuid_parse(buf, &temp);
+	if (rc)
+		return rc;
+
+	cxl_device_lock(dev);
+
+	if (dev->driver) {
+		cxl_device_unlock(dev);
+		return -EBUSY;
+	}
+
+	if (!uuid_is_null(&cxlr->uuid)) {
+		cxl_device_unlock(dev);
+		return -EEXIST;
+	}
+
+	rc = bus_for_each_dev(&cxl_bus_type, NULL, cxlr, is_dupe);
+	if (rc < 0) {
+		cxl_device_unlock(dev);
+		return false;
+	}
+
+	cxlr->uuid = temp;
+	cxl_device_unlock(dev);
+	return len;
+}
+static DEVICE_ATTR_RW(uuid);
+
+static struct attribute *region_attrs[] = {
+	&dev_attr_resource.attr,
+	&dev_attr_interleave_ways.attr,
+	&dev_attr_interleave_granularity.attr,
+	&dev_attr_size.attr,
+	&dev_attr_uuid.attr,
+	NULL,
+};
+
+static const struct attribute_group region_group = {
+	.attrs = region_attrs,
+};
+
+static size_t show_targetN(struct cxl_region *cxlr, char *buf, int n)
+{
+	if (!cxlr->targets[n])
+		return sysfs_emit(buf, "\n");
+
+	return sysfs_emit(buf, "%s\n", dev_name(&cxlr->targets[n]->base.dev));
+}
+
+static size_t store_targetN(struct cxl_region *cxlr, const char *buf, int n,
+			    size_t len)
+{
+	struct cxl_endpoint_decoder *cxled;
+	struct cxl_decoder *cxld;
+	struct device *cxld_dev;
+	struct cxl_port *port;
+
+	cxl_device_lock(&cxlr->dev);
+
+	if (cxlr->dev.driver) {
+		cxl_device_unlock(&cxlr->dev);
+		return -EBUSY;
+	}
+
+	/* The target attrs don't exist until ways are set. No need to check */
+
+	if (cxlr->targets[n]) {
+		cxl_device_unlock(&cxlr->dev);
+		return -EEXIST;
+	}
+
+	cxld_dev = bus_find_device_by_name(&cxl_bus_type, NULL, buf);
+	if (!cxld_dev) {
+		cxl_device_unlock(&cxlr->dev);
+		return -ENOENT;
+	}
+
+	if (!is_cxl_decoder(cxld_dev)) {
+		put_device(cxld_dev);
+		cxl_device_unlock(&cxlr->dev);
+		dev_info(cxld_dev, "Not a decoder\n");
+		return -EINVAL;
+	}
+
+	if (!is_cxl_endpoint(to_cxl_port(cxld_dev->parent))) {
+		put_device(cxld_dev);
+		cxl_device_unlock(&cxlr->dev);
+		dev_info(cxld_dev, "Not an endpoint decoder\n");
+		return -EINVAL;
+	}
+
+	cxld = to_cxl_decoder(cxld_dev);
+	if (cxld->flags & CXL_DECODER_F_ENABLE) {
+		put_device(cxld_dev);
+		cxl_device_unlock(&cxlr->dev);
+		return -EBUSY;
+	}
+
+	/* Decoder reference is held until region probe can complete. */
+	cxled = to_cxl_endpoint_decoder(cxld);
+
+	if (range_len(&cxled->drange) !=
+	    range_len(&cxlr->range) / cxlr->interleave_ways) {
+		put_device(cxld_dev);
+		cxl_device_unlock(&cxlr->dev);
+		dev_info(cxld_dev, "Decoder is the wrong size\n");
+		return -EINVAL;
+	}
+
+	port = to_cxl_port(cxld->dev.parent);
+	if (port->last_cxled &&
+	    cxlr->range.start <= port->last_cxled->drange.start) {
+		put_device(cxld_dev);
+		cxl_device_unlock(&cxlr->dev);
+		dev_info(cxld_dev, "Decoder in set has higher HPA than region. Try different device\n");
+		return -EINVAL;
+	}
+
+	cxlr->targets[n] = cxled;
+	cxled->cxlr = cxlr;
+
+	cxl_device_unlock(&cxlr->dev);
+
+	return len;
+}
+
+#define TARGET_ATTR_RW(n)                                                      \
+	static ssize_t target##n##_show(                                       \
+		struct device *dev, struct device_attribute *attr, char *buf)  \
+	{                                                                      \
+		return show_targetN(to_cxl_region(dev), buf, (n));             \
+	}                                                                      \
+	static ssize_t target##n##_store(struct device *dev,                   \
+					 struct device_attribute *attr,        \
+					 const char *buf, size_t len)          \
+	{                                                                      \
+		return store_targetN(to_cxl_region(dev), buf, (n), len);       \
+	}                                                                      \
+	static DEVICE_ATTR_RW(target##n)
+
+TARGET_ATTR_RW(0);
+TARGET_ATTR_RW(1);
+TARGET_ATTR_RW(2);
+TARGET_ATTR_RW(3);
+TARGET_ATTR_RW(4);
+TARGET_ATTR_RW(5);
+TARGET_ATTR_RW(6);
+TARGET_ATTR_RW(7);
+TARGET_ATTR_RW(8);
+TARGET_ATTR_RW(9);
+TARGET_ATTR_RW(10);
+TARGET_ATTR_RW(11);
+TARGET_ATTR_RW(12);
+TARGET_ATTR_RW(13);
+TARGET_ATTR_RW(14);
+TARGET_ATTR_RW(15);
+
+static struct attribute *interleave_attrs[] = {
+	&dev_attr_target0.attr,
+	&dev_attr_target1.attr,
+	&dev_attr_target2.attr,
+	&dev_attr_target3.attr,
+	&dev_attr_target4.attr,
+	&dev_attr_target5.attr,
+	&dev_attr_target6.attr,
+	&dev_attr_target7.attr,
+	&dev_attr_target8.attr,
+	&dev_attr_target9.attr,
+	&dev_attr_target10.attr,
+	&dev_attr_target11.attr,
+	&dev_attr_target12.attr,
+	&dev_attr_target13.attr,
+	&dev_attr_target14.attr,
+	&dev_attr_target15.attr,
+	NULL,
+};
+
+static umode_t visible_targets(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (n < cxlr->interleave_ways)
+		return a->mode;
+	return 0;
+}
+
+static const struct attribute_group region_interleave_group = {
+	.attrs = interleave_attrs,
+	.is_visible = visible_targets,
+};
+
+static const struct attribute_group *region_groups[] = {
+	&region_group,
+	&region_interleave_group,
+	&cxl_base_attribute_group,
+	NULL,
+};
+
 static const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
+	.groups = region_groups
 };
 
 bool is_cxl_region(struct device *dev)
@@ -41,7 +476,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, CXL);
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -49,6 +484,7 @@ static struct cxl_region *to_cxl_region(struct device *dev)
 
 	return container_of(dev, struct cxl_region, dev);
 }
+EXPORT_SYMBOL_NS_GPL(to_cxl_region, CXL);
 
 static void unregister_region(struct work_struct *work)
 {
@@ -96,20 +532,20 @@ static struct cxl_region *cxl_region_alloc(struct cxl_decoder *cxld)
 	INIT_WORK(&cxlr->detach_work, unregister_region);
 	mutex_init(&cxlr->remove_lock);
 
+	cxlr->range = (struct range) {
+		.start = 0,
+		.end = -1,
+	};
+
 	return cxlr;
 }
 
 /**
  * devm_cxl_add_region - Adds a region to a decoder
- * @cxld: Parent decoder.
- *
- * This is the second step of region initialization. Regions exist within an
- * address space which is mapped by a @cxld. That @cxld must be a root decoder,
- * and it enforces constraints upon the region as it is configured.
+ * @cxld: Root decoder.
  *
  * Return: 0 if the region was added to the @cxld, else returns negative error
- * code. The region will be named "regionX.Y.Z" where X is the port, Y is the
- * decoder id, and Z is the region number.
+ * code. The region will be named "regionX" where Z is the region number.
  */
 static struct cxl_region *devm_cxl_add_region(struct cxl_decoder *cxld)
 {
@@ -191,7 +627,6 @@ static ssize_t create_pmem_region_store(struct device *dev,
 	}
 
 	cxlr = devm_cxl_add_region(cxld);
-	rc = 0;
 	dev_dbg(dev, "Created %s\n", dev_name(&cxlr->dev));
 
 out:
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 3abc8b0cf8f4..db69dfa16f71 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -81,6 +81,19 @@ static inline int cxl_to_interleave_ways(u8 eniw)
 	}
 }
 
+static inline int cxl_from_ways(u8 ways)
+{
+	if (is_power_of_2(ways))
+		return ilog2(ways);
+
+	return ways / 3 + 8;
+}
+
+static inline int cxl_from_granularity(u16 g)
+{
+	return ilog2(g) - 8;
+}
+
 /* CXL 2.0 8.2.8.1 Device Capabilities Array Register */
 #define CXLDEV_CAP_ARRAY_OFFSET 0x0
 #define   CXLDEV_CAP_ARRAY_CAP_ID 0
@@ -277,6 +290,7 @@ struct cxl_switch_decoder {
  * @targets: Downstream targets (ie. hostbridges).
  * @next_region_id: The pre-cached next region id.
  * @id_lock: Protects next_region_id
+ * @regions: List of active regions in this decoder's address space
  */
 struct cxl_root_decoder {
 	struct cxl_decoder base;
@@ -284,6 +298,7 @@ struct cxl_root_decoder {
 	struct cxl_decoder_targets *targets;
 	int next_region_id;
 	struct mutex id_lock; /* synchronizes access to next_region_id */
+	struct list_head regions;
 };
 
 #define _to_cxl_decoder(x)                                                     \
diff --git a/drivers/cxl/region.h b/drivers/cxl/region.h
index 66d9ba195c34..e6457ea3d388 100644
--- a/drivers/cxl/region.h
+++ b/drivers/cxl/region.h
@@ -14,6 +14,12 @@
  * @flags: Flags representing the current state of the region.
  * @detach_work: Async unregister to allow attrs to take device_lock.
  * @remove_lock: Coordinates region removal against decoder removal
+ * @list: Node in decoder's region list.
+ * @range: Resource this region carves out of the platform decode range.
+ * @uuid: The UUID for this region.
+ * @interleave_ways: Number of interleave ways this region is configured for.
+ * @interleave_granularity: Interleave granularity of region
+ * @targets: The memory devices comprising the region.
  */
 struct cxl_region {
 	struct device dev;
@@ -22,8 +28,78 @@ struct cxl_region {
 #define REGION_DEAD 0
 	struct work_struct detach_work;
 	struct mutex remove_lock; /* serialize region removal */
+
+	struct list_head list;
+	struct range range;
+
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct cxl_endpoint_decoder *targets[CXL_DECODER_MAX_INTERLEAVE];
 };
 
+bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
 bool schedule_cxl_region_unregister(struct cxl_region *cxlr);
 
+/**
+ * cxl_region_ways_valid - Determine if ways is valid for the given
+ *				  decoder.
+ * @rootd: The decoder for which validity will be checked
+ * @ways: Determination if ways is valid given @rootd and @granularity
+ * @granularity: The granularity the region will be interleaved
+ */
+static inline bool cxl_region_ways_valid(const struct cxl_decoder *rootd,
+					 u8 ways, u16 granularity)
+{
+	int root_ig, region_ig, root_eniw;
+
+	switch (ways) {
+	case 0 ... 4:
+	case 6:
+	case 8:
+	case 12:
+	case 16:
+		break;
+	default:
+		return false;
+	}
+
+	if (rootd->interleave_ways == 1)
+		return true;
+
+	root_ig = cxl_from_granularity(rootd->interleave_granularity);
+	region_ig = cxl_from_granularity(granularity);
+	root_eniw = cxl_from_ways(rootd->interleave_ways);
+
+	return ((1 << (root_ig - region_ig)) * (1 << root_eniw)) <= ways;
+}
+
+static inline bool cxl_region_granularity_valid(const struct cxl_decoder *rootd,
+						int ig)
+{
+	int rootd_hbig;
+
+	if (!is_power_of_2(ig))
+		return false;
+
+	/* 16K is the max */
+	if (ig >> 15)
+		return false;
+
+	rootd_hbig = cxl_from_granularity(rootd->interleave_granularity);
+	if (rootd_hbig < cxl_from_granularity(ig))
+		return false;
+
+	return true;
+}
+
+static inline bool cxl_region_size_valid(u64 size, int ways)
+{
+	int rem;
+
+	div_u64_rem(size, SZ_256M * ways, &rem);
+	return rem == 0;
+}
+
 #endif
-- 
2.35.1

