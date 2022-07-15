Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970B7460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843517; x=1689379517;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pDhRf3qBnQEd9BweVVOXaxp4SJT1O6WGOvb5VpLfORo=;
  b=SDGkp6URqdb5kbBieH89YbrRDimsb5D67eoAaUGNviLdltIq07X/wlM0
   tnodyeHWG8KDMoS0kT2IitlXYUk4nrXy41A5PTr62fHC53sBZfVC8v5hf
   U0tL+dIPeObH9Htom7QtaIWRMAi4/ioK6Sj/nXk/BfhWIAKNrawXif3QD
   vTFfPy93Bg+XNTemybElX/MjfQrYMzCy4QHx1oGTkuvX/pCkuIKmomQCG
   vR1tqGe8QPee9iNA0+diCWaMLUagoGor2BUJd62JKzHyhxhk18LryFoaY
   /SqoLTJJbQO4cRnP0HhiDRsMx+aCFAkkp3e1KhSJslMPHs3X3RAUGex6t
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268688416"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="268688416"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="685766925"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:03:10 -0700
Subject: [PATCH v2 26/28] cxl/region: Add region driver boiler plate
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <bwidawsk@kernel.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, hch@lst.de,
 nvdimm@lists.linux.dev, linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:03:09 -0700
Message-ID: <165784338963.1758207.3908994719897882778.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL region driver is responsible for routing fully formed CXL
regions to one of libnvdimm, for persistent memory regions, device-dax
for volatile memory regions, or just act as an enumeration placeholder
if the region was setup and configuration locked by platform firmware.
In the platform-firmware-setup case the expectation is that region is
already accounted in the system memory map, i.e. already enabled as
"System RAM".

For now, just attach to CXL regions in the CXL_CONFIG_COMMIT state, and
take no further action.

Given this driver is just a small / simple router, include it in the
core rather than its own module.

Co-developed-by: Ben Widawsky <bwidawsk@kernel.org>
Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20220624041950.559155-18-dan.j.williams@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core/core.h   |   12 ++++++++++++
 drivers/cxl/core/port.c   |    9 +++++++++
 drivers/cxl/core/region.c |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h         |    1 +
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index fcf14b8a3c87..391aadf9e7fa 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -13,14 +13,26 @@ extern struct attribute_group cxl_base_attribute_group;
 extern struct device_attribute dev_attr_create_pmem_region;
 extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
+extern const struct device_type cxl_region_type;
 void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
 #define CXL_REGION_ATTR(x) (&dev_attr_##x.attr)
+#define CXL_REGION_TYPE(x) (&cxl_region_type)
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
+int cxl_region_init(void);
+void cxl_region_exit(void);
 #else
 static inline void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled)
 {
 }
+static inline int cxl_region_init(void)
+{
+	return 0;
+}
+static inline void cxl_region_exit(void)
+{
+}
 #define CXL_REGION_ATTR(x) NULL
+#define CXL_REGION_TYPE(x) NULL
 #define SET_CXL_REGION_ATTR(x)
 #endif
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 7ab9a98c5d4f..194003525397 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -51,6 +51,8 @@ static int cxl_device_id(struct device *dev)
 	}
 	if (is_cxl_memdev(dev))
 		return CXL_DEVICE_MEMORY_EXPANDER;
+	if (dev->type == CXL_REGION_TYPE())
+		return CXL_DEVICE_REGION;
 	return 0;
 }
 
@@ -1864,8 +1866,14 @@ static __init int cxl_core_init(void)
 	if (rc)
 		goto err_bus;
 
+	rc = cxl_region_init();
+	if (rc)
+		goto err_region;
+
 	return 0;
 
+err_region:
+	bus_unregister(&cxl_bus_type);
 err_bus:
 	destroy_workqueue(cxl_bus_wq);
 err_wq:
@@ -1875,6 +1883,7 @@ static __init int cxl_core_init(void)
 
 static void cxl_core_exit(void)
 {
+	cxl_region_exit();
 	bus_unregister(&cxl_bus_type);
 	destroy_workqueue(cxl_bus_wq);
 	cxl_memdev_exit();
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index de794344d964..20871bdb6858 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1444,7 +1444,7 @@ static void cxl_region_release(struct device *dev)
 	kfree(cxlr);
 }
 
-static const struct device_type cxl_region_type = {
+const struct device_type cxl_region_type = {
 	.name = "cxl_region",
 	.release = cxl_region_release,
 	.groups = region_groups
@@ -1644,4 +1644,47 @@ static ssize_t delete_region_store(struct device *dev,
 }
 DEVICE_ATTR_WO(delete_region);
 
+static int cxl_region_probe(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	struct cxl_region_params *p = &cxlr->params;
+	int rc;
+
+	rc = down_read_interruptible(&cxl_region_rwsem);
+	if (rc) {
+		dev_dbg(&cxlr->dev, "probe interrupted\n");
+		return rc;
+	}
+
+	if (p->state < CXL_CONFIG_COMMIT) {
+		dev_dbg(&cxlr->dev, "config state: %d\n", p->state);
+		rc = -ENXIO;
+	}
+
+	/*
+	 * From this point on any path that changes the region's state away from
+	 * CXL_CONFIG_COMMIT is also responsible for releasing the driver.
+	 */
+	up_read(&cxl_region_rwsem);
+
+	return rc;
+}
+
+static struct cxl_driver cxl_region_driver = {
+	.name = "cxl_region",
+	.probe = cxl_region_probe,
+	.id = CXL_DEVICE_REGION,
+};
+
+int cxl_region_init(void)
+{
+	return cxl_driver_register(&cxl_region_driver);
+}
+
+void cxl_region_exit(void)
+{
+	cxl_driver_unregister(&cxl_region_driver);
+}
+
 MODULE_IMPORT_NS(CXL);
+MODULE_ALIAS_CXL(CXL_DEVICE_REGION);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index a51709613c43..9aedd471193a 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -592,6 +592,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 #define CXL_DEVICE_PORT			3
 #define CXL_DEVICE_ROOT			4
 #define CXL_DEVICE_MEMORY_EXPANDER	5
+#define CXL_DEVICE_REGION		6
 
 #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
 #define CXL_MODALIAS_FMT "cxl:t%d"

