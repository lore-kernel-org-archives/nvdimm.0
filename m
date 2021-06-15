Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442E16D13
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 23:18:35 +0000 (UTC)
IronPort-SDR: 7ZCdogSQr6HYqiEykYxYFSJsJNe/MGlvYcD2xlGy+MtmcELHMMuzS6Ft5h0visxSkNKVatTOPG
 Kut/woiFTGXQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="193393673"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="193393673"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:34 -0700
IronPort-SDR: pQZPL63gXVJ5iOi4BsOiPLxd+N5SL/e/CzgXIyTKBh+uuOaE2gpKbd610Shu0/crQr0XNiJoT4
 66gB/aFdqjfw==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="553839481"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:33 -0700
Subject: [PATCH v2 5/5] cxl/pmem: Register 'pmem' / cxl_nvdimm devices
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 15 Jun 2021 16:18:33 -0700
Message-ID: <162379911364.2993820.5684144324426888810.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162379908663.2993820.16543025953842049041.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

While a memX device on /sys/bus/cxl represents a CXL memory expander
control interface, a pmemX device represents the persistent memory
sub-functionality. It bridges the CXL subystem to the libnvdimm nmemX
control interface.

With this skeleton ndctl can now see persistent memory devices on a
"CXL" bus. Later patches add support for translating libnvdimm native
commands to CXL commands.

# ndctl list -BDiu -b CXL
{
  "provider":"CXL",
  "dev":"ndbus1",
  "dimms":[
    {
      "dev":"nmem1",
      "state":"disabled"
    },
    {
      "dev":"nmem0",
      "state":"disabled"
    }
  ]
}

Given nvdimm_bus_unregister() removes all devices on an ndbus0 the
cxl_pmem infrastructure needs to arrange ->remove() to be triggered on
cxl_nvdimm devices to keep their enabled state synchronized with the
registration state of their corresponding device on the nvdimm_bus. In
other words, always arrange for cxl_nvdimm_driver.remove() to unregister
nvdimms from an nvdimm_bus ahead of the bus being unregistered.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/162336398605.2462439.17422037666825492593.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core.c |   86 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h  |   12 +++++-
 drivers/cxl/mem.h  |    1 
 drivers/cxl/pci.c  |   23 ++++++++---
 drivers/cxl/pmem.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 214 insertions(+), 16 deletions(-)

diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
index aaffb390d168..a2e4d54fc7bc 100644
--- a/drivers/cxl/core.c
+++ b/drivers/cxl/core.c
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include "cxl.h"
+#include "mem.h"
 
 /**
  * DOC: cxl core
@@ -730,6 +731,89 @@ struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 }
 EXPORT_SYMBOL_GPL(devm_cxl_add_nvdimm_bridge);
 
+static void cxl_nvdimm_release(struct device *dev)
+{
+	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
+
+	kfree(cxl_nvd);
+}
+
+static const struct attribute_group *cxl_nvdimm_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	NULL,
+};
+
+static const struct device_type cxl_nvdimm_type = {
+	.name = "cxl_nvdimm",
+	.release = cxl_nvdimm_release,
+	.groups = cxl_nvdimm_attribute_groups,
+};
+
+bool is_cxl_nvdimm(struct device *dev)
+{
+	return dev->type == &cxl_nvdimm_type;
+}
+EXPORT_SYMBOL_GPL(is_cxl_nvdimm);
+
+struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_nvdimm(dev),
+			  "not a cxl_nvdimm device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_nvdimm, dev);
+}
+EXPORT_SYMBOL_GPL(to_cxl_nvdimm);
+
+static struct cxl_nvdimm *cxl_nvdimm_alloc(struct cxl_memdev *cxlmd)
+{
+	struct cxl_nvdimm *cxl_nvd;
+	struct device *dev;
+
+	cxl_nvd = kzalloc(sizeof(*cxl_nvd), GFP_KERNEL);
+	if (!cxl_nvd)
+		return ERR_PTR(-ENOMEM);
+
+	dev = &cxl_nvd->dev;
+	cxl_nvd->cxlmd = cxlmd;
+	device_initialize(dev);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlmd->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_nvdimm_type;
+
+	return cxl_nvd;
+}
+
+int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd)
+{
+	struct cxl_nvdimm *cxl_nvd;
+	struct device *dev;
+	int rc;
+
+	cxl_nvd = cxl_nvdimm_alloc(cxlmd);
+	if (IS_ERR(cxl_nvd))
+		return PTR_ERR(cxl_nvd);
+
+	dev = &cxl_nvd->dev;
+	rc = dev_set_name(dev, "pmem%d", cxlmd->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(host, "%s: register %s\n", dev_name(dev->parent),
+		dev_name(dev));
+
+	return devm_add_action_or_reset(host, unregister_dev, dev);
+
+err:
+	put_device(dev);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(devm_cxl_add_nvdimm);
+
 /**
  * cxl_probe_device_regs() - Detect CXL Device register blocks
  * @dev: Host device of the @base mapping
@@ -929,6 +1013,8 @@ static int cxl_device_id(struct device *dev)
 {
 	if (dev->type == &cxl_nvdimm_bridge_type)
 		return CXL_DEVICE_NVDIMM_BRIDGE;
+	if (dev->type == &cxl_nvdimm_type)
+		return CXL_DEVICE_NVDIMM;
 	return 0;
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5da2163ca45f..b6bda39a59e3 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -220,6 +220,12 @@ struct cxl_nvdimm_bridge {
 	enum cxl_nvdimm_brige_state state;
 };
 
+struct cxl_nvdimm {
+	struct device dev;
+	struct cxl_memdev *cxlmd;
+	struct nvdimm *nvdimm;
+};
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
@@ -306,7 +312,8 @@ int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
 #define cxl_driver_register(x) __cxl_driver_register(x, THIS_MODULE, KBUILD_MODNAME)
 void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 
-#define CXL_DEVICE_NVDIMM_BRIDGE 1
+#define CXL_DEVICE_NVDIMM_BRIDGE	1
+#define CXL_DEVICE_NVDIMM		2
 
 #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
 #define CXL_MODALIAS_FMT "cxl:t%d"
@@ -314,4 +321,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 struct cxl_nvdimm_bridge *to_cxl_nvdimm_bridge(struct device *dev);
 struct cxl_nvdimm_bridge *devm_cxl_add_nvdimm_bridge(struct device *host,
 						     struct cxl_port *port);
+struct cxl_nvdimm *to_cxl_nvdimm(struct device *dev);
+bool is_cxl_nvdimm(struct device *dev);
+int devm_cxl_add_nvdimm(struct device *host, struct cxl_memdev *cxlmd);
 #endif /* __CXL_H__ */
diff --git a/drivers/cxl/mem.h b/drivers/cxl/mem.h
index 13868ff7cadf..7ac7a1767790 100644
--- a/drivers/cxl/mem.h
+++ b/drivers/cxl/mem.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020-2021 Intel Corporation. */
 #ifndef __CXL_MEM_H__
 #define __CXL_MEM_H__
+#include "cxl.h"
 
 /* CXL 2.0 8.2.8.5.1.1 Memory Device Status Register */
 #define CXLMDEV_STATUS_OFFSET 0x0
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index a8f29ce35c2a..f8408e5f0754 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1332,7 +1332,8 @@ static struct cxl_memdev *cxl_memdev_alloc(struct cxl_mem *cxlm)
 	return ERR_PTR(rc);
 }
 
-static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
+static struct cxl_memdev *devm_cxl_add_memdev(struct device *host,
+					      struct cxl_mem *cxlm)
 {
 	struct cxl_memdev *cxlmd;
 	struct device *dev;
@@ -1341,7 +1342,7 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
 
 	cxlmd = cxl_memdev_alloc(cxlm);
 	if (IS_ERR(cxlmd))
-		return PTR_ERR(cxlmd);
+		return cxlmd;
 
 	dev = &cxlmd->dev;
 	rc = dev_set_name(dev, "mem%d", cxlmd->id);
@@ -1359,8 +1360,10 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
 	if (rc)
 		goto err;
 
-	return devm_add_action_or_reset(dev->parent, cxl_memdev_unregister,
-					cxlmd);
+	rc = devm_add_action_or_reset(host, cxl_memdev_unregister, cxlmd);
+	if (rc)
+		return ERR_PTR(rc);
+	return cxlmd;
 
 err:
 	/*
@@ -1369,7 +1372,7 @@ static int cxl_mem_add_memdev(struct cxl_mem *cxlm)
 	 */
 	cxl_memdev_shutdown(cxlmd);
 	put_device(dev);
-	return rc;
+	return ERR_PTR(rc);
 }
 
 static int cxl_xfer_log(struct cxl_mem *cxlm, uuid_t *uuid, u32 size, u8 *out)
@@ -1580,6 +1583,7 @@ static int cxl_mem_identify(struct cxl_mem *cxlm)
 
 static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	struct cxl_memdev *cxlmd;
 	struct cxl_mem *cxlm;
 	int rc;
 
@@ -1607,7 +1611,14 @@ static int cxl_mem_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	return cxl_mem_add_memdev(cxlm);
+	cxlmd = devm_cxl_add_memdev(&pdev->dev, cxlm);
+	if (IS_ERR(cxlmd))
+		return PTR_ERR(cxlmd);
+
+	if (range_len(&cxlm->pmem_range) && IS_ENABLED(CONFIG_CXL_PMEM))
+		rc = devm_cxl_add_nvdimm(&pdev->dev, cxlmd);
+
+	return rc;
 }
 
 static const struct pci_device_id cxl_mem_pci_tbl[] = {
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 8365839856dc..0088e41dd2f3 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -3,7 +3,10 @@
 #include <linux/libnvdimm.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/ndctl.h>
+#include <linux/async.h>
 #include <linux/slab.h>
+#include "mem.h"
 #include "cxl.h"
 
 /*
@@ -13,6 +16,62 @@
  */
 static struct workqueue_struct *cxl_pmem_wq;
 
+static void unregister_nvdimm(void *nvdimm)
+{
+	nvdimm_delete(nvdimm);
+}
+
+static int match_nvdimm_bridge(struct device *dev, const void *data)
+{
+	return strcmp(dev_name(dev), "nvdimm-bridge") == 0;
+}
+
+static struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(void)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&cxl_bus_type, NULL, NULL, match_nvdimm_bridge);
+	if (!dev)
+		return NULL;
+	return to_cxl_nvdimm_bridge(dev);
+}
+
+static int cxl_nvdimm_probe(struct device *dev)
+{
+	struct cxl_nvdimm *cxl_nvd = to_cxl_nvdimm(dev);
+	struct cxl_nvdimm_bridge *cxl_nvb;
+	unsigned long flags = 0;
+	struct nvdimm *nvdimm;
+	int rc = -ENXIO;
+
+	cxl_nvb = cxl_find_nvdimm_bridge();
+	if (!cxl_nvb)
+		return -ENXIO;
+
+	device_lock(&cxl_nvb->dev);
+	if (!cxl_nvb->nvdimm_bus)
+		goto out;
+
+	set_bit(NDD_LABELING, &flags);
+	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags, 0, 0,
+			       NULL);
+	if (!nvdimm)
+		goto out;
+
+	rc = devm_add_action_or_reset(dev, unregister_nvdimm, nvdimm);
+out:
+	device_unlock(&cxl_nvb->dev);
+	put_device(&cxl_nvb->dev);
+
+	return rc;
+}
+
+static struct cxl_driver cxl_nvdimm_driver = {
+	.name = "cxl_nvdimm",
+	.probe = cxl_nvdimm_probe,
+	.id = CXL_DEVICE_NVDIMM,
+};
+
 static int cxl_pmem_ctl(struct nvdimm_bus_descriptor *nd_desc,
 			struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 			unsigned int buf_len, int *cmd_rc)
@@ -29,19 +88,34 @@ static bool online_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
 	return cxl_nvb->nvdimm_bus != NULL;
 }
 
-static void offline_nvdimm_bus(struct cxl_nvdimm_bridge *cxl_nvb)
+static int cxl_nvdimm_release_driver(struct device *dev, void *data)
 {
-	if (!cxl_nvb->nvdimm_bus)
+	if (!is_cxl_nvdimm(dev))
+		return 0;
+	device_release_driver(dev);
+	return 0;
+}
+
+static void offline_nvdimm_bus(struct nvdimm_bus *nvdimm_bus)
+{
+	if (!nvdimm_bus)
 		return;
-	nvdimm_bus_unregister(cxl_nvb->nvdimm_bus);
-	cxl_nvb->nvdimm_bus = NULL;
+
+	/*
+	 * Set the state of cxl_nvdimm devices to unbound / idle before
+	 * nvdimm_bus_unregister() rips the nvdimm objects out from
+	 * underneath them.
+	 */
+	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_nvdimm_release_driver);
+	nvdimm_bus_unregister(nvdimm_bus);
 }
 
 static void cxl_nvb_update_state(struct work_struct *work)
 {
 	struct cxl_nvdimm_bridge *cxl_nvb =
 		container_of(work, typeof(*cxl_nvb), state_work);
-	bool release = false;
+	struct nvdimm_bus *victim_bus = NULL;
+	bool release = false, rescan = false;
 
 	device_lock(&cxl_nvb->dev);
 	switch (cxl_nvb->state) {
@@ -50,11 +124,13 @@ static void cxl_nvb_update_state(struct work_struct *work)
 			dev_err(&cxl_nvb->dev,
 				"failed to establish nvdimm bus\n");
 			release = true;
-		}
+		} else
+			rescan = true;
 		break;
 	case CXL_NVB_OFFLINE:
 	case CXL_NVB_DEAD:
-		offline_nvdimm_bus(cxl_nvb);
+		victim_bus = cxl_nvb->nvdimm_bus;
+		cxl_nvb->nvdimm_bus = NULL;
 		break;
 	default:
 		break;
@@ -63,6 +139,12 @@ static void cxl_nvb_update_state(struct work_struct *work)
 
 	if (release)
 		device_release_driver(&cxl_nvb->dev);
+	if (rescan) {
+		int rc = bus_rescan_devices(&cxl_bus_type);
+
+		dev_dbg(&cxl_nvb->dev, "rescan: %d\n", rc);
+	}
+	offline_nvdimm_bus(victim_bus);
 
 	put_device(&cxl_nvb->dev);
 }
@@ -118,17 +200,24 @@ static __init int cxl_pmem_init(void)
 
 	rc = cxl_driver_register(&cxl_nvdimm_bridge_driver);
 	if (rc)
-		goto err;
+		goto err_bridge;
+
+	rc = cxl_driver_register(&cxl_nvdimm_driver);
+	if (rc)
+		goto err_nvdimm;
 
 	return 0;
 
-err:
+err_nvdimm:
+	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
+err_bridge:
 	destroy_workqueue(cxl_pmem_wq);
 	return rc;
 }
 
 static __exit void cxl_pmem_exit(void)
 {
+	cxl_driver_unregister(&cxl_nvdimm_driver);
 	cxl_driver_unregister(&cxl_nvdimm_bridge_driver);
 	destroy_workqueue(cxl_pmem_wq);
 }
@@ -138,3 +227,4 @@ module_init(cxl_pmem_init);
 module_exit(cxl_pmem_exit);
 MODULE_IMPORT_NS(CXL);
 MODULE_ALIAS_CXL(CXL_DEVICE_NVDIMM_BRIDGE);
+MODULE_ALIAS_CXL(CXL_DEVICE_NVDIMM);

