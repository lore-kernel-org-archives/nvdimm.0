Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649793D94;
	Wed, 13 Apr 2022 18:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649875098; x=1681411098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aeZKwA6KXw/WgR7UJB3SvHnRt3gEatPvEZCT9hDGrhA=;
  b=Sr9tSRbhRV7XCYYvaGkUF0LMugeusSdJM0K3rbWIpjRqHyit0z5NTchp
   YkOR0MTRLqi/yTWIxR3WPUDYmO/S25t09ZgDzIKN83ZZXVm1uyNRAVT9H
   AOLm6ttc5vo8zDa79qCJ9H0mxJU2wJQCZnkvTjt1mAg82+Wp47SK7oJkx
   qTOdaQB0w5rgpcd41NJnIhEwIuqxejn4GZFfLmAQXKbzRNpxgJZK+L5mN
   +z02NdK20h15ex101kU5I4F+rNlCr839vGyTRyjY831ntPAeFkiSu1CmY
   9FmKLw3G0UxYSr3qRvg4It4ImTwKfMt1IPtFT5wzfREcAZBN7NIMqK4J8
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="244631866"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="244631866"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="725013640"
Received: from sushobhi-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.131.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 11:37:52 -0700
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
Subject: [RFC PATCH 15/15] cxl/region: Introduce a cxl_region driver
Date: Wed, 13 Apr 2022 11:37:20 -0700
Message-Id: <20220413183720.2444089-16-ben.widawsky@intel.com>
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

The cxl_region driver is responsible for managing the HDM decoder
programming in the CXL topology. Once a region is created it must be
configured and bound to the driver in order to activate it.

The following is a sample of how such controls might work:

region=$(cat /sys/bus/cxl/devices/decoder0.0/create_pmem_region)
echo $region > /sys/bus/cxl/devices/decoder0.0/create_pmem_region
echo 256 > /sys/bus/cxl/devices/decoder0.0/region0/interleave_granularity
echo 2 > /sys/bus/cxl/devices/decoder0.0/region0/interleave_ways
echo $((256<<20)) > /sys/bus/cxl/devices/decoder0.0/region0/size
echo decoder3.0 > /sys/bus/cxl/devices/decoder0.0/region0/target0
echo decoder4.0 > /sys/bus/cxl/devices/decoder0.0/region0/target1
echo region0 > /sys/bus/cxl/drivers/cxl_region/bind

Note that the above is not complete as the endpoint decoders also need
configuration.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 .../driver-api/cxl/memory-devices.rst         |   3 +
 drivers/cxl/Kconfig                           |   4 +
 drivers/cxl/Makefile                          |   2 +
 drivers/cxl/core/core.h                       |   1 +
 drivers/cxl/core/port.c                       |   2 +
 drivers/cxl/core/region.c                     |   2 +-
 drivers/cxl/cxl.h                             |   6 +
 drivers/cxl/region.c                          | 333 ++++++++++++++++++
 8 files changed, 352 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cxl/region.c

diff --git a/Documentation/driver-api/cxl/memory-devices.rst b/Documentation/driver-api/cxl/memory-devices.rst
index 66ddc58a21b1..8cb4dece5b17 100644
--- a/Documentation/driver-api/cxl/memory-devices.rst
+++ b/Documentation/driver-api/cxl/memory-devices.rst
@@ -364,6 +364,9 @@ CXL Core
 
 CXL Regions
 -----------
+.. kernel-doc:: drivers/cxl/region.c
+   :doc: cxl region
+
 .. kernel-doc:: drivers/cxl/region.h
    :identifiers:
 
diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index 7ce86eee8bda..d5c41c96971f 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -104,4 +104,8 @@ config CXL_REGION
 	default CXL_BUS
 	select MEMREGION
 
+config CXL_REGION
+	default CXL_PORT
+	tristate
+
 endif
diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index ce267ef11d93..02a4776e7ab9 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -5,9 +5,11 @@ obj-$(CONFIG_CXL_MEM) += cxl_mem.o
 obj-$(CONFIG_CXL_ACPI) += cxl_acpi.o
 obj-$(CONFIG_CXL_PMEM) += cxl_pmem.o
 obj-$(CONFIG_CXL_PORT) += cxl_port.o
+obj-$(CONFIG_CXL_REGION) += cxl_region.o
 
 cxl_mem-y := mem.o
 cxl_pci-y := pci.o
 cxl_acpi-y := acpi.o
 cxl_pmem-y := pmem.o
 cxl_port-y := port.o
+cxl_region-y := region.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index a507a2502127..8871a3385604 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -6,6 +6,7 @@
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
+extern const struct device_type cxl_region_type;
 
 extern struct attribute_group cxl_base_attribute_group;
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 19cf1fd16118..f22579cd031d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -53,6 +53,8 @@ static int cxl_device_id(struct device *dev)
 	}
 	if (is_cxl_memdev(dev))
 		return CXL_DEVICE_MEMORY_EXPANDER;
+	if (dev->type == &cxl_region_type)
+		return CXL_DEVICE_REGION;
 	return 0;
 }
 
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 4766d897f4bf..1c28d9623cb8 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -464,7 +464,7 @@ static const struct attribute_group *region_groups[] = {
 	NULL,
 };
 
-static const struct device_type cxl_region_type = {
+const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
 	.groups = region_groups
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index db69dfa16f71..184af920113d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -212,6 +212,10 @@ void __iomem *devm_cxl_iomap_block(struct device *dev, resource_size_t addr,
 #define CXL_DECODER_F_ENABLE    BIT(5)
 #define CXL_DECODER_F_MASK  GENMASK(5, 0)
 
+#define cxl_is_pmem_t3(flags)                                                  \
+	(((flags) & (CXL_DECODER_F_TYPE3 | CXL_DECODER_F_PMEM)) ==             \
+	 (CXL_DECODER_F_TYPE3 | CXL_DECODER_F_PMEM))
+
 enum cxl_decoder_type {
        CXL_DECODER_ACCELERATOR = 2,
        CXL_DECODER_EXPANDER = 3,
@@ -440,6 +444,7 @@ struct cxl_dport *devm_cxl_add_dport(struct cxl_port *port,
 				     resource_size_t component_reg_phys);
 struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
 					const struct device *dev);
+struct cxl_port *ep_find_cxl_port(struct cxl_memdev *cxlmd, unsigned int depth);
 
 struct cxl_decoder *to_cxl_decoder(struct device *dev);
 bool is_root_decoder(struct device *dev);
@@ -501,6 +506,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 #define CXL_DEVICE_PORT			3
 #define CXL_DEVICE_ROOT			4
 #define CXL_DEVICE_MEMORY_EXPANDER	5
+#define CXL_DEVICE_REGION		6
 
 #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
 #define CXL_MODALIAS_FMT "cxl:t%d"
diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
new file mode 100644
index 000000000000..f5de640623c0
--- /dev/null
+++ b/drivers/cxl/region.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2021 Intel Corporation. All rights reserved. */
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include "cxlmem.h"
+#include "region.h"
+#include "cxl.h"
+
+/**
+ * DOC: cxl region
+ *
+ * This module implements a region driver that is capable of programming CXL
+ * hardware to setup regions.
+ *
+ * A CXL region encompasses a chunk of host physical address space that may be
+ * consumed by a single device (x1 interleave aka linear) or across multiple
+ * devices (xN interleaved). The region driver has the following
+ * responsibilities:
+ *
+ * * Walk topology to obtain decoder resources for region configuration.
+ * * Program decoder resources based on region configuration.
+ * * Bridge CXL regions to LIBNVDIMM
+ * * Initiates reading and configuring LSA regions
+ * * Enumerates regions created by BIOS (typically volatile)
+ */
+
+#define for_each_cxled(cxled, idx, cxlr) \
+	for (idx = 0; idx < cxlr->interleave_ways && (cxled = cxlr->targets[idx]); idx++)
+
+static struct cxl_decoder *rootd_from_region(const struct cxl_region *cxlr)
+{
+	struct device *d = cxlr->dev.parent;
+
+	if (WARN_ONCE(!is_root_decoder(d),
+		      "Corrupt topology for root region\n"))
+		return NULL;
+
+	return to_cxl_decoder(d);
+}
+
+static struct cxl_port *get_hostbridge(const struct cxl_memdev *ep)
+{
+	struct cxl_port *port = dev_get_drvdata(&ep->dev);
+
+	while (!is_cxl_root(port)) {
+		port = to_cxl_port(port->dev.parent);
+		if (port->depth == 1)
+			return port;
+	}
+
+	BUG();
+	return NULL;
+}
+
+static struct cxl_port *get_root_decoder(const struct cxl_memdev *endpoint)
+{
+	struct cxl_port *hostbridge = get_hostbridge(endpoint);
+
+	if (hostbridge)
+		return to_cxl_port(hostbridge->dev.parent);
+
+	return NULL;
+}
+
+/**
+ * validate_region() - Check is region is reasonably configured
+ * @cxlr: The region to check
+ *
+ * Determination as to whether or not a region can possibly be configured is
+ * described in CXL Memory Device SW Guide. In order to implement the algorithms
+ * described there, certain more basic configuration parameters must first need
+ * to be validated. That is accomplished by this function.
+ *
+ * Returns 0 if the region is reasonably configured, else returns a negative
+ * error code.
+ */
+static int validate_region(const struct cxl_region *cxlr)
+{
+	const struct cxl_decoder *rootd = rootd_from_region(cxlr);
+	const int gran = cxlr->interleave_granularity;
+	const int ways = cxlr->interleave_ways;
+	struct cxl_endpoint_decoder *cxled;
+	int i;
+
+	/*
+	 * Interleave attributes should be caught by later math, but it's
+	 * easiest to find those issues here, now.
+	 */
+	if (!cxl_region_granularity_valid(rootd, gran)) {
+		dev_dbg(&cxlr->dev, "Invalid interleave granularity\n");
+		return -ENXIO;
+	}
+
+	if (!cxl_region_ways_valid(rootd, ways, gran)) {
+		dev_dbg(&cxlr->dev, "Invalid number of ways\n");
+		return -ENXIO;
+	}
+
+	if (!cxl_region_size_valid(range_len(&cxlr->range), ways)) {
+		dev_dbg(&cxlr->dev, "Invalid size. Must be multiple of %uM\n",
+			256 * ways);
+		return -ENXIO;
+	}
+
+	for_each_cxled(cxled, i, cxlr) {
+		struct cxl_memdev *cxlmd;
+		struct cxl_port *port;
+
+		port = to_cxl_port(cxled->base.dev.parent);
+		cxlmd = to_cxl_memdev(port->uport);
+		if (!cxlmd->dev.driver) {
+			dev_dbg(&cxlr->dev, "%s isn't CXL.mem capable\n",
+				dev_name(&cxled->base.dev));
+			return -ENODEV;
+		}
+
+		if ((range_len(&cxlr->range) / ways) !=
+		    range_len(&cxled->drange)) {
+			dev_dbg(&cxlr->dev, "%s is the wrong size\n",
+				dev_name(&cxled->base.dev));
+			return -ENXIO;
+		}
+	}
+
+	if (i != cxlr->interleave_ways) {
+		dev_dbg(&cxlr->dev, "Missing memory device target%u", i);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+/**
+ * find_cdat_dsmas() - Find a valid DSMAS for the region
+ * @cxlr: The region
+ */
+static bool find_cdat_dsmas(const struct cxl_region *cxlr)
+{
+	return true;
+}
+
+/**
+ * qtg_match() - Does this root decoder have desirable QTG for the endpoint
+ * @rootd: The root decoder for the region
+ *
+ * Prior to calling this function, the caller should verify that all endpoints
+ * in the region have the same QTG ID.
+ *
+ * Returns true if the QTG ID of the root decoder matches the endpoint
+ */
+static bool qtg_match(const struct cxl_decoder *rootd)
+{
+	/* TODO: */
+	return true;
+}
+
+/**
+ * region_xhb_config_valid() - determine cross host bridge validity
+ * @cxlr: The region being programmed
+ * @rootd: The root decoder to check against
+ *
+ * The algorithm is outlined in 2.13.14 "Verify XHB configuration sequence" of
+ * the CXL Memory Device SW Guide (Rev1p0).
+ *
+ * Returns true if the configuration is valid.
+ */
+static bool region_xhb_config_valid(const struct cxl_region *cxlr,
+				    const struct cxl_decoder *rootd)
+{
+	/* TODO: */
+	return true;
+}
+
+/**
+ * region_hb_rp_config_valid() - determine root port ordering is correct
+ * @cxlr: Region to validate
+ * @rootd: root decoder for this @cxlr
+ *
+ * The algorithm is outlined in 2.13.15 "Verify HB root port configuration
+ * sequence" of the CXL Memory Device SW Guide (Rev1p0).
+ *
+ * Returns true if the configuration is valid.
+ */
+static bool region_hb_rp_config_valid(const struct cxl_region *cxlr,
+				      const struct cxl_decoder *rootd)
+{
+	/* TODO: */
+	return true;
+}
+
+/**
+ * rootd_contains() - determine if this region can exist in the root decoder
+ * @rootd: root decoder that potentially decodes to this region
+ * @cxlr: region to be routed by the @rootd
+ */
+static bool rootd_contains(const struct cxl_region *cxlr,
+			   const struct cxl_decoder *rootd)
+{
+	/* TODO: */
+	return true;
+}
+
+static bool rootd_valid(const struct cxl_region *cxlr,
+			const struct cxl_decoder *rootd)
+{
+	if (!qtg_match(rootd))
+		return false;
+
+	if (!cxl_is_pmem_t3(rootd->flags))
+		return false;
+
+	if (!region_xhb_config_valid(cxlr, rootd))
+		return false;
+
+	if (!region_hb_rp_config_valid(cxlr, rootd))
+		return false;
+
+	if (!rootd_contains(cxlr, rootd))
+		return false;
+
+	return true;
+}
+
+struct rootd_context {
+	const struct cxl_region *cxlr;
+	struct cxl_port *hbs[CXL_DECODER_MAX_INTERLEAVE];
+	int count;
+};
+
+static int rootd_match(struct device *dev, void *data)
+{
+	struct rootd_context *ctx = (struct rootd_context *)data;
+	const struct cxl_region *cxlr = ctx->cxlr;
+
+	if (!is_root_decoder(dev))
+		return 0;
+
+	return !!rootd_valid(cxlr, to_cxl_decoder(dev));
+}
+
+/*
+ * This is a roughly equivalent implementation to "Figure 45 - High-level
+ * sequence: Finding CFMWS for region" from the CXL Memory Device SW Guide
+ * Rev1p0.
+ */
+static struct cxl_decoder *find_rootd(const struct cxl_region *cxlr,
+				      const struct cxl_port *root)
+{
+	struct rootd_context ctx;
+	struct device *ret;
+
+	ctx.cxlr = cxlr;
+
+	ret = device_find_child((struct device *)&root->dev, &ctx, rootd_match);
+	if (ret)
+		return to_cxl_decoder(ret);
+
+	return NULL;
+}
+
+static int bind_region(const struct cxl_region *cxlr)
+{
+	struct cxl_endpoint_decoder *cxled;
+	int i;
+	/* TODO: */
+
+	/*
+	 * Natural decoder teardown can occur at this point, put the
+	 * reference which was taken when the target was set.
+	 */
+	for_each_cxled(cxled, i, cxlr)
+		put_device(&cxled->base.dev);
+
+	WARN_ON(i != cxlr->interleave_ways);
+	return 0;
+}
+
+static int cxl_region_probe(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_port *root_port, *ep_port;
+	struct cxl_decoder *rootd, *ours;
+	struct cxl_memdev *cxlmd;
+	int ret;
+
+	if (uuid_is_null(&cxlr->uuid))
+		uuid_gen(&cxlr->uuid);
+
+	/* TODO: What about volatile, and LSA generated regions? */
+
+	ret = validate_region(cxlr);
+	if (ret)
+		return ret;
+
+	if (!find_cdat_dsmas(cxlr))
+		return -ENXIO;
+
+	rootd = rootd_from_region(cxlr);
+	if (!rootd) {
+		dev_err(dev, "Couldn't find root decoder\n");
+		return -ENXIO;
+	}
+
+	if (!rootd_valid(cxlr, rootd)) {
+		dev_err(dev, "Picked invalid rootd\n");
+		return -ENXIO;
+	}
+
+	ep_port = to_cxl_port(cxlr->targets[0]->base.dev.parent);
+	cxlmd = to_cxl_memdev(ep_port->uport);
+	root_port = get_root_decoder(cxlmd);
+	ours = find_rootd(cxlr, root_port);
+	if (ours != rootd)
+		dev_dbg(dev, "Picked different rootd %s %s\n",
+			dev_name(&rootd->dev), dev_name(&ours->dev));
+	if (ours)
+		put_device(&ours->dev);
+
+	return bind_region(cxlr);
+}
+
+static struct cxl_driver cxl_region_driver = {
+	.name = "cxl_region",
+	.probe = cxl_region_probe,
+	.id = CXL_DEVICE_REGION,
+};
+module_cxl_driver(cxl_region_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(CXL);
+MODULE_ALIAS_CXL(CXL_DEVICE_REGION);
-- 
2.35.1

