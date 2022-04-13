Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2872F3B;
	Wed, 13 Apr 2022 18:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875095; x=1681411095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGYR65MFaiiuy5Lo24QFC6NqUiqMmD6aLbcUy9Q7Rcg=;
  b=Jg8tWTZAy5cXv487f70A0d5clX2AdyAOM4AYo5W5R4Lus19O2ETxeMn3
   5r/oDWz6FPHLkzl/3Z/nlCKfjSe1buxcvV/Nrfk6Pn2BwMi5LUl5TXbnr
   TVCLLGlhly3wEVvnpFRzUV6qugLYmD6QIBp3Px/kLAxeK6i9X527srtPo
   j/wJ9WbtKy8IaZv04AiCiENbw7/kb74huzNN/uYaXMNBPzCWB16YuUBSz
   SHJ9jaaGEuQp+WFWF0NRustC9JQxtM8CaRbDc57ql90KceA7C9IVbKtqy
   aOUrSTR4A2go4h+DJIm9zfeHr2Okg6ddWecHzeFQtScso0mBejzh3II0g
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631851"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631851"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013608"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:50 -0700
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
Subject: [RFC PATCH 09/15] cxl/core/port: Add attrs for size and volatility
Date: Wed, 13 Apr 2022 11:37:14 -0700
Message-Id: <20220413183720.2444089-10-ben.widawsky@intel.com>
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

Endpoint decoders have the decoder-unique properties of having their
range being constrained by the media they're a part of, and, having a
concrete need to disambiguate between volatile and persistent capacity
(due to partitioning). As part of region programming, these decoders
will be required to be pre-configured, ie, have the size and volatility
set.

Endpoint decoders must consider two different address spaces for address
allocation. Sysram will need to be mapped for use of this memory if not
set up in the EFI memory map. Additionally, the CXL device itself has
it's own address space domain which requires allocation and management.
Device address space is managed with a simple allocator and host
physical address space is managed by the region driver/core.

/sys/bus/cxl/devices/decoder3.0
├── devtype
├── interleave_granularity
├── interleave_ways
├── locked
├── modalias
├── size
├── start
├── subsystem -> ../../../../../../../bus/cxl
├── target_type
├── uevent
└── volatile

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  13 ++-
 drivers/cxl/Kconfig                     |   3 +-
 drivers/cxl/core/port.c                 | 145 +++++++++++++++++++++++-
 drivers/cxl/cxl.h                       |   6 +
 4 files changed, 163 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 7c2b846521f3..01fee09b8473 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -117,7 +117,9 @@ Description:
 		range is fixed. For decoders of devtype "cxl_decoder_switch" the
 		address is bounded by the decode range of the cxl_port ancestor
 		of the decoder's cxl_port, and dynamically updates based on the
-		active memory regions in that address space.
+		active memory regions in that address space. For decoders of
+		devtype "cxl_decoder_endpoint", size is a mutable value which
+		carves our space from the physical media.
 
 What:		/sys/bus/cxl/devices/decoderX.Y/locked
 Date:		June, 2021
@@ -163,3 +165,12 @@ Description:
 		memory (type-3). The 'target_type' attribute indicates the
 		current setting which may dynamically change based on what
 		memory regions are activated in this decode hierarchy.
+
+What:		/sys/bus/cxl/devices/decoderX.Y/volatile
+Date:		March, 2022
+KernelVersion:	v5.19
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		Provide a knob to set/get whether the desired media is volatile
+		or persistent. This applies only to decoders of devtype
+		"cxl_decoder_endpoint",
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index b88ab956bb7c..8796fd4b22bc 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -95,7 +95,8 @@ config CXL_MEM
 	  If unsure say 'm'.
 
 config CXL_PORT
-	default CXL_BUS
 	tristate
+	default CXL_BUS
+	select DEVICE_PRIVATE
 
 endif
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 9ef8d69dbfa5..bdafdec80d98 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -4,6 +4,7 @@
 #include <linux/workqueue.h>
 #include <linux/genalloc.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
@@ -80,7 +81,7 @@ static ssize_t start_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_ADMIN_RO(start);
 
 static ssize_t size_show(struct device *dev, struct device_attribute *attr,
-			char *buf)
+			 char *buf)
 {
 	struct cxl_decoder *cxld = to_cxl_decoder(dev);
 
@@ -93,7 +94,144 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 		return sysfs_emit(buf, "%#llx\n", range_len(&cxld->range));
 	}
 }
-static DEVICE_ATTR_RO(size);
+
+static struct cxl_endpoint_decoder *
+get_prev_decoder(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
+	struct device *cxldd;
+	char *name;
+
+	if (cxled->base.id == 0)
+		return NULL;
+
+	name = kasprintf(GFP_KERNEL, "decoder%u.%u", port->id, cxled->base.id);
+	if (!name)
+		return ERR_PTR(-ENOMEM);
+
+	cxldd = device_find_child_by_name(&port->dev, name);
+	kfree(name);
+	if (cxldd) {
+		struct cxl_decoder *cxld = to_cxl_decoder(cxldd);
+
+		if (dev_WARN_ONCE(&port->dev,
+				  (cxld->flags & CXL_DECODER_F_ENABLE) == 0,
+				  "%s should be enabled\n",
+				  dev_name(&cxld->dev)))
+			return NULL;
+		return to_cxl_endpoint_decoder(cxld);
+	}
+
+	return NULL;
+}
+
+static ssize_t size_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+	struct cxl_port *port = to_cxl_port(cxled->base.dev.parent);
+	struct cxl_endpoint_decoder *prev = get_prev_decoder(cxled);
+	u64 size, dpa_base = 0;
+	int rc;
+
+	rc = kstrtou64(buf, 0, &size);
+	if (rc)
+		return rc;
+
+	if (size % SZ_256M)
+		return -EINVAL;
+
+	rc = mutex_lock_interruptible(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	/* No change */
+	if (range_len(&cxled->drange) == size)
+		goto out;
+
+	rc = mutex_lock_interruptible(&port->media_lock);
+	if (rc)
+		goto out;
+
+	/* Extent was previously set */
+	if (port->last_cxled == cxled) {
+		if (size == range_len(&cxled->drange)) {
+			mutex_unlock(&port->media_lock);
+			goto out;
+		}
+
+		if (!size) {
+			dev_dbg(dev,
+				"freeing previous reservation %#llx-%#llx\n",
+				cxled->drange.start, cxled->drange.end);
+			port->last_cxled = prev;
+			mutex_unlock(&port->media_lock);
+			goto out;
+		}
+	}
+
+	if (prev)
+		dpa_base = port->last_cxled->drange.end + 1;
+
+	if ((dpa_base + size) > port->capacity)
+		rc = -ENOSPC;
+	else
+		port->last_cxled = cxled;
+
+	mutex_unlock(&port->media_lock);
+	if (rc)
+		goto out;
+
+	cxled->drange = (struct range) {
+		.start = dpa_base,
+		.end = dpa_base + size - 1
+	};
+
+	dev_dbg(dev, "Allocated %#llx-%#llx from media\n", cxled->drange.start,
+		cxled->drange.end);
+
+out:
+	mutex_unlock(&cxled->res_lock);
+	return rc ? rc : len;
+}
+static DEVICE_ATTR_RW(size);
+
+static ssize_t volatile_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+
+	return sysfs_emit(buf, "%u\n", cxled->volatil);
+}
+
+static ssize_t volatile_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(cxld);
+	bool p;
+	int rc;
+
+	rc = kstrtobool(buf, &p);
+	if (rc)
+		return rc;
+
+	rc = mutex_lock_interruptible(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	if (range_len(&cxled->drange) > 0)
+		rc = -EBUSY;
+	mutex_unlock(&cxled->res_lock);
+	if (rc)
+		return rc;
+
+	cxled->volatil = p;
+	return len;
+}
+static DEVICE_ATTR_RW(volatile);
 
 #define CXL_DECODER_FLAG_ATTR(name, flag)                            \
 static ssize_t name##_show(struct device *dev,                       \
@@ -211,6 +349,7 @@ static const struct attribute_group *cxl_decoder_root_attribute_groups[] = {
 
 static struct attribute *cxl_decoder_endpoint_attrs[] = {
 	&dev_attr_target_type.attr,
+	&dev_attr_volatile.attr,
 	NULL,
 };
 
@@ -413,6 +552,7 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	ida_init(&port->decoder_ida);
 	INIT_LIST_HEAD(&port->dports);
 	INIT_LIST_HEAD(&port->endpoints);
+	mutex_init(&port->media_lock);
 
 	device_initialize(dev);
 	device_set_pm_not_required(dev);
@@ -1191,6 +1331,7 @@ static struct cxl_decoder *__cxl_decoder_alloc(struct cxl_port *port,
 		cxled = kzalloc(sizeof(*cxled), GFP_KERNEL);
 		if (!cxled)
 			return NULL;
+		mutex_init(&cxled->res_lock);
 		cxld = &cxled->base;
 	} else if (is_cxl_root(port)) {
 		struct cxl_root_decoder *cxlrd;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 33f8a55f2f84..07df13f05d3d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -230,11 +230,15 @@ struct cxl_decoder {
  * @base: Base class decoder
  * @drange: Device physical address space this decoder is using
  * @skip: The skip count as specified in the CXL specification.
+ * @res_lock: Synchronize device's resource usage
+ * @volatil: Configuration param. Decoder target is non-persistent mem
  */
 struct cxl_endpoint_decoder {
 	struct cxl_decoder base;
 	struct range drange;
 	u64 skip;
+	struct mutex res_lock; /* sync access to decoder's resource */
+	bool volatil;
 };
 
 /**
@@ -321,6 +325,7 @@ struct cxl_nvdimm {
  * @pmem_offset: Partition dividing volatile, [0, pmem_offset -1 ], and persistent
  *		 [pmem_offset, capacity - 1] addresses.
  * @last_cxled: Last active decoder doing decode (endpoint only)
+ * @media_lock: Synchronizes use of allocation of media (endpoint only)
  */
 struct cxl_port {
 	struct device dev;
@@ -336,6 +341,7 @@ struct cxl_port {
 	u64 capacity;
 	u64 pmem_offset;
 	struct cxl_endpoint_decoder *last_cxled;
+	struct mutex media_lock; /* sync access to media allocator */
 };
 
 /**
-- 
2.35.1

