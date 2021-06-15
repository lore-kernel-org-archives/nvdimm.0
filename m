Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00366D12
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 23:18:12 +0000 (UTC)
IronPort-SDR: MboTBGgbgi1+DV8Qq6DKCZcyG7zO0/e5hOJDLF1dV/UaA9R2/xtgPpRmRQtZlMdvoekIWTDVgo
 A52a1kpM79aA==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="205901581"
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="205901581"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:12 -0700
IronPort-SDR: elHlbj/JjWZmywhOk/1xJayrk9q031ggwxbHUgsozSzm3XG1LJzIo5uWfl6OmAwjiUK50OwmuV
 BSvwhFq4OtvA==
X-IronPort-AV: E=Sophos;i="5.83,276,1616482800"; 
   d="scan'208";a="450414384"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2021 16:18:12 -0700
Subject: [PATCH v2 1/5] cxl/core: Add cxl-bus driver infrastructure
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Date: Tue, 15 Jun 2021 16:18:11 -0700
Message-ID: <162379909190.2993820.6134168109678004186.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Enable devices on the 'cxl' bus to be attached to drivers. The initial
user of this functionality is a driver for an 'nvdimm-bridge' device
that anchors a libnvdimm hierarchy attached to CXL persistent memory
resources. Other device types that will leverage this include:

cxl_port: map and use component register functionality (HDM Decoders)

cxl_nvdimm: translate CXL memory expander endpoints to libnvdimm
	    'nvdimm' objects

cxl_region: translate CXL interleave sets to libnvdimm 'region' objects

The pairing of devices to drivers is handled through the cxl_device_id()
matching to cxl_driver.id values. A cxl_device_id() of '0' indicates no
driver support.

In addition to ->match(), ->probe(), and ->remove() support for the
'cxl' bus introduce MODULE_ALIAS_CXL() to autoload modules containing
cxl-drivers. Drivers are added in follow-on changes.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/162336396329.2462439.16556923116284874437.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/core.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h  |   22 ++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/cxl/core.c b/drivers/cxl/core.c
index c613dc795498..68d6afea363b 100644
--- a/drivers/cxl/core.c
+++ b/drivers/cxl/core.c
@@ -767,8 +767,81 @@ int cxl_map_device_regs(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL_GPL(cxl_map_device_regs);
 
+/**
+ * __cxl_driver_register - register a driver for the cxl bus
+ * @cxl_drv: cxl driver structure to attach
+ * @owner: owning module/driver
+ * @modname: KBUILD_MODNAME for parent driver
+ */
+int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
+			  const char *modname)
+{
+	if (!cxl_drv->probe) {
+		pr_debug("%s ->probe() must be specified\n", modname);
+		return -EINVAL;
+	}
+
+	if (!cxl_drv->name) {
+		pr_debug("%s ->name must be specified\n", modname);
+		return -EINVAL;
+	}
+
+	if (!cxl_drv->id) {
+		pr_debug("%s ->id must be specified\n", modname);
+		return -EINVAL;
+	}
+
+	cxl_drv->drv.bus = &cxl_bus_type;
+	cxl_drv->drv.owner = owner;
+	cxl_drv->drv.mod_name = modname;
+	cxl_drv->drv.name = cxl_drv->name;
+
+	return driver_register(&cxl_drv->drv);
+}
+EXPORT_SYMBOL_GPL(__cxl_driver_register);
+
+void cxl_driver_unregister(struct cxl_driver *cxl_drv)
+{
+	driver_unregister(&cxl_drv->drv);
+}
+EXPORT_SYMBOL_GPL(cxl_driver_unregister);
+
+static int cxl_device_id(struct device *dev)
+{
+	return 0;
+}
+
+static int cxl_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	return add_uevent_var(env, "MODALIAS=" CXL_MODALIAS_FMT,
+			      cxl_device_id(dev));
+}
+
+static int cxl_bus_match(struct device *dev, struct device_driver *drv)
+{
+	return cxl_device_id(dev) == to_cxl_drv(drv)->id;
+}
+
+static int cxl_bus_probe(struct device *dev)
+{
+	return to_cxl_drv(dev->driver)->probe(dev);
+}
+
+static int cxl_bus_remove(struct device *dev)
+{
+	struct cxl_driver *cxl_drv = to_cxl_drv(dev->driver);
+
+	if (cxl_drv->remove)
+		cxl_drv->remove(dev);
+	return 0;
+}
+
 struct bus_type cxl_bus_type = {
 	.name = "cxl",
+	.uevent = cxl_bus_uevent,
+	.match = cxl_bus_match,
+	.probe = cxl_bus_probe,
+	.remove = cxl_bus_remove,
 };
 EXPORT_SYMBOL_GPL(cxl_bus_type);
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 97a273ae3947..a6f8e7097ea2 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -268,4 +268,26 @@ devm_cxl_add_passthrough_decoder(struct device *host, struct cxl_port *port)
 }
 
 extern struct bus_type cxl_bus_type;
+
+struct cxl_driver {
+	const char *name;
+	int (*probe)(struct device *dev);
+	void (*remove)(struct device *dev);
+	struct device_driver drv;
+	int id;
+};
+
+static inline struct cxl_driver *to_cxl_drv(struct device_driver *drv)
+{
+	return container_of(drv, struct cxl_driver, drv);
+}
+
+int __cxl_driver_register(struct cxl_driver *cxl_drv, struct module *owner,
+			  const char *modname);
+#define cxl_driver_register(x) __cxl_driver_register(x, THIS_MODULE, KBUILD_MODNAME)
+void cxl_driver_unregister(struct cxl_driver *cxl_drv);
+
+#define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
+#define CXL_MODALIAS_FMT "cxl:t%d"
+
 #endif /* __CXL_H__ */

