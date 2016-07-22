Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id EAE321A1E45
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 20:28:48 -0700 (PDT)
Subject: [PATCH 1/2] libnvdimm: move ->module to struct nvdimm_bus_descriptor
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Jul 2016 20:25:44 -0700
Message-ID: <146915794457.7201.5023729229431647060.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Let the provider module be explicitly passed in rather than implicitly
assumed by the module that calls nvdimm_bus_register().  This is in
preparation for unifying the nfit and nfit_test driver teardown paths.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |    1 +
 drivers/nvdimm/bus.c             |    2 +-
 drivers/nvdimm/core.c            |    7 +++----
 drivers/nvdimm/e820.c            |    1 +
 drivers/nvdimm/nd-core.h         |    1 -
 include/linux/libnvdimm.h        |    7 +++----
 tools/testing/nvdimm/test/nfit.c |    1 +
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fb80f32db525..e7eb3b6f1514 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -2417,6 +2417,7 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 	acpi_desc->blk_do_io = acpi_nfit_blk_region_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = "ACPI.NFIT";
+	nd_desc->module = THIS_MODULE;
 	nd_desc->ndctl = acpi_nfit_ctl;
 	nd_desc->flush_probe = acpi_nfit_flush_probe;
 	nd_desc->clear_to_send = acpi_nfit_clear_to_send;
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 1cc7880320fe..275dd5c0a301 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -73,7 +73,7 @@ static struct module *to_bus_provider(struct device *dev)
 	if (is_nd_pmem(dev) || is_nd_blk(dev)) {
 		struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 
-		return nvdimm_bus->module;
+		return nvdimm_bus->nd_desc->module;
 	}
 	return NULL;
 }
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 757e0cf028bf..e8528756f54f 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -447,8 +447,8 @@ struct attribute_group nvdimm_bus_attribute_group = {
 };
 EXPORT_SYMBOL_GPL(nvdimm_bus_attribute_group);
 
-struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
-		struct nvdimm_bus_descriptor *nd_desc, struct module *module)
+struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
+		struct nvdimm_bus_descriptor *nd_desc)
 {
 	struct nvdimm_bus *nvdimm_bus;
 	int rc;
@@ -467,7 +467,6 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 		return NULL;
 	}
 	nvdimm_bus->nd_desc = nd_desc;
-	nvdimm_bus->module = module;
 	nvdimm_bus->dev.parent = parent;
 	nvdimm_bus->dev.release = nvdimm_bus_release;
 	nvdimm_bus->dev.groups = nd_desc->attr_groups;
@@ -491,7 +490,7 @@ struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
 	put_device(&nvdimm_bus->dev);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__nvdimm_bus_register);
+EXPORT_SYMBOL_GPL(nvdimm_bus_register);
 
 static void set_badblock(struct badblocks *bb, sector_t s, int num)
 {
diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
index 95825b38559a..11ea90120542 100644
--- a/drivers/nvdimm/e820.c
+++ b/drivers/nvdimm/e820.c
@@ -47,6 +47,7 @@ static int e820_pmem_probe(struct platform_device *pdev)
 
 	nd_desc.attr_groups = e820_pmem_attribute_groups;
 	nd_desc.provider_name = "e820";
+	nd_desc.module = THIS_MODULE;
 	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
 	if (!nvdimm_bus)
 		goto err;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 6e961f7f43e7..38ce6bbbc170 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -26,7 +26,6 @@ extern int nvdimm_major;
 struct nvdimm_bus {
 	struct nvdimm_bus_descriptor *nd_desc;
 	wait_queue_head_t probe_wait;
-	struct module *module;
 	struct list_head list;
 	struct device dev;
 	int id, probe_active;
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d37fda6dd64c..2ab869dece4a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -70,6 +70,7 @@ struct nd_mapping {
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long cmd_mask;
+	struct module *module;
 	char *provider_name;
 	ndctl_fn ndctl;
 	int (*flush_probe)(struct nvdimm_bus_descriptor *nd_desc);
@@ -128,10 +129,8 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 }
 
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
-struct nvdimm_bus *__nvdimm_bus_register(struct device *parent,
-		struct nvdimm_bus_descriptor *nfit_desc, struct module *module);
-#define nvdimm_bus_register(parent, desc) \
-	__nvdimm_bus_register(parent, desc, THIS_MODULE)
+struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
+		struct nvdimm_bus_descriptor *nfit_desc);
 void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
 struct nvdimm *to_nvdimm(struct device *dev);
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 78cba1e3b1da..642713f15723 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1463,6 +1463,7 @@ static int nfit_test_probe(struct platform_device *pdev)
 	acpi_desc->blk_do_io = nfit_test_blk_do_io;
 	nd_desc = &acpi_desc->nd_desc;
 	nd_desc->provider_name = NULL;
+	nd_desc->module = THIS_MODULE;
 	nd_desc->ndctl = nfit_test_ctl;
 	acpi_desc->nvdimm_bus = nvdimm_bus_register(&pdev->dev, nd_desc);
 	if (!acpi_desc->nvdimm_bus)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
