Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D853FC4
	for <nvdimm@lists.linux.dev>; Tue, 14 Sep 2021 19:08:41 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="283105339"
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="283105339"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 12:08:41 -0700
X-IronPort-AV: E=Sophos;i="5.85,292,1624345200"; 
   d="scan'208";a="481979128"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 12:08:41 -0700
Subject: [PATCH v5 16/21] cxl/pmem: Add support for multiple nvdimm-bridge
 objects
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com
Date: Tue, 14 Sep 2021 12:08:40 -0700
Message-ID: <163164647007.2831228.2150246954620721526.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163116437978.2460985.6298243237502084824.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116437978.2460985.6298243237502084824.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for a mocked unit test environment for CXL objects, allow
for multiple unique nvdimm-bridge objects.

For now, just allow multiple bridges to be registered. Later, when there
are multiple present, further updates are needed to
cxl_find_nvdimm_bridge() to identify which bridge is associated with
which CXL hierarchy for nvdimm registration.

Note that this does change the kernel device-name for the bridge object.
User space should not have any attachment to the device name at this
point as it is still early days in the CXL driver development.

Acked-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v4:

- rebase on "[PATCH v5 15/21] cxl/pmem: Translate NVDIMM label commands
  to CXL label commands"

 drivers/cxl/core/pmem.c |   32 +++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h       |    2 ++
 drivers/cxl/pmem.c      |   15 ---------------
 3 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
index d24570f5b8ba..9e56be3994f1 100644
--- a/drivers/cxl/core/pmem.c
+++ b/drivers/cxl/core/pmem.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 Intel Corporation. */
 #include <linux/device.h>
 #include <linux/slab.h>
+#include <linux/idr.h>
 #include <cxlmem.h>
 #include <cxl.h>
 #include "core.h"
@@ -20,10 +21,13 @@
  * operations, for example, namespace label access commands.
  */
 
+static DEFINE_IDA(cxl_nvdimm_bridge_ida);
+
 static void cxl_nvdimm_bridge_release(struct device *dev)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb = to_cxl_nvdimm_bridge(dev);
 
+	ida_free(&cxl_nvdimm_bridge_ida, cxl_nvb->id);
 	kfree(cxl_nvb);
 }
 
@@ -47,16 +51,38 @@ struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_cxl_nvdimm_bridge);
 
+static int match_nvdimm_bridge(struct device *dev, const void *data)
+{
+	return dev->type == &cxl_nvdimm_bridge_type;
+}
+
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
+	if (!dev)
+		return NULL;
+	return to_cxl_nvdimm_bridge(dev);
+}
+EXPORT_SYMBOL_GPL(cxl_find_nvdimm_bridge);
+
 static struct cxl_nvdimm_bridge *
 cxl_nvdimm_bridge_alloc(struct cxl_port *port)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb;
 	struct device *dev;
+	int rc;
 
 	cxl_nvb = kzalloc(sizeof(*cxl_nvb), GFP_KERNEL);
 	if (!cxl_nvb)
 		return ERR_PTR(-ENOMEM);
 
+	rc = ida_alloc(&cxl_nvdimm_bridge_ida, GFP_KERNEL);
+	if (rc < 0)
+		goto err;
+	cxl_nvb->id = rc;
+
 	dev = &cxl_nvb->dev;
 	cxl_nvb->port = port;
 	cxl_nvb->state = CXL_NVB_NEW;
@@ -67,6 +93,10 @@ cxl_nvdimm_bridge_alloc(struct cxl_port *port)
 	dev->type = &cxl_nvdimm_bridge_type;
 
 	return cxl_nvb;
+
+err:
+	kfree(cxl_nvb);
+	return ERR_PTR(rc);
 }
 
 static void unregister_nvb(void *_cxl_nvb)
@@ -119,7 +149,7 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 		return cxl_nvb;
 
 	dev = &cxl_nvb->dev;
-	rc = dev_set_name(dev, "nvdimm-bridge");
+	rc = dev_set_name(dev, "nvdimm-bridge%d", cxl_nvb->id);
 	if (rc)
 		goto err;
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 53927f9fa77e..1b2e816e061e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -211,6 +211,7 @@ enum cxl_nvdimm_brige_state {
 };
 
 struct cxl_nvdimm_bridge {
+	int id;
 	struct device dev;
 	struct cxl_port *port;
 	struct nvdimm_bus *nvdimm_bus;
@@ -323,4 +324,5 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
 bool is_cxl_nvdimm(struct device *dev);
 int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
+struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void);
 #endif /* __CXL_H__ */
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index bc1466b0e999..5ccf9aa6b3ae 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -29,21 +29,6 @@ static void unregister_nvdimm(void *nvdimm)
 	nvdimm_delete(nvdimm);
 }
 
-static int match_nvdimm_bridge(struct device *dev, const void *data)
-{
-	return strcmp(dev_name(dev), "nvdimm-bridge") == 0;
-}
-
-static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
-	if (!dev)
-		return NULL;
-	return to_cxl_nvdimm_bridge(dev);
-}
-
 static int cxl_nvdimm_probe(struct device *dev)
 {
 	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);

