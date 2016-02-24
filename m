Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 4/8] nfit,
 tools/testing/nvdimm: unify common init for acpi_nfit_desc
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:17:19 -0800
Message-ID: <20160224021719.22776.38487.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The nvdimm unit test infrastructure performs its own initialization of
an acpi_nfit_desc to specify test overrides over the native
implementation.  Make it clear which attributes and operations it is
overriding by re-using acpi_nfit_init_desc() as a common starting point.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c              |   44 ++++++++++++++------------------------
 drivers/acpi/nfit.h              |    2 +-
 tools/testing/nvdimm/test/nfit.c |   22 +++----------------
 3 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index 4dd2b6808df5..76c9444c9c60 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -748,12 +748,11 @@ static struct attribute_group acpi_nfit_attribute_group = {
 	.attrs = acpi_nfit_attributes,
 };
 
-const struct attribute_group *acpi_nfit_attribute_groups[] = {
+static const struct attribute_group *acpi_nfit_attribute_groups[] = {
 	&nvdimm_bus_attribute_group,
 	&acpi_nfit_attribute_group,
 	NULL,
 };
-EXPORT_SYMBOL_GPL(acpi_nfit_attribute_groups);
 
 static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
 {
@@ -1962,15 +1961,9 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, acpi_size sz)
 }
 EXPORT_SYMBOL_GPL(acpi_nfit_init);
 
-static struct acpi_nfit_desc *acpi_nfit_desc_init(struct acpi_device *adev)
+void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
 {
 	struct nvdimm_bus_descriptor *nd_desc;
-	struct acpi_nfit_desc *acpi_desc;
-	struct device *dev = &adev->dev;
-
-	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
-	if (!acpi_desc)
-		return ERR_PTR(-ENOMEM);
 
 	dev_set_drvdata(dev, acpi_desc);
 	acpi_desc->dev = dev;
@@ -1980,12 +1973,6 @@ static struct acpi_nfit_desc *acpi_nfit_desc_init(struct acpi_device *adev)
 	nd_desc->ndctl = acpi_nfit_ctl;
 	nd_desc->attr_groups = acpi_nfit_attribute_groups;
 
-	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, nd_desc);
-	if (!acpi_desc->nvdimm_bus) {
-		devm_kfree(dev, acpi_desc);
-		return ERR_PTR(-ENXIO);
-	}
-
 	INIT_LIST_HEAD(&acpi_desc->spa_maps);
 	INIT_LIST_HEAD(&acpi_desc->spas);
 	INIT_LIST_HEAD(&acpi_desc->dcrs);
@@ -1996,9 +1983,8 @@ static struct acpi_nfit_desc *acpi_nfit_desc_init(struct acpi_device *adev)
 	INIT_LIST_HEAD(&acpi_desc->dimms);
 	mutex_init(&acpi_desc->spa_map_mutex);
 	mutex_init(&acpi_desc->init_mutex);
-
-	return acpi_desc;
 }
+EXPORT_SYMBOL_GPL(acpi_nfit_desc_init);
 
 static int acpi_nfit_add(struct acpi_device *adev)
 {
@@ -2017,12 +2003,13 @@ static int acpi_nfit_add(struct acpi_device *adev)
 		return 0;
 	}
 
-	acpi_desc = acpi_nfit_desc_init(adev);
-	if (IS_ERR(acpi_desc)) {
-		dev_err(dev, "%s: error initializing acpi_desc: %ld\n",
-				__func__, PTR_ERR(acpi_desc));
-		return PTR_ERR(acpi_desc);
-	}
+	acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
+	if (!acpi_desc)
+		return -ENOMEM;
+	acpi_nfit_desc_init(acpi_desc, &adev->dev);
+	acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
+	if (!acpi_desc->nvdimm_bus)
+		return -ENOMEM;
 
 	/*
 	 * Save the acpi header for later and then skip it,
@@ -2085,12 +2072,13 @@ static void acpi_nfit_notify(struct acpi_device *adev, u32 event)
 	}
 
 	if (!acpi_desc) {
-		acpi_desc = acpi_nfit_desc_init(adev);
-		if (IS_ERR(acpi_desc)) {
-			dev_err(dev, "%s: error initializing acpi_desc: %ld\n",
-				__func__, PTR_ERR(acpi_desc));
+		acpi_desc = devm_kzalloc(dev, sizeof(*acpi_desc), GFP_KERNEL);
+		if (!acpi_desc)
+			goto out_unlock;
+		acpi_nfit_desc_init(acpi_desc, &adev->dev);
+		acpi_desc->nvdimm_bus = nvdimm_bus_register(dev, &acpi_desc->nd_desc);
+		if (!acpi_desc->nvdimm_bus)
 			goto out_unlock;
-		}
 	}
 
 	/* Evaluate _FIT */
diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h
index f45b7d9b1d9e..524dec0a3adb 100644
--- a/drivers/acpi/nfit.h
+++ b/drivers/acpi/nfit.h
@@ -195,5 +195,5 @@ static inline struct acpi_nfit_desc *to_acpi_desc(
 
 const u8 *to_nfit_uuid(enum nfit_uuids id);
 int acpi_nfit_init(struct acpi_nfit_desc *nfit, acpi_size sz);
-extern const struct attribute_group *acpi_nfit_attribute_groups[];
+void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
 #endif /* __NFIT_H__ */
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 9ead77970546..a66842e61bbc 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -499,7 +499,6 @@ static int nfit_test1_alloc(struct nfit_test *t)
 
 static void nfit_test0_setup(struct nfit_test *t)
 {
-	struct nvdimm_bus_descriptor *nd_desc;
 	struct acpi_nfit_desc *acpi_desc;
 	struct acpi_nfit_memory_map *memdev;
 	void *nfit_buf = t->nfit_buf;
@@ -1165,8 +1164,6 @@ static void nfit_test0_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
-	nd_desc = &acpi_desc->nd_desc;
-	nd_desc->ndctl = nfit_test_ctl;
 }
 
 static void nfit_test1_setup(struct nfit_test *t)
@@ -1176,7 +1173,6 @@ static void nfit_test1_setup(struct nfit_test *t)
 	struct acpi_nfit_memory_map *memdev;
 	struct acpi_nfit_control_region *dcr;
 	struct acpi_nfit_system_address *spa;
-	struct nvdimm_bus_descriptor *nd_desc;
 	struct acpi_nfit_desc *acpi_desc;
 
 	offset = 0;
@@ -1226,8 +1222,6 @@ static void nfit_test1_setup(struct nfit_test *t)
 	set_bit(ND_CMD_ARS_CAP, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_START, &acpi_desc->bus_dsm_force_en);
 	set_bit(ND_CMD_ARS_STATUS, &acpi_desc->bus_dsm_force_en);
-	nd_desc = &acpi_desc->nd_desc;
-	nd_desc->ndctl = nfit_test_ctl;
 }
 
 static int nfit_test_blk_do_io(struct nd_blk_region *ndbr, resource_size_t dpa,
@@ -1310,26 +1304,16 @@ static int nfit_test_probe(struct platform_device *pdev)
 
 	nfit_test->setup(nfit_test);
 	acpi_desc = &nfit_test->acpi_desc;
-	acpi_desc->dev = &pdev->dev;
+	acpi_nfit_desc_init(acpi_desc, &pdev->dev);
 	acpi_desc->nfit = nfit_test->nfit_buf;
 	acpi_desc->blk_do_io = nfit_test_blk_do_io;
 	nd_desc = &acpi_desc->nd_desc;
-	nd_desc->attr_groups = acpi_nfit_attribute_groups;
+	nd_desc->provider_name = NULL;
+	nd_desc->ndctl = nfit_test_ctl;
 	acpi_desc->nvdimm_bus = nvdimm_bus_register(&pdev->dev, nd_desc);
 	if (!acpi_desc->nvdimm_bus)
 		return -ENXIO;
 
-	INIT_LIST_HEAD(&acpi_desc->spa_maps);
-	INIT_LIST_HEAD(&acpi_desc->spas);
-	INIT_LIST_HEAD(&acpi_desc->dcrs);
-	INIT_LIST_HEAD(&acpi_desc->bdws);
-	INIT_LIST_HEAD(&acpi_desc->idts);
-	INIT_LIST_HEAD(&acpi_desc->flushes);
-	INIT_LIST_HEAD(&acpi_desc->memdevs);
-	INIT_LIST_HEAD(&acpi_desc->dimms);
-	mutex_init(&acpi_desc->spa_map_mutex);
-	mutex_init(&acpi_desc->init_mutex);
-
 	rc = acpi_nfit_init(acpi_desc, nfit_test->nfit_size);
 	if (rc) {
 		nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
